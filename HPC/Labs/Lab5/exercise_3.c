/*****************************************************
    AUTHOR  : Sébastien Valat
    MAIL    : sebastien.valat@univ-grenoble-alpes.fr
    LICENSE : BSD
    YEAR    : 2021
    COURSE  : Parallel Algorithms and Programming
*****************************************************/

//////////////////////////////////////////////////////
//
// Goal: Implement non-blocking 1D communication scheme
//       along X axis.
//
// SUMMARY:
//     - 1D splitting along X
// NEW:
//     - >>> Non-blocking communications <<<
//
//////////////////////////////////////////////////////

/****************************************************/
#include "mpi.h"
#include "src/lbm_struct.h"
#include "src/exercises.h"

/****************************************************/
void lbm_comm_init_ex3(lbm_comm_t * comm, int total_width, int total_height)
{
	//we use the same implementation then ex1
	lbm_comm_init_ex1(comm, total_width, total_height);
}

/****************************************************/
void lbm_comm_ghost_exchange_ex3(lbm_comm_t * comm, lbm_mesh_t * mesh)
{
	//
	// 1D communication with non-blocking MPI functions.
	//
 
	//get infos
	int rank;
	int comm_size;
	MPI_Comm_rank( MPI_COMM_WORLD, &rank );
	MPI_Comm_size( MPI_COMM_WORLD, &comm_size );


    int req_count = 0;
    
    // send data
    if (rank<comm_size-1){
	    double * cell_send = lbm_mesh_get_cell(mesh, comm->width-2, 0);
        MPI_Isend(cell_send, DIRECTIONS*comm->height, MPI_DOUBLE, rank+1, 0, comm->communicator, &comm->requests[req_count++]);
    }
    if (rank>0){
	    double * cell_send = lbm_mesh_get_cell(mesh, 1, 0);
        MPI_Isend(cell_send, DIRECTIONS*comm->height, MPI_DOUBLE, rank-1, 1, comm->communicator, &comm->requests[req_count++]);
    }

    // receive data
    if (rank>0){
	    double * cell_rcv = lbm_mesh_get_cell(mesh, 0, 0);
        MPI_Irecv(cell_rcv, DIRECTIONS*comm->height, MPI_DOUBLE, rank-1, 0, comm->communicator, &comm->requests[req_count++]);
    }
    // send data backwards
    if (rank<comm_size-1){
	    double * cell_rcv = lbm_mesh_get_cell(mesh, comm->width-1, 0);
        MPI_Irecv(cell_rcv, DIRECTIONS*comm->height, MPI_DOUBLE, rank+1, 1, comm->communicator, &comm->requests[req_count++]);
    }

    MPI_Waitall(req_count, comm->requests, MPI_STATUSES_IGNORE);
}
