# Mermaid Diagram Example

This file demonstrates Mermaid diagram rendering in WezTerm.

## Simple Flowchart

```mermaid
graph TD
    A[Start] --> B{Is WezTerm?}
    B -->|Yes| C[Render Diagram]
    B -->|No| D[Show Text Only]
    C --> E[Done]
    D --> E
```

## Sequence Diagram

```mermaid
sequenceDiagram
    participant U as User
    participant E as Editor
    participant G as LLM

    U->>E: Type code
    E->>G: Send request
    G->>E: Respond with answer
    E->>U: Show response
```

## State Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle: Press <C-a>
    Idle --> Asking: Type question
    Asking --> Processing: Send to LLM
    Processing --> Answer: Receive response
    Answer --> [*]
```

## How to View

1. **In WezTerm (required):**
   - Open this file: `nvim docs/examples/markdown/mermaid-example.md`
   - Diagrams appear as inline images
   - Mermaid syntax rendered in terminal preview

2. **In iTerm (not supported):**
   - Open this file: `nvim docs/examples/markdown/mermaid-example.md`
   - Diagrams show as text (Mermaid code blocks)
   - No image preview (iTerm doesn't support terminal graphics)

**Note:** Mermaid only works in WezTerm due to image protocol support. See `docs/plugins/markdown-images.md` for details.