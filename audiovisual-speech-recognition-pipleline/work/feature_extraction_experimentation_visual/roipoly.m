## -*- texinfo -*-
## @deftypefn  {} {@var{BW}} hist (@var{img}, @var{x}, @var{y})
## @deftypefnx  {} {[@var{BW}, @var{x}, @var{y}] =} hist (@var{img})
## Create binary mask from boundary coordinates.
##
## When @var{x} and @var{y} are missing, display @var{img} in a new figure and
## let the user draw a polygon.  A left click adds a point, a middle click
## removes the last added point and a right click terminates the boundary point
## selection.
##
## @seelaso{inpolygon}


function [BW, xv, yv] = roipoly(img, xv, yv)

if nargin == 1

  % Display image in new figure
  fig = gcf();
  imagesc(img);
  hold on;
  colormap(gray);
  ax = gca();

  % Initialize output vertices list
  vertices = [];
  h_list = [];

  % Main GUI loop
  done = false;
  while ~done

    [px, py, b] = ginput(1);
    if b == 1
        vertices = [vertices; px, py];
    elseif b == 2
        vertices = vertices(1:end-1, :);
    elseif b == 3
        done = true;
    endif

    h_list = plot_vertices(ax, vertices, h_list);

  endwhile

  xv = vertices([1:end 1], 1);
  yv = vertices([1:end 1], 2);
  delete(fig);

endif

[x, y] = meshgrid(1:size(img, 1), 1:size(img, 2));
%BW = inpolygon(x, y, xv, yv);
BW = inpolygon(x, y, yv, xv);
BW = BW';

endfunction

function h_list = plot_vertices(ax, vertices, h_list)

for hi = 1:length(h_list)
  for vi = 1:numel(h_list{hi})
    delete(h_list{hi}(vi));
  endfor
endfor

p_args_list = { ...
  {'linestyle', 'none', 'marker', 'o', 'color', 'b', 'markersize', 8}, ...
  {'linestyle', 'none', 'marker', 'o', 'color', 'w', 'markersize', 5}};
e_args_list = { ...
  {'linestyle', '-', 'color', 'b', 'linewidth', 6}, ...
  {'linestyle', '-', 'color', 'w', 'linewidth', 3}};

h_list = { ...
  zeros(size(vertices, 1), length(p_args_list)), ...
  zeros(size(vertices, 1) - 1, length(e_args_list))};
for vi = 1:size(vertices, 1)
  h_p = plot_point(ax, vertices(vi, :), p_args_list);
  h_list{1}(vi, :) = h_p;
  if vi > 1
    h_e = plot_edge(ax, vertices(vi - 1:vi, :), e_args_list);
    h_list{2}(vi - 1, :) = h_e;
  endif
endfor

endfunction

function h_p = plot_point(ax, vertex, p_args_list)

h_p = zeros(length(p_args_list), 1);
for pi = 1:length(p_args_list)
  h_p(pi) = plot(ax, vertex(1), vertex(2), p_args_list{pi}{:});
endfor

endfunction

function h_e = plot_edge(ax, vertices, e_args_list)

h_e = zeros(length(e_args_list), 1);
for pi = 1:length(e_args_list)
  h_e(pi) = plot(ax, ...
    vertices(:, 1), vertices(:, 2), e_args_list{pi}{:});
endfor

endfunction
