#ifndef TIMESTEPPER_RK4_HPP__
#define TIMESTEPPER_RK4_HPP__


#include "TimeStepperBase.hpp"

template <typename T_, std::size_t NArraySize_, std::size_t NConstArraySize_>
class TimeStepperRK4:
	public TimeStepperBase<T_, NArraySize_, NConstArraySize_>
{
	const Config<T_> &config;

public:
	TimeStepperRK4(
		const std::array<GridData<T_>,NConstArraySize_> &i_const_vars,
		const Config<T_> &i_config
	)	:
		TimeStepperBase<T_, NArraySize_, NConstArraySize_>(i_const_vars, i_config),
		config(i_config)
	{
	}


	/**
	 * RK4 time integrator which updates 
	 */
	void time_integrate(
		std::array<GridData<T_>,NArraySize_> &io_U,	///< simulation state at t_n for input, output is t_n + dt
		Operators<T_> &i_ops,
		T_ i_dt		///< time step size
	)
	{
		std::array<GridData<T_>,NArraySize_> k1, k2, k3, k4, tmp;

		// setup GridData which we might use for the different stages of the PDE solver
		for (int i = 0; i < NArraySize_; i++)
		{
			k1[i].setup_like(io_U[i]);
			k2[i].setup_like(io_U[i]);
			k3[i].setup_like(io_U[i]);
			k4[i].setup_like(io_U[i]);
			tmp[i].setup_like(io_U[i]);
		}

		// k1 = f(U)
		this->df_dt(io_U, i_ops, k1);

		// tmp = U + 0.5 * dt * k1
		for (int i = 0; i < NArraySize_; i++)
			tmp[i] = io_U[i] + (T_)(0.5 * i_dt) * k1[i];

		// k2 = f(tmp)
		this->df_dt(tmp, i_ops, k2);

		// tmp = U + 0.5 * dt * k2
		for (int i = 0; i < NArraySize_; i++)
			tmp[i] = io_U[i] + (T_)(0.5 * i_dt) * k2[i];

		// k3 = f(tmp)
		this->df_dt(tmp, i_ops, k3);

		// tmp = U + dt * k3
		for (int i = 0; i < NArraySize_; i++)
			tmp[i] = io_U[i] + i_dt * k3[i];

		// k4 = f(tmp)
		this->df_dt(tmp, i_ops, k4);

		// U = U + dt/6 * (k1 + 2*k2 + 2*k3 + k4)
		for (int i = 0; i < NArraySize_; i++)
			io_U[i] = io_U[i] + (T_)(i_dt / 6.0) * (k1[i] + (T_)2.0 * k2[i] + (T_)2.0 * k3[i] + k4[i]);
	}
};

#endif
