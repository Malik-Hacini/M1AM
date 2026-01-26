#ifndef DISC_CONFIG_HPP__
#define DISC_CONFIG_HPP__


/**
 * Class which gathers information about the discretization
 *
 * This is shared by other classes, e.g.
 *  - GridData to allocate the data storage for the DoFs
 *  - Operators to be able to compute (differential) operators on DoFs
 */
template <typename T = double>
class DiscConfig
{
public:
	T domain_size;
	int num_dofs;

	T dx;
	T inv_dx;
	T inv_dx2;


	DiscConfig()
	{
		domain_size = -1;
		num_dofs = -1;
	}

	DiscConfig(
		T i_domain_size,
		int i_num_dofs
	)
	{
		setup(i_domain_size, i_num_dofs);
	}


	void setup(
		T i_domain_size,
		int i_num_dofs
	)
	{
		domain_size = i_domain_size;
		num_dofs = i_num_dofs;

		dx = domain_size / num_dofs;
		inv_dx = num_dofs / domain_size;
		inv_dx2 = num_dofs / (domain_size * 2.0);
	}
};


#endif
