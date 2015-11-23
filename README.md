# DIPProject
* The use of residuals in image denoising
* Implementation of a paper by Brunet et. al.

# Code Environment Requirements
* This code will run on Linux OS only due to the use of file specific paths.

# Code Licence and use of 3rd party toolbox
The Total Variation Minimization filter code has been used as a black box. The toolbox is located at <code>./toolbox_optim/</code>.

# Test Images
The test images are located in <code>./USC_SIPI_DATABASE</code>

# Code details
* <code>ms1.m</code> executes the algo over 5 test images for 6 different values of noise standard deviation and plots psnr and ssim figure for each standard deviation. Denoiser 1 is Wiener filter and Denoiser 2 is TVD

* <code>ms2.m</code> executes the algo over the lenna image for a s.d value mentioned in the code. Plots the residues and images for 2 iterations. Denoiser 1 is TVD and Denoiser 2 is Wiener filter.

* <code>ms3.m</code> Similar to <code>ms2.m</code> except that Denoiser 1 is Wiener filter and Denoiser 2 is TVD.