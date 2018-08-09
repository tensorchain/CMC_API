import urllib.request, urllib.parse, json, datetime, sqlite3

# Make an API call and store the response
url = 'https://api.coinmarketcap.com/v2/ticker/'
uh = urllib.request.urlopen(url)
data = uh.read().decode()

try:
    js = json.loads(data)
except:
    js = None

errorstatus = js["metadata"]["error"]

if not js or errorstatus != None:
    print('==== Failure to Retrieve ====')

timesstamp = js["metadata"]["timestamp"]
btcvalue = js["data"]["1"]["quotes"]["USD"]["price"]
timesconvert = datetime.datetime.fromtimestamp(timesstamp).isoformat()

sqlite_file = 'C:/Users/Tom/Documents/Quant/Database Files/btcusd.sqlite3'
conn = sqlite3.connect(sqlite_file)
c = conn.cursor()
c.execute('INSERT INTO btcprice (Time, USDprice) VALUES (?, ?)', (timesconvert, btcvalue))

def printable():
    c.execute("SELECT * FROM btcprice")
    print(c.fetchall())

# printable()

conn.commit()
conn.close()


# Store API response in a variable
#response_dict = r.json()

# Process results
#print(response_dict.keys())
