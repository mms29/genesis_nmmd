!--------1---------2---------3---------4---------5---------6---------7---------8
!
!  Module   at_dynamics_str_mod
!> @brief   structure of dynamics information
!! @authors Takaharu Mori (TM)
!
!  (c) Copyright 2014 RIKEN. All rights reserved.
!
!--------1---------2---------3---------4---------5---------6---------7---------8

#ifdef HAVE_CONFIG_H
#include "../config.h"
#endif

module at_dynamics_str_mod

  use constants_mod
  use string_mod

  implicit none
  private

  ! structures
  type, public :: s_dynamics
    logical             :: restart
    integer             :: integrator
    integer             :: nsteps
    real(wp)            :: timestep
    integer             :: istart_step
    integer             :: iend_step
    integer             :: eneout_period
    integer             :: crdout_period
    integer             :: velout_period
    integer             :: rstout_period
    integer             :: stoptr_period
    integer             :: nbupdate_period
    integer             :: iseed
    real(wp)            :: initial_time
    logical             :: stop_com_translation
    logical             :: stop_com_rotation
    logical             :: annealing
    integer             :: anneal_period
    real(wp)            :: dtemperature
    logical             :: target_md
    logical             :: steered_md
    real(wp)            :: initial_value
    real(wp)            :: final_value
    logical             :: verbose
    logical             :: random_restart
    integer             :: nm_number
    real(wp)            :: nm_mass
    real(wp)            :: nm_limit
    real(wp)            :: elnemo_cutoff
    integer             :: elnemo_rtb_block
    character(MaxFilename)     :: elnemo_path
    character(MaxFilename)     :: nm_prefix
  end type s_dynamics

  type, public:: s_nmmd_dynamics

end type s_nmmd_dynamics

  ! parameters
  integer,      public, parameter :: IntegratorLEAP = 1
  integer,      public, parameter :: IntegratorVVER = 2
  integer,      public, parameter :: IntegratorNMMD = 3

  character(*), public, parameter :: IntegratorTypes(3)  = (/'LEAP','VVER','NMMD'/)


  ! subroutines
  public  ::  init_dynamics

contains

  !======1=========2=========3=========4=========5=========6=========7=========8
  !
  !  Subroutine    init_dynamics
  !> @brief        initialize dynamics information
  !! @authors      TM
  !! @param[out]   dynamics : dynamics information
  !
  !======1=========2=========3=========4=========5=========6=========7=========8

  subroutine init_dynamics(dynamics)

    ! formal arguments
    type(s_dynamics), intent(inout) :: dynamics


    dynamics%restart              = .false.
    dynamics%integrator           = 0
    dynamics%nsteps               = 0
    dynamics%timestep             = 0.0_wp
    dynamics%eneout_period        = 0
    dynamics%crdout_period        = 0
    dynamics%velout_period        = 0
    dynamics%rstout_period        = 0
    dynamics%stoptr_period        = 0
    dynamics%nbupdate_period      = 0
    dynamics%iseed                = 0
    dynamics%initial_time         = 0.0_wp
    dynamics%stop_com_translation = .false.
    dynamics%stop_com_rotation    = .false.
    dynamics%annealing            = .false.
    dynamics%anneal_period        = 0
    dynamics%dtemperature         = 0.0_wp
    dynamics%istart_step          = 0
    dynamics%iend_step            = 0
    dynamics%verbose              = .false.
    dynamics%target_md            = .false.
    dynamics%steered_md           = .false.
    dynamics%initial_value        = 0.0_wp
    dynamics%final_value          = 0.0_wp
    dynamics%random_restart       = .true.
    dynamics%nm_number            = 10
    dynamics%nm_mass              = 10
    dynamics%nm_limit             = 1000
    dynamics%elnemo_path          = ''
    dynamics%nm_prefix            = ''
    dynamics%elnemo_cutoff        = 8.0_wp
    dynamics%elnemo_rtb_block     = 10

    return

  end subroutine init_dynamics

end module at_dynamics_str_mod
