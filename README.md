# MCM 2020 - AmazonReviews_Analysis

I cleaned the 3 data files (microwave.tsv, hair_dryer.tsv, pacifier.tsv) using Python to export the cleaned files (cleaned_microwave.tsv, hair_dryer.tsv, pacifier.tsv):
- change all "Y", "N" in verified_purchase columns into 1 and 0
- change all product_id into uppercase characters
- extract time by year, adding another column "year" into the dataframe
- others, depending on our goals

Open the model.R file to run the logistic model for the cleaned data
- Install any packages as needed
- refined_pacifier, refined_microwave are dataframe filtered from the cleaned data as follows: review_body with more than 100 characters, helpful/total votes >= 0.98, helpful_votes > 1. You can change these constraints to test the model.

