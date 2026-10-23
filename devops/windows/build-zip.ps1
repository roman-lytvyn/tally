# Packs the Flutter release bundle into <name>-<version>-windows.zip for the
# app described by devops\apps\<app>.env: one folder named after the app with
# its .exe, which runs where it is unpacked, with no installation. Run
# `flutter build windows --release` first.
#
# Usage: devops\windows\build-zip.ps1 <version> [output-dir] [app]
param(
    [Parameter(Mandatory = $true)][string]$Version,
    [string]$OutputDir = ".",
    [string]$App = "deberc"
)
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
. (Join-Path $PSScriptRoot "..\apps\profile.ps1")
$identity = Read-AppProfile $App
$name = $identity.APP_FILE_NAME

$bundle = (Resolve-Path (Join-Path $PSScriptRoot "..\..\build\windows\x64\runner\Release")).Path
if (-not (Test-Path (Join-Path $bundle "$name.exe"))) { throw "No Windows release build in $bundle" }

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$zip = Join-Path (Resolve-Path $OutputDir).Path "$name-$Version-windows.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }

$archive = [IO.Compression.ZipFile]::Open($zip, [IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($file in Get-ChildItem -Path $bundle -Recurse -File) {
        # Everything goes under one top-level folder, so unpacking never
        # scatters the app's files into the folder it is unpacked to. Entry
        # names use forward slashes, as the zip format requires.
        $entry = "$($identity.APP_NAME)/" + $file.FullName.Substring($bundle.Length + 1).Replace('\', '/')
        [IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $archive, $file.FullName, $entry, [IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
} finally {
    $archive.Dispose()
}
Write-Host "Built $zip"
