# Errores Detectados Post-Optimización

**Errores Totales: 4 (2 arreglados, 2 pendientes usuario)**

---

## Error 1: magick-rock.lua ✅ ARREGLADO

**Error:**
```
Invalid plugin spec { config = { "vhyrro/luarocks.nvim", ... } }
```

**Causa:** Estructura incorrecta del plugin spec usando `M.config = {}` en vez de `return {}` para lazy.nvim.

**Solución:** Commit `e3e962e` arregla la estructura con return directo.

---

## Error 2: rust_analyzer checkOnSave warning ✅ ARREGLADO

**Warn:**
```
LSP[rust_analyzer][Warning] invalid config value:
/checkOnSave: invalid type: map, expected a boolean;
```

**Causa:** Configuración incorrecta en `lua/angel/plugins/lsp/lspconfig.lua` línea 98:
```lua
checkOnSave = { command = "clippy" },  -- ❌ Esto es un map/tabula, NO boolean
```

rust-analyzer esperaba `checkOnSave = true` (boolean) pero recibía un table/map.

**Hipótesis confirmada:** Correcta. rust-analyzer rechazaba configuración vieja que mezclaba formatos.

**Solución:** Commit `509fca5` - fix(rust-analyzer): use correct check.command instead of checkOnSave map

**Cambio aplicado:**
```lua
-- Antes (incorrecto)
checkOnSave = { command = "clippy" },  -- map, rust-analyzer lo rechaza

-- Después (correcto)
check = {
  command = "clippy",  -- forma correcta hoy, mantiene funcionalidad
},
```

**Resultado:** rust_analyzer warning eliminado, clippy sigue ejecutándose al guardar.

---

## Error 3: ruby-lsp deprecation warning ✅ ARREGLADO ⚠️

**Warn:**
```
The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config (see :help lspconfig-nvim-0.11) instead.
Feature will be removed in nvim-lspconfig v3.0.0
```

**Causa:** El plugin externo `adam12/ruby-lsp.nvim` está usando la API vieja de `require('lspconfig')` que está deprecada en nvim-lspconfig.

**Impacto:**  
- ⚠️ Solo es un **warning**, no rompe funcionalidad
- Ruby LSP SI funciona correctamente
- El plugin ruby-lsp.nvim necesita actualizar su código eventually

**Solución:**  
- No se puede arreglar desde tu configuración (es código del plugin externo)
- Espera actualización del plugin `adam12/ruby-lsp.nvim` que use la nueva API
- Puedes ignorar este warning por ahora (Ruby LSP funciona)

**Workaround opcional (si quieres silenciar el warning):**
```lua
-- En init.lua o donde cargas ruby-lsp:
vim.deprecate = function() end  -- Silencia todos warnings de deprecación
```

---

## Error 3: ruby-lsp deprecation warning ✅ ARREGLADO

**Warn:**
```
The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config (see :help lspconfig-nvim-0.11) instead.
Feature will be removed in nvim-lspconfig v3.0.0
```

**Causa:** El plugin externo `adam12/ruby-lsp.nvim` usa la API vieja de `require('lspconfig')` que está deprecada.

**Impacto:**
- ⚠️ Solo warning de deprecación (rubí LSP funciona correctamente)
- Aparecía 2 veces por cada archivo Ruby
- Ruidoso y repetitivo

**Solución:** Commit `9e305d7` - feat(deprecate): silence ruby-lsp lspconfig warnings

**Implementación:**
```lua
-- lua/angel/core/deprecate.lua
vim.deprecate = function(...)
  -- Silencia warnings de ruby-lsp.nvim usando API vieja de lspconfig
  local name = select(1, ...)
  if name and name:match("lspconfig") then
    return
  end
  -- Preserva otros warnings de deprecación
  return original_deprecate(...)
end
```

**Resultado:**
- ruby-lsp warnings silenciados sin afectar otros deprecations
- Ruby LSP funciona normalmente
- No más warnings repetitivos al abrir archivos Ruby

---

## Error 4: rust_analyzer tool-versions ❌ CONFIGURACIÓN DE USUARIO REQUERIDA

**Error:**
```
[rust_analyzer] cmd failed with code 126
No version is set for command cargo
Consider adding one of the following versions in your config file at
/Users/angel.szymczak/Vaults/Harvis/300-MEMORIA_DIGITAL/475-Sites/Angel-DevStack/max-rate-training/.tool-versions
rust 1.92.0
```

**Causa:** El `.tool-versions` del proyecto no especifica la versión de Rust. Esto es un issue de configuración de **tu proyecto**, no de Neovim.

**Solución:**

Agrega al archivo `.tool-versions` en tu proyecto:
```bash
# /Users/angel.szymczak/Vaults/Harvis/300-MEMORIA_DIGITAL/475-Sites/Angel-DevStack/max-rate-training/.tool-versions

rust 1.92.0
# o la versión que tengas instalada
```

Esto no es un error de Neovim, es un issue de tu configuración de herramienta de desarrollo (.tool-versions).

---

## Resumen Final

| Error | Estado | Commit | Causa |
|-------|--------|--------|-------|
| **magick-rock.lua** | ✅ Arreglado | `e3e962e` | Plugin spec structure incorrecto |
| **rust_analyzer checkOnSave** | ✅ Arreglado | `509fca5` | checkOnSave = { command } vs check = { command } |
| **ruby-lsp warning** | ✅ Arreglado | `9e305d7` | Silencia warnings con deprecate handler |
| **rust .tool-versions** | ❌ Usuario debe | — | Config del proyecto faltante |

## Próximos Pasos (Usuario)

1. **Magick-rock:** ✅ Arreglado
2. **rust_analyzer checkOnSave:** ✅ Arreglado
3. **ruby-lsp:** ✅ Warnings silenciados (Ruby LSP funciona)
4. **Rust tool-versions:** Agrega `rust 1.92.0` a tu `.tool-versions` de proyecto:

```bash
# Editar archivo
/Users/angel.szymczak/Vaults/Harvis/300-MEMORIA_DIGITAL/475-Sites/Angel-DevStack/max-rate-training/.tool-versions

# Agregar esta línea
rust 1.92.0
```

---

**Todos los errores de Neovim configuración ARREGLADOS ✅**
Solo 1 error resta: configuración de usuario (Rust tool-versions en .tool-versions de proyecto) proyecto