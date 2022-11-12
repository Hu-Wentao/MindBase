# MindBase

## 安装与配置
> 亚马逊EC2 （Amz Linux）

### 安装配置Docker
1. 安装Docker
sudo amazon-linux-extras install docker

2. 启动Docker服务
sudo service docker start

3.授权
sudo usermod -a -G docker ec2-user

4.安装 docker-compose

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version

### 安装配置Appwrite

sudo docker run -it --rm \
--volume /var/run/docker.sock:/var/run/docker.sock \
--volume "$(pwd)"/appwrite:/usr/src/code/appwrite:rw \
--entrypoint="install" \
appwrite/appwrite:1.0.3

