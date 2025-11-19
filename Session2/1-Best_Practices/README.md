# Dockerfile Best Practices for C++ Application

This repository demonstrates **good** and **bad practices** when writing Dockerfiles for a simple C++ application. The app prints `Hello from Docker!`.

---

## ✅ Good Practices Dockerfile
```dockerfile
# -----------------------------------------
# GOOD PRACTICES DOCKERFILE
# Builds a simple C++ Hello World app
# -----------------------------------------

# Stage 1: Build the application

# Minimal base image for building C++
FROM gcc:13 AS builder  
# Set working directory
WORKDIR /app          
# Copy only necessary files  
COPY main.cpp .         
# Compile with optimization
RUN g++ -O2 -o app main.cpp  

# Stage 2: Runtime image
# ✅ Minimal runtime image
FROM debian:bookworm-slim  
WORKDIR /app
# Multi-stage build reduces image size
COPY --from=builder /app/app .  
# ✅ Create non-root user for security
RUN useradd -m appuser
USER appuser

# ✅ Use ENTRYPOINT for executable, CMD for optional args
ENTRYPOINT ["./app"]
CMD []

# ✅ Documentation included
# This Dockerfile demonstrates best practices:
# - Minimal base images
# - Multi-stage builds
# - Layer caching
# - WORKDIR usage
# - ENTRYPOINT and CMD separation
# - No hardcoded secrets
# - Runs as non-root user
```

### Why is this good?
- **Minimal base images**: `gcc:13` for build, `debian:bookworm-slim` for runtime.
- **Multi-stage builds**: Keeps final image small.
- **Layer caching**: COPY and RUN steps structured for caching.
- **WORKDIR**: Avoids messy paths.
- **ENTRYPOINT vs CMD**: ENTRYPOINT for main process, CMD for optional args.
- **Avoid secrets**: No hardcoded credentials.
- **Non-root user**: Improves security.
- **Documentation**: Comments explain purpose.

---

## ❌ Bad Practices Dockerfile
```dockerfile
# -----------------------------------------
# BAD PRACTICES DOCKERFILE
# Builds a simple C++ Hello World app
# -----------------------------------------

# ❌ Bloated base image (large and unnecessary)
FROM ubuntu:latest

# ❌ No WORKDIR, everything dumped in root
COPY . /root/

# ❌ Hardcoding secrets (NEVER DO THIS)
ENV API_KEY=123456789
    
# ❌ Single-stage build (huge image, includes compiler)
RUN apt-get update && apt-get install -y g++ \
    && g++ -o app /root/main.cpp

# ❌ Runs as root (default)
# ❌ ENTRYPOINT and CMD misused (only CMD, no ENTRYPOINT)
CMD ["./hello"]
```

### Why is this bad?
- Bloated base image (`ubuntu:latest`).
- No WORKDIR.
- Hardcoded secrets.
- Single-stage build (huge image).
- Runs as root.
- Misuse of ENTRYPOINT/CMD.

---

## 🔍 Comparison Table
| Practice                | Good Dockerfile | Bad Dockerfile |
|-------------------------|-----------------|----------------|
| Minimal Base Image      | ✅             | ❌             |
| Multi-Stage Build       | ✅             | ❌             |
| Layer Caching           | ✅             | ❌             |
| WORKDIR Set             | ✅             | ❌             |
| ENTRYPOINT/CMD Proper   | ✅             | ❌             |
| Avoid Secrets           | ✅             | ❌             |
| Non-Root User           | ✅             | ❌             |
| Documentation           | ✅             | ✅             |

---

## ▶️ How to Build and Run

### 1. Create `main.cpp`
```cpp
#include <iostream>
int main() {
    std::cout << "Hello from Docker!" << std::endl;
    return 0;
}
```

### 2. Build Good Dockerfile
```bash
docker build -f Dockerfile.good -t hello:good .
```

### 3. Run Container
```bash
docker run --rm cpp-app-good
```

### 4. Build Bad Dockerfile
```bash
docker build -f Dockerfile.bad -t hello:bad .
```

---

## 🛡️ Best Practices Recap
- Use minimal base images.
- Apply multi-stage builds.
- Leverage layer caching.
- Set WORKDIR.
- Use ENTRYPOINT and CMD appropriately.
- Avoid hardcoding secrets.
- Run as non-root user.
- Document your Dockerfile.

