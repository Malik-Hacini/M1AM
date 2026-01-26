import os
import subprocess
import numpy as np
import matplotlib.pyplot as plt
import glob

def run_simulation(method, benchmark, output_freq, sim_time=100):
    # Clean up previous output
    for f in glob.glob("output_state_*.txt"):
        os.remove(f)

    cmd = [
        "./main",
        "--num-dofs", "512",
        "--simtime", str(sim_time),
        "--output-freq", str(output_freq),
        "--benchmark-name", benchmark,
        "--timestepping-method", method
    ]
    
    print(f"Running {method} with {benchmark}...")
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def plot_last_frame(title, filename):
    # Find output files
    h_files = sorted(glob.glob("output_state_h_*.txt"))
    if not h_files:
        print(f"No output files found for {filename}")
        return

    # Pick the last file
    last_file = h_files[-1]
    data = np.loadtxt(last_file)
    
    # If data is 2 columns (index, value) or 1 column
    if data.ndim == 2:
        y = data[:, 1]
    else:
        y = data

    x = np.linspace(0, 150000, len(y))

    plt.figure(figsize=(10, 6))
    plt.plot(x, y)
    plt.title(title)
    plt.xlabel("Position (m)")
    plt.ylabel("Height Deviation (m)")
    plt.grid(True)
    plt.savefig(f"../report/{filename}")
    plt.close()
    print(f"Saved {filename}")

def main():
    # RK1 - Unstable
    # Run for a short time to catch the explosion before it becomes NaNs or too huge if possible, 
    # or just show the noise.
    run_simulation("rk1", "gaussian_bump", 10, sim_time=200) 
    plot_last_frame("RK1 (Forward Euler) - Instability", "rk1_instability.png")

    # RK2 - Unstable
    run_simulation("rk2", "gaussian_bump", 10, sim_time=500)
    plot_last_frame("RK2 (Heun) - Instability", "rk2_instability.png")

    # RK4 - Stable
    run_simulation("rk4", "gaussian_bump", 10, sim_time=1000)
    plot_last_frame("RK4 - Stable Propagation", "rk4_stability.png")

if __name__ == "__main__":
    main()
