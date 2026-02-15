输入：assets JSON + next_steps JSON
任务：选择“最优先的一步”生成工具调用 JSON（只输出 JSON）。

约束：
- 不得输出 exploit payload/注入语句。
- args 必须可执行且最小化。
- 工具仅允许以下枚举/验证类：
  - "http_probe"（拉取标题/headers）
  - "dir_enum"（目录枚举，安全模式）
  - "web_fingerprint"（综合指纹，安全模式）
  - "report_note"（把观察结果写入报告）
  - "need_more_data"（要求补充扫描）

输出 JSON Schema：
{
  "tool": "http_probe|dir_enum|web_fingerprint|report_note|need_more_data",
  "args": {
    "target": "127.0.0.1",
    "port": 8080,
    "scheme": "http",
    "safe_mode": true,
    "timeout_sec": 10
  },
  "reasoning_brief": "不超过30字，且必须引用证据",
  "evidence": { "quote": "Nmap原文片段", "source": "nmap" }
}