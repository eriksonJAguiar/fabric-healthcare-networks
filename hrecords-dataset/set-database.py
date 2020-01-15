from pymongo import MongoClient
from datetime import datetime
import urllib.parse
import os
import statistics as st
import ast

#username = urllib.parse.quote_plus('admin')
#password = urllib.parse.quote_plus('mongodb')

api = MongoClient('mongodb://localhost:27017')

db = api.hrecords

labs = db.labs

labs2 = db.labsUpdated

def save_mongo(lines):
    json_col = {}
    json_col[lines[1].split(",")[1]] = lines[1].split(",")[2].rstrip()
    aux_time = lines[1].split(",")[0]
    for x in lines[2:]:
        line = x.split(",")
        time =  line[0]
        param = line[1]
        value = line[2].rstrip()
        if aux_time == time: 
            json_col['Time'] = time
            json_col[param] = value
        else:
            labs.insert_one(json_col)
            aux_time = time
            json_col = {}
            json_col[lines[1].split(",")[1]] = lines[1].split(",")[2].rstrip()
            json_col['Time'] = time
            json_col[param] = value

def save_mongo_timestamp(lines):
    json_col = {}
    json_col["_id"] = lines[1].split(",")[2].rstrip()
    last_time = datetime.strptime(lines[len(lines)-1].split(",")[0],"%M:%S")
    first_time = datetime.strptime(lines[1].split(",")[0],"%M:%S")
    t = last_time - first_time
    json_col['Time'] = t.total_seconds()
    list_param = []
    for x in lines[2:]:
        line = x.split(",")
        param = line[1]
        if not param in list_param:
            list_param.append(param)
            json_col[param] = list()
        value = line[2].rstrip()           
        json_col[param].append(ast.literal_eval(value))
    
    for j in list_param:
        val = st.median(json_col[j])
        if isinstance(val, float):
            json_col[j] = round(val, 2)
        else:
            json_col[j] = val

    labs.insert_one(json_col)


def save_all_docs():
    folders = ['set-a','set-b']
    for i in folders:
        for r, d, f in os.walk('./%s'%(i)):
            for file in f:
                f = open(os.path.join(r, file),"r")
                lines = f.readlines()
                f.close()
                save_mongo_timestamp(lines)

save_all_docs()