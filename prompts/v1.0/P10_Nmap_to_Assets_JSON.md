任务：把用户提供的 Nmap 输出解析为资产清单（只基于 Nmap 原文）。
要求：
- 只输出 JSON（不要任何额外文本）。
- 每个资产必须包含 evidence.quote（从 Nmap 复制的原文片段）。
- 没有证据的字段必须标为 "unknown"。

输出 JSON Schema：
{
  "status": "ok",
  "assets": [
    {
      "target": "127.0.0.1",
      "port": 8080,
      "proto": "tcp",
      "service": "http",
      "product": "Apache httpd",
      "version": "2.4.25",
      "notes": "string or unknown",
      "evidence": { "quote": "原文片段", "source": "nmap" }
    }
  ],
  "evidence": [ { "quote": "原文片段", "source": "nmap" } ]
}