# jSPIM_realignment

ImageJ macro for realigning multidimensional single plane illumination microscopy data 

Takes default directory organisation of t-stacks within position folders: 
/pos_i/frame_1.tif
/pos_i/frame_2.tif
/pos_i/frame_3.tif

And reorganises it into an organisation of z-stacks within time-point folders:

/frame_i/pos_1.tif
/frame_i/pos_2.tif
/frame_i/pos_3.tif

NOTE position is z-location of light sheet.

Macro then organises SPIM data set into multidimensional hyperstack before performing realignment to stop the image "drifting" as a result of image acquisition angle. 

