# # Step 1: Build and start the containers
# docker compose up --build

# # Step 2: Copy the public key from the victim container
# VIC_CONTAINER_ID=$(docker compose ps -q victim)

# # Check if the victim container is running and accessible
# if [ -z "$VIC_CONTAINER_ID" ]; then
#     echo "Victim container is not running. Please check your setup."
#     exit 1
# fi

# docker cp "$VIC_CONTAINER_ID:/root/.ssh/id_rsa.pub" ./backup/authorized_keys

# # Step 3: Rebuild the backup container to include the public key
# docker compose up --build backup

# # Step 4: Verify the authorized_keys file was copied correctly
# BACKUP_CONTAINER_ID=$(docker compose ps -q backup)

# if [ -z "$BACKUP_CONTAINER_ID" ]; then
#     echo "Backup container is not running. Please check your setup."
#     exit 1
# fi

# docker exec -it "$BACKUP_CONTAINER_ID" bash -c "cat /home/backupuser/.ssh/authorized_keys"

# echo "Public key from the victim machine has been successfully copied to the backup machine."

#!/bin/bash

# Step 1: Build and start the victim container

#!/bin/bash

echo "Step 1: Building and starting the victim container..."
docker compose up --build -d victim backup

# Step 2: Get the container IDs
VIC_CONTAINER_ID=$(docker compose ps -q victim)
BACKUP_CONTAINER_ID=$(docker compose ps -q backup)

echo "Victim container ID: $VIC_CONTAINER_ID"
echo "Backup container ID: $BACKUP_CONTAINER_ID"

# Check if the victim container is running and accessible
if [ -z "$VIC_CONTAINER_ID" ]; then
    echo "Victim container is not running. Please check your setup."
    exit 1
fi

# Check if the backup container is running and accessible
if [ -z "$BACKUP_CONTAINER_ID" ]; then
    echo "Backup container is not running. Please check your setup."
    exit 1
fi

# Wait a few seconds to ensure SSH is up and running in the backup container
echo "Waiting for SSH service to be ready on backup container..."
sleep 5

echo "Step 3: Copying the public key from the victim to the backup container..."
# Copy the public key from victim to backup container's authorized_keys
docker exec "$VIC_CONTAINER_ID" cat /root/.ssh/id_rsa.pub | docker exec -i "$BACKUP_CONTAINER_ID" bash -c 'cat >> /home/backupuser/.ssh/authorized_keys'

echo "Step 4: Setting correct permissions on the authorized_keys file and .ssh directory..."
# Set correct permissions for SSH to work properly
docker exec "$BACKUP_CONTAINER_ID" bash -c 'chmod 700 /home/backupuser/.ssh && chmod 600 /home/backupuser/.ssh/authorized_keys && chown -R backupuser:backupuser /home/backupuser/.ssh'

echo "Public key has been successfully copied."


