#! /usr/bin/env octave
## Sim
function decompress(compressedImg, method, k, h) 
  [imgRead,imgMap] = imread(compressedImg);
  imgRead = im2double(imgRead);
  r = rows(imgRead);
  tamanho = r + (r - 1)*k;
  decImg = zeros(tamanho, tamanho, 3); # matriz de zeros de formato tam*tam*3

  for i = 1:r
    for j = 1:r
      decImg((k+1) * i, (k+1) * j, 1:3) = imgRead(i, j, 1:3);
    endfor
  endfor
  imwrite(decImg, "step.png");
  ## Chama o metodo correto
  if (method == 1) # Interpolação bilinear por partes
    
    matrizH = [[1, 0, 0, 0];
	       [1, 0, h, 0];
	       [1, h, 0, 0];
	       [1, h, h, h*h]];
    invH = inv(matrizH);

    
    
    for i = k+1:k+1:rows(decImg)
      for j = 1:k+1:rows(decImg) - k

	matrizF1 = [decImg(i, j, 1);	 
		    decImg(i, j+k, 1);	 
		    decImg(i-k, j, 1);	 
		    decImg(i-k, j+k, 1)];
	coef1 = invH * matrizF1;

	matrizF2 =  [decImg(i, j, 2);	 
		     decImg(i, j+k, 2);	 
		     decImg(i-k, j, 2);	 
		    decImg(i-k, j+k, 2)];
	coef2 = invH * matrizF2;

	matrizF3 =  [decImg(i, j, 3);	 
		     decImg(i, j+k, 3);	 
		     decImg(i-k, j, 3);	 
		     decImg(i-k, j+k, 3)];
	coef3 = invH * matrizF3;	


	xc = h;
	for x = 1:k+1
	  xc  -= (h/k+1);
	  yc = 0;
	  for y = 1:k+1
	    yc += (h/k+1);
	    if (i == x)
	      var = 1;
	    else
	      var = i - x;
	    endif
	    
	    decImg(var, j+y, 1) = coef1(1) + coef1(2) * xc + coef1(3) * yc + coef1(4) * xc * yc;
	    decImg(var, j+y, 2) = coef2(1) + coef2(2) * xc + coef2(3) * yc + coef2(4) * xc * yc;
	    decImg(var, j+y, 3) = coef3(1) + coef3(2) * xc + coef3(3) * yc + coef3(4) * xc * yc;	    
	  endfor
	endfor
      endfor
    endfor
  endif

  if (method == 2)
    decImg = cubicDecompress(decImg, k, h);
  endif

#  imshow(decImg);
  imwrite(decImg, "decompressed.png");
endfunction
