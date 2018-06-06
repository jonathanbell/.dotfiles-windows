# Ensure UTF-8 encoding
# https://stackoverflow.com/a/48029600/1171790
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# Check if script is running on Windows
if ([Environment]::OSVersion.Platform -eq 'Win32NT') {
  # Windows only stuff...
}

# ------------------------------------------------------------------------------
# | Git and the PowerShell prompt
# ------------------------------------------------------------------------------

function Write-BranchName () {
  try {
    $branch = git rev-parse --abbrev-ref HEAD

    if ($branch -eq 'HEAD') {
      # We're probably in detached HEAD state, so print the SHA
      $branch = git rev-parse --short HEAD
      Write-Host "[$branch] " -NoNewline -ForegroundColor 'DarkYellow'
    }
    else {
      # We're on an actual branch, so print it
      Write-Host "[$branch]" -NoNewline -BackgroundColor 'DarkRed'
      Write-Host ' ' -NoNewline
    }
  }
  catch {
    # We end up here if we're in a newly initiated git repo
    Write-Host '(bare) ' -NoNewline -ForegroundColor 'Yellow'
  }
}

function prompt {
  $base = '-> ' # Base prompt string
  $path = (Get-Item -Path ".\" -Verbose).Name
  $userPrompt = "$(' $' * ($nestedPromptLevel + 1)) "

  # All colors are listed here: https://technet.microsoft.com/en-us/library/ff406264.aspx
  Write-Host "`n$base" -NoNewline -ForegroundColor 'Red'

  if (Test-Path .git) {
    Write-BranchName
  }

  Write-Host $path -NoNewline -ForegroundColor 'Cyan'

  return $userPrompt
}

# ------------------------------------------------------------------------------
# | Functions and Aliases
# | https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-alias?view=powershell-5.1
# ------------------------------------------------------------------------------

function shruggie() {
  # All emojis here: https://unicode.org/emoji/charts/full-emoji-list.html
  # Not all emojis listed above are supported in the module yet though..
  $outputEmoji = Get-Emoji 'PERSON SHRUGGING'
  $outputEmoji | Set-Clipboard
  Write-Host '*shrug*'
}

function restartapache() {
  if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `"net stop Apache; net start Apache;`"" -Verb RunAs
    # Backtick usage above explained: https://stackoverflow.com/a/18313593/1171790
    # Use the `-NoExit` param above if you don't want the PowerShell window to close automatically.
    exit
  }
}

# ------------------------------------------------------------------------------
# | Chocolatey
# ------------------------------------------------------------------------------

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
