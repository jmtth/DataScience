```
uv run jupyter lab
```

## Data Analyst

I uses `sqlalchemy`, `pandas`, and `matplotlib` to analyze data.
`dotenv` to load environment variables from a .env file.
And I use `jupyter lab` to run the code.

I use `sqlalchemy` to connect to the database and query data.
I record the data in a `pandas` dataframe and then I use `matplotlib` to visualize the data.
pandas is compatible with matplotlib, so I can use pandas to plot the data directly.


### ex00 / pie
I use `matplotlib` to create a pie chart.
pie chart is a circular statistical graphic, which is divided into slices to illustrate numerical proportion.
`autopct` allows to display the percentage of each slice in a pie chart.

### ex01 / chart
I use `matplotlib` to create a chart.

In this query:
```sql
SELECT
    event_time::date AS day,
    COUNT(DISTINCT user_id) AS customer_count
FROM customers
WHERE event_time >= DATE '2022-10-01'
  AND event_time <  DATE '2023-03-01'
  AND event_type = 'purchase'
GROUP BY day
ORDER BY day;
``` 
::date is used to cast the event_time to date type, so that we can group by day.
DISTINCT is used to count the unique user_id, so that we can get the number of unique customers.

`ax.xaxis.set_major_formatter(mdates.DateFormatter("%b"))` is used to format the x-axis labels to show only the month abbreviation. `%b` is the format code for month abbreviation.

Im this query:
```sql
SELECT
    DATE_TRUNC('month', event_time) AS month,
    SUM(price) / 1000000.0 AS sales_millions
FROM customers
WHERE event_type = 'purchase'
  AND event_time >= DATE '2022-10-01'
  AND event_time <  DATE '2023-02-01'
GROUP BY month
ORDER BY month;
```
`DATE_TRUNC('month', event_time)` is used to truncate the event_time to the first day of the month, so that we can group by month.
`SUM(price) / 1000000.0` is used to convert the sales from cents to millions, so that we can display the sales in millions on the y-axis.

```python
df_sales = pd.read_sql_query(query, engine)
df_sales["month"] = pd.to_datetime(df_sales["month"])
df_sales["month_label"] = df_sales["month"].dt.strftime("%b")

ax.bar(
    df_sales["month_label"],
    df_sales["sales_millions"],
    width=0.8,
    color="#AFC0D6",
    edgecolor="white",
    linewidth=1
)
```
`pd.to_datetime` is used to convert the month column to datetime type, so that we can use the dt accessor to extract the month abbreviation.
`width=0.8` is used to set the width of the bars in the bar chart, which is 80% of the available space.

### ex02 / mustache

**boxplot** is a standardized way of displaying the distribution of data based on a five-number summary: 
- minimum
- first quartile (Q1)
- median
- third quartile (Q3)
- maximum

It can also show outliers.

The box is drawn from Q1 to Q3, with a line at the median.
The whiskers extend from the box to the minimum and maximum values, excluding outliers. 
the whiskers are typically drawn to 1.5 times the interquartile range (IQR) from the box.
Outliers are plotted as individual points beyond the whiskers.

![boxplot](boxplot.png)

Parameters of boxplot:
```python
flierprops={
    "marker": "d",
    "markerfacecolor": "#666666",
    "markeredgecolor": "#666666",
    "markersize": 4
}
```
flierprops corresponds to the properties of the outliers in the boxplot:
marker: type of marker ;
markerfacecolor: background color of the marker ;
markeredgecolor: color of the marker's edge ;
markersize: size of the marker.
**Types of markers:**
"d"  # diamond
"o"  # circle
"s"  # square
"x"  # cross
"D"  # large diamond
"."  # small point