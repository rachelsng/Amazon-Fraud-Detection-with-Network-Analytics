# Detecting Brands Committing Ratings Fraud on Amazon with Network Analytics

## Context

Fake ratings is a persistent problem for eCommerce companies including Amazon, the world’s largest online retailer. It is especially rampant in consumer electronics, where an estimated [61% of ratings are estimated to be fake](https://review42.com/resources/what-percentage-of-amazon-reviews-are-fake). In September 2021, Amazon [permanently banned over 600 Chinese brands](https://www.theverge.com/2021/9/17/22680269/amazon-ban-chinese-brands-review-abuse-fraud-policy) across 3,000 different seller accounts, including many big names in consumer electronics. Some of them incentivised positive reviews with gift cards, while others offered incentives to customers for deleting negative reviews. 

Given that these modern schemes are pulled off via real users (as opposed to automated schemes involving bots), fraud detection by studying each user in isolation (e.g. looking for signals like click speed etc.) may be insufficient to distinguish between honest and dishonest brands. Hence, we aim to study if network analysis can be used to enhance the detection of dishonest ratings behavior as it is able to capture and quantify differences in interactions between users of a certain brand.

## Objective

- ABC
    - ABC
- ABC
    - ABC

## Dataset

Amazon product and ratings data is accessed from a [repository](https://nijianmo.github.io/amazon/index.html) maintained by the University of California, San Diego (retrieved on April 12, 2022). It consists of data from 1998 to 2018 over 30 product categories. Our analysis is limited to electronics as it has the highest incidence of fraud. However, as we aim to evaluate suspicious activity of brands banned in 2021, we focus on the most recent, complete year of data (2017). 

The following two files are preprocessed and loaded into a PostgreSQL database:

1. *meta_Electronics.json.gz*: 786,445 entries containg product metadata across all time periods and brands.
2. *ratings_Electronics.csv*: 20,553,480 entries, each representing a rating given on the above products.

See *1_Raw_Data_Preparation* and *2_SQL_Table___View_Setup*, located in *1_Database_and_Network_Setup* for detailed steps.

## Network Construction 

We hypothesize that .... 
- <b>Directionally similar rating</b>: either positive (rating of 4 or 5, upon 5), negative (rating of 1 or 2, upon 5) and neutral
(rating of 3 upon 5)
- <b>On the same product </b>: ratings must be on the same unique product id
- <b>With 3 months of each other</b>: each rating by product is joined to all directionally similar ratings 3 months into the
future

## Exploratory Data Analysis

- ABC ABC

*Packages used: pandas, numpy, matplotlib, seaborn*

## Model Building Approach

<b>XGBoost without Network Metrics</b>
- ABC

<b>XGBoost with Network Metrics</b>
- ABC

*Packages used: ABC, ABC*

## Results



## Directory

- *1_Database_and_Network_Setup*: 
- *2_Bad_Brand_Prediction*: 
- *3_Network_Metrics_Computation_and_EDA.ipynb*:

Source and intermediate csv files are quite large and not enclosed in this repository. Please refer to each respective folder for step-by-step instructions to generate data. 

## Credits

This project was co-authored with 