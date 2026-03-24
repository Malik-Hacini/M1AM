#! /usr/bin/env python3

from pathlib import Path

import numpy as np


EXPLICIT_BENCHMARK_LABELS = {
    "matrix_sum_rowwise": "row-wise",
    "matrix_sum_colwise": "column-wise",
    "mm_mul_simple_ijk": "ijk",
    "mm_mul_simple_jik": "jik",
    "mm_mul_simple_ikj": "ikj",
    "mm_mul_simple_jki": "jki",
    "mm_mul_simple_kij": "kij",
    "mm_mul_simple_kji": "kji",
    "mm_mul_restricted_ikj": "restrict ikj",
    "mm_mul_var_blocked_ikj": "variable blocked",
    "mm_mul_blocked_ikj": "blocked",
    "mm_mul_simd_ikj": "simd ikj",
    "mm_mul_simd_openmp_ikj": "OpenMP + SIMD",
}


def load_benchmark_tsv(path: Path):
    raw = np.genfromtxt(path, delimiter="\t", dtype=str)
    ticks = np.array(raw[0, 1:], dtype=float)
    labels = list(raw[1:, 0])
    values = np.array(raw[1:, 1:], dtype=float)
    return ticks, labels, values


def clean_benchmark_label(label: str) -> str:
    if label in EXPLICIT_BENCHMARK_LABELS:
        return EXPLICIT_BENCHMARK_LABELS[label]

    label = label.replace("mm_mul_", "")
    label = label.replace("matrix_sum_", "")
    label = label.replace("matrix_matrix_mul_", "")
    label = label.replace("var_blocked", "variable blocked")
    label = label.replace("restricted", "restrict")
    label = label.replace("rowwise", "row-wise")
    label = label.replace("colwise", "column-wise")
    return label.replace("_", " ")


def benchmark_group_label(path: Path) -> str:
    label = path.stem
    label = label.replace("output_run_", "")
    label = label.replace("mmul_", "")
    label = label.replace("_", " ")
    return label


def maybe_show(plt_module) -> None:
    if plt_module.get_backend().lower() != "agg":
        plt_module.show()
