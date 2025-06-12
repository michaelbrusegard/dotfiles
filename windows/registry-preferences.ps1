function Set-RegistryValue {
    Param(
        [string]$Path,
        [string]$Name,
        $Value,
        [string]$Type = "DWord"
    )
    try {
        $parentPath = Split-Path -Path $Path
        if (-not (Test-Path $parentPath)) {
            New-Item -Path $parentPath -Force | Out-Null
        }
        switch ($Type) {
            "DWord" { 
                Set-ItemProperty -Path $Path -Name $Name -Value $Value -Force -ErrorAction Stop
                Write-Host "Set $Path\$Name to $Value (DWord)"
            }
            "String" { 
                Set-ItemProperty -Path $Path -Name $Name -Value "$Value" -Force -ErrorAction Stop
                Write-Host "Set $Path\$Name to $Value (String)"
            }
            "Binary" { 
                Set-ItemProperty -Path $Path -Name $Name -Value ([byte[]]$Value) -Force -ErrorAction Stop
                Write-Host "Set $Path\$Name to Binary Value"
            }
        }
    } catch {}
}

# Set app and system to use light theme
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

# Disable Bing Search in Start Menu
Set-RegistryValue -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1 -Type "DWord"
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\WebSearch" -Name "BingSearchEnabled" -Value 0

# Set Initial Keyboard Indicators (NumLock, CapsLock, ScrollLock) to off for current and default users
Set-RegistryValue -Path "HKCU:\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value 0
Set-RegistryValue -Path "HKU\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value 0

# Disable verbose status messages during startup/shutdown
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Value 0

# Hide Recommended section in Start Menu
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "HideRecommendedSection" -Value 1

# Set environment to education mode
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Education" -Name "IsEducationEnvironment" -Value 1

# Disable Window Arrangement (Snap Assist) features
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "WindowArrangementActive" -Value 0
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapAssistFlyout" -Value 0
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "SnapAssist" -Value 0

# Set mouse speed and acceleration thresholds to 0
Set-RegistryValue -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0
Set-RegistryValue -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0
Set-RegistryValue -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0

# Show hidden files
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1

# Show file extensions
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# Set Search Box Taskbar Mode to hidden
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0

# Hide Task View button
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0

# Set Taskbar Alignment to left
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0

# Set Taskbar Position to Top for main display
$taskbarSettings = @(
    0x28,0x00,0x00,0x00,0xFF,0xFF,0xFF,0xFF,0x02,0x00,0x00,0x00,0x01,0x00,0x00,0x00,
    0x3E,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
)
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" -Name "Settings" -Value $taskbarSettings -Type "Binary"

# Set Taskbar Position to Top for additional monitors
$multiMonitorPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MMStuckRects3"
if (Test-Path $multiMonitorPath) {
    $taskbarSettingsMultiMonitor = @(
        0x28,0x00,0x00,0x00,0xFF,0xFF,0xFF,0xFF,0x02,0x00,0x00,0x00,0x01,0x00,0x00,0x00,
        0x3E,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    )
    Set-RegistryValue -Path $multiMonitorPath -Name "Settings" -Value $taskbarSettingsMultiMonitor -Type "Binary"
}

# Remove Widget button from taskbar
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Taskbar" -Name "TaskbarDa" -Value 0

# Disable badges on taskbar apps
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarBadges" -Value 0

# Disable flashing of applications in the taskbar
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarFlashing" -Value 0

# Disable "Show desktop" button in the far corner of taskbar
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowPeekButton" -Value 0

# Disable emoticon display for crash control (Blue Screen of Death)
Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -Name "DisplayParameters" -Value 1

# Disable Windows Key combinations
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableLockWorkstation" -Value 1
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWinKeys" -Value 1
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoLeftWindows" -Value 1
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoRightWindows" -Value 1

# Disable Sticky Keys
Set-RegistryValue -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value 58

# Disable Dynamic Lighting
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowDynamicLighting" -Value 0
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDynamicLighting" -Value 0

# Set keyboard repeat delay
Set-RegistryValue -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value "0" -Type "String"

# Set keyboard repeat rate
Set-RegistryValue -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value "31" -Type "String"

# Set UAC to never notify 
Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0
Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1

# Set WezTerm config path
Set-RegistryValue -Path "HKCU:\Environment" -Name "WEZTERM_CONFIG_FILE" -Value "\\wsl.localhost\NixOS\home\michaelbrusegard\Developer\dotfiles\modules\wezterm\config\wezterm.lua" -Type "String"

# Set GlazeWM config path
Set-RegistryValue -Path "HKCU:\Environment" -Name "GLAZEWM_CONFIG_PATH" -Value "\\wsl.localhost\NixOS\home\michaelbrusegard\Developer\dotfiles\windows\programs\glazewm\config.yaml" -Type "String"

function Set-Wallpaper {
    param(
        [string]$WallpaperPath,
        [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
        [string]$Style = 'Fill'
    )

    $WallpaperStyle = switch ($Style) {
        'Fill'    { 10 }
        'Fit'     { 6 }
        'Stretch' { 2 }
        'Tile'    { 1 }
        'Center'  { 0 }
        'Span'    { 22 }
    }

    if (-not (Test-Path $WallpaperPath)) {
        Write-Error "Wallpaper file not found: $WallpaperPath"
        return
    }

    $WallpaperPath = (Resolve-Path $WallpaperPath).Path

    Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value $WallpaperStyle -Type "String"
    Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -Value $(if ($Style -eq 'Tile') { 1 } else { 0 }) -Type "String"

    Add-Type -TypeDefinition @"
        using System.Runtime.InteropServices;
        public class Wallpaper {
            [DllImport("user32.dll", CharSet = CharSet.Auto)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        }
"@

    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent

    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $WallpaperPath, $fWinIni)
    Write-Host "Wallpaper set to: $WallpaperPath with style: $Style"
}

# Set wallpaper
Set-Wallpaper -WallpaperPath "\\wsl.localhost\NixOS\home\michaelbrusegard\Developer\dotfiles\assets\wallpapers\twilight-peaks.png" -Style "Fill"

# Set lock screen wallpaper
$lockScreenPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
Set-RegistryValue -Path $lockScreenPath -Name "LockScreenImagePath" -Value "\\wsl.localhost\NixOS\home\michaelbrusegard\Developer\dotfiles\assets\wallpapers\twilight-peaks.png" -Type "String"
Set-RegistryValue -Path $lockScreenPath -Name "LockScreenImageUrl" -Value "\\wsl.localhost\NixOS\home\michaelbrusegard\Developer\dotfiles\assets\wallpapers\twilight-peaks.png" -Type "String"
Set-RegistryValue -Path $lockScreenPath -Name "LockScreenImageStatus" -Value 1 -Type "DWord"
