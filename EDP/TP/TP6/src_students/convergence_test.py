import os
import subprocess
import numpy as np
import glob
import sys
import matplotlib.pyplot as plt


def run_simulation(num_dofs, sim_time, output_freq, dt):
    """Runs the C++ simulation."""
    cmd = [
        "./main",
        "--num-dofs", str(num_dofs),
        "--simtime", str(sim_time),
        "--output-freq", str(output_freq),
        "--timestepping-method", "rk4",
        "--benchmark-name", "solitary_wave",
        "--dt", str(dt)
    ]
    # Suppress output
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def read_state(filename):
    """Reads the simulation state from a file."""
    try:
        data = np.loadtxt(filename)
        if data.ndim == 1:
            return data[1] # Single point? Unlikely
        return data[:, 1] # Return the values (2nd column)
    except:
        return np.array([])

def compute_error(num_dofs):
    # Physical parameters
    domain_size = 150000.0
    g = 9.81
    h_bar = 5000.0
    c = np.sqrt(g * h_bar)
    period = domain_size / c
    
    # CFL = 0.1 for convergence analysis to dominate spatial error
    cfl = 0.1
    dx = domain_size / num_dofs
    dt = cfl * dx / c

    # Clean previous outputs
    for f in glob.glob("output_state_*.txt"):
        os.remove(f)

    # Run simulation for exactly one period
    run_simulation(num_dofs, period, period * 1.1, dt)

    # Find output files
    h_files = sorted(glob.glob("output_state_h_*.txt"))
    
    if len(h_files) < 2:
        print(f"Error: Not enough output files for N={num_dofs}")
        return None

    h_initial = read_state(h_files[0])
    h_final = read_state(h_files[-1])

    # Compute L2 error normalized by number of points
    error = np.sqrt(np.sum((h_final - h_initial)**2) / num_dofs)
    return error

def main():
    # Compile first
    subprocess.run(["make"], cwd=".", stdout=subprocess.DEVNULL)

    dofs = [64, 128, 256, 512, 1024]
    errors = []

    print("Running convergence test...")
    print(f"{'N':<10} {'L2 Error':<15} {'Order':<10}")
    print("-" * 35)

    for i, n in enumerate(dofs):
        err = compute_error(n)
        errors.append(err)
        
        order = "-"
        if i > 0:
            # Empirical order of convergence: log(E1/E2) / log(N2/N1)
            # Since N2 = 2*N1, log(N2/N1) = log(2)
            order = f"{np.log(errors[i-1]/err) / np.log(dofs[i]/dofs[i-1]):.2f}"
        
        print(f"{n:<10} {err:<15.2e} {order:<10}")

    # Plotting
    plt.figure(figsize=(10, 6))
    plt.loglog(dofs, errors, '-o', label='Simulation Error', linewidth=2)
    
    # Add reference lines for 2nd and 4th order
    ref_2nd = [errors[0] * (dofs[0]/n)**2 for n in dofs]
    ref_4th = [errors[0] * (dofs[0]/n)**4 for n in dofs]
    
    plt.loglog(dofs, ref_2nd, '--', label='2nd Order Reference', alpha=0.5)
    plt.loglog(dofs, ref_4th, ':', label='4th Order Reference', alpha=0.5)

    plt.grid(True, which="both", ls="-", alpha=0.4)
    plt.xlabel('Number of Grid Points (N)')
    plt.ylabel('L2 Error')
    plt.title('Convergence Analysis: Solitary Wave (RK4 + Centered Diff)')
    plt.legend()
    
    output_path = "../report/convergence_plot.png"
    plt.savefig(output_path)
    print(f"\nPlot saved to {output_path}")

if __name__ == "__main__":
    main()
