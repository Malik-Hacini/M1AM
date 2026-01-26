#ifndef TIMESTEPPER_BASE_HPP__
#define TIMESTEPPER_BASE_HPP__

#include "GridData.hpp"
#include "Operators.hpp"



template <typename T_, std::size_t NArraySize_, std::size_t NConstArraySize_>
class TimeStepperBase
{
protected:
	const std::array<GridData<T_>,NConstArraySize_> &const_vars;
	const Config<T_> &config;

public:
	TimeStepperBase(
		const std::array<GridData<T_>,NConstArraySize_> &i_const_vars,
		const Config<T_> &i_config
	)	:
		const_vars(i_const_vars),
		config(i_config)
	{
	}



public:
	/**
	 * General time integration interface to be called by individual time steppers
	 */
	virtual
	void time_integrate(
		std::array<GridData<T_>,NArraySize_> &io_U,	///< simulation state at t_n for input, output is t_n + dt
		Operators<T_> &i_ops,
		T_ i_dt		///< time step size
	) = 0;



public:
	/**
	 * Compute the time derivatives for a given state
	 */
	void df_dt(
		const std::array<GridData<T_>,NArraySize_> &i_U,
		const Operators<T_> &i_ops,
		std::array<GridData<T_>,NArraySize_> &o_U
	)
	{
		T_ g = config.sim_g;
		T_ h_bar = std::abs(config.sim_bavg);

		// h_t = - h_bar * v_x
		o_U[0] = -h_bar * i_ops.diff1(i_U[1]);

		// v_t = - g * h_x
		o_U[1] = -g * i_ops.diff1(i_U[0]);
	}


};

#endif
