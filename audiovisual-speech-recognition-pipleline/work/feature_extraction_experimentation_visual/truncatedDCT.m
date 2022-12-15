function B = truncatedDCT(A, M, N)
    % TODO: improve this function to use 8*8 (M*N) image blocking like used in blockproc

    [RO, CO]            = size(A);
    img_dct             = dct2(A);
    B                   = img_dct(1:RO/3, 1:CO/3);
end