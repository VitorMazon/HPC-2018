! ---
! Copyright (C) 1996-2016	The SIESTA group
!  This file is distributed under the terms of the
!  GNU General Public License: see COPYING in the top directory
!  or http://www.gnu.org/copyleft/gpl.txt .
! See Docs/Contributors.txt for a list of contributors.
! ---


! This code has been fully implemented by:
! Nick Papior, 2014
!
! Please attribute the original author in case of dublication

! Creation of the hssigma files.
module m_tbt_sigma_save

  use units, only : dp

  use m_tbt_hs, only : tTSHS
  use m_tbt_save, only : tNodeE
#ifdef NCDF_4
  use m_tbt_save, only : tbt_cdf_precision
#endif
  
  implicit none

  private 

  public :: init_Sigma_options, print_Sigma_options

#ifdef NCDF_4
  logical, save :: sigma_save      = .false.
  logical, save :: sigma_mean_save = .false.
  logical, save :: sigma_parallel  = .false.
  integer, save :: cmp_lvl    = 0

  public :: init_Sigma_save
  public :: state_Sigma_save
  public :: state_Sigma2mean
#endif

contains


  subroutine init_Sigma_options(save_DATA)

    use dictionary
    use fdf

    type(dict), intent(inout) :: save_DATA

#ifdef NCDF_4

    sigma_save   = fdf_get('TBT.CDF.SelfEnergy.Save',.false.)
    if ( sigma_save ) then
       sigma_mean_save = fdf_get('TBT.CDF.SelfEnergy.Save.Mean',.false.)
    end if
    cmp_lvl = fdf_get('CDF.Compress',0)
    cmp_lvl = fdf_get('TBT.CDF.Compress',cmp_lvl)
    cmp_lvl = fdf_get('TBT.CDF.SelfEnergy.Compress',cmp_lvl)
    if ( cmp_lvl < 0 ) cmp_lvl = 0
    if ( cmp_lvl > 9 ) cmp_lvl = 9
#ifdef NCDF_PARALLEL
    sigma_parallel = fdf_get('TBT.CDF.SelfEnergy.MPI',.false.)
    if ( sigma_parallel ) then
       cmp_lvl = 0
    end if
#endif

    if ( fdf_get('TBT.SelfEnergy.Only',.false.) ) then
       save_DATA = save_DATA // ('Sigma-only'.kv.1)
    end if
    
#endif
    
  end subroutine init_Sigma_options

  subroutine print_Sigma_options( save_DATA )

    use parallel, only: IONode
    use dictionary

    type(dict), intent(inout) :: save_DATA

    character(len=*), parameter :: f1 ='(''tbt: '',a,t53,''='',tr4,l1)'
    character(len=*), parameter :: f12='(''tbt: '',a,t53,''='',tr2,i0)'
    character(len=*), parameter :: f11='(''tbt: '',a)'

    if ( .not. IONode ) return
    
#ifdef NCDF_4
    write(*,f1)'Saving down-folded self-energies',sigma_save
    if ( .not. sigma_save ) return

    write(*,f1)'Only calc down-folded self-energies', &
         ('Sigma-only'.in.save_DATA)
    if ( cmp_lvl > 0 ) then
       write(*,f12)'Compression level of TBT.SE.nc files',cmp_lvl
    else
       write(*,f11)'No compression level of TBT.SE.nc files'
    end if
    write(*,f1)'k-average down-folded self-energies',sigma_mean_save
#else
    write(*,f11)'Saving down-folded self-energies not enabled (NetCDF4)'
#endif

  end subroutine print_Sigma_options

#ifdef NCDF_4

  ! Save the self-energies of the electrodes and
  subroutine init_Sigma_save(fname, TSHS, r, ispin, N_Elec, Elecs, &
       nkpt, kpt, wkpt, NE, &
       a_Dev, a_Buf)

    use parallel, only : IONode
    use m_os, only : file_exist

    use netcdf_ncdf, ncdf_parallel => parallel
    use m_timestamp, only : datestring
#ifdef MPI
    use mpi_siesta, only : MPI_COMM_WORLD, MPI_Bcast, MPI_Logical
#endif
    use m_ts_electype
    use m_region
    use dictionary

    ! The file name that we save in
    character(len=*), intent(in) :: fname
    ! The full Hamiltonian and system at present investigation.
    ! Note the H have been shifted to zero energy
    type(tTSHS), intent(in) :: TSHS
    ! The device region that we are checking
    ! This is the device regions pivot-table!
    type(tRgn), intent(in) :: r 
    integer, intent(in) :: ispin
    integer, intent(in) :: N_Elec
    type(Elec), intent(in) :: Elecs(N_Elec)
    integer, intent(in) :: nkpt
    real(dp), intent(in) :: kpt(3,nkpt), wkpt(nkpt)
    integer, intent(in) :: NE
    ! Device atoms
    type(tRgn), intent(in) :: a_Dev
    ! Buffer atoms
    type(tRgn), intent(in) :: a_Buf

    type(hNCDF) :: ncdf, grp
    type(dict) :: dic
    logical :: prec_Sigma
    logical :: exist, isGamma, same
    character(len=200) :: char
    integer :: i, iEl
    real(dp), allocatable :: r2(:,:)
#ifdef MPI
    integer :: MPIerror
#endif

    if ( .not. sigma_save ) return

    isGamma = all(TSHS%nsc(:) == 1)

    exist = file_exist(fname, Bcast = .true. )

    call tbt_cdf_precision('SelfEnergy','single',prec_Sigma)

    ! in case it already exists...
    if ( exist ) then

       ! Create a dictionary to check that the sigma file is the
       ! same
       call ncdf_open(ncdf,fname)

       dic = ('no_u'.kv.TSHS%no_u) // ('na_u'.kv.TSHS%na_u) // &
            ('nkpt'.kv.nkpt ) // ('no_d'.kv.r%n) // &
            ('ne'.kv. NE )
       dic = dic // ('na_d'.kv. a_Dev%n)
       if ( a_Buf%n > 0 ) then
          dic = dic // ('na_b'.kv.a_Buf%n)
       end if
       call ncdf_assert(ncdf,exist,dims=dic)
       call delete(dic)
#ifdef MPI
       call MPI_Bcast(same,1,MPI_Logical,0, &
            MPI_Comm_World,MPIerror)
#endif
       if ( .not. same ) then
          call die('Dimensions in the TBT.SE.nc file does not conform &
               &to the current simulation.')
       end if

       do iEl = 1 , N_Elec
          call ncdf_open_grp(ncdf,Elecs(iEl)%name,grp)
          dic = dic // ('no_e'.kv.Elecs(iEl)%o_inD%n)
          call ncdf_assert(grp,exist,dims=dic)
          if ( .not. exist ) then
             write(*,*) 'Assertion of dimensions in file: '//trim(fname)//' failed.'

             call die('We could not assert the dimensions TBT.SE.nc file.')
          end if
       end do
       call delete(dic)

       ! Check the variables
       ! Check the variables
       dic = ('lasto'.kvp. TSHS%lasto(1:TSHS%na_u) ) // &
            ('pivot'.kvp. r%r )
       dic = dic // ('a_dev'.kvp.a_Dev%r )
       dic = dic // ('xa'.kvp. TSHS%xa)
       if ( a_Buf%n > 0 )then
          dic = dic // ('a_buf'.kvp.a_Buf%r )
       end if
       call ncdf_assert(ncdf,same,vars=dic, d_EPS = 1.e-4_dp )
       call delete(dic,dealloc=.false.) ! we have them pointing...
#ifdef MPI
       call MPI_Bcast(same,1,MPI_Logical,0, &
            MPI_Comm_World,MPIerror)
#endif
       if ( .not. same ) then
          call die('pivot, lasto, xa or a_buf in the TBT.nc file does &
               &not conform to the current simulation.')
       end if

       if ( .not. isGamma ) then
          ! Check the k-points
          allocate(r2(3,nkpt))
          do i = 1 , nkpt
             call kpoint_convert(TSHS%cell,kpt(:,i),r2(:,i),1)
          end do
          dic = ('kpt'.kvp. r2) // ('wkpt'.kvp. wkpt)
          call ncdf_assert(ncdf,same,vars=dic, d_EPS = 1.e-7_dp )
          if ( .not. same ) then
             call die('k-points or k-weights are not the same')
          end if
          call delete(dic,dealloc = .false. )
          deallocate(r2)
       end if

       call die('Currently the TBT.SE.nc file exists, &
            &we do not currently implement a continuation scheme.')

       ! We currently overwrite the Sigma-file
       if ( IONode ) then
          write(*,'(2a)')'tbtrans: Overwriting self-energy file: ',trim(fname)
       end if

    else
       
       if ( IONode ) then
          write(*,'(2a)')'tbtrans: Initializing self-energy file: ',trim(fname)
       end if

    end if

    ! We need to create the file
#ifdef NCDF_PARALLEL
    if ( sigma_parallel ) then
       call ncdf_create(ncdf,fname, mode=NF90_MPIIO, overwrite=.true., &
            comm = MPI_COMM_WORLD, &
            parallel = .true. )
    else
       call ncdf_create(ncdf,fname, mode=NF90_NETCDF4, overwrite=.true.)
    end if
#else
    call ncdf_create(ncdf,fname, mode=NF90_NETCDF4, overwrite=.true.)
#endif

    ! Save the current system size
    call ncdf_def_dim(ncdf,'no_u',TSHS%no_u)
    call ncdf_def_dim(ncdf,'na_u',TSHS%na_u)
    call ncdf_def_dim(ncdf,'nkpt',nkpt) ! Even for Gamma, it makes files unified
    call ncdf_def_dim(ncdf,'xyz',3)
    call ncdf_def_dim(ncdf,'one',1)
    call ncdf_def_dim(ncdf,'ne',NE)
    call ncdf_def_dim(ncdf,'na_d',a_Dev%n)
    call ncdf_def_dim(ncdf,'no_d',r%n)
    if ( a_Buf%n > 0 ) then
       call ncdf_def_dim(ncdf,'na_b',a_Buf%n) ! number of buffer-atoms
    end if

#ifdef TBT_PHONON
    dic = ('source'.kv.'PHtrans')
#else
    dic = ('source'.kv.'TBtrans')
#endif

    char = datestring()
    dic = dic//('date'.kv.char(1:10))
    if ( all(TSHS%nsc(:) == 1) ) then
       dic = dic // ('Gamma'.kv.'true')
    else
       dic = dic // ('Gamma'.kv.'false')
    end if
    if ( TSHS%nspin > 1 ) then
       if ( ispin == 1 ) then
          dic = dic // ('spin'.kv.'UP')
       else
          dic = dic // ('spin'.kv.'DOWN')
       end if
    end if
    call ncdf_put_gatt(ncdf, atts = dic )
    call delete(dic)

    ! Create all the variables needed to save the states
    dic = ('info'.kv.'Last orbitals of the equivalent atom')
    call ncdf_def_var(ncdf,'lasto',NF90_INT,(/'na_u'/), &
         atts = dic)
    dic = dic//('info'.kv.'Unit cell')
    dic = dic//('unit'.kv.'Bohr')
    call ncdf_def_var(ncdf,'cell',NF90_DOUBLE,(/'xyz','xyz'/), &
         atts = dic)
    dic = dic//('info'.kv.'Atomic coordinates')
    dic = dic//('unit'.kv.'Bohr')
    call ncdf_def_var(ncdf,'xa',NF90_DOUBLE,(/'xyz ','na_u'/), &
         atts = dic)
    call delete(dic)

    dic = ('info'.kv.'Device region orbital pivot table')
    call ncdf_def_var(ncdf,'pivot',NF90_INT,(/'no_d'/), &
         atts = dic)

    dic = dic//('info'.kv.'Index of device atoms')
    call ncdf_def_var(ncdf,'a_dev',NF90_INT,(/'na_d'/), &
         atts = dic)

    if ( a_Buf%n > 0 ) then
       dic = dic//('info'.kv.'Index of buffer atoms')
       call ncdf_def_var(ncdf,'a_buf',NF90_INT,(/'na_b'/), &
            atts = dic)
    end if

    if ( .not. isGamma ) then

       dic = dic//('info'.kv.'k point')//('unit'.kv.'b')
       call ncdf_def_var(ncdf,'kpt',NF90_DOUBLE,(/'xyz ','nkpt'/), &
            atts = dic)
       call delete(dic)
       dic = dic//('info'.kv.'k point weights')
       call ncdf_def_var(ncdf,'wkpt',NF90_DOUBLE,(/'nkpt'/), &
            atts = dic)

    end if

#ifdef TBT_PHONON
    dic = dic//('info'.kv.'Frequency')//('unit'.kv.'Ry')
#else
    dic = dic//('info'.kv.'Energy')//('unit'.kv.'Ry')
#endif
    call ncdf_def_var(ncdf,'E',NF90_DOUBLE,(/'ne'/), &
         atts = dic)
    call delete(dic)

    call ncdf_put_var(ncdf,'pivot',r%r)
    call ncdf_put_var(ncdf,'cell',TSHS%cell)
    call ncdf_put_var(ncdf,'xa',TSHS%xa)
    call ncdf_put_var(ncdf,'lasto',TSHS%lasto(1:TSHS%na_u))
    call ncdf_put_var(ncdf,'a_dev',a_Dev%r)
    if ( a_Buf%n > 0 ) then
       call ncdf_put_var(ncdf,'a_buf',a_Buf%r)
    end if

    ! Save all k-points
    if ( .not. isGamma ) then
       allocate(r2(3,nkpt))
       do i = 1 , nkpt
          call kpoint_convert(TSHS%cell,kpt(:,i),r2(:,i),1)
       end do
       call ncdf_put_var(ncdf,'kpt',r2)
       call ncdf_put_var(ncdf,'wkpt',wkpt)
       deallocate(r2)
    end if

    do iEl = 1 , N_Elec

       call ncdf_def_grp(ncdf,trim(Elecs(iEl)%name),grp)

       ! Save information about electrode
       dic = dic//('info'.kv.'Chemical potential')//('unit'.kv.'Ry')
       call ncdf_def_var(grp,'mu',NF90_DOUBLE,(/'one'/), &
            atts = dic)
       call ncdf_put_var(grp,'mu',Elecs(iEl)%mu%mu)

       dic = ('info'.kv.'Imaginary part of self-energy')//('unit'.kv.'Ry')
       call ncdf_def_var(grp,'Eta',NF90_DOUBLE,(/'one'/), atts = dic)
       
       dic = ('info'.kv.'Accuracy of the self-energy')//('unit'.kv.'Ry')
       call ncdf_def_var(grp,'Accuracy',NF90_DOUBLE,(/'one'/), atts = dic)
       call delete(dic)

       call ncdf_def_dim(grp,'no_e',Elecs(iEl)%o_inD%n)

       dic = ('info'.kv.'Orbital pivot table for self-energy')
       call ncdf_def_var(grp,'pivot',NF90_INT,(/'no_e'/), atts = dic)
       dic = dic//('info'.kv.'Down-folded self-energy')
       dic = dic//('unit'.kv.'Ry')
       ! Chunking greatly reduces IO cost
       i = Elecs(iEl)%o_inD%n
       call ncdf_def_var(grp,'SelfEnergy',prec_Sigma, &
            (/'no_e','no_e','ne  ','nkpt'/), compress_lvl = cmp_lvl, &
            atts = dic , chunks = (/i,i,1,1/) )
       call delete(dic)

       call ncdf_put_var(grp,'Eta',Elecs(iEl)%Eta)
       call ncdf_put_var(grp,'Accuracy',Elecs(iEl)%accu)
       call ncdf_put_var(grp,'pivot',Elecs(iEl)%o_inD%r)

    end do

    call ncdf_close(ncdf)

  end subroutine init_Sigma_save

  subroutine state_Sigma_save(fname, ikpt, nE, N_Elec, Elecs,nzwork,zwork)

    use parallel, only : Node, Nodes

    use netcdf_ncdf, ncdf_parallel => parallel
#ifdef MPI
    use mpi_siesta, only : MPI_COMM_WORLD, MPI_Gather
    use mpi_siesta, only : MPI_Send, MPI_Recv, MPI_DOUBLE_COMPLEX
    use mpi_siesta, only : MPI_Integer, MPI_STATUS_SIZE
    use mpi_siesta, only : Mpi_double_precision
#endif
    use m_ts_electype

    ! The file name we save too
    character(len=*), intent(in) :: fname
    integer, intent(in) :: ikpt
    type(tNodeE), intent(in) :: nE
    integer, intent(in) :: N_Elec
    type(Elec), intent(in) :: Elecs(N_Elec)
    integer, intent(in) :: nzwork
    complex(dp), intent(inout), target :: zwork(nzwork)

    type(hNCDF) :: ncdf, grp
    integer :: iEl, i, iN
#ifdef MPI
    complex(dp), pointer :: Sigma(:)
    integer :: MPIerror, status(MPI_STATUS_SIZE)
#endif

    if ( .not. sigma_save ) return

#ifdef NCDF_PARALLEL
    if ( sigma_parallel ) then
       call ncdf_open(ncdf,fname, mode=NF90_WRITE, &
            comm = MPI_COMM_WORLD )
    else
#endif
       call ncdf_open(ncdf,fname, mode=NF90_WRITE)
#ifdef NCDF_PARALLEL
    end if
#endif

    ! Save the energy-point
    if ( parallel_io(ncdf) ) then
       if ( nE%iE(Node) > 0 ) then
          call ncdf_put_var(ncdf,'E',nE%E(Node),start = (/nE%iE(Node)/) )
       end if
    else
       do iN = 0 , Nodes - 1
          if ( nE%iE(iN) <= 0 ) cycle
          call ncdf_put_var(ncdf,'E',nE%E(iN),start = (/nE%iE(iN)/) )
       end do
    end if

#ifdef MPI
    if ( .not. sigma_parallel .and. Nodes > 1 ) then
       i = 0
       do iEl = 1 , N_Elec
          i = max(i,Elecs(iEl)%o_inD%n)
       end do
       Sigma => zwork(1:i**2)
       if ( i**2 > nzwork ) then
          call die('Could not re-use the work array for Sigma &
               &communication.')
       end if
    end if
#endif

    do iEl = 1 , N_Elec
       
       call ncdf_open_grp(ncdf,trim(Elecs(iEl)%name),grp)

       i = Elecs(iEl)%o_inD%n
       if ( nE%iE(Node) > 0 ) then
          call ncdf_put_var(grp,'SelfEnergy', &
               reshape(Elecs(iEl)%Sigma(1:i*i),(/i,i/)), &
               start = (/1,1,nE%iE(Node),ikpt/) )
       end if

#ifdef MPI
       if ( .not. sigma_parallel .and. Nodes > 1 ) then
          if ( Node == 0 ) then
             do iN = 1 , Nodes - 1
                if ( nE%iE(iN) <= 0 ) cycle
                call MPI_Recv(Sigma,i*i,MPI_Double_Complex,iN,iN, &
                     Mpi_comm_world,status,MPIerror)
                call ncdf_put_var(grp,'SelfEnergy',reshape(Sigma(1:i*i),(/i,i/)), &
                     start = (/1,1,nE%iE(iN),ikpt/) )
             end do
          else if ( nE%iE(Node) > 0 ) then
             call MPI_Send(Elecs(iEl)%Sigma(1),i*i,MPI_Double_Complex,0,Node, &
                  Mpi_comm_world,MPIerror)
          end if
       end if
#endif

    end do

    call ncdf_close(ncdf)
    
  end subroutine state_Sigma_save

  subroutine state_Sigma2mean(fname,N_Elec,Elecs)

    use parallel, only : IONode

    use dictionary
    use netcdf_ncdf, ncdf_parallel => parallel
#ifdef MPI
    use mpi_siesta, only : MPI_COMM_WORLD, MPI_Gather
    use mpi_siesta, only : MPI_Send, MPI_Recv, MPI_DOUBLE_COMPLEX
    use mpi_siesta, only : MPI_Integer, MPI_STATUS_SIZE
    use mpi_siesta, only : Mpi_double_precision
    use mpi_siesta, only : MPI_Barrier
#endif
    use m_ts_electype

    ! The file name we save too
    character(len=*), intent(in) :: fname
    integer, intent(in) :: N_Elec
    type(Elec), intent(in) :: Elecs(N_Elec)

    type(dict) :: dic
    type(hNCDF) :: ncdf, grp
    integer :: iEl, iE, ikpt
    integer :: NE, nkpt, no_e
    real(dp), allocatable :: rwkpt(:)
    complex(dp), allocatable :: c2(:,:)
    complex(dp), pointer :: Sigma(:,:)

#ifdef MPI
    integer :: MPIerror
#endif

    ! If we should not save the mean, we return immediately.
    if ( .not. sigma_save ) return
    if ( .not. sigma_mean_save ) return

    if ( .not. IONode ) then
#ifdef MPI
       call MPI_Barrier(Mpi_comm_world,MPIerror)
#endif
       return
    end if

    ! We do this on one processor
    call ncdf_open(ncdf,fname, mode=NF90_WRITE)

    ! We read in the dimensions
    call ncdf_inq_dim(ncdf,'ne',len=NE)
    call ncdf_inq_dim(ncdf,'nkpt',len=nkpt)

    ! Allocate space
    allocate(rwkpt(nkpt))
    call ncdf_get_var(ncdf,'wkpt',rwkpt)

    ! When taking the mean of self-energies
    ! we need the transpose, hence we need half the
    ! contribution from Sigma and Sigma^T
    rwkpt(:) = 0.5_dp * rwkpt(:)

    ! Loop over all electrodes
    do iEl = 1 , N_Elec

       ! We need to extend the netcdf file with the SigmaMean
       ! variable

       call ncdf_open_grp(ncdf,trim(Elecs(iEl)%name),grp)

       ! Get size of Sigma
       call ncdf_inq_dim(grp,'no_e',len=no_e)

       dic = ('info'.kv.'Down-folded self-energy, k-averaged')
       dic = dic//('unit'.kv.'Ry')
       ! Chunking greatly reduces IO cost
       call ncdf_def_var(grp,'SigmaMean',NF90_DOUBLE_COMPLEX, &
            (/'no_e','no_e','ne  '/), chunks = (/no_e,no_e,1/) , &
            atts = dic ,compress_lvl = cmp_lvl )
       call delete(dic)

       ! Allocate space for the self-energy mean
       allocate(c2(no_e,no_e))

       ! Point the sigma
       ! This is a hack to ease the processing
       call pass2pnt(no_e,Elecs(iEl)%Sigma(1:no_e**2),Sigma)

       ! loop over all energy points
       do iE = 1 , NE

          do ikpt = 1 , nkpt

             ! Loop over k-points to average
             call ncdf_get_var(grp,'SelfEnergy',Sigma, &
                  start=(/1,1,iE,ikpt/) )
             
             if ( ikpt == 1 ) then
                c2(:,:) = rwkpt(ikpt) * ( &
                     Sigma + transpose(Sigma) &
                     )
             else
                c2(:,:) = c2(:,:) + rwkpt(ikpt) * ( &
                     Sigma + transpose(Sigma) &
                     )
             end if
             
          end do

          call ncdf_put_var(grp,'SelfEnergyMean',c2, start=(/1,1,iE/) )

       end do

       deallocate(c2)

    end do

    deallocate(rwkpt)
    
    call ncdf_close(ncdf)

#ifdef MPI
    call MPI_Barrier(Mpi_comm_world,MPIerror)
#endif

  end subroutine state_Sigma2mean

  subroutine pass2pnt(no,Sigma,new_pnt)
    integer :: no
    complex(dp), target :: Sigma(no,no)
    complex(dp), pointer :: new_pnt(:,:)
    new_pnt => Sigma(:,:)
  end subroutine pass2pnt

#endif

end module m_tbt_sigma_save

  

