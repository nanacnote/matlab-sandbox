function [vector] = applyMelTriangleFilterbank(num_bands, signal)
%APPLYMELTRIANGLEFILTERBANK applys a mel triangle filter bank on a signal

    % Inline conversion functions
    f2m                     = @(x) 2595 .* log10(1 + (x./700));
    m2f                     = @(x) 700 .* (10 .^ (x./2595) - 1);

    sig_size                = length(signal);
    loHz                    = min(signal);
    hiHz                    = max(signal);
    
    lowMel                  = f2m(loHz);
    hiMel                   = f2m(hiHz);
    x_mel                   = linspace(lowMel, hiMel, num_bands + 2);
    x_hz                    = m2f(x_mel);
    fbank                   = zeros(num_bands, sig_size);
    bin                     = floor(1 + sig_size * x_hz / hiHz);
    bin(num_bands + 2)      = sig_size;

    for j = 1:num_bands
        for i = bin(j):bin(j+1)
             fbank(j, i) = (i - bin(j)) / (bin(j+1)-bin(j));
        end
        for i = bin(j+1):bin(j+2)
             fbank(j, i) = (bin(j+2) - i) / (bin(j+2)-bin(j+1));
        end
    end
    
    vector = fbank * signal;
end

