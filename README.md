# Scripts Guide - For Tian Han Review


## CoinMarketCap Price Pull

The cmc_btc_api.py script pulls user specified token price and stores the value in an SQL database. The script consists of two functional parts. It first makes the API call by specifying the timestamp, desired token, and desired exchange currency. The script then transfers price and timestamp data to an SQL database for post-processing.      

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
To pull specific token exchange USD price values, simply adjust the corresponding dictionary number in the second bracket of line 19 in cmc_btc_api.py. For example, inputting "1958" in the bracket between "data" and "quotes" produces TRON USD exchange prices: 

```
timesstamp = js["metadata"]["timestamp"]
coinvalue = js["data"]["1958"]["quotes"]["USD"]["price"]
```

#### II. SQL Database Transfer

To transfer the data to a database, adjust the "sqlite_file" link to reflect the target database:

```
sqlite_file = 'C:/Users/Tom/Documents/Quant/Database Files/btcusd.sqlite3'
conn = sqlite3.connect(sqlite_file)
c = conn.cursor()
c.execute('INSERT INTO coinprice (Time, USDprice) VALUES (?, ?)', (timesconvert, coinvalue))
```

####  III. SQL to CSV Conversion

The volatility_mod.m post-pocessing script only accepts csv files for input. Therefore, the user should first output the database list as a csv file prior to running the volatility_mod.m script. To 


## Token Price Modeling

The volatility_mod.m script runs the imported token price data through several processing steps to create analysis outputs. The processing steps are:

1. Normality Testing of Token Daily Returns via Pearson Chi Square Test
2. Modeling Daily Volatility via GARCH(1,1) Maximum Likelihood Estimate
3. Auto-Correlation and Ljung-Box Test for GARCH(1,1) Results
4. Modeling Daily Volatility via Expoentially Weighted Moving Average (EWMA)

The analysis output results are:

1. P-Value from Normality Testing
2. Omega, Alpha, and Beta Constants from GARCH(1,1) Modeling
3. GARCH(1,1) Long-Term Volatility
4. Auto-Correlation Graph
5. Returns Distribution and Asset Price Distribution Histograms
6. Asset Spot Price vs. Volatility Models Time Series Charts

#### I. Import Token Prices

The 
