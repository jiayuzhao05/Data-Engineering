#!/bin/bash

# ========== 配置部分 ==========
# 要备份的目录
SOURCE_DIR="$HOME/Documents/mydata"

# 备份目标目录
BACKUP_DIR="$HOME/Backups"

# 日志文件路径
LOG_FILE="$HOME/Backups/backup.log"

# 日期时间戳
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")

# 创建目标文件夹（如果不存在）
mkdir -p "$BACKUP_DIR"

# 备份文件名
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

# ========== 执行备份 ==========
echo "[$(date)] Starting backup..." >> "$LOG_FILE"

# 使用 tar 打包并压缩目录
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" . >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "[$(date)] Backup succeeded: $BACKUP_NAME" >> "$LOG_FILE"
else
    echo "[$(date)] ❌ Backup failed." >> "$LOG_FILE"

    # macOS 弹窗提醒（GUI）
    osascript -e 'display notification "Backup failed." with title "Backup Alert"'

    # 邮件通知
    # echo "Incremental backup failed at $TIMESTAMP" | mail -s "❌ Backup Failed" your@email.com
fi

# 定时任务 
# 0 2 * * * /bin/bash /Users/你的用户名/incremental_backup_notify.sh



# secure backup to google drive

# === 用户设置 ===
SOURCE_DIR="$HOME/Documents/mydata"
BACKUP_TMP="$HOME/.tmp_backup"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
LOG_FILE="$HOME/backup_gdrive.log"

# === 创建临时目录备份（增量方式） ===
mkdir -p "$BACKUP_TMP"

echo "[$TIMESTAMP] Starting rsync backup..." >> "$LOG_FILE"
rsync -av --delete "$SOURCE_DIR/" "$BACKUP_TMP/current/" >> "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo "[$TIMESTAMP] ❌ rsync failed." >> "$LOG_FILE"
    osascript -e 'display notification "Rsync backup failed." with title "Secure Backup"'
    exit 1
fi

# === 上传到 Google Drive 加密目录 ===
echo "[$TIMESTAMP] Starting encrypted upload to gcrypt..." >> "$LOG_FILE"
rclone sync "$BACKUP_TMP/current/" gcrypt:current --progress >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] ✅ Backup + Upload successful." >> "$LOG_FILE"
else
    echo "[$TIMESTAMP] ❌ Upload failed." >> "$LOG_FILE"
    osascript -e 'display notification "GDrive upload failed." with title "Secure Backup"'
fi
