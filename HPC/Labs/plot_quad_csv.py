#! /usr/bin/env python3

from pathlib import Path
import sys

import matplotlib.pyplot as plt
import numpy as np

import lib.plot_helpers as ph
import lib.plot_config as pc



def print_usage() -> None:
    print("")
    print("Usage:")
    print("")
    print(f" {sys.argv[0]} [quadrature_output.csv]")
    print("")


def main() -> int:
    if len(sys.argv) < 2:
        print_usage()
        return 1

    csv_path = Path(sys.argv[1])
    data = np.genfromtxt(csv_path, delimiter=",", names=True)

    fig, axes = pc.setup(scale=2.2, ncols=2, figsize=(7.5, 2.8))
    time_ax, speedup_ax = axes

    time_ax.plot(data["N"], data["time_serial"], label="serial")
    time_ax.plot(data["N"], data["time_hand_reduce"], label="hand-written reduce")
    time_ax.plot(data["N"], data["time_omp_reduce"], label="OpenMP reduction")
    time_ax.set_xscale("log")
    time_ax.set_yscale("log")
    time_ax.set_xlabel("N")
    time_ax.set_ylabel("time [s]")
    time_ax.set_title("Quadrature runtime")
    time_ax.grid(True, which="both", alpha=0.3)
    time_ax.legend()

    speedup_ax.plot(data["N"], data["speedup_hand_reduce"], label="hand-written reduce")
    speedup_ax.plot(data["N"], data["speedup_omp_reduce"], label="OpenMP reduction")
    speedup_ax.axhline(1.0, color="black", linestyle="--", linewidth=0.8)
    speedup_ax.set_xscale("log")
    speedup_ax.set_xlabel("N")
    speedup_ax.set_ylabel("speedup vs serial")
    speedup_ax.set_title("Quadrature speedup")
    speedup_ax.grid(True, which="both", alpha=0.3)
    speedup_ax.legend()

    fig.tight_layout()

    output_path = csv_path.with_suffix(".pdf")
    print("Writing output to file: " + str(output_path))
    pc.savefig(str(output_path))
    print("Done")

    ph.maybe_show(plt)
    return 0


if __name__ == "__main__":
    sys.exit(main())
