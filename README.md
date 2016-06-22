# Thesis

MATLAB code portion of my MSc thesis in self-supervised learning of depth from monocular images, given stereo data as the supervisory ground truth input.

The MATLAB code is responsible for testing the learning algorithm in an offline setting, with previously available standard datasets (Make3D 1, NYU Depth V2, and KITTI 2015, more information in the corresponding folders), as well as new high resolution stereo data, collected at TU Delft with a Stereolabs ZED camera.

## Structure
The program is modularized, and structured in such a way that it's relatively easy to use and expand with new features and learning algorithms. All configuration is performed in the `defaultConfiguration` function, where the desired features are specified, as well as per-feature settings. The functions that do the heavy lifting are `generateFeaturesData`, `classificationModel` and `regressionModel`, which in turn call different functions depending on the configuration. Post-processing is then controlled by `processResults`.

## Features
The program currently supports filter-based features similar to Saxena et al, Histogram of Oriented Gradients (HOG), Radon-transform based features, patch distances to learned Textons, and (x, y) coordinates within the image.

## Learning Algorithms
The code supports both classification and regression algorithms. The Calibrated Least Squares algorithm (Agarwal, Kakade, et al) can be used for both. A similar iterative least squares algorithm with a kernel for multi-class classification is also available, as well as an interface to the liblinear implementation of a linear SVM.

## References
Saxena et al - Saxena - Learning Depth from Single Monocular Images (2005)
Agarwal et al - Least Squares Revisited - Scalable Approaches for Multi-Class Prediction (2013)
Fan et al - LIBLINEAR: A Library for Large Linear Classification (2008)
