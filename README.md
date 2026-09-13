# dots — lean, portable, stow-managed

One repo, three stow roots. Only hand-edited configs live here.
Caches, app state, and secrets are never committed (see `.gitignore`).

```
dots/
  home/      # stow -t ~            (.zshrc, .zshenv, .aliases, .gitconfig, …)
  config/    # stow -t ~/.config    (nvim/, i3/, tmux/, zsh/, opencode/, …)
  localbin/  # stow -t ~/.local/bin (scripts; merges ~/bin + .config/bin)
  hosts/     # per-machine overlays, stowed last (arch-desktop/, laptop/, …)
  install.sh # bootstrap: checks deps, stows everything
```

## Fresh machine

```bash
git clone git@github.com:cipherlogs/dots.git ~/dots
cd ~/dots
./install.sh
cp home/zsh/secrets.env.template ~/.config/zsh/secrets.env  # fill in
cp config/environment.d/github_pat.conf.template ~/.config/environment.d/github_pat.conf
gh auth login   # regenerates config/gh/hosts.yml (never committed)
```

Requires `stow` (`sudo pacman -S stow` on Manjaro).

## Rules

- `git add` is explicit per file — never `git add .` (state dirs sit next to configs).
- Secrets go in `*.template` + local-only real file. If a secret touches the
  index, rotate it; history rewrites don't unfire a pushed token.
- Machine-specific stuff (monitors, mimeapps, autostart) goes under `hosts/`.
- Dead apps get removed, not ignored: this repo is curated, not a backup.
