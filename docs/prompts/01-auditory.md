---
id: auditory
aliases: []
tags: []
---

Actúa como Arquitecto Senior de Neovim / Lua especializado en performance, maintainability y tooling moderno (2026).

Vas a realizar una auditoría técnica profunda y exhaustiva de mi configuración de Neovim.

⸻

🎯 Objetivo General

Realizar una auditoría completa del setup que incluya:
	1.	Revisión detallada de cada plugin.
	2.	Análisis de arquitectura y organización.
	3.	Evaluación de consistencia técnica.
	4.	Identificación de problemas potenciales (ej: linter Python).
	5.	Propuestas concretas de mejora.
	6.	Recomendaciones de simplificación y limpieza.
	7.	Alternativas modernas si detectas mejores opciones.

No quiero una revisión superficial.
Quiero una auditoría técnica seria, como si fueras a mantener este setup por 3 años.

⸻

🏗 1️⃣ Análisis de Arquitectura

Primero:
	•	Analiza cómo está estructurado el proyecto:
	•	init.lua
	•	lua/angel/core
	•	lua/angel/plugins/*
	•	utils/
	•	docs/
	•	Evalúa:
	•	Separación de responsabilidades
	•	Cohesión por categoría
	•	Acoplamiento innecesario
	•	Carga condicional vs eager loading
	•	Uso de lazy.nvim (patrones correctos o mejorables)

Responde:
	•	¿La arquitectura es escalable?
	•	¿Qué refactor estructural propondrías?
	•	¿Hay duplicación conceptual?
	•	¿Hay configuraciones que deberían abstraerse?
	•	¿Hay plugins mal ubicados por categoría?

⸻

🔍 2️⃣ Auditoría Plugin por Plugin

Para CADA plugin:
	1.	¿Está correctamente configurado?
	2.	¿Se están usando buenas prácticas actuales?
	3.	¿Hay opciones innecesarias?
	4.	¿Hay opciones faltantes que mejorarían UX o performance?
	5.	¿Está cargando demasiado pronto?
	6.	¿Tiene conflictos potenciales con otros plugins?
	7.	¿Tiene alternativas mejores en 2026?

Para cada plugin quiero:
	•	🔎 Diagnóstico técnico
	•	⚠️ Riesgos o problemas
	•	🚀 Mejoras sugeridas
	•	🔁 Alternativas posibles
	•	📉 Si recomendarías eliminarlo

⸻

🧪 3️⃣ LSP, Linters y Formateo (CRÍTICO)

Estoy teniendo un posible problema con el linter de Python.

Quiero que revises exhaustivamente:
	•	mason.lua
	•	lsp configs
	•	conform
	•	null-ls si existe
	•	configuración de python (pyright, ruff, flake8, black, etc.)
	•	rutas locales o entornos virtuales

Analiza:
	•	¿Puede haber conflicto entre LSP y formatter?
	•	¿Hay doble formateo?
	•	¿Hay conflicto entre mason y herramientas locales?
	•	¿Hay timeout mal configurado?
	•	¿Está correctamente resuelto el PATH?
	•	¿Hay dependencia de entorno virtual que esté rompiendo algo?

Proponé una arquitectura ideal para:
	•	Python
	•	TypeScript
	•	Shell
	•	Markdown

⸻

⚡ 4️⃣ Performance y Lazy Loading

Analiza:
	•	¿Qué plugins deberían usar event?
	•	¿Qué plugins deberían usar ft?
	•	¿Qué debería usar cmd?
	•	¿Hay plugins UI que cargan innecesariamente?
	•	¿Hay riesgo de startup lento?
	•	¿Hay cosas que deberían ir en after/?

Dame:
	•	Recomendaciones específicas de lazy loading.
	•	Qué moverías y cómo.

⸻

🧹 5️⃣ Limpieza y Simplificación

Quiero que detectes:
	•	Código muerto.
	•	Config redundante.
	•	Opciones duplicadas.
	•	Keymaps inconsistentes.
	•	Plugins que podrían unificarse.
	•	Complejidad innecesaria.

Responde:
	•	Si tuvieras que reducir el setup un 20% sin perder potencia, ¿qué sacarías?
	•	¿Qué simplificarías?
	•	¿Qué abstraerías en helpers?

⸻

📚 6️⃣ Documentación

Revisa:
	•	docs/
	•	KEYMAP registry
	•	WARP
	•	AI docs
	•	CLAUDE.md

Evalúa:
	•	¿Está alineada con la realidad del código?
	•	¿Hay documentación que debería eliminarse?
	•	¿Hay documentación desactualizada?
	•	¿Falta documentación crítica?
	•	¿Está sobredocumentado algo innecesario?

⸻

🧠 7️⃣ Diseño Técnico y Filosofía

Analiza si el setup:
	•	Tiene una filosofía clara.
	•	Es minimalista o maximalista.
	•	Es coherente.
	•	Está demasiado orientado a AI.
	•	Tiene sobreingeniería.
	•	Tiene under-engineering en algo importante.

Quiero un diagnóstico honesto, incluso crítico.

⸻

🧭 8️⃣ Roadmap de Mejora

Al final quiero:
	1.	🔥 Prioridad alta (arreglar ya)
	2.	⚠️ Prioridad media
	3.	✨ Mejora opcional
	4.	🧼 Limpieza estética

Y un plan sugerido en fases.

⸻

📊 Formato de Respuesta

Organiza tu respuesta así:
	•	Resumen Ejecutivo
	•	Problemas Críticos Detectados
	•	Análisis Arquitectónico
	•	Auditoría Plugin por Plugin
	•	LSP y Tooling
	•	Performance
	•	Limpieza
	•	Documentación
	•	Roadmap Priorizado

⸻

📌 Restricciones
	•	No des respuestas vagas.
	•	No seas complaciente.
	•	Sé específico.
	•	Propón cambios concretos (con ejemplo si es necesario).
	•	Señala configuraciones problemáticas con precisión.

⸻

Si detectas algo potencialmente mal diseñado, quiero que lo señales claramente.
