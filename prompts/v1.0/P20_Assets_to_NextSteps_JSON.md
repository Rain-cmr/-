输入：Nmap 原文 + assets JSON
任务：基于证据输出下一步“枚举/验证计划”（不要 exploit，不要 payload）。

要求：
- 只输出 JSON。
- 每条 next_step 必须绑定一个 asset（port/service）并引用证据 evidence.quote。
- 每条必须包含：
  - goal（要确认什么）
  - method（安全的方法/工具类别；不要给武器化参数）
  - expected_evidence（观察到什么算完成）
  - decision_branch（如果A发生→做B，否则做C）
  - priority（1-5）

输出 JSON Schema：
{
  "status": "ok",
  "next_steps": [
    {
      "priority": 1,
      "asset_ref": "127.0.0.1:8080/tcp",
      "goal": "确认 Web 应用类型/登录入口/安全配置状态",
      "method": "HTTP 指纹、标题/headers、基础目录枚举（安全模式）",
      "expected_evidence": "title/Server/header/关键路径返回码",
      "decision_branch": "如果存在登录与测试模块→进入功能点验证；否则补充目录枚举",
      "evidence": { "quote": "Nmap原文片段", "source": "nmap" }
    }
  ],
  "risks_of_hallucination": [
    "不得推断数据库端口开放，除非证据存在",
    "不得假设存在特定漏洞利用链"
  ],
  "evidence": [ { "quote": "原文片段", "source": "nmap" } ]
}