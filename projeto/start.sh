#!/bin/bash

docker compose up --build -d victim backup

VIC_CONTAINER_ID=$(docker compose ps -q victim)
BACKUP_CONTAINER_ID=$(docker compose ps -q backup)

echo "Victim container ID: $VIC_CONTAINER_ID"
echo "Backup container ID: $BACKUP_CONTAINER_ID"

if [ -z "$VIC_CONTAINER_ID" ]; then
    echo "Victim container is not running. Please check your setup."
    exit 1
fi

if [ -z "$BACKUP_CONTAINER_ID" ]; then
    echo "Backup container is not running. Please check your setup."
    exit 1
fi
echo "Waiting for SSH service to be ready on backup container..."
sleep 5
docker exec "$VIC_CONTAINER_ID" cat /root/.ssh/id_rsa.pub | docker exec -i "$BACKUP_CONTAINER_ID" bash -c 'cat >> /home/backupuser/.ssh/authorized_keys'
docker exec "$BACKUP_CONTAINER_ID" bash -c 'chmod 700 /home/backupuser/.ssh && chmod 600 /home/backupuser/.ssh/authorized_keys && chown -R backupuser:backupuser /home/backupuser/.ssh'
