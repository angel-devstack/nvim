# 🤝 Contributing to Neovim Configuration

Thank you for your interest in contributing! This guide will help you understand the project structure and contribution workflow.

---

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Conventions](#commit-conventions)
- [Testing Changes](#testing-changes)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)

---

## 🚀 Getting Started

### Prerequisites

- Neovim 0.10+ (recommended 0.11+ for latest features)
- Git
- Basic understanding of Lua
- Familiarity with lazy.nvim plugin manager

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/angel-devstack/nvim.git ~/.config/nvim

# Open Neovim (plugins will auto-install)
nvim

# Verify setup
:checkhealth
```

---

## 📁 Project Structure

```
.
├── docs/                       # 📚 All documentation
│   ├── README.md              # Documentation index
│   ├── user-guide/            # User-facing guides
│   ├── development/           # Developer docs
│   ├── testing/               # Testing guides
│   └── investigations/        # Issue investigations
│
├── lua/angel/
│   ├── core/                  # Core configuration
│   │   ├── options.lua       # Neovim options
│   │   ├── keymaps.lua       # Global keymaps
│   │   └── autocmds.lua      # Autocommands
│   │
│   └── plugins/              # Plugin configurations (organized by category)
│       ├── completion/       # Auto-completion (nvim-cmp)
│       ├── dap/              # Debug adapters
│       ├── editing/          # Editing enhancements
│       ├── formatting/       # Formatters and linters
│       ├── git/              # Git integrations
│       ├── lsp/              # Language servers
│       ├── misc/             # Utilities
│       ├── ruby/             # Ruby-specific plugins
│       ├── syntax/           # Treesitter
│       ├── testing/          # Test runners
│       ├── tools/            # Dev tools
│       └── ui/               # UI plugins
│
└── init.lua                  # Entry point
```

### Directory Organization

Each plugin category has:
- **Individual plugin files** (`plugin-name.lua`)
- **Category `init.lua`** that imports all plugins in the category
- **Main `plugins/init.lua`** that imports all categories

---

## 🔧 Development Workflow

### 1. Create a Branch

Always work in a feature branch:

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

### Branch Naming Convention

- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation updates
- `test/` - Testing improvements

### 2. Make Your Changes

- Keep changes focused and atomic
- Follow the existing code style
- Update documentation as needed
- Test your changes thoroughly

### 3. Commit Your Changes

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git commit -m "feat(lsp): add support for new language server"
git commit -m "fix(dap): resolve breakpoint issue in Ruby files"
git commit -m "docs: update KEYMAP_REGISTRY with new keymaps"
```

---

## 💻 Coding Standards

### Lua Style

- **Indentation**: 2 spaces (no tabs)
- **Line length**: 100 characters max (flexible for readability)
- **Naming**: `snake_case` for variables and functions
- **Comments**: Use `--` for single-line, document complex logic

### Plugin Configuration Pattern

```lua
return {
  "author/plugin-name",
  event = { "BufReadPre", "BufNewFile" },  -- Lazy-load when appropriate
  dependencies = {
    "dependency/plugin",
  },
  config = function()
    local plugin = require("plugin-name")
    
    plugin.setup({
      -- Configuration here
    })
    
    -- Keymaps (if needed)
    vim.keymap.set("n", "<leader>xx", function()
      -- Action
    end, { desc = "Description" })
  end,
}
```

### Key Principles

1. **Lazy-load plugins** when possible (use `event`, `cmd`, `ft`, `keys`)
2. **Document keymaps** with `desc` option
3. **Use `pcall`** for optional dependencies
4. **Keep configs self-contained** in their plugin file
5. **Follow category organization** - don't mix unrelated plugins

---

## 📝 Commit Conventions

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `refactor` - Code refactoring (no functional change)
- `perf` - Performance improvement
- `test` - Adding or updating tests
- `chore` - Maintenance tasks

### Scopes

Match the plugin category or area:
- `lsp`, `dap`, `completion`, `testing`
- `ui`, `editing`, `syntax`, `formatting`
- `git`, `ruby`, `tools`, `misc`
- `docs`, `core`

### Examples

```bash
feat(lsp): add TypeScript language server configuration
fix(dap): resolve connection timeout for Ruby debugger
docs(keymap): update KEYMAP_REGISTRY with new Git commands
refactor(ui): simplify telescope configuration
perf(syntax): optimize treesitter parser loading
```

---

## 🧪 Testing Changes

### Manual Testing

Always test your changes before committing:

```bash
# 1. Test plugin loading
nvim --headless "+Lazy sync" +qa

# 2. Start Neovim and verify
nvim

# 3. Check health
:checkhealth

# 4. Test specific functionality
# (e.g., if you modified LSP, open a file and verify LSP works)
```

### Testing Checklist

- [ ] Neovim starts without errors
- [ ] Affected plugins load correctly
- [ ] Keymaps work as expected
- [ ] No deprecation warnings
- [ ] Documentation is updated
- [ ] Changes don't break existing functionality

### Phase Testing

If adding significant features, create a testing guide:
- See `docs/testing/` for examples
- Document test steps clearly
- Include expected results

---

## 📚 Documentation

### When to Update Documentation

**ALWAYS update documentation when:**
- Adding a new plugin
- Adding/changing keymaps
- Modifying configuration behavior
- Fixing a bug that affects users
- Adding new features

### Files to Update

| Change Type | Files to Update |
|-------------|----------------|
| New keymap | `docs/user-guide/KEYMAP_REGISTRY.md` |
| New plugin | Category `init.lua` + individual plugin file |
| User-facing feature | `docs/user-guide/WARP.md` |
| Bug fix | `docs/user-guide/TROUBLESHOOTING.md` (if relevant) |
| New documentation | `docs/README.md` (add to index) |

### Documentation Style

- Use clear, concise language
- Include code examples
- Use emojis for visual navigation (📚 🔧 ✅ ⚠️ etc.)
- Cross-reference related documents
- Keep docs/README.md index updated

---

## 🔀 Pull Request Process

### Before Submitting

1. ✅ Test your changes thoroughly
2. ✅ Update documentation
3. ✅ Follow commit conventions
4. ✅ Ensure no merge conflicts with main
5. ✅ Review your own changes

### PR Template

```markdown
## Description
Brief description of your changes.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe how you tested your changes.

## Checklist
- [ ] Tested locally
- [ ] Documentation updated
- [ ] Follows commit conventions
- [ ] No breaking changes (or documented if yes)
```

### Review Process

1. Submit PR with descriptive title and details
2. Address reviewer feedback
3. Make requested changes
4. Wait for approval
5. PR will be merged using `--no-ff` (preserves history)

---

## 🎯 Common Contribution Scenarios

### Adding a New Plugin

1. Create plugin file in appropriate category
2. Add lazy-load configuration
3. Add to category's `init.lua`
4. Document keymaps in KEYMAP_REGISTRY.md
5. Test thoroughly
6. Commit with `feat(category): add plugin-name`

### Fixing a Bug

1. Reproduce the issue
2. Identify root cause
3. Make minimal fix
4. Test fix
5. Update TROUBLESHOOTING.md if relevant
6. Commit with `fix(scope): description`

### Updating Documentation

1. Identify what needs updating
2. Make changes
3. Verify links work
4. Update docs/README.md index if needed
5. Commit with `docs(scope): description`

---

## 📞 Getting Help

- **Documentation**: Start with `docs/README.md`
- **Issues**: Check existing issues on GitHub
- **Questions**: Open a discussion on GitHub

---

## 🙏 Thank You

Every contribution helps make this configuration better. Whether you're:
- Fixing a typo
- Adding a feature
- Improving documentation
- Reporting a bug

Your effort is appreciated! 🎉

---

**Last Updated:** 2025-11-09  
**Project Maintainer:** angel-devstack
