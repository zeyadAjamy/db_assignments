from pymongo import MongoClient
from pprint import pprint
# Connect to the local mongodb
client = MongoClient("mongodb://localhost")

# Get the database called "test"
db = client.test

# Access the collection called "restaurants"
collection = db.restaurants

def insertRestaurant(object):
    res = collection.insert_one(object)
    print("Inserted restaurant with id: ", res.inserted_id)

insert_element = {
    "address": {
        "street": "Sportivnaya",
        "building": "126",
        "zipcode": "420500",
        "coord": [-73.9557413, 40.7720266]
    },
    "borough": "Innopolis",
    "cuisine": "Serbian",
    "name": "The Best Restaurant",
    "restaurant_id": "41712354",
    "grades": [
            {
                "date": "04 Apr, 2023",
                "grade": "A",
                "score": 11
            }
    ]
}


insertRestaurant(insert_element)
