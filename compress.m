#! /usr/bin/env octave


function compress (originalImg, k);

  [imgRead,imgMap] = imread(originalImg);
  imgRead = im2double(imgRead);
  p = []; ## Indices dos pixels que serão removidos
  index = 1;
  for i = 1:rows(imgRead)
     if mod(i - 1, k+1) != 0
       p(index) = i;
       index++;
     endif
  endfor
  
  imgRead(p, :) = [];
  imgRead(:, p) = [];
  
  imwrite(imgRead, "compressed.png");
endfunction

