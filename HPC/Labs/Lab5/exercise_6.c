/*****************************************************
    AUTHOR  : Sébastien Valat
    MAIL    : sebastien.valat@univ-grenoble-alpes.fr
    LICENSE : BSD
    YEAR    : 2021
    COURSE  : Parallel Algorithms and Programming
*****************************************************/

//////////////////////////////////////////////////////
//
// Goal: Implement 2D grid communication with non-blocking
//       messages.
//
// SUMMARY:
//     - 2D splitting along X and Y
//     - 8 neighbors communications
//     - MPI type for non contiguous cells
// NEW:
//     - Non-blocking communications
//
//////////////////////////////////////////////////////

/****************************************************/
#include "src/lbm_struct.h"
#include "src/exercises.h"

/****************************************************/
void lbm_comm_init_ex6(lbm_comm_t * comm, int total_width, int total_height)
{
	//we use the same implementation than ex5
	lbm_comm_init_ex5(comm, total_width, total_height);
}

/****************************************************/
void lbm_comm_release_ex6(lbm_comm_t * comm)
{
	//we use the same implementation than ext 5
	lbm_comm_release_ex5(comm);
}

static int lbm_comm_rank_at(lbm_comm_t * comm, int rank_x, int rank_y)
{
	if (rank_x < 0 || rank_x >= comm->nb_x || rank_y < 0 || rank_y >= comm->nb_y)
		return MPI_PROC_NULL;

	int coords[2] = {rank_x, rank_y};
	int rank;
	MPI_Cart_rank(comm->communicator, coords, &rank);
	return rank;
}

/****************************************************/
void lbm_comm_ghost_exchange_ex6(lbm_comm_t * comm, lbm_mesh_t * mesh)
{
	//
	// 2D communication with :
	//         - non-blocking MPI functions
	//         - use MPI type for non contiguous side 
    //

    int req_count = 0;

    int rank_left = lbm_comm_rank_at(comm, comm->rank_x - 1, comm->rank_y);
    int rank_right = lbm_comm_rank_at(comm, comm->rank_x + 1, comm->rank_y);
    int rank_top = lbm_comm_rank_at(comm, comm->rank_x, comm->rank_y - 1);
    int rank_bottom = lbm_comm_rank_at(comm, comm->rank_x, comm->rank_y + 1);

    // left - right
    double * right_inner = lbm_mesh_get_cell(mesh,comm->width-2,0);
    double * right_ghost = lbm_mesh_get_cell(mesh, comm->width - 1, 0);
    double * left_inner = lbm_mesh_get_cell(mesh,1,0);
    double * left_ghost = lbm_mesh_get_cell(mesh,0, 0);


    if (rank_left != MPI_PROC_NULL) {
        MPI_Isend(left_inner, DIRECTIONS * comm->height, MPI_DOUBLE, rank_left, 1, comm->communicator, &comm->requests[req_count++]);
        MPI_Irecv(left_ghost, DIRECTIONS * comm->height, MPI_DOUBLE, rank_left, 2, comm->communicator, &comm->requests[req_count++]);
    }
    
    if (rank_right != MPI_PROC_NULL) {
        MPI_Isend(right_inner, DIRECTIONS * comm->height, MPI_DOUBLE, rank_right, 2, comm->communicator, &comm->requests[req_count++]);
        MPI_Irecv(right_ghost, DIRECTIONS * comm->height, MPI_DOUBLE, rank_right, 1, comm->communicator, &comm->requests[req_count++]);
    }

    // Wait for the request to finish
    MPI_Waitall(req_count, comm->requests, MPI_STATUSES_IGNORE);
    req_count = 0; 

    // top-bottom
    double * top_inner = lbm_mesh_get_cell(mesh, 0, 1);
    double * top_ghost = lbm_mesh_get_cell(mesh, 0, 0);
    double * bottom_inner = lbm_mesh_get_cell(mesh, 0, comm->height - 2);
    double * bottom_ghost = lbm_mesh_get_cell(mesh, 0, comm->height - 1);

    if (rank_top != MPI_PROC_NULL) {
        MPI_Isend(top_inner, 1, comm->type, rank_top, 3, comm->communicator, &comm->requests[req_count++]);
        MPI_Irecv(top_ghost, 1, comm->type, rank_top, 4, comm->communicator, &comm->requests[req_count++]);
    }

    if (rank_bottom != MPI_PROC_NULL) {
        MPI_Isend(bottom_inner, 1, comm->type, rank_bottom, 4, comm->communicator, &comm->requests[req_count++]);
        MPI_Irecv(bottom_ghost, 1, comm->type, rank_bottom, 3, comm->communicator, &comm->requests[req_count++]);
    }

    // synchronize before continuing computations
    MPI_Waitall(req_count, comm->requests, MPI_STATUSES_IGNORE);
}

