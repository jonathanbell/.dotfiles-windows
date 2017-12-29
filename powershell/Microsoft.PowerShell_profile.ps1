# This file's encoding is UTF-8 with BOM
# Why? https://stackoverflow.com/questions/48016113/how-to-pass-utf-8-characters-to-clip-exe-with-powershell-without-conversion-to-a/48017565#comment83004132_48016113

# function prompt {
#   "PSSS " + $(get-location) + "> "
# }


function CD32 { Set-Location -Path "C:\" }
Set-Alias goroot CD32

$global:CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
function prompt {
  $host.ui.rawui.WindowTitle = $CurrentUser.Name + " " + $Host.Name + " Line: " + $host.UI.RawUI.CursorPosition.Y
  Write-Host ("PS " + $(get-location) + ">") -nonewline -foregroundcolor Magenta 
  return " "
}

function meh() {
  # All emojis here: https://unicode.org/emoji/charts/full-emoji-list.html
  # Not all emojis listed above are supported in the module yet though..
  $upsideDownFace = Get-Emoji 'UPSIDE-DOWN FACE'
  $upsideDownFace | Set-Clipboard
  Write-Host 'Upsidedown face copied to clipboard.' -foregroundcolor yellow
}

function shruggie() {
  Set-ClipBoard '¯\_(ツ)_/¯'
  Write-Host '¯\_(ツ)_/¯ copied to clipboard.' -foregroundcolor yellow
}
