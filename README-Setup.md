# LLM‑Setup.md

## 1. Objetivo

Este documento describe cómo elegir, instalar y
ejecutar un modelo de lenguaje (LLM) localmente en
macOS (Apple Silicon) para usar con el plugin `gen.nvim` en Neovim,
y cómo configurarlo.

## 2. Convención de modelo seleccionada

**Modelo recomendado**: `Llama 3 8B`
**Opción avanzada**: `DeepSeek‑Coder‑V2 16B (Lite)`
Variables de entorno de ejemplo:

```sh
export OLLAMA_SERVER="127.0.0.1"
export OLLAMA_PORT="11434"
export OLLAMA_HOST="${OLLAMA_SERVER}:${OLLAMA_PORT}"

export LLM_MODEL="llama3:8b" # INFO: check $SHELL_PATH/exports.sh
```
