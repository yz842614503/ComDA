! ��̃��C���v���O����
! 99/07/11 �ۍ␪�G ����
! 99/07/15 �ۍ␪�G RHO_SNOW ��������
!                   �Ƃ肠���� rho_snow �̈�����A��Z���␳�͕ۗ��B
! 99/08/04 �ۍ␪�G ��򂳂�ɓn���o�[�W�����t�B�b�N�X
!
      SUBROUTINE SNOW_MAIN (
     I    NMAX     , NMAX_0     , NMAX_01    , NMAX_1     , 
     I    NMAX_2   , NMAX_3     , NMAX_4     , imsklt     , 
     I    CVR_SNW  , CVR_SNW_INV, DELT_SNOW  , DELT_CNP   ,
     I    DEP_SNOW , 
     I    HDF_SNOW_H , 
     I    H2O_BUCKET_INTO_SNOW  , H2O_BUCKET_FROM_SNOW    , 
     I    ENH_BUCKET_INTO_SNOW  , ENH_BUCKET_FROM_SNOW    , 
     I    ENG_BUCKET_SNW        , SRAD_BUCKET_SNW   , 
     I    ENG_SNOW_BUCKET       , H2O_SNOW_BUCKET         , 
     I    TMP_REF       , U_REF         , V_REF       ,   
     I    TMP_SNSK_NEXT , 
     I    ENG_SOIL_TOP  , 
     M    WTR_SNOW_PROG , GLA_SNOW_PROG   , TMP_SNOW_PROG   ,      
     M    AGE_SNOW_PROG , RHO_SNOW_INV_PROG     ,  
     M    ENG_BUCKET_INTO_SOIL  , 
     M    H2O_BUCKET_INTO_SOIL  , ENH_BUCKET_INTO_SOIL     , 
     O    CVR_SNW_NEXT          , CVR_SNW_INV_NEXT         ,    
     O    CVR_NOS_NEXT          , CVR_NOS_INV_NEXT         , 
     O    INFO_SNOW_NEXT        , 
     O    DEP_SNOW_NEXT         , 
     O    ENG_BUCKET_SNOW_TO_SNSL      ,  
     O    WTR_BUCKET_SNOW_TO_SNSL  , ENH_BUCKET_SNOW_TO_SNSL  , 
     O    ENG_SNOW_BUCKET_NEXT     , H2O_SNOW_BUCKET_NEXT     , 
     O    BERG                   )
!
!
!  ���j
!    �E�M�`���W���́A���l���g�p���āAsoil_main �ɓ���O�Ɍv�Z���Ă����B
!
!    �E�����E���؂��������E�X���� soil_pre �ō��������B
!        ����ɂ��M�`���W���͍Čv�Z���Ȃ��B
!        �i�����A���؂������Ă��Ȃ��Ă������Ƃ���B�j
!        ��������M�͕ω����A����t���b�N�X�␳�ʂ͕ς��B
!
!    �Esoil_h* �ł́A���̈ړ��⑊�ω��͂Ȃ��Ƃ��ĔM�`���������������B
!      �M�`�����Ŋe�w������G�l���M�[�t���b�N�X�����ʂ�]������B
!        ���������Ƃ��Ɨ�x�ł��鑊�ɂ��ẮA���x���ς��Ȃ��Ɣ��f���āA
!        �A�I�ɕ]�����邱�Ƃɔ����␳���s�Ȃ�Ȃ��B
!    �E���̎��_�ŏ󋵂��Œ肷��B�e�w�̊e�������G�l���M�[�ʂȂǂ�
!      �t�B�b�N�X����B
!
!    �Esoil_w* �ł́A���̈ړ��������B
!
!  �ۑ�
!    �ERHO_SNOW �̐ϕ��B
!        �܂��ł��Ă��Ȃ��B
!        �������ǂ��ł��邩�B
!        ����ȊO�̕ω��͂ǂ��ōl�����邩
!
!  ����
!     �E *_TOP ����� *SNOW_TO_SNSL �́A�P�ʊi�q������ł����āA
!        �Ⴀ��̈悠����ł͂Ȃ��B
!
!  ��w�ɂ��āA
!    �M�̕������𗧂Ăĉ����B
!    ���̗����������B
!    ���X�e�b�v�ł̐�̕��z�����߂�B
!
!  �Ȃ��A�����ł͈ȉ��̂��Ƃ͍s��Ȃ� 
!    
!    ��̃A���x�h�v�Z
!      ... ����͕��˂̑O�B
!
!    ��̔M�`���W��
!      ... ����͓y��̔M�`���W���Ƃ��֌W����̂ŁA���̈ȑO�Ɍv�Z����B
!
!    ��̏�[�E�����ɓ����Ă�����˂ȂǁA��[�ɓ����ė������
!      ... ����͂��̈ȑO�Ɍv�Z����B
!
!          �Z�g  ...  SRAD_BUCKET_SNW 
!          �M    ...  ENG_BUCKET_SNW 
!          ��    ...  ENG_GLA_SNW,GLA_SNW,ENG_WTR_SNW,WTR_SNW �̊e BUCKET
!                     ����� BUCKET �ʂ́A*CVR_SNW ���������ʂ�����
!                     �ᖳ���i�q�ɍ~���Ă�������������߁B
!
!    ��ʔ핢�����ς�����ꍇ�̃A���x�h�̕␳ 
!      ... �����E���n�̃A���x�h�ɂ��������̂ŁA���̌�ōs���B
!
!    �ዤ�ʔz��ւ̋l�ߑւ� ��̎��Ԑϕ�����
!      ... ���Ƃň�C�ɕ����i�q�ɋl�ߍ��ށB
!
!    CVR_SNW �̐ϕ�
!
! ����
!   ��̖��������i�q�ɐႪ�~���Ă����ꍇ�́A�M�܂��̌v�Z�͂��Ȃ��B
!   ���̃X�e�b�v�ł̐�ʐς�]�����邽�߂ɐ��܂��̌v�Z�͂����Ȃ��B
!   ���̌��ʂ̐�̗ʂ����Ȃ��ꍇ�̓o�P�c�ɒ��߂��܂܂Ƃ���B
!
      USE SIBPRM , ONLY : 
     1    IDX    , 
     1    ISN      
!
      USE COM_STEP_SIB0109 , ONLY :
     1   ICN_SIB0109_SNOW_RESET                  ! ��w�����Z�b�g���� 1
!
      USE SIB_MONIT , ONLY :
     1    SIB_MONIT_RUN_SET_SNOWNEXTINFO 
!
      USE COM_RUNCONF_SIB0109 , ONLY : 
     1   JCN_SNOW_HEAT_EXPLICIT 
!
#ifdef SIB_DEBUG
      use sibcon , only : 
     1   HL_W2G_c , TMP_FREZ_C , CAP_GLA_c , CAP_WTR_c 
#endif
!
      IMPLICIT NONE 
!
! INPUT 
!
      INTEGER,INTENT(IN)    :: IMSKLT(IDX)
      INTEGER,INTENT(IN)    :: NMAX
      INTEGER,INTENT(IN)    :: NMAX_0 (3)
      INTEGER,INTENT(IN)    :: NMAX_01(3)
      INTEGER,INTENT(IN)    :: NMAX_1 (3)
      INTEGER,INTENT(IN)    :: NMAX_2 (3)
      INTEGER,INTENT(IN)    :: NMAX_3 (3)
      INTEGER,INTENT(IN)    :: NMAX_4 (3)
!
!  �\��ϐ�
!
      REAL(8),INTENT(INOUT) :: TMP_SNOW_PROG    (IDX,ISN+1) ! ��̉��x 
      REAL(8),INTENT(INOUT) :: WTR_SNOW_PROG    (IDX,ISN)
      REAL(8),INTENT(INOUT) :: GLA_SNOW_PROG    (IDX,ISN)
      REAL(8),INTENT(INOUT) :: RHO_SNOW_INV_PROG(IDX,ISN)   ! �ᖧ�x�t��
      REAL(8),INTENT(INOUT) :: AGE_SNOW_PROG   (IDX)        ! ��̔N��
!
      REAL(8),INTENT(INOUT) :: ENG_BUCKET_INTO_SOIL(IDX)  
      REAL(8),INTENT(INOUT) :: H2O_BUCKET_INTO_SOIL(IDX)  
      REAL(8),INTENT(IN)    :: ENH_BUCKET_INTO_SOIL(IDX)   ! �g��Ȃ�

!
      REAL(8),INTENT(IN)    :: ENG_SNOW_BUCKET(IDX)
      REAL(8),INTENT(IN)    :: H2O_SNOW_BUCKET(IDX)
!
!   ��C����̋���
!
      REAL(8),INTENT(IN)    :: ENH_BUCKET_INTO_SNOW (IDX)  ! �J���̃G�l���M�[
      REAL(8),INTENT(IN)    :: ENH_BUCKET_FROM_SNOW (IDX)  ! ������
      REAL(8),INTENT(IN)    :: H2O_BUCKET_INTO_SNOW (IDX)  ! �J�̗�
      REAL(8),INTENT(IN)    :: H2O_BUCKET_FROM_SNOW (IDX)  ! ����
      REAL(8),INTENT(IN)    :: SRAD_BUCKET_SNW       (IDX)  ! �Z�g����
      REAL(8),INTENT(IN)    :: ENG_BUCKET_SNW        (IDX)  ! �M�t���b�N�X
!
!   �Q�Ƌ�C�̏�� ( ��̉��x�̌���ޗ� )
!
      REAL(8),INTENT(IN)    :: U_REF    (IDX) 
      REAL(8),INTENT(IN)    :: V_REF    (IDX)
      REAL(8),INTENT(IN)    :: TMP_REF  (IDX)
!
!   ���̑�
!
      REAL(8),INTENT(IN)    :: TMP_SNSK_NEXT (IDX) ! 
!     REAL(8),INTENT(INOUT) :: TMP_GRSK_NEXT (IDX) ! 
!
      REAL(8),INTENT(IN)    :: ENG_SOIL_TOP  (IDX) ! 
!
      REAL(8),INTENT(IN)    :: DEP_SNOW    (IDX,ISN+1) ! ��̌��� ISN+1 �͍��v
      REAL(8),INTENT(IN)    :: CVR_SNW     (IDX)
      REAL(8),INTENT(IN)    :: CVR_SNW_INV (IDX)
!
      REAL(8),INTENT(IN)    :: HDF_SNOW_H  (IDX,ISN)   ! �ᒆ�M�`���W��
!     REAL(8),INTENT(IN)    :: HDF_SNOW_BH (IDX)       ! ��B �ƒn��
!
      REAL(8),INTENT(IN)    :: DELT_SNOW               ! ���ԍ�
      REAL(8),INTENT(IN)    :: DELT_CNP                ! ���ԍ�
!
! OUTPUT  
!
!
      REAL(8),INTENT(OUT)   :: ENG_SNOW_BUCKET_NEXT(IDX)
      REAL(8),INTENT(OUT)   :: H2O_SNOW_BUCKET_NEXT(IDX)
!
      REAL(8),INTENT(OUT)   :: DEP_SNOW_NEXT  (IDX,ISN+1) ! ��̌��� 
!
      REAL(8),INTENT(OUT)   :: BERG (IDX)               ! ��̗��o (10m�ȏ�)
!                 ������ 10m ���z������A
!                 �o�b�t�@�̑w ( 01/10/29 ���ݑ� 2 �w ) ���痬�o������B
!
!   �y��ւ̋���
!
      REAL(8),INTENT(OUT)   :: ENG_BUCKET_SNOW_TO_SNSL     (IDX) ! �M�`��
!
      REAL(8),INTENT(OUT)   :: ENH_BUCKET_SNOW_TO_SNSL (IDX) ! �������� ENG
      REAL(8),INTENT(OUT)   :: WTR_BUCKET_SNOW_TO_SNSL (IDX) ! ��������
!
!   ���̑�
!
      INTEGER,INTENT(OUT)   :: INFO_SNOW_NEXT   (IDX)  ! �w��
      REAL(8),INTENT(OUT)   :: CVR_SNW_NEXT     (IDX)  
      REAL(8),INTENT(OUT)   :: CVR_NOS_NEXT     (IDX)  
      REAL(8),INTENT(OUT)   :: CVR_SNW_INV_NEXT (IDX)  
      REAL(8),INTENT(OUT)   :: CVR_NOS_INV_NEXT (IDX)  
!
!
! WORK �M�֘A ( �Ⴀ��悾���ł̕��� ) 
!
      INTEGER   :: I
!     REAL(8)   :: ENG_BUC (IDX)                
!
      REAL(8)   :: TMP_SNOW     (IDX,ISN+1) ! ��̉��x �Ō�� TMP_SNSL
      REAL(8)   :: WTR_SNOW     (IDX,ISN)
      REAL(8)   :: GLA_SNOW     (IDX,ISN)
!
      REAL(8)   :: HDIFF_FLUX_H    (IDX,0:ISN)     ! �M�`���t���b�N�X
!
      REAL(8)   :: PHASE_SNOW   (IDX,ISN)        ! ��x�Ȃ� 0�A�����łȂ���� 1
      REAL(8)   :: SIB_MTX_SNOW (IDX,ISN,ISN+1)  ! �M�p�̍s��
      REAL(8)   :: CAP_SNOW     (IDX,ISN)        ! ��M
      REAL(8)   :: HFLUX_CONV(IDX,ISN)       ! ��̑w������M
!
      REAL(8)   :: SRAD_FLUX_CNV (IDX,ISN)       ! ��̑w���̒Z�g�t���b�N�X
!
      REAL(8)   :: SRAD_BUCKET_SNOW_TO_SNSL (IDX) ! �Z�g����
!
      REAL(8)   :: DELT_SNOW_INV    
!
! WORK ���֘A ( �i�q���� ) 
!
      REAL(8)   :: ENG_SNOW        (IDX,ISN)
      REAL(8)   :: H2O_SNOW        (IDX,ISN)
      REAL(8)   :: RHO_SNOW_INV    (IDX,ISN)
      REAL(8)   :: RHO_PRECIPI_INV (IDX) ! �~��̐�̖��x�̋t��
!
      REAL(8)   :: ENG_PRECIPI (IDX)
      REAL(8)   :: H2O_PRECIPI (IDX)
!
      REAL(8)   :: ENG_SNOW_NEXT   (IDX,ISN) 
      REAL(8)   :: H2O_SNOW_NEXT   (IDX,ISN)
!
      REAL(8)   :: ENH_BERG    (IDX)
!
      INTEGER   :: IFLG_SLEV_CHANGE (IDX) ! ��w�̃��Z�b�g�����邩�ǂ���
!
!  �s�v�����m��Ȃ��B
      INTEGER   :: LIST_SNOW (IDX,0:4)      ! ���X�g�x�N�g�� ( �Ӗ���? )
      INTEGER   :: ICNT_SNOW (    0:4)      ! ? 
!
      INTEGER   :: I_SNOW_LEV      (IDX)    ! ���݂̐�̑w�� 
!
#ifdef SIB_DEBUG
      REAL(8)   :: ENG_SNOW_SUM_SAVE  (IDX)
      REAL(8)   :: H2O_SNOW_SUM_SAVE  (IDX)
      REAL(8)   :: ENG_SNOW_SUM_TMP   (IDX)
      REAL(8)   :: H2O_SNOW_SUM_TMP   (IDX)
      REAL(8)   :: ENG_SNOW_SUM_NEW   (IDX)
      REAL(8)   :: H2O_SNOW_SUM_NEW   (IDX)
      REAL(8)   :: H2O_ERR_MAX
      REAL(8)   :: ENG_ERR_MAX
      REAL(8)   :: TMP_SNOW_SAVE    (IDX,ISN) 
      REAL(8)   :: WTR_SNOW_SAVE    (IDX,ISN)
      REAL(8)   :: GLA_SNOW_SAVE    (IDX,ISN)
#endif
!
      LOGICAL,SAVE :: LFIRST =  .TRUE. 
!
!     integer :: icount = 0
!     icount = icount + 1  
!
      IF ( LFIRST ) THEN
        WRITE(6,*) 'SNOW_MAIN     POCHAKA 99/08/09' 
        LFIRST = .FALSE.
      ENDIF
!
      DELT_SNOW_INV = 1 / DELT_SNOW
!
!
      ENG_BUCKET_SNOW_TO_SNSL(:) = 0. 
!
      H2O_SNOW     (:,:) = 0.
      ENG_SNOW     (:,:) = 0.
!
#ifdef SIB_DEBUG
      WTR_SNOW_SAVE(:,:) = WTR_SNOW_PROG(:,:)  
      GLA_SNOW_SAVE(:,:) = GLA_SNOW_PROG(:,:)  
      TMP_SNOW_SAVE(:,1:4) = TMP_SNOW_PROG(:,1:4)  
!
      DO I=1,NMAX
        H2O_SNOW_SUM_SAVE(I) = 
     1       H2O_SNOW_BUCKET(I)      
     1     + H2O_BUCKET_INTO_SNOW(I) 
     1     + H2O_BUCKET_INTO_SOIL(I) 
     1     + H2O_BUCKET_FROM_SNOW(I) 
     1     + WTR_SNOW_SAVE    (I,1) 
     1     + WTR_SNOW_SAVE    (I,2) 
     1     + WTR_SNOW_SAVE    (I,3) 
     1     + WTR_SNOW_SAVE    (I,4) 
     1     + GLA_SNOW_SAVE    (I,1) 
     1     + GLA_SNOW_SAVE    (I,2) 
     1     + GLA_SNOW_SAVE    (I,3) 
     1     + GLA_SNOW_SAVE    (I,4) 
!
        ENG_SNOW_SUM_SAVE(I) = 
     1       SRAD_BUCKET_SNW(I)
     1     + ENG_BUCKET_SNW (I)
     1     + ENG_BUCKET_INTO_SOIL (I)
     1     + ENG_SNOW_BUCKET(I) 
     1     + ENH_BUCKET_INTO_SNOW(I) 
     1     + ENH_BUCKET_FROM_SNOW(I) 
     1     + (   CAP_WTR_c * WTR_SNOW_SAVE(I,1) 
     1         + CAP_GLA_c * GLA_SNOW_SAVE(I,1) )
     1           * ( TMP_SNOW_SAVE(I,1) - TMP_FREZ_c  ) 
     1     - HL_W2G_c * GLA_SNOW_SAVE(I,1)
     1     + (   CAP_WTR_c * WTR_SNOW_SAVE(I,2) 
     1         + CAP_GLA_c * GLA_SNOW_SAVE(I,2) )
     1           * ( TMP_SNOW_SAVE(I,2) - TMP_FREZ_c  ) 
     1     - HL_W2G_c * GLA_SNOW_SAVE(I,2)
     1     + (   CAP_WTR_c * WTR_SNOW_SAVE(I,3) 
     1         + CAP_GLA_c * GLA_SNOW_SAVE(I,3) )
     1           * ( TMP_SNOW_SAVE(I,3) - TMP_FREZ_c  ) 
     1     - HL_W2G_c * GLA_SNOW_SAVE(I,3)
     1     + (   CAP_WTR_c * WTR_SNOW_SAVE(I,4) 
     1         + CAP_GLA_c * GLA_SNOW_SAVE(I,4) )
     1           * ( TMP_SNOW_SAVE(I,4) - TMP_FREZ_c  ) 
     1     - HL_W2G_c * GLA_SNOW_SAVE(I,4)
      ENDDO
#endif
!
!  ======================
!  >> �����E���؂̏��� <<
!  ======================
!
!
      CALL SNOW_PRE (
     I    NMAX      , NMAX_01   , 
     I    NMAX_2    , NMAX_3    , NMAX_4  , 
     I    CVR_SNW_INV    , 
     I    WTR_SNOW_PROG  , GLA_SNOW_PROG    , 
     I    H2O_BUCKET_FROM_SNOW   , ENH_BUCKET_FROM_SNOW   , 
     I    TMP_SNOW_PROG  , 
     O    TMP_SNOW       , WTR_SNOW       , GLA_SNOW      )   
! 
!  ==================
!  >> �M�܂��v�Z <<
!  ==================
!
!  ----------
!  >> ���� <<
!  ----------
!     �E��M�̌v�Z
!     �E�z�ɕ]�������M�����̌v�Z
!        �E�e�w�̒Z�g�z���� SRAD_SNOW �v�Z 
!        �E��[����̃G�l���M�[�t���b�N�X ENG_BUC
!        �E�M�`���t���b�N�X HDIFF_FLUX_CNV �v�Z
!    
      CALL SNOW_HFLUX_PRE (
     I    NMAX      , NMAX_01   , NMAX_1  , 
     I    NMAX_2    , NMAX_3    , NMAX_4  , 
     I    DELT_SNOW , DELT_SNOW_INV         , 
     I    WTR_SNOW  , GLA_SNOW  , 
     I    SRAD_BUCKET_SNW       , ENG_BUCKET_SNW      ,   
     I    DEP_SNOW  , TMP_SNOW  , 
     I    CVR_SNW   , CVR_SNW_INV         , 
     I    HDF_SNOW_H, 
     O    PHASE_SNOW,  
     O    CAP_SNOW  , 
     O    HFLUX_CONV , 
     O    SRAD_BUCKET_SNOW_TO_SNSL , 
     O    HDIFF_FLUX_H  )
!
!  ====================================
!  >> �M�̎������� �` �C���v���V�b�g <<
!  ====================================
!
      IF ( JCN_SNOW_HEAT_EXPLICIT .EQ. 0 ) THEN
!
!  ------------------------
!  >> �M�̕������𗧂Ă� <<
!  ------------------------
!     �E�M�`�������������Ă�
!     �E�z�ɕ]�������M�t���b�N�X���� HFLUX_CONV �v�Z
!
      CALL SNOW_HFLUX_IMPLICIT_EQSET (
     I  NMAX       , NMAX_01   , 
     I  NMAX_2     , NMAX_3    , NMAX_4    , 
     I  DELT_SNOW  , 
     I  PHASE_SNOW , 
     I  CAP_SNOW   , HDIFF_FLUX_H ,
     I  HDF_SNOW_H , 
     O  SIB_MTX_SNOW    , 
     M  HFLUX_CONV )
!
!  ----------------------
!  >> �M�̕����������� <<
!  ----------------------
!    ����ŁAdT/dt ��������B
!
      CALL SNOW_HFLUX_IMPLICIT_EQSLV (
     I  NMAX_01   , 
     I  NMAX_1    , NMAX_2    , NMAX_3    , NMAX_4    , 
     M  SIB_MTX_SNOW )
!
!  --------------------------
!  > �M�t���b�N�X�����̕␳ <
!  --------------------------
!     �E�M�t���b�N�X���� HFLUX_CONV �ɃC���v���V�b�g����������B
!     �ESNSL �ɗ^����M�o�P�c�v�Z 
!    
      CALL SNOW_HFLUX_IMPLICIT_CORR (
     I  NMAX      , NMAX_01   , NMAX_1    , 
     I  NMAX_2    , NMAX_3    , NMAX_4    , 
     I  SIB_MTX_SNOW          , 
     I  HDF_SNOW_H            , 
     I  DELT_SNOW             , PHASE_SNOW            , 
     I  CVR_SNW               ,              
     I  SRAD_BUCKET_SNOW_TO_SNSL     ,  
     I  HDIFF_FLUX_H          , 
     O  ENG_BUCKET_SNOW_TO_SNSL      , 
     M  HFLUX_CONV          )  
! 
!  ======================================
!  >> �M�̎������� �` �C�N�X�v���V�b�g <<
!  ======================================
!
      ELSE
        CALL SNOW_HFLUX_EXPLICIT (
     I  NMAX      , NMAX_01   , NMAX_1    ,
     I  NMAX_2    , NMAX_3    , NMAX_4    , 
     I  DELT_SNOW , CVR_SNW   ,   
! 20050517
!     I  SRAD_FLUX_CNV  , 
     I  SRAD_BUCKET_SNOW_TO_SNSL     ,  
     I  HDIFF_FLUX_H     , 
     M  HFLUX_CONV    , 
     O  ENG_BUCKET_SNOW_TO_SNSL )


!
      ENDIF
!
!  ==================
!  >> ���܂��v�Z <<
!  ==================
!   ���̈ړ��ɔ����ύX
!
!   ���������́ANMAX_01 �̕����́A
!   �i�q���ϒl �i*CVR_SNW �����l�j�ɂȂ�B
!
!  ----------------
!  > ���܂�菀�� <
!  ----------------
!     �E�i�q���ϒl�ɂ���
!     �E�V��E����ɕ����A�e�w�̃G�l���M�[�Ȃǌv�Z
!     �E�N��̉��Z
!     �E��w���Z�b�g�t���O IFLG_SLEV_CHANGE �̏�������
!
      CALL SNOW_WFLUX_PRE (
     I   NMAX    , DELT_SNOW         , 
     I   NMAX_0  , NMAX_01 , NMAX_2 , NMAX_3  , NMAX_4  , 
     I   GLA_SNOW, WTR_SNOW, TMP_SNOW, 
     I   CVR_SNW , 
     I   HFLUX_CONV     , 
     I   H2O_BUCKET_INTO_SNOW      , ENH_BUCKET_INTO_SNOW        , 
     I   ENG_SNOW_BUCKET , H2O_SNOW_BUCKET , 
     I   U_REF       , V_REF       , TMP_REF         , 
     I   RHO_SNOW_INV_PROG   ,
     O   ENG_PRECIPI , H2O_PRECIPI , RHO_PRECIPI_INV , 
     O   ENG_SNOW    , H2O_SNOW    , RHO_SNOW_INV    ,          
     O   IFLG_SLEV_CHANGE      )                      ! �N���A & �ᖳ���ɒl
!
      CALL SNOW_AGE_INTG (
     I   NMAX   , NMAX_1 , DELT_SNOW , 
     I   RHO_SNOW_INV , 
     M   AGE_SNOW_PROG ) 
!
      I_SNOW_LEV(1         :NMAX_0(3)) = 0  
      I_SNOW_LEV(NMAX_01(2):NMAX_1(3)) = 1  
!
! SX6 �̃o�O�΍�
#ifdef SX6_OPTION
      do i=nmax_2(2),nmax_2(3)
        I_SNOW_LEV(i) = 2  
      ENDDO
#else
      I_SNOW_LEV(NMAX_2 (2):NMAX_2(3)) = 2  
#endif
      I_SNOW_LEV(NMAX_3 (2):NMAX_3(3)) = 3  
!
#ifdef SIB_DEBUG
      DO I=1,NMAX
        H2O_SNOW_SUM_TMP(I) = 
!    1       H2O_SNOW_BUCKET(I)         ! ���ł� precipi �ɉ��Z
     1     + H2O_SNOW       (I,1) 
     1     + H2O_SNOW       (I,2) 
     1     + H2O_SNOW       (I,3) 
     1     + H2O_SNOW       (I,4) 
     1     + H2O_PRECIPI    (I) 
     1     + H2O_BUCKET_INTO_SOIL(I)    
        ENG_SNOW_SUM_TMP(I) = 
!    1       ENG_SNOW_BUCKET(I)         ! ���ł� precipi �ɉ��Z
     1     + ENG_SNOW       (I,1) 
     1     + ENG_SNOW       (I,2) 
     1     + ENG_SNOW       (I,3) 
     1     + ENG_SNOW       (I,4) 
     1     + ENG_PRECIPI    (I) 
     1     + ENG_BUCKET_SNOW_TO_SNSL (I) 
     1     + ENG_BUCKET_INTO_SOIL(I)    
      ENDDO
#endif
!
!  ---------------------------------------
!  > ������� ( ������Z�b�g���Ȃ��ꍇ ) < 
!  ---------------------------------------
!
      IF ( ICN_SIB0109_SNOW_RESET.EQ.0 )  THEN 
!
        CALL SNOW_WFLUX (
     I     NMAX      , 
     I     NMAX_01   , NMAX_2    , NMAX_3    , 
     I     H2O_PRECIPI  , ENG_PRECIPI   , RHO_PRECIPI_INV       , 
     I     H2O_SNOW     , ENG_SNOW      , RHO_SNOW_INV          , 
     I     I_SNOW_LEV   , 
     M     IFLG_SLEV_CHANGE      , 
     M     ENG_SNOW_NEXT         , H2O_SNOW_NEXT         , 
     M     RHO_SNOW_INV_PROG     , 
     M     ENH_BUCKET_SNOW_TO_SNSL  , WTR_BUCKET_SNOW_TO_SNSL  , 
     O     INFO_SNOW_NEXT )         ! �����l -1 �A��w�� ( 01 �Ȃ� 1 ) 
!
      ENDIF
!
!  ------------------------------------------------
!  > ������� �` ��̑w�̂Ƃ�������Z�b�g����ꍇ < 
!  ------------------------------------------------
!    �ᖳ���Ő�̃^�l������ꍇ�������ŏ�������B
!
      CALL SNOW_SLEV_MOD (
     I    NMAX         , 
     I    ENG_PRECIPI  , H2O_PRECIPI  , RHO_PRECIPI_INV       , 
     I    ENG_SNOW     , H2O_SNOW     , RHO_SNOW_INV          , 
     M    ENG_SNOW_NEXT, H2O_SNOW_NEXT, RHO_SNOW_INV_PROG     ,  
     M    ENH_BUCKET_SNOW_TO_SNSL , WTR_BUCKET_SNOW_TO_SNSL   , 
     M    IFLG_SLEV_CHANGE            , 
     M    INFO_SNOW_NEXT  )                 ! ��w�������B
!
! ======================
! >> ��㏈���������� <<  
! ======================
!
!  ------------------
!  > �ቺ�ʂ�Z���� <
!  ------------------
!     �y��̃G�l���M�[�����̏ꍇ�A���̃G�l���M�[���[���ɂ��āA���Z�����B
!
      CALL SNOW_BOTTOM_MELT (
     I    NMAX          , NMAX_0        , NMAX_01       , 
     I    CVR_SNW       , ENG_SOIL_TOP  , 
     M    INFO_SNOW_NEXT, 
     M    ENG_SNOW_NEXT , H2O_SNOW_NEXT , 
     M    ENG_BUCKET_INTO_SOIL    , ENG_BUCKET_SNOW_TO_SNSL , 
     M    H2O_BUCKET_INTO_SOIL    , WTR_BUCKET_SNOW_TO_SNSL  )  
!
!  --------------------
!  > ����o�P�c�Ɋi�[ <
!  --------------------
!   �E����A�Ⴊ���Ȃ���Ώ���o�P�c�ցB
!   �E�ȉ��̍�Ƃ͍���̉ۑ�
!     �X�L���ƍ��킹�����x������ ( TF �ȏ� ) �ꍇ�A�Z�ᐅ�͓y���
!
      CALL SNOW_LITTLE_SNOW (
     I    NMAX                  ,
     M    INFO_SNOW_NEXT        ,                      ! ����Ȃ� 1 �� -2 ��
     M    H2O_SNOW_NEXT         , ENG_SNOW_NEXT    , 
     M    AGE_SNOW_PROG         , 
     O    ENG_SNOW_BUCKET_NEXT  , H2O_SNOW_BUCKET_NEXT   ) 
!
! ------------
! > �X�͗��o <
! ------------
!
#ifdef HIGH_SPEED
          BERG    (:) = 0. 
          ENH_BERG(:) = 0. 
#else
      CALL SNOW_BERG (
     I    NMAX                  ,
     M    H2O_SNOW_NEXT         , ENG_SNOW_NEXT    , 
     O    BERG                  , ENH_BERG           )
#endif
!
!  -------------------
!  > ���֌W���Ǝn�� <
!  -------------------
!    CVR_SNW_NEXT �̌v�Z
!    ���x�A���E�X�̗ʂ����Ԑϕ�
!    �X�͗��o
!
      CALL SNOW_WFLUX_POST ( 
     I    NMAX             , 
     I    H2O_SNOW_NEXT    , ENG_SNOW_NEXT    , 
#ifdef MONYOS
     I    DELT_CNP         , DELT_SNOW        ,
#endif
     M    INFO_SNOW_NEXT   ,                         ! 01 �Ȃ� 0 ��
     O    CVR_SNW_NEXT     , CVR_SNW_INV_NEXT , 
     O    CVR_NOS_NEXT     , CVR_NOS_INV_NEXT , 
     O    TMP_SNOW_PROG    , WTR_SNOW_PROG    , GLA_SNOW_PROG   , 
     O    LIST_SNOW        , ICNT_SNOW )
!
! ------------------
! > ��̐[���̌v�Z <
! ------------------
!   GLA_SNOW_NEXT �͐ᖳ������܂ފi�q���ςȂ̂ŁA�[�������߂�ɂ�
!   CVR_SNW_INV_NEXT ��������K�v������B
!
      CALL SNOW_POST (
     I    NMAX          , 
     I    GLA_SNOW_PROG , CVR_SNW_INV_NEXT , 
     I    RHO_SNOW_INV_PROG , 
     O    DEP_SNOW_NEXT  )
!
! ----------------------------------------------
! > ���j�^�p �` ���X�e�b�v�ł̐�핢�����̐ݒ� <
! ----------------------------------------------
!
#ifdef MONYOS
      CALL SIB_MONIT_RUN_SET_SNOWNEXTINFO (
     I   NMAX    , 
     I   CVR_SNW_NEXT , CVR_NOS_NEXT , INFO_SNOW_NEXT )
#endif
!
! ------------------
! > ��̉��x���j�^ <
! ------------------
!   �Œ肵���[���ł̉��x���j�^�B�����܂Ŗڈ��B���x�͐��`���}�B
!
      CALL SNOW_MONIT_FIXED_DEPTH (
     I    NMAX   , NMAX_01 , DELT_SNOW ,
     I    CVR_SNW_INV_NEXT  , 
     I    INFO_SNOW_NEXT    , 
     I    TMP_SNOW_PROG     , TMP_SNSK_NEXT     , 
     I    WTR_SNOW_PROG     , GLA_SNOW_PROG     , 
     I    DEP_SNOW_NEXT  )
!
#ifdef SIB_DEBUG
      DO I=1,NMAX
        H2O_SNOW_SUM_NEW(I) = 
     1       H2O_SNOW_BUCKET_NEXT(I)           ! ���ł� precipi �ɉ��Z
     1     + H2O_SNOW_NEXT       (I,1) 
     1     + H2O_SNOW_NEXT       (I,2) 
     1     + H2O_SNOW_NEXT       (I,3) 
     1     + H2O_SNOW_NEXT       (I,4) 
     1     + WTR_BUCKET_SNOW_TO_SNSL (I) 
     1     + BERG                    (I) 
     1     + H2O_BUCKET_INTO_SOIL(I)    
!      
        ENG_SNOW_SUM_NEW (I) = 
     1       ENG_SNOW_BUCKET_NEXT(I)           ! ���ł� precipi �ɉ��Z
     1     + ENG_SNOW_NEXT       (I,1) 
     1     + ENG_SNOW_NEXT       (I,2) 
     1     + ENG_SNOW_NEXT       (I,3) 
     1     + ENG_SNOW_NEXT       (I,4) 
     1     + ENH_BUCKET_SNOW_TO_SNSL (I)  
     1     + ENG_BUCKET_SNOW_TO_SNSL (I) 
     1     + ENH_BERG                (I) 
     1     + ENG_BUCKET_INTO_SOIL(I)    
      ENDDO
!
      H2O_ERR_MAX = -1
      ENG_ERR_MAX = -1
      DO I=1,NMAX
        IF ( 
     1         ABS(H2O_SNOW_SUM_TMP(I)-H2O_SNOW_SUM_SAVE(I)).GT.1.D-9 
     1     ) THEN
          write(6,*) 'SNOW_MAIN : ERROR HEATCALC H2O' , I , 
     1         H2O_SNOW_SUM_TMP(I)-H2O_SNOW_SUM_SAVE(I) , 
     1         H2O_SNOW_SUM_SAVE(I),H2O_SNOW_SUM_TMP(I)  
        ENDIF 
! 
        IF ( 
     1        ABS(ENG_SNOW_SUM_TMP(I)-ENG_SNOW_SUM_SAVE(I)).GT.1.D-6 
     1     ) THEN
          write(6,*) 'SNOW_MAIN : ERROR HEATCALC ENG' , I , 
     1         ENG_SNOW_SUM_TMP(I)-ENG_SNOW_SUM_SAVE(I) , 
     1         ENG_SNOW_SUM_SAVE(I),ENG_SNOW_SUM_TMP(I)  
!
          write(6,*) 'E_SAVE ' , 
     1       SRAD_BUCKET_SNW(I) ,
     1     + ENG_BUCKET_SNW (I) ,
     1     + ENG_SNOW_BUCKET(I) ,
     1     + ENH_BUCKET_INTO_SNOW(I) ,
     1     + ENH_BUCKET_FROM_SNOW(I) ,
     1     + (   CAP_WTR_c * WTR_SNOW_SAVE(I,1) 
     1         + CAP_GLA_c * GLA_SNOW_SAVE(I,1) )
     1           * ( TMP_SNOW_SAVE(I,1) - TMP_FREZ_c  ) 
     1     - HL_W2G_c * GLA_SNOW_SAVE(I,1) ,
     1     + (   CAP_WTR_c * WTR_SNOW_SAVE(I,2) 
     1         + CAP_GLA_c * GLA_SNOW_SAVE(I,2) )
     1           * ( TMP_SNOW_SAVE(I,2) - TMP_FREZ_c  ) 
     1     - HL_W2G_c * GLA_SNOW_SAVE(I,2) ,
     1     + (   CAP_WTR_c * WTR_SNOW_SAVE(I,3) 
     1         + CAP_GLA_c * GLA_SNOW_SAVE(I,3) )
     1           * ( TMP_SNOW_SAVE(I,3) - TMP_FREZ_c  ) 
     1     - HL_W2G_c * GLA_SNOW_SAVE(I,3) ,
     1     + (   CAP_WTR_c * WTR_SNOW_SAVE(I,4) 
     1         + CAP_GLA_c * GLA_SNOW_SAVE(I,4) )
     1           * ( TMP_SNOW_SAVE(I,4) - TMP_FREZ_c  ) 
     1     - HL_W2G_c * GLA_SNOW_SAVE(I,4) 
!
          write(6,*) 'E_TMP ' , 
     1     + ENG_SNOW       (I,1) ,
     1     + ENG_SNOW       (I,2) ,
     1     + ENG_SNOW       (I,3) ,
     1     + ENG_SNOW       (I,4) ,
     1     + ENG_PRECIPI    (I) ,
     1     + ENG_BUCKET_SNOW_TO_SNSL (I) 
!
        ENDIF 
!
        IF ( ABS(H2O_SNOW_SUM_TMP(I)-H2O_SNOW_SUM_SAVE(I))
     1          .GT.H2O_ERR_MAX) THEN
          H2O_ERR_MAX = ABS(H2O_SNOW_SUM_TMP(I)-H2O_SNOW_SUM_SAVE(I))
        ENDIF
        IF ( ABS(ENG_SNOW_SUM_TMP(I)-ENG_SNOW_SUM_SAVE(I))
     1          .GT.ENG_ERR_MAX) THEN
          ENG_ERR_MAX = ABS(ENG_SNOW_SUM_TMP(I)-ENG_SNOW_SUM_SAVE(I))
        ENDIF
      ENDDO

      write(6,*) 'SNOW_MAIN : water  h2o/eng heat diff ' , 
     1            h2o_err_max , eng_err_max 
! ---------------------------------------------------------------
      H2O_ERR_MAX = -1
      ENG_ERR_MAX = -1
      DO I=1,NMAX
        IF ( 
     1         ABS(H2O_SNOW_SUM_NEW(I)-H2O_SNOW_SUM_TMP(I)).GT.1.D-9 
     1     ) THEN
          write(6,*) 'SNOW_MAIN : ERROR WATERCALC MASS' , I , 
     1               IFLG_SLEV_CHANGE (I)  , 
     1         H2O_SNOW_SUM_NEW(I)-H2O_SNOW_SUM_TMP(I) , 
     1         H2O_SNOW_SUM_TMP(I),H2O_SNOW_SUM_NEW(I)  
!
          write(6,*) ' H2O_TMP' ,
     1     + H2O_SNOW       (I,1) ,
     1     + H2O_SNOW       (I,2) ,
     1     + H2O_SNOW       (I,3) ,
     1     + H2O_SNOW       (I,4) ,
     1     + H2O_PRECIPI    (I) 

          write(6,*) ' H2O_NEW' ,
     1       H2O_SNOW_NEXT       (I,1)     ,
     1       H2O_SNOW_NEXT       (I,2)     ,
     1       H2O_SNOW_NEXT       (I,3)     ,
     1       H2O_SNOW_NEXT       (I,4)     ,
     1       H2O_SNOW_BUCKET_NEXT(I)       ,
     1       WTR_BUCKET_SNOW_TO_SNSL (I)   , 
     1       BERG (I)    
!
!
        ENDIF 
        IF ( 
     1    ABS(ENG_SNOW_SUM_NEW(I)-ENG_SNOW_SUM_TMP(I)).GT.1.D-6 
     1     ) THEN
          write(6,*) 'SNOW_MAIN : ERROR WATERCALC ENG ' , I , 
     1               IFLG_SLEV_CHANGE (I)  , 
     1         ENG_SNOW_SUM_NEW(I)-ENG_SNOW_SUM_TMP(I) , 
     1         ENG_SNOW_SUM_TMP(I),ENG_SNOW_SUM_NEW(I)
!
!
        ENDIF 
!
        IF ( ABS(H2O_SNOW_SUM_NEW(I)-H2O_SNOW_SUM_TMP(I))
     1          .GT.H2O_ERR_MAX) THEN
          H2O_ERR_MAX = ABS(H2O_SNOW_SUM_NEW(I)-H2O_SNOW_SUM_TMP(I))
        ENDIF
        IF ( ABS(ENG_SNOW_SUM_NEW(I)-ENG_SNOW_SUM_TMP(I))
     1          .GT.ENG_ERR_MAX) THEN
          ENG_ERR_MAX = ABS(ENG_SNOW_SUM_NEW(I)-ENG_SNOW_SUM_TMP(I))
        ENDIF
      ENDDO
!
      write(6,*) 'snow_main : water  h2o/eng diff ' , 
     1            h2o_err_max , eng_err_max 
!
      IF ( 
     1            h2o_err_max .gt. 1 
     1      .or.  eng_err_max .gt. 1 
     1     ) THEN
            write(6,*) 'snow_main ERROR too large' 
            stop 999
      ENDIF


#endif
!
      RETURN
      END