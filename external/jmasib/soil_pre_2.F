! �y��̏���
!   �E�����E���U���ɂ��y��g�b�v���甲����ʂ𔲂�
!   �E�ォ�����J�E�Z�ᐅ��y��ɂ��݂��܂���
!   �E���ӁB��L�͂�������ADELT_SOIL �̂��������ʂŌv�Z����B
!     RUNOFF_S ���o�͂��邪�A����͒P�ʎ��ԓ�����̐��t���b�N�X�ɂ������̂ŁA
!     �Ō�ɒP�ʕϊ����s�Ȃ��B
!   
! 99/07/12 �ۍ␪�G�Ahcap2.F ���ړ�
! 99/08/04 �ۍ␪�G ��򂳂�ɓn���o�[�W�����t�B�b�N�X
! 99/10/04 �ۍ␪�G �啝�ύX�Bsoil_pre �ɂ���B�Ⴀ�薳�����p�B
! 2000-09-27 �L�c�p�i �s���Ȓl�Ŏ~�߂錟����������
!
! 
!
! �Â� cpp ���g���Ă��܂����ꍇ�̑Ή�
#ifndef __LINE__
#  define __LINE__
#endif
!
      SUBROUTINE SOIL_PRE_2 (
     I    NSTR        , NEND        , INSFLAG  , 
     I    NSTR_2      , NEND_2      ,  
     I    CVR_NorS_INV   ,  
     I    NTYP             , 
     I    TMP_SOIL_IN    , TMP_SOIL4_IN , 
     I    FR_WTR_SOIL_IN , 
     I    FR_GLA_SOIL_IN , 
     I    FACT_WGT_H2O , FACT_WGT_H2O_INV , CAP_SOLID  , 
     I    DELT_SOIL   , 
     I    WTR_BUCKET_INTO    , ENH_BUCKET_INTO  , 
     I    WTR_BUCKET_IN_SN2GR, ENH_BUCKET_IN_SN2GR , 
     I    H2O_BUCKET_FROM    , ENH_BUCKET_FROM  , 
     I    TRNS_BUCKET    , 
     O    TMP_SOIL    , TMP_SOIL4   , 
     O    FR_WTR_SOIL , FR_GLA_SOIL , 
     O    CAP_SOIL    , CAP_SOIL_INV, 
     O    ENG_SOIL    , H2O_SOIL    , 
     O    PHASE_SOIL  , RUNOFF_S  )
!
!  ���� 
!    �E�����E���؁E���U���́A�͂��߂Ɏ�菜���Ă��܂��B
!      �L���m�s�[�v�Z���ł͂���Ƃ݂���ŕ]�����������̂��A
!      ���͔M�v�Z��������ł͖����Ȃ��Ă��܂��Ă����A�Ƃ����̂ł�
!      ���邩��ł���B
!      �Ȃ��A�{���A�������ō���������鐅�ɂƂ��Ȃ��G�l���M�[�͕�����Ȃ�
!      �͂������A�����ł͓y��̐������̉��x�Ŕ������Ɖ��肵�Ă���̂ŁA
!      TMP_SOIL ���炻�̂܂܋��߂邱�Ƃɂ���B    
!
!    �E���𔲂����Ǝv�����琅�������ĕX�𔲂��ꍇ�A���̃G�l���M�[��
!      �l����K�v�������B 
!             ... ���āA�ǂ������Ӗ���? ( 01/09/04 �ۍ� )
!      �����E���؁E���U�M�o�P�c�Ə����E���؁E���U���o�P�c�ɓ����Ă���
!      �G�l���M�[�� H2O ���������΁A�����̂����ł���X�ł���A������
!      ����ł���B�i�y��̃t���b�N�X�]���ɂ͌������낤���A�Ō�̉��x��
!      ���ɂ͒��ڂ͌����Ȃ��B�j
!
!    �EH2O ���̂��̂�����Ȃ��ꍇ�́AH2O �𑫂�Ȃ����������Ă��
!
!    �E�M�̌v�Z�p�ɕK�v�ȕϐ����o�͂���
!      
      USE SIBPRM , ONLY : 
     1    IDX     , 
     1    IDP     , 
     1    ITYP 
!
      USE SIBCON , ONLY : 
     1    CAP_WTR_c  ,                            ! CW 
     1    CAP_GLA_c  ,                            ! CICE 
     1    TMP_FREZ_c  , 
     1    HL_W2G_c   ,
     1    RHO_WTR_C  , 
     1    CAP_SOIL4_c   
!
      USE SIBVEG , ONLY : 
     1           POR_SOIL_co            ,  ! �󌄗�   (ITYP)  
     1           BEE_co                 ,  ! �y�됅���ˑ����W�� (ITYP)
     1           DEP_SOIL_co             , ! �y��w�̐[��    (ITYP,IDP)
     1           WCOEF_SAT_SOIL_co         ! �O�a�����W��    (ITYP)

!
#ifdef MONYOS
      USE SIB_MONIT , ONLY : MONIT_SIB , ICN,ICS,INN,INS,INA,
     1                       IMONIT_LEVEL , IMONIT_ALL,
     1                       IMONIT_FLUX_COMMON , IMONIT_ALMA 
#endif
!
      IMPLICIT NONE
!
! INPUT 
!
      INTEGER,INTENT(IN)    :: NSTR
      INTEGER,INTENT(IN)    :: NEND
      INTEGER,INTENT(IN)    :: NSTR_2           ! NMAX_0(2)
      INTEGER,INTENT(IN)    :: NEND_2           ! NMAX_0(3)
      INTEGER,INTENT(IN)    :: INSFLAG 
!
      REAL(8),INTENT(IN)    :: FACT_WGT_H2O     (IDX,IDP)  ! �󌄗�x���̔�d
      REAL(8),INTENT(IN)    :: FACT_WGT_H2O_INV (IDX,IDP)  ! �󌄗�x���̔�d
!
      REAL(8),INTENT(IN)    :: CVR_NorS_INV     (IDX)      ! ��ʔ핢��
      INTEGER,INTENT(IN)    :: NTYP             (IDX)
!
      REAL(8),INTENT(IN)    :: TRNS_BUCKET      (IDX,IDP)
!
      REAL(8),INTENT(IN)    :: TMP_SOIL_IN      (IDX,IDP)
      REAL(8),INTENT(IN)    :: TMP_SOIL4_IN     (IDX)
!
      REAL(8),INTENT(IN)    :: FR_WTR_SOIL_IN   (IDX,IDP)
      REAL(8),INTENT(IN)    :: FR_GLA_SOIL_IN   (IDX,IDP)
!
      REAL(8),INTENT(IN)    :: H2O_BUCKET_FROM(IDX) 
      REAL(8),INTENT(IN)    :: ENH_BUCKET_FROM(IDX) 
!
      REAL(8),INTENT(IN)    :: CAP_SOLID (IDX,IDP) 
!
!   �o�P�c�֘A
!
      REAL(8),INTENT(IN)   ::  DELT_SOIL
      REAL(8),INTENT(IN)   ::  WTR_BUCKET_INTO         (IDX)
      REAL(8),INTENT(IN)   ::  ENH_BUCKET_INTO         (IDX)
!
!        ! ��Ȃ�(0) ��ň�U����o�P�c����Z������
      REAL(8),INTENT(IN)   ::  WTR_BUCKET_IN_SN2GR     (IDX) 
      REAL(8),INTENT(IN)   ::  ENH_BUCKET_IN_SN2GR     (IDX)
!
!
! OUTPUT 
!
      REAL(8),INTENT(OUT)   :: FR_WTR_SOIL  (IDX,IDP)
      REAL(8),INTENT(OUT)   :: FR_GLA_SOIL  (IDX,IDP)
!
      REAL(8),INTENT(OUT)   :: PHASE_SOIL   (IDX,IDP)  ! ��x�̎� 0 �� 1
      REAL(8),INTENT(OUT)   :: TMP_SOIL     (IDX,IDP) 
      REAL(8),INTENT(OUT)   :: TMP_SOIL4    (IDX) 
      REAL(8),INTENT(OUT)   :: CAP_SOIL     (IDX,IDP) 
      REAL(8),INTENT(OUT)   :: CAP_SOIL_INV (IDX,IDP) 
!
      REAL(8),INTENT(INOUT) :: ENG_SOIL     (IDX,IDP) 
      REAL(8),INTENT(INOUT) :: H2O_SOIL     (IDX,IDP) 
!
      REAL(8),INTENT(INOUT) :: RUNOFF_S     (IDX)      ! �o�͎��� kg/m**2/s
!
!
! WORK
!
      REAL(8)   :: WTR_SOIL
      REAL(8)   :: GLA_SOIL
!
!     REAL(8)   :: XFR_WTR   (IDX)    ! W �󌄒��ŉt���̐�߂�̐ϔ�
!     REAL(8)   :: XPOROS    (IDX)    ! �󌄗� �i1- �y - �X�j
!
! ��Ȃ���ł́A����̗Z�ᐅ ��
!
      REAL(8)   :: WTR_MOVE     (IDX) ! �ᖳ����� �� ����̐�
      REAL(8)   :: ENH_MOVE     (IDX)   
!
! �����Ȃǂɂ�鏜����
!
      REAL(8)   :: H2O_ADD_SOIL(IDX,IDP)
      REAL(8)   :: ENH_ADD_SOIL(IDX,IDP)
!
! ���̐Z���ƃ����I�t ( �����I�t�ʂ��̂��̂̓��j�^�o�� ) 
!
      REAL(8)   :: WTR_INFILT_1 (IDX)
      REAL(8)   :: WTR_INFILT_2 (IDX)
      REAL(8)   :: ENH_INFILT_1 (IDX)
      REAL(8)   :: ENH_INFILT_2 (IDX)
      REAL(8)   :: ENH_RUNOFF_S (IDX) 
!
      REAL(8)   :: WTR_IN_TRY             ! �J��
      REAL(8)   :: ENH_IN_TRY
      REAL(8)   :: WTR_INTO               ! �y��1,2 �w�֓��鐅
      REAL(8)   :: WTR_IN_MAX0            ! 1 �w�ɓ��낤�Ƃ�����
      REAL(8)   :: WTR_IN_MAX1            ! 1 �w�̂�����
      REAL(8)   :: WTR_IN_MAX2            ! 2 �w�̂�����
      REAL(8)   :: FAC_INFILT_1 
      REAL(8)   :: FAC_INFILT_2 
!
! �s�����̒ǉ�
!
      REAL(8)   :: ENG_MOD (IDX,IDP)
      REAL(8)   :: H2O_MOD (IDX,IDP)
!
! ���x�v�Z�p
!
      REAL(8)   :: FAC
      REAL(8)   :: ENX_SOIL
!
      INTEGER               :: I
      INTEGER               :: J
      INTEGER               :: K
!
      REAL(8),PARAMETER  :: ZERO = 0.D0
!
      REAL(8),PARAMETER :: SMALL  = 1.D-30   
!
#ifdef MONYOS
!     REAL(8),PARAMETER  :: DM1 = -1.D0 
      REAL(8),PARAMETER  :: ONE = 1.D0 
      REAL(8)            :: WORK(IDX) 
      CHARACTER(7)       :: CMARK
#endif
!
#ifdef SIB_DEBUG
      REAL(8)  :: H2O_STR(IDX) 
      REAL(8)  :: ENG_STR(IDX) 
      REAL(8)  :: H2O_END(IDX) 
      REAL(8)  :: ENG_END(IDX) 
      REAL(8)  :: H2O_DIFF_MIN
      REAL(8)  :: ENG_DIFF_MIN
#endif
!
      LOGICAL, SAVE:: LFIRST = .TRUE.
!
      IF ( LFIRST ) THEN 
        WRITE(6,*) 'SOIL_PRE 99/10/04 POCHAKA'
        LFIRST = .FALSE. 
      ENDIF
!
!  --------------
!  >> ������� <<
!  --------------
!
      DO 1000 K=1,IDP
      DO 1000 I=NSTR,NEND
        WTR_SOIL         = FR_WTR_SOIL_IN(I,K) * FACT_WGT_H2O(I,K)
        GLA_SOIL         = FR_GLA_SOIL_IN(I,K) * FACT_WGT_H2O(I,K)
        CAP_SOIL(I,K)
     1     =    CAP_SOLID(I,K)
     1       +  CAP_WTR_c  * WTR_SOIL
     1       +  CAP_GLA_c  * GLA_SOIL
!
        H2O_SOIL (I,K) = WTR_SOIL + GLA_SOIL
        ENG_SOIL (I,K) 
     1     = CAP_SOIL(I,K) * ( TMP_SOIL_IN(I,K) - TMP_FREZ_c )
     1       - HL_W2G_c * GLA_SOIL
 1000 CONTINUE           
!
      TMP_SOIL4(:) = 0.
      TMP_SOIL4(NSTR:NEND) = TMP_SOIL4_IN(NSTR:NEND) 
!
#ifdef SIB_DEBUG
      H2O_STR(:) = 0.
      ENG_STR(:) = 0.
      DO K=1,IDP
      DO I=NSTR,NEND
        H2O_STR(I) = H2O_STR(I) + H2O_SOIL(I,K)
        ENG_STR(I) = ENG_STR(I) + ENG_SOIL(I,K)
      ENDDO 
      ENDDO 
!
!      DO I=NSTR,NEND
!        ENG_STR(I) = ENG_STR(I) + CAP_SOIL4_c * TMP_SOIL4(I)
!      ENDDO
!
      IF ( INSFLAG .EQ. 0 ) THEN 
        DO I=NSTR_2,NEND_2
          H2O_STR (I) = H2O_STR (I) + WTR_BUCKET_IN_SN2GR (I)
          ENG_STR (I) = ENG_STR (I) + ENH_BUCKET_IN_SN2GR (I)  
        ENDDO
      ENDIF
!
      DO I=NSTR,NEND
        H2O_STR (I) = H2O_STR(I) + H2O_BUCKET_FROM(I)*CVR_NorS_INV(I) 
        ENG_STR (I) = ENG_STR(I) + ENH_BUCKET_FROM(I)*CVR_NorS_INV(I) 
      ENDDO 
!
      DO K=1,IDP
      DO I=NSTR,NEND
        H2O_STR (I) = H2O_STR(I) 
     1        + TRNS_BUCKET (I,K) * CVR_NorS_INV (I) 
!
        ENG_STR (I) = ENG_STR(I) 
     1        + CAP_WTR_c * TRNS_BUCKET (I,K) * CVR_NorS_INV (I) 
     1           * ( TMP_SOIL_IN(I,K) - TMP_FREZ_c ) 
      ENDDO 
      ENDDO 
!
      DO I=NSTR,NEND
        H2O_STR (I) = H2O_STR(I) 
     1                + WTR_BUCKET_INTO(I) * CVR_NorS_INV(I)
        ENG_STR (I) = ENG_STR(I) 
     1                + ENH_BUCKET_INTO(I) * CVR_NorS_INV(I)
      ENDDO 
#endif        
!
! ======================
! >> �o�P�c�C���̊J�n << 
! ======================
!
      CALL RESET ( ENH_ADD_SOIL , IDX*IDP )
      CALL RESET ( H2O_ADD_SOIL , IDX*IDP )
!
      CALL RESET ( WTR_MOVE     , IDX     )
      CALL RESET ( ENH_MOVE     , IDX     )
!
! =============================================
! >> ��핢�� = 0 �Ȃ̂ɐ�w���琅������ꍇ <<
! =============================================
!    �Ⴊ��������ŁA����o�P�c���琅������ꍇ�ȂǁB
!
      IF ( INSFLAG.EQ.0 ) THEN
        DO I=NSTR_2,NEND_2
          WTR_MOVE (I) = WTR_BUCKET_IN_SN2GR (I)
          ENH_MOVE (I) = ENH_BUCKET_IN_SN2GR (I)  
        ENDDO
      ENDIF      
!
! ========================
! >> �����I�������̕]�� << 
! ========================
!
! --------------------------
! > �����E���؂ɂ�鏜���� < 
! --------------------------
!    �����A���؂̐���X�������B
!    �X�͏��؂����Ȃ̂ŁAK=1 �̎��_�Ō��܂�B
!
      DO 2000 I = NSTR , NEND
        H2O_ADD_SOIL (I,1) = H2O_BUCKET_FROM (I) * CVR_NorS_INV (I) 
        ENH_ADD_SOIL (I,1) = ENH_BUCKET_FROM (I) * CVR_NorS_INV (I) 
 2000 CONTINUE
!
! --------------------
! > ���U�ɂ�鏜���� < 
! --------------------
!
      DO 2100 K = 1,IDP 
      DO 2100 I = NSTR , NEND
        H2O_ADD_SOIL (I,K) 
     1      = H2O_ADD_SOIL(I,K) 
     1        + TRNS_BUCKET (I,K) * CVR_NorS_INV (I) 
!
        ENH_ADD_SOIL(I,K) 
     1      = ENH_ADD_SOIL(I,K)
     1        + CAP_WTR_c * TRNS_BUCKET (I,K) * CVR_NorS_INV (I) 
     1           * ( TMP_SOIL_IN(I,K) - TMP_FREZ_c ) 
 2100 CONTINUE
!
! ---------------------------------------------------------
! > ���� < ( �G���[���� : ���̕s��������Ή����� ���܂� ) <
! ---------------------------------------------------------
!
      CALL RESET ( ENG_MOD      , IDX*IDP )
      CALL RESET ( H2O_MOD      , IDX*IDP )
!
      DO 2200 K = 1,IDP 
      DO 2200 I = NSTR , NEND
        FAC = 1.D0 
        IF ( H2O_SOIL(I,K) + H2O_ADD_SOIL(I,K) .LT. 0 ) THEN
          FAC = H2O_SOIL(I,K) / MAX ( - H2O_ADD_SOIL(I,K) , SMALL ) 
        ENDIF 
!
        H2O_SOIL (I,K) = H2O_SOIL(I,K) + H2O_ADD_SOIL(I,K) * FAC 
        ENG_SOIL (I,K) = ENG_SOIL(I,K) + ENH_ADD_SOIL(I,K) * FAC 
!
        H2O_MOD  (I,K) = H2O_ADD_SOIL(I,K) * (1-FAC) 
        ENG_MOD  (I,K) = ENH_ADD_SOIL(I,K) * (1-FAC) 
 2200 CONTINUE  
!
! ==================
! >> ���ԃ`�F�b�N <<
! ==================
!
#ifdef SIB_DEBUG
      H2O_END(:) = 0.
      ENG_END(:) = 0.
      DO I=NSTR,NEND
        H2O_END(I) = WTR_BUCKET_INTO(I) * CVR_NorS_INV(I)
     1               + WTR_MOVE       (I) 
        ENG_END(I) = ENH_BUCKET_INTO(I) * CVR_NorS_INV(I)
     1               + ENH_MOVE       (I) 
      ENDDO 
!
      DO K=1,IDP
      DO I=NSTR,NEND
        H2O_END(I) = H2O_END(I) + H2O_SOIL(I,K) + H2O_MOD(I,K)
        ENG_END(I) = ENG_END(I) + ENG_SOIL(I,K) + ENG_MOD(I,K)
      ENDDO 
      ENDDO 
!

!
      DO I=NSTR,NEND
        IF ( ABS(H2O_STR(I)-H2O_END(I)) .GT. 1.D-9 ) THEN
          write(6,*) 'soil_pre_2 h2o middle error' , I , 
     1               H2O_STR(I)-H2O_END(I) , H2O_STR(I) , H2O_END(I),
     1               ENG_STR(I)-ENG_END(I) , ENG_STR(I) , ENG_END(I)
          stop 999
        ENDIF
        IF ( ABS(ENG_STR(I)-ENG_END(I)) .GT. 1.D-6 ) THEN
          write(6,*) 'soil_pre_2 eng middle error' , I , 
     1               H2O_STR(I)-H2O_END(I) , H2O_STR(I) , H2O_END(I),
     1               ENG_STR(I)-ENG_END(I) , ENG_STR(I) , ENG_END(I)
          stop 999
        ENDIF
      ENDDO 
#endif        
!
! ======================
! >> ��[����̐Z���� <<
! ======================
!   �ᖳ���� �` �~���E���I ( �����͐�ʂɂ����̂ŁA�����ł͂Ȃ� )
!   �Ⴀ��� �` �Z�ᐅ
!
!   �y����w�� 0 �x��荂����΁A�\�Ȃ������͐Z������B
!   ( 0 �x�ȉ��̏ꍇ�͋󌄗ʂ�����Ƃ��� )
!   ���w�ڂɂ́A�ȒP�̂��߁A�J���͐�������̉��x�������ĐZ������B
!
      DO 3000 K = 1,2
      DO 3000 I = NSTR , NEND
        ENX_SOIL = ENG_SOIL(I,K) + HL_W2G_c * H2O_SOIL(I,K) 
!
        IF   ( ENG_SOIL(I,K) .GT. 0 ) THEN
          GLA_SOIL = 0. 
          WTR_SOIL = H2O_SOIL(I,K)
!
        ELSEIF ( ENX_SOIL .LT. 0 ) THEN
          GLA_SOIL = H2O_SOIL(I,K)
          WTR_SOIL = 0. 
!
        ELSE  
          FAC = ENX_SOIL / MAX ( HL_W2G_c*H2O_SOIL(I,K), SMALL ) 
                ! ���̊��� 
          WTR_SOIL = H2O_SOIL(I,K) * FAC 
          GLA_SOIL = H2O_SOIL(I,K) * (1-FAC)
        ENDIF
!
        FR_WTR_SOIL(I,K) = WTR_SOIL * FACT_WGT_H2O_INV(I,K)
        FR_GLA_SOIL(I,K) = GLA_SOIL * FACT_WGT_H2O_INV(I,K)
 3000 CONTINUE  
!
!#ifdef DEBUG
!      CALL RESET ( WTR_INFILT_1  , IDX )
!      CALL RESET ( WTR_INFILT_2  , IDX )
!      CALL RESET ( ENH_INFILT_1  , IDX )
!      CALL RESET ( ENH_INFILT_2  , IDX )
!#endif
!
      DO 3100 I=NSTR,NEND
!
        J = NTYP(I)
!
! ���낤�Ƃ��鐅
!
        WTR_IN_TRY =   WTR_BUCKET_INTO(I) * CVR_NorS_INV(I)
     1               + WTR_MOVE       (I) 
        ENH_IN_TRY =   ENH_BUCKET_INTO(I) * CVR_NorS_INV(I)
     1               + ENH_MOVE       (I) 
!
! �Z��������� ( �����W���ő�l x ���ԍ� �A���ʊ��Z ) 
!
        WTR_IN_MAX0 =  WCOEF_SAT_SOIL_co(J) 
     1                * ( 1 - FR_GLA_SOIL(I,1) ) 
!    1                * XFR_WTR(I)**(2.*BEE_co(J)+3.)   ! w �ˑ�������
     1                * DELT_SOIL   
     1                * RHO_WTR_C                       ! 000731 
!
! ���ۂɓy��\�ʂ��������Ă����
!
        WTR_INTO  = MIN ( WTR_IN_TRY , WTR_IN_MAX0)
!
! ----------------------
! > �y����w�ւ̐Z�� <
! ----------------------
!
! ���w�̂����� ( ���̎��ʂɂ����ꍇ ) 
!
        WTR_IN_MAX1 = POR_SOIL_co(J) * DEP_SOIL_co(J,1)  ! (1-�y-�X)* �̐�
     1                * RHO_WTR_C             
     1                * ( 1. - FR_WTR_SOIL(I,1) -FR_GLA_SOIL(I,1) )     
!
! ���w�ɓ��鐅
!
        WTR_INFILT_1(I) = MIN ( WTR_INTO , WTR_IN_MAX1 ) 
!
! ----------------------
! > �y����w�ւ̐Z�� <
! ----------------------
!
! ���w������w�ɓ����ė��镪
!
        WTR_INTO = MAX ( WTR_INTO - WTR_INFILT_1(I) , ZERO ) 
!
! ���w�̂����� ( ���̎��ʂɂ����ꍇ ) 
!
        WTR_IN_MAX2 = POR_SOIL_co(J) * DEP_SOIL_co(J,2)  ! (1-�y-�X)* �̐�
     1                * RHO_WTR_C             
     1                * ( 1. - FR_WTR_SOIL(I,2) -FR_GLA_SOIL(I,2) )     
!
        WTR_INFILT_2(I) =  MIN ( WTR_INTO , WTR_IN_MAX2 )
!
! --------------
! > �����I�t�� <
! --------------
!
        FAC_INFILT_1 = WTR_INFILT_1(I) / MAX(WTR_IN_TRY,SMALL) 
        WTR_INFILT_1(I) = WTR_IN_TRY * FAC_INFILT_1
        ENH_INFILT_1(I) = ENH_IN_TRY * FAC_INFILT_1
!
        FAC_INFILT_2 = WTR_INFILT_2(I) / MAX(WTR_IN_TRY,SMALL) 
        WTR_INFILT_2(I) = WTR_IN_TRY * FAC_INFILT_2
        ENH_INFILT_2(I) = ENH_IN_TRY * FAC_INFILT_2
!
!        RUNOFF_S    (I) = WTR_IN_TRY * ( 1-FAC_INFILT_1-FAC_INFILT_2 )
!        ENH_RUNOFF_S(I) = ENH_IN_TRY * ( 1-FAC_INFILT_1-FAC_INFILT_2 )
        RUNOFF_S    (I) = WTR_IN_TRY 
     1         * max ( 1-FAC_INFILT_1-FAC_INFILT_2 , 0.D0 )
        ENH_RUNOFF_S(I) = ENH_IN_TRY 
     1         * max ( 1-FAC_INFILT_1-FAC_INFILT_2 , 0.D0 )
!
        H2O_SOIL(I,1) = H2O_SOIL(I,1) + WTR_INFILT_1(I) 
        ENG_SOIL(I,1) = ENG_SOIL(I,1) + ENH_INFILT_1(I) 
        H2O_SOIL(I,2) = H2O_SOIL(I,2) + WTR_INFILT_2(I) 
        ENG_SOIL(I,2) = ENG_SOIL(I,2) + ENH_INFILT_2(I) 
 3100 CONTINUE  
!
! ================
! >> ���ɕ����� <<
! ================
!
      DO 4000 K = 1,IDP
      DO 4000 I = NSTR , NEND
        ENX_SOIL  = ENG_SOIL(I,K) + HL_W2G_c * H2O_SOIL(I,K) 
        PHASE_SOIL(I,K) = 1.  
!
        IF   ( ENG_SOIL(I,K) .GT. 0 ) THEN
          GLA_SOIL = 0. 
          WTR_SOIL = H2O_SOIL(I,K)
          CAP_SOIL (I,K)  
     1     =    CAP_SOLID (I,K)
     1       +  CAP_WTR_c  * WTR_SOIL
     1       +  CAP_GLA_c  * GLA_SOIL
          CAP_SOIL_INV(I,K)  = 1./CAP_SOIL(I,K)
          TMP_SOIL(I,K) = TMP_FREZ_c + ENG_SOIL(I,K)*CAP_SOIL_INV(I,K) 
!
        ELSEIF ( ENX_SOIL .LT. 0 ) THEN
          GLA_SOIL = H2O_SOIL(I,K)
          WTR_SOIL = 0. 
          CAP_SOIL (I,K)  
     1     =    CAP_SOLID (I,K)
     1       +  CAP_WTR_c  * WTR_SOIL
     1       +  CAP_GLA_c  * GLA_SOIL
          CAP_SOIL_INV(I,K)  = 1./CAP_SOIL(I,K)
          TMP_SOIL(I,K) = TMP_FREZ_c + ENX_SOIL*CAP_SOIL_INV(I,K) 
!
        ELSE  
          FAC = ENX_SOIL / MAX ( HL_W2G_c*H2O_SOIL(I,K), SMALL ) 
                ! ���̊��� 
          WTR_SOIL = H2O_SOIL(I,K) * FAC 
          GLA_SOIL = H2O_SOIL(I,K) * (1-FAC)
          CAP_SOIL (I,K)  
     1     =    CAP_SOLID (I,K)
     1       +  CAP_WTR_c  * WTR_SOIL
     1       +  CAP_GLA_c  * GLA_SOIL
          CAP_SOIL_INV(I,K)  = 1./CAP_SOIL(I,K)
          TMP_SOIL(I,K) = TMP_FREZ_c 
          PHASE_SOIL(I,K) = 0.  
        ENDIF
!
        FR_WTR_SOIL(I,K) = WTR_SOIL * FACT_WGT_H2O_INV(I,K)
        FR_GLA_SOIL(I,K) = GLA_SOIL * FACT_WGT_H2O_INV(I,K)
 4000 CONTINUE  
!
! ==================
! >> �I���`�F�b�N <<
! ==================
!
#ifdef SIB_DEBUG
      H2O_END(:) = 0.
      ENG_END(:) = 0.
!
      DO I=NSTR,NEND
        H2O_END(I) = RUNOFF_S     (I)
        ENG_END(I) = ENH_RUNOFF_S (I)
      ENDDO 
!
      DO K=1,IDP
      DO I=NSTR,NEND
        H2O_END(I) = H2O_END(I) + H2O_SOIL(I,K) + H2O_MOD(I,K) 
        ENG_END(I) = ENG_END(I) + ENG_SOIL(I,K) + ENG_MOD(I,K)
      ENDDO 
      ENDDO 
!
      H2O_DIFF_MIN = -1
      ENG_DIFF_MIN = -1
      DO I=NSTR,NEND
        IF ( ABS(H2O_STR(I)-H2O_END(I)) .GT. H2O_DIFF_MIN ) THEN
           H2O_DIFF_MIN = ABS(H2O_STR(I)-H2O_END(I))
        ENDIF 
        IF ( ABS(ENG_STR(I)-ENG_END(I)) .GT. ENG_DIFF_MIN ) THEN
           ENG_DIFF_MIN = ABS(ENG_STR(I)-ENG_END(I))
        ENDIF 
!
        IF ( ABS(H2O_STR(I)-H2O_END(I)) .GT. 1.D-9 ) THEN
          write(6,*) 'soil_pre_2 h2o error' , I , 
     1               H2O_STR(I)-H2O_END(I) , H2O_STR(I) , H2O_END(I),
     1               ENG_STR(I)-ENG_END(I) , ENG_STR(I) , ENG_END(I)
          stop 999
        ENDIF
        IF ( ABS(ENG_STR(I)-ENG_END(I)) .GT. 1.D-6 ) THEN
          write(6,*) 'soil_pre_2 eng error' , I , 
     1               H2O_STR(I)-H2O_END(I) , H2O_STR(I) , H2O_END(I),
     1               ENG_STR(I)-ENG_END(I) , ENG_STR(I) , ENG_END(I)
          stop 999
        ENDIF
      ENDDO 
      write(6,*) 'soil_pre_2 diff_max h2o ' , h2o_diff_min
      write(6,*) 'soil_pre_2 diff_max eng ' , eng_diff_min
#endif        

!
! ================
! >> �ڍ׃��j�^ <<   ���� 1 ver 1
! ================
!
#ifdef MONYOS
!
! �i�q���ϗ� ( �����I�t )
!
      IF ( IMONIT_LEVEL .GE. IMONIT_FLUX_COMMON ) THEN
        CMARK  = 'ROFS'
        IF ( INSFLAG .EQ.0 ) THEN
          CALL MONIT_SIB ( CMARK , RUNOFF_S, ICN, ONE, ONE )  
        ELSE
          CALL MONIT_SIB ( CMARK , RUNOFF_S, ICS, ONE, ONE )  
        ENDIF
      ENDIF
!
      IF ( IMONIT_LEVEL .GE. IMONIT_ALMA ) THEN
        CMARK  = 'A_ROS'
        CALL MONIT_SIB ( CMARK , RUNOFF_S, INA, ONE, ONE )  
      ENDIF
!
      IF ( IMONIT_LEVEL .GE. IMONIT_ALL ) THEN
!
        IF ( INSFLAG.EQ.0 ) THEN       
!
! �����E���؂ɂ�鑝���X��
!
          CMARK  = 'WEVBLN'                                  ! ver2 
          CALL MONIT_SIB ( CMARK , H2O_BUCKET_FROM,INN, ONE, ONE )   
!
! �����E���؂ɂ�鑝���X�ɔ����G�l���M�[
!
          CMARK  = 'IEVBLN' 
          CALL MONIT_SIB ( CMARK , ENH_BUCKET_FROM,INN, ONE, ONE )
!
        ENDIF
!
! ���U�ɂ�鑝�����ʁA����ɔ����G�l���M�[��
!
!  ��w��
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'WTRBL1N' 
          CALL MONIT_SIB ( CMARK , TRNS_BUCKET,INN, ONE, ONE ) 
        ELSE
          CMARK  = 'WTRBL1S' 
          CALL MONIT_SIB ( CMARK , TRNS_BUCKET,INS, ONE, ONE ) 
        ENDIF
!
        DO I=NSTR,NEND
          WORK(I) = TRNS_BUCKET(I,1) 
     1              * CAP_WTR_c * ( TMP_SOIL_IN(I,1) - TMP_FREZ_c ) 
        ENDDO
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'ITRBL1N' 
          CALL MONIT_SIB ( CMARK , WORK ,INN, ONE, ONE ) 
        ELSE
          CMARK  = 'ITRBL1S' 
          CALL MONIT_SIB ( CMARK , WORK ,INS, ONE, ONE ) 
        ENDIF
!
! ��w��
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'WTRBL2N' 
          CALL MONIT_SIB ( CMARK , TRNS_BUCKET(1,2),INN, ONE, ONE ) 
        ELSE
          CMARK  = 'WTRBL2S' 
          CALL MONIT_SIB ( CMARK , TRNS_BUCKET(1,2),INS, ONE, ONE ) 
        ENDIF
!
        DO I=NSTR,NEND
          WORK(I) = TRNS_BUCKET(I,2) 
     1              * CAP_WTR_c * ( TMP_SOIL_IN(I,2) - TMP_FREZ_c ) 
        ENDDO
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'ITRBL2N' 
          CALL MONIT_SIB ( CMARK , WORK ,INN, ONE, ONE ) 
        ELSE
          CMARK  = 'ITRBL2S' 
          CALL MONIT_SIB ( CMARK , WORK ,INS, ONE, ONE ) 
        ENDIF
!
! �O�w��
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'WTRBL3N' 
          CALL MONIT_SIB ( CMARK , TRNS_BUCKET(1,3),INN, ONE, ONE ) 
        ELSE
          CMARK  = 'WTRBL3S' 
          CALL MONIT_SIB ( CMARK , TRNS_BUCKET(1,3),INS, ONE, ONE ) 
        ENDIF
!
        DO I=NSTR,NEND
          WORK(I) = TRNS_BUCKET(I,3) 
     1              * CAP_WTR_c * ( TMP_SOIL_IN(I,3) - TMP_FREZ_c ) 
        ENDDO
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'ITRBL3N' 
          CALL MONIT_SIB ( CMARK , WORK ,INN, ONE, ONE ) 
        ELSE
          CMARK  = 'ITRBL3S' 
          CALL MONIT_SIB ( CMARK , WORK ,INS, ONE, ONE ) 
        ENDIF
!
! ��[�����U���鐅  = �J�E���I  or �Z�ᐅ
!
        DO I=NSTR,NEND
          WORK(I) = WTR_BUCKET_INTO(I) * CVR_NorS_INV(I) 
        ENDDO
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'WFLBLN'
          CALL MONIT_SIB ( CMARK , WORK , ICN ,  ONE, ONE )        
        ELSE
          CMARK  = 'WFLBLW'
          CALL MONIT_SIB ( CMARK , WORK , ICS ,  ONE, ONE )        
        ENDIF
!
!    (�� -> �ᖳ���y��)
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'WFLBLNW'
          CALL MONIT_SIB ( CMARK , WTR_MOVE , ICN , ONE, ONE )        
        ENDIF 
!
! ��U���낤�Ƃ��鐅�ɔ����G�l���M�[
!
        DO I=NSTR,NEND
          WORK(I) = ENH_BUCKET_INTO(I) * CVR_NorS_INV(I) 
        ENDDO
        IF ( INSFLAG.EQ.0) THEN
          CMARK = 'IFLBLN' 
          CALL MONIT_SIB ( CMARK , WORK , ICN , ONE, ONE )  
        ELSE
          CMARK = 'IFLBLW' 
          CALL MONIT_SIB ( CMARK , WORK , ICS ,  ONE, ONE )  
        ENDIF
!
!    (�� -> �ᖳ���y��)
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'IFLBLNW'
          CALL MONIT_SIB ( CMARK , ENH_MOVE , ICN, ONE, ONE )        
        ENDIF 
!
! ���w�ɓ�������
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'WINFLN1'
          CALL MONIT_SIB ( CMARK , WTR_INFILT_1 , ICN , ONE, ONE )        
        ELSE
          CMARK  = 'WINFLS1'
          CALL MONIT_SIB ( CMARK , WTR_INFILT_1 , ICS, ONE, ONE )        
        ENDIF
!
! ���w�ɓ��������ɔ����G�l���M�[
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'IINFLN1'
          CALL MONIT_SIB ( CMARK , ENH_INFILT_1 , ICN, ONE, ONE )        
        ELSE
          CMARK  = 'IINFLS1'
          CALL MONIT_SIB ( CMARK , ENH_INFILT_1 , ICS, ONE, ONE )        
        ENDIF
!
! ���w�ɓ�������
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'WINFLN2'
          CALL MONIT_SIB ( CMARK , WTR_INFILT_2 , ICN, ONE, ONE )        
        ELSE
          CMARK  = 'WINFLS2'
          CALL MONIT_SIB ( CMARK , WTR_INFILT_2 , ICS, ONE, ONE )        
        ENDIF
!
! ���w�ɓ��������ɔ����G�l���M�[
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'IINFLN2'
          CALL MONIT_SIB ( CMARK , ENH_INFILT_2 , ICN, ONE, ONE )        
        ELSE
          CMARK  = 'IINFLS2'
          CALL MONIT_SIB ( CMARK , ENH_INFILT_2 , ICS, ONE, ONE )        
        ENDIF
!
! �\�w�����I�t �i���j
!
        IF ( INSFLAG .EQ.0 ) THEN
          CMARK  = 'WRONS'
          CALL MONIT_SIB ( CMARK , RUNOFF_S, ICN, ONE, ONE )  
        ELSE
          CMARK  = 'WROSS'
          CALL MONIT_SIB ( CMARK , RUNOFF_S, ICS, ONE, ONE )  
        ENDIF
!
! �\�w�����I�t�������ɔ����G�l���M�[
!
        IF ( INSFLAG .EQ.0 ) THEN
          CMARK  = 'IRONS'
          CALL MONIT_SIB ( CMARK , ENH_RUNOFF_S, ICN, ONE, ONE )  
        ELSE
          CMARK  = 'IROSS'
          CALL MONIT_SIB ( CMARK , ENH_RUNOFF_S, ICS, ONE, ONE )  
        ENDIF
!
      ENDIF
!
#endif
!
! ================
! >> �ڍ׃��j�^ <<   ���� 2  ���E�X�G���[������
! ================
!
#ifdef MONYOS 
      IF ( IMONIT_LEVEL .GE. IMONIT_ALL ) THEN
!
!
! �{���ɗ^�������ƔM
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'WADLN1B'
          CALL MONIT_SIB ( CMARK , H2O_MOD ,ICN, ONE, ONE )
          CMARK  = 'WADLN2B'
          CALL MONIT_SIB ( CMARK , H2O_MOD(1,2), ICN, ONE, ONE )     
          CMARK  = 'WADLN3B'
          CALL MONIT_SIB ( CMARK , H2O_MOD(1,3), ICN, ONE, ONE )
        ELSE
          CMARK  = 'WADLS1B'
          CALL MONIT_SIB ( CMARK , H2O_MOD     , ICS , ONE, ONE )
          CMARK  = 'WADLS2B'
          CALL MONIT_SIB ( CMARK , H2O_MOD(1,2), ICS , ONE, ONE )     
          CMARK  = 'WADLS3B'
          CALL MONIT_SIB ( CMARK , H2O_MOD(1,3), ICS, ONE, ONE )
        ENDIF
!
        IF ( INSFLAG.EQ.0 ) THEN
          CMARK  = 'HADLN1B'
          CALL MONIT_SIB ( CMARK , ENG_MOD ,     ICN , ONE, ONE )
          CMARK  = 'HADLN2B'
          CALL MONIT_SIB ( CMARK , ENG_MOD(1,2), ICN , ONE, ONE )     
          CMARK  = 'HADLN3B'
          CALL MONIT_SIB ( CMARK , ENG_MOD(1,3), ICN , ONE, ONE )
        ELSE
          CMARK  = 'HADLS1B'
          CALL MONIT_SIB ( CMARK , ENG_MOD     , ICS , ONE, ONE )
          CMARK  = 'HADLS2B'
          CALL MONIT_SIB ( CMARK , ENG_MOD(1,2), ICS , ONE, ONE )     
          CMARK  = 'HADLS3B'
          CALL MONIT_SIB ( CMARK , ENG_MOD(1,3), ICS , ONE, ONE )
        ENDIF
!
      ENDIF
#endif
!
! ==============
! >> �P�ʕϊ� <<
! ==============
!
      DO I=NSTR,NEND 
        RUNOFF_S(I) = RUNOFF_S(I) / DELT_SOIL 
      ENDDO
!
      RETURN
      END
!==================================================================
      SUBROUTINE MR_SOIL_PRE_2
!
! soil_pre �ŏo�͂���f�o�b�O�p�ϐ��̓o�^���
!
#ifdef MONYOS
      USE SIB_MONIT , ONLY : 
     1                       IMONIT_LEVEL , IMONIT_ALL,
     1                       IMONIT_FLUX_COMMON, IMONIT_ALMA
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
        WRITE(6,*) 'MONIT_REGIST_SOIL_PRE 99/10 POCHAKA'
        LFIRST = .FALSE. 
      ENDIF
!
! --------------------------------------------------------------
!
#ifdef MONYOS
!
      IF ( IMONIT_LEVEL .GE. IMONIT_FLUX_COMMON ) THEN
!   �����I�t
!     ROFS = WRONS + WROSS 
        CMARK  = 'ROFS'
        CTITLE = 'Surface Runoff'
        CUNIT  = 'kg/m**2/s'
        CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
      ENDIF
!
      IF ( IMONIT_LEVEL .GE. IMONIT_ALL ) THEN
!
!  �^�����M
!
      CMARK  = 'HADLN1B'
      CTITLE = 'ADD ENERGY WITH ADD WATER SOIL 1 BAD'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HADLS1B'
      CTITLE = 'ADD ENERGY WITH ADD WATER SNSL   BAD'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HADLN2B'
      CTITLE = 'ADD ENERGY WITH ADD WATER SOIL 2 NOS BAD'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HADLS2B'
      CTITLE = 'ADD ENERGY WITH ADD WATER SOIL 2 SNW BAD'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HADLN3B'
      CTITLE = 'ADD ENERGY WITH ADD WATER SOIL 3 NOS BAD'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'HADLS3B'
      CTITLE = 'ADD ENERGY WITH ADD WATER SOIL 3 SNW BAD'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
!  �^������
!
      CMARK  = 'WADLN1B'
      CTITLE = 'ADD WATER SOIL 1 BAD'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WADLS1B'
      CTITLE = 'ADD WATER SNSL   BAD'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WADLN2B'
      CTITLE = 'ADD WATER SOIL 2 BAD NOS'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WADLS2B'
      CTITLE = 'ADD WATER SOIL 2 BAD SNW'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WADLN3B'
      CTITLE = 'ADD WATER SOIL 3 BAD NOS'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WADLS3B'
      CTITLE = 'ADD WATER SOIL 3 BAD SNW'
      CUNIT  = 'W/M**2'
      CALL MONIT_REGIST_SIB ( CMARK , CTITLE , CUNIT )
!
!---------------
! ver2
!
!  �y�� 1 �w����̏��U���i���j
!
      CMARK  = 'WTRBL1N'
      CTITLE = 'TRANS FROM SOIL 1 NOS'
      CUNIT  = 'KG/M**2/S'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WTRBL1S'
      CTITLE = 'TRANS FROM SOIL 1 SNW'
      CUNIT  = 'KG/M**2/S'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  �y�� 2 �w����̏��U���i���j
!
      CMARK  = 'WTRBL2N'
      CTITLE = 'TRANS FROM SOIL 2 NOS'
      CUNIT  = 'KG/M**2/S'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WTRBL2S'
      CTITLE = 'TRANS FROM SOIL 2 SNW'
      CUNIT  = 'KG/M**2/S'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  �y�� 3 �w����̏��U���i���j
!
      CMARK  = 'WTRBL3N'
      CTITLE = 'TRANS FROM SOIL 3 NOS'
      CUNIT  = 'KG/M**2/S'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WTRBL3S'
      CTITLE = 'TRANS FROM SOIL 3 SNW'
      CUNIT  = 'KG/M**2/S'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!---------------
! ver2
!
!  �y�� 1 �w����̏��U���ɔ����G�l���M�[
!
      CMARK  = 'ITRBL1N'
      CTITLE = 'ENERGY WITH TRANS FROM SOIL 1 NOS'
      CUNIT  = 'J/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'ITRBL1S'
      CTITLE = 'ENERGY WITH TRANS FROM SOIL 1 SNW'
      CUNIT  = 'J/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  �y�� 2 �w����̏��U���ɔ����G�l���M�[
!
      CMARK  = 'ITRBL2N'
      CTITLE = 'ENERGY WITH TRANS FROM SOIL 2 NOS'
      CUNIT  = 'J/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'ITRBL2S'
      CTITLE = 'ENERGY WITH TRANS FROM SOIL 2 SNW'
      CUNIT  = 'J/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  �y�� 3 �w����̏��U���ɔ����G�l���M�[
!
      CMARK  = 'ITRBL3N'
      CTITLE = 'ENERGY WITH TRANS FROM SOIL 3 NOS'
      CUNIT  = 'J/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'ITRBL3S'
      CTITLE = 'ENERGY WITH TRANS FROM SOIL 3 SNW'
      CUNIT  = 'J/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
! �����E���؃o�P�c
!
      CMARK  = 'WEVBLN'
      CTITLE = 'EVAP/SUBL WATER FROM SOIL TO CNP_NOS'
      CUNIT  = 'KG/M**2/S'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!
      CMARK  = 'IEVBLN'
      CTITLE = 'ENG WITH EVAP/SUBL WATER FROM SOIL TO CNP_NOS'
      CUNIT  = 'W/M**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  ��[���炢������͓��鐅
!
      CMARK  = 'WFLBLN'
      CTITLE = 'H2O INTO SOIL 1 NOS'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WFLBLW'
      CTITLE = 'H2O INTO SOIL 1 SNW'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WFLBLNW'
      CTITLE = 'H2O INTO NOS SOIL FROM SOIL'
      CUNIT  = 'kg/m**2/s'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  ��[���炢������͓��鐅�ɔ����G�l���M�[
!
      CMARK  = 'IFLBLN' 
      CTITLE = 'ENERGY WITH WTR FROM SOIL 0 TO SOIL 1 NOS'
      CUNIT  = 'W/M**2 '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'IFLBLW' 
      CTITLE = 'ENERGY WITH WTR FROM SOIL 0 TO SOIL 1 SNW'
      CUNIT  = 'W/M**2 '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'IFLBLNW'
      CTITLE = 'ENERGY WITH H2O INTO NOS SOIL FROM SOIL'
      CUNIT  = 'W/M**2 '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  ���w�ւ̐Z����
!
      CMARK  = 'WINFLN1'
      CTITLE = 'H2O INFILT INTO SOIL 1 NOS'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WINFLS1'
      CTITLE = 'H2O INFILT INTO SOIL 1 SNW'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  ���w�ւ̐Z����
!
      CMARK  = 'WINFLN2'
      CTITLE = 'H2O INFILT INTO SOIL 2 NOS'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WINFLS2'
      CTITLE = 'H2O INFILT INTO SOIL 2 SNW'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  ���w�ւ̐Z�����ɔ����G�l���M�[
!
      CMARK  = 'IINFLN1'
      CTITLE = 'ENG with H2O INFILT INTO SOIL 1 NOS'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'IINFLS1'
      CTITLE = 'ENG_with H2O INFILT INTO SOIL 1 SNW'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  ���w�ւ̐Z�����ɔ����G�l���M�[
!
      CMARK  = 'IINFLN2'
      CTITLE = 'ENG with H2O INFILT INTO SOIL 2 NOS'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'IINFLS2'
      CTITLE = 'ENG with H2O INFILT INTO SOIL 2 SNW'
      CUNIT  = 'kg/m**2/s '
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )

!
!  �\�w�����I�t
!
      CMARK  = 'WRONS'
      CTITLE = 'SURFACE RUNOFF NOS'
      CUNIT  = 'kg/m**2/s'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'WROSS'
      CTITLE = 'SURFACE RUNOFF SNW'
      CUNIT  = 'kg/m**2/s'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
!  �\�w�����I�t�ɔ����M
!
      CMARK  = 'IRONS'
      CTITLE = 'ENERGY OF SURFACE RUNOFF NOS'
      CUNIT  = 'W/m**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      CMARK  = 'IROSS'
      CTITLE = 'ENERGY OF SURFACE RUNOFF SNW'
      CUNIT  = 'W/m**2'
      CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
!
      ENDIF
!
      IF ( IMONIT_LEVEL .GE. IMONIT_ALMA ) THEN
        CMARK  = 'A_ROS'
        CTITLE = 'ALMA Qs : Surface Runoff'
        CUNIT  = 'kg/m**2/s'
        CALL monit_regist_sib ( CMARK , CTITLE , CUNIT )
      ENDIF
#endif
!
      RETURN
      END