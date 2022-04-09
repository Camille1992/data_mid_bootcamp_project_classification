README - BANKING SECTOR - CREDIT CARD OFFER - CLASSIFICATION

1. State the question and determine required data
We want to understand our customers better and explore the demographic characteristics that would impact their decision to accept or not a credit card offer.
To proceed with this study, we need the financial and demographic data of the customers who accepted and the customers who refused the credit card offer.



2. Acquire the data in an accessible format
The data was already provided to us in csv and excel formats.



3. Identify and correct missing data points/anomalies as required

a. Exploring the data
    i. Column names - We rename the column names to improve readability and set the Customer Number as the index.
    ii. Exploring the data - generating the data shape, info, and statistical information to have en overview of our data.
    iii. NaN - We check for NaN values as an large number of those would mean spending more time and focus finding the best way to offset the large presence of NaNs by replacing them in the way that helps our modeling purposes the most. In our case, the NaN values represent very little percentage of data (less than 0.15% or 24 rows out of 18 000)
    iv. Reviewing the value count - this gives an idea of which features we would class as continuous numerical data and discrete numerical data. In our dataset, only the balance features are continuous. We know already that we will have to deal with data imbalance.
    v. Checking the unique value - it could be worth changing a value with only a few or one count into the nearest value as to reduice the noise and not have too many distinct values in our discrete numerical data.

b. Data cleaning
    i. Droping the NaN values
    ii. Cleaning household_size - 8 and 9 values had only 1 count each so we labeled them as the nearest value - 6.

c. Exploratory Data Analysis (EDA)
    i. Separating the discrete and continuous numerical, and the categorical data as they we won't be using the same plots for them.
    ii. Plotting continuous numerical data with density plots, scatterplots, boxen plots and creating a correlation matrix with the target included. Redacting observations.
    iii. Plotting discrete numerical data with count plots, crosstabs and creating a correlation matrix with the target included. Redacting observations.
    iv. Plotting categorical data with count plots, violin plots, boxen plots and redacting observations.




4. Prepare the data for the machine learning model

a. Preparing the continuous numerical data
    i. Improving the distribution with the Box-Cox transformation. It will make the distrubution of our countinuous numerical data more normal and already take care of some of the outliers. Comparing this improvement with the ones using the log and sqrt functions.
    ii. Removing the outliers and checking the percentage of outliers removed for each of our three transformed continuous numerical dataframes (already transformed with Box-Cox or Log or Sqrt).
    iii. Plotting the density plots and boxen plots again to see the change in distribution for the three mofified dataframes. We will proceed with the continuous numerical dataframe transformed by the Box-Cox.
    iv. Scaling the continuous numerical data using StandardScaler. It was chosen over MinMaxScaler because it performs better.

b. Preparing the categorical data
~We drop the target from the categorical dataframe.
    i. Encoding the nominal categorical data using OneHotEncoder and renaming the column names.
    ii. Encoding the ordinal categorical data - we want to keep the order (Low, Medium, High - 1, 2, 3) for income_level and credit_rating.

c. Re-assembling the dataframes into one final_data dataframe before we start with the modeling part of our study.



5. Establish baseline models - we will want to exceed their first performance
~We define all the functions most commonly used at the beginning of our modeling work: Train-Test split, modeling function, model accuracy function and graph functions.

a. Logistic Regression - 0.5 AUC ROC and 0 sensitivity
b. KNN Classifier - 0.51 AUC ROC and 0.02 sensitivity
c. Random Forest Classifier (RFC) - 0.76 AUC ROC; 1.0 test_score and 0.8852 train_score.



6. Train the model on the training data - we already see that we have to improve the models to deal with the data imbalance. Plotting the ROC curves.



7. Make predictions on the test data - all three models fail to predict the `Yes` label as it is underrepresented in our dataset.

a. Logistic Regression
    - We improve the model by oversampling the underrepresented data with the SMOTE method.
    - It greatly improve the result - 0.71 AUC ROC and 0.70 sensitivity
b. KNN Classifier
    - We improve the model by oversampling the underrepresented data with the SMOTE method.
    - We plot the error rate, accuracy rate and false negative rate to determine the best k-value for our model (k=24)
    - We run the model again and it yields better results - - 0.65 AUC ROC and 0.60 sensitivity
c. Random Forest Classifier (RFC)
    - We improve the model by reducing the overfitting by finding the best hyper parameters with RandomizedSearchCV.
    - The best hyper parameters yields 0.7759 test_score and 0.7539 train_score. Sensitivity (ability to predict the `Yes`, which is the challenge with our dataset) is of 0.6. Its 
    - We extract the best features according to our model.
    - We run the RFC again with the best features - it improves the sensitivity for the `1` from 0.6 to 0.68. Its AUC ROC remains at 0.76.
    
    
    
8. Conclusion 
The RFC performs best overall. We know which features the models are most sensitive too and which we could focus on when trying to target customers who are more likely to accept the credit card offer.

