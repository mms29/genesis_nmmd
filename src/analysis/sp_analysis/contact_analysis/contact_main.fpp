!--------1---------2---------3---------4---------5---------6---------7---------8
!
!> Program  contact_main
!! @brief   main subroutine for GRID analysis
!! @authors Isseki  Yu (IY), Yuji Sugita (YS)
!
!  (c) Copyright 2014 RIKEN. All rights reserved.
!
!--------1---------2---------3---------4---------5---------6---------7---------8

#ifdef HAVE_CONFIG_H
#include "../../../config.h"
#endif

program contact_main

  use contact_analyze_mod
  use contact_control_mod
  use contact_option_mod
  use contact_option_str_mod
  use sa_setup_mpi_mod
  use sa_setup_mod
  use sa_control_mod
  use sa_option_str_mod
  use sa_domain_str_mod
  use sa_boundary_str_mod
  use sa_ensemble_str_mod
  use sa_timers_mod
  use trajectory_str_mod
  use output_str_mod
  use molecules_str_mod
  use fitting_str_mod
  use fileio_control_mod
  use string_mod
  use messages_mod
  use mpi_parallel_mod
#ifdef HAVE_MPI_GENESIS
  use mpi
#endif
#ifdef OMP
  use omp_lib
#endif

  implicit none

  ! local variables
  character(MaxFilename)     :: ctrl_filename
  type(s_ctrl_data)          :: ctrl_data
  type(s_molecule)           :: molecule
  type(s_trj_list)           :: trj_list
  type(s_trajectory)         :: trajectory
  type(s_fitting)            :: fitting
  type(s_output)             :: output
  type(s_option)             :: option
  type(s_domain)             :: domain
  type(s_boundary)           :: boundary
  type(s_ensemble)           :: ensemble
  type(s_contact_ctrl_data)  :: contact_ctrl_data
  type(s_contact_option)     :: contact_option


#ifdef HAVE_MPI_GENESIS
  call mpi_init(ierror)
  call mpi_comm_rank(mpi_comm_world, my_world_rank, ierror)
  call mpi_comm_size(mpi_comm_world, nproc_world,   ierror)
  main_rank = (my_world_rank == 0)
#else

  my_city_rank = 0
  nproc_city   = 1
  main_rank    = .true.
#endif

#ifdef OMP
  nthread = omp_get_max_threads()
#else
  nthread = 1
#endif


  ! show usage
  !
  call contact_usage(ctrl_filename)

  ! [Step1] Read control file
  !
  if (main_rank) then
    write(MsgOut,'(A)') '[STEP1] Read Control Parameters for contact analysis'
    write(MsgOut,'(A)') ' '
  end if

  call control(ctrl_filename, ctrl_data)
  call contact_control(ctrl_filename, contact_ctrl_data)

  ! [Step2] Setup MPI
  !

  if (main_rank) then
    write(MsgOut,'(A)') '[STEP2] Setup MPI'
    write(MsgOut,'(A)') ' '
  end if

  call timer(TimerTotal, TimerOn)
  call setup_mpi_sa ( )

  ! [Step3] Set relevant variables and structures
  !
  if (main_rank) then
    write(MsgOut,'(A)') '[STEP3] Set Relevant Variables and Structures'
    write(MsgOut,'(A)') ' '
  end if

  call setup(ctrl_data, molecule, trj_list, trajectory, &
             fitting, output, option, boundary,  domain, ensemble)

  call contact_setup_option(contact_ctrl_data%contact_opt_info, contact_option)

  ! [Step4] Analyze trajectory
  !
  if (main_rank) then
    write(MsgOut,'(A)') '[STEP4] Run Analysis'
    write(MsgOut,'(A)') ' '
  end if

  call run_contact(molecule, trj_list, output, option, contact_option, &
                   trajectory, boundary, domain, ensemble)

  ! [Step5] Deallocate memory
  !
  if (main_rank) then
    write(MsgOut,'(A)') '[STEP5] Deallocate memory'
    write(MsgOut,'(A)') ' '
  end if

  call dealloc_contact_option(contact_option)
  call dealloc_option(option)
  call dealloc_trj_list(trj_list)
  call dealloc_trajectory(trajectory)
  call dealloc_molecules_all(molecule)

  call timer(TimerTotal, TimerOff)
  call  sa_output_time

#ifdef HAVE_MPI_GENESIS
  call mpi_finalize(ierror)
#endif

  stop

end program contact_main
