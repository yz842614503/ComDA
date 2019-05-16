! �y��̌v�Z ... �ϕ��܂�
! 99/07/12 �ۍ␪�G  ����
! 99/08/04 �ۍ␪�G ��򂳂�ɓn���o�[�W�����t�B�b�N�X
! 2000-09-13 �L�c�p�i �y�됅���������o�O�̒���
!                     -DDEBUG_PARANOIA ������Ɠy�됅���� 1 �𒴂��Ă悢
!                     �Ƃ���ł��������s��

      SUBROUTINE SOIL_MAIN  (
     I    NMAX      , NMAX_0      , NMAX_01     , 
     I    NTYP           , 
     I    DELT_SOIL      , 
     I    CVR_SNW        , CVR_SNW_NEXT   , 
     I    CVR_SNW_INV    , CVR_NOS_INV    , 
     I    CVR_SNW_INV_NEXT ,  CVR_NOS_INV_NEXT ,  
     I    HDF_SOIL_H     , HDF_SNSL_H      , 
     I    ENG_BUCKET_NOS , ENG_BUCKET_SNOW_TO_SNSL  , 
     I    WTR_BUCKET_INTO_SOIL     , ENH_BUCKET_INTO_SOIL , 
     I    H2O_BUCKET_FROM_SOIL     , ENH_BUCKET_FROM_SOIL , 
     I    WTR_BUCKET_SNOW_TO_SNSL  , ENH_BUCKET_SNOW_TO_SNSL   , 
     I    TRNS_BUCKET_NOS          , TRNS_BUCKET_SNW        , 
     I    INFO_SNOW_NEXT , 
     M    TMP_SOIL_PROG   , TMP_SNSL_PROG   ,      ! �\��ϐ� : ���x
     M    FR_WTR_SOIL_PROG, FR_WTR_SNSL_PROG,      ! �\��ϐ� : ���̊���
     M    FR_GLA_SOIL_PROG, FR_GLA_SNSL_PROG,      ! �\��ϐ� : �X�̊���
     M    TMP_SOIL4_PROG  ,
     O    RUNOFF )
!
! ���Ă��Ȃ�����
!
!   �E�M�`���W���v�Z
!        ... ��Ƃ�����ނ̂ŁA���̑O��
!
! �y��Ɋւ���S�̓I�Ȓ���
!   �E�y�뒆�ł͐����X�ɂȂ�Ƃ��ɁA�̐ς��������Ăق����Ȃ��B
!     �����œy�뒆�̐ς��玿�ʂɊ��Z����ۂ̖��x�Ƃ��Ă� 
!     RHO_GLA_c �͎g�킸�ARHO_WTR_c ��p����B
!     ������
!         ��M���g���̐ς���G�l���M�[���Z����ꍇ
!         ���M�W�����g���̐ς���G�l���M�[���Z����ꍇ
!         ( �M�`���W���̌v�Z ? )
!     �� RHO_GLA_c/RHO_WTR_c �ł��� RHO_FAC_GW �����������̂��g��������
!     �����̂����m��Ȃ��B
!     �܂�
!        ��M     CAP_GLA_c �̂����� 
!           CAP_GLA_GW_c ( CAP_WTR_c �̌��?? �ۍ� 01/09/20 )���g��
!        ���M�W�� HL_W2G_c    �̂�����
!           HL_GLA_GW    ( ??  �ۍ� 01/09/20 )���g��
!     ���������̂����m��Ȃ��B
!     �ƈ�u�v�������A��M�E���M�W���ł͂��̕K�v�͂Ȃ��C������B
!     ��肪����Ƃ���ΔM�`���W����?
!     ���̂�����͂�����ƃy���f�B���O���āACAP_GLA_c ���g���Ă��܂��B
!
! �� ��[����̓��͗ʂ͂�������A�i�q���ϒl�ł���B
!      * CVR_SNW , �܂��� * CVR_NOS ���ꂽ�l�ł��邱�Ƃɒ���
!
      USE SIBPRM , ONLY :
     1    IDX   , 
     1    IDP   ,
     1    ITYP 
!
      USE COM_RUNCONF_SIB0109 , ONLY : 
     1    JCN_SOIL_HEAT_EXPLICIT       ! implicit -> 0 , explicit -> 1 
!
      IMPLICIT NONE
!
      INTEGER,INTENT(IN)    :: NMAX 
      INTEGER,INTENT(IN)    :: NMAX_0 (3) 
      INTEGER,INTENT(IN)    :: NMAX_01(3) 
!
      INTEGER,INTENT(IN)    :: NTYP           (IDX)     ! �A���^�C�v
!
      REAL(8),INTENT(IN)    :: DELT_SOIL                ! �y��p���ԍ�
!
      REAL(8),INTENT(IN)    :: HDF_SOIL_H   (IDX,IDP) ! �M�`���W��
      REAL(8),INTENT(IN)    :: HDF_SNSL_H   (IDX,IDP)
!
      REAL(8),INTENT(IN)    :: CVR_SNW       (IDX)          ! ��ʔ핢��
      REAL(8),INTENT(IN)    :: CVR_SNW_INV   (IDX)          ! ��ʔ핢��
      REAL(8),INTENT(IN)    :: CVR_NOS_INV   (IDX)          ! ��ʔ핢��
      REAL(8),INTENT(IN)    :: CVR_SNW_NEXT  (IDX)          ! ��ʔ핢��
      REAL(8),INTENT(IN)    :: CVR_NOS_INV_NEXT (IDX)
      REAL(8),INTENT(IN)    :: CVR_SNW_INV_NEXT (IDX)
!
      REAL(8),INTENT(IN)    :: ENG_BUCKET_NOS (IDX)         ! ��[�ɓ���M��
      REAL(8),INTENT(IN)    :: ENG_BUCKET_SNOW_TO_SNSL(IDX) ! 
!
      REAL(8),INTENT(IN)    :: WTR_BUCKET_INTO_SOIL   (IDX) ! ��[�ɓ��鐅��
      REAL(8),INTENT(IN)    :: H2O_BUCKET_FROM_SOIL   (IDX) ! ��[����o�鐅��
      REAL(8),INTENT(IN)    :: WTR_BUCKET_SNOW_TO_SNSL(IDX)
      REAL(8),INTENT(IN)    :: ENH_BUCKET_INTO_SOIL   (IDX) ! ��[������鐅E
      REAL(8),INTENT(IN)    :: ENH_BUCKET_FROM_SOIL   (IDX) ! 
      REAL(8),INTENT(IN)    :: ENH_BUCKET_SNOW_TO_SNSL(IDX)
!
      REAL(8),INTENT(IN)    :: TRNS_BUCKET_NOS       (IDX,IDP) ! ���U
      REAL(8),INTENT(IN)    :: TRNS_BUCKET_SNW       (IDX,IDP) ! 
!
!
      REAL(8),INTENT(INOUT) :: TMP_SOIL_PROG   (IDX,IDP)  ! ���x
      REAL(8),INTENT(INOUT) :: TMP_SNSL_PROG   (IDX,IDP)
      REAL(8),INTENT(INOUT) :: FR_WTR_SOIL_PROG(IDX,IDP)  ! �󌄒��̐��̔䗦
      REAL(8),INTENT(INOUT) :: FR_WTR_SNSL_PROG(IDX,IDP)
      REAL(8),INTENT(INOUT) :: FR_GLA_SOIL_PROG(IDX,IDP)  ! �X�̔䗦
      REAL(8),INTENT(INOUT) :: FR_GLA_SNSL_PROG(IDX,IDP)
!
      REAL(8),INTENT(INOUT) :: TMP_SOIL4_PROG  (IDX)
!
      INTEGER,INTENT(IN) :: INFO_SNOW_NEXT      (IDX) 
!
! OUTPUT
!

      REAL(8),INTENT(OUT)   :: RUNOFF         (IDX)      ! �����I�t
!
!
! WORK ( NOS/SNW �� )
!
      REAL(8)    :: ENG_SOIL_NOS  (IDX,IDP)  ! �w�̃G�l���M�[
      REAL(8)    :: ENG_SOIL_SNW  (IDX,IDP)
      REAL(8)    :: H2O_SOIL_NOS  (IDX,IDP)  ! �w�� H2O 
      REAL(8)    :: H2O_SOIL_SNW  (IDX,IDP)
!
      REAL(8)    :: ENG_SOIL_NEXT (IDX,IDP)  ! �w�̃G�l���M�[
      REAL(8)    :: H2O_SOIL_NEXT (IDX,IDP)
      REAL(8)    :: ENG_SNSL_NEXT (IDX,IDP)  ! �w�� H2O 
      REAL(8)    :: H2O_SNSL_NEXT (IDX,IDP)
!
      REAL(8)    :: RUNOFF_S_NOS  (IDX)      ! �����I�t(���t���b�N�X)
      REAL(8)    :: RUNOFF_S_SNW  (IDX)
      REAL(8)    :: RUNOFF_B_NOS  (IDX)
      REAL(8)    :: RUNOFF_B_SNW  (IDX)
!
! WORK ( NOS/SNW �g���� )
!
      REAL(8)    :: TMP_SOIL       (IDX,IDP)  ! �y�뉷�x 
      REAL(8)    :: FR_WTR_SOIL    (IDX,IDP)  ! ���̔䗦 
      REAL(8)    :: FR_GLA_SOIL    (IDX,IDP)  ! �X�̔䗦 
!
      REAL(8)    :: SIB_MTX_SOIL(IDX,IDP,IDP+1)
      REAL(8)    :: CAP_SOIL    (IDX,IDP)    ! �M�e��    
      REAL(8)    :: CAP_SOIL_INV(IDX,IDP)    
!
      REAL(8)    :: PHASE_SOIL  (IDX,IDP)    ! ��x 0 �� 1
      REAL(8)    :: HEAT_CONV   (IDX,IDP+1)  ! �w������M�t���b�N�X����
      REAL(8)    :: HFLUX_H     (IDX,0:IDP)  ! 
!
      REAL(8)    :: WFLUX_H     (IDX,IDP)  ! ���t���b�N�X 
      REAL(8)    :: WTR_INC     (IDX,IDP)  ! ���t���b�N�X���� * DELT  
!
      REAL(8)    :: TMP_SOIL4_N (IDX)      ! 
      REAL(8)    :: TMP_SOIL4_S (IDX)      ! 
!
! WORK ( �萔�I�ϐ� ) 
!
      REAL(8)    :: CAP_SOLID     (IDX,IDP)    ! �ő̓y�̔�M
      REAL(8)    :: FACT_WGT_H2O  (IDX,IDP)    ! �󌄗�x���̔�d
!                                              ! ����X�̊�����������Ǝ��ʂ�
      REAL(8)    :: FACT_WGT_H2O_INV (IDX,IDP) ! �󌄗� x ���̔�d�̋t��
!
      REAL(8)    :: DELT_SOIL_INV 
!
#ifdef SIB_DEBUG
      INTEGER    :: I , K
#endif
!
! ���̑�
!
      REAL(8),PARAMETER :: DUMMY_IDX      (IDX) = 0.
!
      LOGICAL,SAVE :: LFIRST
      DATA LFIRST / .TRUE. /
!
      IF ( LFIRST ) THEN 
        WRITE(6,*) 'SOIL_MAIN 99/08 POCHAKA'
        LFIRST = .FALSE. 
      ENDIF
!
      DELT_SOIL_INV = 1/DELT_SOIL
!
! ==========
! >> ���� <<
! ==========
!
! ���ʂ̃��Z�b�g
!
      CALL RESET ( ENG_SOIL_NOS , IDX*IDP )
      CALL RESET ( ENG_SOIL_SNW , IDX*IDP )
      CALL RESET ( H2O_SOIL_NOS , IDX*IDP )
      CALL RESET ( H2O_SOIL_SNW , IDX*IDP )
!
      RUNOFF_S_NOS(:) = 0.
      RUNOFF_B_NOS(:) = 0.
      RUNOFF_S_SNW(:) = 0.
      RUNOFF_B_SNW(:) = 0.
!
      TMP_SOIL4_N (:) = 0.
      TMP_SOIL4_S (:) = 0.
!
!   ��M�Ƌ󌄗ʂ̌v�Z
!
      CALL SOIL_PRE_1 (
     I    NMAX            , NTYP       , 
     O    FACT_WGT_H2O     , 
     O    FACT_WGT_H2O_INV ,     
     O    CAP_SOLID      )
!
! ==============
! >> �ᖳ���� <<
! ==============
!
      BARESOIL_GRIDS: IF (NMAX_01(3) > 0) THEN
!
      CALL SOIL_PRE_2 (
     I    1              , NMAX_01(3)        , 0       , 
     I    1              , NMAX_0(3)         , 
     I    CVR_NOS_INV    ,  NTYP             , 
     I    TMP_SOIL_PROG  , TMP_SOIL4_PROG   ,
     I    FR_WTR_SOIL_PROG , 
     I    FR_GLA_SOIL_PROG, 
     I    FACT_WGT_H2O   , FACT_WGT_H2O_INV , 
     I    CAP_SOLID      , 
     I    DELT_SOIL      , 
     I    WTR_BUCKET_INTO_SOIL    , ENH_BUCKET_INTO_SOIL    , 
     I    WTR_BUCKET_SNOW_TO_SNSL , ENH_BUCKET_SNOW_TO_SNSL , !��Ȃ���̂�
     I    H2O_BUCKET_FROM_SOIL    , ENH_BUCKET_FROM_SOIL    , 
     I    TRNS_BUCKET_NOS  , 
     O    TMP_SOIL       , TMP_SOIL4_N   ,
     O    FR_WTR_SOIL    , FR_GLA_SOIL   , 
     O    CAP_SOIL       , CAP_SOIL_INV  , 
     O    ENG_SOIL_NOS   , H2O_SOIL_NOS  , 
     O    PHASE_SOIL     , RUNOFF_S_NOS      ) 
!
! ------------
! > �M�̌v�Z <  �C���v���V�b�g�̏ꍇ
! ------------
!
      BARESOIL_IMPLICIT: IF ( JCN_SOIL_HEAT_EXPLICIT.EQ.0 ) THEN
!
!   �M�̕������𗧂Ă� 
!
        CALL SOIL_HFLUX_IMPLICIT_EQSET (
     I  1                , NMAX_01(3)          , 
#ifdef MONYOS
     I  0                ,
#endif
     I  CVR_NOS_INV      , 
     I  TMP_SOIL         , TMP_SOIL4_N         , 
     I  PHASE_SOIL       , 
     I  CAP_SOIL         , 
     I  HDF_SOIL_H       , 
     I  ENG_BUCKET_NOS   , 
     I  DELT_SOIL        , DELT_SOIL_INV       ,
     O  SIB_MTX_SOIL     , HFLUX_H    )
!
!   �M�̕����������� 
!
        CALL SOIL_HFLUX_IMPLICIT_EQSLV (
     I  1            , NMAX_01(3)     , 
     M  SIB_MTX_SOIL   )
!
!   �M�̃t���b�N�X������ 
!     �����͏�[�������A�M�o�P�c�ɓ����Ă����G�l���M�[
!      ���ƕX�̗ʂ͕ς��Ȃ��Ƃ��āA�M�����ʂ��v�Z����B
!
        CALL SOIL_HFLUX_IMPLICIT_CONV (
     I  1               , NMAX_01(3)      , 
#ifdef MONYOS
     I  0               ,
#endif
     I  SIB_MTX_SOIL    , 
     I  HDF_SOIL_H      , 
     I  PHASE_SOIL      , 
     I  DELT_SOIL       ,  
     M  HFLUX_H         ,  
     O  HEAT_CONV    )  
!
! ------------
! > �M�̌v�Z <  �C�N�X�v���V�b�g�̏ꍇ
! ------------
!
      ELSE BARESOIL_IMPLICIT
!
        CALL SOIL_HFLUX_EXPLICIT (
     I  1                , NMAX_01(3)          , 
#ifdef MONYOS
     I  0                ,
#endif
     I  CVR_NOS_INV      , 
     I  TMP_SOIL         , TMP_SOIL4_N         ,  
     I  HDF_SOIL_H       , 
     I  ENG_BUCKET_NOS   , 
     I  DELT_SOIL        , DELT_SOIL_INV       ,
     O  HEAT_CONV )

      ENDIF BARESOIL_IMPLICIT
!
! ----------------------------
! > ���̃t���b�N�X���������� <
! ----------------------------
!    ���������̐���X���y��ɑ��݂��Ȃ��ꍇ�ɑ[�u���{���B
!    ���v�ł͑��݂���Ȃ�΁A���ω����N��������B
!    �i����ǂ�������݂��Ȃ��Ȃ�A�d�����Ȃ��̂ŊO����^����B�j    
!
! ------------------------
! > ���̃t���b�N�X������ <
! ------------------------
!    �����͏�Ƃ̂��Ƃ�A���U�B
!    ���̈ړ��t���b�N�X�������B
!
      CALL SOIL_WFLUX (
     I   1               , NMAX_01(3)      , 
     I   0               ,                       ! INSFLAG = 0 ���, 1 ��
     I   FR_WTR_SOIL     , 
     I   FR_GLA_SOIL     , 
     I   FACT_WGT_H2O    , 
     I   DELT_SOIL       , 
     I   NTYP            , 
     I   TMP_SOIL        , 
     O   WFLUX_H         , WTR_INC ) 
!
! ------------------------
! > �t���b�N�X�����̊m�� <
! ------------------------
!  ENG �� H2O �̐ϕ������Ă���!! 
!
      CALL SOIL_FLUX_CONV (
     I   1             , NMAX_01(3)    , DELT_SOIL     , 
#ifdef MONYOS
     I   0             ,
#endif
     I   HEAT_CONV     , 
     I   WFLUX_H       , WTR_INC      , 
     I   CAP_SOIL_INV  , 
     I   TMP_SOIL      , 
     M   ENG_SOIL_NOS  , H2O_SOIL_NOS , TMP_SOIL4_N  ,  
     O   RUNOFF_B_NOS) 
!
      ENDIF BARESOIL_GRIDS
!
! ====================
! >> �Ⴀ���̌v�Z <<
! ====================
!
      SNOW_GRIDS: IF ( NMAX_0(1) .LT. NMAX ) THEN
!
      CALL SOIL_PRE_2 (
     I    NMAX_01(2)    , NMAX         , 1   , 
     I    0              , 0              ,           ! �_�~�[
     I    CVR_SNW_INV   ,  NTYP , 
     I    TMP_SNSL_PROG    , TMP_SOIL4_PROG , 
     I    FR_WTR_SNSL_PROG , 
     I    FR_GLA_SNSL_PROG , 
     I    FACT_WGT_H2O   , FACT_WGT_H2O_INV   , CAP_SOLID  , 
     I    DELT_SOIL         ,
     I    WTR_BUCKET_SNOW_TO_SNSL , ENH_BUCKET_SNOW_TO_SNSL , ! �����ϐ��̂�
     I    DUMMY_IDX      , DUMMY_IDX         , 
     I    DUMMY_IDX      , DUMMY_IDX         , 
     I    TRNS_BUCKET_SNW  , 
     O    TMP_SOIL         , TMP_SOIL4_S    ,
     O    FR_WTR_SOIL      , FR_GLA_SOIL    , 
     O    CAP_SOIL         , CAP_SOIL_INV   , 
     O    ENG_SOIL_SNW     , H2O_SOIL_SNW   , 
     O    PHASE_SOIL       , RUNOFF_S_SNW ) 

#ifdef DEBUG_PARANOIA
      ! ��1�w�̐������`�F�b�N
      CALL TEST_H2O(
     I  CVR_SNW_INV_NEXT(1:NMAX), FACT_WGT_H2O(1:NMAX, 1),
     I  H2O_SOIL_SNW(1:NMAX, 1), 'soil_pre_2 result SNW')
#endif

! ------------
! > �M�̌v�Z <  �C���v���V�b�g�̏ꍇ
! ------------
!
      SNOW_IMPLICIT: IF ( JCN_SOIL_HEAT_EXPLICIT.EQ.0 ) THEN

!  �M�̕������𗧂Ă� 
!
        CALL SOIL_HFLUX_IMPLICIT_EQSET (
     I  NMAX_01(2)       , NMAX                , 
#ifdef MONYOS
     I  1                ,
#endif
     I  CVR_SNW_INV      , 
     I  TMP_SOIL         , TMP_SOIL4_S         ,  
     I  PHASE_SOIL       , 
     I  CAP_SOIL         , 
     I  HDF_SNSL_H       , 
     I  ENG_BUCKET_SNOW_TO_SNSL   , 
     I  DELT_SOIL        , DELT_SOIL_INV       , 
     O  SIB_MTX_SOIL     , HFLUX_H        )
!
!  �M�̕����������� 
!
        CALL SOIL_HFLUX_IMPLICIT_EQSLV (
     I  NMAX_01(2)       , NMAX            , 
     M  SIB_MTX_SOIL   )
!
!  �M�̃t���b�N�X������ 
!
        CALL SOIL_HFLUX_IMPLICIT_CONV (
     I  NMAX_01(2)      , NMAX            , 
#ifdef MONYOS
     I  1               ,
#endif
     I  SIB_MTX_SOIL    , 
     I  HDF_SNSL_H      , 
     I  PHASE_SOIL      , 
     I  DELT_SOIL       , 
     M  HFLUX_H         , 
     O  HEAT_CONV    )  
!
! ------------
! > �M�̌v�Z <  �C�N�X�v���V�b�g�̏ꍇ
! ------------
!
      ELSE SNOW_IMPLICIT

        CALL SOIL_HFLUX_EXPLICIT (
     I  NMAX_01(2)       , NMAX                , 
#ifdef MONYOS
     I  1                ,
#endif
     I  CVR_SNW_INV      , 
     I  TMP_SOIL         , TMP_SOIL4_S         , 
     I  HDF_SNSL_H       ,
     I  ENG_BUCKET_SNOW_TO_SNSL   , 
     I  DELT_SOIL        , DELT_SOIL_INV       , 
     O  HEAT_CONV   )

      ENDIF SNOW_IMPLICIT
!
! ------------------------
! > ���̃t���b�N�X������ <
! ------------------------
!
      CALL SOIL_WFLUX (
     I   NMAX_01(2)      , NMAX            , 
     I   1               ,                       ! INSFLAG = 0 ��� , 1 �� 
     I   FR_WTR_SOIL     , 
     I   FR_GLA_SOIL     , 
     I   FACT_WGT_H2O    , 
     I   DELT_SOIL       , 
     I   NTYP            , 
     I   TMP_SOIL        , 
     O   WFLUX_H         , WTR_INC   )

#ifdef DEBUG_PARANOIA
      ! ��1�w�̐������`�F�b�N
      CALL TEST_H2O(
     I  CVR_SNW_INV_NEXT(1:NMAX), FACT_WGT_H2O(1:NMAX, 1),
     I  H2O_SOIL_SNW(1:NMAX, 1), 'soil_flux_conv entry SNW')
#endif

! ------------------------
! > �t���b�N�X�����̊m�� <
! ------------------------
!  ENG �� H2O �̐ϕ������Ă���!! 
!
      CALL SOIL_FLUX_CONV (
     I   NMAX_01(2)    , NMAX          , DELT_SOIL     , 
#ifdef MONYOS
     I   1             ,
#endif
     I   HEAT_CONV     , 
     I   WFLUX_H       , WTR_INC       , 
     I   CAP_SOIL_INV  , 
     I   TMP_SOIL      , 
     M   ENG_SOIL_SNW  , H2O_SOIL_SNW  ,  TMP_SOIL4_S  ,  
     O   RUNOFF_B_SNW) 
!

#ifdef DEBUG_PARANOIA
      ! ��1�w�̐������`�F�b�N
      CALL TEST_H2O(
     I  CVR_SNW_INV_NEXT(1:NMAX), FACT_WGT_H2O(1:NMAX, 1),
     I  H2O_SOIL_SNW(1:NMAX, 1), 'soil_flux_conv result SNW')
#endif

      ENDIF SNOW_GRIDS
!
!  ============
!  >> �㏈�� <<
!  ============
!
!  --------------------------------
!  > �Ⴀ��E������̒P�����Ϗ��� <
!  --------------------------------
!   �K�v�Ȃ̂��ǂ���������Ȃ����A�Ƃ肠��������Ă����B
!   00/08/16 ���݂̓����I�t�݂̂����A
!   ������̓��j�^�p�f�[�^�쐬�̂��߂ɁA
!   ��葽���̕ϐ��łȂ���邱�ƂɂȂ낤�B
!
!   �y��� 4 �w�̉��x�̐ϕ��͂����ł������ƂɂȂ��Ă���
!
      CALL SOIL_AREA_MEAN (
     I   NMAX          , 
     I   CVR_SNW       , 
     I   RUNOFF_B_NOS  , RUNOFF_B_SNW  , 
     I   RUNOFF_S_NOS  , RUNOFF_S_SNW  , 
     I   TMP_SOIL4_N   , TMP_SOIL4_S   , 
     O   RUNOFF        , TMP_SOIL4_PROG ) 
!
! --------------------------
! > CVR_SNW �ύX�ɔ����␳ <
! --------------------------
!
!   �E�Ⴀ��Ȃ��拤�ʂł���� 4 �w�ɂ��Ă��A
!     �ڍ׃��j�^�ł́A��핢���ɔ����ᖳ����ƐႠ���Ƃ̔M�̂��Ƃ�
!     �����j�^
!
!   �E�� 1-3 �w�ɂ��ẮA*_SNW �� *_NOS ���� *_NEXT ���쐬
!     ���̂Ƃ���핢���̕ω����l������B
!     �Ⴆ�Δ핢���������́A�ᖳ����̓y��̔M�E���̈ꕔ��Ⴀ���ɉ��Z 
!     �ڍ׃��j�^�ł��A���̂��Ƃ�����j�^����
!
      CALL SOIL_SNOWCVR_MOD (
     I   NMAX             , 
     I   CVR_SNW          , CVR_SNW_NEXT     , 
     I   CVR_NOS_INV_NEXT , CVR_SNW_INV_NEXT , 
     I   H2O_SOIL_SNW     , H2O_SOIL_NOS     ,
     I   ENG_SOIL_SNW     , ENG_SOIL_NOS     , 
     I   TMP_SOIL4_PROG   , 
     O   H2O_SOIL_NEXT    , H2O_SNSL_NEXT    ,
     O   ENG_SOIL_NEXT    , ENG_SNSL_NEXT     )

#ifdef DEBUG_PARANOIA
      ! ��1�w�̐������`�F�b�N
      CALL TEST_H2O(
     I  CVR_NOS_INV_NEXT(1:NMAX), FACT_WGT_H2O(1:NMAX, 1),
     I  H2O_SOIL_NEXT(1:NMAX, 1), 'soil_snowcvr_mod result NOS')
      CALL TEST_H2O(
     I  CVR_SNW_INV_NEXT(1:NMAX), FACT_WGT_H2O(1:NMAX, 1),
     I  H2O_SNSL_NEXT(1:NMAX), 'soil_snowcvr_mod result SNW')
#endif
!
! ----------------------
! > �y��\��ϐ��̌v�Z <
! ----------------------
!   �E�M�� H2O �̖����l����A�y�뉷�x�Ɠy��t���E�X�̊����̖����l���Z�o 
!
      CALL SOIL_INTG (
     I   NMAX               , 
     I   FACT_WGT_H2O_INV   , CAP_SOLID         ,
     I   INFO_SNOW_NEXT     , 
     I   H2O_SOIL_NEXT      , H2O_SNSL_NEXT     ,
     I   ENG_SOIL_NEXT      , ENG_SNSL_NEXT     , 
     O   TMP_SOIL_PROG      , TMP_SNSL_PROG     , 
     O   FR_WTR_SOIL_PROG   , FR_WTR_SNSL_PROG  , 
     O   FR_GLA_SOIL_PROG   , FR_GLA_SNSL_PROG ) 

#ifdef DEBUG_PARANOIA
      ! ��1�w�̐������`�F�b�N
      CALL TEST_FRW(
     I  CVR_NOS_INV_NEXT(1:NMAX), FR_WTR_SOIL_NEXT(1:NMAX, 1),
     I  FR_GLA_SOIL_NEXT(1:NMAX, 1), 'soil_intg result NOS')
      CALL TEST_FRW(
     I  CVR_SNW_INV_NEXT(1:NMAX), FR_WTR_SNSL_NEXT(1:NMAX,1),
     I  FR_GLA_SNSL_NEXT(1:NMAX), 'soil_intg result SNW')
#endif

! --------------
! > �y��̕␳ <
! --------------
!   �E�y�됅�����Ȃ�����Ƃ��A�X����������Ƃ��ɕ␳����B 
!     00/08/16 ���݁A�n�O�Ƃ��Ƃ肷��i���Ƃ�ʂ����j�^�j
!
!   �E���x�A�X/����͕ς��Ȃ�
!     # ���̂悤�ɂ������̂ŁAsoil_intg ���ɍs�Ȃ��Ă���B
!
!   �ECVR_SNW �̕ύX�ɔ����␳�͂����ł͍s��Ȃ��B( soil_snowcvr_mod �ł��� ) 
!
      CALL SOIL_MOD (
     I   NMAX             , 
     I   FACT_WGT_H2O     , INFO_SNOW_NEXT   , 
     M   TMP_SOIL_PROG    , TMP_SNSL_PROG    , 
     M   FR_WTR_SOIL_PROG , FR_WTR_SNSL_PROG , 
     M   FR_GLA_SOIL_PROG , FR_GLA_SNSL_PROG ) 
!
#ifdef SIB_DEBUG
      DO K=1,IDP
      DO I=1,NMAX
        IF (       TMP_SOIL_PROG(I,K) .LT. 150 
     1       .AND. INFO_SNOW_NEXT(I)  .LE. 0   ) THEN
          write (6,*) 'SOIL_MAIN ERROR 1' , I,K,TMP_SOIL_PROG(I,K), 
     1                 INFO_SNOW_NEXT(I),NMAX_0(3),NMAX_01(3) 
          stop 999
        ENDIF
      ENDDO
!
      DO I=1,NMAX
        IF (       TMP_SNSL_PROG(I,K) .LT. 150 
     1       .AND. INFO_SNOW_NEXT(I)  .GE. 0   ) THEN
          write (6,*) 'SOIL_MAIN ERROR 2' , I,K,TMP_SNSL_PROG(I,K) ,
     1                 INFO_SNOW_NEXT(I),NMAX_0(3),NMAX_01(3) 
          stop 999
        ENDIF
      ENDDO
      ENDDO
#endif


#ifdef DEBUG_PARANOIA
      ! ��1�w�̐������`�F�b�N
      CALL TEST_FRW(
     I  CVR_NOS_INV_NEXT(1:NMAX), FR_WTR_SOIL_PROG(1:NMAX, 1),
     I  FR_GLA_SOIL_PROG(1:NMAX, 1), 'soil_main ENDING NOS')
      CALL TEST_FRW(
     I  CVR_SNW_INV_NEXT(1:NMAX), FR_WTR_SNSL_PROG(1:NMAX),
     I  FR_GLA_SNSL_PROG(1:NMAX), 'soil_main ENDING SNW')
#endif

      RETURN

#ifdef DEBUG_PARANOIA
      CONTAINS

      ! �ϐ�핢���̋t���̕ϐ��� CVR_SNW �� 1 �܂��� 0 �ɋ߂��Ƃ���
      ! ������ɔ��U���Ȃ��悤�ɏ���������Ă���AInf �]���͂��Ȃ��B
      SUBROUTINE TEST_FRW(CVRSNW_INV, FRW, FRG, MSG)
        REAL(8), INTENT(IN):: CVRSNW_INV(:)
        REAL(8), INTENT(IN):: FRW(:)
        REAL(8), INTENT(IN):: FRG(:)
        CHARACTER(LEN = *), INTENT(IN):: MSG
        REAL(8):: TEST(SIZE(FRW))
        INTEGER:: I
      CONTINUE
        TEST(:) = CVRSNW_INV(:) * (FRW(:) + FRG(:))
        IF (ANY(TEST(:) > 1.0d0)) THEN
          WRITE(6, *) '#' // MSG // ': FRW+FRG > 1 FOR <',
     ,      PACK((/(I, I = 1, SIZE(TEST))/), (TEST(:) > 1.0d0)),
     ,      '> MAX AT', MAXLOC(TEST(:))
          WRITE(6, *) ' MAX(FRW + FRG) - 1 =', MAXVAL(TEST(:)) - 1.0d0
        ENDIF
      END SUBROUTINE TEST_FRW

      SUBROUTINE TEST_H2O(CVRSNW_INV, FACT_WGT_H2O, H2O, MSG)
        REAL(8), INTENT(IN):: CVRSNW_INV(:)
        REAL(8), INTENT(IN):: FACT_WGT_H2O(:)
        REAL(8), INTENT(IN):: H2O(:)
        CHARACTER(LEN = *), INTENT(IN):: MSG
        REAL(8):: TEST(SIZE(H2O))
        INTEGER:: I
      CONTINUE
        TEST(:) = CVRSNW_INV(:) * H2O(:) - FACT_WGT_H2O(:)
        IF (ANY(TEST(:) > 0.0d0)) THEN
          WRITE(6, *) '#' // MSG // ': H2O > SOIL CAPACITY'         
          WRITE(6, *) ' FOR', PACK((/(I, I = 1, SIZE(TEST))/), 
     ,      (TEST(:) > 0.0d0))
          WRITE(6, *) ' MAX EXCESS=', MAXVAL(TEST(:)), ' AT',
     ,      MAXLOC(TEST(:))
        ENDIF
      END SUBROUTINE TEST_H2O
#endif
! 20050517
! /* DEBUG_PARANOIA */

      END SUBROUTINE SOIL_MAIN