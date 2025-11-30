# Stage 1: Build
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app
COPY src ./src
RUN mkdir -p /app/classes \
 && javac -d /app/classes $(find src -name "*.java")
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/classes /app/classes
RUN printf '#!/bin/sh\nexec java -cp /app/classes com.example.Main "$@"\n' > /app/run.sh \
 && chmod +x /app/run.sh
LABEL org.opencontainers.image.title="java-docker-template"
EXPOSE 8080
CMD ["/app/run.sh"]
