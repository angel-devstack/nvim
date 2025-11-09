ollama/setup:
	brew install ollama

ollama/start:
	ollama serve

ollama/pull/mistral:
	ollama pull mistral-2b

ollama/pull/llama:
	ollama pull llama3:8b

ollama/pull/deepseek:
	ollama pull deepseek-coder-v2:16b

ollama/monitor:
	sudo asitop --interval 2
