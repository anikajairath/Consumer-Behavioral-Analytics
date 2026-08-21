nudge_findings = [

    {
        "nudge": "Scarcity Message",
        "exposed_buyer_rate": 80.83,
        "non_exposed_buyer_rate": 59.47,
        "conversion_lift": 21.36,
        "performance_rank": 1
    },

    {
        "nudge": "Trending Badge",
        "exposed_buyer_rate": 79.05,
        "non_exposed_buyer_rate": 62.35,
        "conversion_lift": 16.70,
        "performance_rank": 2
    },

    {
        "nudge": "Free Shipping",
        "exposed_buyer_rate": 76.86,
        "non_exposed_buyer_rate": 61.16,
        "conversion_lift": 15.70,
        "performance_rank": 3
    },

    {
        "nudge": "Countdown Timer",
        "exposed_buyer_rate": 76.92,
        "non_exposed_buyer_rate": 63.80,
        "conversion_lift": 13.12,
        "performance_rank": 4
    },

    {
        "nudge": "Recommended Label",
        "exposed_buyer_rate": 74.66,
        "non_exposed_buyer_rate": 63.35,
        "conversion_lift": 11.31,
        "performance_rank": 5
    },

    {
        "nudge": "Influencer Campaign",
        "exposed_buyer_rate": 74.81,
        "non_exposed_buyer_rate": 65.90,
        "conversion_lift": 8.91,
        "performance_rank": 6
    }
]


knowledge_chunks = []

for finding in nudge_findings:

    text = (
        f"{finding['nudge']} had an exposed buyer rate of "
        f"{finding['exposed_buyer_rate']}%, a non-exposed buyer rate of "
        f"{finding['non_exposed_buyer_rate']}%, and an observed "
        f"conversion lift of {finding['conversion_lift']} percentage points. "
        f"Its performance rank was {finding['performance_rank']}."
    )

    knowledge_chunks.append(text)

other_findings = [
	"Among the six psychological marketing nudges analyzed in the Behavioral Analytics project, Scarcity Message produced the strongest observed conversion lift. Scarcity Message ranked first with a 21.36 percentage-point conversion lift, compared with 16.70 for Trending Badge, 15.70 for Free Shipping, 13.12 for Countdown Timer, 11.31 for Recommended Label, and 8.91 for Influencer Campaign.",

    "Scarcity Message was associated with the fastest purchase decisions among the six nudges. Purchasers exposed to Scarcity Message had an average decision time of approximately 8.14 minutes compared with 14.49 minutes for non-exposed purchasers, an observed reduction of 43.83%.",

    "Among discount levels, High Discount had the highest purchase rate at 72.45%. Moderate Discount had a purchase rate of 65.85%, while Low Discount had a purchase rate of 64.60%.",

    "Among buyer segments created using NTILE(3) on purchase value, Budget Buyers, Value Buyers, and Premium Buyers were compared on average purchase value, decision time, and discount percentage.",

    "The analysis examined psychological nudge performance across Years as Customer ranges to identify whether newer and longer-term customers responded differently to different nudges.",

    "The analysis compared customer responses to psychological nudges across demographic and behavioral segments, including age groups, loyalty status, income levels, and decision-making speed.",

    "The project uses conversion lift to compare the purchase rate among customers exposed to a behavioral nudge with the purchase rate among customers who were not exposed to that nudge.",

    "The behavioral analytics project is based on a synthetically generated dataset. Observed relationships between nudges and purchasing behavior should therefore not be interpreted as definitive causal effects."
]

knowledge_chunks.extend(other_findings)


print("TOTAL CHUNKS:", len(knowledge_chunks))
print("TYPE OF CHUNK 6:", type(knowledge_chunks[6]))
print("CHUNK 6:")
print(knowledge_chunks[6])