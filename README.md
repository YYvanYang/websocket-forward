# Websocket端口转发
动机：为了处理mac端没有缺少相应打印组件，将mac端请求ws://localhost:13888转发到windows端的ws://localhost:13888来实现流量转发。从而实现打印的目的。

docker build
```
docker-compose up -d --build
```

当使用`docker-compose`和`.env`文件进行构建时，虽然`docker-compose`会自动读取`.env`文件中的环境变量并将它们应用到服务的运行时环境中，但这些变量在构建阶段（即在Dockerfile的`RUN`命令中）默认是不可用的。要在构建阶段使用这些变量，你需要在`docker-compose.yml`文件中显式地声明它们。以下是如何操作的步骤：

### 1. 声明环境变量
在`docker-compose.yml`文件的服务下，使用`env_file`来指定环境变量文件，然后在`build`部分的`args`下声明你想在构建过程中使用的变量。

```yaml
version: '3'
services:
  your-service:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        - LISTEN_PORT1
        - WS_BACKEND1
        - LISTEN_PORT2
        - WS_BACKEND2
    env_file:
      - ./.env
```

### 2. 在Dockerfile中使用ARG
在你的`Dockerfile`中，使用`ARG`指令来声明相同的变量。这样，你就可以在构建过程中使用这些变量了。

```Dockerfile
ARG LISTEN_PORT1
ARG WS_BACKEND1
ARG LISTEN_PORT2
ARG WS_BACKEND2

# 使用envsubst等命令
RUN envsubst '\$LISTEN_PORT1 \$WS_BACKEND1 \$LISTEN_PORT2 \$WS_BACKEND2' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
```

### 3. 构建和运行
现在当你使用`docker-compose up --build`命令时，`.env`文件中的变量将被读取，并作为参数传递给Docker构建过程，然后`envsubst`将能够正确地替换这些值。

### 注意事项
- **安全性**：确保不要在镜像中泄露敏感的环境变量，尤其是那些涉及密码或API密钥的。
- **环境隔离**：在多环境部署中，确保每个环境使用正确的`.env`文件。
- **调试**：如果仍然不起作用，尝试检查和打印环境变量，确保它们在构建过程中被正确传递和识别。

通过遵循这些步骤，你应该能够在使用`docker-compose`进行构建时，使`.env`中的环境变量在Dockerfile的`RUN`命令中可用。
