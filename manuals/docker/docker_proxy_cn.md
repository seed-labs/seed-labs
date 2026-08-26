# 设置 Docker 代理

SEED 实验用的容器镜像存储在 Docker Hub 上，从国内访问 Docker Hub 经常不稳定，需要通过 Docker 代理。
我们需要将代理信息添加到 Docker 的代理文件中 `/etc/docker/daemon.json`。

  - 打开或创立 `daemon.json` 文件 （可以用其他的编辑器，但必须用 root 权限）
  ```bash
  sudo vim /etc/docker/daemon.json
  ```

  - 在文件中添加下面的条目。这些代理在写这个文档时是工作的，但情况会变的。如果它们不工作了，
  可以在网上找到其它的代理。

  ```json
  {
    "registry-mirrors":[
        "https://docker.1panel.live",
        "https://docker.anyhub.us.kg",
        "https://dockerhub.icu"
    ]
  }
  ```

  - 重启 docker
  ```bash
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  ```
