#!/bin/bash
####################################
#
# Backup to NFS mount script.
#
####################################

# What to backup.
project_dir="/home/user/"
project="test.com"

# Where to backup to.
dest="/tmp/"

database="database"
user="root"
pass="root"
s3destination="s3://destination"

# Create archive filename.
day=$(date +%H_%M_%d_%m_%Y)
archive_file="backup-all-$day.tar"
sql_file_dump="sql-dump-$day.sql"
files_file_dump="files-dump-$day.tar"

# Print start status message.
echo "Backing started"
date
echo

# Make database backup.
mysqldump --user=$user --password=$pass --result-file=$dest$sql_file_dump --databases $database

# Go to target dir.
cd $project_dir

# Backup the files using tar.
tar cf $dest$files_file_dump $project

# Go to target dir.
cd /tmp

# Backup the files using tar.
tar czf $archive_file $sql_file_dump $files_file_dump

# Remove temp files.
rm -f /tmp/$sql_file_dump
rm -f /tmp/$files_file_dump

#-------------------------------------------------------
# Copy to remove data storage.
#-------------------------------------------------------
s3cmd put $archive_file $s3destination
#-------------------------------------------------------

# Remove archive file.
rm -f /tmp/$archive_file

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
# ls -lh $dest
