# Submission Notes - Labs 1 to 3

## Files prepared in this round

- `main.cpp`: Lab 2 and Lab 3 matrix-multiplication kernels completed.
- `quad.cpp`: separate numerical integration benchmark program for Lab 3.
- `run_08_quadrature.sh`: simple driver for the quadrature benchmark.
- `plot_quad_csv.py`: plotting helper for quadrature CSV output.
- `slides/submission.typ`: combined slide deck source for the submission.

## Matrix multiplication highlights

### Cache blocking (`output_run_04_mmul_blocked.csv`)

- `mm_mul_blocked_ikj` peaks at `6.471 GFLOP/s` for `N=128`.
- `mm_mul_blocked_ikj` stays at `3.810 GFLOP/s` for `N=1024`.
- `mm_mul_simple_ikj` reaches only `2.825 GFLOP/s` for `N=1024`.
- Takeaway: tiling clearly helps once the matrices no longer fit well in cache.

### SIMD (`output_run_05_mmul_simd.csv`)

- `mm_mul_simd_ikj` reaches `15.003 GFLOP/s` at `N=256`.
- `mm_mul_blocked_ikj` remains strongest for larger sizes with `12.273 GFLOP/s` at `N=512` and `12.068 GFLOP/s` at `N=1024`.
- Takeaway: SIMD helps, but cache reuse still matters a lot for large matrices.

### OpenMP (`output_run_06_mmul_openmp.csv`)

- With `OMP_NUM_THREADS=4`, the threaded blocked kernel reaches `16.318 GFLOP/s` at `N=256`.
- It delivers `15.345 GFLOP/s` at `N=512` and `20.030 GFLOP/s` at `N=1024`.
- Takeaway: threading becomes most valuable on the larger blocked workloads, where it improves throughput without changing the memory-friendly structure.

## Numerical integration highlights

### Validation

- Test problem: `int_0^1 4 / (1 + x^2) dx = pi`.
- Required midpoint resolution for error `<= 1e-8`: `N=4096`.

### Benchmark (`output_run_08_quadrature.csv`)

- At `N=4096`, both parallel versions are already about `1.15x` faster than serial.
- At `N=65536`, the hand-written reduction reaches `1.354x` speedup.
- At `N=65536`, the OpenMP reduction reaches `1.514x` speedup.
- Takeaway: OpenMP reduction is the cleanest implementation and also the fastest here.

## Plotting note

The plotting helpers are ready, but the current environment is missing a working scientific Python stack (`numpy` / `matplotlib`).
If that stack is installed later, the CSV files can be turned into figures directly from the lab root.
