# src/processor.py
import cv2
import numpy as np
from pathlib import Path

def process_image(in_path, out_folder, cfg):
    """Load image, (optional) tile, enhance, denoise, edge-detect, save overlay.
    Returns a dict of metrics.
    """
    p = Path(in_path)
    img = cv2.imdecode(np.fromfile(str(p), dtype=np.uint8), cv2.IMREAD_COLOR)
    if img is None:
        raise ValueError("Could not read image")
    h, w = img.shape[:2]

    # If very large and tiling enabled: simple single-tile approach (tile logic can be extended)
    max_dim = cfg.get('max_dim', 4096)
    if cfg.get('tile_large', False) and max(h,w) > max_dim:
        scale = max_dim / max(h,w)
        img = cv2.resize(img, (int(w*scale), int(h*scale)), interpolation=cv2.INTER_AREA)

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # CLAHE (adaptive histogram equalization)
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    enhanced = clahe.apply(gray)

    # Denoise using fastNlMeans
    denoised = cv2.fastNlMeansDenoising(enhanced, None, h=7, templateWindowSize=7, searchWindowSize=21)

    # Edge detection
    edges = cv2.Canny(denoised, 50, 150)

    # Morphological cleanup
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3,3))
    edges_clean = cv2.morphologyEx(edges, cv2.MORPH_CLOSE, kernel)

    # Overlay edges on original (for color output)
    overlay = img.copy()
    overlay[edges_clean>0] = (0,0,255)  # red edges

    # Save output
    out_name = f"{p.stem}_processed{p.suffix}"
    out_path = Path(out_folder) / out_name
    # np.tofile needed for Windows paths with non-ascii sometimes
    cv2.imencode(p.suffix, overlay)[1].tofile(str(out_path))

    # compute metrics
    mean_intensity = float(np.mean(denoised))
    std_intensity = float(np.std(denoised))
    edges_count = int(np.count_nonzero(edges_clean))

    return {
        'filename': p.name,
        'original_width': w,
        'original_height': h,
        'processed_width': overlay.shape[1],
        'processed_height': overlay.shape[0],
        'mean_intensity': mean_intensity,
        'std_intensity': std_intensity,
        'edges_count': edges_count,
        'out_path': str(out_path),
        'status': 'ok'
    }
