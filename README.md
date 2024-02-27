This is a project that analyzes customer segmentation by RFM metrics and gives recommendations for each group of customer segmentation.
**1. RFM metrics:**
- Recency: The freshness of the customer activity, be it purchases or visits.
E.g. Time since the last order or last engagement with the product.
- Frequency: The frequency of customer transactions or visits.
Eg. The total number of transactions or average time between transactions engaged visits.
- Monetary: The intention of customers to spend or purchasing power of customers.
E.g. Total or average transaction value.
**2. Code:**
-- -- -- -- -- -- -- RFM Calculate -- -- -- -- -- -- -- 
WITH RFM_Base AS
(
SELECT b.Customer_Name,
    DATEDIFF(DAY, MAX(a.Order_Date), CONVERT(DATE, GETDATE())) AS Recency_Value,
    COUNT(DISTINCT a.Order_Date) AS Frequency_Value,
    ROUND(SUM(a.Sales), 2) AS Monetary_Value
FROM sales AS a
INNER JOIN customers AS b ON a.Customer_ID = b.Customer_ID
GROUP BY b.Customer_Name
)
-- SELECT * FROM RFM_Base
, RFM_Score 
AS
(
  SELECT *,
    NTILE(5) OVER (ORDER BY Recency_Value DESC) as R_Score,
    NTILE(5) OVER (ORDER BY Frequency_Value ASC) as F_Score,
    NTILE(5) OVER (ORDER BY Monetary_Value ASC) as M_Score
  FROM RFM_Base
)
-- SELECT * FROM RFM_Score
, RFM_Final
AS
(
SELECT *,
  CONCAT(R_Score, F_Score, M_Score) as RFM_Overall
FROM RFM_Score
)
-- SELECT * FROM RFM_Final
SELECT f.*, s.Segment
FROM RFM_Final f
JOIN segment_scores s ON f.RFM_Overall = s.Scores
ORDER BY Recency_Value
; 
-- -- -- -- -- -- -- Done -- -- -- -- -- -- --
**3. Results:**
As a result, we have 11 segmentations as below:
- Champions: people who bought recently, bought often, and spent the most - **10.20% of the total**
- Loyal Customers: people who spend good money with us often. Responsive to promotions - **9.83% of the total**
- Potential Loyalists: people who are recent customers, but spent a good amount and bought more than once - **14.18% of the total**
- New Customers: people who bought most recently, but not often - **6.09% of the total**
- Promising: people who are recent shoppers, but haven't spent much - **7.59% of the total**
- Customers Needing Attention: people who have above-average recency, frequency, and monetary values. May not have bought it very recently though - **7.84% of the total**
- About To Sleep: people who have below-average recency, frequency, and monetary values. Will lose them if not reactivated - **4.73% of the total**
- At Risk: people who spend big money and purchase often. But a long time ago. Need to bring them back - **14.55% of the total**
- Can't Lose Them: people who made the biggest purchases, and often. But haven't returned for a long time - **2.49% of the total**
- Hibernating: The last purchase was long back, with low spenders and a low number of orders - **13.56% of the total**
- Lost: people who have the lowest recency, frequency, and monetary scores - **8.96% of the total**
  **4. Recommendations for each group of customer segmentation:**
- Champions: Reward them. Can be early adopters of new products. Will promote your brand.
- Loyal Customers: Upsell higher-value products. Ask for reviews. Engage them.
- Potential Loyalist: Offer membership/ loyalty program, recommend other products
- Recent Customers: Provide onboarding support, give them early success, and start building a relationship
- Promising: Create brand awareness, and offer free trials.
- Customers Needing Attention: Make limited-time offers and recommendations based on past purchases. Reactivate them.
- About To Sleep: Share valuable resources, recommend popular product renewals at a discount, and reconnect with them.
- At Risk: Send personalized emails to reconnect, offer renewals provide helpful resources.
- Can't Lose Them: Win them back Via renewals or newer products, don't lose them to Competition, talk to them.
- Hibernating: Offer other relevant products and special discounts. Recreate brand value.
- Lost: Revive interest by reaching out to the campaign, ignore otherwise.


