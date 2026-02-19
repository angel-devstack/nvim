# Git Plugins Module

## Purpose
Git plugins provide conflict resolution operations, diff visualization, and Git operations through Neovim UI. Integrates with standard Git tools.

## Entry Point
`lua/angel/plugins/git/init.lua` imports:
- git-conflict
- gitsigns
- neogit

## Load Triggers

### Git Conflict Resolution (git-conflict)
- `event = "BufReadPost"` - Loads when file read (conflict detection)
- Auto-resolves conflicts: LSP stop on detect, restart on resolve

### Git Diff (gitsigns)
- `event = "VeryLazy"` - Lazy-loaded for performance (~400ms startup gain)

### Git Operations (neogit)
- `cmd = NeoGit` - Only loads when `:NeoGit` command used

## User Actions

### Git Conflict (git-conflict)
- **Conflict detection**: Auto-notifies when merge conflicts detected
- **Resolve conflicts**: Uses standard Git operations (cherry-pick, ours/theirs)
- **Keymaps**:
  - `<leader>co` - Our side (accept current)
  - `<leader>ct` - Their side (accept incoming)
  - `<leader>cb` - Both sides (merge)
  - `<leader>cn` - Next conflict
  - `<leader>cp` - Previous conflict

### Git Diff (gitsigns)
- **Hunk navigation**:
  - `]h` - Next hunk
  - `[h` - Previous hunk
- **Hunk stage**:
  - `ghs` - Stage hunk
  - `ghu` - Unstage hunk
- **Hunk preview**:
  - `ghp` - Preview hunk

### Git Operations (neogit)
- `:NeoGit` - Open Neogit UI
- Standard Git operations within Neovim

## Files

| Plugin | File | Load Trigger | Purpose |
|--------|------|--------------|---------|
| Git conflict | `git-conflict.lua` | `event = "BufReadPost"` | Conflict resolution |
| Gitsigns | `gitsigns.lua` | `event = "VeryLazy"` | Diff visualization |
| Neogit | `neogit.lua` | `cmd = NeoGit` | Git Operations UI |

## Troubleshooting

**Issue**: Conflicts not detected
- Check git-conflict loads: `:Lazy status git-conflict`
- Verify `event = "BufReadPost"` configured
- Check LSP stops/resets on conflict detection

**Issue**: Gitsigns not showing diffs
- Ensure `event = "VeryLazy"` is configured
- Check with `:Lazy status gitsigns`
- Verify git operations work externally

**Issue**: Neogit not opening
- Check `:NeoGit` command exists
- Verify `cmd = NeoGit` is configured

## Future Options

- [ ] Add git-conflict advanced documentation
- [ ] Add Gitsigns keymaps reference
- [ ] Extract neogit to separate plugin doc

---

## Links
- **Plugins**: See individual plugin files for configuration
- **Related**: See [POST-AUDIT-FIXES.md](../../audit/POST-AUDIT-FIXES.md) for conflict resolution docs