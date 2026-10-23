# Reads the identity of an app from devops\apps\<app>.env into a hashtable.
# Usage: . devops\apps\profile.ps1; $app = Read-AppProfile deberc
function Read-AppProfile([string]$Name) {
    $file = Join-Path $PSScriptRoot "$Name.env"
    if (-not (Test-Path $file)) { throw "No app profile at $file" }
    $profile = @{}
    foreach ($line in [IO.File]::ReadAllLines($file, [Text.Encoding]::UTF8)) {
        if ($line.Trim() -eq "" -or $line.TrimStart().StartsWith("#")) { continue }
        $key, $value = $line.Split("=", 2)
        $profile[$key.Trim()] = $value.Trim().Trim('"')
    }
    return $profile
}