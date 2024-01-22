""" module for a Python function that returns the list of school having a specific topic
"""


def schools_by_topic(mongo_collection, topic):
    """
    Python function that returns the list of school having a specific topic
    """
    schools = mongo_collection.find({'topics': {'$elemMatch': {'$eq': topic}}})
    return list(schools)
