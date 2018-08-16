# Asset Management

## CMC Price Pull

The cmc_btc_api.py script pulls user specified token price and stores the value in an SQL database. The script consists of two functional parts. It first makes the API call by specifying the timestamp, desired token, and desired exchange currency. The script then     

#### I. Token & Currency Selection

The CoinMarketCap (CMC) JSON v2 ticker schema packages coin information into high level key-value pairs in which coin properties are stored in a dictionary corresponding to the coin ID key. Within the dictionary, the coin    
several levels denoting coin ID, coin name, abbreviated symbol, circulating supply, total supply, and maximum supply.    

```
timesstamp = js["metadata"]["timestamp"]
btcvalue = js["data"]["1"]["quotes"]["USD"]["price"]
```

#### II. SQL DB Transfer

```
sqlite_file = 'C:/Users/Tom/Documents/Quant/Database Files/btcusd.sqlite3'
conn = sqlite3.connect(sqlite_file)
c = conn.cursor()
c.execute('INSERT INTO btcprice (Time, USDprice) VALUES (?, ?)', (timesconvert, btcvalue))
```


## Asset Modeling

The asset
