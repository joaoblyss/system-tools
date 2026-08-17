# system-tools

Cross-platform rewrites of personal shell utilities, starting with PowerShell ports of the bash scripts in `bkptc/scripts`.

## Scripts

- `scripts/findtext.ps1` - recursively search text files for a pattern, skipping binaries. PowerShell port of `findtext`.

## Install via Scoop

This repo doubles as a [Scoop](https://scoop.sh) bucket.

```powershell
scoop bucket add system-tools https://github.com/joaoblyss/system-tools
scoop install system-tools/findtext
```

Then run it as `findtext.ps1 <pattern> [path] [-CaseSensitive]`.
