# RAG Source Attribution: Attribution-Aware Reranking (AAR)

This repository focuses on improving the reliability and factual grounding of Retrieval-Augmented Generation (RAG) systems. The core innovation is an **Attribution-Aware Reranker (AAR)** trained to prioritize retrieved passages that provide strong, direct factual support for generated answers, thereby reducing hallucinations.

## Project Overview

Standard RAG pipelines often suffer from "retrieval brittleness," where relevant documents are retrieved but the model fails to attribute information correctly or hallucinates based on loosely related text. This project explores a multi-stage pipeline:

1.  **Stage 1 Retrieval:** BM25 lexical search using Pyserini/Lucene.
2.  **Stage 2 Reranking (Baseline):** Standard Cross-Encoder (e.g., MS-MARCO MiniLM) for semantic relevance.
3.  **Stage 2 Reranking (AAR):** A custom-trained reranker focused on *attribution* rather than just *relevance*.
4.  **Stage 3 Generation:** Answer generation using **Gemini 2.5 Flash** via Vertex AI.

## Technical Stack

- **Data:** ArXiv Metadata Snapshot (Kaggle).
- **Search Engine:** Pyserini / Lucene (BM25).
- **LLM:** Google Gemini 2.5 Flash (Vertex AI SDK).
- **Reranker Framework:** Sentence-Transformers / Cross-Encoders.
- **Environment:** Python 3.10+, Java 21 (for Pyserini).

## Repository Structure

- `notebooks/main.ipynb`: The primary pipeline covering data preparation, indexing, baseline evaluation, and AAR training.
- `data/`: Raw ArXiv data, processed chunks (Parquet), and search indexes.
- `models/`: Trained AAR model weights.
- `results/`: Performance plots and evaluation reports.

## Setup & Execution

### 1. Environment Configuration
Create a `.env` file with your credentials:
```env
KAGGLE_USERNAME=your_username
KAGGLE_KEY=your_key
```

### 2. Dependencies
Install required packages as listed in the notebook:
```bash
pip install kaggle google-generativeai nmslib faiss-cpu sentence-transformers datasets pyserini python-dotenv matplotlib seaborn
```

### 3. ArXiv Data Acquisition
Data is automatically downloaded and chunked within `main.ipynb` using the Kaggle API.

### 4. Running the Pipeline
Open `notebooks/main.ipynb` and execute the cells sequentially through the phases:
- **Phase 1:** Data Preparation & Indexing.
- **Phase 2:** Baseline RAG Pipeline & Evaluation.
- **Phase 3:** AAR Synthetic Data Generation & Training.
- **Phase 4:** Comparative Performance Analysis.

## Evaluation
The system is evaluated against a set of 50+ specialized queries (physics, mathematics, computer science) to measure precision and attribution accuracy. Results and comparison plots are stored in the `/results` directory.
