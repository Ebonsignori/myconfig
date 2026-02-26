# LLM Echo Server

A simple mock server that echoes responses in LLM API formats.

## Usage

```bash
./echo-server.mjs [port] [message]
```

### Arguments

| Argument  | Default              | Description                    |
|-----------|----------------------|--------------------------------|
| `port`    | `8080`               | Port to listen on              |
| `message` | `Mock echo response` | Message to echo in responses   |

### Examples

```bash
# Start on default port 8080
./echo-server.mjs

# Start on port 3000
./echo-server.mjs 3000

# Start on port 3000 with custom message
./echo-server.mjs 3000 "Hello from mock server"
```

## Supported API Formats

The server automatically detects the API format based on the request path:

| Format           | Path Contains                                      |
|------------------|----------------------------------------------------|
| Vertex AI/Gemini | `generatecontent`, `vertexai`, `aiplatform`        |
| Anthropic        | `anthropic`, `messages`                            |
| OpenAI           | Default for all other paths                        |

## Response Examples

### OpenAI Format
```json
{
  "id": "chatcmpl-mock",
  "object": "chat.completion",
  "model": "gpt-mock",
  "choices": [{
    "index": 0,
    "message": { "role": "assistant", "content": "<message>" },
    "finish_reason": "stop"
  }],
  "usage": { "prompt_tokens": 10, "completion_tokens": 10, "total_tokens": 20 }
}
```

### Anthropic Format
```json
{
  "id": "msg_mock",
  "type": "message",
  "role": "assistant",
  "content": [{ "type": "text", "text": "<message>" }],
  "model": "claude-mock",
  "stop_reason": "end_turn",
  "usage": { "input_tokens": 10, "output_tokens": 10 }
}
```

### Vertex AI/Gemini Format
```json
{
  "candidates": [{
    "content": { "parts": [{ "text": "<message>" }], "role": "model" },
    "finishReason": "STOP"
  }],
  "usageMetadata": { "promptTokenCount": 10, "candidatesTokenCount": 10, "totalTokenCount": 20 }
}
```
