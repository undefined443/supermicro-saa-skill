# SAA Server Management Skill

A Claude skill for managing Supermicro servers using SAA (SuperServer Automation Assistant).

## Overview

This skill provides Claude with comprehensive guidance for using SAA to perform server management tasks including:

- Firmware updates (BIOS, BMC, CPLD, GPU, etc.)
- BIOS/BMC configuration management
- System health monitoring and diagnostics
- Power management and control
- Storage and RAID management
- Security operations
- Multi-system batch operations

## Installation

### Claude Code

Copy this skill to your Claude skills directory:

```bash
cp -r saa ~/.claude/skills/
```

Or clone directly:

```bash
git clone https://github.com/undefined443/saa-skill.git ~/.claude/skills/saa
```

### Claude.ai

Upload the skill folder following [Using skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude).

## Structure

```
saa/
├── SKILL.md                      # Main skill instructions
├── README.md                     # This file
├── LICENSE                       # Apache 2.0 License
├── scripts/
│   └── export_help.sh            # Script to regenerate help docs
└── reference/
    ├── saa_help.txt              # Complete saa -h output
    └── commands/                 # Help for each command (217 files)
        ├── UpdateBios.txt
        ├── GetBmcInfo.txt
        └── ...
```

## Usage

Once installed, Claude will automatically use this skill when you ask about Supermicro server management tasks. Examples:

- "How do I update the BIOS on my Supermicro server?"
- "Check the sensor data on BMC at 192.168.1.100"
- "Export the current BMC configuration"
- "What's the command to mount an ISO image?"

## Regenerating Documentation

If SAA is updated, you can regenerate the help documentation:

```bash
cd ~/.claude/skills/saa
./scripts/export_help.sh
```

## Requirements

- SAA (SuperServer Automation Assistant) installed on the system
- Supermicro server hardware with BMC/IPMI support

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

## Related Links

- [SAA User Guide](https://www.supermicro.com/en/solutions/management-software/saa)
- [Supermicro BMC/IPMI Documentation](https://www.supermicro.com/en/support/BMC_Firmware)
- [Claude Skills Documentation](https://support.claude.com/en/articles/12512176-what-are-skills)
