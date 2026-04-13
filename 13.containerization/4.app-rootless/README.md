# Docker Rootless Images

## Why Running as Root is Dangerous

By default, Docker containers run as **root (UID 0)**. The root inside the container maps to root on the **host kernel**. If a container breakout occurs, the attacker has **full host access**.

```dockerfile
# What most Dockerfiles look like (dangerous)
FROM node:18
COPY . /app
RUN npm install
CMD ["node", "app.js"]
# Who runs this? Root.
```

---

## Why You Need Rootless

| Risk | Root Container | Non-Root Container |
|------|---------------|-------------------|
| Container escape | Full host compromise | Limited blast radius |
| File system writes | Can overwrite host-mounted files | Restricted |
| Privilege escalation | Easier | Much harder |
| Kernel exploits | Full exposure | Reduced attack surface |
| Compliance (PCI-DSS, SOC2, CIS) | Fails checks | Passes |

---

## Security Reasons

1. **Principle of Least Privilege** — process only has the permissions it needs
2. **Container Breakout Mitigation** — escaping to host yields an unprivileged user
3. **No `setuid`/`setgid` abuse** — attackers can't leverage SUID binaries
4. **Kubernetes enforcement** — `runAsNonRoot: true` in SecurityContext will reject root containers
5. **OCI/CIS Benchmark compliance** — non-root is a required control
6. **Defense in depth** — adds a layer even if other controls fail

---

## How to Implement It (Dockerfile)

```dockerfile
FROM node:18-alpine

# Create a dedicated non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY --chown=appuser:appgroup . .
RUN npm ci --only=production

# Switch to non-root user
USER appuser

EXPOSE 3000
CMD ["node", "server.js"]
```

Key directives:
- `RUN adduser` / `useradd` — create the user
- `COPY --chown` — set ownership at copy time (avoids a `RUN chown` layer)
- `USER` — switch before `CMD`/`ENTRYPOINT`

---

## How to Implement It (Multi-stage Build)

```dockerfile
# Build stage (can run as root to install tools)
FROM node:18-alpine AS builder
WORKDIR /build
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Runtime stage — minimal and non-root
FROM node:18-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=builder --chown=app:app /build/dist ./dist
COPY --from=builder --chown=app:app /build/node_modules ./node_modules
USER app
CMD ["node", "dist/index.js"]
```

---

## How to Enforce It in Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        runAsGroup: 1000
        fsGroup: 1000
      containers:
        - name: app
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop: ["ALL"]
```

---

## Distroless & Hardened Base Images

| Image | Non-Root Default | Shell | Notes |
|-------|-----------------|-------|-------|
| `gcr.io/distroless/nodejs` | Yes (UID 65532) | No | Google distroless |
| `cgr.dev/chainguard/node` | Yes | No | Chainguard, SBOM signed |
| `scratch` | Configurable | No | For Go static binaries |
| `node:18-alpine` | No | Yes | Lightweight but needs `USER` |

---

## Quick Checklist

- [ ] No `USER root` in final image stage
- [ ] Explicit `USER <non-root>` instruction before `CMD`
- [ ] `COPY --chown` for file ownership
- [ ] `readOnlyRootFilesystem: true` in K8s SecurityContext
- [ ] `allowPrivilegeEscalation: false`
- [ ] `capabilities.drop: ["ALL"]`
- [ ] `runAsNonRoot: true` at Pod or Container level
- [ ] Scan with `trivy`, `grype`, or `docker scout` for root-related findings

---

## Summary

> **Running as root in a container is the same as running as root on the host — just with an extra door in between.**

- Default behavior is insecure — always be explicit
- Non-root = smaller blast radius on compromise
- Required for Kubernetes security hardening and compliance
- Easy to implement with `adduser` + `USER` + `--chown`


### build
```bash
docker build -t node-rootless-demo:1.0 .
```

### run
```bash
docker run -it -p 3000:3000 --name node-rootless-demo node-rootless-demo:1.0
```