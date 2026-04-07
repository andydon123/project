## GitHub Copilot Chat

- Extension: 0.42.2 (prod)
- VS Code: 1.113.0 (cfbea10c5ffb233ea9177d34726e6056e89913dc)
- OS: win32 10.0.26100 x64
- GitHub Account: andydon123

## Network

User Settings:
```json
  "http.systemCertificatesNode": true,
  "github.copilot.advanced.debug.useElectronFetcher": true,
  "github.copilot.advanced.debug.useNodeFetcher": false,
  "github.copilot.advanced.debug.useNodeFetchFetcher": true
```

Connecting to https://api.github.com:
- DNS ipv4 Lookup: 140.82.121.6 (4 ms)
- DNS ipv6 Lookup: Error (2 ms): getaddrinfo ENOTFOUND api.github.com
- Proxy URL: None (1 ms)
- Electron fetch (configured): HTTP 200 (73 ms)
- Node.js https: HTTP 200 (236 ms)
- Node.js fetch: HTTP 200 (266 ms)

Connecting to https://api.githubcopilot.com/_ping:
- DNS ipv4 Lookup: 140.82.112.22 (2 ms)
- DNS ipv6 Lookup: Error (2 ms): getaddrinfo ENOTFOUND api.githubcopilot.com
- Proxy URL: None (1 ms)
- Electron fetch (configured): HTTP 200 (499 ms)
- Node.js https: HTTP 200 (506 ms)
- Node.js fetch: HTTP 200 (513 ms)

Connecting to https://copilot-proxy.githubusercontent.com/_ping:
- DNS ipv4 Lookup: 20.199.39.224 (62 ms)
- DNS ipv6 Lookup: Error (3 ms): getaddrinfo ENOTFOUND copilot-proxy.githubusercontent.com
- Proxy URL: None (1 ms)
- Electron fetch (configured): HTTP 200 (281 ms)
- Node.js https: HTTP 200 (267 ms)
- Node.js fetch: HTTP 200 (264 ms)

Connecting to https://mobile.events.data.microsoft.com: HTTP 404 (223 ms)
Connecting to https://dc.services.visualstudio.com: HTTP 404 (395 ms)
Connecting to https://copilot-telemetry.githubusercontent.com/_ping: HTTP 200 (509 ms)
Connecting to https://copilot-telemetry.githubusercontent.com/_ping: HTTP 200 (504 ms)
Connecting to https://default.exp-tas.com: timed out after 10 seconds

Number of system certificates: 67

## Documentation

In corporate networks: [Troubleshooting firewall settings for GitHub Copilot](https://docs.github.com/en/copilot/troubleshooting-github-copilot/troubleshooting-firewall-settings-for-github-copilot).