# Solidity Support 🪙

Configuración de soporte completo para Solidity (Web3) en Neovim con ASDF integration.

## 🎯 Overview

El soporte de Solidity incluye:

- **Language Server**: `solidity-language-server` (Nomic Foundation) para completions, diagnostics, code navigation
- **Formatting**: Detección automática de proyecto Foundry vs Hardhat
- **ASDF Integration**: Resolución automática de herramientas desde `.tool-versions`

## 🛠️ Installation

### Pre-requisitos

```bash
# 1. Install solidity-language-server (LSP)
npm install -g @nomicfoundation/solidity-language-server

# 2. Install Foundry in ASDF (forge formatter)
asdf plugin add foundry https://github.com/llllvvuu/asdf-foundry.git
asdf install foundry latest
asdf set foundry latest

# 3. Install Solidity compiler (solc)
asdf plugin add solidity
asdf install solidity latest
```

### Configuración ASDF

Agregar a `~/.tool-versions` o `.tool-versions` del proyecto:

```
foundry nightly
nodejs 20.17.0
solidity 0.8.34
```

## 🔧 Architecture

### Archivos de Configuración

| Archivo | Propósito |
|---------|-----------|
| `lua/angel/utils/asdf.lua` | Resolución de herramientas ASDF (solidity-language-server, forge) |
| `lua/angel/plugins/lsp/lspconfig.lua` | LSP config para Solidity |
| `lua/angel/plugins/formatting/conform.lua` | Formatter por tipo de proyecto |
| `lua/angel/plugins/syntax/treesitter.lua` | Syntax highlighting |

### Flujo de Detección de Proyecto

```
Abrir archivo .sol
│
├─ Check .tool-versions (ASDF)
│  └─ Resolve forge path si existe
│
├─ Check foundry.toml
│  └─ Usar forge_fmt
│
├─ Check package.json
│  └─ Usar prettier + prettier-plugin-solidity
│
└─ Fallback
   └─ forge si disponible, else prettier
```

## 📝 Usage

### Completions & Diagnostics

- Abrir cualquier archivo `.sol`
- `:LspInfo` - Verificar que Solidity LSP está activo
- Completions automáticos de funciones, variables, estructuras
- Diagnostics del compiler (errors, warnings)
- Hover documentation (`K`)

### Code Navigation

- `gd` - Go to definition
- `gr` - Go to references
- `gi` - Go to implementation
- `<leader>ds` - Document symbols

### Code Actions

- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

### Formatting

Auto-formatting on save basado en typo de proyecto:

**Foundry projects**:
```
project/
├── foundry.toml
├── src/
│   └── MyContract.sol
└── test/
```

Format on save usa `forge fmt`.

**Hardhat/Node projects**:
```
project/
├── package.json
└── contracts/
    └── MyContract.sol
```

Format on save usa `prettier + prettier-plugin-solidity`.

**Manual formatting**:
- `<leader>cf` - Format current file

### Linting

LSP provides diagnostics del Solidity compiler automáticamente.

## 🔍 Troubleshooting

### LSP not attaching

**Check 1**: Verificar que `solidity-language-server` está instalado:

```bash
which nomicfoundation-solidity-language-server
```

**Check 2**: Verificar en Neovim:

```vim
:LspInfo
```

Debería mostrar `solidity_ls` attached al buffer.

**Check 3**: Reinstalar solidity-language-server:

```bash
npm uninstall -g @nomicfoundation/solidity-language-server
npm install -g @nomicfoundation-solidity
```

### Formatter not working

**Check 1**: Verificar tipo de proyecto:

```bash
# Foundry project
ls foundry.toml

# Hardhat project
ls package.json
```

**Check 2**: Verificar forge via ASDF:

```bash
asdf list foundry
forge --version
```

**Check 3**: Verificar LSP formatter disabled:

```vim
:LspInfo
```

Si LSP formatter está activo, lo reemplaza conform. Deshabilitarlo en LSP config o usar `lsp_format = false` en conform.setup.

### Format on save not working

**Check 1**: Verificar conform setup:

```vim
:lua print(vim.inspect(require('conform').list_formatters_to_run()))
```

Debería mostrar los formatters para filetype `solidity`.

**Check 2**: Forzar formato manual:

```vim
:ConformInfo
```

**Check 3**: Verificar ASDF shims:

```bash
asdf reshim foundry
```

### Treesitter no highlighting

**Check 1**: Install Solidity parser：

```vim
:TSInstall solidity
```

**Check 2**: Verify installed parsers:

```vim
:TSInstallInfo
```

## 📚 Examples

Ver `docs/examples/solidity/example-contract.sol` para un contrato completo con features demostrados.

## 🔗 Resources

- [Solidity LSP (Nomic Foundation)](https://github.com/NomicFoundation/hardhat-vscode)
- [Foundry Documentation](https://book.getfoundry.sh/)
- [ASDF Foundry Plugin](https://github.com/llllvvuu/asdf-foundry)
- [Conform.nvim](https://github.com/stevearc/conform.nvim)