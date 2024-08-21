#!/bin/bash

# SSH key path (this key should be generated and placed in the victim machine)
SSH_KEY="/root/.ssh/id_rsa"

# The directory to back up
SOURCE_DIR="/var/www/html/"

# Backup user and machine (this matches the username and the service name in Docker Compose)
BACKUP_USER="backupuser"
BACKUP_MACHINE="backup"

# Destination directory on the backup machine
DEST_DIR="/home/backupuser/backup/"

# Perform the backup using rsync over SSH
rsync -avz -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" $SOURCE_DIR ${BACKUP_USER}@${BACKUP_MACHINE}:${DEST_DIR}
