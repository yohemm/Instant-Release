param(
  [switch]$SyncOnly,
  [switch]$ArchiveDuplicates,
  [switch]$DeleteDuplicates,
  [switch]$DeleteImportedIssues,
  [switch]$DeleteAllIssues,
  [switch]$ResetProjectItems
)

$Org = "yohemm"
$ProjectTitle = "Instant-Release-Project"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkipInaccessibleRepos = $true
$GitHubHost = "github.com"

$RepoMap = @{
  "instant-release_API"      = "$Org/instant-release_API"
  "instant-release_APP"      = "$Org/instant-release_APP"
  "instant-release_VITRINE"  = "$Org/instant-release_VITRINE"
  "instant-release_ACTIONS"  = "$Org/instant-release_ACTIONS"
}

function Resolve-CsvPath($FileName) {
  $candidates = @(
    (Join-Path $ScriptDir ("docs\\github_project_csv\\" + $FileName)),
    (Join-Path $ScriptDir ("docs\\" + $FileName)),
    (Join-Path $ScriptDir ("github_project_csv\\" + $FileName)),
    (Join-Path $ScriptDir $FileName),
    (Join-Path $ScriptDir ("..\\github_project_csv\\" + $FileName)),
    (Join-Path $ScriptDir ("..\\docs\\github_project_csv\\" + $FileName)),
    (Join-Path $ScriptDir ("..\\docs\\" + $FileName))
  )
  foreach ($path in $candidates) {
    if (Test-Path $path) { return (Resolve-Path $path).Path }
  }
  throw "CSV introuvable: $FileName"
}

function Get-ImportCsvPaths() {
  return @(
    (Resolve-CsvPath -FileName "GITHUB_PROJECT_EPICS_IMPORT.csv"),
    (Resolve-CsvPath -FileName "GITHUB_PROJECT_FEATURES_IMPORT.csv"),
    (Resolve-CsvPath -FileName "GITHUB_PROJECT_REQUIREMENTS_IMPORT.csv"),
    (Resolve-CsvPath -FileName "GITHUB_PROJECT_DOCUMENTATION_IMPORT.csv")
  )
}

function Invoke-GhGraphQL($Query, $Variables) {
  function Test-RetryableGhError($text) {
    if ([string]::IsNullOrWhiteSpace($text)) { return $false }
    return ($text -match "HTTP 502" -or
            $text -match "HTTP 503" -or
            $text -match "HTTP 504" -or
            $text -match "timed out" -or
            $text -match "connection reset" -or
            $text -match "Bad Gateway")
  }

  $maxAttempts = 4
  $lastErr = $null

  for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
    $args = @("api", "graphql", "-f", "query=$Query")
    foreach ($k in $Variables.Keys) {
      $v = $Variables[$k]
      if ($null -eq $v) {
        $args += @("-F", "$k=null")
        continue
      }

      if ($v -is [bool]) {
        $args += @("-F", "$k=$($v.ToString().ToLower())")
        continue
      }

      if ($v -is [int] -or $v -is [long] -or $v -is [double] -or $v -is [decimal]) {
        $args += @("-F", "$k=$v")
        continue
      }

      $args += @("-f", "$k=$v")
    }

    $raw = & gh @args 2>&1
    if ($LASTEXITCODE -ne 0) {
      $lastErr = "$raw"
      if ((Test-RetryableGhError -text $lastErr) -and $attempt -lt $maxAttempts) {
        Start-Sleep -Seconds ([Math]::Pow(2, $attempt - 1))
        continue
      }
      $shortErr = $lastErr
      if ($shortErr.Length -gt 500) { $shortErr = $shortErr.Substring(0, 500) + "...(truncated)" }
      throw "GraphQL error: $shortErr"
    }

    try {
      $obj = $raw | ConvertFrom-Json
    }
    catch {
      $lastErr = "$raw"
      if ((Test-RetryableGhError -text $lastErr) -and $attempt -lt $maxAttempts) {
        Start-Sleep -Seconds ([Math]::Pow(2, $attempt - 1))
        continue
      }
      $shortErr = $lastErr
      if ($shortErr.Length -gt 500) { $shortErr = $shortErr.Substring(0, 500) + "...(truncated)" }
      throw "GraphQL parse error: $shortErr"
    }

    if ($null -ne $obj.errors) {
      $errs = ($obj.errors | ConvertTo-Json -Depth 10 -Compress)
      if ((Test-RetryableGhError -text $errs) -and $attempt -lt $maxAttempts) {
        Start-Sleep -Seconds ([Math]::Pow(2, $attempt - 1))
        continue
      }
      throw ("GraphQL returned errors: " + $errs)
    }

    return $obj.data
  }

  throw "GraphQL error apres retries: $lastErr"
}

function Assert-GhAuth() {
  gh auth status --hostname $GitHubHost *> $null
  if ($LASTEXITCODE -ne 0) {
    throw "Auth gh invalide. Execute: gh auth login --hostname $GitHubHost puis gh auth refresh -s repo -s project"
  }

  $token = gh auth token --hostname $GitHubHost 2>$null
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($token)) {
    throw "Token gh indisponible. Execute: gh auth refresh -s repo -s project"
  }
}

function Test-RepoAccess($Repo) {
  gh repo view $Repo *> $null
  return ($LASTEXITCODE -eq 0)
}

function Test-RepoPushAccess($Repo) {
  $canPush = gh api "repos/$Repo" --jq ".permissions.push" 2>&1
  return ($LASTEXITCODE -eq 0 -and "$canPush".Trim().ToLower() -eq "true")
}

function Get-AccessibleRepoMap($InputMap) {
  $active = @{}
  foreach ($key in $InputMap.Keys) {
    $repo = $InputMap[$key]
    $viewOk = Test-RepoAccess -Repo $repo
    $pushOk = Test-RepoPushAccess -Repo $repo

    if ($viewOk -and $pushOk) {
      $active[$key] = $repo
      continue
    }

    $permJson = gh api "repos/$repo" --jq ".permissions" 2>&1
    $permInfo = if ($LASTEXITCODE -eq 0) { $permJson } else { "permissions indisponibles" }

    if ($SkipInaccessibleRepos) {
      Write-Warning "Repo inaccessible (ou sans droit push), skipped: $repo | view=$viewOk push=$pushOk | $permInfo"
      continue
    }
    throw "Repo inaccessible: $repo. Verifie les droits et l'auth gh."
  }
  return $active
}

function Get-ExistingLabels($Repo) {
  $existing = @{}
  $raw = gh api "repos/$Repo/labels?per_page=100" --paginate --jq ".[].name" 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Impossible de lister les labels pour $Repo. Detail: $raw"
  }
  $raw -split "`n" | ForEach-Object {
    $name = $_.Trim()
    if ($name) { $existing[$name] = $true }
  }
  return $existing
}

function Ensure-Label($Repo, $Existing, $Name, $Color, $Description) {
  if ($Existing.ContainsKey($Name)) { return }
  gh label create $Name --repo $Repo --color $Color --description $Description | Out-Null
  if ($LASTEXITCODE -ne 0) {
    throw "Echec creation label '$Name' sur $Repo"
  }
  $Existing[$Name] = $true
}

function Ensure-StandardLabels($RepoMapToUse) {
  $LabelCatalog = @(
    @{ Name = "type/epic";         Color = "5319E7"; Desc = "Epic work item" },
    @{ Name = "type/feature";      Color = "1D76DB"; Desc = "Feature work item" },
    @{ Name = "type/requirement";  Color = "0E8A16"; Desc = "Requirement work item" },
    @{ Name = "type/documentation";Color = "0075CA"; Desc = "Documentation work item" },
    @{ Name = "type/task";         Color = "5319E7"; Desc = "Task work item" },
    @{ Name = "type/bug";          Color = "D73A4A"; Desc = "Bug work item" },
    @{ Name = "type/incident";     Color = "B60205"; Desc = "Incident work item" },
    @{ Name = "type/risk";         Color = "E99695"; Desc = "Risk work item" },
    @{ Name = "type/doc";          Color = "0075CA"; Desc = "Documentation work item" },
    @{ Name = "area/devops";       Color = "0052CC"; Desc = "DevOps area" },
    @{ Name = "area/web";          Color = "0366D6"; Desc = "Web area" },
    @{ Name = "area/api";          Color = "1D76DB"; Desc = "API area" },
    @{ Name = "area/ux";           Color = "C2E0C6"; Desc = "UX/UI area" },
    @{ Name = "area/marketing";    Color = "FBCA04"; Desc = "Marketing area" },
    @{ Name = "area/docs";         Color = "BFDADC"; Desc = "Docs area" },
    @{ Name = "class/expedite";    Color = "B60205"; Desc = "Class Expedite" },
    @{ Name = "class/fixed-date";  Color = "D93F0B"; Desc = "Class Fixed Date" },
    @{ Name = "class/standard";    Color = "0E8A16"; Desc = "Class Standard" },
    @{ Name = "class/intangible";  Color = "5319E7"; Desc = "Class Intangible" },
    @{ Name = "priority/p0";       Color = "B60205"; Desc = "Highest priority" },
    @{ Name = "priority/p1";       Color = "D93F0B"; Desc = "High priority" },
    @{ Name = "priority/p2";       Color = "FBCA04"; Desc = "Medium priority" },
    @{ Name = "priority/p3";       Color = "0E8A16"; Desc = "Low priority" },
    @{ Name = "status/blocked";    Color = "000000"; Desc = "Blocked item" }
  )

  foreach ($repo in $RepoMapToUse.Values) {
    Write-Host "Sync labels for $repo"
    $existing = Get-ExistingLabels -Repo $repo
    foreach ($label in $LabelCatalog) {
      Ensure-Label -Repo $repo -Existing $existing -Name $label.Name -Color $label.Color -Description $label.Desc
    }
  }
}

function Get-TypeLabelFromType($TypeValue) {
  switch ($TypeValue) {
    "Documentation" { return "type/documentation" }
    "Epic" { return "type/epic" }
    default { return ("type/" + $TypeValue.ToLower()) }
  }
}

$Script:RepoIssueTitleCache = @{}

function Get-RepoIssueTitleSet($Repo) {
  if ($Script:RepoIssueTitleCache.ContainsKey($Repo)) {
    return $Script:RepoIssueTitleCache[$Repo]
  }

  $set = @{}
  $raw = gh issue list --repo $Repo --state all --json title --limit 1000 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Impossible de lister les issues pour $Repo. Detail: $raw"
  }

  $items = $raw | ConvertFrom-Json
  foreach ($it in $items) {
    if (-not [string]::IsNullOrWhiteSpace($it.title)) {
      $set[$it.title] = $true
    }
  }

  $Script:RepoIssueTitleCache[$Repo] = $set
  return $set
}

function Archive-DuplicateIssues($RepoMapToUse) {
  foreach ($repo in $RepoMapToUse.Values) {
    Write-Host "Check duplicates in $repo"
    $raw = gh issue list --repo $repo --state all --json number,title,state,url --limit 1000 2>&1
    if ($LASTEXITCODE -ne 0) {
      Write-Warning "Impossible de lister les issues pour dedupe ($repo): $raw"
      continue
    }

    $issues = $raw | ConvertFrom-Json
    $groups = @{}
    foreach ($it in $issues) {
      if ([string]::IsNullOrWhiteSpace($it.title)) { continue }
      if (-not $groups.ContainsKey($it.title)) { $groups[$it.title] = @() }
      $groups[$it.title] += $it
    }

    foreach ($title in $groups.Keys) {
      $arr = @($groups[$title] | Sort-Object number)
      if ($arr.Count -le 1) { continue }

      $keep = $arr[0]
      $dups = @($arr | Select-Object -Skip 1 | Sort-Object number -Descending)
      foreach ($dup in $dups) {
        Write-Host "Archive duplicate: $repo #$($dup.number) (keep #$($keep.number)) | $title"
        gh issue comment $dup.number --repo $repo --body "Archived as duplicate of #$($keep.number) by setup cleanup." | Out-Null
        gh issue close $dup.number --repo $repo --reason "not planned" | Out-Null
      }
    }
  }
}

function Get-IssueNodeId($Repo, $Number) {
  $parts = $Repo.Split("/")
  if ($parts.Count -ne 2) { throw "Repo invalide: $Repo" }
  $owner = $parts[0]
  $name = $parts[1]

  $query = @'
query($owner:String!, $name:String!, $number:Int!) {
  repository(owner:$owner, name:$name) {
    issue(number:$number) { id }
  }
}
'@
  $data = Invoke-GhGraphQL -Query $query -Variables @{ owner = $owner; name = $name; number = [int]$Number }
  if ($null -eq $data.repository -or $null -eq $data.repository.issue -or [string]::IsNullOrWhiteSpace($data.repository.issue.id)) {
    throw "Issue introuvable pour suppression: $Repo#$Number"
  }
  return $data.repository.issue.id
}

function Delete-IssueByNumber($Repo, $Number) {
  $issueId = Get-IssueNodeId -Repo $Repo -Number $Number
  $mutation = @'
mutation($issueId:ID!) {
  deleteIssue(input:{issueId:$issueId}) {
    clientMutationId
  }
}
'@
  Invoke-GhGraphQL -Query $mutation -Variables @{ issueId = $issueId } | Out-Null
}

function Delete-DuplicateIssues($RepoMapToUse) {
  foreach ($repo in $RepoMapToUse.Values) {
    Write-Host "Check duplicates (delete mode) in $repo"
    $raw = gh issue list --repo $repo --state all --json number,title,state,url --limit 1000 2>&1
    if ($LASTEXITCODE -ne 0) {
      Write-Warning "Impossible de lister les issues pour dedupe ($repo): $raw"
      continue
    }

    $issues = $raw | ConvertFrom-Json
    $groups = @{}
    foreach ($it in $issues) {
      if ([string]::IsNullOrWhiteSpace($it.title)) { continue }
      if (-not $groups.ContainsKey($it.title)) { $groups[$it.title] = @() }
      $groups[$it.title] += $it
    }

    foreach ($title in $groups.Keys) {
      $arr = @($groups[$title] | Sort-Object number)
      if ($arr.Count -le 1) { continue }

      $keep = $arr[0]
      $dups = @($arr | Select-Object -Skip 1 | Sort-Object number -Descending)
      foreach ($dup in $dups) {
        Write-Host "Delete duplicate: $repo #$($dup.number) (keep #$($keep.number)) | $title"
        try {
          Delete-IssueByNumber -Repo $repo -Number $dup.number
        }
        catch {
          Write-Warning "Suppression echouee pour $repo#$($dup.number): $($_.Exception.Message)"
        }
      }
    }
  }
}

function Get-AllRepoIssues($Repo) {
  $raw = gh issue list --repo $Repo --state all --json number,title,state,url --limit 1000 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Impossible de lister les issues pour $Repo. Detail: $raw"
  }
  return ($raw | ConvertFrom-Json)
}

function Delete-ImportedIssues($RepoMapToUse) {
  $csvRows = Load-CsvReferenceByTitle
  $importTitles = @{}
  foreach ($k in $csvRows.Keys) { $importTitles[$k] = $true }

  foreach ($repo in $RepoMapToUse.Values) {
    Write-Host "Delete imported issues in $repo"
    $issues = Get-AllRepoIssues -Repo $repo
    $toDelete = @($issues | Where-Object { $importTitles.ContainsKey($_.title) } | Sort-Object number -Descending)
    foreach ($it in $toDelete) {
      Write-Host "Delete imported: $repo #$($it.number) | $($it.title)"
      try {
        Delete-IssueByNumber -Repo $repo -Number $it.number
      }
      catch {
        Write-Warning "Suppression echouee pour $repo#$($it.number): $($_.Exception.Message)"
      }
    }
  }
}

function Delete-AllIssues($RepoMapToUse) {
  foreach ($repo in $RepoMapToUse.Values) {
    Write-Host "Delete ALL issues in $repo"
    $issues = @(Get-AllRepoIssues -Repo $repo | Sort-Object number -Descending)
    foreach ($it in $issues) {
      Write-Host "Delete issue: $repo #$($it.number) | $($it.title)"
      try {
        Delete-IssueByNumber -Repo $repo -Number $it.number
      }
      catch {
        Write-Warning "Suppression echouee pour $repo#$($it.number): $($_.Exception.Message)"
      }
    }
  }
}

function Import-CsvToIssues($CsvPath, $RepoMapToUse) {
  Import-Csv $CsvPath | ForEach-Object {
    $row = $_
    $repoKey = $row.Repository
    if (-not $RepoMapToUse.ContainsKey($repoKey)) {
      Write-Warning "Repo non disponible pour import, issue skippee ($repoKey): $($row.Title)"
      return
    }
    $repo = $RepoMapToUse[$repoKey]

    $labels = @(
      (Get-TypeLabelFromType -TypeValue $row.Type),
      ("area/" + $row.Area.ToLower()),
      ("priority/" + $row.Priority.ToLower()),
      ("class/" + $row.'Class of Service'.ToLower().Replace(' ', '-'))
    ) -join ","

    $titleSet = Get-RepoIssueTitleSet -Repo $repo
    if ($titleSet.ContainsKey($row.Title)) {
      Write-Host "Issue deja presente, skip create: $repo | $($row.Title)"
      return
    }

    gh issue create `
      --repo $repo `
      --title $row.Title `
      --body $row.Body `
      --label $labels `
      --project $ProjectTitle | Out-Null
    if ($LASTEXITCODE -ne 0) {
      throw "Echec creation issue pour '$($row.Title)' dans $repo"
    }

    $titleSet[$row.Title] = $true
  }
}

function Load-CsvReferenceByTitle() {
  $rows = @{}
  $paths = Get-ImportCsvPaths
  foreach ($p in $paths) {
    Import-Csv $p | ForEach-Object {
      $title = $_.Title
      if (-not [string]::IsNullOrWhiteSpace($title)) {
        $rows[$title] = $_
      }
    }
  }
  return $rows
}

function Get-ProjectContext($Login, $Title) {
  $projects = @()

  $userQuery = @'
query($login:String!, $q:String!) {
  user(login:$login) {
    projectsV2(first:50, query:$q) {
      nodes { id title number }
    }
  }
}
'@
  try {
    $udata = Invoke-GhGraphQL -Query $userQuery -Variables @{ login = $Login; q = $Title }
    if ($null -ne $udata.user) { $projects += $udata.user.projectsV2.nodes }
  }
  catch {
    Write-Warning "Lookup projet user echoue pour '$Login': $($_.Exception.Message)"
  }

  if ($projects.Count -eq 0) {
    $orgQuery = @'
query($login:String!, $q:String!) {
  organization(login:$login) {
    projectsV2(first:50, query:$q) {
      nodes { id title number }
    }
  }
}
'@
    try {
      $odata = Invoke-GhGraphQL -Query $orgQuery -Variables @{ login = $Login; q = $Title }
      if ($null -ne $odata.organization) { $projects += $odata.organization.projectsV2.nodes }
    }
    catch {
      Write-Warning "Lookup projet organization echoue pour '$Login': $($_.Exception.Message)"
    }
  }

  $project = $projects | Where-Object { $_.title -eq $Title } | Select-Object -First 1
  if (-not $project) {
    throw "Project '$Title' introuvable pour '$Login'."
  }

  $fieldsQuery = @'
query($projectId:ID!) {
  node(id:$projectId) {
    ... on ProjectV2 {
      fields(first:100) {
        nodes {
          __typename
          ... on ProjectV2FieldCommon { id name }
          ... on ProjectV2SingleSelectField {
            id
            name
            options { id name }
          }
        }
      }
    }
  }
}
'@

  $fdata = Invoke-GhGraphQL -Query $fieldsQuery -Variables @{ projectId = $project.id }
  $fieldMap = @{}
  foreach ($f in $fdata.node.fields.nodes) {
    if (-not $f.name) { continue }
    $entry = @{ id = $f.id; name = $f.name; type = $f.__typename; options = @{} }
    if ($null -ne $f.options) {
      foreach ($opt in $f.options) { $entry.options[$opt.name] = $opt.id }
    }
    $fieldMap[$f.name] = $entry
  }

  return @{ ProjectId = $project.id; Fields = $fieldMap }
}

function Get-ProjectIssueItems($ProjectId) {
  $items = @()
  $after = $null

  $query = @'
query($projectId:ID!, $after:String) {
  node(id:$projectId) {
    ... on ProjectV2 {
      items(first:100, after:$after) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          content {
            __typename
            ... on Issue {
              id
              title
              body
              number
              repository { name nameWithOwner }
              labels(first:100) { nodes { name } }
            }
          }
        }
      }
    }
  }
}
'@

  while ($true) {
    $data = Invoke-GhGraphQL -Query $query -Variables @{ projectId = $ProjectId; after = $after }
    $batch = $data.node.items.nodes
    foreach ($it in $batch) {
      if ($it.content -and $it.content.__typename -eq "Issue") {
        $items += $it
      }
    }

    if (-not $data.node.items.pageInfo.hasNextPage) { break }
    $after = $data.node.items.pageInfo.endCursor
  }

  return $items
}

function Get-AllProjectItems($ProjectId) {
  $items = @()
  $after = $null

  $query = @'
query($projectId:ID!, $after:String) {
  node(id:$projectId) {
    ... on ProjectV2 {
      items(first:100, after:$after) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          content {
            __typename
            ... on Issue { id title number repository { nameWithOwner } }
            ... on PullRequest { id title number repository { nameWithOwner } }
          }
        }
      }
    }
  }
}
'@

  while ($true) {
    $data = Invoke-GhGraphQL -Query $query -Variables @{ projectId = $ProjectId; after = $after }
    $batch = $data.node.items.nodes
    foreach ($it in $batch) { $items += $it }
    if (-not $data.node.items.pageInfo.hasNextPage) { break }
    $after = $data.node.items.pageInfo.endCursor
  }

  return $items
}

function Delete-ProjectItem($ProjectId, $ItemId) {
  $mutation = @'
mutation($projectId:ID!, $itemId:ID!) {
  deleteProjectV2Item(input:{ projectId:$projectId, itemId:$itemId }) {
    deletedItemId
  }
}
'@
  Invoke-GhGraphQL -Query $mutation -Variables @{ projectId = $ProjectId; itemId = $ItemId } | Out-Null
}

function Reset-ProjectItems($ProjectContext) {
  $projectId = $ProjectContext.ProjectId
  $items = @(Get-AllProjectItems -ProjectId $projectId)
  Write-Host "Reset project items: $($items.Count) item(s) a supprimer."
  foreach ($it in $items) {
    try {
      Delete-ProjectItem -ProjectId $projectId -ItemId $it.id
    }
    catch {
      Write-Warning "Echec suppression item project $($it.id): $($_.Exception.Message)"
    }
  }
}

function Get-LabelValueByPrefix($Issue, $Prefix) {
  foreach ($l in $Issue.labels.nodes) {
    if ($l.name.StartsWith($Prefix)) {
      return $l.name.Substring($Prefix.Length)
    }
  }
  return $null
}

function Get-BodyFieldValue($Body, $FieldName) {
  if ([string]::IsNullOrWhiteSpace($Body)) { return $null }
  $regex = [regex]($FieldName + ":\\s*([^|`r`n]+)")
  $m = $regex.Match($Body)
  if (-not $m.Success) { return $null }
  return $m.Groups[1].Value.Trim()
}

function Set-ProjectSingleSelectField($ProjectId, $ItemId, $Field, $Value) {
  if ([string]::IsNullOrWhiteSpace($Value)) { return }
  if ($null -eq $Field) { return }
  if (-not $Field.options.ContainsKey($Value)) {
    Write-Warning "Option single-select inexistante pour '$($Field.name)': '$Value'"
    return
  }
  $optId = $Field.options[$Value]
  $mutation = @'
mutation($projectId:ID!, $itemId:ID!, $fieldId:ID!, $optionId:String!) {
  updateProjectV2ItemFieldValue(input:{
    projectId:$projectId,
    itemId:$itemId,
    fieldId:$fieldId,
    value:{ singleSelectOptionId:$optionId }
  }) { projectV2Item { id } }
}
'@
  Invoke-GhGraphQL -Query $mutation -Variables @{ projectId = $ProjectId; itemId = $ItemId; fieldId = $Field.id; optionId = $optId } | Out-Null
}

function Set-ProjectTextField($ProjectId, $ItemId, $Field, $Value) {
  if ([string]::IsNullOrWhiteSpace($Value)) { return }
  if ($null -eq $Field) { return }
  $mutation = @'
mutation($projectId:ID!, $itemId:ID!, $fieldId:ID!, $text:String!) {
  updateProjectV2ItemFieldValue(input:{
    projectId:$projectId,
    itemId:$itemId,
    fieldId:$fieldId,
    value:{ text:$text }
  }) { projectV2Item { id } }
}
'@
  Invoke-GhGraphQL -Query $mutation -Variables @{ projectId = $ProjectId; itemId = $ItemId; fieldId = $Field.id; text = $Value } | Out-Null
}

function Map-TypeFromLabel($Raw) {
  switch ($Raw) {
    "epic" { return "Epic" }
    "feature" { return "Feature" }
    "requirement" { return "Requirement" }
    "task" { return "Task" }
    "bug" { return "Bug" }
    "incident" { return "Incident" }
    "risk" { return "Risk" }
    "doc" { return "Documentation" }
    "documentation" { return "Documentation" }
    default { return $null }
  }
}

function Map-AreaFromLabel($Raw) {
  switch ($Raw) {
    "devops" { return "DevOps" }
    "web" { return "Web" }
    "api" { return "API" }
    "ux" { return "UX/UI" }
    "marketing" { return "Marketing" }
    "docs" { return "Docs" }
    default { return $null }
  }
}

function Map-PriorityFromLabel($Raw) {
  switch ($Raw) {
    "p0" { return "P0" }
    "p1" { return "P1" }
    "p2" { return "P2" }
    "p3" { return "P3" }
    default { return $null }
  }
}

function Map-ClassFromLabel($Raw) {
  switch ($Raw) {
    "expedite" { return "Expedite" }
    "fixed-date" { return "Fixed Date" }
    "standard" { return "Standard" }
    "intangible" { return "Intangible" }
    default { return "Standard" }
  }
}

function Sync-ProjectFieldsFromIssues($ProjectContext) {
  $projectId = $ProjectContext.ProjectId
  $fields = $ProjectContext.Fields
  $items = Get-ProjectIssueItems -ProjectId $projectId
  $csvByTitle = Load-CsvReferenceByTitle

  $updated = 0
  foreach ($item in $items) {
    $issue = $item.content
    $csvRow = $null
    if ($csvByTitle.ContainsKey($issue.title)) {
      $csvRow = $csvByTitle[$issue.title]
    }

    $typeRaw = Get-LabelValueByPrefix -Issue $issue -Prefix "type/"
    $areaRaw = Get-LabelValueByPrefix -Issue $issue -Prefix "area/"
    $prioRaw = Get-LabelValueByPrefix -Issue $issue -Prefix "priority/"
    $classRaw = Get-LabelValueByPrefix -Issue $issue -Prefix "class/"

    $typeVal = if ($csvRow) { $csvRow.Type } else { Map-TypeFromLabel -Raw $typeRaw }
    $areaVal = if ($csvRow) { $csvRow.Area } else { Map-AreaFromLabel -Raw $areaRaw }
    $prioVal = if ($csvRow) { $csvRow.Priority } else { Map-PriorityFromLabel -Raw $prioRaw }
    $classVal = if ($csvRow) { $csvRow.'Class of Service' } else { Map-ClassFromLabel -Raw $classRaw }
    $sizeVal = if ($csvRow) { $csvRow.Size } else { $null }

    $pbsVal = if ($csvRow -and -not [string]::IsNullOrWhiteSpace($csvRow.'PBS ID')) { $csvRow.'PBS ID' } else { Get-BodyFieldValue -Body $issue.body -FieldName "PBS ID" }
    $rqVal = if ($csvRow -and -not [string]::IsNullOrWhiteSpace($csvRow.'Requirement ID')) { $csvRow.'Requirement ID' } else { Get-BodyFieldValue -Body $issue.body -FieldName "Requirement ID" }
    $featVal = if ($csvRow -and -not [string]::IsNullOrWhiteSpace($csvRow.'Feature ID')) { $csvRow.'Feature ID' } else { Get-BodyFieldValue -Body $issue.body -FieldName "Feature ID" }
    $wbsVal = if ($csvRow -and -not [string]::IsNullOrWhiteSpace($csvRow.'WBS ID')) { $csvRow.'WBS ID' } else { Get-BodyFieldValue -Body $issue.body -FieldName "WBS ID" }
    $testVal = if ($csvRow -and -not [string]::IsNullOrWhiteSpace($csvRow.'Test ID')) { $csvRow.'Test ID' } else { Get-BodyFieldValue -Body $issue.body -FieldName "Test ID" }

    try {
      Set-ProjectSingleSelectField -ProjectId $projectId -ItemId $item.id -Field $fields["Type"] -Value $typeVal
      Set-ProjectSingleSelectField -ProjectId $projectId -ItemId $item.id -Field $fields["Area"] -Value $areaVal
      Set-ProjectSingleSelectField -ProjectId $projectId -ItemId $item.id -Field $fields["Priority"] -Value $prioVal
      Set-ProjectSingleSelectField -ProjectId $projectId -ItemId $item.id -Field $fields["Class of Service"] -Value $classVal
      Set-ProjectSingleSelectField -ProjectId $projectId -ItemId $item.id -Field $fields["Size"] -Value $sizeVal

      Set-ProjectTextField -ProjectId $projectId -ItemId $item.id -Field $fields["PBS ID"] -Value $pbsVal
      Set-ProjectTextField -ProjectId $projectId -ItemId $item.id -Field $fields["Requirement ID"] -Value $rqVal
      Set-ProjectTextField -ProjectId $projectId -ItemId $item.id -Field $fields["Feature ID"] -Value $featVal
      Set-ProjectTextField -ProjectId $projectId -ItemId $item.id -Field $fields["WBS ID"] -Value $wbsVal
      Set-ProjectTextField -ProjectId $projectId -ItemId $item.id -Field $fields["Test ID"] -Value $testVal
      $updated++
    }
    catch {
      Write-Warning "Sync fields echec sur item '$($issue.title)': $($_.Exception.Message)"
    }
  }

  Write-Host "Sync project fields termine. Items traites: $updated"
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI (gh) introuvable. Installe gh puis relance le script."
}

Assert-GhAuth

if ($ArchiveDuplicates) {
  throw "Option desactivee: -ArchiveDuplicates. Utilise un mode suppression: -DeleteImportedIssues, -DeleteDuplicates ou -DeleteAllIssues."
}

if ($DeleteAllIssues -and $DeleteImportedIssues) {
  throw "Options incompatibles: -DeleteAllIssues inclut deja un reset complet."
}

if ($ResetProjectItems -and (-not $SyncOnly) -and (-not $DeleteImportedIssues) -and (-not $DeleteAllIssues) -and (-not $DeleteDuplicates)) {
  Write-Host "Mode reset project items actif."
}

$needRepoAccess = (-not $SyncOnly) -or $DeleteDuplicates -or $DeleteImportedIssues -or $DeleteAllIssues
if ($needRepoAccess) {
  $ActiveRepoMap = Get-AccessibleRepoMap -InputMap $RepoMap
  if ($ActiveRepoMap.Count -eq 0) {
    throw "Aucun repository accessible en ecriture. Verifie les droits repo + l'auth gh."
  }
}

if (-not $SyncOnly) {
  Ensure-StandardLabels -RepoMapToUse $ActiveRepoMap
  $importPaths = Get-ImportCsvPaths
  foreach ($csvPath in $importPaths) {
    Import-CsvToIssues $csvPath $ActiveRepoMap
  }
}

if ($DeleteDuplicates) {
  Delete-DuplicateIssues -RepoMapToUse $ActiveRepoMap
}

if ($DeleteImportedIssues) {
  Delete-ImportedIssues -RepoMapToUse $ActiveRepoMap
}

if ($DeleteAllIssues) {
  Delete-AllIssues -RepoMapToUse $ActiveRepoMap
}

$ctx = Get-ProjectContext -Login $Org -Title $ProjectTitle
if ($ResetProjectItems) {
  Reset-ProjectItems -ProjectContext $ctx
}
if ($ResetProjectItems -and $SyncOnly -and (-not $DeleteImportedIssues) -and (-not $DeleteAllIssues) -and (-not $DeleteDuplicates)) {
  Write-Host "Reset project items termine (sans sync)."
  return
}
Sync-ProjectFieldsFromIssues -ProjectContext $ctx
