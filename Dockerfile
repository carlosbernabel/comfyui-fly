FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-venv \
    python3-pip \
    git \
    wget \
    curl \
    ca-certificates \
    build-essential \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip setuptools wheel

WORKDIR /opt

RUN git clone --depth 1 \
    https://github.com/comfyanonymous/ComfyUI.git

WORKDIR /opt/ComfyUI

RUN pip install \
    torch \
    torchvision \
    torchaudio \
    --index-url https://download.pytorch.org/whl/cu128

RUN pip install -r requirements.txt

RUN mkdir -p \
    /opt/ComfyUI/models \
    /opt/ComfyUI/input \
    /opt/ComfyUI/output \
    /opt/ComfyUI/user \
    /opt/ComfyUI/custom_nodes

EXPOSE 8188

CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
