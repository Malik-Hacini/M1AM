"""
TUTORIAL 4: BEZIER CURVES - Interactive Version
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.special import comb


def Bernstein(N, t):

    t = np.asarray(t)
    BNt = np.zeros((N + 1, len(t)))
    
    for i in range(N + 1):
        BNt[i, :] = comb(N, i) * (t ** i) * ((1 - t) ** (N - i))
    
    return BNt


def PlotBezierCurve(Polygon):
    n = Polygon.shape[1] - 1  # degree of the curve
    t = np.linspace(0, 1, 500)
    BNt = Bernstein(n, t)
    Bezier = Polygon @ BNt
    
    plt.plot(Bezier[0, :], Bezier[1, :], 'b-', linewidth=2, label='Bezier curve')
    plt.legend()
    plt.draw()


def AcquisitionPolygone(minmax, color1, color2):
    x = []
    y = []
    coord = 0
    
    print("Click to add control points. Right-click to finish.")
    
    while coord != []:
        coord = plt.ginput(1, mouse_add=1, mouse_stop=3, mouse_pop=2)
        if coord != []:
            plt.draw()
            xx = coord[0][0]
            yy = coord[0][1]
            plt.plot(xx, yy, color1, ms=8)
            x.append(xx)
            y.append(yy)
            if len(x) > 1:
                plt.plot([x[-2], x[-1]], [y[-2], y[-1]], color2)
    
    # Polygon creation
    Polygon = np.zeros((2, len(x)))
    Polygon[0, :] = x
    Polygon[1, :] = y
    return Polygon


if __name__ == "__main__":
    fig2 = plt.figure(figsize=(10, 8))
    ax = fig2.add_subplot(111)
    minmax = 10
    ax.set_xlim((-minmax, minmax))
    ax.set_ylim((-minmax, minmax))
    ax.grid(True, alpha=0.3)
    plt.title("Polygon acquisition and Bezier curve\n(Right-click to finish)")
    
    Poly = AcquisitionPolygone(minmax, 'or', ':r')
    
    if Poly.shape[1] > 0:
        PlotBezierCurve(Poly)
        print(f"Bezier curve created with {Poly.shape[1]} control points")
    
    plt.waitforbuttonpress()
    plt.show()
