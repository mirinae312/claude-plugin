# claude-plugin

A Claude Code plugin.

## Structure

```
claude-plugin/
├── .claude-plugin/
│   └── plugin.json       # Plugin manifest
├── agents/               # Custom subagent definitions
├── commands/             # Simple command files (.md)
├── hooks/
│   └── hooks.json        # Event hooks (PreToolUse, PostToolUse, etc.)
├── scripts/              # Hook and utility scripts
├── skills/
│   └── example/
│       └── SKILL.md      # Example skill
└── settings.json         # Default plugin settings
```

## Development

Test the plugin locally:

```bash
claude --plugin-dir .
```

Invoke a skill:

```
/claude-plugin:example
```

## Installation

```bash
claude plugin install /path/to/claude-plugin --scope project
```
