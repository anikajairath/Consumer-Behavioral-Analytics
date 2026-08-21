import streamlit as st

from rag_assistant import ask_project


# --------------------------------------------------
# Page configuration
# --------------------------------------------------
st.set_page_config(
    page_title="Behavioral Analytics Assistant",
    page_icon="🧠",
    layout="wide",
)


# --------------------------------------------------
# Custom styling
# --------------------------------------------------
st.markdown(
    """
    <style>

    /* ==============================
       Global
       ============================== */

    .stApp {
        background: #F6F5FC;
        color: #25233A;
    }

    .main {
        background: #F6F5FC;
    }

    .block-container {
        max-width: 900px;
        padding-top: 3rem;
        padding-bottom: 4rem;
    }


    /* ==============================
       Typography
       ============================== */

    h1 {
        color: #25233A !important;
        font-weight: 700 !important;
        letter-spacing: -0.5px;
    }

    h2 {
        color: #3D3A5C !important;
        font-weight: 650 !important;
    }

    h3 {
        color: #3D3A5C !important;
        font-weight: 600 !important;
    }

    p,
    label,
    .stMarkdown {
        color: #25233A;
    }


    /* ==============================
       Text input
       ============================== */

    div[data-testid="stTextInput"] input {
        background-color: #FFFFFF !important;
        color: #25233A !important;

        border: 1px solid #D8D5EA !important;
        border-radius: 10px !important;

        padding: 0.75rem 1rem !important;

        box-shadow: none !important;
    }

    div[data-testid="stTextInput"] input:focus {
        border-color: #6C63A8 !important;
        box-shadow: 0 0 0 1px #6C63A8 !important;
    }

    div[data-testid="stTextInput"] input::placeholder {
        color: #8A879F !important;
        opacity: 1 !important;
        font-style: italic !important;
    }


    /* ==============================
       Ask button
       ============================== */

    div[data-testid="stButton"] > button {
        background-color: #6C63A8 !important;
        color: #FFFFFF !important;

        border: none !important;
        border-radius: 10px !important;

        padding: 0.55rem 1.6rem !important;

        font-weight: 600 !important;
        font-size: 0.95rem !important;

        transition: all 0.2s ease;
    }

    div[data-testid="stButton"] > button:hover {
        background-color: #5B5394 !important;
        color: #FFFFFF !important;
        border: none !important;
    }

    div[data-testid="stButton"] > button:focus {
        color: #FFFFFF !important;
        border: none !important;
        box-shadow: 0 0 0 2px rgba(108, 99, 168, 0.25) !important;
    }


    /* ==============================
       Info / warning messages
       ============================== */

    div[data-testid="stAlert"] {
        border-radius: 10px !important;
        border: 1px solid #D8D5EA !important;
    }


    /* ==============================
       Expanders
       ============================== */

    div[data-testid="stExpander"] {
        background-color: #FFFFFF !important;
        border: 1px solid #D8D5EA !important;
        border-radius: 10px !important;
        overflow: hidden;
    }

    div[data-testid="stExpander"] summary {
        color: #3D3A5C !important;
        font-weight: 600 !important;
    }


    /* ==============================
       Spinner
       ============================== */

    div[data-testid="stSpinner"] {
        color: #6C63A8 !important;
    }


    /* ==============================
       Caption
       ============================== */

    div[data-testid="stCaptionContainer"] {
        color: #6F6B83 !important;
    }

    </style>
    """,
    unsafe_allow_html=True,
)


# --------------------------------------------------
# Session state
# --------------------------------------------------

if "chat_history" not in st.session_state:
    st.session_state.chat_history = []


# --------------------------------------------------
# Header
# --------------------------------------------------

st.title("🧠 Behavioral Analytics AI Assistant")

st.caption(
    "A retrieval-augmented AI assistant for exploring findings "
    "from the Behavioral Analytics project."
)

st.info(
    "Ask a question about the project. "
    "The assistant uses retrieved project evidence to generate its answer."
)


# --------------------------------------------------
# Previous conversation
# --------------------------------------------------

if st.session_state.chat_history:

    st.subheader("💬 Conversation")

    for item in st.session_state.chat_history:

        # User question
        st.markdown("**You**")

        st.write(item["question"])


        # AI answer
        st.markdown("**🤖 AI Assistant**")

        st.write(item["answer"])


        # Evidence
        with st.expander("📚 Project Evidence Used"):

            for i, chunk in enumerate(item["evidence"], start=1):

                st.markdown(f"**Evidence {i}**")

                st.write(chunk)

                if i < len(item["evidence"]):
                    st.divider()


        st.divider()


# --------------------------------------------------
# User question
# --------------------------------------------------

question = st.text_input(
    "Ask a question about the project:",
    placeholder="e.g. Which psychological nudge performed best?",
    key="question_input",
)


# --------------------------------------------------
# Ask button
# --------------------------------------------------

if st.button("Ask"):

    if not question.strip():

        st.warning("Please enter a question.")

    else:

        with st.spinner("Analyzing project evidence..."):

            answer, evidence = ask_project(question)

        # Save conversation
        st.session_state.chat_history.append(
            {
                "question": question,
                "answer": answer,
                "evidence": evidence,
            }
        )

        st.rerun()