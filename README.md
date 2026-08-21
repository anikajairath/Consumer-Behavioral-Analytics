# ⭐ Key Project for Data Analyst Portfolio
----------------------------------------------------------------------------------------------------------------

# Consumer Behavioral Analytics – Evaluating Psychological Nudges in E-Commerce

⭐ **Featured Data Analytics Project** | Python • MySQL • Power BI • Behavioral Psychology • Generative AI

---

# Overview

This project investigates how behavioral psychology influences consumer purchasing decisions in an e-commerce environment. Rather than performing traditional sales analysis, the study evaluates the effectiveness of psychological marketing interventions—including Scarcity Messaging, Countdown Timers, Free Shipping, Trending Badges, Recommendation Labels, and Influencer Campaigns—by measuring their impact on purchase conversion and decision-making speed.

The project combines **Python for data preparation**, **SQL for advanced behavioral analysis**, and **Power BI for interactive visualization** to uncover actionable insights that can support evidence-based marketing strategies.

The project was further extended with an **AI-powered Retrieval-Augmented Generation (RAG) assistant**, allowing users to ask natural-language questions about the project's analytical findings and receive answers grounded in the project's evidence.

---

# Business Question

How do psychological marketing nudges influence consumer purchasing behavior, conversion rates, and decision-making speed in an e-commerce environment?

The study investigates whether interventions such as Scarcity Messaging, Countdown Timers, Free Shipping, Trending Badges, Recommendation Labels, and Influencer Campaigns significantly impact customer purchase decisions and which strategies generate the highest behavioral response.

---

# Objective

To analyze consumer purchasing behavior and determine how different psychological marketing nudges influence conversion rates, customer decision-making, and purchasing patterns across various customer segments using a data-driven behavioral analytics approach.

---

# Tools & Technologies

### Data Analytics

- Python (Pandas, NumPy, Matplotlib, Seaborn)
- SQL (MySQL)
- Power BI
- Jupyter Notebook

### Generative AI Extension

- Python
- Sentence Transformers
- `all-MiniLM-L6-v2`
- Cosine Similarity
- Gemini API
- Streamlit
- Retrieval-Augmented Generation (RAG)

---

# Dataset

The analysis is based on a **synthetic e-commerce dataset containing 10,000 consumer transactions**.

The dataset includes:

- Customer demographics
- Product information
- Original and discounted prices
- Purchase decisions
- Decision time
- Loyalty membership
- Brand familiarity
- Customer tenure
- Multiple behavioral marketing interventions (psychological nudges)

---

# Project Workflow

- Cleaned and preprocessed raw transactional data using Python
- Performed exploratory data analysis (EDA) to identify consumer behavior trends
- Engineered analytical features including:
  - Age Groups
  - Customer Tenure Categories
  - Decision Speed Groups
  - Discount Percentage
- Imported the prepared dataset into MySQL
- Designed advanced SQL analyses using:
  - Common Table Expressions (CTEs)
  - Window Functions (LAG, NTILE, RANK)
  - Views
  - Stored Procedures
  - User Defined Functions
  - Indexes
- Compared **Experimental (Exposed)** and **Control (Non-Exposed)** customer groups to measure the effectiveness of behavioral interventions
- Built interactive Power BI dashboards to communicate key business insights
- Developed a RAG-based AI assistant to allow natural-language exploration of project findings
- Built a Streamlit interface for interacting with the AI assistant

---

# Behavioral Psychology Concepts Explored

- Fear of Missing Out (FOMO)
- Scarcity Effect
- Social Proof
- Bandwagon Effect
- Loss Aversion
- Authority Bias
- Consumer Segmentation
- Behavioral Marketing

---

# Executive Findings

✅ **Overall Conversion Rate:** 68.98%

✅ **Most Effective Behavioral Nudge:** Scarcity Messaging (+21.36 percentage point conversion lift)

✅ **Strongest Social Proof Strategy:** Trending Badge outperformed Influencer Campaigns

✅ **Best Customer Acquisition Strategy:** Free Shipping showed the greatest impact on non-loyal customers

✅ **Decision Speed Matters:** Purchasers made decisions significantly faster than non-purchasers

✅ **Best Discount Range:** Discounts above 20% generated the strongest improvement in purchase likelihood

---

# Business Impact

This project demonstrates how organizations can combine behavioral psychology with data analytics to move beyond descriptive reporting and make evidence-based marketing decisions.

The findings can help businesses:

- Optimize promotional strategies
- Personalize customer experiences
- Improve conversion rates
- Understand customer decision-making behavior
- Allocate marketing resources more effectively

---

# Recommendations

- Prioritize scarcity-based campaigns during promotional events
- Leverage Trending Badges to strengthen social proof
- Offer Free Shipping strategically for customer acquisition campaigns
- Personalize marketing based on customer tenure and loyalty
- Optimize discount strategies using customer behavioral insights
- Continuously evaluate marketing interventions through data-driven experimentation and A/B testing

---

# Interactive Dashboard

The Power BI dashboard is organized into three analytical sections.

### Consumer Behavior Overview

- Overall Conversion Rate
- Purchase Value
- Decision Time Analysis
- Demographic Trends

### Psychological Nudge Performance

- Conversion Lift Comparison
- Decision Time Reduction
- Nudge Performance Ranking
- Customer Tenure Analysis

### Customer Purchase Behavior

- Free Shipping vs Loyalty Analysis
- Discount Responsiveness
- Behavioral Purchase Trends

---

# 🤖 AI-Powered RAG Assistant

The project was extended with a **Retrieval-Augmented Generation (RAG) AI assistant** that allows users to interact with the project's analytical findings using natural-language questions.

Instead of functioning as a general-purpose chatbot, the assistant retrieves relevant information from a curated knowledge base containing findings from the Behavioral Analytics project and provides that information to Gemini as context for generating the response.

## How It Works

```text
User Question
      ↓
Question Embedding
      ↓
Semantic Similarity Search
      ↓
Top Relevant Project Evidence
      ↓
Gemini
      ↓
Grounded AI Answer
      ↓
Streamlit Interface
