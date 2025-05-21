############################  BASIC DATA PIPELINE in Bash ############################


# This is a basic data pipeline script that automates the process of downloading, processing,
# and loading data into a database. The script is designed to be modular and easy to maintain.
# 1. Connects to an SFTP server and downloads .zip files
# 2. Unzips them
# 3. Runs a Python pre-processor
# 4. Loads the data into a database (e.g., PostgreSQL)
# 5. Creates logs at each step
# 6. Notifies or triggers a Tableau refresh via REST API

#############################   ASSUMPTIONS #############################
# Runs on a Linux server with:
# sftp, unzip, psql (PostgreSQL client), curl installed
# Credentials and paths are managed via environment variables or a config file
# Pre-processor is a Python script named preprocess.py
# Tableau Server supports REST API and your credentials/token are set

# /data_pipeline/
# ├── config.env
# ├── pipeline.sh
# ├── preprocess.py
# ├── logs/


########################### pipeline.sh #########################

# This script is a basic data pipeline that connects to an SFTP server, downloads zip files,
# unzips them, processes the data with a Python script, loads it into a PostgreSQL database,
# and notifies Tableau to refresh the dashboard.
# It also creates logs at each step of the process.
# The script assumes that the necessary credentials and paths are set in a config file.
# The script is designed to be run on a Linux server with the necessary tools installed.
# The script is structured to be modular and easy to maintain.
# It uses functions to encapsulate each step of the process, making it easy to modify or extend.
# The script is designed to be run as a cron job or manually as needed.
# The script is designed to be run in a directory structure that includes a config file, a Python pre-processor script, and a logs directory.



#!/bin/bash

set -e
source ./config.env

LOGFILE="./logs/pipeline_$(date '+%Y%m%d_%H%M%S').log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOGFILE"
}

log "STEP 1: Downloading zip files from SFTP"
sftp "$SFTP_USER@$SFTP_HOST" <<EOF
cd $SFTP_REMOTE_DIR
lcd $LOCAL_DOWNLOAD_DIR
mget *.zip
bye
EOF

log "STEP 2: Unzipping downloaded files"
for zip_file in "$LOCAL_DOWNLOAD_DIR"/*.zip; do
  unzip -o "$zip_file" -d "$EXTRACT_DIR"
  log "Unzipped: $zip_file"
done

log "STEP 3: Running Python pre-processor"
python3 preprocess.py "$EXTRACT_DIR" "$PROCESSED_DIR" | tee -a "$LOGFILE"

log "STEP 4: Loading processed files into PostgreSQL"
for csv_file in "$PROCESSED_DIR"/*.csv; do
  table_name=$(basename "$csv_file" .csv)
  log "Loading $csv_file into $table_name"
  psql "$DB_CONN_STRING" -c "\copy $table_name FROM '$csv_file' CSV HEADER"
done

log "STEP 5: Notifying Tableau to refresh dashboard"
curl -X POST "$TABLEAU_API_URL" \
     -H "X-Tableau-Auth: $TABLEAU_AUTH_TOKEN" \
     -d "{\"dashboard_id\": \"$TABLEAU_DASHBOARD_ID\"}" \
     -H "Content-Type: application/json"

log "Pipeline execution completed successfully!"

############################  CONFIGURATION FILE ############################

# config.env
# Configuration file for the data pipeline
# This file contains environment variables that are used in the pipeline script.
# It is recommended to keep this file secure and not share it publicly.
# SFTP server credentials

# SFTP Configuration
SFTP_USER=username
SFTP_HOST=sftp.example.com
SFTP_REMOTE_DIR=/data
LOCAL_DOWNLOAD_DIR=./downloads
EXTRACT_DIR=./extracted
PROCESSED_DIR=./processed

# PostgreSQL
DB_CONN_STRING="host=localhost dbname=mydb user=dbuser password=dbpass"

# Tableau
TABLEAU_API_URL="https://tableau.example.com/api/refresh_dashboard"
TABLEAU_AUTH_TOKEN="your_tableau_token"
TABLEAU_DASHBOARD_ID="dashboard123"
# Ensure the logs directory exists


###################################### PREPROCESSOR SCRIPT ######################################

# preprocess.py

# Python script to preprocess data files
# This script takes input and output directories as arguments
# It processes the data files in the input directory and saves the processed files in the output directory

import sys
import pandas as pd
import os

src_dir = sys.argv[1]
dst_dir = sys.argv[2]

os.makedirs(dst_dir, exist_ok=True)

for file in os.listdir(src_dir):
    if file.endswith(".csv"):
        df = pd.read_csv(os.path.join(src_dir, file))
        # Example transformation
        df.dropna(inplace=True)
        df.columns = [c.strip().lower() for c in df.columns]
        df.to_csv(os.path.join(dst_dir, file), index=False)
        print(f"Processed {file}")
# Ensure the logs directory exists

# this is how you will execute the script

chmod +x pipeline.sh
./pipeline.sh

#######  ADDITIONAL FUNCTIONALITY: EMAIL NOTIFICATION #####


# This section adds email notification functionality to the pipeline script
# It sends an email alert after each step of the pipeline execution
# The email contains the status of the pipeline execution and a summary of the logs


#Updated config.env

# SFTP Configuration

SFTP_USER=username
SFTP_HOST=sftp.example.com
SFTP_REMOTE_DIR=/data
LOCAL_DOWNLOAD_DIR=./downloads
PROCESSED_DIR=./processed

# PostgreSQL
DB_CONN_STRING="host=localhost dbname=mydb user=dbuser password=dbpass"

# Tableau
TABLEAU_API_URL="https://tableau.example.com/api/refresh_dashboard"
TABLEAU_AUTH_TOKEN="your_tableau_token"
TABLEAU_DASHBOARD_ID="dashboard123"

# Email

EMAIL_ALERTS="data.team@example.com"


# Add email notification after each step

#!/bin/bash

set -euo pipefail
source ./config.env

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOGFILE="./logs/pipeline_${TIMESTAMP}.log"
STATUS="SUCCESS"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOGFILE"
}

trap 'STATUS="FAILED"; send_email' ERR

send_email() {
  SUBJECT="Data Pipeline Job [$STATUS] - $TIMESTAMP"
  TO="$EMAIL_ALERTS"
  {
    echo "Pipeline run completed with status: $STATUS"
    echo "Timestamp: $TIMESTAMP"
    echo ""
    echo "Log Summary:"
    tail -n 20 "$LOGFILE"
  } | mail -s "$SUBJECT" "$TO"
}

log "STEP 1: Downloading GZIP files from SFTP"
sftp "$SFTP_USER@$SFTP_HOST" <<EOF
cd $SFTP_REMOTE_DIR
lcd $LOCAL_DOWNLOAD_DIR
mget *.gz
bye
EOF

log "STEP 2: Extracting GZIP files"
for gz_file in "$LOCAL_DOWNLOAD_DIR"/*.gz; do
  gunzip -kf "$gz_file"
  log "Extracted: $gz_file"
done

log "STEP 3: Running Python pre-processor"
python3 preprocess.py "$LOCAL_DOWNLOAD_DIR" "$PROCESSED_DIR" | tee -a "$LOGFILE"

log "STEP 4: Loading processed files into PostgreSQL"
for csv_file in "$PROCESSED_DIR"/*.csv; do
  table_name=$(basename "$csv_file" .csv)
  log "Loading $csv_file into $table_name"
  psql "$DB_CONN_STRING" -c "\copy $table_name FROM '$csv_file' CSV HEADER"
done

log "STEP 5: Notifying Tableau to refresh dashboard"
curl -X POST "$TABLEAU_API_URL" \
     -H "X-Tableau-Auth: $TABLEAU_AUTH_TOKEN" \
     -d "{\"dashboard_id\": \"$TABLEAU_DASHBOARD_ID\"}" \
     -H "Content-Type: application/json"

log "Pipeline execution completed successfully."
send_email

