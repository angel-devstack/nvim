# Plugin Specs vs Modules with setup()

## ⚠️ ERROR: "Invalid plugin spec { setup = <function 1> }"

Este error ocurre cuando pasamos **módulos con `M.setup()`** en lugar de **plugin specs** a `lazy.nvim`.

## Lazy expects TWO different things:

### ✅ CORRECTO Plugin Spec:

```lua
-- Archivo: lua/angel/plugins/lsp/mason.lua
return {
  "williamboman/mason.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function() ... end,
}
-- Resultado: { "repo", "dependencies", "config" } - válido ✅
```

OR

```lua
-- Archivo: lua/angel/plugins/init.lua
return {
  { import = "angel.plugins.core" },
  { import = "angel.plugins.lsp" },
}
-- Resultado: { "import", "import", ... } } - válido ✅
```

### ❌ INCORRECTO (Module with setup):

```lua
-- Archivo: lua/angel/plugins/lsp/bundler_hook.lua
local M = {}
function M.setup() ... end
return M

-- Al importar con { import = "angel.plugins.lsp.bundler_hook" },
-- lazy intenta buscar un archivo con return { { plugin1, ... }, }
-- Pero encontró return M que es MODULE, no SPEC
```

## Reglas:

1. **return { "repo", ... }** ✅ - Plugin spec válido
2. **return { import = "..." }** ✅ - Importa módulo que DEBE devolver specs
3. **local M = {}; return M** ❌ - NO es un plugin spec si se usa directamente

---

## ¿Cuándo usar M.setup()?

**NUNCA en plugin specs directos.**

M.setup() debe usarse ASI cuando:
- Es un módulo interno que NO es un plugin (ej: módulo de utilidades)
- Se carga en el config de OTRO plugin que SÍ es un spec válido

**Ejemplo WRONG:**
```lua
-- ❌ Esto NO es un plugin spec
return {
  "my-plugin/utils.lua",  -- archivo, no plugin spec
  -- lazy intenta leer pero no es "repo" ni "import"
}
```

**Ejemplo CORRECTO:**
```lua
-- ✅ Archivo con utils (no es plugin spec)
-- El plugin SPEC que lo importa usa este archivo
require("my-plugin/internal.lua")  -- en otro plugin spec válido
```

---

## Ejemplo Real de Error Causado:

```lua
-- ❌ ruby-lsp.nvim/venv-lsp.nvim - COMO plugins
return { ... }  -- ESTO ES CORRECTO

-- ❌ MI código duplicado (bundlers_hook.lua, python_venv_hook.lua)
local M = {}
function M.setup() ... end
return M
-- NO es plugin spec

-- ❌ Causó: { setup = <function> } } error al importar
```

## Conclusión:

- NO escribir archivos con `local M = {}` que se pasan directamente a lazy.setup()
- Solo usar `{ "repo", ... }` o `{ import = "..." }` en plugins
- Los módulos internos con `M.setup()` deben ser cargados por plugins NORMALES, no directamente

---

**Next:** Usar plugins ruby-lsp/venv-lsp built-in (ya tienen Bundler/venv detection) en lugar de re-implementar.