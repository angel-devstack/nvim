
# 🧪 Neotest + DAP Integration

Esta configuración te permite ejecutar y depurar pruebas en múltiples lenguajes directamente desde Neovim usando [neotest](https://github.com/nvim-neotest/neotest) y [nvim-dap](https://github.com/mfussenegger/nvim-dap).

## ✅ Soporte para Lenguajes

| Lenguaje     | Adapter           | Ejecuta tests | Depura con DAP |
|--------------|-------------------|----------------|----------------|
| Ruby         | neotest-rspec     | ✅              | ✅              |
| Python       | neotest-python    | ✅              | ✅              |
| JS/TS (Jest) | neotest-jest      | ✅              | ✅              |
| Rust         | neotest-rust      | ✅              | ✅              |

---

## 🧠 Comandos disponibles

| Atajo        | Acción                                    |
|--------------|-------------------------------------------|
| `<leader>tt` | 🧪 Ejecutar el archivo actual de pruebas   |
| `<leader>tr` | 🧪 Ejecutar la prueba más cercana          |
| `<leader>ta` | 🧪 Ejecutar todos los tests del proyecto   |
| `<leader>tS` | 🐞 Depurar el test más cercano con DAP     |
| `<leader>to` | 📤 Mostrar salida del test actual          |
| `<leader>ts` | 📋 Alternar el resumen de tests            |

---

## 🧩 Requisitos

Instalación recomendada vía Lazy:

```lua
{
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-python",
    "olimorris/neotest-rspec",
    "nvim-neotest/neotest-jest",
    "rouge8/neotest-rust",
  },
}
