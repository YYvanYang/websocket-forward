# 第一阶段：构建阶段
FROM nginx:alpine as builder

# 安装 gettext 包（包含 envsubst）
RUN apk add --no-cache gettext

# 复制自定义配置文件到构建环境
COPY nginx/conf.d/ /etc/nginx/templates/

ARG LISTEN_PORT1
ARG WS_BACKEND1
ARG LISTEN_PORT2
ARG WS_BACKEND2

# 使用 envsubst 处理 Nginx 配置模板
RUN envsubst '\$LISTEN_PORT1 \$WS_BACKEND1 \$LISTEN_PORT2 \$WS_BACKEND2' < /etc/nginx/templates/default.conf > /etc/nginx/conf.d/default.conf

# 第二阶段：运行阶段
FROM nginx:alpine

# 从构建阶段复制已处理的 Nginx 配置
COPY --from=builder /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
