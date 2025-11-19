# Dockerfile Instructions: Comprehensive Guide

A **Dockerfile** is a script that contains instructions to build a Docker image. Below is an extensive list of Dockerfile parts, their purpose, and examples.

---

## 1. FROM
**Purpose:** Specifies the base image for your container.
```dockerfile
FROM ubuntu:22.04
```
This is usually the first instruction in the Dockerfile.

---

## 2. LABEL
**Purpose:** Adds metadata to the image.
```dockerfile
LABEL maintainer="you@example.com" version="1.0"
```

---

## 3. RUN
**Purpose:** Executes commands inside the image during build time.
```dockerfile
RUN apt-get update && apt-get install -y curl
```

---

## 4. COPY
**Purpose:** Copies files from your host machine into the image.
```dockerfile
COPY ./app /usr/src/app
```

---

## 5. ADD
**Purpose:** Similar to COPY but can also handle remote URLs and extract archives.
```dockerfile
ADD https://example.com/file.tar.gz /app/
```

---

## 6. WORKDIR
**Purpose:** Sets the working directory for subsequent instructions.
```dockerfile
WORKDIR /usr/src/app
```

---

## 7. ENV
**Purpose:** Defines environment variables inside the container.
```dockerfile
ENV NODE_ENV=production
```

---

## 8. EXPOSE
**Purpose:** Documents the port the container will listen on.
```dockerfile
EXPOSE 8080
```

---

## 9. CMD
**Purpose:** Specifies the default command to run when the container starts.
```dockerfile
CMD ["node", "server.js"]
```

---

## 10. ENTRYPOINT
**Purpose:** Similar to CMD but makes the command fixed.
```dockerfile
ENTRYPOINT ["python3"]
CMD ["app.py"]
```

---

## 11. USER
**Purpose:** Sets the user to run commands inside the container.
```dockerfile
USER appuser
```

---

## 12. VOLUME
**Purpose:** Creates a mount point for external volumes.
```dockerfile
VOLUME ["/data"]
```

---

## 13. ARG
**Purpose:** Defines build-time variables.
```dockerfile
ARG VERSION=1.0
RUN echo "Version: $VERSION"
```

---

## 14. HEALTHCHECK
**Purpose:** Checks the health of the container.
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s CMD curl -f http://localhost/ || exit 1
```

---

## 15. SHELL
**Purpose:** Changes the default shell used by RUN.
```dockerfile
SHELL ["/bin/bash", "-c"]
```

---

## 16. STOPSIGNAL
**Purpose:** Sets the system call signal to stop the container.
```dockerfile
STOPSIGNAL SIGTERM
```

---

## 17. ONBUILD
**Purpose:** Adds triggers for child images.
```dockerfile
ONBUILD RUN echo "This runs when used as a base image"
```

---

## 18. Multiple Stage Builds
**Purpose:** Optimize image size by using multiple stages.
```dockerfile
FROM golang:1.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/myapp .
CMD ["./myapp"]
```