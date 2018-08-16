# Asset Management

## CoinMarketCap Price Pull

The cmc_btc_api.py script pulls user specified token price and stores the value in an SQL database. The script consists of two functional parts. It first makes the API call by specifying the timestamp, desired token, and desired exchange currency. The script then     

#### I. Token Price Selection

The CoinMarketCap (CMC) JSON v2 ticker schema packages coin information into high level key-value pairs in which coin properties are stored in a dictionary corresponding to the coin ID key. Within the dictionary, key-value pairs provide coin property information, such as name, abbreviated symbol, circulating supply, total supply, and maximum supply. The "quotes" key contains dictionaries of the USD exchange rate properties for the coin.     

Below is an example showing the location of the TRON USD price value. It is located as the value pair to the "price" key inside the "USD" dictionary, which is subsequently part of the "quotes" dictionary: 

```
"1958": {
            "id": 1958, 
            "name": "TRON", 
            "symbol": "TRX", 
            "website_slug": "tron", 
            "rank": 12, 
            "circulating_supply": 65748111645.0, 
            "total_supply": 99000000000.0, 
            "max_supply": null, 
            "quotes": {
                "USD": {
                    "price": 0.0197016268, 
                    "volume_24h": 117266475.97462, 
                    "market_cap": 1295344760.0, 
                    "percent_change_1h": 1.29, 
                    "percent_change_24h": -2.41, 
                    "percent_change_7d": -22.12
                }
            }, 
            "last_updated": 1534433753
```
To adjust the python script

```
timesstamp = js["metadata"]["timestamp"]
coinvalue = js["data"]["1"]["quotes"]["USD"]["price"]
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
