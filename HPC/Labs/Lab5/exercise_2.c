/*****************************************************
    AUTHOR  : Sébastien Valat
    MAIL    : sebastien.valat@univ-grenoble-alpes.fr
    LICENSE : BSD
    YEAR    : 2021
    COURSE  : Parallel Algorithms and Programming
*****************************************************/

//////////////////////////////////////////////////////
//
// Goal: Implement odd/even 1D blocking communication scheme 
//       along X axis.
//
// SUMMARY:
//     - 1D splitting along X
//     - Blocking communications
// NEW:
//     - >>> Odd/even communication ordering <<<<
//
//////////////////////////////////////////////////////

/****************************************************/
#include "src/lbm_struct.h"
#include "src/exercises.h"

/****************************************************/
void lbm_comm_init_ex2(lbm_comm_t * comm, int total_width, int total_height)
{
	//we use the same implementation then ex1
	lbm_comm_init_ex1(comm, total_width, total_height);
}

/****************************************************/
void lbm_comm_ghost_exchange_ex2(lbm_comm_t * comm, lbm_mesh_t * mesh)
{
	//
	//1D communication with blocking MPI functions using odd/even communications.
	//
    
	//get infos
	int rank;
	int comm_size;
	MPI_Comm_rank( MPI_COMM_WORLD, &rank );
	MPI_Comm_size( MPI_COMM_WORLD, &comm_size );

    // odd sends
    if (rank%2==1){
        // send right side
        if (rank<comm_size-1){
            double * cell_send = lbm_mesh_get_cell(mesh, comm->width-2, 0);
            MPI_Send(cell_send, DIRECTIONS*comm->height, MPI_DOUBLE, rank+1, 0, comm->communicator);
        }
        // send left side
        if (rank>0){
            double * cell_send = lbm_mesh_get_cell(mesh, 1, 0);
            MPI_Send(cell_send, DIRECTIONS*comm->height, MPI_DOUBLE, rank-1, 1, comm->communicator);
        }
    }

    // even receives
    if (rank%2==0){
        // receive left side
        if (rank>0){
            double * cell_rcv = lbm_mesh_get_cell(mesh, 0, 0);
            MPI_Recv(cell_rcv, DIRECTIONS*comm->height, MPI_DOUBLE, rank-1, 0, comm->communicator,MPI_STATUS_IGNORE);
        }

        // receive right side
        if (rank<comm_size-1){
            double * cell_rcv = lbm_mesh_get_cell(mesh, comm->width-1, 0);
            MPI_Recv(cell_rcv, DIRECTIONS*comm->height, MPI_DOUBLE, rank+1, 1, comm->communicator,MPI_STATUS_IGNORE);
        }
    }
	
    // even sends 
    if (rank%2==0){
        // send right side
        if (rank<comm_size-1){
            double * cell_send = lbm_mesh_get_cell(mesh, comm->width-2, 0);
            MPI_Send(cell_send, DIRECTIONS*comm->height, MPI_DOUBLE, rank+1, 0, comm->communicator);
        }
        // send left side
        if (rank>0){
            double * cell_send = lbm_mesh_get_cell(mesh, 1, 0);
            MPI_Send(cell_send, DIRECTIONS*comm->height, MPI_DOUBLE, rank-1, 1, comm->communicator);
        }
    }
    
    // odd receive
    if (rank%2==1){
        // receive left side
        if (rank>0){
            double * cell_rcv = lbm_mesh_get_cell(mesh, 0, 0);
            MPI_Recv(cell_rcv, DIRECTIONS*comm->height, MPI_DOUBLE, rank-1, 0, comm->communicator,MPI_STATUS_IGNORE);
        }

        // send right side
        if (rank<comm_size-1){
            double * cell_rcv = lbm_mesh_get_cell(mesh, comm->width-1, 0);
            MPI_Recv(cell_rcv, DIRECTIONS*comm->height, MPI_DOUBLE, rank+1, 1, comm->communicator,MPI_STATUS_IGNORE);
        }
    }
}
