function [magnitude,phase] = magAndPhase(signal)
%MAGANDPHASE Magnitude and Phase extractor
%   Extracts the magnitude and phase value of a signal from the frequency
%   domain
    w               = length(signal);
    h               = hamming(w);
    hammedFrame     = h .* signal;
    xDFT            = fft(hammedFrame);
    magnitude       = abs(xDFT);
    phase           = angle(xDFT);
end

