FROM debian:stretch-slim

RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    sed -i 's/security.debian.org\/debian-security/archive.debian.org\/debian-security/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y openssh-server rsync sudo && \
    mkdir /var/run/sshd && \
    useradd -m -d /home/backupuser -s /bin/bash backupuser && \
    echo 'backupuser:backup' | chpasswd && \
    mkdir /home/backupuser/.ssh && \
    chmod 700 /home/backupuser/.ssh && \
    echo 'backupuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
