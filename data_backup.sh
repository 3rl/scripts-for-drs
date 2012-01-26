#! /bin/bash
#
# Description: Simple script to backup data in
#              multiple directories
# (fuad.hasan@bigjava.com)

# timestamp
stamp=$(date -u  +%F)
# path to folder
kind=contents
backup_dir=/home/erlang/backup
contents_dir=./backup_me
temp_dir=/home/erlang/Download/test_chaosreader/example_backup_script
dest_dir=$backup_dir/Data-$stamp
log_file=$dest_dir/log.$kind

if [ ! -d $dest_dir ]; then
	mkdir $dest_dir
fi

cd $temp_dir
echo "Starting Backup..."
contents_list=`ls $contents_dir`

if [ -e $log_file ]; then
  echo $contents_list >> $log_file
else  
  echo $contents_list > $log_file
fi

tar cjf contents-$stamp.tar.bz2 $contents_dir
mv contents-$stamp.tar.bz2 $dest_dir

cd $contents_dir
for folder in $contents_list;
do
	echo -ne "Backing up directory $data ... "
	#rm -rf $folder
  echo $folder
  echo "Done."
done

echo "Backup Complete!"
exit 0
