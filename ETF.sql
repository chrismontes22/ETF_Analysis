/* Here is a basic SQL analysis to find out how many days a base stock dipped below 50%, based off historical data. Since it is a 2x ETF, this would lead to total loss with no chance of recovery.
 * This script focuses sepcifically on the intraday lows. For catastrophic loss to occur with my 2x leveraged ETF's, the stock simply has to dip 50% at any point in the day.
 * For more information head over to the Readme.md. https://github.com/chrismontes22/ETF_Analysis/blob/main/README.md

 
 * In order to run this script, first download the CSV files with the historical data.
 * Then you log into your postgres server and a database. If you are using psql, simply copy and paste this script as is into the CLI.
 * If you are using a GUI instead, you will need to allow permission to use the downloaded CSV files. Then in the COPY line remove the "\" at the begining.
 * To look at different stocks, simply find and replace all of the AAPL tickers with the ticker of your choice.
 * Finally, while the default is set to search for days where the low crossed 50%, you can change the last integer to any value. Useful to see the days where it also has come close.
*/


CREATE TABLE AAPL (
    "Date" DATE,
    "Open" NUMERIC,
    "High" NUMERIC,
    "Low" NUMERIC,
    "Close" NUMERIC,
    "Adj Close" NUMERIC,
    "Volume" BIGINT
);


--If you are not using psql, remove the "\" at the begining of this line. Make sure the permissions are set
\COPY AAPL("Date", "Open", "High", "Low", "Close", "Adj Close", "Volume") FROM 'PATH\TO\FILE\AAPL.csv' DELIMITER ',' CSV HEADER;

/*
As stated before, we want to see any day where the Low crosses the set threshold. Adjustments are necessary because stock splits and other nominal stock events change the price.
Many such stock events would result in days that dip below the 50% threshold. For example, if a day makes no gains or losses (no change in price), but has a 2:1 stock split, the script would show the day as a catastrophic loss.
"Adj Close" counts for this, but we need to find the "Adj Low" since catastrophic loss can occur during the trading session. ("Adj Close" / "Close") of the given day gives us the ratio needed to adjust for nominal stock events.
I will call this ratio "Nominal Event Ratio". Basically I am leveraging a second CTE in order to simplify the calculation. 
The calculation without the second CTE would be;
(("Low" * ("Adj Close" / "Close") - LAG("Adj Close") OVER (ORDER BY "Date")) / (LAG("Adj Close") OVER (ORDER BY "Date"))) * 100 AS "Percent Change".
Instead it's somplified to;
(("Low" * "Nominal Event Ratio" - "Previous Adj Close") / "Previous Adj Close") * 100 AS "Percent Change"
Then we basically do a percent change calculation ((a-b)/b), where a is the "Adj Low" and b is the PREVIOUS day's "Adj Close", to find the true day's low.
*/
WITH Daily_Changes AS (
    SELECT
        "Date",
        "Adj Close",
        "Low",
        "Close",
        ("Adj Close" / "Close") AS "Nominal Event Ratio",
        LAG("Adj Close") OVER (ORDER BY "Date") AS "Previous Adj Close"
    FROM AAPL
),
Percent_Changes AS (
    SELECT
        "Date",
        (("Low" * "Nominal Event Ratio" - "Previous Adj Close") / "Previous Adj Close") * 100 AS "Percent Change"
    FROM Daily_Changes
)
SELECT "Date", "Percent Change"
FROM Percent_Changes
WHERE "Percent Change" <= -50;


--After looking at all the days for the four stocks (AAPL, GOOG, META, MSFT), only AAPL has experienced one single day where it dropped below 50% in any trading day.
--This was during the tech bubble burst of 2000, but AAPL is now a much more mature company.

