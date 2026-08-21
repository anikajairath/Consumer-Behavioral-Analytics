import os

from dotenv import load_dotenv
from google import genai
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

from project_knowledge import knowledge_chunks


# Load API key
load_dotenv()

client = genai.Client(
    api_key=os.getenv("GEMINI_API_KEY")
)


# Load embedding model
model = SentenceTransformer("all-MiniLM-L6-v2")


# Create embeddings for project knowledge
knowledge_embeddings = model.encode(knowledge_chunks)


def ask_project(question):
    """
    Takes a user's question and returns:
    1. AI answer
    2. Top 3 retrieved project knowledge chunks
    """

    # Convert the question into an embedding
    question_embedding = model.encode([question])


    # Compare question with all knowledge chunks
    similarities = cosine_similarity(
        question_embedding,
        knowledge_embeddings
    )[0]


    # Retrieve top 3 most relevant chunks
    top_indices = similarities.argsort()[::-1][:3]


    # Store the top chunks
    top_chunks = []

    for index in top_indices:
        top_chunks.append(knowledge_chunks[index])


    # Build retrieved context
    retrieved_context = ""

    for chunk in top_chunks:
        retrieved_context += "\n" + chunk


    # Create prompt for Gemini
    prompt = f"""
You are an AI assistant for a Behavioral Analytics project.

Answer the user's question using ONLY the project evidence provided below.

Do not invent facts.
Do not use outside knowledge.

If the evidence does not contain enough information to answer the question,
say that the project evidence does not provide enough information.

Remember that this project uses a synthetically generated dataset.
Observed relationships should not automatically be interpreted as definitive causal effects.

PROJECT EVIDENCE:
{retrieved_context}

USER QUESTION:
{question}
"""


    # Generate answer
    response = client.models.generate_content(
        model="gemini-3.5-flash",
        contents=prompt
    )


    # Return both answer and retrieved chunks
    return response.text, top_chunks