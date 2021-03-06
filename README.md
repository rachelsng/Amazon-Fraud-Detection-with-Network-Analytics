# Detecting Brands Committing Ratings Fraud on Amazon with Network Analytics

## Context

Fake ratings is a persistent problem for eCommerce companies including Amazon, the world’s largest online retailer. It is especially rampant in consumer electronics, where an estimated [61% of ratings are estimated to be fake](https://review42.com/resources/what-percentage-of-amazon-reviews-are-fake). In September 2021, Amazon [permanently banned over 600 Chinese brands](https://www.theverge.com/2021/9/17/22680269/amazon-ban-chinese-brands-review-abuse-fraud-policy) across 3,000 different seller accounts, including many big names in consumer electronics. Some of them incentivised positive reviews with gift cards, while others offered incentives to customers for deleting negative reviews. 

Given that these modern schemes are pulled off via real users (as opposed to automated schemes involving bots), fraud detection relying on user-specific signals (e.g. click speed) may be insufficient to distinguish between honest and dishonest brands. Hence, we aim to study if network analysis can be used to enhance the detection of dishonest ratings behavior as it is able to capture and quantify differences in interactions between users of a certain brand.

<img src="./images/context.png" alt="Amazon review fraud ban" width="500"/>

## Objective

1. Predict which brands are engaging in ratings fraud
2. Demonstrate that network metrics can help to improve prediction accuracy

## Dataset

Amazon product and ratings data is accessed from a [repository](https://nijianmo.github.io/amazon/index.html) maintained by the University of California, San Diego (retrieved on April 12, 2022). It consists of data from 1998 to 2018 over 30 product categories. Our analysis is limited to electronics as it has the highest incidence of fraud. However, as we aim to evaluate suspicious activity of brands banned in 2021, we focus on the most recent, complete year of data (2017). 

The following two files are preprocessed and loaded into a PostgreSQL database:

1. *meta_Electronics.json.gz*: 786,445 entries containg product metadata across all time periods and brands.
2. *ratings_Electronics.csv*: 20,553,480 entries, each representing a rating given on the above products.

See *1_Raw_Data_Preparation* and *2_SQL_Table___View_Setup*, located in *1_Database_and_Network_Setup* for detailed steps.

## Sample Construction 

- <b>Dishonest/Bad Brands</b>: We are able to find 14 brands out of the 600 banned that have been [publicly identified](https://www.gadgetsnow.com/slideshows/19-chinese-consumer-electronics-brands-banned-by-amazon/photolist/84008698.cms), operating in the consumer electronics space and also present in the 2017 dataset.
- <b>Honest/Good Brands</b>: We sample 7% of the 2,694 brands that have at least one product rating in 2017 and at least 100 ratings in total (top 88th percentile of brands). Brands are then checked manually to ensure they are still present on Amazon as of 2022. This is because not all banned brands were publicly disclosed and we should not risk potential sample contamination by including brands that can no longer be found on Amazon.

## Network Construction 

Nodes are defined as any unique user who has left a rating during that time period. Edges/Links are defined between users when ratings meet the following criteria:

- <b>Directionally similar rating</b>: either positive (rating of 4 or 5, upon 5), negative (rating of 1 or 2, upon 5) and neutral
(rating of 3 upon 5)
- <b>On the same product </b>: ratings must be on the same unique product id
- <b>With 3 months of each other</b>: each rating by product is joined to all directionally similar ratings 3 months into the
future

The intent of creating the edges in this manner is to ensure we are able to capture user groups that are rating many products similarly within a short timeframe (3 months). 

We hypothesize that nodes in dishonest brands will have many edges formed between them as dishonest users will presumably <b>rate many products</b> from the same brand positively, and do so in the <b>same short time frame</b> where the pay-for-ratings incentive schemes are activated. 

For honest brands, it is hypothesized that users may just purchase and leave ratings for the few products that they need and hence edge formation should be much lower and mainly by chance.

See *3_Brand_Network_Extraction_From_Database.ipynb*, located in *1_Database_and_Network_Setup* for detailed steps.

## Exploratory Data Analysis Highlights

### Non-Network Features
- The most notable is the <b>standard deviation of ratings</b> as this feature is clearly clustered around the 1.3 to 1.4 mark for banned brands but uniformly distributed for good brands. This makes sense as bad brands may consistently have more extreme reviews (e.g. 5 for fradulent positive ratings and 1 for disgruntled real users).

<img src="./images/std_rating_eda.png" alt="standard deviation of ratings" width="300"/>

### Network Features

Various network features also differ between the good (label = 0, left) and bad (label = 1, right).

- <b>Clustering</b>: Generally higher for bad brand
- <b>Degree</b>: Generally higher for bad brand
- <b>Largest Component</b>: Generally higher for bad brand, even when normalised by number of nodes (to control for brand popularity).

<img src="./images/network_metrics.png" alt="network metrics differences" width="700"/>

See *3_Network_Metrics_Computation_and_EDA.ipynb*.

## Results

As we aim to explore the incremental impact of network features, only basic ML-model selection and tuning is done. The performance is then compared with and without network features.

### XGBoost Classification Performance Improves with Network Features

Network features decisively improve the prediction outcomes when used in combination with various non-network features. 

- <b>Without Network Features</b>: Precision of 62%, Recall of 59%, AUC of 0.67
- <b>With Network Features</b>: Precision of 73% (+11%), Recall of 83% (+24%), AUC of 0.89 (+0.22)

The resulting ROC-AUC performance difference is illustrated below: 

<img src="./images/roc_auc_comparison.png" alt="roc auc" width="400"/>

### Network Features Have High Importances

The top 15 most important features according to SHAP values are shown below. It can be seen that 6 network features (<b>clustering, density, largest_component_norm, largest_component, degree</b> and <b>n_edges</b>) emerge as being important.

Clustering is particularly helpful at a global level, where high values of clustering are associated with higher probability that the brand is engaging in fraud. 

<img src="./images/shap_explanation.png" alt="shap values" width="400"/>

See *2_Bad_Brand_Prediction*.

## Closing Thoughts

Overall, this analysis demonstrates that network metrics can be leveraged to better predict whether brands are engaging in review fraud or not, even as early as 2017 (almost 4 years in advance of when the brands were officially banned).


## Directory

- *1_Database_and_Network_Setup*: Files to clean up raw data, create tables and views in Postgres database and psycopg2 notebook to query db for the nodelist and edgelist for each brand.
- *2_Bad_Brand_Prediction*: Notebook to predict whether a brand is engaging in ratings fraud or not, as well as supporting precomputed network metrics by brand in csv form.
- *3_Network_Metrics_Computation_and_EDA.ipynb*: Notebook to compute network metrics for each brand and do preliminary exploratory data analysis on differences in networks of good and bad brands.

Source and intermediate csv files are quite large and not enclosed in this repository. Please refer to each respective folder for step-by-step instructions to generate data.