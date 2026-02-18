# AI/LLM Keybindings Reference

## gen.nvim (Local LLM via Ollama)

### Comandos principales:
- `<leader>g1` — Generate via LLM (modo normal o visual)
- `<leader>g2` — Gen chat session
- `<leader>gm` — Seleccionar modelo Ollama

### Comandos específicos (requieren selección visual):
- `<leader>ge` — **Enhance/refactor code** (refactoriza y mejora código seleccionado)
- `<leader>gr` — **Review code** (encuentra bugs y mejoras)
- `:Gen Explain_Code` — Explica código seleccionado

### Flujo de trabajo:
1. Selecciona código con `V` (visual line mode)
2. Presiona `<leader>ge` o `<leader>gr`
3. Espera respuesta en split horizontal
4. Navega con `<C-w>w` entre código y resultado
5. Copia con `yy`, `V`+`y`, etc.
6. Cierra split con `<C-w>q`
7. Pega en código con `p`

## avante.nvim (Alternative AI Chat)

### Comandos principales:
- `<leader>aa` — Open AI chat panel (funciona en normal y visual)
- `<leader>ac` — Start new conversation (limpia contexto anterior)
- `<leader>at` — Toggle sidebar
- `<leader>ar` — Refresh current chat
- `<leader>aX` — Clear all history (útil si mantiene conversaciones antiguas)

### Keybindings dentro del chat:
- `<CR>` (normal) / `<C-s>` (insert) — Submit prompt
- `co` / `ct` / `ca` / `cb` / `cc` — Diff operations (ours/theirs/all/both/cursor)
- `]x` / `[x` — Next/previous diff hunk
- `]]` / `[[` — Jump to next/previous code block

### Flujo de trabajo:
1. `<leader>aa` — Abre chat
2. Pega código manualmente o escribe pregunta
3. Para nueva conversación sin contexto: `<leader>ac`
4. Para limpiar todo: `<leader>aX`

## Keybindings NO conflictivos

Los siguientes prefijos están reservados y NO se deben usar:

### Git (`<leader>g*`):
- `<leader>gs` — **Git status (Neogit)** ⚠️ NO TOCAR
- `<leader>gf` — Git fetch
- `<leader>gl` — Git pull
- `<leader>gp` — Git push
- `<leader>gP` — Git push force
- `<leader>gc` — Git commit

### Testing (`<leader>t*`):
- `<leader>tt` — Run test file
- `<leader>tr` — Run nearest test
- `<leader>ta` — Run all tests
- etc.

### Align (`<leader>a*` parcial):
- `<leader>a=` — Align by '='
- `<leader>a:` — Align by ':'
- `<leader>a,` — Align by ','

## Configuración

### Cambiar modelo Ollama:
```bash
# En shell config (~/.zshrc):
export LLM_MODEL="qwen2.5-coder:3b"  # o tu modelo preferido
```

### Cambiar display mode de gen.nvim:
En `lua/angel/plugins/tools/gen.lua`:
```lua
display_mode = "split",  -- o "float" para ventana flotante
```

### Activar/desactivar debug:
En `lua/angel/plugins/tools/gen.lua`:
```lua
debug = false,  -- cambia a true para troubleshooting
```

## Modelos recomendados

- **qwen2.5-coder:3b** — Rápido, bajo consumo de memoria (1.9GB)
- **llama3:8b** — Propósito general, balanceado (4.7GB)
- **deepseek-coder-v2:16b** — Avanzado para código (~9GB)

## Troubleshooting

### Gen.nvim no responde:
```bash
# Verificar Ollama:
curl http://localhost:11434/api/tags

# Reiniciar si es necesario:
killall ollama
ollama serve
```

### Limpiar historial de avante:
```vim
<leader>aX  " desde Neovim
```

### Recargar plugins:
```vim
:Lazy reload gen.nvim
:Lazy reload avante.nvim
```
