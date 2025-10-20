#!/bin/bash
DATE=$(date +%Y%m%d_%H%M)
BACKUP_DIR=./backups
CONTAINER=postgres
USER=postgres

mkdir -p $BACKUP_DIR
docker exec -t $CONTAINER pg_dumpall -U $USER > $BACKUP_DIR/backup_$DATE.sql
find $BACKUP_DIR -type f -mtime +7 -delete
echo "✅ Backup completed: $BACKUP_DIR/backup_$DATE.sql"
