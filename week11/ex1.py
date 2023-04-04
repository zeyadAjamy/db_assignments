from pymongo import MongoClient
from pprint import pprint
# Connect to the local mongodb
client = MongoClient("mongodb://localhost") 

# Get the database called "test"
db = client.test

# Access the collection called "restaurants"
collection = db.restaurants

def queryIrish():
    print("Querying all Irish cuisines...\n")
    for restaurant in collection.find({"cuisine": "Irish"}):
        pprint(restaurant)

def queryIrishRussian():
    print("Querying all Irish and Russian cuisines...\n")
    for restaurant in collection.find({"$or": [{"cuisine": "Irish"}, {"cuisine": "Russian"}]}):
        pprint(restaurant)
        
def findRestaurant():
    print("Finding a restaurant with the following address: Prospect Park West 284, 11215...\n")
    for restaurant in collection.find({"address.street": "Prospect Park West", "address.building": "284" , "address.zipcode": "11215"}):
        pprint(restaurant)
        
# Call the functions
queryIrish()
queryIrishRussian()
findRestaurant()