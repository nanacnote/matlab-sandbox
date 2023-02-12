function outputImage = ImMultipliedByMatrix(inputImage, matrix)
% IMMULTIPLIEDBYMATRIX  mutlplies each pixel in an image by a give matrix.
    [raw_row, raw_col, raw_depth]       = size(inputImage);
    tmp                                 = reshape(inputImage, [raw_row*raw_col, raw_depth]);
    outputImage                         = reshape(tmp*matrix,[raw_row, raw_col, raw_depth]);