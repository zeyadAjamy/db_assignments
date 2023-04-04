from pymongo import MongoClient
from pprint import pprint
# Connect to the local mongodb
client = MongoClient("mongodb://localhost")

# Get the database called "test"
db = client.test

# Access the collection called "restaurants"
collection = db.restaurants

def deleteBrooklyn():
    res = collection.delete_one({"borough": "Brooklyn"})
    print(f'Deleted {res.deleted_count} document(s).')

def deleteThai():
    res = collection.delete_many({"cuisine": "Thai"})
    print(f'Deleted {res.deleted_count} document(s).')
    
# Call the functions
deleteBrooklyn()
deleteThai()