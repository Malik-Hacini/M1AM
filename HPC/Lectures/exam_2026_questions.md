# HPC Exam 2026 - Reconstructed Questions

Source: `Lectures/exam_2026.jpg`, manually OCR'd from handwritten notes. The wording is reformatted to match the style of `Lectures/exam_hpc.pdf`. Items marked `[unclear]` contain details that were not fully visible or readable in the photo.

Note: a later re-check of the photo showed that the MPI gather/reduce question is numbered 6 in the handwritten list, while the shared-memory questions start at 7. The numbering below follows the photo, even where that makes the topic order non-contiguous.

## Part I

Basics of computer architectures and performance

1) Cache locality and memory access order (points unknown)

Given a C/C++ two-dimensional array, compare the following two loop nests:

```cpp
for (int i = 0; i < N; i++)
    for (int j = 0; j < M; j++)
        sum += A[i][j];
```

versus

```cpp
for (int j = 0; j < M; j++)
    for (int i = 0; i < N; i++)
        sum += A[i][j];
```

Which version is expected to perform better? Briefly justify your answer with respect to memory layout and cache locality.

2) CPI (points unknown)

Describe what CPI means and explain its relation to program performance.

3) Roofline model (points unknown)

Describe the roofline model. Which main quantities of an algorithm and machine are taken into account by the roofline model?

4) L1 cache size (points unknown)

What is the typical size range of the L1 cache on current architectures?

5) SIMD (points unknown)

Which statement about SIMD is true? `[unclear: multiple-choice options were not visible in the handwritten notes]`

## Part II

Shared-memory parallelization

7) Maximum parallelism of a computation (points unknown)

Given a computation or dependency graph, determine the maximum amount of parallelism. `[unclear: the actual graph/code was not visible in the handwritten notes]`

8) OpenMP critical and barrier (points unknown)

Describe the purpose of `#pragma omp critical` and `#pragma omp barrier`. Explain the difference between the two constructs.

10) OpenMP reduction output (points unknown)

Given an OpenMP program using a `reduction` clause, determine the output of the program. `[unclear: the actual program was not visible in the handwritten notes]`

11) OpenMP firstprivate output (points unknown)

Given an OpenMP program using a `firstprivate` clause, determine the output of the program. `[unclear: the actual program was not visible in the handwritten notes]`

12) NUMA and OpenMP tasking (points unknown)

Answer the question about NUMA and/or define OpenMP tasking. `[unclear: the handwritten note reads approximately "Q NUMA | Q OMP tasking def"]`

## Part III

Distributed-memory parallelization

6) MPI reduction with gather (points unknown)

Can an MPI sum reduction be implemented using `MPI_Gather` followed by a local sum on the root process? Is this efficient compared to using `MPI_Reduce`? Briefly justify your answer.

13) Blocking and non-blocking communication (points unknown)

Explain the difference between blocking and non-blocking communication in MPI.

14) MPI data types (points unknown)

Why do we use MPI data types when communicating data, rather than sending only an untyped chunk of bytes?

15) MPI deadlock (points unknown)

Explain an example of an MPI deadlock from the lab exercises and describe a correct solution.

## Part IV

Performance modeling and scalability

16) Unit of speedup (points unknown)

What is the unit of speedup?

17) Strong and weak scaling (points unknown)

Explain the difference between strong scaling and weak scaling.

18) Network topology metrics (points unknown)

For a given mesh/network configuration, determine or describe the following metrics: diameter, maximum degree, and bisection width. `[unclear: the exact topology/configuration was not visible in the handwritten notes]`

19) Maximum speedup (points unknown)

Compute the maximum achievable speedup. `[unclear: the serial/parallel fraction or formula data were not visible in the handwritten notes]`

20) Number of cores for target speedup (points unknown)

Determine the number of cores required to reach 50% of the maximum speedup. `[unclear: the exact parameters were not visible in the handwritten notes]`
