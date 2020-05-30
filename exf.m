function exf(p, n)

  img = ones(p, p, 3);
  img = im2double(img);
  h = 0.002;

  i = p;
  for x = 1:1:p
    j = 1;
    for y = 1:1:p
      if (n == 1)
	img(x, y, 1) = sin(h*i);
	img(x, y, 2) = (sin(h*i) + sin(h*j))/2.0;
	img(x, y, 3) = sin(h*i);
      elseif(n == 2)
	img(x, y, 1) = (h*i) * (h * i) * (h *i);
	img(x, y, 2) = sin(h*i);
	img(x, y, 3) = cos(h*j);
      elseif(n == 3) ## f(x, y) = (x^5 + (x - y^2)^2 - x^3, x^2 + x^4 + x^6 - y^5 - y^3 - y, (x^3 - y^3)^2)
	img(x, y, 1) = (h*i)*(h*i)*(h*i)*(h*i)*(h*i) + ((h*i) - (h*j)*(h*j))*((h*i) - (h*j)*(h*j)) - (h*i)*(h*i)*(h*i);
	img(x, y, 2) = (h*i)*(h*i) + (h*i)*(h*i)*(h*i)*(h*i) + (h*i)*(h*i)*(h*i)*(h*i)*(h*i)*(h*i) - (h*j)*(h*j)*(h*j)*(h*j)*(h*j) - (h*j)*(h*j)*(h*j) - (h*j);
	img(x, y, 3) = ((h*i)*(h*i)*(h*i) -  (h*j)*(h*j)*(h*j)) * ((h*i)*(h*i)*(h*i) -  (h*j)*(h*j)*(h*j));
      elseif (n == 4)
	img(x, y, 1) = (h*i) + (h*j);
	img(x, y, 2) = (h*j)*2 + 7;
	img(x, y, 3) = (h*i) * (h*j) * 4;
      endif
      
      j += 1;      
    endfor
    i -= 1;
  endfor
  img = im2double(img);
  imwrite(img, "f.png");
endfunction
