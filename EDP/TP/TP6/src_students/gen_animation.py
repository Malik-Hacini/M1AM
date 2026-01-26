#! /usr/bin/env python3

import sys
import glob
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import animation


files = glob.glob("output_state_h_*.txt")
files.sort()


# Get figure handle
fig = plt.figure()
ax = plt.axes()

# Create dummy line
line1, = ax.plot([], [], color="blue", label="h(x): Perturbed surface height")
line2, = ax.plot([], [], color="red", linestyle="--", label="v(x): Velocity")
line3, = ax.plot([], [], color="brown", label="b(x): Bathymetry")


title = ax.set_title("XXX")

ax.set_xlabel("x")
ax.set_ylabel("numerical approximation of h(x), v(h)")
ax.legend(loc='lower left')
fig.tight_layout()


def extend_xlim(x):
    """
    Extend the xlimits to be able to represent all values in x
    """
    min_x = np.min(x)
    max_x = np.max(x)

    min_x -= (max_x-min_x)*0.1
    max_x += (max_x-min_x)*0.1

    ax.set_xlim(min(min_x, ax.get_xlim()[0]), max(max_x, ax.get_xlim()[1]))

def extend_ylim(y):
    """
    Extend the ylimits to be able to represent all values in y
    """
    min_y = np.min(y)
    max_y = np.max(y)


    delta = (max_y-min_y)*0.1
    if delta == 0:
        delta = max(np.max(np.abs(min_y)), np.max(np.abs(max_y)))*0.1

    assert delta >= 0

    min_y -= delta
    max_y += delta

    max_y = max(max_y, ax.get_ylim()[1])
    min_y = min(min_y, ax.get_ylim()[0])

    ax.set_ylim(min_y, max_y)



def load_data(filename, frame):

    data_h = np.genfromtxt(filename, delimiter="\t")
    data_v = np.genfromtxt(filename.replace("state_h", "state_v"), delimiter="\t")
    data_b = np.genfromtxt(filename.replace("state_h", "state_b"), delimiter="\t")

    data_h_mabs = np.max(np.abs(data_h[:,1]))
    data_v_mabs = np.max(np.abs(data_v[:,1]))
    data_b_mabs = np.max(np.abs(data_b[:,1]))

    if data_h_mabs == 0:
        data_h_mabs = 1e-10
    if data_v_mabs == 0:
        data_v_mabs = 1e-10
    if data_b_mabs == 0:
        data_b_mabs = 1e-10

    if 1:
        """
        Render 'h' field
        """
        x = data_h[:,0]
        y = data_h[:,1]

        # Amlify h perturbation field to keep things visible
        y *= data_b_mabs / data_h_mabs * 0.5

        line1.set_data(x, y)

        extend_xlim(x)
        extend_ylim(y)


    if 1:
        """
        Render 'v' field
        """
        x = data_v[:,0]
        y = data_v[:,1]
        y *= data_b_mabs / data_v_mabs * 0.5

        line2.set_data(x, y)

        extend_xlim(x)
        extend_ylim(y)


    if 1:
        """
        Render 'b' field
        """
        x = data_b[:,0]
        y = data_b[:,1]

        line3.set_data(x, y)

        extend_xlim(x)
        extend_ylim(y)

    """
    Update title
    """
    title.set_text(filename.replace("output_state_h_", ""))


# Initialize empty line
def init_func():
    filename = files[0]

    load_data(filename, 0)

    return line1, line2, line3, title,


# Animation function
def animate(i):
    filename = files[i]

    load_data(filename, i)

    return line1, line2, line3, title,



num_frames = len(files)

# Create animation
anim = animation.FuncAnimation(
        fig,
        animate,
        init_func=init_func,
        frames=num_frames,
        interval=int(1000/30),
        blit=False,
        repeat=False
)

plt.show()

