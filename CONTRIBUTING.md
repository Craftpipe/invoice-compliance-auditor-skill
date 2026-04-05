# Contributing

Thanks for your interest in contributing! Here's how to get started.

## Reporting Issues

- Use [GitHub Issues](../../issues) to report bugs or suggest features
- Include steps to reproduce for bugs
- Check existing issues before creating a new one

## Setup

No installation needed. Copy the skill files into your AI tool:

**Claude Code:** Copy to `~/.claude/commands/`
**Cursor:** Copy `.cursor-plugin/` directory to your project
**ClawHub:** Upload via clawhub.com

## Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Make your changes
4. Run tests (see below)
5. Commit with a clear message: `git commit -m "feat: add my feature"`
6. Push and open a Pull Request

## Skill Guidelines

- SKILL.md must be under 2000 tokens
- Instructions must be unambiguous — use "do", "check", "output", never "try to" or "maybe"
- Each step must be specific and actionable
- Trigger patterns must be clear — the AI must know exactly WHEN to use this skill
- No brand names or competitor references

## Testing

- Test the skill by running it through Claude Code or Cursor
- Verify all trigger patterns activate correctly
- Test with edge cases: empty input, unrelated requests, ambiguous prompts
- The skill should gracefully decline unrelated requests

## Architecture

- `SKILL.md` — the skill definition (YAML frontmatter + instructions)
- `.claude-plugin/plugin.json` — Claude Code plugin manifest
- `.cursor-plugin/plugin.json` — Cursor plugin manifest
- `README.md` — installation instructions for all platforms

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
