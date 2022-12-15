function [vector] = applyLinearRectFilterbank(num_bands, signal)
%LINEARRECTANGULARFILTERBANK applys a linear filter bank on a signal

    signal_size             = length(signal);
    freq_sample             = signal_size/num_bands;
    vector                   = zeros([1,num_bands]);

    for i = 1:num_bands
        start_index         = freq_sample * i - freq_sample + 1;
        end_index           = freq_sample * i;
        vector(i)            = sum(signal(start_index:end_index));
    end
end

