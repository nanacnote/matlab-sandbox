function [ext_vec_matrix] = calcVelVec(vec_matrix)
%CALCVELVEC extend the coefficient vector with velocity components

    [row_size, col_size]        = size(vec_matrix);
    ext_vec_matrix              = zeros(row_size, col_size * 2);
    
    ext_vec_matrix(1,:)         = [vec_matrix(1,:), zeros(1, col_size)];
    ext_vec_matrix(row_size,:)  = [vec_matrix(row_size,:), zeros(1, col_size)];
    
    for i = 2:row_size - 1
        cur_vec                 = vec_matrix(i,:);
        prv_vec                 = vec_matrix(i - 1,:);
        nxt_vec                 = vec_matrix(i + 1,:);
        
        vel                     = nxt_vec - prv_vec;
        ext_vec_matrix(i,:)     = [cur_vec, vel];
    end
end

