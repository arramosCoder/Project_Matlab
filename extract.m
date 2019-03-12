function watermark = extract(markedImage, alpha, DCT_blue)
mother_wavelet = 'haar';

[exab1, ~,~,~] = dwt2(markedImage, mother_wavelet);
[exab2, ~,~,~] = dwt2(exab1, mother_wavelet);
[exab3, ~,~,~] = dwt2(exab2, mother_wavelet);
[exab4, ~,~,~] = dwt2(exab3, mother_wavelet);

DCT_final = dct2(exab4);

extracted_Mask = (DCT_final - DCT_blue)/alpha;

final_mask = round(extracted_Mask);

watermark = final_mask;
end

