import numpy as np
import matplotlib.pyplot as plt


def plot_levelSets(f, lb, ub, nb_points, title, levels):

    X = np.linspace(lb,ub,nb_points)

    X1, X2 = np.meshgrid(X, X)
    
    def f_no_vector(x1,x2):
	    return f( np.array( [x1,x2] ) )

    Z = f_no_vector(X1,X2)


    fig = plt.figure()
    contour = plt.contour(X1, X2, Z, levels)
    plt.clabel(contour, fontsize=10)
    plt.xlabel(r'$x_1$')
    plt.ylabel(r'$x_2$')
    plt.title(title)
    plt.show()



