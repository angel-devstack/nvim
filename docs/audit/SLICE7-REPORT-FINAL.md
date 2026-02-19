# Slice 7 - UI/Visual: Reporte Final

**Fecha:** 2026-02-19  
**Status:** ✅ Completado  
**Impacto de startup:** 0ms (sin cambios de lazy-load)

---

## Resumen

Slice 7 (UI/Visual) concluyó sin cambios de lazy-loading debido a decisiones de usuario sobre usabilidad inmediata. Se añadieron mejoras funcionales: soporte completo de mouse y guías de longitud para mejorar la experiencia de edición.

---

## Preguntas y Respuestas del Usuario

### 1. nvim-scrollbar

**Pregunta:** ¿Usas scrollbar con mouse regularmente?
- **Respuesta:** Sí, uso scrollbar. Quiero que responda al movimiento de la rueda vertical y, si possible, también a la horizontal (mouse es MX Master 3 Mac)
- **Decisión:** Mantener `event = "BufReadPost"` (sin cambio de lazy-load)
- **Acción implementada:** Habilitar `opt.mouse = "a"` en `options.lua` para soporte completo de mouse en todos modos

### 2. colorscheme

**Pregunta:** ¿Tema es ligado o cosmético?
- **Respuesta:** Crítico
- **Decisión:** Mantener `lazy = false` (sin cambio - ya configurado correctamente)
- **Acción implementada:** No se necesita cambio (configuración actual correcta)

### 3. indent-blankline

**Pregunta:** ¿Usas indent guides regularmente?
- **Respuesta:** Frecuentemente. Me gusta ver las guías inmediatamente. Además, me gustaría tener una guía "rule" a los 80 y otro a los 100 caracteres de longitud (es posible tener 2?, sino con el de 80 estamos bien)
- **Decisión:** Mantener `event = { "BufReadPre", "BufNewFile" }` (sin cambio)
- **Acción implementada:** Agregar `opt.colorcolumn = "80,100"` en `options.lua` para guías de longitud vertical

---

## Cambios Implementados

### Archivos Modificados

| Archivo | Cambio | Commit |
|---------|--------|--------|
| `lua/angel/core/options.lua` | Agregar `opt.mouse = "a"` para soporte completo de mouse | e7afd9f |
| `lua/angel/core/options.lua` | Agregar `opt.colorcolumn = "80,100"` para guías de longitud | e7afd9f |

### Archivos Sin Cambios (Configuración Correcta)

| Archivo | Razón |
|---------|--------|
| `lua/angel/plugins/ui/nvim-scrollbar.lua` | `event = "BufReadPost"` es correcto (carga inmediata para responder al mouse) |
| (colorscheme en otros archivos) | `lazy = false` es correcto (tema es crítico, ya configurado) |
| `lua/angel/plugins/ui/indent-blankline.lua` | `event = { "BufReadPre", "BufNewFile" }` es correcto (carga inmediata para ver guías) |

---

## Detalles Técnicos

### nvim-scrollbar

**Configuración actual:**
```lua
return {
  "petertriho/nvim-scrollbar",
  event = "BufReadPost",  -- Carga inmediata en cada buffer
  config = function()
    require("scrollbar").setup()
  end,
}
```

**Por qué esta configuración es correcta:**
- nvim-scrollbar no está en lista de offenders de startup según baseline
- `event = "BufReadPost"` asegura que el scrollbar esté disponible inmediatamente cuando abres un archivo
- Con `opt.mouse = "a"`, el scrollbar y mouse wheel (vertical y horizontal) funcionan correctamente
- MX Master 3 Mac tiene rueda horizontal que ahora está soportada

**Funcionamiento esperado:**
- Rueda vertical del mouse: Navegación hacia arriba/abajo en buffer
- Rueda horizontal (MX Master 3): Desplazamiento horizontal en líneas largas con `nowrap` activado
- Click y drag en scrollbar: Desplazamiento rápido a posición específica

### colorscheme (tema dark)

**Configuración actual:** El tema está configurado en archivos separados (ver `lua/angel/plugins/ui/colorscheme.lua` para lazy=false configuration correcta)

**Por qué esta configuración es correcta:**
- `lazy = false` es necesario para que el tema cargue antes de cualquier plugin UI
- Sin el tema cargado, los plugins UI (luline, telescope, neogit) mostrarían colores incorrectos o glitch
- El usuario confirmó que el tema es **crítico** no cosmético

**Nota:** No se modificó ningún archivo de colorscheme ya que la configuración es correcta según el usuario.

### indent-blankline (guías de longitud)

**Configuración actual:**
```lua
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },  -- Carga inmediata
  main = "ibl",
  opts = {
    indent = { char = "┊" },
    scope = { enabled = true },
    exclude = {
      filetypes = {
        "help", "alpha", "dashboard", "lazy", "neogitstatus",
        "Trouble", "toggleterm", "lazyterm",
      },
    },
  },
}
```

**Por qué esta configuración es correcta:**
- `event = { "BufReadPre", "BufNewFile" }` carga indent-blankline inmediatamente
- El usuario confirmó que **frecuentemente usa** indent guides
- Ver las guías inmediatamente es importante para la fluidez de programación

**Guías de longitud (80 y 100 columnas):**

Las guías de longitud se implementan con la opción nativa de Neovim `opt.colorcolumn = "80,100"`:

```lua
opt.colorcolumn = "80,100"  -- Line length rulers
```

**Funcionamiento:**
- Columna 80: Línea vertical sutil marcando límite PEP8 para Python y estándar de 80 chars
- Columna 100: Segunda línea vertical para límites más largos (100 chars)
- Las columnas se resaltan con el highlight `ColorColumn` (normalmente fondo sutil)
- Solo se muestra cuando la línea excede esas columnas

**Compatibilidad:**
- No interfiere con indent-blankline (guías separadas de guía de línea)
- Funciona en todos filetypes (configuración global)
- `ColorColumn` highlight se puede personalizar en `lua/angel/core/colors.lua` si se desea

---

## Impacto en Performance

### Startup Time
- **Sin cambios de lazy-load:** 0ms ganancia/pérdida
- **Baseline 156ms:** Sin cambios (todos plugins UI/Visual mantienen configuraciones existentes)
- **Total acumulado:** ~900ms ganancia (DAP ~500ms + Gitsigns ~400ms)

### Runtime Performance
- **opt.mouse = "a":** Sin impacto (habilitado por defecto en muchos setups)
- **opt.colorcolumn = "80,100":** Sin impacto (highlight nativo muy ligero)
- **nvim-scrollbar:** Sin cambio ( ya estaba presente, ahora responde mejor al mouse)

### Esperado
1. **Mouse wheel vertical:** Rueda del mouse MX Master 3 ahora responde en Neovim
2. **Mouse wheel horizontal:** Si `nowrap = true` está activado, rueda horizontal del MX Master 3 desplaza horizontalmente
3. **Scrollbar interactivos:** Click y drag en scrollbar ahora funciona correctamente
4. **Guías de longitud visibles:** Líneas excediendo 80 y 100 chars se resaltan inmediatamente

---

## Keymaps

No agregados keymaps nuevos. Sin embargo, se habilita la interacción completa del mouse:

- **Scroll vertical:** Rueda hacia arriba/abajo del mouse
- **Scroll horizontal:** Rueda lateral del MX Master 3 (requiere `nowrap = true` y contenido largo)
- **Click en scrollbar:** Salta a posición de buffer
- **Drag scrollbar:** Desplaza rápidamente a posición específica

---

## Documentación Actualizada

**Creado:**
- `docs/audit/SLICE7-REPORT-FINAL.md` (este archivo)

**Actualizado:**
- No requiere actualización de keymap registry (sin nuevos keymaps)

---

## Commit Implementado

```
e7afd9f feat(core): enable mouse and line length rulers

- Enable opt.mouse = 'a' for full mouse support (vertical+horizontal wheel)
- Add opt.colorcolumn = '80,100' for line length rulers at 80 and 100 columns
- Scrollbar now responds to mouse wheel on MX Master 3 Mac
```

---

## Conclusión

Slice 7 concluiu con:
- **Sin cambios de lazy-load** (prioridad en usabilidad inmediata sobre startup time)
- **Mejoras funcionales agregadas** (mouse enable, rulers de longitud)
- **Decisiones basadas en el usuario** (frecuencia de uso vs performance)

Slices restantes (8-10):
- **Slice 8: QoL** (surround, comment, endwise, autopairs, textobjects)
- **Slice 9: Editing** (substitute, splitjoin, etc.)
- **Slice 10: Additional plugins** (opencode, rest, obsidian, markdown, etc.)

**Total de commits de Slice 7:** 1

**Siguiente Slice:** Slice 8 - Quality of Life