# RAG Source Attribution: Attribution-Aware Reranking (AAR)

This repository presents a **Retrieval-Augmented Generation (RAG)**
system designed to improve **factual grounding and citation
reliability** in Large Language Models (LLMs). The core contribution is
an **Attribution-Aware Reranker (AAR)**, which prioritizes passages that
*truly support claims*, reducing hallucinations and misleading
citations.

------------------------------------------------------------------------

## Project Overview

Standard RAG pipelines suffer from **retrieval brittleness**, where
retrieved documents are relevant but fail to properly support generated
claims. This leads to hallucinations or weak attribution.

This project introduces a **multi-stage, attribution-focused RAG
pipeline**:

1.  **Stage 1 -- Retrieval**\
    BM25 lexical search using Pyserini/Lucene.

2.  **Stage 2 -- Reranking**

    -   **Baseline:** Cross-Encoder (MS MARCO MiniLM)
    -   **Proposed:** Attribution-Aware Reranker (AAR)

3.  **Stage 3 -- Generation**\
    Answer generation using **Gemini 2.5 Flash (Vertex AI)**

4.  **(Optional Extension) Verification Layer**\
    Designed to validate claim--citation alignment for improved
    reliability.

------------------------------------------------------------------------

## Key Innovation: Attribution-Aware Reranker (AAR)

Unlike traditional rerankers that optimize for *semantic relevance*, AAR
is trained to evaluate:

- **Attributable** -- Passage directly supports the claim\
-️ **Extrapolatory** -- Related but insufficient support\
- **Contradictory** -- Conflicts with the claim

------------------------------------------------------------------------

## Technical Stack

- **Data:** ArXiv Metadata (Kaggle)
- **Search Engine:** Pyserini / Lucene (BM25)
- **LLM:** Google Gemini 2.5 Flash (Vertex AI)
- **Reranker:** Sentence-Transformers (Cross-Encoders)
- **Environment:** Python 3.10+, Java 21

------------------------------------------------------------------------

## Repository Structure

project-root/ 
notebooks/ main.ipynb 
data/ arxiv/ processed/ 
models/ aar_trained_model/ 
results/ evaluation_queries.json
final_evaluation_report.csv 
scripts/ Dockerfile requirements-repro.txt
.env.example run_in_docker.sh run_reproducibility.ps1

------------------------------------------------------------------------

## Setup & Execution

### 1. Environment Configuration

Create a `.env` file:

KAGGLE_USERNAME=your_username\
KAGGLE_KEY=your_key\
JAVA_HOME="C:\Program Files\Eclipse Adoptium\jdk-21.0.2.10-hotspot"\
BASE_DIR="/workspace"\
VERTEX_PROJECT_ID=your-gcp-project-id\
VERTEX_LOCATION="global"

------------------------------------------------------------------------

### 2. Install Dependencies

pip install kaggle google-generativeai nmslib faiss-cpu
sentence-transformers datasets pyserini python-dotenv matplotlib seaborn

------------------------------------------------------------------------

### 3. Data Acquisition

-   Dataset is automatically downloaded via Kaggle API
-   Preprocessing handled in `main.ipynb`

------------------------------------------------------------------------

### 4. Run the Pipeline

Execute `notebooks/main.ipynb`:

-   Phase 1: Data Preparation & Indexing\
-   Phase 2: Baseline RAG\
-   Phase 3: AAR Training\
-   Phase 4: Evaluation

------------------------------------------------------------------------

## Reproducibility Guide

### Option A --- Docker

docker build -f scripts/Dockerfile -t thesis-rag-repro .

docker run --rm -it -p 8888:8888 --env-file .env -v "\${PWD}:/workspace"
source-attribution-rag-repro

Open: http://localhost:8888/lab

------------------------------------------------------------------------

### Option B --- PowerShell

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

.`\scripts`{=tex}`\run`{=tex}\_reproducibility.ps1 -LaunchJupyter

------------------------------------------------------------------------

## Evaluation

-   50+ domain-specific queries (ArXiv)
-   Metrics:
    -   Citation Precision
    -   Citation Recall
    -   F1 Score

Results stored in `/results`.
