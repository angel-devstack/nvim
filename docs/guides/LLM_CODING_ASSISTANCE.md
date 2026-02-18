# Guía de Asistencia de Código con LLM

Esta guía proporciona documentación completa para usar **opencode.nvim** — el asistente de codificación con IA integrado en esta configuración de Neovim.

---

## 🎯 Descripción General

**opencode.nvim** es un asistente de IA que conecta Neovim con [OpenCode](https://github.com/sst/opencode), habilitando investigación, revisiones y generación de código con conciencia del contexto. Proporciona una interfaz TUI (Terminal User Interface) similar a GitHub Copilot Chat o Cursor, con rica conciencia del contexto.

**Características Clave:**
- 🤖 Soporte para *cualquier* backend de LLM (OpenCode puede usar Claude, OpenAI, modelos locales, etc.)
- 📋 Compartir contexto (buffer, cursor, selección, diagnósticos, git diff, marcas)
- 🎯 Prompts inteligentes (biblioteca pre-construida + prompts personalizados)
- 🔄 Recargas de buffer en tiempo real (las ediciones aparecen instantáneamente)
- 🖥️ Integración con la línea de estado para monitoreo de sesiones
- ⌨️ Interfaz nativa de Vim (rangos, repetición con punto)

---

## ⌨️ Combinaciones de Teclas

### Combinaciones Primarias

| Tecla       | Modo(s)       | Acción                     | Descripción                                 |
|-------------|---------------|----------------------------|---------------------------------------------|
| `<C-a>`     | Normal, Visual | Preguntar a opencode      | Prompt rápido con contexto `@this`          |
| `<C-x>`     | Normal, Visual | Ejecutar acción opencode… | Abrir paleta de comandos completa           |
| `<C-.>`     | Normal, Terminal | Activar/desactivar opencode | Iniciar/detener sesión opencode            |
| `ga`        | Normal, Visual | Agregar a opencode         | Agregar selección o línea del cursor al contexto |
| `<S-C-u>`   | Normal       | Desplazar opencode arriba  | Desplazar sesión opencode media página arriba |
| `<S-C-d>`   | Normal       | Desplazar opencode abajo  | Desplazar sesión opencode media página abajo |

**Nota:** `<Space>` es tu tecla líder (super key). Puedes usar `<Space>a` en lugar de `<C-a>`, `<Space>x` en lugar de `<C-x>`, etc.

**Notas Adicionales sobre el Líder:**
- Tu tecla líder configurada es `<Space>` (barra espaciadora)
- Solo presiona la barra espaciadora + tecla del comando para acortos
- Ejemplo: `<Space a>` (Space + a) es equivalente a `<C-a>` (Ctrl + a)

---

## 🚀 Inicio Rápido

### 1. Flujo de Trabajo Básico

```vim
" Hacer una pregunta (modo normal)
<Space>a          " Abre prompt, escribe tu pregunta, presiona Enter
                  " (o usa <C-a> como atajo directo)

" Preguntar sobre código seleccionado (modo visual)
V                 " Entra a modo visual por línea
<Space>a          " Pregunta a opencode sobre la selección
                  " (o <C-a> como atajo directo)

" Seleccionar de todas las acciones
<Space>x          " (O <C-x>) Abre selector de acciones
```

### 2. Prompts Comunes

La configuración de `opencode.nvim` incluye prompts pre-construidos para tareas comunes:

| Nombre Prompt | Descripción                                | Patrón de Uso            |
|---------------|--------------------------------------------|--------------------------|
| `review`      | Revisar código por corrección y legibilidad | `ga` → Escribir `review` |
| `explain`     | Explicar código y contexto                | `ga` → Escribir `explain`|
| `fix`         | Arreglar diagnósticos                     | `ga` → Escribir `fix`    |
| `refactor`    | Optimizar para rendimiento y legibilidad  | `ga` → Escribir `refactor`|
| `document`    | Agregar comentarios de código             | `ga` → Escribir `document`|
| `implement`   | Implementar función/clase basado en selección| `ga` → Escribir `implement`|
| `test`        | Generar pruebas                            | `ga` → Escribir `test`   |

---

## 📝 Flujos de Trabajo Detallados

### Flujo de Trabajo 1: Revisión de Código

**Objetivo:** Que la IA revise una función o bloque de código.

```vim
" 1. Navega al código que quieres revisar
" 2. Selecciónalo en modo visual (V para modo por línea, o v para modo por carácter)
" 3. Presiona <Space>a para abrir prompt de pregunta (o <C-a>)
" 4. Escribe: review
" 5. Presiona Enter
" 6. Lee el feedback de la IA en terminal opencode
" 7. Usa <S-C-u> / <S-C-d> para desplazar si es necesario
```

**Resultado:** La IA analiza el código buscando bugs, problemas de estilo, problemas de rendimiento y sugiere mejoras.

### Flujo de Trabajo 2: Arreglar Bugs con Diagnósticos

**Objetivo:** Dejar que la IA arregle diagnósticos de LSP/Compilador automáticamente.

```vim
" 1. Posiciona el cursor en un diagnóstico (ver output de: [d / ]d)
" 2. Ejecuta :lua vim.diagnostic.open_float() para ver el error
" 3. Presiona <Space>a (o <C-a>)
" 4. Escribe: fix diagnostics
" 5. Presiona Enter
" 6. La IA analiza diagnósticos y propone soluciones
" 7. Aplica cambios sugeridos (opencode puede editar archivos directamente)
```

### Flujo de Trabajo 3: Refactorización

**Objetivo:** Mejorar calidad de código preservando funcionalidad.

```vim
" Paso 1: Selecciona el código a refactorizar
Vj                " Selecciona línea actual y siguiente (ejemplo)

" Paso 2: Pregunta a opencode
<Space>a          " (o <C-a>)

" Paso 3: Escribe una solicitud específica de refactorización
refactor this function to use async/await pattern, keep error handling

" Paso 4: Revisa respuesta de la IA con vista diff
" Paso 5: Acepta o aplica cambios
```

### Flujo de Trabajo 4: Generar Pruebas

**Objetivo:** Auto-generar pruebas para código seleccionado.

```vim
" Paso 1: Selecciona la función/clase que quieres probar
V5j               " Selecciona 6 líneas (ejemplo)

" Paso 2: Pregunta por pruebas
<Space>a          " (o <C-a>)
test

" Paso 3: La IA genera casos de prueba apropiados
" Paso 4: Copia/pega las pruebas generadas en tu archivo de pruebas
```

### Flujo de Trabajo 5: Explicar Código

**Objetivo:** Entender código no familiar o explicarlo a un colega.

```vim
" Paso 1: Selecciona código complejo
V10G              " Selecciona desde cursor hasta final de buffer

" Paso 2: Pregunta por explicación
<Space>a          " (o <C-a>)
explain this in simple terms, focus on the business logic

" Paso 3: La IA proporciona explicación clara con contexto
```

### Flujo de Trabajo 6: Implementar desde Documentación

**Objetivo:** Implementar una función basada en descripción o comentarios.

```vim
" 1. Escribe un comentario describiendo lo que quieres
-- function: calculate fibonacci recursively with memoization

" 2. Selecciona el comentario
V

" 3. Pregunta a opencode
<Space>a          " (o <C-a>)
implement

" 4. La IA genera la implementación completa
```

---

## 🎯 Placeholders de Contexto

`opencode.nvim` usa placeholders especiales para inyectar contexto en tus prompts:

| Placeholder     | Qué proporciona                              | Ejemplo de uso                                      |
|-----------------|----------------------------------------------|-----------------------------------------------------|
| `@this`         | Rango de operador o selección, o posición del cursor | `review @this for bugs`                           |
| `@buffer`       | Buffer actual completo                        | `explain @buffer`                                  |
| `@buffers`      | Todos los buffers abiertos                     | `compare code patterns across @buffers`            |
| `@visible`      | Líneas actualmente visibles                   | `debug @visible`                                    |
| `@diagnostics`  | Diagnósticos LSP en buffer actual             | `fix @diagnostics`                                  |
| `@diff`         | Git diff (cambios sin preparar)               | `review @diff for correctness`                      |
| `@marks`        | Marcas globales                               | `summarize @marks`                                  |

**Ejemplo:**

```vim
-- En modo visual sobre código seleccionado:
<Space>a>review the function logic in @this, check for edge cases
" (o <C-a>)

-- En modo normal:
<Space>a>fix all @diagnostics with appropriate solutions
```

---

## 🎨 Uso Avanzado

### Método 1: Usando Ask (`<C-a>` o `<Space>a`)

La función `ask()` proporciona un prompt con completado y resaltado:

```vim
-- Uso básico
<Space>a          " En modo normal: pregunta sobre archivo completo
" (o <C-a> como atajo)
-- Escribe: explain this function

-- Con selección visual
V<Space>a         " (o <C-a>) Selección visual + pregunta
-- Escribe: refactor this using functional approach
```

**Características:**
- `<Up>` para navegar preguntas recientes
- `<Tab>` para activar completado de contexto
- Presionar `\n` (nueva línea) al final del prompt agrega en lugar de enviar

### Método 2: Usando Select (`<C-x>` o `<Space>x`)

La función `select()` abre un selector con toda la funcionalidad de opencode:

```vim
<Space>x          " Abre selector
" (O <C-x>)
-- Puedes buscar y seleccionar:
--  - Prompts integrados (review, explain, fix, etc.)
--  - comandos opencode
--  - controles del proveedor (iniciar/parar, nueva sesión)
```

**Uso:**
1. Presiona `<Space>x` (o `<C-x>`)
2. Escribe para buscar (ej., "review", "new session")
3. `Enter` para seleccionar

### Método 3: Usando Operador (`ga`)

La función `operator()` envuelve prompts como operadores de Vim:

```vim
-- Agregar rango seleccionado al contexto
V                 " Selección visual
ga                " Agregar a opencode
review

-- O en modo normal, agregar línea actual
ga
review

-- ¡Repetición con punto funciona!
```

**Tip:** Usa con operadores de rango:

```vim
ga                " Modo operador pendiente
j10               " Aplicar a las siguientes 10 líneas
-- Pregunta automáticamente
```

### Método 4: Usando Prompts Personalizados

Puedes definir tus propios prompts en tu configuración:

```lua
-- En tu init.lua o configuración de plugin
vim.g.opencode_opts = {
  prompts = {
    rust_optimize = {
      prompt = "Optimizar este código Rust para rendimiento, mantener funcionalidad intacta: @this",
    },
    rails_security_check = {
      prompt = "Revisar este código Rails por vulnerabilidades de seguridad (inyección SQL, XSS, problemas auth): @this",
    },
  },
}
```

Luego úsalos:

```vim
ga
rust_optimize    " Tu prompt personalizado
```

---

## 🔧 Configuración

### Configuración Básica

La configuración por defecto ya está en `lua/angel/plugins/tools/opencode.lua`:

```lua
return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    vim.g.opencode_opts = {}
    vim.o.autoread = true

    -- Los keymaps se configuran automáticamente
    -- Ver: lua/angel/plugins/tools/opencode.lua
  end,
}
```

### Opciones Avanzadas

Opciones disponibles `opencode_opts` (de la documentación oficial):

```lua
vim.g.opencode_opts = {
  prompts = {},            -- Prompts personalizados
  provider = {            -- Cómo se lanza opencode
    enabled = "terminal",  -- o "snacks", "kitty", "wezterm", "tmux"
  },
  events = {              -- Manejo de eventos
    reload = true,        -- Auto-recargar archivos editados
  },
}
```

### Ejemplos de Proveedores

La opción `provider` controla cómo se lanzan las sesiones opencode:

#### Proveedor Terminal (Por Defecto)
```lua
provider = { enabled = "terminal", terminal = {} }
```

#### Proveedor Snacks Terminal
```lua
provider = { enabled = "snacks", snacks = {} }
```

#### Proveedor Tmux
```lua
provider = { enabled = "tmux", tmux = {} }
```

---

## 🌐 Integración con Línea de Estado

opencode.nvim proporciona un componente de línea de estado para rastrear estado de sesión:

```lua
-- Ejemplo de integración lualine
require("lualine").setup({
  sections = {
    lualine_z = {
      { require("opencode").statusline },
    }
  }
})
```

**Indicadores de estado:**
- 🤖 Sesión activa ejecutándose
- 💤 Sesión inactiva (esperando entrada)
- ⚡ Procesando solicitud
- ✨ Editando en progreso

---

## 🎯 Mejores Prácticas

### 1. Ingeniería de Prompts

**Sé específico:**

```vim
-- ❌ Demasiado vago
<Space>a>fix this

-- ✅ Solicitud clara
<Space>a>Fix this function to handle the case where user is nil, add proper error handling
```

**Incluye contexto:**

```vim
-- Usa @this y otros placeholders
<Space>a>Explain @this in the context of the user authentication flow
```

**Refinamiento iterativo:**

```vim
-- Primero pregunta por panorama general
<Space>a>Explain how this authentication works

-- Luego pregunta específico
<Space>a>What happens if the JWT token expires?
```

### 2. Gestión de Sesiones

```vim
-- Iniciar sesión nueva
<Space>x          " Selecciona "session.new" en selector

-- Compartir sesión (obtener URL)
<Space>x          " Selecciona "session.share"

-- Compactar sesión (reducir contexto)
<Space>x          " Selecciona "session.compact"
```

### 3. Manejo de Permisos

Cuando opencode intenta editar archivos, pedirá permiso:

```
[opencode] ¿Permitir edición de file.lua? [y/N]
```

**Tip:** Di `y` para dejar que opencode edite directamente. El plugin recargará el buffer automáticamente.

### 4. Tips de Eficiencia

- **Usa modo visual para consultas enfocadas:** Selecciona solo lo que necesitas
- **Pre-selecciona rangos apropiados:** Usa `V` para líneas, `vi"` para strings, etc.
- **Verifica diagnósticos primero:** Ejecuta `:lua vim.diagnostic.open_float()` para ver errores
- **Revisa antes de aplicar:** Lee siempre sugerencias de la IA antes de aceptar

### 5. Pitfalls Comunes

```vim
-- ❌ No preguntes sobre código no relacionado
<Space>a>Explain how payment processing works

-- ✅ Selecciona código de pagos primero
V10j
<Space>a>Explain how this payment flow works
```

```vim
-- ❌ No sobrecargues contexto con selecciones enormes
V100G             " Seleccionar 1000+ líneas puede confundir a la IA

-- ✌️ Empieza pequeño, itera
V10G
<Space>a>Review first
-- Luego haz preguntas de seguimiento
```

---

## 🧪 Escenarios de Ejemplo

### Escenario 1: Depuración de Prueba Fallida

```vim
" 1. Ejecuta la prueba fallida
<Space>tr         " Ejecuta test bajo cursor

" 2. Mira el output de error
<Space>to        " Revisa output de test

" 3. Ve a la función fallida
gd               " Ir a implementación de test

" 4. Pregunta a opencode arreglarla
V<Space>a        " (o <C-a>)
fix: this test is failing with Assertion Error, the expected behavior is X but got Y
```

### Escenario 2: Aprendiendo una Nueva Codebase

```vim
" 1. Abre el punto de entrada principal
:Telescope find_files
-- Selecciona main.rb

" 2. Pregunta por panorama
<Space>a>Explain @buffer en 3 oraciones: qué hace este archivo, cuáles son los componentes principales?

" 3. Profundiza en partes específicas
V5j
<Space>a>Explain @this en el contexto de la arquitectura general de la aplicación

" 4. Sigue referencias
gd
<Space>a>Explain how this integrates with the rest of the system
```

### Escenario 3: Refactorizar Código Legado

```vim
" 1. Encuentra función compleja
/complex_function
<CR>

" 2. Selecciona y pide modernización
Va{
<Space>a>refactor: modernizar esto usando async/await, preservar todo el error handling, agregar comentarios

" 3. Revisa y aplica cambios
```

### Escenario 4: Agregar Nuevas Funcionalidades

```vim
" 1. Escribe un comentario describiendo la característica
-- Agregar: rate limiting a API endpoint, return 429 cuando se exceda

" 2. Selecciona el comentario
V

" 3. Pide implementación
<Space>a>implement

" 4. Revisa y ajusta según sea necesario
```

---

## 🔍 Solución de Problemas

### opencode No Responde

```vim
" Verificar si opencode está ejecutándose
<Space>.          " (O <C-.>) Activar

" Verificar health
:checkhealth opencode
```

### Las Ediciones No Aparecen

```vim
" Asegurar que autoread esté habilitado
:set autoread?

" Recargar manualmente si es necesario
:e
```

### Problemas de Conexión

```bash
# Verificar si opencode es accesible
curl http://localhost:11434/health

# Si usas LLM local, revisa Ollama
curl http://localhost:11434/api/tags
```

### Tiempos de Respuesta Lentos

- Usa selecciones más pequeñas (no selecciones archivos enteros)
- Compacta la sesión antes de preguntar
- Considera usar un modelo más rápido (ej. 3B vs 16B)

---

## 📚 Recursos Adicionales

- **opencode.nvim GitHub:** https://github.com/NickvanDyke/opencode.nvim
- **OpenCode Project:** https://github.com/sst/opencode
- **Referencia de Configuración:** Ver `lua/opencode/config.lua` en el plugin
- **Guías Relacionadas:**
  - [WARP.md](../user-guide/WARP.md) — Configuración completa y comandos
  - [KEYMAP_REGISTRY.md](../user-guide/KEYMAP_REGISTRY.md) — Todos los keymaps

---

## 🆚 Comparación con Otras Herramientas de IA

| Característica                    | opencode.nvim | AI_KEYBINDINGS.md (depreciado) |
|-----------------------------------|---------------|------------------------------|
| Desarrollo Activo                 | ✅ Sí (v0.3.0 más reciente) | ❌ No |
| Conciencia de Contexto           | ✅ Rica (@this, @buffer, etc.) | ⚠️ Limitada |
| Prompts Personalizados           | ✅ Configurable | ⚠️ Estáticos |
| Gestión de Sesiones              | ✅ Múltiples sesiones | ⚠️ Limitada |
| Ediciones en Tiempo Real         | ✅ Recarga buffers auto | ❌ No |
| Línea de Estado                  | ✅ Soporte nativo | ❌ No |

**Nota:** Los plugins `gen.nvim` y `avante.nvim` mencionados en esta configuración fueron eliminados en favor de opencode.nvim. Ver el commit: `refactor(tools): remove redundant AI assistants (gen.nvim, avante.nvim)`

---

## 🎓 Checklist de Inicio

- [ ] Verificar instalación de opencode: `:checkhealth opencode`
- [ ] Iniciar opencode: `<Space>.` (o `<C-.>`)
- [ ] Probar pregunta básica: `<Space>a` (o `<C-a>`) → escribe "hello"
- [ ] Probar selección visual: `V` → `<Space>a` → "explain"
- [ ] Probar prompt personalizado: `ga` → "review"
- [ ] Explorar selector: `<Space>x` → buscar comandos

---

**Última Modificación:** 2026-02-18
