FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jre-headless \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY scripts/requirements.txt /tmp/requirements.txt
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install -r /tmp/requirements.txt

COPY scripts/run_in_docker.sh /usr/local/bin/run_in_docker.sh
RUN chmod +x /usr/local/bin/run_in_docker.sh

EXPOSE 8888
CMD ["/usr/local/bin/run_in_docker.sh"]
