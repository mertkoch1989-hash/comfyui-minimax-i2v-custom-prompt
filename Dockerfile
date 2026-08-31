FROM runpod/worker-comfyui:5.8.4-base

ENV COMFYUI_PATH=/ComfyUI

WORKDIR /ComfyUI

# ============================================================
# MiniMax H3 - CUSTOM NODES
# ============================================================

RUN git clone --depth 1 \
    https://github.com/kijai/ComfyUI-KJNodes.git \
    /ComfyUI/custom_nodes/ComfyUI-KJNodes

RUN git clone --depth 1 \
    https://github.com/rgthree/rgthree-comfy.git \
    /ComfyUI/custom_nodes/rgthree-comfy

RUN git clone --depth 1 \
    https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git \
    /ComfyUI/custom_nodes/ComfyUI-VideoHelperSuite

RUN git clone --depth 1 \
    https://github.com/xmarre/ComfyUI-Spectrum-MiniMax-H3.git \
    /ComfyUI/custom_nodes/ComfyUI-Spectrum-MiniMax-H3

RUN git clone --depth 1 \
    https://github.com/Hearmeman24/ComfyUI-MiniMaxRefPack.git \
    /ComfyUI/custom_nodes/ComfyUI-MiniMaxRefPack

RUN git clone --depth 1 \
    https://github.com/Hearmeman24/ComfyUI-HearmemanAI-Upscale.git \
    /ComfyUI/custom_nodes/ComfyUI-HearmemanAI-Upscale

RUN git clone --depth 1 \
    https://github.com/Hearmeman24/ComfyUI-LoRABlockSurgeon.git \
    /ComfyUI/custom_nodes/ComfyUI-LoRABlockSurgeon

RUN git clone --depth 1 \
    https://github.com/Hearmeman24/ComfyUI-OpenRouter-Simple.git \
    /ComfyUI/custom_nodes/ComfyUI-OpenRouter-Simple

RUN git clone --depth 1 \
    https://github.com/gabe-init/ComfyUI-Openrouter_node.git \
    /ComfyUI/custom_nodes/ComfyUI-Openrouter_node

RUN git clone --depth 1 \
    https://github.com/ltdrdata/ComfyUI-Manager.git \
    /ComfyUI/custom_nodes/comfyui-manager

# ============================================================
# NODE DEPENDENCIES
# ============================================================

RUN for f in /ComfyUI/custom_nodes/*/requirements.txt; do \
        echo "Installing $f"; \
        pip install --no-cache-dir -r "$f" || exit 1; \
    done

# ============================================================
# RUNPOD NETWORK VOLUME
# ============================================================

COPY extra_model_paths.yaml /ComfyUI/extra_model_paths.yaml

# ============================================================
# SERVER
# ============================================================

ENV COMFYUI_ARGS="--listen 0.0.0.0 --port 8188"

EXPOSE 8188
