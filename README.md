# CUDA-Course3_Project
## Data sources

We use the following resources for images and audio for the assignment — NOTE: do not commit large datasets into repo. Use `data_downloader.sh` to pull small example files for lab tests; for full datasets download manually and place under `data/`:

### Images
- **SIPI (USC)** — https://sipi.usc.edu/database/database.php  
  Best for diverse image categories (textures, aerial, faces, misc). The site has preview images and download links for sets. Place downloaded images under `data/images/sipi/`.
- **UCI Machine Learning Repository** — https://archive-beta.ics.uci.edu  
  Useful image datasets: Iris (non-image), CMU Face, MNIST (handwritten digits) — place under `data/images/uci/`.
- **Creative Commons** — https://search.creativecommons.org  
  Use this for copyright-safe image selection. Manual download recommended; place into `data/images/cc/`.

### Audio / signals
- **Aquila (C++ DSP)** — http://aquila-dsp.org  
  Use Aquila to load WAV files and compute features (spectrum, RMS, spectrogram). Put audio files under `data/audio/`.
- **STK (Synthesis Toolkit)** — https://ccrma.stanford.edu/software/stk/  
  Use to synthesize signals for testing (instrument sounds).

### How to fetch (quick)
- Run: `./data_downloader.sh --all` to download a few small example images and example WAVs for testing.
- For full datasets (SIPI / MNIST / UCI datasets) follow the dataset pages and download the tar/zip, then extract under `data/` (do not add to git).

### Licensing / attribution
- SIPI images and UCI datasets are for educational use — check their site for license details and cite them in your submission.
- For Creative Commons images use `CC-BY` or `CC0` licensed images and keep a `data/LICENSES.md` file listing image URLs and licenses for grading.

