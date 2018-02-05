#!/bin/bash
####################################
#
# Backup to NFS mount script.
#
####################################

# Where to backup to.
dest="/tmp/"

database="database"
user="root"
pass="root"
s3destination="s3://destination"

# Create archive filename.
day=$(date +%H_%M_%d_%m_%Y)
archive_file="backup-sql-$day.tar"
sql_file_dump="full-sql-dump-$day.sql"

# Print start status message.
echo "Backing started"
date
echo

# Make database backup.
mysqldump --user=$user --password=$pass --result-file=$dest$sql_file_dump --databases $database

# Go to target dir.
cd /tmp

# Backup the files using tar.
tar czf $archive_file $sql_file_dump

# Remove temp files.
rm -f /tmp/$sql_file_dump

#-------------------------------------------------------
# Copy to remove data storage.
#-------------------------------------------------------
s3cmd put $archive_file $s3destination
#-------------------------------------------------------

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
# ls -lh $dest
