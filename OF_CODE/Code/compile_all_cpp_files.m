clc
% compile all cpp files used by the application

mex compute_regularization_weights.cpp Matrix.cpp Matrix4.cpp

mex occlusions_map_mex.cpp Matrix.cpp

mex linear_operator.cpp Matrix.cpp Matrix4.cpp
mex adjoint_linear_operator.cpp Matrix.cpp Matrix4.cpp
