# Convención / estructura para prefijos <leader>

Aquí va una propuesta de convención para tus keymaps con `<leader>`,
que facilita la organización, evita colisiones y hace que la memoria sea más fácil.
Puedes copiar y pegar esta documentación en algún archivo de
tu configuración (por ejemplo en un README‑keymaps.md o similar).

## 📦 Convención sugerida

- `<leader>g` → Git / control de versiones
  - Ejemplo: `<leader>gs` (git status)
  - Ejemplo: `<leader>gp` (git push)
  - Ejemplo: `<leader>gl` (git pull)

- `<leader>t` → Tests / toolkit de pruebas
  - Ejemplo: `<leader>tt` (run tests)
  - Ejemplo: `<leader>ta` (run all tests)
  - Ejemplo: `<leader>to` (open test output)

- `<leader>x` → Diagnostics / interfaz de errores / lists
  - Ejemplo: `<leader>xx` (toggle trouble)
  - Ejemplo: `<leader>xd` (diagnostics document)
  - Ejemplo: `<leader>xl` (loclist)

- `<leader>r` → Requests / REST / API / generación de peticiones
  - Ejemplo: `<leader>rr` (run request)
  - Ejemplo: `<leader>rp` (preview request)

- `<leader>s` → Session / entorno / administración de sesiones
  - Ejemplo: `<leader>ws` (session save)
  - Ejemplo: `<leader>wr` (session restore)
  - Ejemplo: `<leader>wd` (session delete)

- `<leader>m` o `<leader>o` → Misc / utilitarios
  - Ejemplo: `<leader>sm` (maximize split)
  - Ejemplo: `<leader>so` (sort selection)
  - (Aquí puedes decidir otro prefijo si “m” o “o” ya se usa mucho)

## 🧠 Beneficios de esta convención

Facilita encontrar la función al ver el keymap (g=git, t=tests, x=error/diagnostics, r=requests).
Reduce solapamientos, ya que cada categoría tiene su prefijo.
Hace más fácil la documentación, enseñanza a otros o recordar tú mismo.
Se adapta bien a herramientas nuevas que añadas (solo añades bajo su categoría).

## 📝 Cómo usarlo

En tu configuración de which‑key o en tu documentación, incluye los grupos con los prefijos.
Al definir los keymaps en los plugins, asegúrate de que usan el prefijo correcto.
Si encuentras un mapeo que rompe la convención o colisiona con otro, cambia el mapeo a otro prefijo.
