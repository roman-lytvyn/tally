# Builds the Windows installer (deberc-<version>-setup.exe) from the Flutter
# release bundle. Run `flutter build windows --release` first.
#
# Usage: devops\windows\build-installer.ps1 <version> [output-dir]
#
# Uses Inno Setup's ISCC.exe when it is installed; otherwise downloads the
# pinned Inno Setup release, checks its checksum and installs it for the
# current user into a cache folder that later runs reuse.
param(
    [Parameter(Mandatory = $true)][string]$Version,
    [string]$OutputDir = "."
)
$ErrorActionPreference = "Stop"

$InnoVersion = "6.7.3"
$InnoUrl = "https://github.com/jrsoftware/issrc/releases/download/is-6_7_3/innosetup-6.7.3.exe"
$InnoSha256 = "9c73c3bae7ed48d44112a0f48e66742c00090bdb5bef71d9d3c056c66e97b732"
$InnoCache = Join-Path $env:LOCALAPPDATA "deberc-ci\innosetup-$InnoVersion"

function Find-Iscc {
    $onPath = Get-Command ISCC.exe -ErrorAction SilentlyContinue
    if ($onPath) { return $onPath.Source }
    $candidates = @(
        (Join-Path $InnoCache "ISCC.exe"),
        (Join-Path $env:LOCALAPPDATA "Programs\Inno Setup 6\ISCC.exe"),
        (Join-Path ${env:ProgramFiles(x86)} "Inno Setup 6\ISCC.exe"),
        (Join-Path $env:ProgramFiles "Inno Setup 6\ISCC.exe")
    )
    foreach ($path in $candidates) {
        if (Test-Path $path) { return $path }
    }
    return $null
}

$iscc = Find-Iscc
if (-not $iscc) {
    Write-Host "Inno Setup not found, installing $InnoVersion into $InnoCache"
    $setup = Join-Path $env:TEMP "innosetup-$InnoVersion.exe"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $InnoUrl -OutFile $setup -UseBasicParsing
    $hash = (Get-FileHash $setup -Algorithm SHA256).Hash.ToLower()
    if ($hash -ne $InnoSha256) {
        Remove-Item $setup -Force
        throw "Inno Setup download checksum mismatch: $hash"
    }
    $proc = Start-Process -FilePath $setup -Wait -PassThru -ArgumentList @(
        "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART", "/CURRENTUSER",
        "/DIR=`"$InnoCache`""
    )
    Remove-Item $setup -Force
    if ($proc.ExitCode -ne 0) { throw "Inno Setup install failed with exit code $($proc.ExitCode)" }
    $iscc = Join-Path $InnoCache "ISCC.exe"
    if (-not (Test-Path $iscc)) { throw "ISCC.exe not found after installing Inno Setup" }
}

$script = Join-Path $PSScriptRoot "deberc.iss"
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$out = (Resolve-Path $OutputDir).Path
& $iscc /Q "/DAppVersion=$Version" "/DOutputDir=$out" $script
if ($LASTEXITCODE -ne 0) { throw "ISCC failed with exit code $LASTEXITCODE" }
Write-Host "Built $(Join-Path $out "deberc-$Version-setup.exe")"
