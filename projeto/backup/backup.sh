#!/bin/bash

SSH_KEY="/root/.ssh/id_rsa"
SOURCE_DIR="/var/www/html/"
BACKUP_USER="backupuser"
BACKUP_MACHINE="backup"
DEST_DIR="/home/backupuser/backup/"

rsync -avz -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" $SOURCE_DIR ${BACKUP_USER}@${BACKUP_MACHINE}:${DEST_DIR}
