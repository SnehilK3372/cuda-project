#ifdef HAS_AQUILA
#include "audio_processor.h"
#include <Aquila/source/WaveFile.h>
#include <Aquila/DSP/Transform.h>
#include <Aquila/DSP/Window.h>
#include <numeric>
#include <algorithm>

AudioProcResult process_wav_with_aquila(const std::string &path, int fft_size) {
    Aquila::WaveFile wav(path);
    auto fs = wav.sampleRate();
    AudioProcResult r;
    r.filename = path;
    r.sample_rate = fs;
    r.duration_s = static_cast<double>(wav.getSamplesCount()) / fs;

    // read samples (mono pre-converted)
    std::vector<int16_t> samples;
    samples.reserve(wav.getSamplesCount());
    while (wav.hasMoreSamples()) {
        auto s = wav.readFrame();
        // s is vector of channels; pick channel 0
        samples.push_back(static_cast<int16_t>(s[0]));
    }

    // convert to double [-1,1]
    std::vector<double> x(samples.size());
    std::transform(samples.begin(), samples.end(), x.begin(), [](int16_t v){ return v / 32768.0; });

    // RMS and peak
    double sumsq = 0.0;
    double peak = 0.0;
    for (double v : x) { sumsq += v*v; peak = std::max(peak, std::abs(v)); }
    r.rms = std::sqrt(sumsq / x.size());
    r.peak = peak;

    // FFT: take first fft_size samples (zero-pad if needed)
    int N = std::min<int>(fft_size, x.size());
    std::vector<double> frame(fft_size, 0.0);
    for (int i=0;i<N;++i) frame[i] = x[i] * Aquila::Window::hammingWindow(i, N);

    auto spec = Aquila::Transform::fft(frame);
    // spec: vector<complex>
    int half = spec.size()/2;
    r.fft_magnitudes.resize(half);
    for (int i=0;i<half;++i) r.fft_magnitudes[i] = std::abs(spec[i]);

    return r;
}
#else
AudioProcResult process_wav_with_aquila(const std::string &path, int fft_size) {
    throw std::runtime_error("Aquila not enabled in build");
}
#endif
