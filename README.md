# ETF_Analysis
Check to see catastrophic risks of my 2x Leveraged ETF's using SQL

The purpose of this script is to see which days my Leveraged ETF's would have gone to zero. I am invested in four of the most popular tech stocks: AAPL, GOOG, META, and MSFT. However, I am not invested directly in the base stocks themselves, but am invested rather through 2x leveraged ETF's. What this means is that I am taking double the risks and double the rewards.

Given that these are mature established tech giants, I feel confident in their long term prospects (over five years). This is nice because I avoid short term tax rates. More importantly it allows me to be aggressive in companies that I, and many people, have confidence in. If there is a particularly bad day, I am confident in a bounceback. The problem with being at 2x however, is that if the base stock ever touches a drop of 50 percent in a single day (see the script for the results!), my ETF will drop 100% to zero, thus removing any chance at this comeback I mentioned. If the base stock has its comeback, it will multiply by my new value in the investment of zero!!! So it will stay at zero. It is important to emphasize that these ETF's reset at the end of each day. So 50% is based from current price to the previous closing price, not 50% of my initial investment. In the script I refer to these 50 percent base stock drops as "catastrophic loss".



