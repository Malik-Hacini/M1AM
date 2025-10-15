#! /usr/bin/env python3

import sys
import numpy as np
import matplotlib.pyplot as plt


def get_fd_stencil_weights(
        diff_order : int,
        x_points : np.ndarray,
        x_eval : float = 0,
):
    """
    This function returns the stencil weights for evaluating a particular finite difference on one point

    This follows
    "Generation of Finite Difference Formulas on Arbitrarily Spaced Grids"
    by Bengt Fornberg

    Parameters:
    =======================
    
        diff_order:
            Order of derivative
            
        x_points:
            Grid points to use to evaluate the derivative on.
            The returned weights will be related to these grid points.
            
        x_eval:
            Point to approximate the derivative on.
            This is typically a point in x_points, but can be also used for interpolation (special case of diff_order=0).        
    """
    
    M = diff_order
    N = len(x_points)-1

    delta = np.zeros((M+1, N+1, N+1))
    
    delta[0,0,0] = 1
    c1 = 1
    
    for n in range(1, N+1):
        c2 = 1
        for v in range(0, n):
            c3 = x_points[n] - x_points[v]
            c2 = c2*c3
            
            for m in range(0, min(n, M)+1):
                delta[m,n,v] = ((x_points[n]-x_eval)*delta[m,n-1,v] - m*delta[m-1,n-1,v])/c3
        
        for m in range(0, min(n,M)+1):
            delta[m,n,n] = c1/c2 * (m*delta[m-1,n-1,n-1] - (x_points[n-1] - x_eval) * delta[m,n-1,n-1])
        
        c1 = c2
    
    stencil = delta[M,N,:]
    
    if 1:
        stencil[np.abs(stencil) < np.max(np.abs(stencil))*1e-14] = 0

    return delta[M,N,:] 
            
            



def apply_stencil(stencil_relative_arr_idx, stencil_weights, y):
    """
    Perform convolution of stencil on nodal points.
    
    Note, that we include periodicity here.

    Parameters:
        stencil_relative_arr_idx: Stencil evaluation points given by relative array indices for 'y'.
                   These are integer numbers for array indices relative to
                   the current point on which the stencil values should be evaluated on.
        stencil_weights: Stencil weights associated to the points in stencil_relative_arr_idx
        y: Array of discrete values. Bascially evaluations of the function f(x) at the grid points.
    """

    N = len(y)
    retval = np.zeros_like(y)

    assert len(stencil_relative_arr_idx) < len(y)
    #############################################
    # Exercise b: START
    #############################################

    #############################################
    # Exercise b: END
    #############################################
    return retval



def lmax(a1, a2):
    """
    Return the L_\infty error
    """
    #############################################
    # Exercise d: START
    #############################################
    
    #############################################
    # Exercise d: START
    #############################################



"""
Simple function with a=2*\pi
  f(x) = Re(exp(i*a*x))
and its derivative
  f^(p) = Re( (i*a)^p exp(i*a*x) )
"""
def f(x, p=0):
    a = 2*np.pi
    return np.real(np.exp(1j*a*x)*(1j*a)**p)


"""
Domain size
"""
domain_size = 2
print(f"domain size: {domain_size}")

"""
Different resolutions (number of grid points)
"""

if 1:
    # Use this to generate resolutions for all standard test runs
    N_2_start = 3
    N_2_end = 14
else:
    # Use this for debugging
    N_2_start = 10
    N_2_end = 11

N_ = np.array([2**i for i in range(N_2_start, N_2_end)])
print(f"resolutions: {N_}")

"""
Corresponding node distances.
"""
h_ = domain_size/N_
print(f"cell sizes: {h_}")


"""
Next, we set up different run configurations with a dictionary

USAGE:
Use "if 1" to activate the test and "if 0" to deactivate including the test.
In this way, you can step-by-step run the different configurations for debugging.
"""
test_config_ = []

if 1:
    test_config_ += [{
                'stencil_relative_arr_idx': [-1, 1], 	# stencil coordinates
                'p':    1,          	# order of derivative to setup stencil weights
                'order':    2,      	# expected approximation order
            }]

if 1:
    test_config_ += [{
                'stencil_relative_arr_idx': [-2, -1, 1, 2],
                'p':    1,
                'order':    4,
            }]

if 1:
    test_config_ += [{
                'stencil_relative_arr_idx': [-1, 0, 1],
                'p':    2,
                'order':    2,
            }]

if 1:
    test_config_ += [{
                'stencil_relative_arr_idx': [-2, -1, 0, 1, 2],
                'p':    2,
                'order':    4,
            }]



"""
Accumulator of errors to plot them later on.
"""
errors = np.zeros((len(test_config_), len(h_)))

"""
Iterate over all different test cases
"""
for rci in range(len(test_config_)):
    test_config = test_config_[rci]
    print("*"*80)
    print(f"test_config: {test_config}")
    print("*"*80)

    # Make dict values easier to access
    stencil_relative_arr_idx = test_config['stencil_relative_arr_idx']
    p = test_config['p']
    order = test_config['order']


    prev_error = None
    """
    We like to investigate later on the behavior of the error for higher and higher resolutions.
    Therefore, we iterate over different resolutions here.
    """
    for Ni in range(len(N_)):

        # resolution (number of grid points)
        N = N_[Ni]
        h = h_[Ni]

        print(f" + N: {N}")
        print(f" + h: {h}")

        # Compute nodal points
        x = np.linspace(0, domain_size, N, endpoint=False)

        # Evaluate function on nodal points
        y = f(x)

        #############################################
        # Exercise a: START
        #############################################

        """
        Generate finite difference stencils
        """

        #############################################
        # Exercise a: END
        #############################################

        print(f" + stencil relative array indices: {stencil_relative_arr_idx}")
        print(f" + stencil weights: {stencil_weights}")


        """
        Compute approximation and error
        """

        # Compute numerical approximation
        y_deriv_num = apply_stencil(stencil_relative_arr_idx, stencil_weights, y)

        # Compute exact derivative
        y_deriv_exact = f(x, p)


        if 0:
            plt.close()
            fig, ax = plt.subplots(1, 1, figsize=(4,3))

            #############################################
            # Exercise c: START
            #############################################


            #############################################
            # Exercise c: END
            #############################################

            fig.tight_layout()
            plt.show()
            #sys.exit(1)


        # Compute error
        error = lmax(y_deriv_num, y_deriv_exact)
        print(f" + error: {error}")

        errors[rci, Ni] = error

        """
        Print more information on convergence and the order
        """
        if prev_error is not None:
            conv = prev_error / error
            conv_order = np.log(conv)/np.log(2)
            print(f" + measured convergence: {conv}")
            print(f" + measured convergence order: {conv_order}")

        prev_error = error

        print("")



if 1:
    """
    Plotting of results
    """

    #############################################
    # Exercise f, g: START
    #############################################


    #############################################
    # Exercise f, g: END
    #############################################


