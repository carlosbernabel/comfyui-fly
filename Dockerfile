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

WORKDIR /opt/comfyui

RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git


RUN pip install \
    torch \
    torchvision \
    torchaudio \
    --index-url https://download.pytorch.org/whl/cu128

RUN pip install -r requirements.txt

# ---- ComfyUI-Manager ----
RUN git clone --depth 1 https://github.com/Comfy-Org/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager \
    && pip3 install --no-cache-dir -r custom_nodes/ComfyUI-Manager/requirements.txt
 
# ---- ComfyUI-ReActor ----
RUN git clone --depth 1 https://github.com/Gourieff/comfyui-reactor-node.git custom_nodes/comfyui-reactor-node \
    && pip3 install --no-cache-dir -r custom_nodes/comfyui-reactor-node/requirements.txt

EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--enable-manager"]
