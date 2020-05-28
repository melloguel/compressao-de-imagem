function exf(p)

  img = ones(p, p, 3);
  
    for x = 1:1:p
      for y = 1:1:p
	img(x, y, 1) = sin(x);
	img(x, y, 2) = (sin(x) + sin(y))/2.0;
	img(x, y, 3) = sin(x);
	
      endfor
    endfor
    img = im2double(img);
    imwrite(img, "exampleImg.png");
endfunction
