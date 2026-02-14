本仓库用于快速重现一个本地安全研究基准环境，方便进行：

- 扫描 (Nmap) -> 探索 (JSON) -> LLM 验证 -> 工具执行 (ToolExecutor) 的闭环联调
- Prompt 模板构建和调试
- 工具对接 (Nmap/SQLMap) 规范化验证

靶场包含：

- DVWA: `http://localhost:8080`
- Struts2 S2-005 (Tomcat): `http://localhost:8081`

------

## 1. 环境要求

### 必须

- Docker Desktop (Windows/macOS) 或 Docker Engine (Linux)
- 能运行 Docker 容器

### Windows 用户建议

- 使用 WSL2 + Docker Desktop

- 在 Docker Desktop 中开启 WSL2 Integration

- 验证命令：

  Bash

  ```
  docker run --rm hello-world
  ```

## 2. 快速开始（推荐一键）

在仓库根目录执行：

Bash

```
./scripts/start.sh
./scripts/status.sh
```

访问：

- DVWA: `http://localhost:8080`
- S2-005: `http://localhost:8081`

## 3. 生成 Nmap 扫描样本（用于 Prompt/回归测试）

执行：

Bash

```
./scripts/nmap.sh
```

生成文件在 `./samples/` 下：

- `case01_full_tcp.txt`: 全端口扫描 + 服务识别（基线证据）
- `case02_web_fingerprint.txt`: Web 指纹 (http-title/http-headers, 更适合喂给 LLM)

**注意**：`case01` 默认会优先尝试 `sudo nmap -sS ...` （需要 root 权限）。如果你不想输入 sudo 密码，脚本会自动降级使用 `-sT` 模式（无需 root）。

## 4. 停止靶场

Bash

```
./scripts/stop.sh
```

## 5. 目录结构说明

- `compose.yaml`: 靶场编排入口 (DVWA + S2-005)
- `labs/s2-005/`: Struts2 S2-005 场景 (Dockerfile + war 包)
- `scripts/`: 一键脚本
  - `start.sh`: 启动 (必要时构建镜像)
  - `stop.sh`: 停止并清理
  - `status.sh`: 查看容器状态 + HTTP 连通性检查
  - `nmap.sh`: 生成 Nmap 样本到 `samples/`
- `samples/`: 扫描样本输出 (可提交到仓库或本地生成)

## 6. 常见问题 (Troubleshooting)

### 6.1 端口冲突 (8080/8081 被占用)

现象：启动时报错 `port is already allocated`

处理方式：

1. 先查看当前占用：

   Bash

   ```
   docker ps
   ```

2. 停掉旧容器：

   Bash

   ```
   docker rm -f dvwa s2-005
   ```

3. 或修改 `compose.yaml` 的宿主机端口，例如：

   - DVWA 改为 `"18080:80"`
   - S2-005 改为 `"18081:8080"`

### 6.2 拉取镜像失败（网络/代理/IPv6）

现象：`failed to resolve reference` / `registry-1.docker.io` 连接失败

处理方式（优先级从高到低）：

1. **Docker Desktop 设置代理**：
   - Settings -> Resources -> Proxies -> Use system proxy 或手动配置 HTTP/HTTPS proxy
2. **临时禁用 Windows 网卡 IPv6** (常见于 IPv6 不通导致)
3. **配置 registry mirror** (按团队网络环境选择)

### 6.3 Windows + WSL2 访问问题

一般情况下浏览器访问：

- `http://localhost:8080`
- `http://localhost:8081` 即可。

如遇特殊网络问题，先用 WSL 内验证：

Bash

```
curl -I http://127.0.0.1:8080
curl -I http://127.0.0.1:8081
```

## 7. 使用建议（给联调用）

- 做自动化闭环测试时，建议固定端口：
  - DVWA = 8080
  - S2-005 = 8081
- Prompt/工具解析回归测试，优先用 `samples/case02_web_fingerprint.txt` 作为标准输入
- 每次改动 ToolExecutor / Prompt 后：
  1. `./scripts/status.sh` 确保靶场可达
  2. `./scripts/nmap.sh` 生成新样本（可对比差异）
