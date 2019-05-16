! ��̔M�t���b�N�X�v�Z����  �i��M�v�Z�A�Z�g���ˋz���ʌv�Z�j
! 99/07/12 �ۍ␪�G  ��̔�M�v�Z�� hcap.F ���番������`�ō쐬
! 99/07/xx �ۍ␪�G  ��̒Z�g�z���ʌv�Z�ǉ�
! 99/08/04 �ۍ␪�G  ��򂳂�ɓn���o�[�W�����t�B�b�N�X
!
      SUBROUTINE SNOW_HFLUX_PRE (
     I    NMAX      , NMAX_01   , NMAX_1  , 
     I    NMAX_2    , NMAX_3    , NMAX_4  , 
     I    DELT_SNOW ,  DELT_SNOW_INV         ,  
     I    WTR_SNOW  , GLA_SNOW  , 
     I    SRAD_BUCKET_SNW       , 
     I    ENG_BUCKET_SNW        , 
     I    DEP_SNOW, TMP_SNOW, 
     I    CVR_SNW        , CVR_SNW_INV    , 
     I    HDF_SNOW_H , 
     O    PHASE_SNOW,  
     O    CAP_SNOW  , 
     O    HFLUX_CONV , SRAD_BUCKET_SNOW_TO_SNSL , 
     O    HDIFF_FLUX_H   )
!
! ����
!   SRAD_BUCKET_SNW , ENG_BUCKET_SNW �͊i�q���ϒl�ł���B
!   ��ł̔M�̌v�Z�ł́A�Ⴀ��悾���ł̕��ϒl��p����B
!   _01 �̊i�q�ł͂��ꂪ������̂ŁA���̃T�u���[�`���̒���
!       ���͎��ɂ� /CVR_SNW ���{���K�v������B
!   
!   �Ȃ��A_COR �����Ă���ϐ��͂���� /CVR_SNW ���{�������̂ł���B
!
!   ����
!     �E�ォ��̃t���b�N�X�͗^�����Ă���B      
!
!     �E��̑w���ƁATMP_SNSL ���̊֌W
!       �� 1 �w�̎�    TMP_SNOW(I,2)   = TMP_SNSL(I)  
!                      HDF_SNOW_H(I,1) = �ቺ�[�Ɛቺ�y��
!       �� 2 �w�̎�    TMP_SNOW(I,3)   = TMP_SNSL(I)  
!                      HDF_SNOW_H(I,2) = �ቺ�[�Ɛቺ�y��
!       �� 3 �w�̎�    TMP_SNOW(I,4)   = TMP_SNSL(I)  
!                      HDF_SNOW_H(I,3) = �ቺ�[�Ɛቺ�y��
! 
!     �ET_{frez} �ɓ������ꍇ�͂��̑w�͉��x�ω����Ȃ��Ƃ��ĕ]������B
!       PHASE_SNOW   ! ���ω� on 0 off 1
!
! ����
!   PHASE_SNOW �ŁA�w�̐��̈���̑w�ŗ�Ƃ��Ă���̂́A�t���b�N�X�v�Z��
!   �ۂ̕֋X�̂���
!
      USE SIBPRM , ONLY : 
     I    IDX     , 
     I    ISN
!
      USE SIBCON , ONLY : 
     1    CAP_WTR_c  ,                            ! CW 
     1    CAP_GLA_c  ,                            ! CICE 
     1    TMP_FREZ_c
!
#ifdef MONYOS
      USE SIB_MONIT , ONLY : MONIT_SIB , ICS , INS ,
     1                IMONIT_LEVEL , IMONIT_ALL , IMONIT_FLUX_COMMON
#endif
!
      IMPLICIT NONE
!
! INPUT 
!
      INTEGER,INTENT(IN)    :: NMAX  
      INTEGER,INTENT(IN)    :: NMAX_01(3)  
      INTEGER,INTENT(IN)    :: NMAX_1(3)    
      INTEGER,INTENT(IN)    :: NMAX_2(3)  
      INTEGER,INTENT(IN)    :: NMAX_3(3)    
      INTEGER,INTENT(IN)    :: NMAX_4(3)  
      REAL(8),INTENT(IN)    :: DELT_SNOW
      REAL(8),INTENT(IN)    :: DELT_SNOW_INV
!
      REAL(8),INTENT(IN)    :: WTR_SNOW  (IDX,ISN)
      REAL(8),INTENT(IN)    :: GLA_SNOW  (IDX,ISN)
      REAL(8),INTENT(IN)    :: CVR_SNW     (IDX)
      REAL(8),INTENT(IN)    :: CVR_SNW_INV   (IDX)
!
      REAL(8),INTENT(IN)    :: SRAD_BUCKET_SNW (IDX)     ! ��[����̒Z�g����
      REAL(8),INTENT(IN)    :: ENG_BUCKET_SNW  (IDX)      ! ��[����̔M
      REAL(8),INTENT(IN)    :: DEP_SNOW      (IDX,ISN+1) ! ��̐[��
      REAL(8),INTENT(IN)    :: TMP_SNOW      (IDX,ISN+1) ! ��̉��x
!
      REAL(8),INTENT(IN)    :: HDF_SNOW_H  (IDX,ISN)   ! �ᒆ�M�`���W��
!     REAL(8),INTENT(IN)    :: HDF_SNOW_BH (IDX)       ! ��B �ƒn��
!
! OUTPUT 
!
      REAL(8),INTENT(OUT)  :: PHASE_SNOW    (IDX,ISN) ! ��x -> 0 ����ȉ�->1
!                                                     ! �������Ⴊ�Ȃ��w�ł�0
!
      REAL(8),INTENT(OUT)  :: CAP_SNOW      (IDX,ISN) ! ��̔�M
      REAL(8),INTENT(OUT)  :: HFLUX_CONV (IDX,ISN) ! ��̒Z�g�z��
      REAL(8),INTENT(OUT)  :: SRAD_BUCKET_SNOW_TO_SNSL(IDX)  
!                                                 ! �n�ʑ��w�ւ̒Z�g����
!                                                     !   �P�ʎ��ԓ�
!
!     REAL(8),INTENT(OUT)  :: ENG_BUC (IDX)       ! ��[����̃G�l���M�[
!                                                 ! �P�ʎ��ԓ��A��L��̕���
!
      REAL(8),INTENT(OUT)  :: HDIFF_FLUX_H   (IDX,0:ISN) 
!                                            ! �w�̐��Ɠ����� K �ł́A
!                                            ! �n���ւ̃t���b�N�X
!
! WORK
      INTEGER   :: I
      REAL(8)   :: XMU
      REAL(8)   :: ABSORB
      REAL(8)   :: SRAD_FLUX_H   (IDX,0:1) ! ��̒Z�g�t���b�N�X 0->1,1->2
!                                                     !   �P�ʎ��ԓ�
      REAL(8)   :: SRAD_BUC_DOWN (IDX)     ! �n�ʑ��w�ւ̒Z�g����
!                                                     !   �P�ʎ��ԓ�
!
      REAL(8),PARAMETER   :: XMU_TF   =  20.D0      ! tmp_frez 
      REAL(8),PARAMETER   :: XMU_GLA  = 100.D0      ! < tmp_frez_c 
      REAL(8),PARAMETER   :: DELT_TEMP_INV = 0.5D0  ! = 1/2K
      REAL(8),PARAMETER   :: ONE = 1.D0 
      REAL(8)             :: FACT 
!
#ifdef MONYOS
!     REAL(8)            :: WORK(IDX) 
      CHARACTER(7)       :: CMARK
#endif
      
!
      LOGICAL,SAVE :: LFIRST 
      DATA LFIRST / .TRUE. /
!
      IF ( LFIRST ) THEN
        WRITE(6,*) 'SNOW_HFLUX_PRE POCHAKA 99/08/09' 
        LFIRST = .FALSE.
      ENDIF
!
! --------------
! > PHASE_SNOW <
! --------------
!
      DO 1100 I=NMAX_01(2),NMAX
        IF ( TMP_SNOW(I,1) .EQ. TMP_FREZ_c ) THEN
          PHASE_SNOW(I,1) = 0
        ELSE
          PHASE_SNOW(I,1) = 1
        ENDIF
 1100 CONTINUE 
      DO 1200 I=NMAX_2(2),NMAX
        IF ( TMP_SNOW(I,2) .EQ. TMP_FREZ_c ) THEN
          PHASE_SNOW(I,2) = 0
        ELSE
          PHASE_SNOW(I,2) = 1
        ENDIF
 1200 CONTINUE 
      DO 1300 I=NMAX_3(2),NMAX
        IF ( TMP_SNOW(I,3) .EQ. TMP_FREZ_c ) THEN
          PHASE_SNOW(I,3) = 0
        ELSE
          PHASE_SNOW(I,3) = 1
        ENDIF
 1300 CONTINUE 
      DO 1400 I=NMAX_4(2),NMAX
        IF ( TMP_SNOW(I,4) .EQ. TMP_FREZ_c ) THEN
          PHASE_SNOW(I,4) = 0
        ELSE
          PHASE_SNOW(I,4) = 1
        ENDIF
 1400 CONTINUE 
!
!  �ȉ��̓_�~�[�B�t���b�N�X�v�Z�ł̕֋X�̂���
!
      DO 1500 I=NMAX_01(2),NMAX_1(3)
        PHASE_SNOW(I,2) = 0
 1500 CONTINUE 
      DO 1600 I=NMAX_2(2),NMAX_2(3)
        PHASE_SNOW(I,3) = 0
 1600 CONTINUE 
      DO 1700 I=NMAX_3(2),NMAX_3(3)
        PHASE_SNOW(I,4) = 0
 1700 CONTINUE 
!
      HFLUX_CONV (:,:) = 0. 
!
! ------------
! > ����w <
! ------------
!
      DO 2100 I=NMAX_01(2),NMAX           ! �Ⴊ����Ƃ���
!
!   �M�e��   
!
        CAP_SNOW(I,1) =
     1      (   CAP_GLA_c  * GLA_SNOW(I,1)
     1        + CAP_WTR_c  * WTR_SNOW(I,1) )
     1       * CVR_SNW_INV(I)                 ! fix 01/08/17 �i�q B ���ς�
!                                         
!
!   ��[������˂���G�l���M�[���t���b�N�X�Ɋ��Z �i�Ⴀ��敽�ρj
!
        HDIFF_FLUX_H(I,0) = ENG_BUCKET_SNW (I) 
     1                       * CVR_SNW_INV(I) * DELT_SNOW_INV 
!
        SRAD_FLUX_H(I,0) = SRAD_BUCKET_SNW(I) 
     1                       * CVR_SNW_INV(I) * DELT_SNOW_INV 
!
!   �Z�g���˃t���b�N�X�z���� 
!
        FACT = ( TMP_FREZ_c - TMP_SNOW(I,1) ) * DELT_TEMP_INV 
        FACT = MIN ( FACT, ONE )  
        XMU =   XMU_TF * (1-FACT) +  XMU_GLA * FACT  
!
        ABSORB = 1. - DEXP( -XMU * DEP_SNOW(I,1) )        
        SRAD_FLUX_H(I,1) = SRAD_FLUX_H(I,0) * ( 1 - ABSORB ) ! ��w�̉���
        SRAD_BUC_DOWN (I) =  SRAD_FLUX_H(I,1)
        HFLUX_CONV (I,1) = SRAD_FLUX_H(I,0) - SRAD_FLUX_H(I,1)
!
!   �M�`���t���b�N�X����  �i��w�����Ȃ��ꍇ�� TMP_SNOW(2) = TMP_SNSL(I)�j
!
        HDIFF_FLUX_H (I,1) = 
     1        HDF_SNOW_H(I,1) * ( TMP_SNOW (I,1) - TMP_SNOW(I,2) ) 
!
#ifdef MONYOS
        HDIFF_FLUX_H (I,2) = HDIFF_FLUX_H (I,1)  
        HDIFF_FLUX_H (I,3) = HDIFF_FLUX_H (I,1)  
        HDIFF_FLUX_H (I,4) = HDIFF_FLUX_H (I,1)  
#endif
!
 2100 CONTINUE
!
! ------------
! > ����w <
! ------------
!
      DO 2200 I=NMAX_2(2),NMAX         
!
!   �M�e��
!
        CAP_SNOW(I,2) 
     1     =   CAP_GLA_c  * GLA_SNOW(I,2)
     1       + CAP_WTR_c  * WTR_SNOW(I,2) 
!
!   ��[������˂���G�l���M�[ = �S�ċz��
!
        SRAD_BUC_DOWN (I)   = 0. 
        HFLUX_CONV (I,2) = SRAD_FLUX_H(I,1) 
!
!   �M�`���t���b�N�X����
!
        HDIFF_FLUX_H (I,2) = 
     1        HDF_SNOW_H(I,2) * ( TMP_SNOW (I,2) - TMP_SNOW(I,3) ) 
!
#ifdef MONYOS
        HDIFF_FLUX_H (I,3) = HDIFF_FLUX_H (I,2)  
        HDIFF_FLUX_H (I,4) = HDIFF_FLUX_H (I,2)  
#endif
 2200 CONTINUE
!
! ------------
! > ���O�w <
! ------------
!
      DO 2300 I=NMAX_3(2),NMAX            ! �Ⴊ 3 �w�ȏ゠��Ƃ���
        CAP_SNOW(I,3) 
     1     =   CAP_GLA_c  * GLA_SNOW(I,3)
     1       + CAP_WTR_c  * WTR_SNOW(I,3) 
!
!   �M�`���t���b�N�X����
!
        HDIFF_FLUX_H (I,3) = 
     1        HDF_SNOW_H(I,3) * ( TMP_SNOW (I,3) - TMP_SNOW(I,4) ) 
!
#ifdef MONYOS
        HDIFF_FLUX_H (I,4) = HDIFF_FLUX_H (I,3)  
#endif
 2300 CONTINUE
!
! ------------
! > ���l�w <
! ------------
!
      DO 2400 I=NMAX_4(2),NMAX            ! �Ⴊ 4 �w�ȏ゠��Ƃ���
        CAP_SNOW(I,4) 
     1     =   CAP_GLA_c  * GLA_SNOW(I,4)
     1       + CAP_WTR_c  * WTR_SNOW(I,4) 
!
!   �M�`���t���b�N�X����
!
        HDIFF_FLUX_H (I,4) = 
     1        HDF_SNOW_H(I,4) * ( TMP_SNOW (I,4) - TMP_SNOW(I,5) ) 
 2400 CONTINUE
!
!   �Z�g�̒n���ւ̐Z���ʂ��ABUCKET �Ɂi�Ⴀ��E�����敽�ρA* DELT_SNOW �����j
!     ( ���ۂɂ͈�w�̏ꍇ�̂ݒl���� )
!
      DO 3000 I=NMAX_01(2),NMAX
        SRAD_BUCKET_SNOW_TO_SNSL(I) 
     1          = SRAD_BUC_DOWN(I) * DELT_SNOW * CVR_SNW(I)
 3000 CONTINUE
!
#ifdef MONYOS
!
! ==============
! > �i�q���ϗ� <
! ==============
!
      IF ( IMONIT_LEVEL .GE. IMONIT_FLUX_COMMON ) THEN
!
!  ��[�ł̃G�l���M�[
!
        CMARK  = 'HFLBWS'
        CALL MONIT_SIB ( CMARK , ENG_BUCKET_SNW , INS , ONE , ONE )  
!       CALL MONIT_SIB ( CMARK , HDIFF_FLUX_H(1,0),ICS,DELT_SNOW, ONE )   
!       �ȏ��͓����͂��B
!
!  ��[�ł̒Z�g
!     ��[
        CMARK  = 'HSRBWS'
        CALL MONIT_SIB ( CMARK , SRAD_BUCKET_SNW , INS , ONE , ONE )  
!
      ENDIF
!
! ========
! > �ڍ� <
! ========
!
      IF ( IMONIT_LEVEL .GE. IMONIT_ALL ) THEN
!
!  ���[�ł̒Z�g = ��������� 
!
        CMARK  = 'HSRBWL'
        CALL MONIT_SIB ( CMARK , SRAD_BUCKET_SNOW_TO_SNSL,INS,ONE,ONE)  
      
!
!  �M�t���b�N�X �i�z�I�]���j
!
        CMARK  = 'HFLW12' 
        CALL MONIT_SIB ( CMARK , HDIFF_FLUX_H(1,1),ICS,DELT_SNOW, ONE )   
        CMARK  = 'HFLW23' 
        CALL MONIT_SIB ( CMARK , HDIFF_FLUX_H(1,2),ICS,DELT_SNOW, ONE )  
        CMARK  = 'HFLW34' 
        CALL MONIT_SIB ( CMARK , HDIFF_FLUX_H(1,3),ICS,DELT_SNOW, ONE )  
        CMARK  = 'HFLW4L' 
        CALL MONIT_SIB ( CMARK , HDIFF_FLUX_H(1,4),ICS,DELT_SNOW, ONE )  
!
      ENDIF
!
!
! �Z�g�t���b�N�X ... ���������
!
      IF ( IMONIT_LEVEL .GE. IMONIT_ALL ) THEN 
        CMARK  = 'HSRW12' 
        CALL MONIT_SIB ( CMARK , SRAD_FLUX_H(1,1),ICS,DELT_SNOW, ONE )  
      ENDIF
#endif
!
      RETURN
      END
!==================================================================
      SUBROUTINE MR_SNOW_HFLUX_PRE
!
! SNOW_PRE �ŏo�͂���f�o�b�O�p�ϐ��̓o�^���
!
#ifdef MONYOS
      USE SIB_MONIT , ONLY : 
     1                IMONIT_LEVEL , IMONIT_ALL , IMONIT_FLUX_COMMON
#endif
!
      IMPLICIT NONE
!
      CHARACTER( 7)  :: CMARK 
      CHARACTER(32)  :: CTITLE 
      CHARACTER(13)  :: CUNIT
!
      LOGICAL,SAVE ::  LFIRST 
!
!
      DATA LFIRST /.TRUE./
!
      IF ( LFIRST ) THEN
        WRITE(6,*) 'MONIT_REGIST_SNOW_HFLUX_PRE 99/10 POCHAKA'
        LFIRST = .FALSE. 
      ENDIF
!
! ------------------
! > ��S�̂̎��x�p <
! ------------------
!
!  �G�l���M�[�t���b�N�X
!
#ifdef MONYOS
      IF ( IMONIT_LEVEL .GE. IMONIT_FLUX_COMMON ) THEN
!
      CMARK  = 'HFLBWS'
      CTITLE = 'ENG FLUX FROM CANOPY TO SNOW TOP'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  �Z�g���˃t���b�N�X
!
      CMARK  = 'HSRBWS'
      CTITLE = 'SRAD FLUX INTO SNOW TOP'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      ENDIF
!
      IF ( IMONIT_LEVEL .GE. IMONIT_ALL ) THEN
!
      CMARK  = 'HSRBWL'
      CTITLE = 'SRAD FLUX INTO SNSL'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
! �M�`�� ( �z�I�]���̂� ) 
!
      CMARK  = 'HFLW12'
      CTITLE = 'HEAT DIFFUSION FLUX FROM SNOW 1 TO 2 EXP'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HFLW23'
      CTITLE = 'HEAT DIFFUSION FLUX FROM SNOW 2 TO 3 EXP'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HFLW34'
      CTITLE = 'HEAT DIFFUSION FLUX FROM SNOW 3 TO 4 EXP'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HFLW4L'
      CTITLE = 'HEAT DIFFUSION FLUX FROM SNOW 4 TO SNSL EXP'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      ENDIF
!
! �M�`�� ( �S�� ) 
!
      IF ( IMONIT_LEVEL .GE. IMONIT_FLUX_COMMON ) THEN
!
      CMARK  = 'HFLW12F'
      CTITLE = 'HEAT DIFFUSION FLUX FROM SNOW 1 TO 2 '
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HFLW23F'
      CTITLE = 'HEAT DIFFUSION FLUX FROM SNOW 2 TO 3 '
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HFLW34F'
      CTITLE = 'HEAT DIFFUSION FLUX FROM SNOW 3 TO 4 '
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HFLW4LF'
      CTITLE = 'HEAT DIFFUSION FLUX FROM SNOW 4 TO SNSL '
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      ENDIF
!
!
! �Z�g���˃t���b�N�X
!
      IF ( IMONIT_LEVEL .GE. IMONIT_ALL ) THEN
!
      CMARK  = 'HSRW12'
      CTITLE = 'SRAD FLUX FROM SNOW 1 TO 2'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
! �M�o�P�c �i�� -> �y��j ... snow_hflux_imp/explicit
!
      CMARK  = 'HFLBWL'
      CTITLE = 'HEAT FROM SNOW TO SOIL'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      ENDIF
#endif
!
      RETURN
      END