# Project_Matlab

So this project can be broken up into 3 sections
1) Embedding and Extracting Watermark with Video
  filename:     videoframe_dwt.m
  dependecies:
                MASK_NAME:    saber.jpg
                VIDEONAME:    pizza_guy_Small.mp4
  description:  Extract a frame from video, apply 2-Level DWT with DCT,
                add binary mark and reconstruct image, extact watermark from
                reconstructed image
                MASK_NAME: name of the image to use as the watermark, do include the file extension
                VIDEONAME: video that is used for watermarking
                
2) Embedding, Attacking, and Extracting Watermark from Video
  filenames: attack_testing.m
  description: Complete test script of algorithm. Takes in a .mp4 video, embeds the watermark into each frame, adds the noise, and extracts   the frames and calculates the NC between the original frame and extracted frame.
  user-editable parameters: 
    NAME: name of the video to be watermarked, do not include the file extension (the video must be .mp4)
    MASK_NAME: name of the image to use as the watermark, do include the file extension
    alpha: any positive integer
  dependencies: extract.m, embed.m, pizza_guy_Small.mp4, saber.jpg
  
3) Normalized Correlation Graphs with Averages
  filename:     nc_graphs.m
  dependencies: workspace10.mat, workspace50.mat, workspace100.mat, workspace1000.mat
  description:  using data from 2) to create neater normalized correleation
                graphs

