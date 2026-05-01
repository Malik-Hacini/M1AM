/*****************************************************
    AUTHOR  : Sébastien Valat
    MAIL    : sebastien.valat@univ-grenoble-alpes.fr
    LICENSE : BSD
    YEAR    : 2021
    COURSE  : Parallel Algorithms and Programming
*****************************************************/

//////////////////////////////////////////////////////
//
//
// GOAL: Implement a 1D communication scheme along
//       X axis with blocking communications.
//
// SUMMARY:
//     - 1D splitting along X
//     - Blocking communications
//
//////////////////////////////////////////////////////

/****************************************************/
#include "mpi.h"
#include "src/lbm_comm.h"
#include "src/lbm_config.h"
#include "src/lbm_struct.h"
#include "src/exercises.h"
#include <stdlib.h>

/****************************************************/
void lbm_comm_init_ex1(lbm_comm_t * comm, int total_width, int total_height)
{
	//get infos
	int rank;
	int comm_size;
	MPI_Comm_rank( MPI_COMM_WORLD, &rank );
	MPI_Comm_size( MPI_COMM_WORLD, &comm_size );

    //initialize mpi communicator
    comm->communicator = MPI_COMM_WORLD;

    if (total_width%comm_size !=0){abort();}

	comm->nb_x = comm_size;
	comm->nb_y = 1;

	// current task position in the splitting
	comm->rank_x = rank;
	comm->rank_y = 0;

	// local sub-domain size
	comm->width = total_width/comm_size +2;
	comm->height = total_height+2;

	// absolute position in the global mesh.
	comm->x = (total_width/comm_size)*rank;
	comm->y = 0;

	//if debug print comm
	//lbm_comm_print(comm);
}

/****************************************************/
void lbm_comm_ghost_exchange_ex1(lbm_comm_t * comm, lbm_mesh_t * mesh)
{
	//
	// 1D communication with blocking MPI functions (MPI_Send & MPI_Recv)
	//

	//get infos
	int rank;
	int comm_size;
	MPI_Comm_rank( MPI_COMM_WORLD, &rank );
	MPI_Comm_size( MPI_COMM_WORLD, &comm_size );


    // send data forwards
    if (rank<comm_size-1){
	    double * cell_send = lbm_mesh_get_cell(mesh, comm->width-2, 0);
        MPI_Send(cell_send, DIRECTIONS*comm->height, MPI_DOUBLE, rank+1, 0, comm->communicator);
    }
    if (rank>0){
	    double * cell_rcv = lbm_mesh_get_cell(mesh, 0, 0);
        MPI_Recv(cell_rcv, DIRECTIONS*comm->height, MPI_DOUBLE, rank-1, 0, comm->communicator,MPI_STATUS_IGNORE);
    }

    // send data backwards
    if (rank>0){
	    double * cell_send = lbm_mesh_get_cell(mesh, 1, 0);
        MPI_Send(cell_send, DIRECTIONS*comm->height, MPI_DOUBLE, rank-1, 1, comm->communicator);
    }
    if (rank<comm_size-1){
	    double * cell_rcv = lbm_mesh_get_cell(mesh, comm->width-1, 0);
        MPI_Recv(cell_rcv, DIRECTIONS*comm->height, MPI_DOUBLE, rank+1, 1, comm->communicator,MPI_STATUS_IGNORE);
    }
}
