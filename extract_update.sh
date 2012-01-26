#! /bin/bash
#
# Description: Simple script to extract content from pcap files
#              using extractor.pl then update db using update_db.py
# (fuad.hasan@bigjava.com)

# path to pcap's directory & file list pcap
pcap_dir=/opt/drs/pcap
pcap_list=/opt/drs/read_pcap

# path to script extractor.pl & updater.py 
extractor=/opt/bin/extractor.pl
updater=/opt/bin/updater.py

# 1. extract payload's content from pcap file
for pcap_file in $pcap_list; do
  /usr/bin/perl $extractor ./extractor.pl -q $pcap_path/$pcap_file -D /opt/drs/contents/
  echo "pcap's content extracted successfully"
done

# 2. update db's collection from csv file 
/usr/bin/python $updater
echo "mongodb's collection updated successfully"
