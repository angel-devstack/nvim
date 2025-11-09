# Neovim Configuration

This is a modular Neovim setup built on lazy.nvim with LSP, DAP, testing, and Git integrations.

- For usage, commands, architecture, and setup see: `WARP.md`
- For debugging problems see: `TROUBLESHOOTING.md`

Quick dependency note:
- `brew install jesseduffield/lazygit/lazygit` (for LazyGit)

---

# Debug y Testeo en Neovim con DAP 🔍

## ✨ Visión general
Este sistema usa nvim‑dap para permitir depuración interactiva en Neovim para los lenguajes más comunes:
- Ruby (RSpec, Minitest)
- Python (pytest, unittest)
- JavaScript/TypeScript (Jest, Supertest)
- Rust (cargo test)

---

## ⚙️ ¿Cómo ejecutar tests?
### 🔑 Comando global
```
<leader>tt
````

Esto ejecuta el test runner adecuado según el tipo de archivo actual.

---

## 🧠 ¿Cómo detecta el tipo de test?
| Lenguaje | Detección                | Framework usado              |
|----------|--------------------------|-------------------------------|
| Ruby     | `_spec.rb` → RSpec       | `bundle exec rspec`           |
| Ruby     | Otro `.rb`               | `bundle exec ruby`            |
| Python   | `.py`                    | `python` / `debugpy`          |
| JS/TS    | `.js`, `.ts`             | `jest`                         |
| Rust     | `.rs`                    | `cargo test`                   |

---

## 🐛 ¿Cómo depurar un test?
Durante el test, se activa la sesión DAP. Puedes usar los siguientes atajos:
| Tecla        | Acción                   |
|--------------|--------------------------|
| `<F5>`       | Iniciar/continuar        |
| `<F10>`      | Paso sobre               |
| `<F11>`      | Entrar (step into)       |
| `<S‑F11>`    | Salir (step out)         |
| `<leader>bp` | Alternar breakpoint       |
| `<leader>dr` | REPL de DAP              |
| `<leader>dl` | Ejecutar último DAP       |

> Puedes personalizar estos mapeos en tu archivo `keymaps.lua`.

---

## 🧪 Tests por lenguaje
### Ruby
```bash
gem install debug
bundle add debug --group=development
````

#### Para RSpec

```
<leader>tt
```

Ejecuta `bundle exec rspec path/al/archivo.rb`.

#### Para Minitest

Si el archivo no termina en `_spec.rb`, se usa `bundle exec ruby archivo.rb`.

#### Adjuntar a servidor Rails

1. Inicia el servidor Rails con rdbg:

   ```
   rdbg -n --open --port 1234 -- bundle exec rails s
   ```
2. Luego usa el “Attach to Rails server” desde DAP UI o comando.

---

### Python

```bash
pip install debugpy
```

Asegúrate de que el entorno virtual esté activado.
Se usa el adaptador `debugpy` para depurar archivos `.py`.

---

### JavaScript / TypeScript

* Requiere tener instalado en el proyecto:

  ```bash
  npm install --save-dev jest
  ```
* El adaptador ejecuta:

  ```bash
  node node_modules/jest/bin/jest.js archivo.test.ts
  ```

---

### Rust

* Requiere `codelldb` (por ejemplo instalado vía Mason).
* Se ejecuta un binario de test compilado con `cargo`.

---

## 🔍 Recomendaciones

* Usa `:checkhealth` para asegurarte de que todos los adaptadores están accesibles.
* Verifica con `which rdbg`, `which debugpy`, `which node` para validar que los ejecutables existen.
* Instala adaptadores opcionales con Mason (`:Mason`).

---
