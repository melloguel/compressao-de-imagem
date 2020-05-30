function  ret = tester(img, m, k, h)

  compress(img, k);
  decompress("compressed.png", m, k, h);
  calculateError(img, "decompressed.png")
  
endfunction
