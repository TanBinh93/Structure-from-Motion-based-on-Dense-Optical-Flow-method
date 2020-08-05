The Code was tested on MATLAB R2018a, Windows 64bit.

Input: The set of images
Output: The groups of homologous point (HP-groups)

First of all, have to download optical flow code (OF_CODE) and setpath to the folder containing it.
The description of input and output of each function can be seen inside the script.

1) The parameters for determination of homologous points
tau: a threshold for overlapping region between two images.
epsilon: a threshold value ensures an accurate pixel correspondence.
h: a grid size.

2) Implementation of proposed method

-Step 1:  Determination of reference images.
          (a) Optical flow computation for forward consecutive images by using forward_consecutive_OF.m
          (b) The set of overlapping images with an arbitrary image can be found based on find_overlapping_regions.m
          (c) Then determining the reference images by Reference_images.m 

-Step 2:  For each reference images I_k^{ref}, the HP-groups (the groups of homologous point) can be found by:
          (a) Generate the 2D points for I_k^{ref}. 
          (b) Find the corresponding points between I_k^{ref} and each images I_j belongs to the set of overlapping images with I_{k}^{ref}.
          (c) HP-groups can be determined from pairwise point correspondences.
             Step 2 is done by using Generate_HP.m file. The Generate_HP.m contains the files
             - Reference_images.m which taken the resuts of step 1: the reference images and set of overlapping images with each reference image.
             - Optical flow computation for determining the homologous points between I_k^{ref} and each images I_j.
               Compute the optical flow backward and forward between two images using tvFlow_calc.m
             - Mask_SR.m and Mask_inac.m which allow us to remove the specular reflections and inaccurate homologous point pairs.   
A demo example can be found in Demo_HP_groups_using_DOF.m

3) After obtaining the homologous point groups (point tracks), We can use it as follows
- In MATLAB: It can use directly as input of structure-from-motion and visual odometry which compute the point tracks as a part of these algorithms.
  https://fr.mathworks.com/help/vision/examples/structure-from-motion-from-multiple-views.html
  https://fr.mathworks.com/help/vision/ug/monocular-visual-odometry.html
- You can use HP-groups as an input of Colmap and visualSfM solfware by the guidance in
  https://colmap.github.io/tutorial.html#feature-detection-and-extraction
  http://ccwu.me/vsfm/doc.html#param