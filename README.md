# Dense Optical Flow based Structure from Motion

## About
Here is the MATLAB code for determining the homologous point groups (point tracks) usable as the input of Structure from Motion (SfM). We proposed a Dense Optical Flow method to generate a numerous and large homologous points in scenes with few textures and structures, and images acquired under strong illumination changes.

This Code tested on MATLAB R2018a.  If you used this code or datasets in your work, please cite:
```
@inproceedings{binhicip2019,
  author    = {T.-B. Phan and D.-H. Trinh and D. Lamarque and D. Wolf and C. Daul},
  title     = {Dense Optical Flow for the Reconstruction of Weakly Textured and Structured Surfaces: Application to Endoscopy},
  booktitle = { {IEEE} International Conference on Image Processing, {ICIP}, Taipei, Taiwan, September 22-25, 2019},
  pages     = {310--314},
  year      = {2019}
}
```
or 
```
@Article{Phan2020,
  author  = {T.-B. Phan and D.-H. Trinh and D. Wolf and C. Daul},
  journal = {Pattern Recognition},
  title   = {Optical flow{-}based structure{-}from{-}motion for the reconstruction of epithelial surfacess},
  year    = {2020},
  pages   = {107391},
  volume  = {105},
}
```
## Video demo
### Demo algorithm
See video "Supplementary_material_Algorithm.avi".
### Example on real data
See videos "Supplementary_fluorescence.mp4" and "Supplemetary_NBI.avi".
## Datasets
https://drive.google.com/file/d/1PwFT9ONd073lT_OxjflIqy-42rX0eaLy/view?usp=sharing

## Usage

The parameters for optical flow and point grouping as well as the guide for code can be seen in file README.txt.

## Contributing

Contributions (bug reports, bug fixes, improvements, etc.) are very welcome and should be submitted in the form of new issues and/or pull requests on GitHub.

## License

[MIT](https://choosealicense.com/licenses/mit/)
