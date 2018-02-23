# FISTA
This repository contains a C++ code implementation of the Fast Iterative Shrinkage/Thresholding Algorithm.

## Tooling
- Windows 10
- Microsoft Visual Studio Community 2017
- Matlab R2017a
- mex setup to compile with Microsoft Visual Studio Community 2017, patch availaible in directory matlab_patch/

## Building/Running the code
1. build the Microsoft Visual Studio solution Fista.sln
1. (optionnal) run executable generated by mve.vcxproj to check that all basic C++ tests are passing 
1. build the Matlab mex files with matlab/build_mex_files.m
1. check correctness of the C++ implementation against Matlab by running matlab/test_mex_files.m

## Considerations
- The software builds for Windows, with Microsoft Visual Studio Community 2017 as a build platform, assuming that Windows being the platform of choice at midx
- library developped in C++
- This is a **time constrained** development exercise
- as the FISTA algorithm operates on Matrixes, I used [Armadillo](http://arma.sourceforge.net/) as a library of choice for all matrix operations in C++
- [Armadillo](http://arma.sourceforge.net/) needs the [LAPACK and the BLAS libraries](http://www.netlib.org/lapack/lug/node11.html). 

## Directory content
- externals: artifacts needed to build my solution (Armadillo, Lapack and Blas)
- matlab: matlab test code to check C++ bit exactness against Matlab code
- matlab_fista: matlab fista lasso reference algorithm 
- matlab_patch: MathWorks patch to build mex files with Visual Studio 2017 and Matlab 2017a
- solutions: microsoft visual studio solution and 2 project files:
    1. fista_lib.vcxproj to build the algorithm  (\*.lib)
    1. fista_test.vcxproj to build a simple algo test app (\*.exe)
- src: the C++ Fista algorithm code
- README.md: this readme

## Code considerations
As this is a direct implementation of some Matlab code, and a time constrained exercise, I kept a lot of things from Matlab
- all variables names are kept
- overall algo structure and function names are kept
- most of the comments in C++ contains the Matlab code. As such, the C++ code below a comment is the C++ implementation of the commented Matlab code
- the Matlab code is not object oriented, neither is mine. This point **should be addressed in a refactoring effort**
- the Matlab code uses function handle to pass functions to the algorithm (gradient, project and cost). In my implementation, those functions are hardcoded (they are in the same file). Function pointers should be used, or may be a more elaborate construct could be used in a refactoring effort.

## Testing
I built a C++ implementation mimicking the Matlab code. The C++ code was built progressively doing one function at a time using the test_all() function in the fista test application.
- test_CalcXtY();
- test_Gradient();
- test_proj_l1();
- test_norm1();
- test_lasso();

The code builds and runs. If something is not tested properly, it probably does not work. Testing my algorithm against the Matlab reference still needs to be completed.  

## Testing against the Matlab reference

### SPAMS toolbox
There is everything in place in the original FISTA repository: https://github.com/tiepvupsu/FISTA under the spams/test_release directory.  
  
The development strategy for the spams toolbox is a divide and conquer approach. For each FISTA algorithm elementary function to implement in C++, a matlab test implements the function in Matlab, and compare the result against the C++ implementation called via a mex file. See for instance test_CalcXtY.m under spams\test_release in https://github.com/tiepvupsu/FISTA

As more and more low level functions are tested, intermediate and more complex functions can be assembled, and tested against Matlab code. As lower level functions are sure to be bit-exact, it gives confidence when assembling them into more complex functions, and only the glue code remains to be debugged.

Debugging in this setup becomes easy as it is possible to step inside the mex code and see what is going on with the Visual Studio debugger. (MSVC > Debug > Attach to process -> choose Matlab process). To do this, the code needs to be built in debug mode, mex files and the fista library.

### my approach 
I adopted a similar approach in the matlab directory. I have mex files that I can build and compare against matlab reference output. Each mex file calls a simple function from the Fista library, and there is a corresponding test to exercise the function in test_mex_files.m.
- build_mex_files.m: building all mex files
- test_mex_files.m: testing the fista lib through mex files

### Status
To be sure that my implementation is bit exact, all functions below should be bit exact. (Not the case right now).
- [x] test_CalcXtY();
- [x] test_Gradient();
- [x] test_proj_l1();
- [x] test_norm1();
- [ ] test_fista_general();
- [ ] test_fista_lasso();

## What to do next/still to be done
- check bit-exactness for fista general and fista_lasso
- investigate why the mex files needs blas_win64_MT.dll and lapack_win64_MT.dll to run properly
- there is a warning when building the C++ code (minor: overlapping directory for output compilation)
- improve design in order to pass cost functions, gradiant and projections as functions pointers for the fista algorithm
- testing could be improved. For instance proj_l1 has two parameters, but I test with a fixed value for lambda. I could make random permutations for lambda in order to make sure that the function works for any pair of input arguments
- better comment. C++ code contains only matlab code as for comment. functions and functions headers should properly be documented, in C/C++ fashion
- improve porting. Not all code path are implemented in C++. For instance, proj_l1 behaves differently whether the pos parameter is true or not. I only coded the true case, as demo_lasso.m and demo_full.m set the pos parameter to true.
