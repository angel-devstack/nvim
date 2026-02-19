# Neogit Plugin

## Purpose
Neogit provides Git operations UI directly in Neovim. Manage branches, commit, stage, push, pull without leaving editor. Intuitive interface similar to LazyGit.

## Keymaps
- `:NeoGit` - Open Neogit UI

## Configuration
- See `lua/angel/plugins/git/neogit.lua` for setup
- Integrates with Gitsigns (diff visualization), Mason.

## Usage Patterns

### Git operations in Neovim
- Open Neogit: `:NeoGit`
- Switch branches: Branches → Select branch → Checkout
- Stage files: Files → Stage → Commit
- Push/Pull: Pull → Push button

### Branch management
- Create new branch: Branches → New
- Switch branches: Branches → Checkout
- Merge branches: Git command (merge, rebase, cherry-pick)

### Commit interface
- Stage/Unstage files: Files tab → Stage/Unstage
- Write commit message: Commit → Write message → C-c
- Push to remote: Pull → Push

### Merge conflict resolution
- Detect conflicts automatically (git-conflict integration)
- Open conflicted file: Neogit → Select file
- Resolve: Use Git commands (cherry-pick, ours, theirs)
- Reload: Re-open file to confirm resolution

## Features

### Differential visualization
- Gitsigns (already configured): `]h/[h` navigate hunks
- git-conflict (already configured): Auto-notifies on conflict

### Auto-detection
- Detects Git repository automatically
- Shows branch, commit, status in Neogit UI
- Integrations: Mason (tool installation), LSP (conflict handling)

## Troubleshooting

**Issue**: Neogit not opening
- Check `cmd = NeoGit` configured
- Verify Git repository exists: `git status`
- Ensure neogit loads: `:Lazy status neogit`

**Issue**: Conflicts not detected
- Check git-conflict integration: `lua/angel/plugins/git/git-conflict.lua`
- Verify `BufReadPost` event configured

**Issue**: Push/Pull not working
- Check Git credentials configured
- Test manually: `git push`, `git pull`

---

## Links
- **Configuration**: See `lua/angel/plugins/git/neogit.lua`
- **Related**: See `docs/lua/angel/plugins/git/README.md` (git plugins overview)