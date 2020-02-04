The Code tested on MATLAB R2018a 

Input: The set of images
Output: The groups of homologous point (HP-groups)

I) The parameters

1) The Parameter for Optical Flow:
PyramidF = [0.9 0.7 0.9 0.9 0.9 0.9 0.7 0.8 0.5 0.9];
Lambda = [11 50 60 30 30 1.3 35 10 12 75];

st.dx = 3; st.dy = st.dx; % the size of the data window (the size of the correlation window, the size of the census window etc)
st.nx = 5; st.ny = st.nx; % the size of non-local propagation window
% rescalling settings
st.old_auto_level = false;
st.unEqualSampling = true;
st.downsample_method = 'bilinear'; % the downsampling method used to build the pyramids
st.upsample_method = 'bilinear'; % method for upsampling the flow
st.downsample_method_for_bf = 'bilinear'; % the downsampling method for the pyramid used to compute the bilateral weights
st.antialiasing_start_level = 3; % perform antialiasing for all the levels higher or equal than the given level; for the other levels do not use antialiasing
% warping settings
st.warps = 5; % the numbers of warps per level
st.warping_method = 'bicubic';
% numerical scheme's settings
st.max_its = 35; % the number of equation iterations per warp
%%
Descriptor = 2;
st.lambda = Lambda(Descriptor);
st.D = sprintf('D%01i', Descriptor);
st.pyramid_factor = 0.7;% PyramidF(Descriptor);

2) The parameter for group of homologous points determination 
epsilon = 0.1 is the threshold for accurate correspondence (epsilon can be selected from 0.1 to 0.9)
Tau = 2*W*H/3 where WH be the size of image
h = 10 is the grid size

II) Function (the detailed format of input and output can be seen inside the scripts)

- To compute the optical flow between two images, using the script tvFlow_calc.m
- To compute the reference images can use the script Reference_images.m
- The set of overlapping regions with an arbitrary image can be found by using find_overlapping_regions.m
- To crop the overlapping region between reference image I_k^{ref} and each image I_j belongs to the set of overlapping images with I_{k}^{ref},
  using script Crop_Ovverlapping.m : the out put are the two sub-images of overlapping region extracted from I_k^{ref} and I_j.
- The implementation of inaccurate mask and specular reflection mask can be found in Mask_SR.m and Mask_inac.m
See the inside of each function to know the detail.

III) Step by step of the proposed method
-Step 1: Computing OF forward and backward for each pair of consecutive images. 
-Step 2: For each image, finding the set of overlapping images with it.
-Step 3: Determination of reference images.
-Step 4: For each reference images I_k^{ref}, the HP-groups (the groups of homologous points) can be determined by:
         + Generating the 2D points for I_k^{ref}.
         + Determination of corresponding points between I_k^{ref} and each images I_j belongs to the set of overlapping images with I_{k}^{ref}.
A demo example can be found in Generate_HP.m