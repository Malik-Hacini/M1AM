/*
 * C++ lab 6
 *
 * (c) by University of Grenoble Alpes
 *
 * Template code
 */

#include <iostream>
#include <string>
#include <cmath>
#include <vector>
#include <array>
#include "Config.hpp"
#include "GridData.hpp"
#include "Operators.hpp"

#include "TimeStepperBase.hpp"
#include "TimeStepperRK1.hpp"
#include "TimeStepperRK2.hpp"
#include "TimeStepperRK4.hpp"


// Define T type
typedef float T;

class Simulation
{
	// General configuration (domain size, time step size, etc.)
	Config<T> config;
	
	// Configuration related to spatial discretization
	DiscConfig<T> discConfig;
	
	// Operators for computing RHS of PDE
	Operators<T> ops;
	
	// We pack all simulation variables into one array
	std::array<GridData<T>,2> state_vars;

	// Distance from average surface (sea surface level) to bottom
	std::array<GridData<T>,1> const_vars;
	
	// Current simulation time
	T simtime = 0;

	// Handler to time stepper
	TimeStepperBase<T,2,1> *timestepper;


public:
	Simulation()	:
		timestepper(0)
	{
	}

	~Simulation()
	{
		delete timestepper;
	}


	/**
	 * Write data to output file
	 */
	void data_to_file(
		const GridData<T> &i_data_vector,
		const std::string &filename,
		double timestamp
	)
	{
		char buffer[filename.length()+100];
		sprintf(buffer, filename.c_str(), timestamp);

		std::cout << "Writing to " << buffer << std::endl;
		i_data_vector.to_file(buffer);
	}

		
	/**
	 * Setup the program arguments
	 */
	void arg_setup(int argc, char **argv)
	{
		config.setup(argc, argv);
	}


	void setup()
	{
		// First, we estimate a time step size limitation
		if (config.sim_dt <= 0)
			config.sim_dt = config.domain_size/config.num_dofs / std::sqrt(std::abs(config.sim_g*config.sim_bavg));

		config.print();

		// setup configuration about spatial discretization
		discConfig.setup(config.domain_size, config.num_dofs);
		ops.setup(discConfig);

		// compute timestep size
		double dt = config.domain_size / config.num_dofs;

		// We pack all simulation variables into one array
		state_vars[0].setup(discConfig);
		state_vars[1].setup(discConfig);

		const_vars[0].setup(discConfig);


		/*
		 * Initial condition
		 */
		GridData<T> &h = state_vars[0];
		GridData<T> &v = state_vars[1];
		GridData<T> &b = const_vars[0];

		if (config.benchmark_name == "gaussian_bump")
		{
			for (int i = 0; i < discConfig.num_dofs; i++)
			{
				{
					/*
					 * Setup relative surface height
					 */
					double x = i*discConfig.dx;
					double y = (x - discConfig.domain_size*1.0/2.0)/discConfig.domain_size;
					h.data[i] = std::exp(-300*(y*y));
				}

				{
					/*
					 * Setup velocity
					 */
					v.data[i] = 0;
				}

				{
					/*
					 * Setup bathymetry
					 */
					b.data[i] = config.sim_bavg;
				}
			}
		}
		else if (config.benchmark_name == "solitary_wave")
		{
			for (int i = 0; i < discConfig.num_dofs; i++)
			{
				{
					/*
					 * Setup relative surface height
					 */
					double x = i*discConfig.dx;
					double y = (x - discConfig.domain_size*1.0/2.0)/discConfig.domain_size;
					h.data[i] = std::exp(-300*(y*y));
				}

				{
					/*
					 * Setup velocity
					 * v = sqrt(g/h_bar) * h
					 */
					double g = config.sim_g;
					double h_bar = std::abs(config.sim_bavg);
					v.data[i] = std::sqrt(g/h_bar) * h.data[i];
				}

				{
					/*
					 * Setup bathymetry
					 */
					b.data[i] = config.sim_bavg;
				}
			}
		}
		else if (config.benchmark_name == "solitary_wave_bathymetry")
		{
			/**
			 * TODO
			 */
			std::cout << "TODO" << std::endl;
		}
		else
		{
			std::cout << "Benchmark '" << config.benchmark_name << "' not found" << std::endl;
			exit(1);
		}

		if (config.timestepping_method == "rk1")
		{
			timestepper = new TimeStepperRK1<T, 2, 1>(const_vars, config);
		}
		else if (config.timestepping_method == "rk2")
		{
			timestepper = new TimeStepperRK2<T, 2, 1>(const_vars, config);
		}
		else if (config.timestepping_method == "rk4")
		{
			timestepper = new TimeStepperRK4<T, 2, 1>(const_vars, config);
		}
		else
		{
			std::cout << "Unknown time stepping method '" << config.timestepping_method << "'" << std::endl;
			exit(1);
		}
	}


	void run()
	{
		simtime = 0;

		// total number of time steps
		int num_timesteps = std::round(config.sim_total_time/config.sim_dt);

		state_vars_to_file();

		int output_every_nth_timestep = std::round(config.output_every_simtime/config.sim_dt);
		output_every_nth_timestep = std::max(output_every_nth_timestep, 1);

		for (int i = 0; i < num_timesteps; i++)
		{ 
			std::cout << "Running timestep " << i << " at simulation time " << simtime << std::endl;

			timestepper->time_integrate(state_vars, ops, config.sim_dt);
			simtime = config.sim_dt*(i+1);

			if (i % output_every_nth_timestep == 0)
			{
				state_vars_to_file();
				output_diagnostics();
			}
		}

		state_vars_to_file();
	}

	void output_diagnostics()
	{
		std::cout << " + h min/max: " << state_vars[0].min() << ", " << state_vars[0].max() << std::endl;
		std::cout << " + v min/max: " << state_vars[1].min() << ", " << state_vars[1].max() << std::endl;
		std::cout << " + b min/max: " << const_vars[0].min() << ", " << const_vars[0].max() << std::endl;
	}


	void state_vars_to_file()
	{
		data_to_file(state_vars[0], "output_state_h_%012.4f.txt", simtime);
		data_to_file(state_vars[1], "output_state_v_%012.4f.txt", simtime);
		data_to_file(const_vars[0], "output_state_b_%012.4f.txt", simtime);
	}
};


int main(int argc, char *argv[])
{
	Simulation sim;

	sim.arg_setup(argc, argv);

	sim.setup();

	sim.run();

	return 0;
}

