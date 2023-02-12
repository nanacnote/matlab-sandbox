% loop over the 24 macbeth reflectance and find the product 
% with the chosen illuminant
load("./seed-image-formation.mat");

% map the names from seed file to more meaningful ones
daylight_illuminant             = D65;
tangsten_illuminant             = A;
mcbeth_color_surface            = S;
human_visual_sensitivities      = CMF;
color_camera_sensitivities      = R;


THIS_OBSERVER                       = color_camera_sensitivities;
THIS_ILLUMINANT                     = daylight_illuminant;
THIS_24x24_SURFACE_REFLECTANCE      = mcbeth_color_surface;

[x, num_cols]       = size(S);
result_matrix       = zeros(num_cols,3);

for i = 1:num_cols
    color_sig                   = THIS_ILLUMINANT.*THIS_24x24_SURFACE_REFLECTANCE(:,i);
    result_matrix(i,1)          = sum(THIS_OBSERVER(:,1) .* color_sig);
    result_matrix(i,2)          = sum(THIS_OBSERVER(:,2) .* color_sig);
    result_matrix(i,3)          = sum(THIS_OBSERVER(:,3) .* color_sig);
end

buf    = zeros(50,1200,3);
step   = 51;

for j=1:24
    cur_color                   = xyz2rgb(result_matrix(j,:));
    view                        = zeros(50,50,3);
    view(:,:,1)                 = cur_color(:,1);
    view(:,:,2)                 = cur_color(:,2);
    view(:,:,3)                 = cur_color(:,3);
    buf(:,step-50:step-1,:)     = view(:,:,:);
    step                        = step + 50;
end

mcbeth                      = zeros(200,300,3);
mcbeth(1:50,1:300,:)        = buf(:,1:300,:);
mcbeth(51:100,1:300,:)      = buf(:,301:600,:);
mcbeth(101:150,1:300,:)     = buf(:,601:900,:);
mcbeth(151:200,1:300,:)     = buf(:,901:1200,:);
imshow(mcbeth);