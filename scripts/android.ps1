[CmdletBinding()]
param(
    [ValidateSet('prepare', 'doctor', 'build', 'run')]
    [string]$Action = 'run',
    [string]$FlutterRoot = 'D:\Tools\flutter-3.47.6',
    [string]$AndroidStudioRoot = 'D:\Program Files\Android\Android Studio',
    [string]$AndroidSdkRoot = (Join-Path $env:LOCALAPPDATA 'Android\Sdk'),
    [string]$Avd = 'Medium_Phone_API_36.1',
    [string]$Device = 'emulator-5554',
    [string]$ClientId = $env:NODELANE_CLIENT_ID,
    [string]$GradleUserHome = 'D:\Tools\gradle-nodelane-native',
    [switch]$ShowEmulator = $true
)

$ErrorActionPreference = 'Stop'
$taskProjectRoot = Split-Path -Parent $PSScriptRoot
$taskFlutter = Join-Path $FlutterRoot 'bin\flutter.bat'
$taskAdb = Join-Path $AndroidSdkRoot 'platform-tools\adb.exe'
$taskJavaRoot = Join-Path $AndroidStudioRoot 'jbr'
foreach ($taskPath in @($taskFlutter, $taskAdb, (Join-Path $taskJavaRoot 'bin\java.exe'))) {
    if (-not (Test-Path -LiteralPath $taskPath)) {
        throw "Required tool not found: $taskPath. Set the matching script parameter."
    }
}

# Environment changes apply only to this PowerShell process.
$env:JAVA_HOME = $taskJavaRoot
$env:ANDROID_SDK_ROOT = $AndroidSdkRoot
$env:GRADLE_USER_HOME = $GradleUserHome
$env:PATH = "$FlutterRoot\bin;$taskJavaRoot\bin;$AndroidSdkRoot\platform-tools;$env:PATH"
$taskDefines = @()
if (-not [string]::IsNullOrWhiteSpace($ClientId)) {
    $taskDefines += "--dart-define=NODELANE_CLIENT_ID=$ClientId"
}

Push-Location $taskProjectRoot
try {
    switch ($Action) {
        'doctor' { & $taskFlutter doctor -v }
        'prepare' {
            & rustup target add x86_64-linux-android i686-linux-android
            if ($LASTEXITCODE -ne 0) { throw "Rust target preparation failed." }
            & $taskFlutter pub get --enforce-lockfile
        }
        'build' { & $taskFlutter build apk --debug --target-platform android-x64 --no-pub @taskDefines }
        'run' {
            if ($Device -like 'emulator-*') {
                $taskDeviceState = & $taskAdb -s $Device get-state 2>$null
                if ($taskDeviceState -ne 'device') {
                    $taskEmulator = Join-Path $AndroidSdkRoot 'emulator\emulator.exe'
                    if (-not (Test-Path -LiteralPath $taskEmulator)) { throw "Emulator not found: $taskEmulator" }
                    $taskAvailableAvds = & $taskEmulator -list-avds
                    if ($Avd -notin $taskAvailableAvds) { throw "AVD not found: $Avd. Available: $($taskAvailableAvds -join ', ')" }
                    $taskEmulatorPort = $Device -replace '^emulator-', ''
                    $taskWindowStyle = if ($ShowEmulator) { 'Normal' } else { 'Hidden' }
                    $taskEmulatorArgs = @('-avd', $Avd, '-port', $taskEmulatorPort, '-no-boot-anim')
                    if (-not $ShowEmulator) { $taskEmulatorArgs += '-qt-hide-window' }
                    Start-Process -FilePath $taskEmulator -ArgumentList $taskEmulatorArgs -WindowStyle $taskWindowStyle | Out-Null
                }
                $taskBootDeadline = (Get-Date).AddMinutes(3)
                do {
                    $taskBooted = & $taskAdb -s $Device shell getprop sys.boot_completed 2>$null
                    if ($taskBooted -eq '1') { break }
                    if ((Get-Date) -gt $taskBootDeadline) { throw "Emulator $Device did not boot within 3 minutes." }
                    Start-Sleep -Seconds 2
                } while ($true)
            }
            & $taskFlutter run --debug --no-pub -d $Device @taskDefines
        }
    }
    if ($LASTEXITCODE -ne 0) { throw "Flutter exited with code $LASTEXITCODE." }
} finally {
    Pop-Location
}
