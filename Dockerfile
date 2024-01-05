FROM nginx:latest

# 安装 gettext 包，它包含 envsubst
RUN apt-get update && apt-get install -y gettext-base

# 复制自定义配置文件到容器
COPY nginx/conf.d/ /etc/nginx/templates/

CMD /bin/bash -c "envsubst '\$LISTEN_PORT1 \$WS_BACKEND1 \$LISTEN_PORT2 \$WS_BACKEND2' < /etc/nginx/templates/default.conf > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
