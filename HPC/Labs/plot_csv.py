#! /usr/bin/env python3

from pathlib import Path
import sys

import matplotlib.pyplot as plt

import lib.plot_helpers as ph
import lib.plot_config as pc


def print_usage() -> None:
    print("")
    print("Usage:")
    print("")
    print(f" {sys.argv[0]} [output_file.csv] [more_output_files.csv ...]")
    print("")


def main() -> int:
    if len(sys.argv) < 2:
        print_usage()
        return 1

    csv_paths = [Path(arg) for arg in sys.argv[1:]]
    fig, ax = pc.setup(scale=1.5)
    ps = pc.PlotStyles()
    use_group_prefix = len(csv_paths) > 1

    ax.set_title(", ".join(path.name for path in csv_paths))
    ax.set_xlabel("N")
    ax.set_ylabel("GFLOP/s")
    ax.set_xscale("log")
    ax.grid(True, which="both", alpha=0.3)

    for csv_path in csv_paths:
        ticks, labels, data = ph.load_benchmark_tsv(csv_path)
        group_prefix = ph.benchmark_group_label(csv_path)

        for label, values in zip(labels, data):
            pretty_label = ph.clean_benchmark_label(label)
            if use_group_prefix:
                pretty_label = f"{group_prefix} {pretty_label}"

            ax.plot(ticks, values, label=pretty_label, **ps.getNextStyle(len(ticks)))

    ax.legend()
    fig.tight_layout()

    output_path = csv_paths[0].with_suffix(".pdf")
    print("Writing output to file: " + str(output_path))
    pc.savefig(str(output_path))
    print("Done")

    ph.maybe_show(plt)
    return 0


if __name__ == "__main__":
    sys.exit(main())
