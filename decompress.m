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

      ii = (k+1) * (i - 1) + 1;
      jj = (k+1) * (j - 1) + 1;

      decImg(ii, jj, 1:3) = imgRead(i, j, 1:3);
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

    
    
    for i = k+2:k+1:rows(decImg)
      for j = 1:k+1:rows(decImg) - k - 1

	matrizF1 = [decImg(i, j, 1);	 
		    decImg(i, j+k+1, 1);	 
		    decImg(i-k-1, j, 1);	 
		    decImg(i-k-1, j+k+1, 1)];
	coef1 = invH * matrizF1;

	matrizF2 =  [decImg(i, j, 2);	 
		     decImg(i, j+k+1, 2);	 
		     decImg(i-k-1, j, 2);	 
		    decImg(i-k-1, j+k+1, 2)];
	coef2 = invH * matrizF2;

	matrizF3 =  [decImg(i, j, 3);	 
		     decImg(i, j+k+1, 3);	 
		     decImg(i-k-1, j, 3);	 
		     decImg(i-k-1, j+k+1, 3)];
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
  ##   matrizB = [[1, 0,   0,     0];
  ##   	       [1, h, h*h, h*h*h];
  ##   	       [0, 1,   0,     0];
  ##   	       [0, 1,  2h, 3*h*h]];
  ##   invB = inv(matrizB);
  ##   transInvB = invB';

  ##   for i = k+1:k+1:rows(decImg)
  ##     for j = 1:k+1:rows(decImg) - k

  ##   	f_ws = zeros(4, 4);

  ##   	f_ws(1, 1) = decImg(i, j, w);	  
  ##   	f_ws(1, 2) = decImg(i, j+k, w); 
  ##   	f_ws(2, 1) = decImg(i-k, j, w); 
  ##   	f_ws(2, 2) = decImg(i-k, j+k, w);	

	  
  ##   	if(i == tamanho)
  ##   	  f_ws(3, 1) = fd(decImg(i, j, w), decImg(i-(k+1), j, w), h);   
  ##   	  f_ws(3, 2) = fd(decImg(i, j+k+1, w), decImg(i-(k+1), j+k+1, w), h);

	
  ##   	else

  ##   	  f_ws(3, 1) = fd(decImg(i+k+1, j, w), decImg(i-(k+1), j, w), 2*h);
  ##   	  f_ws(3, 2) = fd(decImg(i+(k+1), j+k+1, w), decImg(i-k-1, j+k+1, w), 2*h)
	 
  ##   	endif


  ##   	if (i - k == 1)
  ##   	  f_ws(4, 1) = fd(decImg(i, j, w), decImg(i-k, j, w), h);
  ##   	  f_ws(4, 2) = fd(decImg(i, j+k, w), decImg(i-k, j+k, w), h);

  ##   	else
	  
  ##   	  f_ws(4, 1) = fd(decImg(i-k, j, w), decImg(i+k, j, w), 2*h);
  ##   	  f_ws(4, 2) = fd(decImg(i-k, j+k, w), decImg(i+k, j+k, w), 2*h);

  ##   	endif

  ##   	if (j == tamanho)
  ##   	  f_ws(1, 3) = fd(decImg(i, j, w), decImg(i, j-k, w), h);
  ##   	  f_ws(2, 3) = fd(decImg(i-k, j, w), decImg(i-k, j-k, w), h);	  

  ##   	else	  
  ##   	  f_ws(1, 3) = fd(decImg(i, , w), decImg(i, , w), 2*h);	  	  
  ##   	  f_ws(2, 3) = fd(decImg(i+1, , w), decImg(i+1, , w), 2*h);	  	  
  ##   	endif 

	
  ##     endfor
  ##   endfor
    
        
   endif
      
				#  imshow(decImg);
  imwrite(decImg, "decompressed.png");
endfunction


function ret = fd(a, b, h)
  ret = (a - b)/h;
endfunction



function ret = derivaF(img, a, b, h)
  
endfunction
