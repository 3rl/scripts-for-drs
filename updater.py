#! /usr/bin/env python
# -*- coding: utf-8 -*-
#
"""
 Description: Python script to update mongodb's (active_data) collection
              using data output.csv from extractor.pl
 Required   : Python version 2.4/2.6, Pymongo version >1.8
 (fuad.hasan@bigjava.com)
"""

import sys
import csv
import time, datetime
import pymongo
from pymongo import Connection
from pymongo.errors import PyMongoError

def main():
  dbhost = '127.0.0.1'
  dbport = 27017
  dbname = 'drs_db'
  
  filecsv = 'output.csv'
  
  #Time information  
  unix_time_now = time.time()
  print "Unix Time Now: %.6f" % unix_time_now
  date_time_now = datetime.datetime.now()
  print "Date Time Now:", str(date_time_now)
  
  mongo_db = db_connect(dbhost, dbport, dbname)
  read_and_update(filecsv, mongo_db)  

#-------------------------------
#function to get DB's connection
def db_connect(dbhost, dbport, dbname):
  try:
    mongo_conn = Connection(dbhost, dbport)
    print "Success to connect %s at %s:%d" % (dbname, dbhost, dbport)
    return mongo_conn[dbname]
    
  except pymongo.errors.AutoReconnect:
    print "Fail to connect mongodb at %s:%d" % (dbhost, dbport)
    return None

#---------------------------------------------  
#function to read csv file, then update the DB
def read_and_update(filecsv, mongo_db):
  month_now = datetime.datetime.now().strftime('%m%Y')   
  coll_name = 'active_data_' + month_now
  print "Collection's name:", coll_name

  #mongodb -> update process will be atomic operation to a single document
  #pymongo -> query argument must be "homogen" in pymongo
  #pymongo -> multiupdate by passing true as 4th argument & 3rd argument (boolean) is for upsert to update()
  #pymongo -> using safe=True will cause exceptions thrown (of type pymongo.errors.OperationFailure or subclasses)
  #pymongo -> Cursor, the result of a find() call, isn't actually a list, it just implements __getitem__ to emulate list-like access
  
  tot_docs = mongo_db[coll_name].find().count()
  print "Total Documents In Collection:", tot_docs
    
  reader = csv.reader(open(filecsv, 'rb'), delimiter=';', quotechar='"')
  counter = 0
  for line in reader:
    #prepare every fields
    #transport_protocol; apps_prot; src_ipaddr; src_port; dst_ipaddr; dst_port; url; directory; filename; network_protocol;
    transport_protocol = str(line[0])
    #print "transport_protocol:", transport_protocol
    apps_protocol = str(line[1])
    #print "apps_protocol:", apps_protocol
    src_ipaddr = str(line[2])
    #print "src_ipaddr:", src_ipaddr
    src_port = int(line[3])
    #print "src_port: ", src_port
    dest_ipaddr = str(line[4])
    #print "dest_ipaddr:", dest_ipaddr
    dest_port = int(line[5])
    #print "dst_port:", dest_port
    url = str(line[6])
    #print "url:", url
    directory  = str(line[7])
    #print "directory:", directory 
    filename = str(line[8])
    #print "filename:", filename
    network_protocol = str(line[9])
    #print "network_protocol:", network_protocol 
    
    try:
      #mongo_db[coll_name].update({'src_ipaddr': fields_list[2], 'src_port': fields_list[3], 'dst_ipaddr': fields_list[4], 'dst_port': fields_list[5]}, {'$set' : {'apps_protocol': fields_list[1], 'url': fields_list[6], 'directory': fields_list[7], 'filename': fields_list[8], 'network_prot': fields_list[9]}}, safe=True)
      mongo_db[coll_name].update({'src_ipaddr': src_ipaddr, 'src_port': src_port, 'dst_ipaddr': dest_ipaddr, 'dst_port': dest_port}, {'$set' : {'apps_protocol': apps_protocol, 'url': url, 'directory': directory, 'filename': filename, 'network_protocol': network_protocol}})
      print 'Ok, this document updated.'
      counter = counter + 1;
    
    except PyMongoError, error:
      print 'Error accessing DB: ', error.value

  print 'Total Documents That Already Updated:', counter


if __name__ == '__main__':
  main()
