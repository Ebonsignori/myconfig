#!/usr/bin/env node
import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  dim: '\x1b[2m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m',
};

// Logging utilities
let requestCount = 0;
const startTime = new Date();

function extractPromptPreview(body) {
  try {
    const data = JSON.parse(body);
    // OpenAI format
    if (data.messages?.[0]?.content) {
      const content = data.messages[0].content;
      const text = typeof content === 'string' ? content : content[0]?.text || '';
      return text.split(/\s+/).slice(0, 3).join(' ') + '...';
    }
    // Anthropic format
    if (data.prompt) {
      return data.prompt.split(/\s+/).slice(0, 3).join(' ') + '...';
    }
    // Vertex/Gemini format
    if (data.contents?.[0]?.parts?.[0]?.text) {
      return data.contents[0].parts[0].text.split(/\s+/).slice(0, 3).join(' ') + '...';
    }
  } catch {}
  return '(no prompt)';
}

// Handle --help or -h flag
if (process.argv.includes('--help') || process.argv.includes('-h')) {
  const readmePath = path.join(__dirname, 'README.md');
  try {
    const readme = fs.readFileSync(readmePath, 'utf-8');
    console.log(readme);
  } catch {
    console.log('README.md not found');
  }
  process.exit(0);
}

const port = parseInt(process.argv[2]) || 8080;
const echoMessage = process.argv[3] || 'Mock echo response';

// API key validation - returns error response if invalid, null if valid
function validateApiKey(req, format) {
  const authHeader = req.headers['authorization'] || '';
  const anthropicKey = req.headers['x-api-key'] || '';
  
  if (format === 'Anthropic') {
    if (!anthropicKey) {
      return {
        status: 401,
        body: {
          type: 'error',
          error: {
            type: 'authentication_error',
            message: 'x-api-key header is required'
          }
        }
      };
    }
  } else if (format === 'Vertex AI / Gemini') {
    if (!authHeader.startsWith('Bearer ')) {
      return {
        status: 401,
        body: {
          error: {
            code: 401,
            message: 'Request had invalid authentication credentials. Expected OAuth 2 access token, login cookie or other valid authentication credential.',
            status: 'UNAUTHENTICATED'
          }
        }
      };
    }
  } else {
    // OpenAI
    if (!authHeader.startsWith('Bearer ')) {
      return {
        status: 401,
        body: {
          error: {
            message: 'You didn\'t provide an API key. You need to provide your API key in an Authorization header using Bearer auth (i.e. Authorization: Bearer YOUR_KEY).',
            type: 'invalid_request_error',
            param: null,
            code: 'invalid_api_key'
          }
        }
      };
    }
  }
  return null;
}

const server = http.createServer((req, res) => {
  let body = '';
  req.on('data', chunk => { body += chunk.toString(); });
  req.on('end', () => {
    requestCount++;
    const format = detectFormat(req.url);
    const preview = extractPromptPreview(body);
    const ts = new Date().toLocaleString('en-US', {
      timeZone: 'America/Los_Angeles',
      month: 'numeric',
      day: 'numeric',
      hour: 'numeric',
      minute: '2-digit',
      hour12: true
    });
    
    // Validate API key
    const authError = validateApiKey(req, format);
    if (authError) {
      console.log(`${colors.dim}[${ts}]${colors.reset} ${colors.green}#${requestCount}${colors.reset} ${colors.yellow}${req.method}${colors.reset} ${req.url} ${colors.cyan}${format}${colors.reset} ${colors.dim}content:${colors.reset} ${preview} ${colors.yellow}[AUTH ERROR]${colors.reset}`);
      res.writeHead(authError.status, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify(authError.body, null, 2));
      return;
    }
    
    console.log(`${colors.dim}[${ts}]${colors.reset} ${colors.green}#${requestCount}${colors.reset} ${colors.yellow}${req.method}${colors.reset} ${req.url} ${colors.cyan}${format}${colors.reset} ${colors.dim}content:${colors.reset} ${preview}`);
    
    const response = getResponse(req, echoMessage);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(response, null, 2));
  });
});

function detectFormat(url) {
  const path = (url || '').toLowerCase();
  if (path.includes('generatecontent') || path.includes('vertexai') || path.includes('aiplatform')) {
    return 'Vertex AI / Gemini';
  }
  if (path.includes('anthropic') || path.includes('messages')) {
    return 'Anthropic';
  }
  return 'OpenAI';
}

function getResponse(req, msg) {
  const urlPath = (req.url || '').toLowerCase();
  
  // Vertex AI / Google Gemini
  if (urlPath.includes('generatecontent') || urlPath.includes('vertexai') || urlPath.includes('aiplatform')) {
    return {
      candidates: [{
        content: { parts: [{ text: msg }], role: 'model' },
        finishReason: 'STOP'
      }],
      usageMetadata: { promptTokenCount: 10, candidatesTokenCount: 10, totalTokenCount: 20 }
    };
  }
  
  // Anthropic
  if (urlPath.includes('anthropic') || urlPath.includes('messages')) {
    return {
      id: 'msg_mock',
      type: 'message',
      role: 'assistant',
      content: [{ type: 'text', text: msg }],
      model: 'claude-mock',
      stop_reason: 'end_turn',
      usage: { input_tokens: 10, output_tokens: 10 }
    };
  }
  
  // OpenAI (default)
  return {
    id: 'chatcmpl-mock',
    object: 'chat.completion',
    created: Date.now(),
    model: 'gpt-mock',
    choices: [{
      index: 0,
      message: { role: 'assistant', content: msg },
      finish_reason: 'stop'
    }],
    usage: { prompt_tokens: 10, completion_tokens: 10, total_tokens: 20 }
  };
}

server.listen(port, () => {
  console.log();
  console.log(`  ${colors.green}LLM Echo Server${colors.reset}`);
  console.log(`  ${colors.cyan}Port:${colors.reset}     ${port}`);
  console.log(`  ${colors.cyan}Response:${colors.reset} "${echoMessage}"`);
  console.log(`  ${colors.cyan}Formats:${colors.reset}  OpenAI, Anthropic, Vertex/Gemini`);
  console.log(`  ${colors.cyan}Started:${colors.reset}  ${startTime.toISOString()}`);
  console.log();
});
