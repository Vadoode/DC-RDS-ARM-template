# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

This is an Azure ARM (Azure Resource Manager) Infrastructure-as-Code project that deploys a Windows Domain Controller and 2 RDS servers on Azure. There is no application runtime, no package manager, no build step, and no automated test suite. The codebase consists of:

- `ITSWitch/WindowsVirtualMachine.json` — the main ARM template (24 Azure resources)
- `ITSWitch/WindowsVirtualMachine.parameters.json` — deployment parameters
- `ITSWitch/Deploy-AzureResourceGroup.ps1` — PowerShell deployment script (uses legacy AzureRM module)
- `itsdsc.ps1` — PowerShell DSC configurations for DC and RDS roles

### Required tools

- **Azure CLI** (`az`) — for ARM template validation
- **PowerShell Core** (`pwsh`) — for script analysis and syntax checking
- **arm-ttk** — Azure ARM Template Toolkit (installed at `/tmp/arm-ttk/arm-ttk/arm-ttk/`) for template best-practice checks
- **jq** — for JSON validation (pre-installed)

### Validation commands (lint / test equivalents)

- **JSON syntax check**: `jq empty ITSWitch/WindowsVirtualMachine.json`
- **ARM TTK validation**: `pwsh -Command "Import-Module /tmp/arm-ttk/arm-ttk/arm-ttk/arm-ttk.psd1; Test-AzTemplate -TemplatePath /workspace/ITSWitch/WindowsVirtualMachine.json"`
- **PowerShell lint (Deploy script)**: `pwsh -Command "Invoke-ScriptAnalyzer -Path /workspace/ITSWitch/Deploy-AzureResourceGroup.ps1"`
- **PowerShell lint (DSC script)**: `pwsh -Command "Invoke-ScriptAnalyzer -Path /workspace/itsdsc.ps1"` (DSC `Configuration` blocks produce parse errors on Linux — this is expected since DSC requires Windows)

### Key caveats

- `itsdsc.ps1` uses PowerShell DSC `Configuration` blocks which cannot be fully parsed on Linux. The DSC-related parse errors from PSScriptAnalyzer are expected and not bugs.
- Actual deployment requires an Azure subscription and uses the legacy `AzureRM` PowerShell module (not `Az`). The deployment script cannot be run without Azure credentials.
- The ARM template uses outdated API versions (2015–2018 era) and a deprecated schema (`2015-01-01`). arm-ttk will flag these; they are pre-existing code issues.
