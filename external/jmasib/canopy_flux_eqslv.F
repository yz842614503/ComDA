! �L���m�s�[���ӂ̔M�g�U�̕�����������
!  99/06/xx �ۍ␪�G
!  99/07/16 �ۍ␪�G
!  99/08/04 �ۍ␪�G ��򂳂�ɓn���o�[�W�����t�B�b�N�X
!
      SUBROUTINE CANOPY_FLUX_EQSLV (
     I   NSTR  , NEND   , 
     M   SMTX      )
!
!    ����
!      �E��Ȃ��̈�A�Ⴀ��̈�Ƃ��Ɏg�����Ƃ��o����B
!      �E���́AdT/dt ���ł���B( �������̑傫���ł͂Ȃ� )
!
!
!       TR,QR               4,5 
!       TC               1
!       TGskin or TSkin  2  
!       Tsoil1 or Tsnow1 3  
!
      USE SIBPRM , ONLY : 
     1    IDX      
!
      USE COM_RUNCONF_SIB0109 , ONLY : JCN_SIB_UPPER_MODEL
!
      IMPLICIT NONE 
!
! INPUT
      INTEGER,INTENT(IN)    :: NSTR
      INTEGER,INTENT(IN)    :: NEND
!
! INOUT
!
!     REAL(8),INTENT(INOUT) :: SMTX(IDX,4,5)   ! SIB_MTX_N or SIB_MTX_S
      REAL(8),INTENT(INOUT) :: SMTX(IDX,5,6)   ! SIB_MTX_N or SIB_MTX_S
!
! WORK 
!
!     REAL(8)               :: SMTX_SAV (IDX,4,5) 
      REAL(8)               :: SMTX_SAV (IDX,5,6) 
      REAL(8)               :: X 
      REAL(8)               :: A22I 
      REAL(8)               :: A33I 
      REAL(8)               :: A44I 
      REAL(8)               :: A55I 
      INTEGER               :: I
      INTEGER               :: K
!
      LOGICAL,SAVE :: LFIRST
      DATA  LFIRST /.TRUE. /
!
      IF ( LFIRST ) THEN
        WRITE(6,*) 'CANOPY_FLUX_EQSLV 00/08 POCHAKA'
        LFIRST = .FALSE. 
      ENDIF
!
      DO I=NSTR,NEND
        SMTX_SAV(I,:,:) = SMTX(I,:,:)
      ENDDO 
!
      DO 1000 I=NSTR,NEND
!
!a11  a12      a14  a15  a16  1
!a21  a22  a23 a24  a25  a26  2
!     a32  a33           a36  3
!a41  a42      a44       a46  4
!a51  a52           a55  a56  5
!
!      �y����w 3 ������
!
        A33I = 1. / SMTX(I,3,3) 
        SMTX(I,3,2) = SMTX(I,3,2) * A33I 
        SMTX(I,3,6) = SMTX(I,3,6) * A33I 
        SMTX(I,3,3) = 1. 
!
!a11  a12      a14  a15  a16  1
!a21  a22  a23 a24  a25  a26  2
!     a32*  1*           a36* 3
!a41  a42      a44       a46  4
!a51  a52           a55  a56  5
!       
        SMTX(I,2,2) = SMTX(I,2,2) - SMTX(I,3,2) * SMTX(I,2,3)  
        SMTX(I,2,6) = SMTX(I,2,6) - SMTX(I,3,6) * SMTX(I,2,3)  
        SMTX(I,2,3) = 0. 
!
!a11  a12      a14  a15  a16  1
!a21  a22*  0* a24  a25  a26* 2
!     a32*  1*           a36* 3
!a41  a42      a44       a46  4
!a51  a52           a55  a56  5
!
!
!      �Q�Ƌ�C������
!
        A44I = 1. / SMTX(I,4,4) 
        SMTX(I,4,1) = SMTX(I,4,1) * A44I 
        SMTX(I,4,2) = SMTX(I,4,2) * A44I 
        SMTX(I,4,6) = SMTX(I,4,6) * A44I 
!       SMTX(I,4,4) = 1. 
!
        A55I = 1. / SMTX(I,5,5) 
        SMTX(I,5,1) = SMTX(I,5,1) * A55I 
        SMTX(I,5,2) = SMTX(I,5,2) * A55I 
        SMTX(I,5,6) = SMTX(I,5,6) * A55I 
!       SMTX(I,5,5) = 1. 
!
!a11* a12*     a14  a15  a16  1
!a21* a22*     a24  a25  a26  2
!     a32   1            a36  3
!a41* a42*      1*       a46* 4
!a51* a52*           1*  a56* 5
!
        SMTX(I,1,1) = SMTX(I,1,1) - SMTX(I,1,4) * SMTX(I,4,1)  
        SMTX(I,1,2) = SMTX(I,1,2) - SMTX(I,1,4) * SMTX(I,4,2)  
        SMTX(I,1,6) = SMTX(I,1,6) - SMTX(I,1,4) * SMTX(I,4,6)  
!       SMTX(I,1,4) = 0. 
!
        SMTX(I,1,1) = SMTX(I,1,1) - SMTX(I,1,5) * SMTX(I,5,1)  
        SMTX(I,1,2) = SMTX(I,1,2) - SMTX(I,1,5) * SMTX(I,5,2)  
        SMTX(I,1,6) = SMTX(I,1,6) - SMTX(I,1,5) * SMTX(I,5,6)  
!       SMTX(I,1,5) = 0. 
!
        SMTX(I,2,1) = SMTX(I,2,1) - SMTX(I,2,4) * SMTX(I,4,1)  
        SMTX(I,2,2) = SMTX(I,2,2) - SMTX(I,2,4) * SMTX(I,4,2)  
        SMTX(I,2,6) = SMTX(I,2,6) - SMTX(I,2,4) * SMTX(I,4,6)  
!       SMTX(I,2,4) = 0. 
!
        SMTX(I,2,1) = SMTX(I,2,1) - SMTX(I,2,5) * SMTX(I,5,1)  
        SMTX(I,2,2) = SMTX(I,2,2) - SMTX(I,2,5) * SMTX(I,5,2)  
        SMTX(I,2,6) = SMTX(I,2,6) - SMTX(I,2,5) * SMTX(I,5,6)  
!       SMTX(I,2,5) = 0. 
!
!a11* a12*      0*   0*  a16* 1
!a21* a22*      0*   0*  a26* 2
!     a32   1            a36  3
!a41  a42       1        a46  4
!a51  a52            1   a56  5
!
        A22I = 1. / SMTX(I,2,2) 
        SMTX(I,2,1) = SMTX(I,2,1) * A22I  
        SMTX(I,2,6) = SMTX(I,2,6) * A22I  
!       SMTX(I,2,2) = 1. 
!
!a11  a12                a16  1
!a21*  1*                a26* 2
!     a32   1            a36  3
!a41  a42       1        a46  4
!a51  a52            1   a56  5
!        
        SMTX(I,1,1) = SMTX(I,1,1) - SMTX(I,1,2) * SMTX(I,2,1) 
        SMTX(I,1,6) = SMTX(I,1,6) - SMTX(I,1,2) * SMTX(I,2,6) 
!       SMTX(I,1,2) = 0. 
!
        SMTX(I,1,6) = SMTX(I,1,6) / SMTX(I,1,1)
!       SMTX(I,1,1) = 1. 
!
! 1*   0*                a16* 1
!a21   1                 a26  2
!     a32   1            a36  3
!a41  a42       1        a46  4
!a51  a52            1   a56  5
!
        SMTX(I,2,6) = SMTX(I,2,6) - SMTX(I,2,1) * SMTX(I,1,6)  
!       SMTX(I,2,1) = 0. 
!
! 1                      a16  1
! 0*   1                 a26* 2
!     a32   1            a36  3
!a41  a42       1        a46  4
!a51  a52            1   a56  5
!
        SMTX(I,3,6) = SMTX(I,3,6) 
     1                - SMTX(I,3,2) * SMTX(I,2,6)  
!       SMTX(I,3,2) = 0. 
!
        SMTX(I,4,6) = SMTX(I,4,6) 
     1                - SMTX(I,4,1) * SMTX(I,1,6)  
     1                - SMTX(I,4,2) * SMTX(I,2,6)  
!       SMTX(I,4,1) = 0. 
!       SMTX(I,4,2) = 0. 
!
        SMTX(I,5,6) = SMTX(I,5,6) 
     1                - SMTX(I,5,1) * SMTX(I,1,6)  
     1                - SMTX(I,5,2) * SMTX(I,2,6)  
!       SMTX(I,5,1) = 0. 
!       SMTX(I,5,2) = 0. 
!
 1000 CONTINUE
!
!  ----------------------
!  > �v�Z���x�̃`�F�b�N <
!  ----------------------
!   �������A���̂��ꂪ�ǂ�����A�C�ɂ͂��Ȃ��A�̂���??
!
#ifdef SIB_DEBUG
!
!
      IF ( JCN_SIB_UPPER_MODEL .EQ. -1 ) THEN
        DO I=NSTR,NEND
          if ( ABS(SMTX(I,5,6)).GT.1.D-8 ) THEN
            write(6,*) 'canopy_flux_eqslv error A5' , I , SMTX(I,5,6)
            stop 999
          endif
          if ( ABS(SMTX(I,4,6)).GT.1.D-8 ) THEN
            write(6,*) 'canopy_flux_eqslv error A4' , I , SMTX(I,4,6)
            stop 999
          endif
         ENDDO
      ENDIF
!
!  �������ۂɑ�����āA�������̍��ӂƉE�ӂ������Ă��邩�ǂ����̃`�F�b�N�B
!
      DO I=NSTR,NEND
      DO K=1,5
        X =   SMTX_SAV(I,K,1) * SMTX(I,1,6) 
     1      + SMTX_SAV(I,K,2) * SMTX(I,2,6)        
     1      + SMTX_SAV(I,K,3) * SMTX(I,3,6)        
     1      + SMTX_SAV(I,K,4) * SMTX(I,4,6)        
     1      + SMTX_SAV(I,K,5) * SMTX(I,5,6)        
     1      - SMTX_SAV(I,K,6)
!
        IF ( ABS(X) .GT. 1.D-10 ) THEN
          write(6,*) 'canopy_flux_eqslv error AA' , I , K , X , 
     1        SMTX_SAV(I,K,1) * SMTX(I,1,6) ,
     1      + SMTX_SAV(I,K,2) * SMTX(I,2,6) ,       
     1      + SMTX_SAV(I,K,3) * SMTX(I,3,6) ,       
     1      + SMTX_SAV(I,K,4) * SMTX(I,4,6) ,       
     1      + SMTX_SAV(I,K,5) * SMTX(I,5,6) ,       
     1      - SMTX_SAV(I,K,6)               
          stop 999
        ENDIF
      ENDDO
      ENDDO
#endif 
!
      RETURN
      END