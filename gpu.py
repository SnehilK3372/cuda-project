
try:
    import cupy as cp
    HAS_CUPY = True
except Exception:
    HAS_CUPY = False

def gpu_hist_equalize(gray_np):
    if not HAS_CUPY:
        raise RuntimeError("CuPy not installed")
    g = cp.asarray(gray_np)
    # implement histogram equalization in cupy...
    # return cp.asnumpy(result)
