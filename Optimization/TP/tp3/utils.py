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


def level_points_plot( f , x_tab , lb, ub ,nb_points, levels , title ):

    def f_no_vector(x1,x2):
	    return f( np.array( [x1,x2] ) )

    x , y = np.meshgrid(np.linspace(lb,ub,nb_points),np.linspace(lb,ub,nb_points))
    z = f_no_vector(x,y)

    fig = plt.figure()
    contour = plt.contour(x,y,z,levels)
    plt.clabel(contour,  fontsize=10)
    plt.title(title)

    plt.xlim([lb,ub])
    plt.ylim([lb,ub])

    for k in range(x_tab.shape[0]):
	    plt.plot(x_tab[k,0],x_tab[k,1],'+k',markersize=10)

    for k in range(x_tab.shape[0]-1):
	    plt.plot([x_tab[k,0], x_tab[k+1,0]],[x_tab[k,1], x_tab[k+1,1]],'-k')
    
    plt.show()






def plot_obj_normGrad(x_tab, f, grad_f, title):


    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
    fig.suptitle(title)

    ax1.semilogy([f(x_tab[k,:]) for k in range(x_tab.shape[0])])
    ax1.set_ylabel(r'$f(x_k)$')

    ax2.semilogy([np.linalg.norm(grad_f(x_tab[k,:])) for k in range(x_tab.shape[0])])
    ax2.set_xlabel(r'$k$')
    ax2.set_ylabel(r'$\| \nabla f(x_k) \|$')

    plt.show()

