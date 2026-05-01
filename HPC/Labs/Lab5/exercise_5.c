/*****************************************************
    AUTHOR  : Sébastien Valat
    MAIL    : sebastien.valat@univ-grenoble-alpes.fr
    LICENSE : BSD
    YEAR    : 2021
    COURSE  : Parallel Algorithms and Programming
*****************************************************/

//////////////////////////////////////////////////////
//
// Goal: Implement 2D grid communication scheme with
//      8 neighbors using MPI types for non contiguous
//      side.
//
// SUMMARY:
//     - 2D splitting along X and Y
//     - 8 neighbors communications
//     - Blocking communications
// NEW:
//     - >>> MPI type for non contiguous cells <<<
//
//////////////////////////////////////////////////////

/****************************************************/
#include "mpi.h"
#include "src/lbm_struct.h"
#include "src/exercises.h"

/****************************************************/
void lbm_comm_init_ex5(lbm_comm_t * comm, int total_width, int total_height)
{
	//we use the same implementation than ex4 for the 2D splitting
	lbm_comm_init_ex4(comm, total_width, total_height);

	// create MPI vector type for a horizontal row of cells
	// each cell has DIRECTIONS doubles, and the stride from one cell
	// to the next is (mesh->height * DIRECTIONS) doubles
	MPI_Type_vector(comm->width, DIRECTIONS, (comm->height) * DIRECTIONS, MPI_DOUBLE, &comm->type);
	MPI_Type_commit(&comm->type);
}

void lbm_comm_release_ex5(lbm_comm_t * comm)
{
	//we use the same implementation than ex4 for the 2D splitting release
	lbm_comm_release_ex4(comm);

	// release the MPI type we created in init
	MPI_Type_free(&comm->type);
}

static int lbm_comm_rank_at(lbm_comm_t * comm, int rank_x, int rank_y)
{
	int coords[2];
	int rank;

	if (rank_x < 0 || rank_x >= comm->nb_x || rank_y < 0 || rank_y >= comm->nb_y)
        // handles borders and corners
		return MPI_PROC_NULL;

	coords[0] = rank_x;
	coords[1] = rank_y;
	MPI_Cart_rank(comm->communicator, coords, &rank);

	return rank;
}


/****************************************************/
void lbm_comm_ghost_exchange_ex5(lbm_comm_t * comm, lbm_mesh_t * mesh)
{
    // left-right communication
    int rank_left  = lbm_comm_rank_at(comm,comm->rank_x-1,comm->rank_y);
    int rank_right = lbm_comm_rank_at(comm,comm->rank_x+1,comm->rank_y);

    double * right_inner = lbm_mesh_get_cell(mesh,comm->width-2,0);
    double * right_ghost = lbm_mesh_get_cell(mesh, comm->width - 1, 0);
    double * left_inner = lbm_mesh_get_cell(mesh,1,0);
    double * left_ghost = lbm_mesh_get_cell(mesh,0, 0);

    MPI_Send(right_inner, DIRECTIONS * comm->height, MPI_DOUBLE, rank_right, 1, comm->communicator);
    MPI_Recv(left_ghost, DIRECTIONS * comm->height, MPI_DOUBLE, rank_left, 1, comm->communicator, MPI_STATUS_IGNORE);

    MPI_Send(left_inner, DIRECTIONS * comm->height, MPI_DOUBLE, rank_left,  2, comm->communicator);
    MPI_Recv(right_ghost, DIRECTIONS * comm->height, MPI_DOUBLE, rank_right, 2, comm->communicator, MPI_STATUS_IGNORE);

    // top-bottom
    int rank_top = lbm_comm_rank_at(comm, comm->rank_x, comm->rank_y - 1);
    int rank_bottom = lbm_comm_rank_at(comm, comm->rank_x, comm->rank_y + 1);

    double * top_inner = lbm_mesh_get_cell(mesh, 0, 1);
    double * top_ghost = lbm_mesh_get_cell(mesh, 0, 0);
    double * bottom_inner = lbm_mesh_get_cell(mesh, 0, comm->height - 2);
    double * bottom_ghost = lbm_mesh_get_cell(mesh, 0, comm->height - 1);

    MPI_Send(top_inner, 1, comm->type, rank_top, 3, comm->communicator);
    MPI_Recv(bottom_ghost, 1, comm->type, rank_bottom, 3, comm->communicator, MPI_STATUS_IGNORE);

    MPI_Send(bottom_inner, 1, comm->type, rank_bottom, 4, comm->communicator);
    MPI_Recv(top_ghost, 1, comm->type, rank_top, 4, comm->communicator, MPI_STATUS_IGNORE);
}
