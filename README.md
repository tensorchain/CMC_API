# Asset Management

## CMC Price Pull

The cmc_btc_api.py script pulls user specified token price and stores the value in an SQL database. The script consists of two functional parts. It first makes the API call by specifying the timestamp, desired token, and desired exchange currency. The script then     

#### Token & Currency Selection




```
timesstamp = js["metadata"]["timestamp"]
btcvalue = js["data"]["1"]["quotes"]["USD"]["price"]
```

```
sqlite_file = 'C:/Users/Tom/Documents/Quant/Database Files/btcusd.sqlite3'
conn = sqlite3.connect(sqlite_file)
c = conn.cursor()
c.execute('INSERT INTO btcprice (Time, USDprice) VALUES (?, ?)', (timesconvert, btcvalue))
```


## Asset Modeling

The asset
