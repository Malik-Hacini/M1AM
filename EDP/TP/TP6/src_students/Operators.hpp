#ifndef OPERATORS_HPP__
#define OPERATORS_HPP__

#include "DiscConfig.hpp"
#include "GridData.hpp"



template <typename T = double>
class Operators
{
public:
	const DiscConfig<T> *discConfig;

	/*
	 * Default constructor doing nothing
	 */
	Operators()	:
		discConfig(nullptr)
	{
	}

	/*
	 * Setup constructor
	 */
	Operators(const DiscConfig<T> &i_discConfig)
	{
		setup(i_discConfig);
	}

	void setup(const DiscConfig<T> &i_discConfig)
	{
		discConfig = &i_discConfig;
	}


	/*
	 * Approximate
	 *  * first derivative with
	 *  * second order centered finite difference 
	 */
	GridData<T> diff1(const GridData<T> &i_d) const
	{
		GridData<T> o;
		o.setup_like(i_d);

		T inv_dx2 = discConfig->inv_dx2;
		int N = i_d.size;

		for (int i = 0; i < N; i++)
		{
			int im1 = (i == 0) ? N - 1 : i - 1;
			int ip1 = (i == N - 1) ? 0 : i + 1;

			o.data[i] = (i_d.data[ip1] - i_d.data[im1]) * inv_dx2;
		}

		return o;
	}
};

#endif
