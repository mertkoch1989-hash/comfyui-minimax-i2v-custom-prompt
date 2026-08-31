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
