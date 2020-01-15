from pymongo import MongoClient
from pathlib import Path

import ipfshttpclient
import os
import errno
import hashlib
import urllib.parse

home = str(Path.home())
path_default = home+"/.ipfs-storage"
api_ipfs = ipfshttpclient.connect('/ip4/10.62.9.23/tcp/5001')

def init_database():
    #username = urllib.parse.quote_plus('admin')
    #password = urllib.parse.quote_plus('admin')

    api = MongoClient('mongodb://localhost:27017')

    db = api.hrecords

    collection = db.labs

    return collection

def init_repo():
    if not os.path.exists(path_default):
        try:
            os.makedirs(path_default)
        except:
            pass

def request_all_data():
    init_repo()
    collection = init_database()
    datas = list(collection.find({}))
    
    fileName = "ids.txt"

    ids = [d['_id'] for d in datas]

    with open("%s/%s"%(path_default,fileName), "a+") as file:
        file.writelines("%s\n"% val for val in ids)

    ref = api_ipfs.add("%s/%s"%(path_default,fileName))

    return ref['Hash']


def select_all_data(ref_hash):
    fileName = api_ipfs.get_json(ref_hash)

    return fileName



hash = request_all_data()
print(hash)
print(select_all_data(hash))






    
        
