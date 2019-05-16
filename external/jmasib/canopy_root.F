! ���֘A�̒�R�v�Z
! 99/07/19 �ۍ␪�G
! 99/08/04 �ۍ␪�G ��򂳂�ɓn���o�[�W�����t�B�b�N�X
!
      SUBROUTINE CANOPY_ROOT (
     I   NSTR            , NEND          , INSFLAG     ,
     I   NTYP            , MON           , 
     I   FR_WTR_SOIL     , 
     I   FR_GLA_SOIL     , 
     I   TMP_SOIL        , 
     O   POT_SOIL        , R_ROOT_BAR_INV, 
     O   HUM_GRSK        , R_BB        )   ! �� INSFLAG=1 �ł� 1/0
!
! LOOP ����x�s���B
!
      USE SIBPRM , ONLY :
     1   IDX   ,
     1   ITYP  ,
     1   ICG   ,
     1   IDP
!
      USE SIBCON , ONLY :
     1   GRAV_c  , 
     1   R_VAP_c 
!
      USE SIBVEG , ONLY :
     1           POT_SAT_SOIL_co        ,  ! �O�a���̓y��|�e���V���� (ITYP)
     1           BEE_co                 ,  ! �y�됅���ˑ����W�� (ITYP)
     1           WCOEF_SAT_SOIL_co      ,  ! �O�a�����W��    (ITYP)
     1           DEP_ROOT_co            ,  ! �w�����̒���    (ITYP,IDP,ICG) 
     1           ALPHAF_BAR_mo          ,  ! ����R�֘A�W����(ITYP,IMON,ICG) 
     1           BETAF_BAR_mo              ! ����R�֘A�W����(ITYP,IMON,ICG) 
!
      IMPLICIT NONE
!
! �@�\ :���̒�R�v�Z�A�y��ECG �̐����|�e���V�����̌v�Z�B
!
! �o��
!
      REAL(8),INTENT(OUT) :: POT_SOIL(IDX,IDP)
!                               ! I�w�ڂ̓y��}�g���b�N�|�e���V����
      REAL(8),INTENT(OUT) :: R_ROOT_BAR_INV (IDX,IDP,ICG)
!                               ! �e�w��C,G �ʂ�(���E�����j��R�̘a�̋t��
!
      REAL(8)  :: XFR_WTR
!                               ! �y��ܐ����F�O�a�x�i�S�w�j : ��/(1-�y-�X) 
!
      REAL(8),INTENT(OUT) :: HUM_GRSK    (IDX) 
!                               ! �ᖳ���y����w���Ύ��x �� HRR 
      REAL(8),INTENT(OUT) :: R_BB        (IDX) 
!                               ! �ᖳ���y��A�y��\�w�̒�R
!                                                   
! ����
!
      INTEGER,INTENT(IN)   :: NSTR
      INTEGER,INTENT(IN)   :: NEND
      INTEGER,INTENT(IN)   :: MON 
!
      INTEGER,INTENT(IN)   :: INSFLAG          ! �ᖳ���� 0 �Ⴀ��� 1
!
      REAL(8),INTENT(IN)   :: FR_WTR_SOIL(IDX,IDP) ! �y��ܐ����F�O�a�x�i�S�w�j
      REAL(8),INTENT(IN)   :: FR_GLA_SOIL(IDX,IDP) ! �y��ܐ����F�O�a�x�i�S�w�j
!
      REAL(8),INTENT(IN)   :: TMP_SOIL   (IDX)     ! �y��\�w���x�i�ᖳ���j
!
      INTEGER,INTENT(IN)   :: NTYP  (IDX)          ! �A���^�C�v
!
!
! WORK
!
      REAL(8)   :: WWTR               ! ��Ǝ��̓y��ܐ���
      REAL(8)   :: XPOT_SOIL          ! ��Ǝ��̓y��|�e���V����
      REAL(8)   :: WCOEF_SOIL(IDX,IDP)
      INTEGER   :: I
      INTEGER   :: J
      INTEGER   :: K
      INTEGER   :: IVEG
!
      REAL(8)   :: DMIN_FRW 
      REAL(8)   :: DMIN_SLC
!
      REAL(8),save   :: ONE = 1.D0 
!
#ifdef SIB_DEBUG
      integer :: imsg_num
      real(8) :: xmsg_sq
#endif

!
      LOGICAL, SAVE :: LFIRST 
      DATA LFIRST  / .TRUE. / 
!

      DATA DMIN_FRW / 1.D-3 /
      DATA DMIN_SLC / 1.D-10/
!
      IF ( LFIRST ) THEN
        WRITE(6,*) 'CANOPY__ROOT 99/07 POCHAKA'
        LFIRST = .FALSE.
      ENDIF 
!
!  ========================================
! >> �y��̃}�g���b�N�|�e���V���� PHSOIL <<
!  ========================================
!                             1-2-81 �ɏ]��
!                             �������]���Ɏg�� W �͉��� 0.1m �ɐݒ�B
!
      DO 1000 K=1,IDP
      DO 1000 I=NSTR,NEND
        IF (FR_GLA_SOIL(I, K) == 1.0) THEN
          XFR_WTR = 0.0d0
        ELSE
          XFR_WTR         = FR_WTR_SOIL(I,K) / (1.-FR_GLA_SOIL(I,K)) 
        ENDIF
        WWTR            = MAX ( DMIN_FRW , XFR_WTR )
        POT_SOIL(I,K)   = POT_SAT_SOIL_co(NTYP(I)) 
     1                        * WWTR**(-BEE_co(NTYP(I)))
        WCOEF_SOIL(I,K) = WCOEF_SAT_SOIL_co(NTYP(I))
     1                        * WWTR**(2.0D0*BEE_co(NTYP(I))+3.0D0)    
        WCOEF_SOIL(I,K) = MAX ( DMIN_SLC , WCOEF_SOIL(I,K) )
 1000 CONTINUE  
!
! -----------------------------
! > ���̒�R�̋t�� R_ROOT_INV <                           ! �y + ���̕\��
! -----------------------------
!
#include "indep_fixedform"
      DO 2000 IVEG=1,2-INSFLAG                 ! �A������
      DO 2000 J=1,IDP                          ! �e�w����
      DO 2000 I=NSTR,NEND                      ! �e�i�q����
         R_ROOT_BAR_INV (I,J,IVEG) 
     1        = DEP_ROOT_co(NTYP(I),J,IVEG)
     1          / (   BETAF_BAR_mo (NTYP(I),MON,IVEG) 
     1              + ALPHAF_BAR_mo(NTYP(I),MON,IVEG) 
     1                  / WCOEF_SOIL(I,J) ) 
 2000 CONTINUE
!
#ifdef SIB_DEBUG
      imsg_num = 0 
#endif
!
      IF ( INSFLAG.EQ.0 ) THEN
      DO 3000 I=NSTR,NEND
        WWTR  = MAX ( DMIN_FRW , 
     1                FR_WTR_SOIL(I,1) + FR_GLA_SOIL(I,1) )
!
! �ᖳ���y��\�w�̋�C�̑��Ύ��x�B
!     1-2-130 ���̏�̎�.
!     �����ł̓y�됅���|�e���V�����́A�X��y�Ƃ݂Ȃ� POT_SOIL �Ƃ͈قȂ�
!     ���Ƃɒ��ӁB
!     ���E�X�����̏ꍇ�݂̂Ȃ炸�A�X�̏ꍇ�����؂̌v�Z�Ɏg�����ƂɂȂ�B

        XPOT_SOIL    = POT_SAT_SOIL_co(NTYP(I)) 
     1                    * WWTR**(-BEE_co(NTYP(I)))
!20051209
        if ( ISNAN(TMP_SOIL(I)) ) then
	     HUM_GRSK (I) = 1

	  else   
	      HUM_GRSK (I) = DEXP ( XPOT_SOIL * GRAV_c 
     1                       / ( TMP_SOIL(I) * R_VAP_c ) ) 
	  endif
!
#ifdef SIB_DEBUG
        if ( hum_grsk(i).gt.1 ) then
          imsg_num = imsg_num + 1
          xmsg_sq  = xmsg_sq + (hum_grsk(i)-1.)**2   
        endif
#endif
!
        hum_grsk(i) = min ( hum_grsk(i) , one ) 
!
! �ᖳ���y��\�ʂł̒�R
!      1-2-129 ���̏�̎�
!
        R_BB (I) = 30. + 3.5 * WWTR**(-2.3) 
 3000 CONTINUE   
      ELSE 
        HUM_GRSK(NSTR:NEND) = 1. 
        R_BB    (NSTR:NEND) = 0. 
      ENDIF
!
#ifdef SIB_DEBUG
      if ( imsg_num.gt.0 ) then
         write(6,*) 'presib_root hum gt 1 ' , imsg_num , xmsg_sq
      endif
#endif
!
      RETURN
      END