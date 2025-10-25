#!/usr/bin/env bash
set -e
# data_downloader.sh
# Usage: ./data_downloader.sh --images --audio
# Downloads small/example datasets (does NOT commit them to git).

OUTDIR="data"
IMAGES_DIR="$OUTDIR/images"
AUDIO_DIR="$OUTDIR/audio"

mkdir -p "$IMAGES_DIR"
mkdir -p "$AUDIO_DIR"

download_sipi() {
  echo "Downloading SIPI sample images (a small subset) ..."
  # SIPI has pages listing images; here we fetch a few canonical images by direct URL.
  # NOTE: replace or expand these with the files you actually need.
  declare -a urls=(
    "https://sipi.usc.edu/database/preview/misc/4.2.03.png"  # example preview image
    "https://sipi.usc.edu/database/preview/misc/4.2.04.png"
  )
  for u in "${urls[@]}"; do
    echo "  fetching $u"
    curl -L -o "$IMAGES_DIR/$(basename $u)" "$u" || echo "failed $u"
  done
}

download_uci_mnist() {
  echo "Downloading small UCI / MNIST subset (useful for tests) ..."
  # UCI repository examples - many datasets have unique URLs; here we grab MNIST from Yann LeCun for small test.
  mkdir -p "$IMAGES_DIR/mnist"
  # Example: fetch a small zipped subset (you may want to replace with real dataset URL in lab)
  # Below are placeholders; replace with the exact dataset you need.
  echo "  NOTE: the UCI / MNIST images often require manual download; place them under data/images/mnist/"
  # If you have direct file URLs, use curl -L -o ...
}

download_audio_examples() {
  echo "Downloading example audio signals ..."
  # example WAVs (public domain / example files). Replace with DSP-related examples you need.
  declare -a urls=(
    "https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand60.wav"
    "https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav"
  )
  for u in "${urls[@]}"; do
    echo "  fetching $u"
    curl -L -o "$AUDIO_DIR/$(basename $u)" "$u" || echo "failed $u"
  done
}

show_help() {
  echo "Usage: $0 [--images] [--audio] [--all]"
  exit 0
}

if [ $# -eq 0 ]; then
  show_help
fi

for arg in "$@"; do
  case $arg in
    --images) download_sipi; download_uci_mnist; shift ;;
    --audio) download_audio_examples; shift ;;
    --all) download_sipi; download_uci_mnist; download_audio_examples; shift ;;
    --help) show_help ;;
    *) echo "Unknown option $arg"; show_help ;;
  esac
done

echo "Done. Data saved under $OUTDIR/ (not committed)."
