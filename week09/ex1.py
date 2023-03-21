import psycopg2
from geopy.geocoders import Nominatim

# Connect to the database
conn = psycopg2.connect(dbname='dvdrental', user='postgres', password='galilio', host='localhost', port='5432')
cur = conn.cursor()

# Get the addresses
cur.execute('SELECT * FROM get_addresses()')
addresses = cur.fetchall()

# Create a geolocator
geolocator = Nominatim(user_agent='my_app')

# Iterate over the addresses and update the database
for address in addresses:
  try:
    address_city = str(address[1]) + ", " + str(address[2])
    print(address_city)
    location = geolocator.geocode(address_city)
    longitude = location.longitude
    latitude = location.latitude
  except:
    longitude = 0
    latitude = 0
  
  cur.execute('UPDATE address SET longitude = %s, latitude = %s WHERE address_id = %s', (longitude, latitude, address[0]))
  conn.commit()

# Close the database connection
cur.close()
conn.close()
