#pragma once
#include <string>
#include <vector>

struct AudioProcResult {
    std::string filename;
    int sample_rate;
    double duration_s;
    double rms;
    double peak;
    std::vector<double> fft_magnitudes; // trimmed
};

AudioProcResult process_wav_with_aquila(const std::string &path, int fft_size=4096);
