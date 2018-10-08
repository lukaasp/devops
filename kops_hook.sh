#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
while true;do
    if [ `sudo systemctl is-active docker` = "active" ];then
        echo "Docker is running ... continuing with installation."
        docker -v
        break;
    fi
    echo "Waiting till nodeup finishes docker installation ..."
    sleep  10
done
echo "Waiting 5 minutes till all containers are up and running..."
sleep 300
tee /etc/docker/daemon.json <<EOF
{
    "storage-driver": "overlay2"
}
EOF
pkill -SIGHUP dockerd
while sudo fuser while sudo fuser /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock >/dev/null 2>&1; do
    echo "Waiting for lock to be released ..."
    sleep 10
done
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get update
wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_18.06.1~ce~3-0~ubuntu_amd64.deb
while sudo fuser while sudo fuser /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock >/dev/null 2>&1; do
    echo "Waiting for lock to be released ..."
    sleep 10
done
dpkg -i docker-ce_18.06.1~ce~3-0~ubuntu_amd64.deb
while sudo fuser while sudo fuser /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock >/dev/null 2>&1; do
    echo "Waiting for lock to be released ..."
    sleep 10
done
apt-get install -o Dpkg::Options::="--force-confold" -y nvidia-docker2
tee /etc/docker/daemon.json <<EOF
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "storage-driver": "overlay2"
}
EOF
systemctl daemon-reload
pkill -SIGHUP dockerd
systemctl restart kubelet
