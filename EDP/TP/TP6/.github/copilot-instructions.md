# GitHub Copilot Instructions

## Project Overview
This is a C++11 project implementing a 1D Wave/Shallow Water Equation solver using various time-stepping methods (RK1, RK2, RK4). The project focuses on numerical methods for Partial Differential Equations (PDEs).

## Architecture & Core Components
- **Entry Point:** `main.cpp` contains the `Simulation` class which orchestrates the simulation loop, configuration, and data output.
- **Data Management:** `GridData.hpp` manages 1D grid data using raw pointers. It handles memory allocation/deallocation manually.
- **Time Integration:** 
  - `TimeStepperBase.hpp` defines the abstract interface.
  - `TimeStepperRK1.hpp`, `TimeStepperRK2.hpp`, `TimeStepperRK4.hpp` implement Runge-Kutta methods.
  - `df_dt` computes time derivatives using spatial operators.
- **Configuration:** `Config.hpp` handles command-line arguments and simulation parameters (domain size, gravity, time step).
- **Spatial Discretization:** `Operators.hpp` (implied) and `DiscConfig.hpp` handle spatial derivatives and grid configuration.

## Build & Run Workflows
- **Build Release:** `make` (produces `./main` with `-O2`).
- **Build Debug:** `make debug` (produces `./main` with `-O0 -g -DWAVE_DEBUG=1`).
- **Clean:** `make clean`.
- **Run Simulation:** `./main` (uses default parameters).
- **Visualization:** `python3 gen_animation.py` reads generated `output_state_h_*.txt` files and creates an animation.

## Coding Conventions & Patterns
- **Templates:** The codebase uses templates extensively (e.g., `template <typename T>`) to support different floating-point precisions (`float`, `double`).
- **Memory Management:** `GridData` uses manual `new`/`delete`. Be cautious of memory leaks and ensure proper copy semantics if modifying.
- **State Variables:** `std::array<GridData<T>, N>` is used to group simulation variables (e.g., height, velocity).
- **Debug Macros:** Use `#if WAVE_DEBUG` for debug-only logic (checks for memory leaks, bounds checking).

## Key Files
- `src_students/main.cpp`: Main simulation loop and setup.
- `src_students/Config.hpp`: Configuration parameters and argument parsing.
- `src_students/TimeStepperBase.hpp`: Base class for time integration.
- `src_students/GridData.hpp`: Data container implementation.
- `src_students/gen_animation.py`: Python visualization script.

## Common Tasks
- **Adding a new Time Stepper:** Inherit from `TimeStepperBase`, implement `time_integrate`, and instantiate it in `main.cpp` based on `Config`.
- **Modifying Output:** Update `Simulation::data_to_file` in `main.cpp` and ensure `gen_animation.py` can parse the new format.
- **Changing Physics:** Modify `Operators.hpp` or `TimeStepperBase::df_dt` to alter the equations being solved.
