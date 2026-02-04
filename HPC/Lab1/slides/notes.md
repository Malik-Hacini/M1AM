
# Lab 1 — Assignment 1: Matrix norm (sum over all elements)

## Implemented kernels

### `kernel__matrix_sum_rowwise`

**Algorithm**

- Use two nested loops over the matrix.
- Outer loop iterates over rows `i`.
- Inner loop iterates over columns `j`.
- Accumulate $A_{i,j}$ into a scalar accumulator.

**Code behavior**

- Access pattern is contiguous in memory for row-major storage because the inner loop walks along `j`.
- Each element is read exactly once and added to the accumulator.

### `kernel__matrix_sum_colwise`

**Algorithm**

- Use two nested loops over the matrix.
- Outer loop iterates over columns `j`.
- Inner loop iterates over rows `i`.
- Accumulate $A_{i,j}$ into a scalar accumulator.

**Code behavior**

- Access pattern is strided in memory for row-major storage because the inner loop jumps by `N` each step.
- Each element is read exactly once and added to the accumulator.

## Performance results (from `output_run_01_matrix_norm_novec.csv`)

| N | Row-wise | Column-wise |
|---:|---:|---:|
| 512 | 1.4996 | 0.1986 |
| 1024 | 1.5394 | 0.1798 |
| 1536 | 1.5754 | 0.1562 |
| 2048 | 1.5916 | 0.1512 |
| 2560 | 1.5854 | 0.1260 |
| 3072 | 1.5651 | 0.1174 |
| 3584 | 1.6027 | 0.0991 |
| 4096 | 1.6014 | 0.0881 |
| 4608 | 1.5432 | 0.0813 |
| 5120 | 1.5874 | 0.0778 |

### Interpretation

- **Row-wise** stays close to ~1.55–1.60 across sizes, which indicates efficient streaming through memory with good spatial locality and effective hardware prefetching.
- **Column-wise** is already much slower at $N=512$ and keeps decreasing as $N$ grows, consistent with a stride-$N$ access pattern that defeats spatial locality and causes many cache misses.
- Both variants perform the same $N^2$ additions, so the observed performance gap is dominated by memory access efficiency rather than arithmetic work.

Row-wise is more efficient here because the matrix is stored in row‑major order. That layout is a language/design choice (C/C++ use row‑major by default), not a hardware rule. In row‑major, elements of a row are contiguous in memory, so the CPU can fetch cache lines and prefetch the next ones efficiently. Column‑wise jumps by a stride of $N$, so each access lands in a different cache line for large $N$, wasting bandwidth and increasing misses. In a column‑major language (like Fortran), the opposite would be true.

# Lab 1 — Assignment 2: Matrix initialization

## Implemented setup

The matrix entries are initialized using trigonometric functions so that the rows of $A$ are orthogonal to the columns of $B$, which yields $AB = I$.

$$
A_{i,j} = \cos\left(\pi \cdot \frac{(j+21)(i+12)}{N}\right)
$$

$$
B_{i,j} = \frac{2}{N}\cos\left(\pi \cdot \frac{(i+12)(j+12)}{N}\right)
$$

## Notes

- Implemented in `matrix_setup_A()` and `matrix_setup_B()` in [main.cpp](main.cpp).
- Complexity is $O(N^2)$ for each matrix initialization, with a compute-heavy inner loop dominated by `cos` evaluations.
- The setup enables later matrix-multiplication validation: `validate_matrix_C()` checks that $C$ is the identity when multiplying $A$ and $B$.

## Test

- Ran `run_01_matrix_norm_novec.sh` successfully after the changes; compilation and runtime completed without errors.

# Lab 1 — Assignment 3: Matrix multiplication (6 loop orderings)

## Implemented kernels

All variants compute $C += AB$.

- `kernel__matrix_matrix_mul_simple_ijk`: outer `i`, middle `j`, inner `k` with a local `sum` then `C_{ij} += sum`.
- `kernel__matrix_matrix_mul_simple_jik`: outer `j`, middle `i`, inner `k` with a local `sum`.
- `kernel__matrix_matrix_mul_simple_ikj`: outer `i`, middle `k`, inner `j`, updates `C_{ij}` directly.
- `kernel__matrix_matrix_mul_simple_jki`: outer `j`, middle `k`, inner `i`, updates `C_{ij}` directly.
- `kernel__matrix_matrix_mul_simple_kij`: outer `k`, middle `i`, inner `j`, updates `C_{ij}` directly.
- `kernel__matrix_matrix_mul_simple_kji`: outer `k`, middle `j`, inner `i`, updates `C_{ij}` directly.

All implementations are in [main.cpp](main.cpp) and validated with the existing identity-matrix check.

## Performance results

### `run_02a_mmul_simple_ijk.sh`

| N | ijk (GFLOP/s) |
|---:|---:|
| 8 | 0.9603 |
| 16 | 3.6958 |
| 32 | 4.8023 |
| 64 | 5.8307 |
| 128 | 3.1317 |
| 256 | 3.0588 |
| 512 | 0.8067 |
| 1024 | 0.6750 |

### `run_02b_mmul_simple_all.sh`

| N | ijk | jik | ikj | jki | kij | kji |
|---:|---:|---:|---:|---:|---:|---:|
| 8 | 1.3328 | 1.2635 | 1.1448 | 0.8402 | 1.0632 | 1.0997 |
| 16 | 3.6290 | 3.1602 | 3.2133 | 2.3398 | 3.2272 | 2.3815 |
| 32 | 5.3860 | 4.9485 | 4.6101 | 2.5163 | 4.5774 | 3.0157 |
| 64 | 5.7888 | 5.2052 | 4.0675 | 2.8706 | 4.0964 | 2.7288 |
| 128 | 3.1798 | 3.0221 | 4.7000 | 0.8203 | 4.6876 | 0.8413 |
| 256 | 3.2194 | 3.0137 | 5.0199 | 0.7376 | 4.9976 | 0.7445 |
| 512 | 0.8215 | 0.8338 | 5.0407 | 0.3689 | 4.9692 | 0.3710 |
| 1024 | 0.7542 | 0.6615 | 4.8478 | 0.3203 | 4.4209 | 0.3264 |

## Interpretation (why loop order matters)

- With row‑major storage, the **inner loop should walk contiguous memory** to maximize cache line utilization.
- **`ikj` and `kij` are fastest** at medium/large sizes because the inner `j` loop streams through contiguous `B[k,*]` and `C[i,*]`, while `A[i,k]` is reused from a register.
- **`ijk` and `jik` degrade for large $N$** because the inner `k` loop accesses `B[k,j]` with stride $N$, which is cache‑unfriendly; `C[i,j]` is updated once per `k` loop (good), but `B` locality is poor.
- **`jki` and `kji` are slowest** because the inner `i` loop strides through both `A[i,k]` and `C[i,j]`, causing poor spatial locality and frequent cache misses.

These differences arise purely from memory access patterns and cache reuse; the arithmetic count is identical for all orderings ($2N^3 - N^2$ flops per multiplication).

## Tests

- Ran `run_02a_mmul_simple_ijk.sh` and `run_02b_mmul_simple_all.sh` successfully; outputs recorded in the CSV files above.

# Lab 1 — Assignment 4: Aliasing & `restrict` statements

## What `restrict` means (intuition)

In C/C++, the compiler must assume that two pointers might refer to the same memory (aliasing). If it cannot prove otherwise, it has to be conservative and may reload values or avoid certain optimizations.

The `__restrict__` qualifier is a promise: **the memory ranges pointed to by these pointers do not overlap** for the lifetime of the function call. This enables better optimization (e.g., keeping values in registers, reordering loads/stores, more aggressive vectorization).

## Implemented kernel

- `kernel__matrix_matrix_mul_restricted_ikj` uses the same `ikj` ordering as the fast simple variant, but adds `__restrict__` on `A`, `B`, and `C` to remove aliasing concerns for the compiler.
- Implementation is in [main.cpp](main.cpp).

## Performance results (from `output_run_03_mmul_restrict.csv`)

| N | restricted_ikj | simple_ikj |
|---:|---:|---:|
| 8 | 0.8798 | 1.1951 |
| 16 | 3.6797 | 2.9567 |
| 32 | 4.7357 | 4.4185 |
| 64 | 5.6644 | 4.3427 |
| 128 | 6.4459 | 4.5338 |
| 256 | 6.9048 | 4.8496 |
| 512 | 6.8277 | 4.9315 |
| 1024 | 6.6610 | 4.4631 |

## Interpretation

- For medium and large sizes, the `restrict` version is **significantly faster** (about $\sim$1.3×–1.5× here). This indicates the compiler could keep values in registers and better schedule loads/stores when aliasing is ruled out.
- The small-size anomaly at $N=8$ is not meaningful; tiny cases are dominated by loop overhead and measurement noise.
- The arithmetic work is identical in both kernels, so the performance gain comes from improved optimization opportunities enabled by `restrict`.

## Test

- Ran `run_03_mmul_restrict.sh` successfully; results recorded above.