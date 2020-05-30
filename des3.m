function des3 (img, m, h)
  compress(img, 7);

  decompress("compressed.png", m, 1, h);
  decompress("decompressed.png", m, 1, h);
  decompress("decompressed.png", m, 1, h);

  calculateError(img, "decompressed.png")

endfunction
