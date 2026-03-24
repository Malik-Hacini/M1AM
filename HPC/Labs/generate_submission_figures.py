#! /usr/bin/env python3

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np

import lib.plot_helpers as ph
import lib.plot_config as pc


ROOT = Path(__file__).resolve().parent
FIG_DIR = ROOT / "slides" / "fig"


def save_line_plot(output_name: str, title: str, ticks, series, ylabel: str,
                   xscale: str = "log", yscale: str | None = None):
    fig, ax = pc.setup(scale=2.0, figsize=(4.8, 2.9))
    ps = pc.PlotStyles()

    for label, values in series:
        ax.plot(ticks, values, label=label, **ps.getNextStyle(len(ticks)))

    ax.set_title(title)
    ax.set_xlabel("N")
    ax.set_ylabel(ylabel)
    ax.set_xscale(xscale)
    if yscale is not None:
        ax.set_yscale(yscale)
    ax.grid(True, which="both", alpha=0.3)
    ax.legend()
    fig.tight_layout()
    pc.savefig(str(FIG_DIR / output_name))
    plt.close(fig)


def save_quadrature_figure(output_name: str):
    data = np.genfromtxt(ROOT / "output_run_08_quadrature.csv", delimiter=",", names=True)
    fig, axes = pc.setup(scale=2.15, ncols=2, figsize=(7.2, 2.8))
    time_ax, speedup_ax = axes

    time_ax.plot(data["N"], data["time_serial"], label="serial")
    time_ax.plot(data["N"], data["time_hand_reduce"], label="hand-written reduce")
    time_ax.plot(data["N"], data["time_omp_reduce"], label="OpenMP reduction")
    time_ax.set_title("Quadrature runtime")
    time_ax.set_xlabel("N")
    time_ax.set_ylabel("time [s]")
    time_ax.set_xscale("log")
    time_ax.set_yscale("log")
    time_ax.grid(True, which="both", alpha=0.3)
    time_ax.legend()

    speedup_ax.plot(data["N"], data["speedup_hand_reduce"], label="hand-written reduce")
    speedup_ax.plot(data["N"], data["speedup_omp_reduce"], label="OpenMP reduction")
    speedup_ax.axhline(1.0, color="black", linestyle="--", linewidth=0.8)
    speedup_ax.set_title("Quadrature speedup")
    speedup_ax.set_xlabel("N")
    speedup_ax.set_ylabel("speedup vs serial")
    speedup_ax.set_xscale("log")
    speedup_ax.grid(True, which="both", alpha=0.3)
    speedup_ax.legend()

    fig.tight_layout()
    pc.savefig(str(FIG_DIR / output_name))
    plt.close(fig)


def series_from_file(file_name: str, selected_labels=None):
    ticks, labels, values = ph.load_benchmark_tsv(ROOT / file_name)
    if selected_labels is None:
        selected_labels = labels

    series = []
    for label in selected_labels:
        index = labels.index(label)
        series.append((ph.clean_benchmark_label(label), values[index, :]))
    return ticks, series


def save_openmp_comparison(output_name: str):
    ticks_base, labels_base, values_base = ph.load_benchmark_tsv(ROOT / "output_run_05_mmul_simd.csv")
    ticks_openmp, labels_openmp, values_openmp = ph.load_benchmark_tsv(ROOT / "output_run_06_mmul_openmp.csv")

    series = []
    for label in ["mm_mul_simple_ikj", "mm_mul_blocked_ikj", "mm_mul_simd_ikj"]:
        index = labels_base.index(label)
        series.append((ph.clean_benchmark_label(label), values_base[index, :]))

    openmp_index = labels_openmp.index("mm_mul_simd_openmp_ikj")
    series.append(("OpenMP + blocked + SIMD", values_openmp[openmp_index, :]))

    save_line_plot(output_name, "Threaded MM performance", ticks_base, series, "GFLOP/s")


def main():
    FIG_DIR.mkdir(parents=True, exist_ok=True)

    ticks, series = series_from_file("output_run_01_matrix_norm_novec.csv")
    save_line_plot("lab1_norm.png", "Matrix sum performance", ticks, series, "GFLOP/s")

    ticks, series = series_from_file("output_run_02b_mmul_simple_all.csv")
    save_line_plot("lab1_loops.png", "Loop ordering impact", ticks, series, "GFLOP/s")

    ticks, series = series_from_file("output_run_03_mmul_restrict.csv")
    save_line_plot("lab1_restrict.png", "Effect of restrict", ticks, series, "GFLOP/s")

    ticks, series = series_from_file("output_run_04_mmul_blocked.csv")
    save_line_plot("lab2_blocked.png", "Cache blocking comparison", ticks, series, "GFLOP/s")

    ticks, series = series_from_file(
        "output_run_05_mmul_simd.csv",
        ["mm_mul_simple_ikj", "mm_mul_restricted_ikj", "mm_mul_blocked_ikj", "mm_mul_simd_ikj"],
    )
    save_line_plot("lab2_simd.png", "SIMD vs scalar kernels", ticks, series, "GFLOP/s")

    save_openmp_comparison("lab3_openmp.png")
    save_quadrature_figure("lab3_quadrature.png")


if __name__ == "__main__":
    main()
