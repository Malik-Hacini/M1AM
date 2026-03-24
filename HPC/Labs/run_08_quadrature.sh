#! /bin/bash

make clean
make quad || exit 1
export OMP_NUM_THREADS=${OMP_NUM_THREADS:-4}
./quad output_run_08_quadrature.csv || exit 1
