! sib �p prm �t�@�C��
! 99/05/xx �ۍ␪�G
!
      MODULE SIBPRM                 
!
      USE PRM , ONLY :              
!     1   IJPHY , JLPHY, NUMPE 
     1   IJPHY , JLPHY
!
      IMPLICIT NONE
!
!      INTEGER,PARAMETER :: NUM_PE = NUMPE       
!
      INTEGER,PARAMETER :: ITYO_veg = 12
      INTEGER,PARAMETER :: ITYO     = 2*ITYO_veg+1 ! �A���^�C�v
      INTEGER,PARAMETER :: ITYP_veg = 40           ! �A���^�C�v  12+1 
      INTEGER,PARAMETER :: ITYP     = 2*ITYP_veg+1 ! �A���^�C�v
!
      INTEGER,PARAMETER :: IDX        = IJPHY      
      INTEGER,PARAMETER :: NUM_BLOCK  = JLPHY      
      INTEGER,PARAMETER :: IMON = 12      ! 12  ��
      INTEGER,PARAMETER :: ICG  =  2      !  2  �L���m�s�[�E�n��
      INTEGER,PARAMETER :: IWV  =  3      !  3  ���E�ߐԁE���g
      INTEGER,PARAMETER :: IVN  =  2      !  2  ���E�ߐ�        �i�Z�g�j
      INTEGER,PARAMETER :: ILD  =  2      !  2  �t�̐���
      INTEGER,PARAMETER :: IBD  =  2      !  2  ���B�E�U��
      INTEGER,PARAMETER :: IBS  =  2      !  2  ��Ȃ��A�Ⴀ��    
      INTEGER,PARAMETER :: IDP  =  3      !  3  �y��̑w��
      INTEGER,PARAMETER :: ISN  =  4      !  4  ��̑w��
      INTEGER,PARAMETER :: IWG  =  2      !  2  WTR or GLA
!
      INTEGER,PARAMETER :: IEST =  3      !  3 EVAP SUBL TRANS
!
      INTEGER,PARAMETER :: ICGB =  3      !  3 CAN,GRS,BSL
      INTEGER,PARAMETER :: ICGR =  3      !  4 CAN,GRD,REF
!
      INTEGER,PARAMETER :: ICS  =  2      !  4 CAN,SNW
      INTEGER,PARAMETER :: ICSR =  3      !  4 CAN,SNW,REF
!
      INTEGER,PARAMETER :: ISPT = 1 
!
      END MODULE SIBPRM


