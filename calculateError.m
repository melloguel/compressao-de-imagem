function ret = calculateError(originalImg, decompressedImg)

  origImg = imread(originalImg);
  decImg = imread(decompressedImg);

  origImg = im2double(origImg);
  decImg = im2double(decImg);
    
  errR = norm(origImg(:, :, 1) - decImg(:, :, 1), 2)/norm(origImg(:, :, 1), 2);
  errG = norm(origImg(:, :, 2) - decImg(:, :, 2), 2)/norm(origImg(:, :, 2), 2);
  errB = norm(origImg(:, :, 3) - decImg(:, :, 3), 2)/norm(origImg(:, :, 3), 2);

  ret = (errR + errG + errB)/3;
endfunction
    
