#Requires -RunAsAdministrator

################################################################################
### Basic Stuff                                                                #
################################################################################

Write-Host "Let's go! Configuring the basic system my homie..." -ForegroundColor "Yellow"

# Set Computer Name
(Get-WmiObject Win32_ComputerSystem).Rename("HERBERT-$(get-date -Format yyyy)") | Out-Null

# Enable Developer Mode
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" "AllowDevelopmentWithoutDevLicense" 1

# Enable Linux sub-system
Enable-WindowsOptionalFeature -Online -All -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart -WarningAction SilentlyContinue | Out-Null

################################################################################
### Privacy                                                                    #
################################################################################

Write-Host "Configuring privacy..." -ForegroundColor "Yellow"

# Ensure necessary registry paths
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Type Folder | Out-Null}

# Don't let apps use advertising ID for experiences across apps: Allow: 1, Disallow: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0

# Enable SmartScreen filter: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" "EnableWebContentEvaluation" 1

# Disable key logging & transmission to Microsoft: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0

# Disable SmartGlass: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" "UserAuthPolicy" 0

# Disable SmartGlass over BlueTooth: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" "BluetoothPolicy" 0

# Contacts: Don't let apps access contacts: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" "Value" "Deny"

# Calendar: Don't let apps access calendar: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" "Value" "Deny"

# Don't let apps access call history: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" "Value" "Deny"

# Don't let apps read and send email: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" "Value" "Deny"

# Don't let apps read or send messages (text or MMS): Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" "Value" "Deny"

# Don't let apps share and sync with non-explicitly-paired wireless devices over uPnP: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "Value" "Deny"

# Don't allow Windows to ask for my feedback
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0

# Telemetry: Send Diagnostic and usage data: Basic: 1, Enhanced: 2, Full: 3
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 1

################################################################################
### Devices and Power                                                          #
################################################################################

Write-Host "Configuring Startup..." -ForegroundColor "Yellow"

# Sound: Disable Startup Sound
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" "DisableStartupSound" 1

# Power: Set standby delay to 1 hour
powercfg /change /standby-timeout-ac 60

################################################################################
### Explorer, Taskbar, and System Tray                                         #
################################################################################

Write-Host "Configuring Explorer, Taskbar, and System Tray..." -ForegroundColor "Yellow"

# Ensure necessary registry paths
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Type Folder | Out-Null}
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Type Folder | Out-Null}

# Show hidden files by default: Show Files: 1, Hide Files: 2
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# Show file extensions by default
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# Show path in title bar
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1

# Avoid creating Thumbs.db files on network volumes
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1

# Enable small icons in Taskbar
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons" 1

# Disable Bing Search on Taskbar
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" 0

# Disable Cortana
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0

# Show colors on Taskbar, Start, and SysTray: Disabled: 0, Taskbar, Start, & SysTray: 1, Taskbar Only: 2
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "ColorPrevalence" 0

# Disable Recylce Bin Delete Confirmation Dialog
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ConfirmFileDelete" 0

#
# Disable automatically syncing settings with other Windows 10 devices:
#

# Theme
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" "Enabled" 0
# Internet Explorer
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" "Enabled" 0
# Passwords
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" "Enabled" 0
# Language
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" "Enabled" 0
# Accessibility / Ease of Access
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" "Enabled" 0
# Other Windows Settings
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" "Enabled" 0

################################################################################
### Default Windows Applications                                               #
################################################################################

Write-Host "Configuring Default Windows Applications..." -ForegroundColor "Yellow"

# Uninstall Bing Finance
Get-AppxPackage "Microsoft.BingFinance" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.BingFinance" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing News
Get-AppxPackage "Microsoft.BingNews" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.BingNews" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing Sports
Get-AppxPackage "Microsoft.BingSports" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.BingSports" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing Weather
Get-AppxPackage "Microsoft.BingWeather" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.BingWeather" | Remove-AppxProvisionedPackage -Online

# Uninstall Calendar and Mail
Get-AppxPackage "Microsoft.WindowsCommunicationsApps" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.WindowsCommunicationsApps" | Remove-AppxProvisionedPackage -Online

# Uninstall Candy Crush Soda Saga
Get-AppxPackage "king.com.CandyCrushSodaSaga" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "king.com.CandyCrushSodaSaga" | Remove-AppxProvisionedPackage -Online

# Uninstall Facebook
Get-AppxPackage "*.Facebook" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "*.Facebook" | Remove-AppxProvisionedPackage -Online

# Uninstall Get Office, and its "Get Office365" notifications
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.MicrosoftOfficeHub" | Remove-AppxProvisionedPackage -Online

# Uninstall Get Started
Get-AppxPackage "Microsoft.GetStarted" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.GetStarted" | Remove-AppxProvisionedPackage -Online

# Uninstall Maps
Get-AppxPackage "Microsoft.WindowsMaps" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.WindowsMaps" | Remove-AppxProvisionedPackage -Online

# Uninstall Messaging
Get-AppxPackage "Microsoft.Messaging" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.Messaging" | Remove-AppxProvisionedPackage -Online

# Uninstall OneNote
Get-AppxPackage "Microsoft.Office.OneNote" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.Office.OneNote" | Remove-AppxProvisionedPackage -Online

# Uninstall People
Get-AppxPackage "Microsoft.People" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.People" | Remove-AppxProvisionedPackage -Online

# Uninstall SlingTV
Get-AppxPackage "*.SlingTV" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "*.SlingTV" | Remove-AppxProvisionedPackage -Online

# Uninstall Solitaire
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxProvisionedPackage -Online

# Uninstall StickyNotes
Get-AppxPackage "Microsoft.MicrosoftStickyNotes" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.MicrosoftStickyNotes" | Remove-AppxProvisionedPackage -Online

# Uninstall Sway
Get-AppxPackage "Microsoft.Office.Sway" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.Office.Sway" | Remove-AppxProvisionedPackage -Online

# Uninstall Twitter
Get-AppxPackage "*.Twitter" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "*.Twitter" | Remove-AppxProvisionedPackage -Online

# Uninstall Voice Recorder
Get-AppxPackage "Microsoft.WindowsSoundRecorder" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.WindowsSoundRecorder" | Remove-AppxProvisionedPackage -Online

# Uninstall Windows Phone Companion
Get-AppxPackage "Microsoft.WindowsPhone" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.WindowsPhone" | Remove-AppxProvisionedPackage -Online

# Uninstall XBox
#Get-AppxPackage "Microsoft.XboxApp" -AllUsers | Remove-AppxPackage
#Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.XboxApp" | Remove-AppxProvisionedPackage -Online

# Uninstall Zune Music (Groove)
Get-AppxPackage "Microsoft.ZuneMusic" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.ZuneMusic" | Remove-AppxProvisionedPackage -Online

# Uninstall Zune Video
Get-AppxPackage "Microsoft.ZuneVideo" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.ZuneVideo" | Remove-AppxProvisionedPackage -Online

# Uninstall Windows Media Player
Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart -WarningAction SilentlyContinue | Out-Null

# Prevent "Suggested Applications" from returning
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Type Folder | Out-Null}
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1

################################################################################
### Accessibility and Ease of Use                                              #
################################################################################

Write-Host "Configuring Accessibility..." -ForegroundColor "Yellow"

# Turn Off Windows Narrator
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe")) {New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" -Type Folder | Out-Null}
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" "Debugger" "%1"

# Disable "Window Snap" Automatic Window Arrangement
Set-ItemProperty "HKCU:\Control Panel\Desktop" "WindowArrangementActive" 0

# Disable automatic fill to space on Window Snap
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapFill" 0

# Disable showing what can be snapped next to a window
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapAssist" 0

# Disable automatic resize of adjacent windows on snap
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "JointResize" 0

# Disable auto-correct
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\TabletTip\1.7" "EnableAutocorrection" 0

################################################################################
### Windows Update & Application Updates                                       #
################################################################################

Write-Host "Configuring Windows Update..." -ForegroundColor "Yellow"

# Ensure Windows Update registry paths
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Type Folder | Out-Null}
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Type Folder | Out-Null}

# Enable Automatic Updates
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0

# Disable automatic reboot after install
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" "NoAutoRebootWithLoggedOnUsers" 1
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoRebootWithLoggedOnUsers" 1

# Configure to Auto-Download but not Install: NotConfigured: 0, Disabled: 1, NotifyBeforeDownload: 2, NotifyBeforeInstall: 3, ScheduledInstall: 4
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 3

# Include Recommended Updates
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "IncludeRecommendedUpdates" 1

# Opt-In to Microsoft Update
$MU = New-Object -ComObject Microsoft.Update.ServiceManager -Strict
$MU.AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "") | Out-Null
Remove-Variable MU

# Download updates from 0: Http Only [Disable], 1: Peering on LAN, 2: Peering on AD / Domain, 3: Peering on Internet, 99: No peering, 100: Bypass & use BITS
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" "DODownloadMode" 0

################################################################################
### Windows Defender                                                           #
################################################################################

Write-Host "Configuring Windows Defender..." -ForegroundColor "Yellow"

# Enable Cloud-Based Protection: Enabled Advanced: 2, Enabled Basic: 1, Disabled: 0
Set-MpPreference -MAPSReporting 2

################################################################################
### OneDrive Removal                                                           #
################################################################################

Stop-Process -processname OneDrive, onedrive, 'Microsoft OneDrive' -ErrorAction SilentlyContinue
& 'C:\Windows\SysWOW64\OneDriveSetup.exe' /uninstall
Remove-Item -Recurse -Force $env:APPDATA'\Microsoft\OneDrive' -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force $env:USERPROFILE'\OneDrive' -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force $env:PROGRAMDATA'\Microsoft OneDrive' -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force 'C:\OneDriveTemp' -ErrorAction SilentlyContinue

Remove-Item -Path 'HKCU:/CLSID/{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -ErrorAction SilentlyContinue
Remove-Item -Path 'HKCU:/Wow6432Node/CLSID/{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -ErrorAction SilentlyContinue

################################################################################
### MS Edge                                                                    #
################################################################################

Write-Host "Configuring MS Edge..." -ForegroundColor "Yellow"

# Set home page to `about:blank` for faster loading
Set-ItemProperty "HKCU:\Software\Microsoft\Internet Explorer\Main" "Start Page" "about:blank"

# Disable 'Default Browser' check: "yes" or "no"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main" "Check_Associations" "no"

# Disable Password Caching
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" "DisablePasswordCaching" 1

################################################################################
### Hyper                                                                      #
################################################################################

Write-Host "Configuring Hyper Terminal..." -ForegroundColor "Yellow"

# https://stackoverflow.com/a/32455290/1171790
if (Test-Path "$HOME\.hyper.js") { Remove-Item "$HOME\.hyper.js" }

# https://stackoverflow.com/a/34905638/1171790
# https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Management/New-Item?view=powershell-5.1
New-Item -Path "$HOME\.hyper.js" -ItemType SymbolicLink -Value "$HOME\.dotfiles\hyper\.hyper.js"

################################################################################
### Git, Meld and Bash (GitBash)                                               #
################################################################################

Write-Host "Configuring Git and Meld..." -ForegroundColor "Yellow"

if (Test-Path "$HOME\.ssh\config") { Remove-Item "$HOME\.ssh\config" }
New-Item -Path "$HOME\.ssh\config" -ItemType SymbolicLink -Value "$HOME\Dropbox\Sites\.ssh\config"

# Bash, brought to you by GitBash!
if (Test-Path "$HOME\.bashrc") { Remove-Item "$HOME\.bashrc" }
New-Item -Path "$HOME\.bashrc" -ItemType SymbolicLink -Value "$HOME\.dotfiles\bash\.bashrc"
Write-Host "The first time you open GitBash, it will complain after linking .bashrc to the .bashrc in your dotfiles but after that, it will calm down." -ForegroundColor "Yellow"

if (Test-Path "$HOME\.minttyrc") { Remove-Item "$HOME\.minttyrc" }
New-Item -Path "$HOME\.minttyrc" -ItemType SymbolicLink -Value "$HOME\.dotfiles\gitbash\.minttyrc"

# Git configuration
if (Test-Path "$HOME\.gitignore_global") { Remove-Item "$HOME\.gitignore_global" }
# Instead of syslinking the files, we simply tell git directly where our global config files are located.
git config --global core.excludesfile "$HOME\.dotfiles\git\.gitignore_global"
if (Test-Path "$HOME\.gitattributes") { Remove-Item "$HOME\.gitattributes" }
git config --global core.attributesfile "$HOME\.dotfiles\git\.gitattributes_global"

# Git configuration script
if (Test-Path "$HOME\.dotfiles\git\git-config.ps1") { Remove-Item "$HOME\.dotfiles\git\git-config.ps1" }
New-Item -Path "$HOME\.dotfiles\git\git-config.ps1" -ItemType SymbolicLink -Value "$HOME\.dotfiles\git\git-config.bash"

& "$HOME\.dotfiles\git\git-config.ps1"

Write-Host "Installing Meld..." -ForegroundColor "Yellow"
choco install meld -y
refreshenv

################################################################################
### PowerShell                                                                 #
################################################################################

Write-Host "Configuring Powershell. You may be asked some questions..." -ForegroundColor "Yellow"

# Link Profile to the one inside this repo.
if (Test-Path "$profile") { Remove-Item "$profile" }
New-Item -Path "$profile" -ItemType SymbolicLink -Value "$HOME\.dotfiles\powershell\Microsoft.PowerShell_profile.ps1" -Force

# Link PowerShell color profiles
New-Item -Path "$(Split-Path -Path $profile)\Set-SolarizedDarkColorDefaults.ps1" -ItemType SymbolicLink -Value "$HOME\.dotfiles\powershell\Set-SolarizedDarkColorDefaults.ps1" -Force
New-Item -Path "$(Split-Path -Path $profile)\Set-SolarizedLightColorDefaults.ps1" -ItemType SymbolicLink -Value "$HOME\.dotfiles\powershell\Set-SolarizedLightColorDefaults.ps1" -Force

#
# PowerShell Providers and modules:
#

# Emojis in PowerShell: https://artofshell.com/2016/04/emojis-in-powershell-yes/
Install-Module -Name Emojis -Scope CurrentUser -Force

# Better colors in Windows command prompts: https://github.com/neilpa/cmd-colors-solarized
cd powershell
regedit /s solarized-dark.reg
cd ..

################################################################################
### All the softwares! (Brought to you by Chocolatey)                          #
################################################################################

Write-Host "Installing lots of software via Chocolatey..." -ForegroundColor "Yellow"

choco install dotnet4.5 -y
refreshenv

# choco install vcredist2015 -y
# refreshenv

[string[]] $packages =
'7zip',
'apache-httpd',
'awscli',
'cmake',
'curl',
'discord',
'droidsansmono',
'ffmpeg',
'FileOptimizer',
'filezilla',
'firacode',
'Firefox',
'gifsicle',
'GoogleChrome',
'heroku-cli',
'hyper',
'imagemagick',
'make',
'mysql.workbench',
'mysql',
'nodejs',
'openssl.light',
'pgadmin3',
'python',
'rsync',
'ruby',
'slack',
'SourceCodePro',
'sqlite',
'sqlitebrowser',
'telegram',
'transmission',
'vagrant',
'virtualbox',
'vlc',
'Wget',
'youtube-dl';

foreach ($package in $packages) {
  choco install $package -y
}

refreshenv

#
# Now config Node and NPM:
#

npm install --global --production windows-build-tools

[string[]] $npmpackages =
'cloudinary-cli',
'create-react-app',
'gatsby-cli',
'gatsby',
'now',
'sass',
'surge';

foreach ($package in $npmpackages) {
  npm install -g $package
}

if (Test-Path "$HOME\.npmrc") { Remove-Item "$HOME\.npmrc" }
New-Item -Path "$HOME\.npmrc" -ItemType SymbolicLink -Value "$HOME\.dotfiles\node\.npmrc"

#
# Now config PHP:
#

choco install php -y --params '"/ThreadSafe"'
refreshenv

choco install composer -y
refreshenv

Copy-Item "C:\tools\php72\php.ini" "C:\tools\php72\php.ini.bak"

# https://brian.teeman.net/joomla/install-amp-on-windows-with-chocolatey
(Get-Content "C:\tools\php72\php.ini").replace('date.timezone = UTC', 'date.timezone = "America/Los_Angele
s"') | Set-Content "C:\tools\php72\php.ini"
(Get-Content "C:\tools\php72\php.ini").replace('memory_limit = 128M', 'memory_limit = 512M') | Set-Content "C:\tools\php72\php.ini"
(Get-Content "C:\tools\php72\php.ini").replace('upload_max_filesize = 2M', 'upload_max_filesize = 32M') | Set-Content "C:\tools\php72\php.ini"
(Get-Content "C:\tools\php72\php.ini").replace('display_errors = Off', 'display_errors = On') | Set-Content "C:\tools\php72\php.ini"
(Get-Content "C:\tools\php72\php.ini").replace('display_startup_errors = Off', 'display_startup_errors = On') | Set-Content "C:\tools\php72\php.ini"
(Get-Content "C:\tools\php72\php.ini").replace('post_max_size = 8M', 'post_max_size = 32M') | Set-Content "C:\tools\php72\php.ini"

[string[]] $extensions =
'curl',
'exif',
'fileinfo',
'gd2',
'ldap',
'mbstring',
'mysqli',
'openssl',
'pdo_mysql',
'pdo_pgsql',
'pdo_sqlite',
'sqlite3';

foreach ($extension in $extensions) {
  (Get-Content "C:\tools\php72\php.ini").replace(";extension=$extension", "extension=$extension") | Set-Content "C:\tools\php72\php.ini"
}

# Enable these Apache modules.
[string[]] $modules =
'expires',
'rewrite';

foreach ($module in $modules) {
  (Get-Content "$env:USERPROFILE\AppData\Roaming\Apache24\conf\httpd.conf").replace("#LoadModule $module`_module modules/mod_$module.so", "LoadModule $module`_module modules/mod_$module.so") | Set-Content "$env:USERPROFILE\AppData\Roaming\Apache24\conf\httpd.conf"
}

(Get-Content "$env:USERPROFILE\AppData\Roaming\Apache24\conf\httpd.conf").replace("#Include conf/extra/httpd-vhosts.conf", "Include conf/extra/httpd-vhosts.conf") | Set-Content "$env:USERPROFILE\AppData\Roaming\Apache24\conf\httpd.conf"
(Get-Content "$env:USERPROFILE\AppData\Roaming\Apache24\conf\httpd.conf").replace("#Include conf/extra/httpd-default.conf", "Include conf/extra/httpd-default.conf") | Set-Content "$env:USERPROFILE\AppData\Roaming\Apache24\conf\httpd.conf"

Write-Host "Finished installing Chocolatey packages..." -ForegroundColor "Yellow"

################################################################################
### Done! Holy shit!                                                           #
################################################################################

refreshenv

Write-Output ''
Write-Output 'All done!!! Please restart the computer in order for all of these changes to take effect.'
Write-Output ''
