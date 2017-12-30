# Ensure UTF-8 encoding
# https://stackoverflow.com/a/48029600/1171790
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
#$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# This file's encoding is UTF-8 with BOM
# Why? https://stackoverflow.com/questions/48016113/how-to-pass-utf-8-characters-to-clip-exe-with-powershell-without-conversion-to-a/48017565#comment83004132_48016113

# When you update to PowerShell version 6, change the encoding of this file to UTF-8 *without* BOM:
# https://stackoverflow.com/a/40098904/1171790

# Check if script is running on Windows
if ([Environment]::OSVersion.Platform -eq 'Win32NT') {
  # Windows only stuff...
}

# ------------------------------------------------------------------------------
# | Prompt with Git branch
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
  $base = '→ ' # Base promt string
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
# | Functions
# ------------------------------------------------------------------------------

function shruggie() {
  # All emojis here: https://unicode.org/emoji/charts/full-emoji-list.html
  # Not all emojis listed above are supported in the module yet though..
  #$outputEmoji = Get-Emoji 'UPSIDE-DOWN FACE'
  $outputEmoji = Get-Emoji 'PERSON SHRUGGING'
  $outputEmoji | Set-Clipboard
  Write-Host '*shrug*'
}

# ------------------------------------------------------------------------------
# | Chocolatey
# ------------------------------------------------------------------------------

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
