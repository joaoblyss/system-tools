#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Recursively search text files for a pattern.
.DESCRIPTION
    PowerShell port of the bash `findtext` script. Skips binary files by
    scanning for a null byte in the first few KB instead of shelling out to
    `file` per entry, so it does one pass per file instead of two processes.
.PARAMETER Pattern
    Regex pattern to search for.
.PARAMETER Path
    Root directory to search. Defaults to the current directory.
.PARAMETER CaseSensitive
    Match case-sensitively. Default is case-insensitive, like grep -i.
.EXAMPLE
    ./findtext.ps1 "TODO"
.EXAMPLE
    ./findtext.ps1 -Pattern "TODO" -Path C:\src -CaseSensitive
#>
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$Pattern,

    [Parameter(Position = 1)]
    [string]$Path = '.',

    [switch]$CaseSensitive
)

function Test-BinaryFile {
    param([string]$FilePath)

    try {
        $stream = [System.IO.File]::OpenRead($FilePath)
        try {
            $buffer = New-Object byte[] 8192
            $read = $stream.Read($buffer, 0, $buffer.Length)
            for ($i = 0; $i -lt $read; $i++) {
                if ($buffer[$i] -eq 0) { return $true }
            }
            return $false
        } finally {
            $stream.Dispose()
        }
    } catch {
        return $true
    }
}

Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
    if (-not (Test-BinaryFile $_.FullName)) {
        Select-String -Path $_.FullName -Pattern $Pattern -CaseSensitive:$CaseSensitive -ErrorAction SilentlyContinue |
            ForEach-Object {
                "{0}:{1}:{2}" -f $_.Path, $_.LineNumber, $_.Line.Trim()
            }
    }
}
