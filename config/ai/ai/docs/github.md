# GitHub

- For GitHub work, including repositories, issues, pull requests, Actions, releases, code search, or GitHub documentation, prefer the `github` MCP server when available.
- Use the `gh` CLI only as a fallback when GitHub MCP is missing or disabled.
- Never hardcode tokens; use the `GITHUB_PAT_TOKEN` environment variable.
- Before creating an issue, search for duplicates.
- When closing an issue, always set a reason.
- For pull request reviews with line-specific comments, create a pending review, add comments to it, then submit it.
- Before creating a pull request, look for a pull request template and follow it.
