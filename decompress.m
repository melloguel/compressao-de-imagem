#! /usr/bin/env octave
## Sim
function decompress(compressedImg, method, k, h) 
  [imgRead,imgMap] = imread(compressedImg);
  imgRead = im2double(imgRead);
  r = rows(imgRead);
  c = columns(imgRead);
  tamanho = r + (r - 1)*k;
  decImg = zeros(tamanho, tamanho, 3); # matriz de zeros de formato tam*tam*3



  ## imwrite(decImg, "step.png");
  ## Chama o metodo correto
  if (method == 1) # Interpolação bilinear por partes

      for i = 1:r
	ii = (k+1) * (i - 1) + 1;
	for j = 1:r
	  jj = (k+1) * (j - 1) + 1;
	  decImg(ii, jj, 1:3) = imgRead(i, j, 1:3);
	endfor
      endfor

    matrizH = [[1, 0, 0, 0];
	       [1, 0, h, 0];
	       [1, h, 0, 0];
	       [1, h, h, h*h]];
    invH = inv(matrizH);

    r = rows(decImg);
    c = columns(decImg);
    
    
    for i = 1:(k+1):(r-(k+1))
      for j = 1:(k+1):(c-(k+1))

	matrizF1 = [decImg(i, j, 1);	 
		    decImg(i, j+k+1, 1);	 
		    decImg(i+k+1, j, 1);	 
		    decImg(i+k+1, j+k+1, 1)];
	coef1 = invH * matrizF1;

	matrizF2 =  [decImg(i, j, 2);	 
		     decImg(i, j+k+1, 2);	 
		     decImg(i+k+1, j, 2);	 
		    decImg(i+k+1, j+k+1, 2)];
	coef2 = invH * matrizF2;

	matrizF3 =  [decImg(i, j, 3);	 
		     decImg(i, j+k+1, 3);	 
		     decImg(i+k+1, j, 3);	 
		     decImg(i+k+1, j+k+1, 3)];
	coef3 = invH * matrizF3;	

	xc = 0;
	for x = 0:k+1
	  xc = x*(h/(k+1));
	  yc = 0;
	  for y = 0:k+1	    
	    yc = y*(h/(k+1));
	    decImg(i+x, j+y, 1) = coef1(1) + coef1(2) * xc + coef1(3) * yc + coef1(4) * xc * yc;
	    decImg(i+x, j+y, 2) = coef2(1) + coef2(2) * xc + coef2(3) * yc + coef2(4) * xc * yc;
	    decImg(i+x, j+y, 3) = coef3(1) + coef3(2) * xc + coef3(3) * yc + coef3(4) * xc * yc;	    
	  endfor
	endfor
      endfor
    endfor
  endif

  if (method == 2)

    ## Derivadas da função f para as cores Vermelho (1), Verde (2), Azul (3)
    f_1s = zeros(r, r, 2);
    f_2s = zeros(r, r, 2);
    f_3s = zeros(r, r, 2);
    
    for i = 1:r
      ii = (k+1) * (i - 1) + 1;
    	for j = 1:r
    	  jj = (k+1) * (j - 1) + 1;
    	  decImg(ii, jj, 1:3) = imgRead(i, j, 1:3);

    	  if (i == 1)
    	    f_1s(1, j, 1) = fd(imgRead(1, j, 1), imgRead(2, j, 1), h);
    	    f_2s(1, j, 1) = fd(imgRead(1, j, 2), imgRead(2, j, 2), h);
    	    f_3s(1, j, 1) = fd(imgRead(1, j, 3), imgRead(2, j, 3), h);	    
    	  elseif(i == r)
    	    f_1s(r, j, 1) = fd(imgRead(r-1, j, 1), imgRead(r, j, 1), h);
    	    f_2s(r, j, 1) = fd(imgRead(r-1, j, 2), imgRead(r, j, 2), h);
    	    f_3s(r, j, 1) = fd(imgRead(r-1, j, 3), imgRead(r, j, 3), h);	    
    	  else
    	    f_1s(i, j, 1) = fd(imgRead(i-1, j, 1), imgRead(i+1, j, 1), 2*h);
    	    f_2s(i, j, 1) = fd(imgRead(i-1, j, 2), imgRead(i+1, j, 2), 2*h);
    	    f_3s(i, j, 1) = fd(imgRead(i-1, j, 3), imgRead(i+1, j, 3), 2*h);	    
    	  endif

    	  if (j == 1)
    	    f_1s(i, 1, 2) = fd(imgRead(i, 2, 1), imgRead(i, 1, 1), h);
    	    f_2s(i, 1, 2) = fd(imgRead(i, 2, 2), imgRead(i, 1, 2), h);
    	    f_3s(i, 1, 2) = fd(imgRead(i, 2, 3), imgRead(i, 1, 3), h);	    	    
    	  elseif(j == r)
    	    f_1s(i, r, 2) = fd(imgRead(i, r, 1), imgRead(i, r-1, 1), h);
    	    f_2s(i, r, 2) = fd(imgRead(i, r, 2), imgRead(i, r-1, 2), h);
    	    f_3s(i, r, 2) = fd(imgRead(i, r, 3), imgRead(i, r-1, 3), h);	    
    	  else
    	    f_1s(i, j, 2) = fd(imgRead(i, j+1, 1), imgRead(i, j-1, 1), 2*h);
    	    f_2s(i, j, 2) = fd(imgRead(i, j+1, 2), imgRead(i, j-1, 2), 2*h);
    	    f_3s(i, j, 2) = fd(imgRead(i, j+1, 3), imgRead(i, j-1, 3), 2*h);	    
    	  endif
	  
    	endfor
    endfor

    
    matrizB = [[1, 0,   0,     0];
    	       [1, h, h*h, h*h*h];
    	       [0, 1,   0,     0];
    	       [0, 1,  2*h, 3*h*h]];
    
    invB = inv(matrizB);
    transInvB = invB';


    matrizF1 = zeros(4, 4); ## Vermelho
    matrizF2 = zeros(4, 4); ## Verde
    matrizF3 = zeros(4, 4); ## Azul   
    
    ## d2_w = zeros(4, 4)

    
    for i = r:-1:2
      x = (k+1) * (i - 1) + 1;
      for j = 1:r-1
    	y = (k+1) * (j - 1) + 1; 

	
    	## Cor Vermelho (1)
    	matrizF1(1, 1) = imgRead(i, j, 1);
    	matrizF1(1, 2) = imgRead(i, j+1, 1);
    	matrizF1(2, 1) = imgRead(i-1, j, 1);
    	matrizF1(2, 2) = imgRead(i-1, j+1, 1);

    	matrizF1(3, 1) = f_1s(i, j, 1);
    	matrizF1(3, 2) = f_1s(i, j+1, 1);
    	matrizF1(4, 1) = f_1s(i-1, j, 1);
    	matrizF1(4, 2) = f_1s(i-1, j+1, 1);

    	matrizF1(1, 3) = f_1s(i, j, 2);
    	matrizF1(1, 4) = f_1s(i, j+1, 2);
    	matrizF1(2, 3) = f_1s(i-1, j, 2);
    	matrizF1(2, 4) = f_1s(i-1, j+1, 2);


    	## Cor Verde (2)
    	matrizF2(1, 1) = imgRead(i, j, 2);
    	matrizF2(1, 2) = imgRead(i, j+1, 2);
    	matrizF2(2, 1) = imgRead(i-1, j, 2);
    	matrizF2(2, 2) = imgRead(i-1, j+1, 2);

    	matrizF2(3, 1) = f_2s(i, j, 1);
    	matrizF2(3, 2) = f_2s(i, j+1, 1);
    	matrizF2(4, 1) = f_2s(i-1, j, 1);
    	matrizF2(4, 2) = f_2s(i-1, j+1, 1);

    	matrizF2(1, 3) = f_2s(i, j, 2);
    	matrizF2(1, 4) = f_2s(i, j+1, 2);
    	matrizF2(2, 3) = f_2s(i-1, j, 2);
    	matrizF2(2, 4) = f_2s(i-1, j+1, 2);


    	## Cor Azul (3)
    	matrizF3(1, 1) = imgRead(i, j, 3);
    	matrizF3(1, 2) = imgRead(i, j+1, 3);
    	matrizF3(2, 1) = imgRead(i-1, j, 3);
    	matrizF3(2, 2) = imgRead(i-1, j+1, 3);

    	matrizF3(3, 1) = f_3s(i, j, 1);
    	matrizF3(3, 2) = f_3s(i, j+1, 1);
    	matrizF3(4, 1) = f_3s(i-1, j, 1);
    	matrizF3(4, 2) = f_3s(i-1, j+1, 1);

    	matrizF3(1, 3) = f_3s(i, j, 2);
    	matrizF3(1, 4) = f_3s(i, j+1, 2);
    	matrizF3(2, 3) = f_3s(i-1, j, 2);
    	matrizF3(2, 4) = f_3s(i-1, j+1, 2);

	
    	if (i == r)
    	  ## Cor Vermelho (1)
    	  matrizF1(3, 3) = fd(f_1s(i-1, j, 2), f_1s(i, j, 2), h);
    	  matrizF1(3, 4) = fd(f_1s(i-1, j+1, 2), f_1s(i, j+1, 2), h);

    	  ## Cor Verde (2)
    	  matrizF2(3, 3) = fd(f_2s(i-1, j, 2), f_2s(i, j, 2), h);
    	  matrizF2(3, 4) = fd(f_2s(i-1, j+1, 2), f_2s(i, j+1, 2), h);

    	  ## Cor Azul (3)
    	  matrizF3(3, 3) = fd(f_3s(i-1, j, 2), f_3s(i, j, 2), h);
    	  matrizF3(3, 4) = fd(f_3s(i-1, j+1, 2), f_3s(i, j+1, 2), h);
    	else
    	  ## Cor Vermelho (1)
    	  matrizF1(3, 3) = fd(f_1s(i-1, j, 2), f_1s(i+1, j, 2), 2*h);
    	  matrizF1(3, 4) = fd(f_1s(i-1, j+1, 2), f_1s(i+1, j+1, 2), 2*h);

    	  ## Cor Verde (2)
    	  matrizF2(3, 3) = fd(f_2s(i-1, j, 2), f_2s(i+1, j, 2), 2*h);
    	  matrizF2(3, 4) = fd(f_2s(i-1, j+1, 2), f_2s(i+1, j+1, 2), 2*h);

    	  ## Cor Azul (3)	                                   
    	  matrizF3(3, 3) = fd(f_3s(i-1, j, 2), f_3s(i+1, j, 2), 2*h);
    	  matrizF3(3, 4) = fd(f_3s(i-1, j+1, 2), f_3s(i+1, j+1, 2), 2*h);
    	endif


    	if (i == 2)
    	  ## Cor Vermelho (1)
    	  matrizF1(4, 3) = fd(f_1s(i-1, j, 2), f_1s(i, j, 2), h);
    	  matrizF1(4, 4) = fd(f_1s(i-1, j+1, 2), f_1s(i, j+1, 2), h);

    	  ## Cor Verde (2)
    	  matrizF2(4, 3) = fd(f_2s(i-1, j, 2), f_2s(i, j, 2), h);
    	  matrizF2(4, 4) = fd(f_2s(i-1, j+1, 2), f_2s(i, j+1, 2), h);

    	  ## Cor Azul (3)
    	  matrizF3(4, 3) = fd(f_3s(i-1, j, 2), f_3s(i, j, 2), h);
    	  matrizF3(4, 4) = fd(f_3s(i-1, j+1, 2), f_3s(i, j+1, 2), h);
	  
    	else
    	  ## Cor Vermelho (1)
    	  matrizF1(4, 3) = fd(f_1s(i-2, j, 2), f_1s(i, j, 2), 2*h);
    	  matrizF1(4, 4) = fd(f_1s(i-2, j+1, 2), f_1s(i, j+1, 2),2*h);
	  
    	  ## Cor Verde (2)
    	  matrizF2(4, 3) = fd(f_2s(i-2, j, 2), f_2s(i, j, 2), 2*h);
    	  matrizF2(4, 4) = fd(f_2s(i-2, j+1, 2), f_2s(i, j+1, 2),2*h);

    	  ## Cor Azul (3)
    	  matrizF3(4, 3) = fd(f_3s(i-2, j, 2), f_3s(i, j, 2), 2*h);
    	  matrizF3(4, 4) = fd(f_3s(i-2, j+1, 2), f_3s(i, j+1, 2),2*h);
    	endif

    	coef1 = invB * matrizF1 * transInvB;
    	coef2 = invB * matrizF2 * transInvB;
    	coef3 = invB * matrizF3 * transInvB;	
	
    	
    	xc = h;
    	for X = x:-1:x-(k+1)
    	  xc -= (h/(k+1));
    	  yc = 0;

	  matrizX = [1, xc, xc*xc, xc*xc*xc];
	  
	  for Y = y:1:y+k+1
    	    yc += (h/(k+1));

	    matrizY = [1; yc; yc*yc; yc*yc*yc];
	    
	    decImg(X, Y, 1) = matrizX * coef1 * matrizY;
	    decImg(X, Y, 2) = matrizX * coef2 * matrizY;
	    decImg(X, Y, 3) = matrizX * coef3 * matrizY; 
	    
    	  endfor
    	endfor
      endfor
    endfor
  endif
      
  
  imwrite(decImg, "decompressed.png");
endfunction


function ret = fd(a, b, h)
  ret = (a - b)/h;
endfunction

