#!/usr/bin/env python3
"""
This module contains the function top_students that returns all students sorted
by average score
"""


def top_students(mongo_collection):
    """
    Returns all students sorted by average score

    Args:
        mongo_collection: pymongo collection object

    Returns:
        list of students sorted by average score
    """
    students = mongo_collection.find({})
    for student in students:
        scores = 0
        for topic in student["topics"]:
            scores += topic["score"]
        topics_length = len(student["topics"])
        if topics_length > 0:
            average_score = scores / topics_length
        else:
            average_score = 0
        mongo_collection.update_one({"name": student["name"]},
                                    {"$set": {"averageScore": average_score}})

    return mongo_collection.find({}).sort("averageScore", -1)
