# DIPProject
* The use of residuals in image denoising
* Implementation of a paper by Brunet et. al.

# Code Environment Requirements
* This code will run on Linux OS only due to the use of file specific paths.

# Code Licence and use of 3rd party toolbox
The Total Variation Minimization filter code has been used as a black box. The toolbox is located at <code>./toolbox_optim/</code>.

# Test Images
The test images are located in <code>./USC_SIPI_DATABASE</code>

# Running instructions
* <code>ms1.m</code> to run the algo over 5 test images for 6 different values of noise standard deviation and plot pne figure for each standard deviation

* <code>ms.m</code> to run the algo over all test images for 6 s.d. values and plot them separately (time consuming)

* <code>ms2.m</code> to run the algo over a test images for a s.d. values and plot the resulting image. The iteration continues as long as SSIM decreases