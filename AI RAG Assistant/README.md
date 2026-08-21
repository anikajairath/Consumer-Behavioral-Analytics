# 🤖 Behavioral Analytics AI Assistant

A Retrieval-Augmented Generation (RAG) assistant built as an AI extension of the Consumer Behavioral Analytics project.

The application allows users to ask natural-language questions about the project's analytical findings. It retrieves relevant project evidence using semantic similarity and uses Gemini to generate a grounded response.

## 🧠 How It Works

User Question
→ Sentence Transformer Embedding
→ Cosine Similarity Retrieval
→ Top Relevant Project Evidence
→ Gemini
→ Grounded AI Answer
→ Streamlit Interface

## 🛠️ Technologies

- Python
- Sentence Transformers
- scikit-learn
- Gemini API
- Streamlit
- python-dotenv

## 📁 Files

- `app.py` — Streamlit user interface
- `rag_assistant.py` — RAG retrieval and Gemini response pipeline
- `project_knowledge.py` — curated knowledge from the Behavioral Analytics project
- `requirements.txt` — Python dependencies
- `.gitignore` — prevents secrets and local files from being uploaded

## 🔐 Setup

Create a virtual environment and install the required packages:

```bash
pip install -r requirements.txt
```

Create a `.env` file in the project folder and add your own Gemini API key:

```text
GEMINI_API_KEY=your_api_key_here
```

Do not upload the `.env` file to GitHub.

Run the application with:

```bash
streamlit run app.py
```

## ⚠️ Project Limitation

The underlying Behavioral Analytics project uses a synthetically generated dataset. Therefore, observed relationships should not automatically be interpreted as definitive causal effects.

The AI assistant is also limited to the project evidence represented in its knowledge base.
