function [ext_vec_matrix] = calcEnergyVec(vec_matrix)
%CALCENERGYVEC extend the coefficient vector with energy component

    [row_size, col_size]        = size(vec_matrix);
    ext_vec_matrix              = zeros(row_size, col_size + 1);
    
    for i = 1:row_size
        cur_vec                 = vec_matrix(i,:);
        energy                  = sum(cur_vec.*cur_vec)/col_size;
        ext_vec_matrix(i,:)     = [cur_vec, energy];
    end
end

