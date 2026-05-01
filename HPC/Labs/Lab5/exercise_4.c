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
//       8 neighbors using manual copy for non
//       contiguous side and blocking communications
//
// SUMMARY:
//     - 2D splitting along X and Y
//     - 8 neighbors communications
//     - Blocking communications
//     - Manual copy for non continguous cells
//
//////////////////////////////////////////////////////

/****************************************************/
#include "mpi.h"
#include "src/lbm_config.h"
#include "src/lbm_struct.h"
#include "src/exercises.h"
#include <stdio.h>
#include <stdlib.h>

/****************************************************/

static void lbm_choose_2d_split(int comm_size, int total_width, int total_height, int dims[2])
{
    // compute the best 2d split
    // i.e. find nb_x, nb_y st nb_x*nb_y=comm_size; total_width%nb_x=0; total_length%nb_y=0 such that the local dimensions are as square as possible : min(|nb_x-nb_y|)
    //

	int best_x = 0;
	int best_y = 0;
	int best_score = 0;
	int nb_x;

    // iterate over all the possibilities
	for (nb_x = 1 ; nb_x <= comm_size ; nb_x++) {
		int nb_y;

		if (comm_size % nb_x != 0) // comm size needs to be a multiple of nb_x
			continue;

		nb_y = comm_size / nb_x;
		if (total_width % nb_x != 0 || total_height % nb_y != 0)// nb_x and nby have to divide the width and height
			continue;

		// square proportions are better
		int local_width = total_width / nb_x;
		int local_height = total_height / nb_y;
		int score = abs(local_width - local_height);

		if (best_x == 0 || score < best_score) {
			best_x = nb_x;
			best_y = nb_y;
			best_score = score;
		}
	}

    // no viable solution found
	if (best_x == 0){abort();}
        
	dims[0] = best_x;
	dims[1] = best_y;
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

void lbm_comm_init_ex4(lbm_comm_t * comm, int total_width, int total_height)
{
	//
    //
    //
	

    // get infos
	int rank;
	int comm_size;
	MPI_Comm_rank( MPI_COMM_WORLD, &rank );
	MPI_Comm_size( MPI_COMM_WORLD, &comm_size );

	int dims[2] = {0, 0};
	int periods[2] = {0, 0};
	int coords[2];

	lbm_choose_2d_split(comm_size, total_width, total_height, dims);
    // printf("dims[0] = %d, dims[1] = %d\n", dims[0], dims[1]);
    // for testing purpose as best split chooses [8,1] for -np 8 which is only on x
    //dims[0] = comm_size/2;
    //dims[1] = 2;
    printf("dims[0] = %d, dims[1] = %d\n", dims[0], dims[1]);
    // MPI_Dims_create(int nnodes, int ndims, int *dims) // doesn't look at the height and width of the domain so could return dims that don't divide the grid perfectly
	MPI_Cart_create(MPI_COMM_WORLD, 2, dims, periods, 0, &comm->communicator);
	MPI_Cart_coords(comm->communicator, rank, 2, coords);

	//number of tasks along X axis and Y axis.
	comm->nb_x = dims[0];
	comm->nb_y = dims[1];

	//current task position in the splitting
	comm->rank_x = coords[0];
	comm->rank_y = coords[1];

	//local sub-domain size
	comm->width = total_width / comm->nb_x + 2;
	comm->height = total_height / comm->nb_y + 2;

	// absolute position  (in cell number) in the global mesh without accounting the ghost cells
	comm->x = comm->rank_x * (total_width / comm->nb_x);
	comm->y = comm->rank_y * (total_height / comm->nb_y);

	// preallocate buffers for non contiguous communications
	comm->buffer_send_up   = malloc(DIRECTIONS * comm->width * sizeof(double));
	comm->buffer_send_down = malloc(DIRECTIONS * comm->width * sizeof(double));
	comm->buffer_recv_up   = malloc(DIRECTIONS * comm->width * sizeof(double));
	comm->buffer_recv_down = malloc(DIRECTIONS * comm->width * sizeof(double));

	//if debug print comm
	//lbm_comm_print(comm);
}

/****************************************************/
void lbm_comm_release_ex4(lbm_comm_t * comm)
{
	//free allocated ressources
    
	// free preallocated buffers
	free(comm->buffer_send_up);
	free(comm->buffer_send_down);
	free(comm->buffer_recv_up);
	free(comm->buffer_recv_down);
}

/****************************************************/
void lbm_comm_ghost_exchange_ex4(lbm_comm_t * comm, lbm_mesh_t * mesh)
{
	//
	// Implement the 2D communication with :
	//         - blocking MPI functions
	//         - manual copy in temp buffer for non contiguous side 
	//
	// To be used:
	//    - DIRECTIONS: the number of doubles composing a cell
	//    - double[9] lbm_mesh_get_cell(mesh, x, y): function to get the address of a particular cell.
	//    - comm->width : The with of the local sub-domain (containing the ghost cells)
	//    - comm->height : The height of the local sub-domain (containing the ghost cells)
	//
	// TIP: create a function to get the target rank from x,y task coordinate. 
	// TIP: You can use MPI_PROC_NULL on borders.
	// TIP: send the corner values 2 times, with the up/down/left/write communication
	//      and with the diagonal communication in a second time, this avoid
	//      special cases for border tasks.

	//example to access cell
	//double * cell = lbm_mesh_get_cell(mesh, local_x, local_y);
	//double * cell = lbm_mesh_get_cell(mesh, comm->width - 1, 0);

    // left-right communication
    int rank_left   = lbm_comm_rank_at(comm, comm->rank_x - 1, comm->rank_y);
    int rank_right  = lbm_comm_rank_at(comm, comm->rank_x + 1, comm->rank_y);

    double * right_inner = lbm_mesh_get_cell(mesh, comm->width-2, 0);
    double * right_ghost = lbm_mesh_get_cell(mesh, comm->width-1, 0);
    double * left_inner  = lbm_mesh_get_cell(mesh, 1, 0);
    double * left_ghost  = lbm_mesh_get_cell(mesh, 0, 0);

    MPI_Send(right_inner, DIRECTIONS * comm->height, MPI_DOUBLE, rank_right, 0, comm->communicator);
    MPI_Recv(left_ghost, DIRECTIONS * comm->height, MPI_DOUBLE, rank_left, 0, comm->communicator, MPI_STATUS_IGNORE);

    MPI_Send(left_inner, DIRECTIONS * comm->height, MPI_DOUBLE, rank_left, 1, comm->communicator);
    MPI_Recv(right_ghost, DIRECTIONS * comm->height, MPI_DOUBLE, rank_right, 1, comm->communicator, MPI_STATUS_IGNORE);


    // top-bottom communication
    int rank_top    = lbm_comm_rank_at(comm, comm->rank_x, comm->rank_y - 1);
    int rank_bottom = lbm_comm_rank_at(comm, comm->rank_x, comm->rank_y + 1);

    double *cell;

    // send top inner, receive bottom ghost
    for (int i=0; i<comm->width; i++) {
        cell = lbm_mesh_get_cell(mesh, i, 1);
        for (int k=0; k<DIRECTIONS; k++) {
            comm->buffer_send_up[i*DIRECTIONS+k] = cell[k];
        }
    }
    MPI_Send(comm->buffer_send_up, DIRECTIONS * comm->width, MPI_DOUBLE, rank_top, 0, comm->communicator);
    MPI_Recv(comm->buffer_recv_down, DIRECTIONS * comm->width, MPI_DOUBLE, rank_bottom, 0, comm->communicator, MPI_STATUS_IGNORE);

    if (rank_bottom != MPI_PROC_NULL) {
        for (int i=0; i<comm->width; i++) {
            cell = lbm_mesh_get_cell(mesh, i, comm->height-1);
            for (int k=0; k<DIRECTIONS; k++) {
                cell[k] = comm->buffer_recv_down[i*DIRECTIONS+k] ;
            }
        }
    }

    // send bottom inner, receive top ghost
    for (int i=0; i<comm->width; i++) {
        cell = lbm_mesh_get_cell(mesh, i, comm->height-2);
        for (int k=0; k<DIRECTIONS; k++) {
            comm->buffer_send_down[i*DIRECTIONS+k] = cell[k];
        }
    }
    MPI_Send(comm->buffer_send_down, DIRECTIONS * comm->width, MPI_DOUBLE, rank_bottom, 0, comm->communicator);
    MPI_Recv(comm->buffer_recv_up, DIRECTIONS * comm->width, MPI_DOUBLE, rank_top, 0, comm->communicator, MPI_STATUS_IGNORE);

    if (rank_top != MPI_PROC_NULL) {
        for (int i=0; i<comm->width; i++) {
            cell = lbm_mesh_get_cell(mesh, i, 0);
            for (int k=0; k<DIRECTIONS; k++) {
                cell[k] = comm->buffer_recv_up[i*DIRECTIONS+k] ;
            }
        }
    }


    // Not useful to do diagonal communication as they get transferred during left/right - top/bottom, but can be used to verify correctness with the checksum command
}
