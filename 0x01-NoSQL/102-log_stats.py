#!/usr/bin/env python3
"""
This module provides some stats about Nginx logs stored in MongoDB
"""


if __name__ == '__main__':
    """
    Provides some stats about Nginx logs stored in MongoDB
    """
    from pymongo import MongoClient

    nginx = MongoClient().logs.nginx
    print("{} logs".format(nginx.count_documents({})))
    print("Methods:")
    print("\tmethod GET: {}".format(nginx.count_documents(
                                                {"method": "GET"}
                                                            )))
    print("\tmethod POST: {}".format(nginx.count_documents(
                                                    {"method": "POST"}
                                                            )))
    print("\tmethod PUT: {}".format(nginx.count_documents(
                                                    {"method": "PUT"}
                                                            )))
    print("\tmethod PATCH: {}".format(nginx.count_documents(
                                                    {"method": "PATCH"}
                                                            )))
    print("\tmethod DELETE: {}".format(nginx.count_documents(
                                                    {"method": "DELETE"}
                                                            )))
    print("{} status check".format(nginx.count_documents(
                                                {"method": "GET",
                                                 "path": "/status"}
                                                        )))

    pipeline = [
        {"$group": {"_id": "$ip", "sum": {"$sum": 1}}},
        {"$sort": {"sum": -1}},
        {"$limit": 10}
    ]
    print("IPs:")
    for ip in nginx.aggregate(pipeline):
        print("\t{}: {}".format(ip["_id"], ip["sum"]))
