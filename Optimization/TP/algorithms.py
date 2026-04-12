from tp1.algorithms import BFGS
from tp2.algorithms import GD, GD_backtracking, GD_exact
from tp3.algorithms import GD_wolfe, newton, bfgs, newton_wolfe
from tp4.algorithms import GD_accelerated, CG_quadratic, CG_nonLinear
from tp6.algorithms import SGD, adagrad_norm, adagrad_diag, adam
from tp7.algorithms import proj_GD, POCS

__all__ = [
    "BFGS",
    "GD",
    "GD_backtracking",
    "GD_exact",
    "GD_wolfe",
    "newton",
    "bfgs",
    "newton_wolfe",
    "GD_accelerated",
    "CG_quadratic",
    "CG_nonLinear",
    "SGD",
    "adagrad_norm",
    "adagrad_diag",
    "adam",
    "proj_GD",
    "POCS",
]
