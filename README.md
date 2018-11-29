# A Voila-Jones face detector hardware implementation

This project attempts to realize a face detector using Voila-Jones algorithm. The reference C model is borrowed from [5kk73 GPU Assignment 2012](https://sites.google.com/site/5kk73gpu2012/assignment/viola-jones-face-detection), with some modify to fit hardware implementation and fixed some bug. 

The code is written by Verilog/SystemVerilog and Synthesized on Xilinx KintexUltrascale FPGA using Vivado.

This code is just experimental for function, a lot of optimization can further be done.

## Architecture 

This project include 4 main module:
- The capture, this module captures the video input to frame buffer, with a scale of the input video
- The vj-fectch, this module accesses the frame buffer to get the pixels and feed into Volia-Jones engine.
- The vj, this is Volia-Jones engine, accepts original pixels and generates integral image and does classify 
- The draw,  this module is to draw a box onto face detected area. This draw engine does not operate on the frame buffer. It draws on video port on the fly.

## Demo
Xilinx KCU105 Board, with HDMI input and output daughter boards.

The input 1080P HDMI input is scaled down to 480x270 to fill the frame buffer, then perform the face dection.

The final detection result is not very good. there is a lot missed and false detection.


## Simulation
    VCS is used
    goto the sim/face subdirectory 
    run ./face 
     
## Synthesis
    go to vivado/face directory 
    run "vivado -mode tcl -source face-ku.tcl"

## TODO

- The area is large mainly because the ii registers.  which can be optimized and the register width can be manual adjusted. Now all the registers use the same width.
- The detection speed is slow, more classifiers can be paralleled to  speed up the performance.
- To speed up the performance,  the data width of frame buffer should be enlarge to access multiple pixels in one clock.
- The II select MUX can be optimized.
- the Haar feature calculation can be implemented by shift and adder, not multiplier.
- The square root cal module is also a limit of speed. 



## Reference
[https://sites.google.com/site/5kk73gpu2012/assignment/viola-jones-face-detection](https://sites.google.com/site/5kk73gpu2012/assignment/viola-jones-face-detection)

[Junguk Cho, "FPGA-Based Face Detection System Using Haar Classifiers"](http://cseweb.ucsd.edu/~kastner/papers/fpga09-face_detection.pdf)

[Braiden Brousseau, "An Energy-Efficient, Fast FPGA Hardware
Architecture for OpenCV-Compatible Object
Detection"](http://www.eecg.toronto.edu/~jayar/pubs/brousseau/brousseaufpt12.pdf)

[Peter Irgens, "An efficient and cost effective FPGA based implementation
of the Viola-Jones face detection algorithm"](http://www.dejazzer.com/doc/2017_hardware_x.pdf)

## Author

LulinChen  
lulinchen@aliyun.com
