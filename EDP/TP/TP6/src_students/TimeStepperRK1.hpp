#ifndef TIMESTEPPER_RK1_HPP__
#define TIMESTEPPER_RK1_HPP__


#include "TimeStepperBase.hpp"

template <typename T_, std::size_t NArraySize_, std::size_t NConstArraySize_>
class TimeStepperRK1:
	public TimeStepperBase<T_, NArraySize_, NConstArraySize_>
{
	const Config<T_> &config;

public:
	TimeStepperRK1(
		const std::array<GridData<T_>,NConstArraySize_> &i_const_vars,
		const Config<T_> &i_config
	)	:
		TimeStepperBase<T_, NArraySize_, NConstArraySize_>(i_const_vars, i_config),
		config(i_config)
	{
	}


	/**
	 * Forward Euler
	 */
	void time_integrate(
		std::array<GridData<T_>,NArraySize_> &io_U,	///< simulation state at t_n for input, output is t_n + dt
		Operators<T_> &i_ops,
		T_ i_dt		///< time step size
	)
	{
		// Storage for first stage
		std::array<GridData<T_>,NArraySize_> k1;

		for (int i = 0; i < NArraySize_; i++)
			k1[i].setup_like(io_U[i]);

		// Compute tendencies k1 = df/dt(U)
		this->df_dt(io_U, i_ops, k1);

		// Update U = U + dt * k1
		for (int i = 0; i < NArraySize_; i++)
			io_U[i] = io_U[i] + i_dt * k1[i];
	}
};

#endif
