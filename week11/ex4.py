from pymongo import MongoClient
import random
import datetime
# Connect to the local mongodb
client = MongoClient("mongodb://localhost")

# Get the database called "test"
db = client.test

# Access the collection called "restaurants"
collection = db.restaurants

def queryProspectParkWest():
    results = collection.find({"address.street": "Prospect Park West"})
    for restaurant in results:
        grades = restaurant["grades"]
        count_grade_a = 0
        for grade in grades:
            if grade["grade"] == "A":
                count_grade_a += 1
        if count_grade_a > 1:
            # Delete this restaurant
            print(f'Delete this restaurant {restaurant["_id"]}')
            collection.delete_one({"_id": restaurant["_id"]})
        else:
            # Add another A grade to this restaurant
            print(f'Add another A grade to this restaurant {restaurant["_id"]}')
            date = datetime.datetime.now()
            score = random.randint(1, 10)
            collection.update_one({"_id": restaurant["_id"]}, {"$push": {"grades": {"date": date, "grade": "A", "score": score}}})

queryProspectParkWest()