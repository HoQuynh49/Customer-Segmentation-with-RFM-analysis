SELECT * FROM sales;
SELECT * FROM customers;
SELECT * FROM segment_scores;

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