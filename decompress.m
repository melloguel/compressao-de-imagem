#! /usr/bin/env octave
## Sim
function decompress(compressedImg, method, k, h) 
  [imgRead,imgMap] = imread(compressedImg);
  imgRead = im2double(imgRead);
  r = rows(imgRead);
  tamanho = r + (r - 1)*k;
  decImg = zeros(tamanho, tamanho, 3); # matriz de zeros de formato tam*tam*3



  ## imwrite(decImg, "step.png");
  ## Chama o metodo correto
  if (method == 1) # Interpolação bilinear por partes

      for i = 1:r
	for j = 1:r
	  ii = (k+1) * (i - 1) + 1;
	  jj = (k+1) * (j - 1) + 1;
	  decImg(ii, jj, 1:3) = imgRead(i, j, 1:3);
	endfor
      endfor

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

    
    f_ws = zeros(r, r);
    
    for i = 1:r
      ii = (k+1) * (i - 1) + 1;
	for j = 1:r
	  jj = (k+1) * (j - 1) + 1;
	  decImg(ii, jj, 1:3) = imgRead(i, j, 1:3);


	  if (i == 1)
	    f_ws(1, j) = fd(imgRead(1, j, w), imgRead(2, j, w), h);	    
	  elseif(i == r)
	    f_ws(r, j) = fd(imgRead(r-1, j, w), imgRead(r, j, w), h);
	  else
	    f_ws(i, j) = fd(imgRead(i-1, j, w), imgRead(i+1, j, w), 2*h);
	  endif

	  if (j == 1)
	    f_ws(i, j) = fd(imgRead(i, 2, w), imgRead(i, 1, w), h);	    
	  elseif(j == r)
	    f_ws(i, r) = fd(imgRead(i, r, w), imgRead(i, r-1, w), h);
	  else
	    f_ws(i, j) = fd(imgRead(i, j+1, w), imgRead(i, j-1, w), 2*h);
	  endif
	  
	endfor
    endfor


    matrizB = [[1, 0,   0,     0];
    	       [1, h, h*h, h*h*h];
    	       [0, 1,   0,     0];
    	       [0, 1,  2h, 3*h*h]];
    invB = inv(matrizB);
    transInvB = invB';

    for i = k+2:k+1:rows(decImg)
      for j = 1:k+1:rows(decImg) -k -1

    	f_ws = zeros(4, 4);

    	f_ws(1, 1) = decImg(i, j, w);	  
    	f_ws(1, 2) = decImg(i, j+k, w); 
    	f_ws(2, 1) = decImg(i-k, j, w); 
    	f_ws(2, 2) = decImg(i-k, j+k, w);	

	  
    	## if(i == tamanho)
    	##   f_ws(3, 1) = fd(decImg(i, j, w), decImg(i-(k+1), j, w), h);   
    	##   f_ws(3, 2) = fd(decImg(i, j+(k+1), w), decImg(i-(k+1), j+(k+1), w), h);

	
    	## else
    	##   f_ws(3, 1) = fd(decImg(i-(k+1), j, w), decImg(i+(k+1), j, w), 2*h);
    	##   f_ws(3, 2) = fd(decImg(i-(k+1), j+(k+1), w), decImg(i+(k+1), j+(k+1), w), 2*h)
	 
    	## endif


    	## if (i - (k + 1) == 1)
    	##   f_ws(4, 1) = fd(decImg(i, j, w), decImg(i-(k+1), j, w), h);
    	##   f_ws(4, 2) = fd(decImg(i, j+(k+1), w), decImg(i-(k+1), j+(k+1), w), h);

    	## else	  
    	##   f_ws(4, 1) = fd(decImg(i-2*(k+1), j, w), decImg(i, j, w), 2*h);
    	##   f_ws(4, 2) = fd(decImg(i-2*(k+1), j+(k+1), w), decImg(i, j+(k+1), w), 2*h);
	  
    	## endif

    	## if (j +(k+1) == tamanho)
    	##   f_ws(1, 4) = fd(decImg(i, j+(k+1), w), decImg(i, j, w), h);
    	##   f_ws(2, 4) = fd(decImg(i-(k+1), j+(k+1), w), decImg(i-(k+1), j, w), h);	  

    	## else	  
    	##   f_ws(1, 4) = fd(decImg(i, j+2*(k+1) , w), decImg(i, j, w), 2*h);	  	  
    	##   f_ws(2, 4) = fd(decImg(i-(k+1),j+2*(k+1) , w), decImg(i-(k+1), j, w), 2*h);	  	  

	## endif 


	## if (j == 1)
	##   f_ws(1, 3) = fd(decImg(i, j+(k+1), w), decImg(i, j, w), h);
	##   f_ws(2, 3) = fd(decImg(i-(k+1), j+(k+1), w), decImg(i-(k+1), j, w), h);

	##   aux_w = fd(decImg(i+(k+1), , w), decImg()); 

	## else
	##   f_ws(1, 3) = fd(decImg(i, j+(k+1), w), decImg(i, j-(k+1), w), 2*h);
	##   f_ws(1, 3) = fd(decImg(i-(k+1), j+(k+1), w), decImg(i-(k+1), j-(k+1), w), 2*h);
	  
	## endif

	## aux_w = fd(decImg(i, j, w), decImg(i, j, w), 2*h);
	
	## f_ws(



	
	
      endfor
    endfor
    
        
   endif
      
				#  imshow(decImg);
  imwrite(decImg, "decompressed.png");
endfunction


function ret = fd(a, b, h)
  ret = (a - b)/h;
endfunction



function ret = derivaF(img, a, b, h)
  
endfunction
