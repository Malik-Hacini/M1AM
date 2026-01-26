#ifndef GRID_DATA_HPP__
#define GRID_DATA_HPP__

#include "DiscConfig.hpp"
#include <fstream>

template <typename T = double>
class GridData
{
public:
	const DiscConfig<T> *discConfig;
	T *data;
	std::size_t size;


	/**
	 * Empty constructor
	 */
	GridData()
	:
		data(nullptr),
		size(0)
	{
	}


	/**
	 * Constructor allocating data according to the configuration
	 */
	GridData(const DiscConfig<T> *i_discConfig)
	:
		discConfig(i_discConfig)
	{
		_alloc(discConfig->num_dofs);
	}


	/**
	 * Copy contructor
	 */
	GridData(const GridData<T> &i_gridData)
	:
		discConfig(i_gridData.discConfig)
	{
		_alloc(discConfig->num_dofs);
		for (std::size_t i = 0; i < size; i++)
			this->data[i] = i_gridData.data[i];
	}

	~GridData()
	{
		_free();
	}

	/**
	 * Setup data storage
	 */
	void setup(const DiscConfig<T> &i_discConfig)
	{
		discConfig = &i_discConfig;
		_alloc(discConfig->num_dofs);
	}

	/**
	 * Setup data storage
	 */
	void setup_like(const GridData<T> &i_grid_data)
	{
		discConfig = i_grid_data.discConfig;
		_alloc(i_grid_data.size);
	}

private:
	void _alloc(std::size_t i_size)
	{
#if WAVE_DEBUG
		if (data != nullptr)
		{
			std::cerr << "Data already allocated, memory leak!" << std::endl;
			exit(-1);
		}
#endif
		size = i_size;
		data = new T[i_size];
	}

	void _free()
	{
		delete [] data;
		data = nullptr;
		size = 0;
	}


public:
	void set_zero()
	{
		for (int i = 0; i < size; i++)
			data[i] = 0;
	}

public:
	/**
	 * Write data to output file
	 * First column is the coordinate.
	 * Second column is the value of the DoF itself.
	 */
	void to_file(
		const std::string &i_output_file
	) const
	{
		std::ofstream f;
		f.open(i_output_file, std::ios::out);

		for (std::size_t i = 0; i < size; i++)
		{
			f << discConfig->dx*i << "\t" << data[i] << std::endl;
		}

		f.close();
	}

	/**
	 * Compute
	 * 	-i_a
	 * and return result
	 */
	GridData<T> operator-() const
	{
		GridData<T> retval(discConfig);

		for (std::size_t i = 0; i < size; i++)
			retval.data[i] = -data[i];

		return retval;
	}

	/**
	 * Compute
	 * 	this+i_b
	 * and return result
	 */
	GridData<T> operator+(const GridData<T> &i_b) const
	{
		GridData<T> retval(discConfig);

		for (std::size_t i = 0; i < size; i++)
			retval.data[i] = data[i] + i_b.data[i];

		return retval;
	}

	/**
	 * Compute
	 * 	this-i_b
	 * and return result
	 */
	GridData<T> operator-(const GridData<T> &i_b) const
	{
		GridData<T> retval(discConfig);

		for (std::size_t i = 0; i < size; i++)
			retval.data[i] = data[i] - i_b.data[i];

		return retval;
	}

	/**
	 * Compute
	 * 	this*i_b
	 * and return result
	 */
	GridData<T> operator*(const GridData<T> &i_b) const
	{
		GridData<T> retval(discConfig);

		for (std::size_t i = 0; i < size; i++)
			retval.data[i] = data[i]*i_b.data[i];

		return retval;
	}

	/**
	 * Copy operator
	 */
	GridData<T>& operator=(const GridData<T> &i_rhs)
	{
		if (data == nullptr)
		{
			// In case that the data was not yet initialized, allocate the data
			setup_like(i_rhs);
		}
#if WAVE_DEBUG
		else if (size != i_rhs.size)
		{
			std::cerr << "Data size mismatch!" << std::endl;
			exit(-1);
		}
#endif
		for (std::size_t i = 0; i < size; i++)
			data[i] = i_rhs.data[i];

		return *this;
	}


	T min()
	{
		T min = data[0];
		for (std::size_t i = 1; i < size; i++)
			min = std::min(min, data[i]);
		return min;
	}


	T max()
	{
		T max = data[0];
		for (std::size_t i = 1; i < size; i++)
			max = std::max(max, data[i]);
		return max;
	}
};



/**
 * Compute
 * 	i_a+i_b
 */
template <typename T>
GridData<T> operator+(const T i_a, const GridData<T> &i_b)
{
	GridData<T> retval(i_b.discConfig);

	for (std::size_t i = 0; i < i_b.size; i++)
		retval.data[i] = i_a+i_b.data[i];

	return retval;
}

/**
 * Compute
 * 	i_a*i_b
 */
template <typename T>
GridData<T> operator*(const T i_a, const GridData<T> &i_b)
{
	GridData<T> retval(i_b.discConfig);

	for (std::size_t i = 0; i < i_b.size; i++)
		retval.data[i] = i_a*i_b.data[i];

	return retval;
}



#endif
