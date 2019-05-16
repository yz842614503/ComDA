! ���˓`�B������������
! 99/05/xx �ۍ␪�G
! 99/08/04 �ۍ␪�G ��򂳂�ɓn���o�[�W�����t�B�b�N�X
!
      SUBROUTINE ALBEDO_SIB  ( 
     I   MON         , 
     I   NSTR        , NEND       , INSFLAG    , 
     I   ALB_SNOW_onCNP           , FR_GLA_CNP , 
     I   ALB_SKIN    , NTYP       ,  
     I   CVR_VEG_ms  ,  
     I   DEP_SNOW    , ZMEAN       , ZLT , 
     O   EXTK        , ABSORB_SHRT   , 
     O   REACH_GRD   , ALB_SIB        )
!
! ���ʂ�
!    �Z�g�A���x�h�ƁA
!    SiB ��[�� 1 ���˂���Z�g�́A�L���m�s�[�E�n�ʂł̋z����
! �Ƃ�]������B
!
! �������Ⴀ���Ɛᖳ����Ƃ͕ʁX�ɌĂ΂��B
!
      USE SIBPRM , ONLY : 
     1    IDX    ,  
     1    ITYP   , 
     1    IMON   , 
     1    ICG    , 
     1    IVN    , 
     1    ILD    , 
     1    IBD    , 
     1    IBS  
!
      USE SIBVEG , ONLY :
     1            TRAN_co               ,   ! ���ߓ��� (ITYP,ICG,IWV,ILD)
     1            REF_co                ,   ! ���˓��� (ITYP,ICG,IWV,ILD)
     1            CHI_L_co              ,   ! ��L  (ITYP,ICG) 
     1            Z2_mo                 ,   ! �L���m�s�[��[���� (ITYP,IMON)
     1            Z1_mo                 ,   ! �L���m�s�[���[���� (ITYP,IMON)
     1            XLAI_mo               ,   ! LAI, �i�q���� (ITYP,IMON,ICG)
     1            GREEN_mo                  ! �����Ă��銄�� (ITYP,IMON,ICG) 
!
      IMPLICIT NONE 
!
! INPUT START 
      INTEGER    NSTR                      ! ���ʊi�q��
      INTEGER    NEND                      ! ���ʊi�q��
      INTEGER    MON                       ! ��
      INTEGER,INTENT(IN)   :: INSFLAG      ! �n�ʏ�ᖳ�� 0 �Ⴀ�� 1 
!
      REAL(8),INTENT(IN)   :: DEP_SNOW(IDX)            ! �t�̂���
      REAL(8),INTENT(IN)   :: ZMEAN   (IDX)            ! cos ( �V���p ) = ��
      INTEGER,INTENT(IN)   :: NTYP    (IDX)            ! �A���^�C�v
!
      REAL(8),INTENT(IN)   :: CVR_VEG_ms(IDX,ICG)      ! �A���핢�� 
      REAL(8),INTENT(IN)   :: ALB_SKIN       (IDX,IVN) ! ���n or ��ʃA���x�h
      REAL(8),INTENT(IN)   :: ALB_SNOW_onCNP (IDX,IVN) !  �؂̗t�̐�A���x�h
      REAL(8),INTENT(IN)   :: FR_GLA_CNP ( IDX )       ! �L���m�s�[�̐�̊���
!
! OUTPUT  START 
!
      REAL(8),INTENT(INOUT)  :: 
     1        EXTK        (IDX,ICG,IVN,IBD)       ,  ! ���U�W�� 
     1        ABSORB_SHRT (IDX,ICG,IVN,IBD)       ,  ! �n�㉺���Z�g��
     1        ALB_SIB     (IDX,    IVN,IBD)       ,  ! �A���x�h
     1        REACH_GRD   (IDX,        IBD)          ! �n�ʓ��B��
!
      REAL(8),intent(in) :: ZLT   (IDX,ICG)           ! �t�ʐώw��
!
! WORK START 
!
      REAL(8)  ::   ALBEDO (IDX,ICG,IVN,IBD)         !CG�EL�EBD�ʃA���x�h  
!
      REAL(8)  ::   RMEW    (IDX)     ! ��                   F
      REAL(8)  ::   RMEWI   (IDX)  
      REAL(8)  ::   RMEWBAR (IDX)     ! ��bar d              ZMEW
      REAL(8)  ::   RMEWBARI(IDX)            
      REAL(8)  ::   GG      (IDX)     ! G(��)                PROJ
      REAL(8)  ::   RKK     (IDX)     ! K = G / ��           EXTKB
      REAL(8)  ::   HH    (IDX)       ! h                    PSI
      REAL(8)  ::   OMEGA (IDX)       ! ��                   SCAT
      REAL(8)  ::   BETOMG(IDX)       ! ����                 UPSCAT
      REAL(8)  ::   BETAO (IDX)       ! ��_0                 UPSCAT
!
      REAL(8)  ::   SS    (IDX)       ! s   ��
      REAL(8)  ::   TT    (IDX)       ! t   ��
      REAL(8)  ::   TTI   (IDX)       ! 1/t   ��
      REAL(8)  ::   UU    (IDX)       ! u   ��
      REAL(8)  ::   VV    (IDX)       ! v   ��
      REAL(8)  ::   STK   (IDX)       ! s^2-t^2-K^2 ��
      REAL(8)  ::   STKI  (IDX)       ! 1/ (s^2-t^2-K^2) ��
      REAL(8)  ::   ALP1  (IDX)       ! ��1 ��
      REAL(8)  ::   ALP2  (IDX)
      REAL(8)  ::   ALP3  (IDX)
      REAL(8)  ::   ALP4  (IDX)
      REAL(8)  ::   ALP5  (IDX)
      REAL(8)  ::   ALP6  (IDX)
      REAL(8)  ::   A23X  (IDX)
      REAL(8)  ::   A23Y  (IDX)
      REAL(8)  ::   TRA1 (IDX)  ! �����B�A��C���[�������ŗt�ɒB��������
!                             ! �t�𒼒B�̂܂ܒʂ蔲���銄��
!                             ! �t�ł̔��˂͍l���B
      REAL(8)  ::   TRA2 (IDX)  ! ���U���A��C���[�������ŗt�ɒB��������
!                             ! �t��ʂ蔲���銄��
      REAL(8)  ::   TRA3 (IDX)  ! �����B�A��C���[�������ŗt�ɒB��������
!                             ! �t�ŎU������Ēʂ蔲���銄��
!     REAL(8)  ::   EKL   ( IDX )            ! exp(KL)           
      REAL(8)  ::   EHL   ( IDX )            ! exp(hL)            
      REAL(8)  ::   EKLI  ( IDX )            ! exp(-KL)     EK  
      REAL(8)  ::   EHLI  ( IDX )            ! exp(-hL)     EPSI
      REAL(8)  ::   CHIV  ( IDX ) 
      REAL(8)  ::   REFF1 ( IDX )
      REAL(8)  ::   REFF2 ( IDX )
      REAL(8)  ::   TRAN1 ( IDX )
      REAL(8)  ::   TRAN2 ( IDX )
      REAL(8)  ::   AA    ( IDX )
      REAL(8)  ::   BB    ( IDX )
      REAL(8)  ::   ACSS  ( IDX )
      REAL(8)  ::   FAC   ( IDX )   ! ��ŃL���m�s�[�����銄��
      REAL(8)  ::   RHL   ( IDX )
      REAL(8)  ::   RKL   ( IDX )
      REAL(8)  ::   ROSB  ( IDX )
      REAL(8)  ::   ROSD  ( IDX )
      REAL(8)  ::   ZAT   ( IDX )
      REAL(8)  ::   SCOV1 ( IDX )
!
      INTEGER ::   I , JVN , IRD  , IVEG
!
      REAL(8),PARAMETER ::   DZERO  = 0.D0
      REAL(8),PARAMETER ::   D095   = 0.95D0
      REAL(8),PARAMETER ::   D05    = 0.5D0
      LOGICAL,SAVE ::   LFIRST
!
      DATA LFIRST  / .TRUE. /
!
      IF ( LFIRST ) THEN
        WRITE(6,*) 'ALBEDO_SIB 99/07 POCHAKA'
        LFIRST = .FALSE.
      ENDIF
!
!  ========================
!  >>> ���̓f�[�^���C�� <<<
!  ========================
!
!   --------------------
!  >> �V���p�������� <<
!  --------------------
!                                                     ! ���x�����́H
      DO 1000 I=NSTR,NEND
        RMEW(I)  = MAX ( ZMEAN(I), 0.01746D0 )         ! �V���p ��
        RMEWI(I) = 1. / RMEW(I)
 1000 CONTINUE
!
!  -----------------------------
!  > �Ⴊ����ꍇ�� LAI �̕␳ <
!  -----------------------------
!       ���B�ᖳ����v�Z�ł� DEP_SNOW = 0 
!           ����l�� 0.95 �ɂ��Ă���B
!
      DO 1300 I=NSTR,NEND
        FAC(I)= ( DEP_SNOW(I)         - Z1_mo(NTYP(I),MON) )
     1          / ( Z2_mo(NTYP(I),MON)- Z1_mo(NTYP(I),MON) ) 
        FAC(I)= MAX ( DZERO , FAC(I) )
        FAC(I)= MIN ( D095  , FAC(I) )
 1300 CONTINUE
!
!  =====================================
!! >> �g���ʏ����������� ( �Ō�܂� ) <<
!  =====================================
!
#include "noparallel_fixedform"
      DO 2000 JVN = 1, 2
!
!  =====================================================
!! >> �L���m�s�[(IVEG=2)�E�n��(IVEG=1) �ʏ����������� <<
!  =====================================================
!!        ���� : �n�ʂ����Ɍv�Z����B
!
#include "noparallel_fixedform"
      DO 2100 IVEG =2, 1, -1
!
!  --------------------------
!! >>> �U���W�� �� �̌v�Z <<<
!  --------------------------
!
      IF ( IVEG.EQ.1 ) THEN    ! �؂̏�
!
      DO 3000 I=NSTR,NEND
!
        SCOV1 (I) = MIN ( D05 , FR_GLA_CNP(I) )  ! �؂̗t�̔����͌����Ă��� 
!
!   ���˗� �� �̌v�Z 
!
        REFF1(I)=                                ! �����Ă���t   ����
     1           ( 1.0D0-SCOV1(I) ) 
     1                   * REF_co (NTYP(I),IVEG,JVN,1)  
     1              + SCOV1(I)      
     1                   * ALB_SNOW_onCNP(I,JVN)                  
!
        REFF2(I)=                                  ! ���񂾗t       ����
     1           ( 1.0D0-SCOV1(I) ) 
     1                   * REF_co (NTYP(I),IVEG,JVN,2) 
     1              + SCOV1(I)      
     1                   * ALB_SNOW_onCNP(I,JVN)                  
!
! 
!  ���ߗ� �� �̌v�Z 
!
        TRAN1(I) =                                    ! �������t ��
     1       (  ( 1.0D0 - SCOV1(I) )
     1           +  SCOV1(I)
     1                * ( 1.0D0-ALB_SNOW_onCNP(I,JVN) ) ) 
     1       * TRAN_co(NTYP(I),IVEG,JVN,1)           
!
        TRAN2(I) =                                    ! ���񂾗t ��
     1       (  ( 1.0D0 - SCOV1(I) )
     1        + SCOV1(I)
     1                * ( 1.0D0-ALB_SNOW_onCNP(I,JVN))*0.9D0)      
     1       * TRAN_co(NTYP(I),IVEG,JVN,2)              
!                                                 ! *0.9 �͕s��
! 
!  �U���W�� ��
!
        OMEGA(I) =                                      ! ��
     1        GREEN_mo(NTYP(I),MON,IVEG)      * ( TRAN1(I) + REFF1(I) )       
     1   + (1.0D0-GREEN_mo(NTYP(I),MON,IVEG)) * ( TRAN2(I) + REFF2(I) )
!
 3000 CONTINUE
!
      ELSEIF ( IVEG.EQ.2 .AND. INSFLAG.EQ.0 ) THEN   ! �n�ʂŐᖳ��
!
!                   ��radalb DO LOOP 440 �� SCOV1=0 ��^�������ɂ���
!
        DO 3001 I=NSTR,NEND
!
!   ���˗� �� �̌v�Z 
!
          REFF1(I)= REF_co (NTYP(I),IVEG,JVN,1)     ! �����Ă���t   ����
          REFF2(I)= REF_co (NTYP(I),IVEG,JVN,2)     ! ���񂾗t       ����
! 
!  ���ߗ� �� �̌v�Z  
!
          TRAN1(I) =  TRAN_co(NTYP(I),IVEG,JVN,1)   ! �������t ��
!         TRAN2(I) =  TRAN_co(NTYP(I),IVEG,JVN,1)   ! ���񂾗t �� 
          TRAN2(I) =  TRAN_co(NTYP(I),IVEG,JVN,2)   ! ���񂾗t ��
!
!  �U���W�� ��
!
          OMEGA(I) =                                      ! ��
     1       GREEN_mo(NTYP(I),MON,IVEG)       * ( TRAN1(I) + REFF1(I) )
     1   + (1.0D0-GREEN_mo(NTYP(I),MON,IVEG)) * ( TRAN2(I) + REFF2(I) )       
!
 3001   CONTINUE
      ENDIF          
!
!  ���������A��̒n�ʌv�Z�͂��Ȃ�   ------------------ AAAA 
!
      IF ( .NOT. ( IVEG.EQ.2 .AND. INSFLAG.EQ.1 ) ) THEN   ! ��ʌv�Z���ȊO��
!
!   -------------------------------
!!  >> ���ʂ̃A���x�h ROSB, ROSD <<
!   -------------------------------
!
      IF     ( IVEG.EQ.2 .AND. INSFLAG.EQ.0 ) THEN   ! �y�̒n��
        DO 3010 I=NSTR,NEND
!         ZAT (I) = XLAI_mo(NTYP(I),MON,IVEG) 
          ZAT (I) = ZLT(I,IVEG) 
     1                      / CVR_VEG_ms(I,IVEG)     ! L = Lg/Vg
          ROSB(I) = ALB_SKIN (I,JVN)                ! ���n�E���B���A���x�hA^b
          ROSD(I) = ALB_SKIN (I,JVN)                ! ���n�E���B���A���x�hA^b
 3010   CONTINUE
      ELSEIF ( IVEG.EQ.1 ) THEN                      ! �L���m�s�[
        DO 3020 I=NSTR,NEND
          ZAT (I) = ZLT(I,IVEG) 
!         ZAT (I) = XLAI_mo(NTYP(I),MON,IVEG) 
     1                      / CVR_VEG_ms(I,IVEG)     ! L = Lc/Vc
!         ZAT (I) = ZAT(I) * (1.0D0 -FAC(I))         ! L ( 1-FAC )
          ROSB(I) = ALBEDO(I,2,JVN,1)              ! ���B��  A^��
          ROSD(I) = ALBEDO(I,2,JVN,2)              ! �U����  A^��
 3020  CONTINUE
      END IF
!
!    ---------------------------
!!   >> �t�̌����̃p�����^��L <<
!    ---------------------------
!
      DO 3100 I=NSTR,NEND
        
        CHIV(I) = CHI_L_co(NTYP(I),IVEG)
        AA(I) = 0.500D0 - 0.633D0 * CHIV(I)- 0.33D0 * CHIV(I) * CHIV(I) 
        BB(I) = 0.877D0 - 1.754D0 * AA(I)                               
!
        RMEWBAR (I) = 1.0D0
     1             / BB(I)
     1             * (1.0D0 -AA(I)/BB(I)*LOG((AA(I)+BB(I))/AA(I)))   !��bar
!!         ������  ���Ƃ͈قȂ�H
        RMEWBARI(I) = 1.D0 / RMEWBAR(I)
 3100 CONTINUE
!
      DO 3200 I=NSTR,NEND
        GG   (I) = AA(I) + BB(I) * RMEW(I)    ! ���ʕ��z G(��)   ( F �� �� )
        RKK  (I) = GG(I) * RMEWI(I)           ! ���w�I�[�� K = G / ��
 3200 CONTINUE
!
!  --------------------------
!  > ���U�W���̌v�Z�i�o�́j<
!  --------------------------
!
      DO 3210 I=NSTR,NEND
        EXTK(I, IVEG, JVN, 1 ) 
     1        = GG(I) * SQRT(1.0D0-OMEGA(I)) * RMEWI(I)    ! G*sqrt(1-��)/��
        EXTK(I, IVEG, JVN, 2 ) 
     1        =         SQRT(1.0D0-OMEGA(I)) * RMEWBARI(I) !sqrt(1-��)/��bar
 3210 CONTINUE
!
      DO 3220 I=NSTR,NEND
        ACSS (I) = OMEGA(I)* 0.5D0 *GG(I)/( GG(I)+RMEW(I)*BB(I) )
        ACSS (I) = ACSS(I)*(1.0D0-RMEW(I)*AA(I)/(GG(I)+RMEW(I)*BB(I))     
     1        * LOG(( GG(I)+RMEW(I)*(BB(I)+AA(I)) )/( RMEW(I)*AA(I) )))   
!                  !   "��/2 \int_0^1 ��'G'/(��G'+��'G) d ��'"  �ł͂Ȃ��H
!
        BETOMG(I) =  
     1            GREEN_mo(NTYP(I),MON,IVEG)       * TRAN1(I)
     1      + ( 1.0D0 -GREEN_mo(NTYP(I),MON,IVEG)) * TRAN2(I)
        BETOMG(I) =   0.50D0 *( OMEGA(I)+( OMEGA(I)- 2.0D0 *BETOMG(I) )
     1              * 0.25D0 *( 1.0D0 -CHIV(I) )**2 )    
!               ! ���� �H
!               ! ��������  �Ƃ͈Ⴄ�B��L �� ��bar �̊Ԃ͉��肠��B
!
        BETAO(I)   =   ( 1.0D0  + RMEWBAR(I)*RKK(I) )         ! ���q
     1              / ( OMEGA(I) *RMEWBAR(I)*RKK(I) ) 
     1              * ACSS(I)                               
!               ! ��0 1-2-61 �H ������ "ACCS = ��/2 \int_0^1 d ��'" �Ȃ�H
 3220 CONTINUE
!
      DO 3230 I=NSTR,NEND
        SS   (I) = ( 1.0D0 - OMEGA(I) + BETOMG(I) ) * RMEWBARI(I)
        TT   (I) = BETOMG(I) * RMEWBARI(I)
        UU   (I) = OMEGA(I)  * RKK(I) * BETAO(I)  
        VV   (I) = OMEGA(I)  * RKK(I) * ( 1.0D0 -BETAO(I) )
        STK  (I) = SS(I)**2 - TT(I)**2 - RKK(I)**2       ! s^2-t^2-K^2
        IF ( ABS(STK(I)).LT.1.D-10 ) THEN
          OMEGA(I) = OMEGA(I) * 0.98D0       ! �C���`�L�L���G���[����
          SS   (I) = ( 1.0D0 - OMEGA(I) + BETOMG(I) ) * RMEWBARI(I)
          TT   (I) = BETOMG(I) * RMEWBARI(I)
          UU   (I) = OMEGA(I)  * RKK(I) * BETAO(I)  
          VV   (I) = OMEGA(I)  * RKK(I) * ( 1.0D0 -BETAO(I) )
          STK  (I) = SS(I)**2 - TT(I)**2 - RKK(I)**2       ! s^2-t^2-K^2
        ENDIF 
        STKI (I) = 1 / STK(I)
        TTI  (I) = 1 / TT(I)
        HH   (I) = SQRT ( SS(I)**2 - TT(I)**2 ) 
 3230 CONTINUE
!
      DO 3240 I=NSTR,NEND
        RHL (I) = MIN ( HH  (I)*ZAT(I), 50.0D0 )   ! hL 
        RKL (I) = MIN ( RKK (I)*ZAT(I), 50.0D0 )   ! KL
        EHLI(I) = DEXP ( - RHL(I) )                 ! exp(-hL)
        EKLI(I) = DEXP ( - RKL(I) )                 ! exp(-KL)
        EHL (I) = 1. / EHLI(I)
!       EKL (I) = 1. / EKLI(I)
!
        A23X (I) = ( SS(I) - TT(I) * ROSD(I) + HH(I) ) * EHL (I)
        A23Y (I) = ( SS(I) - TT(I) * ROSD(I) - HH(I) ) * EHLI(I) 
 3240 CONTINUE
!
      ELSE                            ! ��� 
        DO I=NSTR,NEND
          EXTK(I, IVEG, JVN, 1 ) =10.  ! 0 �ȊO�̒l���_�~�[�ł���Ă���
          EXTK(I, IVEG, JVN, 2 ) =100.  ! ����
        ENDDO 
      ENDIF
!  �����܂ŁA��̒n�ʌv�Z�́A�v�Z���Ȃ�   ------------------ AAAA 
!
!  -------------
!  >>  �U���� <<
!  -------------
!
!  ��������A��̒n�ʌv�Z�́A�v�Z���Ȃ�   ------------------ BBBB
!
      IF ( .NOT. ( IVEG.EQ.2 .AND. INSFLAG.EQ.1 ) ) THEN  ! ��ʌv�Z���ȊO��
!
!  ---------------------
!  >>  �U�����A���x�h <<
!  ---------------------
!
      DO 4000 I=NSTR,NEND
!
        ALP1(I) = 0.
        ALP2(I) =   A23X(I) / ( A23X(I) - A23Y(I) )
        ALP3(I) = 1 - ALP2(I) 
        ALP4(I) = 0.
        ALP5(I) = ( SS(I) - HH(I) ) * TTI(I) * ALP2(I)
        ALP6(I) = ( SS(I) + HH(I) ) * TTI(I) * ALP3(I)
!
        ALBEDO (I,IVEG,JVN,2) = ALP5(I) + ALP6(I) 
        TRA2(I) = ALP2(I) * EHLI(I) + ALP3(I) * EHL(I) 
!
 4000 CONTINUE
!
!  �����܂ŁA��̒n�ʌv�Z�́A�v�Z���Ȃ�   ------------------ BBBB
!
      ENDIF
!
!  -----------------------------------------------------
!! >>  �U�����A���x�h �` �y�̒n�ʂ͗��n�Ƒ��̌��ʍl�� <<
!  -----------------------------------------------------
!
      IF ( IVEG.EQ.2 .AND. INSFLAG.EQ.0 ) THEN                ! �y�̒n��    
        DO 4100 I=NSTR,NEND
          ALBEDO   (I,2,JVN,2)                              ! ���n+�� A^��
     1      =    ROSD(I)            * ( 1.0D0 - CVR_VEG_ms(I,2))
     1         + ALBEDO (I,2,JVN,2) *  CVR_VEG_ms(I,2)
 4100   CONTINUE
      END IF
!
      IF ( IVEG.EQ.2 .AND. INSFLAG.EQ.1 ) THEN                ! ���    
        DO 4200 I=NSTR,NEND
          ALBEDO   (I,2,JVN,2) = ALB_SKIN(I,JVN)
 4200   CONTINUE
      END IF
!
!  ��������A��̒n�ʌv�Z�́A�v�Z���Ȃ�   ------------------ CCCC
!
      IF ( .NOT. ( IVEG.EQ.2 .AND. INSFLAG.EQ.1 ) ) THEN   ! ��ʌv�Z���ȊO��

!  ---------------------
!! >>  ���B���A���x�h <<
!  ---------------------
!
      DO 5000 I=NSTR,NEND
!
        ALP1(I) = ( (SS(I) + RKK(I))*VV(I) + UU(I)*TT(I) ) * STKI(I)     
        ALP4(I) = ( (SS(I) - RKK(I))*UU(I) + VV(I)*TT(I) ) * STKI(I)     
!
        ALP2(I) = ( 
     1           TT(I) * ( -ALP4(I)+ROSD(I)*ALP1(I)+ROSB(I) )*EKLI(I)      
     1    + ((SS(I)+HH(I))*ALP1(I) - TT(I)*ROSD(I)*ALP1(I) ) *EHL (I) )  
     1             / ( A23Y(I) - A23X(I) )
!
        ALP3(I) =  - ALP1(I) - ALP2(I)

        ALP5(I) = ( SS(I) - HH(I) ) * TTI(I) * ALP2(I)
        ALP6(I) = ( SS(I) + HH(I) ) * TTI(I) * ALP3(I)
!
        ALBEDO (I,IVEG,JVN,1) = ALP4(I) + ALP5(I) + ALP6(I) 
!
        TRA1  (I) = EKLI(I)           ! exp(-KL) 
        TRA3  (I) =                   ! �U�����̂����t�𓧉߂���銄��
     1                ALP1 (I) * EKLI(I)    ! ��1 exp(-KL)
     1              + ALP2 (I) * EHLI(I)    ! ��2 exp(-hL)
     1              + ALP3 (I) * EHL (I)    ! ��3 exp( hL)
!
 5000 CONTINUE
!
      ENDIF
!    
!  �����܂ŁA��̒n�ʌv�Z�́A�v�Z���Ȃ�   ------------------ CCCC
!
!  -----------------------------------------------
!! >>  ���B���A���x�h �` �n�ʂ͗��n�E�����ʍl�� <<
!  -----------------------------------------------
!
      IF ( IVEG.EQ.2 .AND. INSFLAG.EQ.0 ) THEN      ! �y�̒n��
        DO 5100 I=NSTR,NEND
          ALBEDO   (I,2,JVN,1)                             ! ���n + ��
     1      =  ROSB(I)            * ( 1.0D0 -CVR_VEG_ms(I,2) )
     1       + ALBEDO (I,2,JVN,1) * CVR_VEG_ms(I,2)
 5100   CONTINUE
      END IF
!
      IF ( IVEG.EQ.2 .AND. INSFLAG.EQ.1 ) THEN       ! ���    
         DO 5200 I=NSTR,NEND
           ALBEDO   (I,2,JVN,1) = ALB_SKIN(I,JVN)
 5200   CONTINUE
      END IF
!
 2100 CONTINUE
!
!  =====================================================
!! >> �L���m�s�[(IVEG=2)�E���n(IVEG=1) �ʏ��������܂� <<
!  =====================================================
!
!  ======================================================
!! >> �ȉ��A�o�͗� ( ABSORB_SHRT, ALB_SIB , REACH_GRD ) �v�Z <<
!  ======================================================
!
!  -----------------------------------------------------------
!! >> �n��ł̉������Z�g���́A�z�� absorb ���銄�� ABSORB_SHRT <<
!  -----------------------------------------------------------
      DO 7000 I=NSTR,NEND
!
        ABSORB_SHRT(I,2,JVN,1)=
     1        ( 1.0D0 -CVR_VEG_ms(I,1)) * ( 1.0D0 - ALBEDO(I,2,JVN,1))
     2        +CVR_VEG_ms(I,1) *( TRA1(I)*( 1.0D0 - ALBEDO(I,2,JVN,1))
     3                       +TRA3(I)*( 1.0D0 - ALBEDO(I,2,JVN,2)))
!
!         ���B���̂����n�ʂŋz�����銄��
!         =   �n�ʂɒ��ړ��B���������A�n�ʂŔ��˂���Ȃ���
!           + �L���m�s�[�𒼒B���̂܂ܓ��߂��āA�n�ʂŔ��˂���Ȃ���
!           + �L���m�s�[�ŎU������Ȃ�������߂��A�n�ʂŔ��˂���Ȃ���
!
        ABSORB_SHRT (I,2,JVN,2)=
     1        ( 1.0D0 -CVR_VEG_ms(I,1))   * (1.0D0 -ALBEDO(I,2,JVN,2))
     2        +CVR_VEG_ms(I,1) * TRA2(I)* (1.0D0 -ALBEDO(I,2,JVN,2))
!
!         �U�����̂����n�ʂŋz�����銄��
!         =   �n�ʂɒ��ړ��B���������A���˂���Ȃ���
!           + �L���m�s�[�ɓ��B�����㓧�߂��A�n�ʂŔ��˂���Ȃ���
!
!         �L���m�s�[�ɓ��B�����U����������ɎU�����ꂽ���́H
!
        ABSORB_SHRT(I,1,JVN,1) = CVR_VEG_ms(I,1) * (  
     1                     ( 1.0D0 -ALBEDO(I,1,JVN,1) )
     &         - TRA1(I) * ( 1.0D0 -ALBEDO(I,2,JVN,1) )
     &         - TRA3(I) * ( 1.0D0 -ALBEDO(I,2,JVN,2) ) )
!

!
!!         ���B���̂����L���m�s�[�ŋz������銄��
!!         =   �L���m�s�[�ɓ��B���������A
!!           ( �L���m�s�[�Ŕ��˂���Ȃ���
!!             - �L���m�s�[�𒼒B���̂܂ܓ��߂���n�ʂŋz������镪
!!             - �L���m�s�[�ŎU�����ɂȂ蓧�߂���n�ʂŋz������镪 )
!
!!         �� : �n�ʂŔ��˂����΁A�L���m�s�[�ŋz�������B
!
        ABSORB_SHRT(I,1,JVN,2) = CVR_VEG_ms(I,1) * (
     1                     ( 1.0D0 -ALBEDO(I,1,JVN,2) )
     &       - TRA2(I) * ( 1.0D0 -ALBEDO(I,2,JVN,2) ) )
!
!!         �U�����̂����L���m�s�[�ŋz������銄��
!!         =   �L���m�s�[�ɓ��B���������A
!!           ( �L���m�s�[�Ŕ��˂���Ȃ���
!!             - �L���m�s�[�œ��߂���n�ʂŋz������镪 )
!
!!         �� : �n�ʂŔ��˂����΁A�L���m�s�[�ŋz�������B
!
 7000 CONTINUE
!
!  --------------------------
!! >> �S�A���x�h ALB_SIB �v�Z <<
!  --------------------------
!
      DO 7100 IRD=1,2
      DO 7100 I=NSTR,NEND
        ALB_SIB(I,JVN,IRD) = 
     1         ( 1.0D0 - CVR_VEG_ms(I,1)) * ALBEDO(I,2,JVN,IRD)  ! �n��
     1      +    CVR_VEG_ms(I,1)          * ALBEDO(I,1,JVN,IRD)  ! �L���m�s�[
 7100 CONTINUE
!
!  --------------------------------------------------------------
!! >> ���ő�C���[�𔲂��������Œn�ʏ�[�ɓ͂����� REACH_GRD <<
!  --------------------------------------------------------------
!!    �L���m�s�[��[�Ŕ��˂���镪�� tranc? �ōl���B
!     SAVING OF EXTINCTION COEFFICIENTS ( PAR ) FOR STOMAT CALCULATION
!
      IF ( JVN.EQ.1 ) THEN                               !  ���̂�
        DO 7200 I=NSTR,NEND
          REACH_GRD(I,1) =                                  ! ���B
     1             1.0D0 -CVR_VEG_ms(I,1)                          ! �n��
     1             + CVR_VEG_ms(I,1) * ( TRA1(I)+TRA3(I) )     ! �L���m�s�[
          REACH_GRD(I,2) =                                         ! �U��
     1             1.0D0 -CVR_VEG_ms(I,1)                          ! �n��
     1             + CVR_VEG_ms(I,1) * TRA2(I)                   ! �L���m�s�[
 7200   CONTINUE
!   
      END IF
!
 2000 CONTINUE      !  <-----------------------  �g���ʏ��������܂�
!
      RETURN
      END