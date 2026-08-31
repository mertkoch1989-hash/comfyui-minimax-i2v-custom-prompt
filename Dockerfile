FROM runpod/worker-comfyui:5.8.4-base

WORKDIR /comfyui

# ============================================================
# CUSTOM NODES
# ============================================================

RUN git clone --depth 1 \
    https://github.com/kijai/ComfyUI-KJNodes.git \
    /comfyui/custom_nodes/ComfyUI-KJNodes

RUN git clone --depth 1 \
    https://github.com/rgthree/rgthree-comfy.git \
    /comfyui/custom_nodes/rgthree-comfy

RUN git clone --depth 1 \
    https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git \
    /comfyui/custom_nodes/ComfyUI-VideoHelperSuite

RUN git clone --depth 1 \
    https://github.com/xmarre/ComfyUI-Spectrum-MiniMax-H3.git \
    /comfyui/custom_nodes/ComfyUI-Spectrum-MiniMax-H3

RUN git clone --depth 1 \
    https://github.com/Hearmeman24/ComfyUI-MiniMaxRefPack.git \
    /comfyui/custom_nodes/ComfyUI-MiniMaxRefPack

RUN git clone --depth 1 \
    https://github.com/Hearmeman24/ComfyUI-HearmemanAI-Upscale.git \
    /comfyui/custom_nodes/ComfyUI-HearmemanAI-Upscale

RUN git clone --depth 1 \
    https://github.com/Hearmeman24/ComfyUI-LoRABlockSurgeon.git \
    /comfyui/custom_nodes/ComfyUI-LoRABlockSurgeon

RUN git clone --depth 1 \
    https://github.com/Hearmeman24/ComfyUI-OpenRouter-Simple.git \
    /comfyui/custom_nodes/ComfyUI-OpenRouter-Simple

RUN git clone --depth 1 \
    https://github.com/gabe-init/ComfyUI-Openrouter_node.git \
    /comfyui/custom_nodes/ComfyUI-Openrouter_node

# ============================================================
# COMFYUI MANAGER
# ============================================================

RUN git clone --depth 1 \
    https://github.com/ltdrdata/ComfyUI-Manager.git \
    /comfyui/custom_nodes/comfyui-manager

# ============================================================
# NODE DEPENDENCIES
# ============================================================

RUN for f in /comfyui/custom_nodes/*/requirements.txt; do \
        echo "Installing $f"; \
        pip install --no-cache-dir -r "$f" || exit 1; \
    done

# ============================================================
# VERIFY VIDEOHELPERSUITE
# ============================================================

RUN test -f /comfyui/custom_nodes/ComfyUI-VideoHelperSuite/__init__.py

RUN python - <<'PY'
import sys
sys.path.insert(0, "/comfyui")

spec_path = "/comfyui/custom_nodes/ComfyUI-VideoHelperSuite/__init__.py"

import importlib.util

spec = importlib.util.spec_from_file_location(
    "videohelpersuite",
    spec_path
)

module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

assert "VHS_VideoCombine" in module.NODE_CLASS_MAPPINGS

print("========================================")
print("VHS_VideoCombine OK")
print("VideoHelperSuite loaded successfully")
print("========================================")
PY

# ============================================================
# NETWORK VOLUME
# ============================================================

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# ============================================================
# SERVER
# ============================================================

ENV COMFYUI_ARGS="--listen 0.0.0.0 --port 8188"

EXPOSE 8188
