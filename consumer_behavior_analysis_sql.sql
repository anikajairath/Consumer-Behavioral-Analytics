-- Overall Conversion Rate
SELECT
	COUNT(CASE WHEN Purchased = 1 THEN 1 END) AS Total_Purchase,
    COUNT(*) AS Total_Transactions,
    ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Conversion_Rate
FROM Consumer_behavior;

-- Average Decision Time Purchasers vs Non Purchasers
SELECT 
	CASE WHEN Purchased = 1 THEN 'Purchasers' ELSE 'Non Purchasers' END AS Purchaser_Category,
AVG(DecisionTimeMinutes) AS Avg_Decision_Time FROM consumer_behavior GROUP BY Purchased;

-- Purchase Rate by Category
SELECT Category, ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate 
FROM consumer_behavior 
GROUP BY Category
ORDER BY Purchase_Rate DESC;

-- Purchase Rate by City
SELECT City, ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate 
FROM consumer_behavior 
GROUP BY City
ORDER BY Purchase_Rate DESC;

-- Purchase Rate by Income Level
SELECT IncomeLevel, ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate 
FROM consumer_behavior 
GROUP BY IncomeLevel;

-- Conversion, Rating and Sales across different Brands
SELECT Brand, ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate,
AVG(Rating) AS Rating, SUM(FinalAmount) AS Sales
FROM consumer_behavior 
GROUP BY Brand
ORDER BY Purchase_Rate DESC, Rating DESC, Sales DESC;

-- Conversion Rate Across Decision Speed Groups
SELECT Decision_Speed, COUNT(*) AS Customers, 
SUM(Purchased) AS Purchases, ROUND(AVG(Purchased)*100, 2) AS Conversion_Rate 
FROM consumer_behavior 
GROUP BY Decision_Speed
ORDER BY Conversion_Rate DESC;

-- Conversion Rate by Brand Familiarity
SELECT BrandFamiliarity, ROUND(AVG(Purchased) * 100, 2) AS Conversion_Rate
FROM consumer_behavior 
GROUP BY BrandFamiliarity
ORDER BY Conversion_Rate DESC;

-- Consumer Loyalty Effecting Buying Behavior
SELECT LoyaltyMember, COUNT(*) AS Total_customers, SUM(Purchased) AS Total_Purchases, 
ROUND(AVG(Purchased) * 100, 2) AS Purchase_Rate,
ROUND(AVG(DecisionTimeMinutes), 2) AS Avg_Decision_Time
FROM consumer_behavior 
GROUP BY LoyaltyMember
ORDER BY Purchase_Rate DESC;

-- Conversion Rate Across Diff Age Groups
SELECT Age_Group, COUNT(*) AS Total_Customers, SUM(Purchased) AS Total_Purchases, ROUND(AVG(Purchased) * 100, 2) AS Conversion_Rate
FROM consumer_behavior 
GROUP BY Age_Group
ORDER BY Conversion_Rate DESC;

-- Decsion Making Speed Across Diff Age Groups
SELECT Age_Group, COUNT(*) AS Total_Customers, ROUND(AVG(DecisionTimeMinutes), 2) AS Avg_Decision_Time,
ROUND(AVG(Purchased)*100, 2) AS Purchase_Rate
FROM consumer_behavior 
GROUP BY Age_Group
ORDER BY Avg_Decision_Time DESC;

-- Psychological Nudge Presented Frequency
SELECT 
	ROUND(COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END)/COUNT(*) * 100, 2) AS Scarcity_Exposure,
    ROUND(COUNT(CASE WHEN CountdownTimer = 'True' THEN 1 END)/COUNT(*) * 100, 2) AS Countdown_Exposure,
    ROUND(COUNT(CASE WHEN RecommendedLabel = 'True' THEN 1 END)/COUNT(*) * 100, 2) AS Recommendation_Exposure,
    ROUND(COUNT(CASE WHEN InfluencerCampaign = 'True' THEN 1 END)/COUNT(*) * 100, 2) AS Influencer_Exposure,
    ROUND(COUNT(CASE WHEN FreeShipping = 'True' THEN 1 END)/COUNT(*) * 100, 2) AS FreeShipping_Exposure,
    ROUND(COUNT(CASE WHEN TrendingBadge = 'True' THEN 1 END)/COUNT(*) * 100, 2) AS Trending_Exposure
FROM consumer_behavior;

-- Scarcity Effect on Purchase Rate and Avg Decision Time
WITH ScarcityAnalysis AS(
SELECT ScarcityMessage, 
ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate, 
ROUND(AVG(DecisionTimeMinutes),2) AS Avg_decision_minutes 
FROM consumer_behavior 
GROUP BY ScarcityMessage)
SELECT *
FROM ScarcityAnalysis;

-- Countdown Effect on Purchase Rate and Avg Decision Time
WITH CountdownAnalysis AS(
SELECT CountdownTimer, 
ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate, 
ROUND(AVG(DecisionTimeMinutes),2) AS Avg_decision_minutes 
FROM consumer_behavior 
GROUP BY CountdownTimer)
SELECT *
FROM CountdownAnalysis;

-- Recommendation Effect on Purchase Rate and Avg Decision Time
WITH RecommendationAnalysis AS(
SELECT RecommendedLabel, 
ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate, 
ROUND(AVG(DecisionTimeMinutes), 2) AS Avg_decision_minutes 
FROM consumer_behavior 
GROUP BY RecommendedLabel)
SELECT *
FROM RecommendationAnalysis;

-- Free Shipping Effect on Purchase Rate and Avg Decision Time
WITH FreeShippingAnalysis AS(
SELECT FreeShipping, 
ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate, 
ROUND(AVG(DecisionTimeMinutes), 2) AS Avg_decision_minutes 
FROM consumer_behavior 
GROUP BY FreeShipping)
SELECT *
FROM FreeShippingAnalysis;

-- Social Influence: Trending vs Influencer
WITH SocialInfluenceAnalysis AS(
SELECT 'InfluencerCampaign' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate, 
AVG(DecisionTimeMinutes) AS Avg_decision_minutes 
FROM consumer_behavior 
WHERE InfluencerCampaign = 'True'

UNION ALL

SELECT 'TrendingBadge' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate, 
AVG(DecisionTimeMinutes) AS Avg_decision_minutes 
FROM consumer_behavior 
WHERE TrendingBadge = 'True'
)
SELECT *
FROM SocialInfluenceAnalysis;

-- Analyzing the effect of discount depth on purchase rates and incremental conversion gains
WITH PurchaseRatebyDisc AS 
(SELECT 
CASE 
	WHEN Discount_Percentage < 10 THEN '0-10%'
    WHEN Discount_Percentage < 20 THEN '10-20%'
    WHEN Discount_Percentage < 30 THEN '20-30%'
    ELSE '30%+'
END AS DiscountRange,

CASE 
	WHEN Discount_Percentage < 10 THEN 1
    WHEN Discount_Percentage < 20 THEN 2
    WHEN Discount_Percentage < 30 THEN 3
    ELSE 4
END AS RangeOrder,
ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate
FROM consumer_behavior
GROUP BY DiscountRange, RangeOrder
),
DiscountAnalysis AS
(SELECT DiscountRange, Purchase_Rate, RangeOrder, LAG(Purchase_Rate) OVER(ORDER BY RangeOrder) AS PreviousPurchaseRate 
FROM PurchaseRatebyDisc
)
SELECT DiscountRange, Purchase_Rate, ROUND(Purchase_Rate - PreviousPurchaseRate, 2) AS PercentageGain 
FROM DiscountAnalysis;
    
-- Performance and Conversion Rate by Nudge Exposures
WITH NudgePerformance AS(
SELECT 'ScarcityMessage' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL 

SELECT 'CountdownTimer' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN 1 END)/ 
COUNT(CASE WHEN CountdownTimer = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN 1 END)/
COUNT(CASE WHEN CountdownTimer = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'RecommendedLabel' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'True' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'False' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'InfluencerCampaign' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'True' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'False' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'TrendingBadge' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'True' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'False' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'FreeShipping' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
)
SELECT Nudge, ExposedBuyerRate, NonExposedBuyerRate, ExposedBuyerRate - NonExposedBuyerRate AS ConversionLift FROM NudgePerformance;

-- Influencer campaign Effect on Brand familiarity levels
WITH InfluencerEffect AS
(SELECT BrandFamiliarity,
ROUND(COUNT(CASE WHEN InfluencerCampaign = 'True' AND Purchased = 1 THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'True' THEN 1 END) * 100, 2) AS Influencer_Purchase_Rate,
ROUND(COUNT(CASE WHEN InfluencerCampaign = 'False' AND Purchased = 1 THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'False' THEN 1 END) * 100, 2) AS No_Influencer_Purchase_Rate
FROM consumer_behavior
GROUP BY BrandFamiliarity
)
SELECT BrandFamiliarity, Influencer_Purchase_Rate, No_Influencer_Purchase_Rate,
ROUND(Influencer_Purchase_Rate - No_Influencer_Purchase_Rate, 2) AS Influencer_Lift
FROM InfluencerEffect
ORDER BY Influencer_Lift DESC;

-- Age groups most susceptible to scarcity messaging
SELECT Age_group, 
COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END) AS Total_Exposed,
COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN 1 END) AS ExposedBuyers,
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END) * 100, 2) AS ExposedBuyersPurchaseRate,
COUNT(CASE WHEN ScarcityMessage = 'False' THEN 1 END) AS Total_NonExposed,
COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN 1 END) AS NonExposedBuyers,
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyersPurchaseRate,

ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END) * 100, 2) - ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'False' THEN 1 END) * 100, 2) AS ScarcityLift
FROM consumer_behavior 
GROUP BY Age_group
ORDER BY ScarcityLift DESC;

-- Loyal customers vs Non Loyal customers response to Free Shipping
SELECT LoyaltyMember, 
COUNT(CASE WHEN FreeShipping = 'True' THEN 1 END) AS Total_Exposed,
COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN 1 END) AS ExposedBuyers,
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'True' THEN 1 END) * 100, 2) AS FreeShippingPurchaseRate,
COUNT(CASE WHEN FreeShipping = 'False' THEN 1 END) AS Total_NonExposed,
COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN 1 END) AS NonExposedBuyers,
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'False' THEN 1 END) * 100, 2) AS NoFreeShippingPurchaseRate,

ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'True' THEN 1 END) * 100, 2) - ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'False' THEN 1 END) * 100, 2) AS FreeShippingLift
FROM consumer_behavior 
GROUP BY LoyaltyMember
ORDER BY FreeShippingLift DESC;

-- Income group with the highest Discount Lift
SELECT IncomeLevel,
ROUND(COUNT(CASE WHEN Purchased = 1 AND Discount_Percentage >= 20 THEN 1 END) * 100/
COUNT(CASE WHEN Discount_Percentage >= 20 THEN 1 END), 2) AS HighDiscountPurchaseRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND Discount_Percentage < 10 THEN 1 END) * 100/
COUNT(CASE WHEN Discount_Percentage < 10 THEN 1 END), 2) AS LowDiscountPurchaseRate,

ROUND((COUNT(CASE WHEN Purchased = 1 AND Discount_Percentage >= 20 THEN 1 END) * 100/
COUNT(CASE WHEN Discount_Percentage >= 20 THEN 1 END)) - (COUNT(CASE WHEN Purchased = 1 AND Discount_Percentage < 10 
THEN 1 END) * 100/ COUNT(CASE WHEN Discount_Percentage < 10 THEN 1 END)), 2) AS DiscountLift

FROM consumer_behavior
GROUP BY IncomeLevel
ORDER BY DiscountLift DESC
LIMIT 1;

-- Effect of CountDown Timer on Fast Decision Making Buyers
SELECT Decision_Speed,
COUNT(*) AS total_fast_buyers,
COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN 1 END) AS ExposedBuyers,
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN 1 END)/
COUNT(CASE WHEN CountdownTimer = 'True' THEN 1 END) * 100, 2) AS ExposedPurchaseRate,

COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN 1 END) AS NonExposedBuyers,
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN 1 END)/
COUNT(CASE WHEN CountdownTimer = 'False' THEN 1 END) * 100, 2)AS NonExposedPurchaseRate,

ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN 1 END)/
COUNT(CASE WHEN CountdownTimer = 'True' THEN 1 END) * 100, 2) - ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN 1 END)/
COUNT(CASE WHEN CountdownTimer = 'False' THEN 1 END) * 100, 2) AS CountDownTimerLift

FROM consumer_behavior 
WHERE Decision_Speed = 'Fast'
GROUP BY Decision_Speed;

-- Which psychological nudge produces the strongest overall conversion lift
WITH NudgePerformance AS(
SELECT 'ScarcityMessage' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL 

SELECT 'CountdownTimer' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN 1 END)/ 
COUNT(CASE WHEN CountdownTimer = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN 1 END)/
COUNT(CASE WHEN CountdownTimer = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'RecommendedLabel' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'True' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'False' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'InfluencerCampaign' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'True' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'False' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'TrendingBadge' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'True' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'False' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'FreeShipping' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
),

Ranked AS (SELECT Nudge, ExposedBuyerRate, NonExposedBuyerRate, 
ExposedBuyerRate - NonExposedBuyerRate AS ConversionLift, RANK() OVER(ORDER BY ExposedBuyerRate - NonExposedBuyerRate DESC) AS PerformanceRank
FROM NudgePerformance)

SELECT * FROM Ranked;

-- Which nudges are associated with the fastest purchase decisions
WITH NudgePerformance AS(
SELECT 'ScarcityMessage' AS Nudge, 
AVG(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN DecisionTimeMinutes END) AS ExposedAvgDecisionTime,
AVG(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN DecisionTimeMinutes END) AS NonExposedAvgDecisionTime,
ROUND((AVG(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN DecisionTimeMinutes END) - 
AVG(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN DecisionTimeMinutes END))/
AVG(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN DecisionTimeMinutes END) * 100, 2) AS PercentageChange
FROM consumer_behavior

UNION ALL

SELECT 'CountdownTimer' AS Nudge, 
AVG(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN DecisionTimeMinutes END) AS ExposedAvgDecisionTime,
AVG(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN DecisionTimeMinutes END) AS NonExposedAvgDecisionTime,
ROUND((AVG(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN DecisionTimeMinutes END) - 
AVG(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN DecisionTimeMinutes END))/
AVG(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN DecisionTimeMinutes END) * 100, 2) AS PercentageChange
FROM consumer_behavior

UNION ALL

SELECT 'RecommendedLabel' AS Nudge, 
AVG(CASE WHEN Purchased = 1 AND RecommendedLabel = 'True' THEN DecisionTimeMinutes END) AS ExposedAvgDecisionTime,
AVG(CASE WHEN Purchased = 1 AND RecommendedLabel = 'False' THEN DecisionTimeMinutes END) AS NonExposedAvgDecisionTime,
ROUND((AVG(CASE WHEN Purchased = 1 AND RecommendedLabel = 'False' THEN DecisionTimeMinutes END) - 
AVG(CASE WHEN Purchased = 1 AND RecommendedLabel = 'True' THEN DecisionTimeMinutes END))/
AVG(CASE WHEN Purchased = 1 AND RecommendedLabel = 'False' THEN DecisionTimeMinutes END) * 100, 2) AS PercentageChange
FROM consumer_behavior

UNION ALL

SELECT 'InfluencerCampaign' AS Nudge, 
AVG(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'True' THEN DecisionTimeMinutes END) AS ExposedAvgDecisionTime,
AVG(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'False' THEN DecisionTimeMinutes END) AS NonExposedAvgDecisionTime,
ROUND((AVG(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'False' THEN DecisionTimeMinutes END) - 
AVG(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'True' THEN DecisionTimeMinutes END))/
AVG(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'False' THEN DecisionTimeMinutes END) * 100, 2) AS PercentageChange
FROM consumer_behavior

UNION ALL

SELECT 'TrendingBadge' AS Nudge, 
AVG(CASE WHEN Purchased = 1 AND TrendingBadge = 'True' THEN DecisionTimeMinutes END) AS ExposedAvgDecisionTime,
AVG(CASE WHEN Purchased = 1 AND TrendingBadge= 'False' THEN DecisionTimeMinutes END) AS NonExposedAvgDecisionTime,
ROUND((AVG(CASE WHEN Purchased = 1 AND TrendingBadge = 'False' THEN DecisionTimeMinutes END) - 
AVG(CASE WHEN Purchased = 1 AND TrendingBadge = 'True' THEN DecisionTimeMinutes END))/
AVG(CASE WHEN Purchased = 1 AND TrendingBadge = 'False' THEN DecisionTimeMinutes END) * 100, 2) AS PercentageChange
FROM consumer_behavior

UNION ALL

SELECT 'FreeShipping' AS Nudge, 
AVG(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN DecisionTimeMinutes END) AS ExposedAvgDecisionTime,
AVG(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN DecisionTimeMinutes END) AS NonExposedAvgDecisionTime,
ROUND((AVG(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN DecisionTimeMinutes END) - 
AVG(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN DecisionTimeMinutes END))/
AVG(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN DecisionTimeMinutes END) * 100, 2) AS PercentageChange
FROM consumer_behavior),

Ranked AS(
SELECT Nudge, ExposedAvgDecisionTime, NonExposedAvgDecisionTime, PercentageChange, 
RANK() OVER(ORDER BY PercentageChange DESC) AS PerformanceRank FROM NudgePerformance)
SELECT * FROM Ranked;

-- Buyer Classification & Segment Analysis
WITH BuyerSegments AS (SELECT TransactionID, CustomerID, FinalAmount, DecisionTimeMinutes, Discount_Percentage,
NTILE(3) OVER(ORDER BY FinalAmount) AS BuyerTier FROM consumer_behavior WHERE Purchased = 1),

SegmentedBuyers AS (SELECT *, 
 CASE WHEN BuyerTier = 1 THEN 'Budget Buyers'
	WHEN BuyerTier = 2 THEN 'Value Buyers'
	WHEN BuyerTier = 3 THEN 'Premium Buyers'
 END AS BuyerSegment
FROM BuyerSegments)

SELECT BuyerSegment, COUNT(*) AS TotalBuyers, ROUND(AVG(FinalAmount), 2) AS AvgPurchaseValue,
ROUND(AVG(DecisionTimeMinutes), 2) AS AvgDecisionTime, ROUND(AVG(Discount_Percentage), 2) AS AvgDiscount
FROM SegmentedBuyers
GROUP BY BuyerSegment
ORDER BY AvgPurchaseValue;

-- Nudge Performance Analysis for Different Years as customer
WITH Years_As_Customer_RangeNudgePerformance AS(
SELECT Years_As_Customer_Range, 'ScarcityMessage' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Years_As_Customer_Range

UNION ALL 

SELECT Years_As_Customer_Range, 'CountdownTimer' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN 1 END)/ 
COUNT(CASE WHEN CountdownTimer = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN 1 END)/
COUNT(CASE WHEN CountdownTimer = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Years_As_Customer_Range

UNION ALL

SELECT Years_As_Customer_Range, 'RecommendedLabel' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'True' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'False' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Years_As_Customer_Range

UNION ALL

SELECT Years_As_Customer_Range, 'InfluencerCampaign' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'True' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'False' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Years_As_Customer_Range

UNION ALL

SELECT Years_As_Customer_Range, 'TrendingBadge' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'True' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'False' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Years_As_Customer_Range

UNION ALL

SELECT Years_As_Customer_Range, 'FreeShipping' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Years_As_Customer_Range)

SELECT Years_As_Customer_Range, Nudge, ExposedBuyerRate, NonExposedBuyerRate, 
ROUND(ExposedBuyerRate - NonExposedBuyerRate, 2) AS NudgeLift
FROM Years_As_Customer_RangeNudgePerformance
ORDER BY Nudge, Years_As_Customer_Range DESC;

-- Nudge Performance by Category
WITH CategoryNudgePerformance AS(
SELECT Category, 'ScarcityMessage' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Category

UNION ALL 

SELECT Category, 'CountdownTimer' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN 1 END)/ 
COUNT(CASE WHEN CountdownTimer = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN 1 END)/
COUNT(CASE WHEN CountdownTimer = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Category

UNION ALL

SELECT Category, 'RecommendedLabel' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'True' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'False' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Category

UNION ALL

SELECT Category, 'InfluencerCampaign' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'True' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'False' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Category

UNION ALL

SELECT Category, 'TrendingBadge' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'True' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'False' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Category

UNION ALL

SELECT Category, 'FreeShipping' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior
GROUP BY Category)

SELECT Category, Nudge, ExposedBuyerRate, NonExposedBuyerRate, 
ROUND(ExposedBuyerRate - NonExposedBuyerRate, 2) AS NudgeLift
FROM CategoryNudgePerformance
ORDER BY Category, NudgeLift DESC;

-- View for Nudge Performance
CREATE VIEW NudgeConversionPerformance AS

WITH NudgePerformance AS(
SELECT 'ScarcityMessage' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN 1 END)/
COUNT(CASE WHEN ScarcityMessage = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL 

SELECT 'CountdownTimer' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'True' THEN 1 END)/ 
COUNT(CASE WHEN CountdownTimer = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND CountdownTimer = 'False' THEN 1 END)/
COUNT(CASE WHEN CountdownTimer = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'RecommendedLabel' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'True' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND RecommendedLabel = 'False' THEN 1 END)/
COUNT(CASE WHEN RecommendedLabel = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'InfluencerCampaign' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'True' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND InfluencerCampaign = 'False' THEN 1 END)/
COUNT(CASE WHEN InfluencerCampaign = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'TrendingBadge' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'True' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND TrendingBadge = 'False' THEN 1 END)/
COUNT(CASE WHEN TrendingBadge = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior

UNION ALL

SELECT 'FreeShipping' AS Nudge, 
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'True' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'True' THEN 1 END) * 100, 2) AS ExposedBuyerRate,
ROUND(COUNT(CASE WHEN Purchased = 1 AND FreeShipping = 'False' THEN 1 END)/
COUNT(CASE WHEN FreeShipping = 'False' THEN 1 END) * 100, 2) AS NonExposedBuyerRate
from consumer_behavior),

Ranked AS (SELECT Nudge, ExposedBuyerRate, NonExposedBuyerRate, 
ExposedBuyerRate - NonExposedBuyerRate AS ConversionLift, 
RANK() OVER(ORDER BY ExposedBuyerRate - NonExposedBuyerRate DESC) AS PerformanceRank
FROM NudgePerformance)

SELECT * FROM Ranked;

-- Creating Discount category function
DELIMITER //

CREATE FUNCTION DiscountCategory(discount decimal(6,2))
RETURNS VARCHAR(20)
DETERMINISTIC

BEGIN
	DECLARE category VARCHAR(20);
    
    SET category = CASE
    WHEN discount < 10 THEN 'Low Discount'
    WHEN discount < 20 THEN 'Moderate Discount'
    ELSE 'High Discount'
    END;
RETURN category;
END//

DELIMITER ;

-- Stored Procedure for Analyzing scarcity by age groups
DELIMITER //
CREATE PROCEDURE AnalyzeScarcityByAge(
    IN selected_age_group VARCHAR(50))
BEGIN
	SELECT Age_Group, ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'True' THEN 1 END) * 100.0 /
	COUNT(CASE WHEN ScarcityMessage = 'True' THEN 1 END), 2) AS ScarcityPurchaseRate,
	ROUND(COUNT(CASE WHEN Purchased = 1 AND ScarcityMessage = 'False' THEN 1 END) * 100/
	COUNT(CASE WHEN ScarcityMessage = 'False' THEN 1 END), 2 ) AS NoScarcityPurchaseRate
    FROM consumer_behavior
    WHERE Age_Group = selected_age_group
    GROUP BY Age_Group;
END //
DELIMITER ;

-- Creating Index on Scarcity Message and Purchase
CREATE INDEX idx_scarcity_purchase
ON consumer_behavior(ScarcityMessage, Purchased);

-- Stored Procedure to Analyze Discount Response by Income Levels
DELIMITER //

CREATE PROCEDURE AnalyzeDiscountResponseByIncome (IN selected_income VARCHAR(20))
BEGIN
	SELECT IncomeLevel, DiscountCategory(Discount_Percentage) AS DiscountLevel, 
    COUNT(*) AS TotalTransactions, COUNT(CASE WHEN Purchased = 1 THEN 1 END) AS Buyers,
    ROUND(COUNT(CASE WHEN Purchased = 1 THEN 1 END)/COUNT(*) * 100, 2) AS Purchase_Rate
    FROM consumer_behavior
    WHERE IncomeLevel = selected_income
    GROUP BY IncomeLevel, DiscountLevel
    ORDER BY Purchase_Rate DESC;
END //
DELIMITER ;
