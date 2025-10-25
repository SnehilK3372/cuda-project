# C++ Image & Audio Processing Pipeline

## Overview

This project implements a **high-throughput image and audio processing pipeline** in modern C++17. It can process:

- Hundreds of small images or tens of large images.
- WAV audio files for feature extraction using **Aquila DSP** (optional).
- Multi-threaded processing using a simple thread pool for efficiency.

The pipeline applies common image-processing steps (CLAHE, denoising, Canny edge detection, morphological operations, and overlay) and extracts audio features (RMS, peak, FFT spectrum).

This repository includes **source code, build scripts, small sample datasets, and proof of execution**.

---

## Features

### Image Processing
- Convert images to grayscale
- Apply CLAHE for contrast enhancement
- Denoise using Non-local Means
- Detect edges using Canny
- Morphological cleanup
- Overlay edges on original images
- Optional tiling / resizing for very large images

### Audio Processing (Optional)
- Load WAV files using **Aquila DSP**
- Compute RMS and peak amplitude
- FFT magnitude spectrum
- Support for STK synthesized signals (optional)

### Multi-threaded
- Uses a thread pool to process images in parallel
- CLI allows specifying number of worker threads

---

## Dependencies

- **C++17**
- [OpenCV](https://opencv.org/) (required)
- [Aquila DSP](http://aquila-dsp.org) (optional, enable with `-DENABLE_AUDIO=ON`)
- [STK - Synthesis Toolkit](https://ccrma.stanford.edu/software/stk/) (optional)
- CMake ≥ 3.10
- Bash (for helper scripts)

---

## Repository Structure

cpp_image_audio_pipeline/
├─ src/ # Source code
│ ├─ main.cpp # CLI entry point
│ ├─ processor.h/.cpp # Image processing functions
│ ├─ audio_processor.h/.cpp # Audio processing functions
│ └─ utils.h/.cpp # Logging, CSV, time utilities
├─ data/ # Small sample datasets (do not commit full datasets)
│ ├─ images/
│ └─ audio/
├─ outputs/ # Processed outputs and logs
│ ├─ processed/
│ ├─ results.csv
│ └─ run.log
├─ CMakeLists.txt # Build configuration
├─ run_local.sh # Build + run example
├─ data_downloader.sh # Download small example datasets
├─ LICENSE.md
└─ README.md

---

## Data Sources

### Images
- **SIPI Image Database (USC)**: https://sipi.usc.edu/database/database.php
- **UCI Machine Learning Repository**: https://archive-beta.ics.uci.edu (MNIST, CMU Face)
- **Creative Commons Search**: https://search.creativecommons.org (manually download a few images for lab proof)

### Audio
- **Aquila DSP**: http://aquila-dsp.org
- **STK**: https://ccrma.stanford.edu/software/stk
- **Example signals**: https://www.dsprelated.com/freebooks/pasp/Sound_Examples.html

> Note: Large datasets should **not be committed**. Use `data_downloader.sh` to fetch small test files.

---

## Build Instructions

1. **Clone repository**:
```bash
git clone https://github.com/SnehilK3372/cuda-project
cd cpp_image_audio_pipeline
mkdir -p build
cmake -S . -B build
cmake --build build -j
# Basic image processing
./build/batch_image_pipeline <input_folder> [workers] [--tile]

# Example:
./build/batch_image_pipeline data/images 6 --tile

# Audio processing (if enabled)
./build/batch_image_pipeline --process-audio data/audio

