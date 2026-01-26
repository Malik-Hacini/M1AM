#ifndef CONFIG_HPP__
#define CONFIG_HPP__

#include <stdlib.h>
#include <getopt.h>
#include <string>


template <typename T = double>
class Config
{
public:
	// Domain size in meter
	T domain_size = 150000;

	// Number of DoFs ($\approx$ number of grid points)
	//int num_dofs = 1024;
	int num_dofs = 512;

	// Gravity (actually "Gravitational accelleration")
	T sim_g = 9.81;

	// Average distance to bathymetry
	T sim_bavg = -5000;

	// Timestep size
	T sim_dt = -1;

	// Simulation time in seconds
	T sim_total_time = 60*10;

	// timestepping method
	std::string timestepping_method = "rk1";

	// output simulation data every specified simulation time
	int output_every_simtime = 10;

	// benchmark
	std::string benchmark_name = "gaussian_bump";

	// Use nonlinear equation
	bool nonlinear_equation = true;

	// program argument information
	int argc;
       	char * const *argv;

	Config()
	{
	}


	void print_help()
	{
		std::cout << std::endl;
		std::cout << "Usage: " << argv[0] << " [program parameters]" << std::endl;
		std::cout << std::endl;
		std::cout << "	--domain-size [float]" << std::endl;
		std::cout << "	--num-dofs [int]" << std::endl;
		std::cout << "	--gravity [float]" << std::endl;
		std::cout << "	--bavg [float]" << std::endl;
		std::cout << "	--dt [float]" << std::endl;
		std::cout << "	--timestepping-method [rk1/rk2/rk4]" << std::endl;
		std::cout << "	--simtime [float]" << std::endl;
		std::cout << "	--output-freq [float]" << std::endl;
		std::cout << "	--benchmark-name [string]" << std::endl;
		std::cout << "	--nonlinear-equation [int]" << std::endl;
		std::cout << "	--help" << std::endl;
		std::cout << std::endl;
	}

	/**
	 * Setup the options based on the command line parameters
	 */
	void setup(int i_argc, char * const i_argv[])
	{
		argc = i_argc;
		argv = i_argv;

		int c;
		while (1)
		{
			int option_index = 0;
			static struct option long_options[] = {
				{"domain-size",	required_argument, 0, 0},
				{"num-dofs",	required_argument, 0, 0},
				{"gravity",	required_argument, 0, 0},
				{"bavg",	required_argument, 0, 0},
				{"dt",		required_argument, 0, 0},
				{"simtime",	required_argument, 0, 0},
				{"output-freq",	required_argument, 0, 0},
				{"benchmark-name",	required_argument, 0, 0},
				{"nonlinear-equation",	required_argument, 0, 0},
				{"timestepping-method",	required_argument, 0, 0},
				{"help",	no_argument, 0, 0},
				{0,		0, 0, 0}
			};

			c = getopt_long(argc, argv, "o:h", long_options, &option_index);
			if (c == -1)
				break;

			switch (c)
			{
			case 0:
				{
					std::string optstr(long_options[option_index].name);

					if (optstr == "domain-size")
						domain_size = atof(optarg);
					else if (optstr == "num-dofs")
						num_dofs = atoi(optarg);
					else if (optstr == "gravity")
						sim_g = atof(optarg);
					else if (optstr == "bavg")
						sim_bavg = atof(optarg);
					else if (optstr == "dt")
						sim_dt = atof(optarg);
					else if (optstr == "simtime")
						sim_total_time = atof(optarg);
					else if (optstr == "output-freq")
						output_every_simtime = atof(optarg);
					else if (optstr == "benchmark-name")
						benchmark_name = optarg;
					else if (optstr == "nonlinear-equation")
						nonlinear_equation = atoi(optarg);
					else if (optstr == "timestepping-method")
						timestepping_method = optarg;
					else if (optstr == "help")
					{
						print_help();
						exit(0);
					}
					else
					{
						std::cout << "INTERNAL ERROR: " << optstr << std::endl;
						exit(-1);
					}

				}
				break;

			case 'o':
				output_every_simtime = atof(optarg);
				break;

			case 'h':
				{
					print_help();
					exit(0);
				}
				break;

			default:
				printf("?? getopt returned character code 0%o ??\n", c);
				exit(1);
			}
		}

		if (optind < i_argc) {
			printf("non-option ARGV-elements: ");
			while (optind < i_argc)
				printf("%s ", i_argv[optind++]);
			printf("\n");
		}

	}


	void print()
	{
		std::cout << " + domain_size: " << domain_size << std::endl;
		std::cout << " + num_dofs: " << num_dofs << std::endl;
		std::cout << " + sim_g: " << sim_g << std::endl;
		std::cout << " + sim_bavg: " << sim_bavg << std::endl;
		std::cout << " + sim_dt: " << sim_dt << std::endl;
		std::cout << " + sim_total_time: " << sim_total_time << std::endl;
		std::cout << " + timestepping_method: " << timestepping_method << std::endl;
		std::cout << " + benchmark_name: " << benchmark_name << std::endl;
		std::cout << " + nonlinear_equation: " << nonlinear_equation << std::endl;
	}
};

#endif
