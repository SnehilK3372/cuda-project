
---

# run_local.sh

```bash
#!/usr/bin/env bash
# run_local.sh - Build and run pipeline

set -e

# Build project
echo "Building project..."
mkdir -p build
cmake -S . -B build
cmake --build build -j

# Download small example datasets (images + audio)
echo "Downloading example datasets..."
./data_downloader.sh --all

# Run image pipeline
echo "Running image processing..."
./build/batch_image_pipeline data/images 4 --tile

# Run audio pipeline if enabled
if ./build/batch_image_pipeline --help | grep -q -- "--process-audio"; then
    echo "Running audio processing..."
    ./build/batch_image_pipeline --process-audio data/audio
fi

echo "Pipeline finished. Check outputs/ for processed files, results.csv, and run.log."
