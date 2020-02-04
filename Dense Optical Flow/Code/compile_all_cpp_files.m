clc
% compile all cpp files used by the application

mex compute_bilateral_filter.cpp Matrix.cpp Matrix4.cpp

mex occlusions_map_mex.cpp Matrix.cpp

mex apply_linear_operator.cpp Matrix.cpp Matrix4.cpp
mex apply_adjoint_linear_operator.cpp Matrix.cpp Matrix4.cpp

mex correlation_transform_mex.cpp Matrix.cpp Matrix4.cpp