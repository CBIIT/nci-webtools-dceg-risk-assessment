C**   ********** BOF FUNCTION CalculateRisk2 ************************ 
      double precision FUNCTION CalculateRisk2(irkndx,
     * t1, t2, i0, i2, i1, i3, i4, iever, ihyp, rhyp, irace
     * )
      implicit double precision (a-h,o-z)
      integer irkndx, t1, t2, i0, i2, i1, i3, i4, iever
C**      , ihyp, rhyp
C**      integer irace
C**      integer irkndx, nti, nts, i1, i3, iever, i2, ihypp, i4, irace
      common/l1/ bet(8), rf2(2,6),  rf(2)                            ! 5/12/00
      common/l2/ abs(216)
      common/l3/ rlan2(14,6), rlan(14), rmu2(14,6), rmu(14),         ! 5/12/00
     x           sumb(216), sumbb(216), t(15)
      double precision  r8itox(216,9)
C**     data ihyp /99/
C**     data
      n=216                            ! # of covariate patterns in GAIL model      
      
      
C** age categories boundaries
      t( 1)=20.0d0
      t( 2)=25.0d0
      t( 3)=30.0d0
      t( 4)=35.0d0
      t( 5)=40.0d0
      t( 6)=45.0d0
      t( 7)=50.0d0
      t( 8)=55.0d0
      t( 9)=60.0d0
      t(10)=65.0d0
      t(11)=70.0d0
      t(12)=75.0d0
      t(13)=80.0d0
      t(14)=85.0d0
      t(15)=90.0d0
      
       ti=t1 !!!SR
       ts=t2 !!!SR
       do i=2,15              ! i-1=14 ==> current age=85, max for current age
          if (ti .lt. t(i)) then
             ni=i-1                     ! ni holds the index for current age
             goto 70
          end if
       end do
70     continue
       do i=2,15
          if (ts .le. t(i)) then
             ns=i-1                     ! ns holds the index for risk assessment age
             goto 80
          end if
       end do
80     continue
 
 
C** age specific competing hazards (h2) - BCPT model or STAR model
C** (SEER mortality 1985:87, excluding death from breast cancer - white, black)
C** (US   mortality 1990:96, excluding death from breast cancer -     hispanic)
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)
      rmu2( 1,1)=   49.3d0*0.00001d0        ! [20:25) race=white,other  1/12
      rmu2( 2,1)=   53.1d0*0.00001d0        ! [25:30) race=white,other  BCPT
      rmu2( 3,1)=   62.5d0*0.00001d0        ! [30:35) race=white,other
      rmu2( 4,1)=   82.5d0*0.00001d0        ! [35:40) race=white,other
      rmu2( 5,1)=  130.7d0*0.00001d0        ! [40:45) race=white,other
      rmu2( 6,1)=  218.1d0*0.00001d0        ! [45:50) race=white,other
      rmu2( 7,1)=  365.5d0*0.00001d0        ! [50:55) race=white,other
      rmu2( 8,1)=  585.2d0*0.00001d0        ! [55:60) race=white,other
      rmu2( 9,1)=  943.9d0*0.00001d0        ! [60:65) race=white,other
      rmu2(10,1)= 1502.8d0*0.00001d0        ! [65:70) race=white,other
      rmu2(11,1)= 2383.9d0*0.00001d0        ! [70:75) race=white,other
      rmu2(12,1)= 3883.2d0*0.00001d0        ! [75:80) race=white,other
      rmu2(13,1)= 6682.8d0*0.00001d0        ! [80:85) race=white,other
      rmu2(14,1)=14490.8d0*0.00001d0        ! [85:90) race=white,other
      rmu2( 1,2)=   73.2d0*0.00001d0        ! [20:25) race=black     1/12/99
      rmu2( 2,2)=  100.5d0*0.00001d0        ! [25:30) race=black        BCPT
      rmu2( 3,2)=  143.4d0*0.00001d0        ! [30:35) race=black
      rmu2( 4,2)=  185.4d0*0.00001d0        ! [35:40) race=black
      rmu2( 5,2)=  270.9d0*0.00001d0        ! [40:45) race=black
      rmu2( 6,2)=  402.4d0*0.00001d0        ! [45:50) race=black
      rmu2( 7,2)=  646.6d0*0.00001d0        ! [50:55) race=black
      rmu2( 8,2)=  956.4d0*0.00001d0        ! [55:60) race=black
      rmu2( 9,2)= 1496.8d0*0.00001d0        ! [60:65) race=black
      rmu2(10,2)= 2069.2d0*0.00001d0        ! [65:70) race=black
      rmu2(11,2)= 3128.3d0*0.00001d0        ! [70:75) race=black
      rmu2(12,2)= 4533.9d0*0.00001d0        ! [75:80) race=black
      rmu2(13,2)= 7532.6d0*0.00001d0        ! [80:85) race=black
      rmu2(14,2)=11716.6d0*0.00001d0        ! [85:90) race=black
      rmu2( 1,3)=   43.7d0*0.00001d0        ! [20:25) race=hispanic  5/12/00
      rmu2( 2,3)=   53.3d0*0.00001d0        ! [25:30) race=hispanic     STAR
      rmu2( 3,3)=   70.0d0*0.00001d0        ! [30:35) race=hispanic
      rmu2( 4,3)=   89.7d0*0.00001d0        ! [35:40) race=hispanic
      rmu2( 5,3)=  116.3d0*0.00001d0        ! [40:45) race=hispanic
      rmu2( 6,3)=  170.2d0*0.00001d0        ! [45:50) race=hispanic
      rmu2( 7,3)=  264.6d0*0.00001d0        ! [50:55) race=hispanic
      rmu2( 8,3)=  421.6d0*0.00001d0        ! [55:60) race=hispanic
      rmu2( 9,3)=  696.0d0*0.00001d0        ! [60:65) race=hispanic
      rmu2(10,3)= 1086.7d0*0.00001d0        ! [65:70) race=hispanic
      rmu2(11,3)= 1685.8d0*0.00001d0        ! [70:75) race=hispanic
      rmu2(12,3)= 2515.6d0*0.00001d0        ! [75:80) race=hispanic
      rmu2(13,3)= 4186.6d0*0.00001d0        ! [80:85) race=hispanic
      rmu2(14,3)= 8947.6d0*0.00001d0        ! [85:90) race=hispanic

C** age specific competing hazards (h2) for "average woman"
C** (NCHS mortality 1992:96, excluding death from breast cancer - white, black)
C** (US   mortality 1990:96, excluding death from breast cancer -     hispanic)
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)

      rmu2( 1,4)=   44.12*0.00001d0         ! [20,25) race=white,other 11/21
      rmu2( 2,4)=   52.54*0.00001d0         ! [25,30) race=white,other
      rmu2( 3,4)=   67.46*0.00001d0         ! [30,35) race=white,other
      rmu2( 4,4)=   90.92*0.00001d0         ! [35,40) race=white,other
      rmu2( 5,4)=  125.34*0.00001d0         ! [40,45) race=white,other
      rmu2( 6,4)=  195.70*0.00001d0         ! [45,50) race=white,other
      rmu2( 7,4)=  329.84*0.00001d0         ! [50,55) race=white,other
      rmu2( 8,4)=  546.22*0.00001d0         ! [55,60) race=white,other
      rmu2( 9,4)=  910.35*0.00001d0         ! [60,65) race=white,other
      rmu2(10,4)= 1418.54*0.00001d0         ! [65,70) race=white,other
      rmu2(11,4)= 2259.35*0.00001d0         ! [70,75) race=white,other
      rmu2(12,4)= 3611.46*0.00001d0         ! [75,80) race=white,other
      rmu2(13,4)= 6136.26*0.00001d0         ! [80,84) race=white,other
      rmu2(14,4)=14206.63*0.00001d0         ! [85,90) race=white,other
      rmu2( 1,5)=   86.05*0.00001d0         ! [20,25) race=black    11/21/99
      rmu2( 2,5)=  129.21*0.00001d0         ! [25,30) race=black
      rmu2( 3,5)=  183.85*0.00001d0         ! [30,35) race=black
      rmu2( 4,5)=  256.14*0.00001d0         ! [35,40) race=black
      rmu2( 5,5)=  342.62*0.00001d0         ! [40,45) race=black
      rmu2( 6,5)=  469.96*0.00001d0         ! [45,50) race=black
      rmu2( 7,5)=  678.98*0.00001d0         ! [50,55) race=black
      rmu2( 8,5)= 1028.23*0.00001d0         ! [55,60) race=black
      rmu2( 9,5)= 1530.83*0.00001d0         ! [60,65) race=black
      rmu2(10,5)= 2199.72*0.00001d0         ! [65,70) race=black
      rmu2(11,5)= 3335.91*0.00001d0         ! [70,75) race=black
      rmu2(12,5)= 4571.50*0.00001d0         ! [75,80) race=black
      rmu2(13,5)= 7197.04*0.00001d0         ! [80,84) race=black
      rmu2(14,5)=12978.86*0.00001d0         ! [85,90) race=black
      rmu2( 1,6)=   43.7d0*0.00001d0        ! [20:25) race=hispanic  5/12/00
      rmu2( 2,6)=   53.3d0*0.00001d0        ! [25:30) race=hispanic
      rmu2( 3,6)=   70.0d0*0.00001d0        ! [30:35) race=hispanic
      rmu2( 4,6)=   89.7d0*0.00001d0        ! [35:40) race=hispanic
      rmu2( 5,6)=  116.3d0*0.00001d0        ! [40:45) race=hispanic
      rmu2( 6,6)=  170.2d0*0.00001d0        ! [45:50) race=hispanic
      rmu2( 7,6)=  264.6d0*0.00001d0        ! [50:55) race=hispanic
      rmu2( 8,6)=  421.6d0*0.00001d0        ! [55:60) race=hispanic
      rmu2( 9,6)=  696.0d0*0.00001d0        ! [60:65) race=hispanic
      rmu2(10,6)= 1086.7d0*0.00001d0        ! [65:70) race=hispanic
      rmu2(11,6)= 1685.8d0*0.00001d0        ! [70:75) race=hispanic
      rmu2(12,6)= 2515.6d0*0.00001d0        ! [75:80) race=hispanic
      rmu2(13,6)= 4186.6d0*0.00001d0        ! [80:85) race=hispanic
      rmu2(14,6)= 8947.6d0*0.00001d0        ! [85:90) race=hispanic

C** age specific breast cancer composite incidence (h1*)
C** (SEER incidence 1983:87 - white, black)                               BCPT
C** (SEER incidence 1990:96 -     hispanic)                               STAR
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)

      rlan2( 1,1)=   1.0d0*0.00001d0        ! [20:25) race=white,other  1/12
      rlan2( 2,1)=   7.6d0*0.00001d0        ! [25:30) race=white,other  BCPT
      rlan2( 3,1)=  26.6d0*0.00001d0        ! [30:35) race=white,other
      rlan2( 4,1)=  66.1d0*0.00001d0        ! [35:40) race=white,other
      rlan2( 5,1)= 126.5d0*0.00001d0        ! [40:45) race=white,other
      rlan2( 6,1)= 186.6d0*0.00001d0        ! [45:50) race=white,other
      rlan2( 7,1)= 221.1d0*0.00001d0        ! [50:55) race=white,other
      rlan2( 8,1)= 272.1d0*0.00001d0        ! [55:60) race=white,other
      rlan2( 9,1)= 334.8d0*0.00001d0        ! [60:65) race=white,other
      rlan2(10,1)= 392.3d0*0.00001d0        ! [65:70) race=white,other
      rlan2(11,1)= 417.8d0*0.00001d0        ! [70:75) race=white,other
      rlan2(12,1)= 443.9d0*0.00001d0        ! [75:80) race=white,other
      rlan2(13,1)= 442.1d0*0.00001d0        ! [80:85) race=white,other
      rlan2(14,1)= 410.9d0*0.00001d0        ! [85:90) race=white,other



      rlan2( 1,2)=   1.5d0*0.00001d0        ! [20:25) race=black     1/12/99
      rlan2( 2,2)=  12.2d0*0.00001d0        ! [25:30) race=black        BCPT
      rlan2( 3,2)=  36.5d0*0.00001d0        ! [30:35) race=black
      rlan2( 4,2)=  79.6d0*0.00001d0        ! [35:40) race=black
      rlan2( 5,2)= 137.7d0*0.00001d0        ! [40:45) race=black
      rlan2( 6,2)= 165.4d0*0.00001d0        ! [45:50) race=black
      rlan2( 7,2)= 177.9d0*0.00001d0        ! [50:55) race=black
      rlan2( 8,2)= 224.3d0*0.00001d0        ! [55:60) race=black
      rlan2( 9,2)= 275.0d0*0.00001d0        ! [60:65) race=black
      rlan2(10,2)= 280.3d0*0.00001d0        ! [65:70) race=black
      rlan2(11,2)= 309.9d0*0.00001d0        ! [70:75) race=black
      rlan2(12,2)= 360.2d0*0.00001d0        ! [75:80) race=black
      rlan2(13,2)= 414.2d0*0.00001d0        ! [80:85) race=black
      rlan2(14,2)= 345.2d0*0.00001d0        ! [85:90) race=black



      rlan2( 1,3)=   2.00d0*0.00001d0       ! [20:25) race=hispanic  5/12/00
      rlan2( 2,3)=   7.10d0*0.00001d0       ! [25:30) race=hispanic     STAR
      rlan2( 3,3)=  19.70d0*0.00001d0       ! [30:35) race=hispanic
      rlan2( 4,3)=  43.80d0*0.00001d0       ! [35:40) race=hispanic
      rlan2( 5,3)=  81.10d0*0.00001d0       ! [40:45) race=hispanic
      rlan2( 6,3)= 130.70d0*0.00001d0       ! [45:50) race=hispanic
      rlan2( 7,3)= 157.40d0*0.00001d0       ! [50:55) race=hispanic
      rlan2( 8,3)= 185.70d0*0.00001d0       ! [55:60) race=hispanic
      rlan2( 9,3)= 215.10d0*0.00001d0       ! [60:65) race=hispanic
      rlan2(10,3)= 251.20d0*0.00001d0       ! [65:70) race=hispanic
      rlan2(11,3)= 284.60d0*0.00001d0       ! [70:75) race=hispanic
      rlan2(12,3)= 275.70d0*0.00001d0       ! [75:80) race=hispanic
      rlan2(13,3)= 252.30d0*0.00001d0       ! [80:85) race=hispanic
      rlan2(14,3)= 203.90d0*0.00001d0       ! [85:90) race=hispanic




C** age specific breast cancer composite incidence (h1*)-"average woman"
C** (SEER incidence 1992:96 - white, black)
C** (SEER incidence 1990:96 -     hispanic)
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)

      rlan2( 1,4)=   1.22d0*0.00001d0       ! [20:25) race=white,other 11/21
      rlan2( 2,4)=   7.41d0*0.00001d0       ! [25:30) race=white,other
      rlan2( 3,4)=  22.97d0*0.00001d0       ! [30:35) race=white,other
      rlan2( 4,4)=  56.49d0*0.00001d0       ! [35:40) race=white,other
      rlan2( 5,4)= 116.45d0*0.00001d0       ! [40:45) race=white,other
      rlan2( 6,4)= 195.25d0*0.00001d0       ! [45:50) race=white,other
      rlan2( 7,4)= 261.54d0*0.00001d0       ! [50:55) race=white,other
      rlan2( 8,4)= 302.79d0*0.00001d0       ! [55:60) race=white,other
      rlan2( 9,4)= 367.57d0*0.00001d0       ! [60:65) race=white,other
      rlan2(10,4)= 420.29d0*0.00001d0       ! [65:70) race=white,other
      rlan2(11,4)= 473.08d0*0.00001d0       ! [70:75) race=white,other
      rlan2(12,4)= 494.25d0*0.00001d0       ! [75:80) race=white,other
      rlan2(13,4)= 479.76d0*0.00001d0       ! [80:85) race=white,other
      rlan2(14,4)= 401.06d0*0.00001d0       ! [85:90) race=white,other

      rlan2( 1,5)=   2.65d0*0.00001d0       ! [20:25) race=black    11/21/99
      rlan2( 2,5)=  10.90d0*0.00001d0       ! [25:30) race=black
      rlan2( 3,5)=  32.31d0*0.00001d0       ! [30:35) race=black
      rlan2( 4,5)=  63.15d0*0.00001d0       ! [35:40) race=black
      rlan2( 5,5)= 120.46d0*0.00001d0       ! [40:45) race=black
      rlan2( 6,5)= 191.32d0*0.00001d0       ! [45:50) race=black
      rlan2( 7,5)= 234.05d0*0.00001d0       ! [50:55) race=black
      rlan2( 8,5)= 281.26d0*0.00001d0       ! [55:60) race=black
      rlan2( 9,5)= 303.45d0*0.00001d0       ! [60:65) race=black
      rlan2(10,5)= 340.47d0*0.00001d0       ! [65:70) race=black
      rlan2(11,5)= 377.43d0*0.00001d0       ! [70:75) race=black
      rlan2(12,5)= 394.48d0*0.00001d0       ! [75:80) race=black
      rlan2(13,5)= 378.97d0*0.00001d0       ! [80:85) race=black
      rlan2(14,5)= 349.11d0*0.00001d0       ! [85:90) race=black

      rlan2( 1,6)=   2.00d0*0.00001d0       ! [20:25) race=hispanic  5/12/00
      rlan2( 2,6)=   7.10d0*0.00001d0       ! [25:30) race=hispanic
      rlan2( 3,6)=  19.70d0*0.00001d0       ! [30:35) race=hispanic
      rlan2( 4,6)=  43.80d0*0.00001d0       ! [35:40) race=hispanic
      rlan2( 5,6)=  81.10d0*0.00001d0       ! [40:45) race=hispanic
      rlan2( 6,6)= 130.70d0*0.00001d0       ! [45:50) race=hispanic
      rlan2( 7,6)= 157.40d0*0.00001d0       ! [50:55) race=hispanic
      rlan2( 8,6)= 185.70d0*0.00001d0       ! [55:60) race=hispanic
      rlan2( 9,6)= 215.10d0*0.00001d0       ! [60:65) race=hispanic
      rlan2(10,6)= 251.20d0*0.00001d0       ! [65:70) race=hispanic
      rlan2(11,6)= 284.60d0*0.00001d0       ! [70:75) race=hispanic
      rlan2(12,6)= 275.70d0*0.00001d0       ! [75:80) race=hispanic
      rlan2(13,6)= 252.30d0*0.00001d0       ! [80:85) race=hispanic
      rlan2(14,6)= 203.90d0*0.00001d0       ! [85:90) race=hispanic

C** logistic regression coefficients from GAIL model (BCDDP)

      bet(1)=-0.7494824600d0     ! intercept                         1/12/99
      bet(2)= 0.0108080720d0     ! age >=50 indicator
      bet(3)= 0.0940103059d0     ! age menarchy
      bet(4)= 0.5292641686d0     ! # of breast biopsy
      bet(5)= 0.2186262218d0     ! age 1st live birth
      bet(6)= 0.9583027845d0     ! # 1st degree relatives with breast cancer
      bet(7)=-0.2880424830d0     ! # breast biopsy * age >=50 indicator
      bet(8)=-0.1908113865d0     ! age 1st live birth * # 1st degree rel


C** conversion factors (1-attributable risk) used in BCPT model

      rf2(1,1)=0.5788413d0         ! age < 50, race=white,other        1/12/99
      rf2(2,1)=0.5788413d0         ! age >=50, race=white,other

      rf2(1,2)=0.4145300d0         ! age < 50, race=black              1/12/99
      rf2(2,2)=0.4227500d0         ! age >=50, race=black

      rf2(1,3)=0.5788413d0         ! age < 50, race=hispanic         5/12/2000
      rf2(2,3)=0.5788413d0         ! age >=50, race=hispanic


C** conversion factors (1-attributable risk) used for "average woman"

      rf2(1,4)=1.d0                ! age < 50, race=white avg woman      11/21
      rf2(2,4)=1.d0                ! age >=50, race=white avg woman

      rf2(1,5)=1.d0                ! age < 50, race=black avg woman      11/21
      rf2(2,5)=1.d0                ! age >=50, race=black avg woman

      rf2(1,6)=1.d0                ! age < 50, race=hispanic avg woman    5/12
      rf2(2,6)=1.d0                ! age >=50, race=hispanic avg woman

          incr=0
          if (irkndx .eq. 2) incr=3    ! use cols 4,5,6 from rmu, rlan, rf
                                        ! for race specific "avg women"
                                        ! otherwise use cols 1,2,3 depending
                                        ! on users race                5/12/00

          do i=1,14                                ! select race specific
             rmu (i)=rmu2 (i,incr+irace)         ! competeing baseline haz &
             rlan(i)=rlan2(i,incr+irace)         ! br ca composite incidence
          end do

          rf(1)=rf2(1,incr+irace)                ! selecting correct factors
          rf(2)=rf2(2,incr+irace)                ! based on race


          if (irkndx .ge. 2) then               ! set risk factors to base line

             i1=0                          ! baseline age menarchy
             i2=0                          !          # of previous biopsy
             i3=0                          !          age 1st live birth
             i4=0                          !          # 1st degree relatives

             rhyp=1.0d0                      ! set hyperplasia to 1.0
          end if



          ilev =108*i0 + 36*i1 + 12*i2 + 3*i3 + 1*i4 + 1  ! index in r8itox
                                                            ! matrix of the
                                                            ! covariate pattern
                                                            ! range of 1,2...216

                 ! i0: age ge 50 ind  0=[20, 50)
                 !                    1=[50, 85)


                 ! i1: age menarchy   0=[14, 39] U 99 (unknown)
                 !                    1=[12, 14)
                 !                    2=[ 7, 12)


                 ! i2: # biopsy       0=0 or (99 and ever had biopsy=99 unk)
                 !                    1=1 or (99 and ever had biopsy=1 yes)
                 !                    2=[ 2, 30]


                 ! i3: age 1st live   0=<20, 99 (unknown)
                 !                    1=[20, 25)
                 !                    2=[25, 30) U 0
                 !                    3=[30, 55]


                 ! i4: 1st degree rel 0=0, 99 (unknown)
                 !                    1=1
                 !                    2=[2, 31]



C**  Correspondence between exposure level and covariate factors X
C**  in the logistic model

C**  i-to-X correspondence

          do k=1,216                                 ! col1: intercept of ones
             r8itox(k, 1)=1.0d0
          end do

          do k=1,108                           ! col2: indicator for age ge 50
             r8itox(    k, 2)=0.0d0
             r8itox(108+k, 2)=1.0d0
          end do

          do j=1,2                             ! col3: age menarchy categories
          do k=1,36
             r8itox((j-1)*108+   k, 3)=0.0d0
             r8itox((j-1)*108+36+k, 3)=1.0d0
             r8itox((j-1)*108+72+k, 3)=2.0d0
          end do
          end do

          do j=1,6                                 ! col4: # biopsy categories
          do k=1,12
             r8itox((j-1)*36   +k, 4)=0.0d0
             r8itox((j-1)*36+12+k, 4)=1.0d0
             r8itox((j-1)*36+24+k, 4)=2.0d0
          end do
          end do

          do j=1,18                            ! col5: age 1st live birth cats
          do k=1,3
             r8itox((j-1)*12+  k, 5)=0.0d0
             r8itox((j-1)*12+3+k, 5)=1.0d0
             r8itox((j-1)*12+6+k, 5)=2.0d0
             r8itox((j-1)*12+9+k, 5)=3.0d0
          end do
          end do

          do j=1,72                              ! col6: # 1st degree rel cats
             r8itox((j-1)*3+1, 6)=0.0d0
             r8itox((j-1)*3+2, 6)=1.0d0
             r8itox((j-1)*3+3, 6)=2.0d0
          end do

          do i=1,216                            ! col7: age*#biop interaction
                                                ! col8: age 1st live*# rel int
             r8itox(i, 7)=r8itox(i, 2)*r8itox(i, 4)
             r8itox(i, 8)=r8itox(i, 5)*r8itox(i, 6)
          end do

          do i=1,216
             r8itox(i, 9)=1.0
          end do




C**  Computation of breast cancer risk


C**  sum(bi*Xi) for all covariate patterns

          do i=1,216                       ! ln relative risk from BCDDP model
             sumb(i)=0.0d0
             do j=1,8
                sumb(i)=sumb(i)+bet(j)*r8itox(i,j)
             end do
          end do

          do i=1,108                                     ! eliminate intercept
             sumbb(i)=sumb(i)-bet(1)
          end do

          do i=109,216                             ! eliminate intercept & age
             sumbb(i)=sumb(i)-bet(1)-bet(2)
          end do

          do j=1,6                       ! age specific baseline hazard age<50
             rlan(j)=rlan(j)*rf(1)
          end do

          do j=7,14                     ! age specific baseline hazard age>=50
             rlan(j)=rlan(j)*rf(2)
          end do




          i=ilev                              ! setting i to covariate pattern
                                                ! index ilev of range 1-216

          sumbb(i)=sumbb(i)+dlog(rhyp)

          if (i .le. 108) then
             sumbb(i+108)=sumbb(i+108)+dlog(rhyp)
          end if



          if (ts .le. t(ni+1)) then            ! age & projection age within
                                               ! same 5 year age risk interval

              abs(i)=1.-dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))
     x               *(ts-ti))

              abs(i)=abs(i)*rlan(ni)*dexp(sumbb(i))/
     x               (rlan(ni)*dexp(sumbb(i))+rmu(ni))    ! breast cancer risk


          else                              ! age & projection age not in same
                                            ! 5 year age risk interval

                                            ! calculate risk from
                                            ! 1st age interval

              abs(i)=1.-dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))
     x               *(t(ni+1)-ti))

              abs(i)=abs(i)*rlan(ni)*dexp(sumbb(i))/
     x               (rlan(ni)*dexp(sumbb(i))+rmu(ni))          ! risk for 1st
                                                                ! age interval

              if ((ns-ni) .gt. 0) then
                 if ((t2 .gt. 50.0d0) .and. (t1 .lt. 50.0d0)) then
                                                                     ! ages
                                                                     ! stradles
                                                                     ! age 50

                                                         ! calculate risk from
                                                         ! last age interval

                    r=1.-dexp(-(rlan(ns)*dexp(sumbb(i+108))
     x                 +rmu(ns))*(ts-t(ns)))

                    r=r*rlan(ns)*dexp(sumbb(i+108))
     x               /(rlan(ns)*dexp(sumbb(i+108))+rmu(ns))

                    r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))
     x               *(t(ni+1)-ti))

                    if ((ns-ni) .gt. 1) then

                       do j=ni+1,ns-1
                          if (t(j) .ge. 50.0d0) then
                             r=r*dexp(-(rlan(j)*dexp(sumbb(i+108))
     x                                     +rmu(j))*(t(j+1)-t(j)))
                          else
                             r=r*dexp(-(rlan(j)*dexp(sumbb(i+  0))
     x                                     +rmu(j))*(t(j+1)-t(j)))
                          end if
                       end do
                    end if

                    abs(i)=abs(i) + r

                 else                             ! ages do not stradle age 50

                                                  ! calculate risk from
                                                  ! last age interval

                    r=1.-dexp(-(rlan(ns)*dexp(sumbb(i))+rmu(ns))
     x                         *(ts-t(ns)))

                    r=r*rlan(ns)*dexp(sumbb(i))
     x                        /(rlan(ns)*dexp(sumbb(i))+rmu(ns))

                    r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))*
     x                                                   (t(ni+1)-ti))

                    if ((ns-ni) .gt. 1) then

                       do j=ni+1,ns-1
                          r=r*dexp(-(rlan(j)*dexp(sumbb(i))+rmu(j))
     x                                                   *(t(j+1)-t(j)))
                       end do

                    end if

                    abs(i)=abs(i) + r
                 end if
              end if


              if ((ns-ni) .gt. 1) then
                 if ((t2 .gt. 50.0d0) .and. (t1 .lt. 50.0d0)) then

                                                   ! calculate risk from
                                                   ! intervening age intervals

                    do k=ni+1,ns-1

                       if (t(k) .ge. 50.0d0) then
                          r=1.-dexp(-(rlan(k)*dexp(sumbb(i+108))+
     x                                     rmu(k))*(t(k+1)-t(k)))

                          r=r*rlan(k)*dexp(sumbb(i+108))/
     x                          (rlan(k)*dexp(sumbb(i+108))+rmu(k))
                       else
                          r=1.-dexp(-(rlan(k)*dexp(sumbb(i+  0))+
     x                                       rmu(k))*(t(k+1)-t(k)))

                          r=r*rlan(k)*dexp(sumbb(i))/
     x                          (rlan(k)*dexp(sumbb(i))+rmu(k))
                       end if

                       r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))*
     x                                                (t(ni+1)-ti))

                       do j=ni+1,k-1
                          if (t(j) .ge. 50.0d0) then
                              r=r*dexp(-(rlan(j)*dexp(sumbb(i+108))
     x                                      +rmu(j))*(t(j+1)-t(j)))
                          else
                              r=r*dexp(-(rlan(j)*dexp(sumbb(i+  0))+
     x                                       rmu(j))*(t(j+1)-t(j)))
                          end if
                       end do

                       abs(i)=abs(i) + r
                    end do

                 else
                                                   ! calculate risk from
                                                   ! intervening age intervals

                    do k=ni+1,ns-1
                       r=1.-dexp(-(rlan(k)*dexp(sumbb(i))+rmu(k))*
     x                                               (t(k+1)-t(k)))

                       r=r*rlan(k)*dexp(sumbb(i))/
     x                    (rlan(k)*dexp(sumbb(i))+rmu(k))

                       r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))*
     x                                                (t(ni+1)-ti))

                       do j=ni+1,k-1
                          r=r*dexp(-(rlan(j)*dexp(sumbb(i))+rmu(j))
     x                                              *(t(j+1)-t(j)))
                       end do

                       abs(i)=abs(i) + r

                    end do
                 end if
              end if
          end if




          abss=abs(i)*1000.D0

          if ((abss-dint(abss)).ge.0.5) then
             abss=dint(abss)+1.0d0
          else
             abss=dint(abss)
          end if

          abss=abss/10.D0



C** write the results to screen and output file

          if     (irkndx .eq. 1) then
             print      604
 604         format (5x,//)

C**            print      605, t1,t2, i0, i2, i1, i3, i4, iever, ihyp,rhyp
C**            write  (16,605) t1,t2, i0, i2, i1, i3, i4, iever, ihyp,rhyp

 605         format ('T1 ', f3.0, ' T2 ', f3.0, ' Age>=50 ', i2,
     x               ' #Biop ', i2, ' AgeMen ', i2, ' Age1st ', i2,
     x               ' #Rel ', i2, ' iever ', i2, ' ihyp ', i2,
     x               ' rhyp ', f3.0)

             print      606, abs(i)
             write  (16,606) abs(i)
 606         format (/// 18x, 'absolute risk : ', f10.6)

          else if (irkndx .eq. 2) then
             print      608, abs(i)
             write  (16,608) abs(i)
 608         format (    18x, 'average  risk : ', f10.6)

          else if (irkndx .eq. 3) then
             print      610, abs(i)
             write  (16,610) abs(i)
 610         format (    18x, 'baseline risk : ', f10.6)
          end if
        
C**       end do
      CalculateRisk2=abs(i)
      return
      end
C**   ********** EOF FUNCTION CalculateRisk2 ************************ 

C**   ***********BOF getabs ********
      double precision FUNCTION getabs(irndx, 
     * t1, t2, i0, i2, i1, i3, i4, iever
     * , ihyp, rhyp, irace
     * )
      implicit double precision (a-h,o-z)
      integer irndx, t1, t2, i0, i2, i1, i3, i4, iever
C**      , ihyp, rhyp
C**      integer irace
C**      integer irndx, nti, nts, i1, i3, iever, i2, ihypp, i4, irace
      common/l1/ bet(8), rf2(2,6),  rf(2)                            ! 5/12/00
      common/l2/ abs(216)
      common/l3/ rlan2(14,6), rlan(14), rmu2(14,6), rmu(14),         ! 5/12/00
     x           sumb(216), sumbb(216), t(15)
      double precision  r8itox(216,9)
C**     data ihyp /99/
C**     data
      integer irkndx
      n=216                            ! # of covariate patterns in GAIL model
      irkndx=1
      
      
C** age categories boundaries
      t( 1)=20.0d0
      t( 2)=25.0d0
      t( 3)=30.0d0
      t( 4)=35.0d0
      t( 5)=40.0d0
      t( 6)=45.0d0
      t( 7)=50.0d0
      t( 8)=55.0d0
      t( 9)=60.0d0
      t(10)=65.0d0
      t(11)=70.0d0
      t(12)=75.0d0
      t(13)=80.0d0
      t(14)=85.0d0
      t(15)=90.0d0
      
       ti=t1 !!!SR
       ts=t2 !!!SR
       do i=2,15              ! i-1=14 ==> current age=85, max for current age
          if (ti .lt. t(i)) then
             ni=i-1                     ! ni holds the index for current age
             goto 70
          end if
       end do
70     continue
       do i=2,15
          if (ts .le. t(i)) then
             ns=i-1                     ! ns holds the index for risk assessment age
             goto 80
          end if
       end do
80     continue
 
 
C** age specific competing hazards (h2) - BCPT model or STAR model
C** (SEER mortality 1985:87, excluding death from breast cancer - white, black)
C** (US   mortality 1990:96, excluding death from breast cancer -     hispanic)
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)
      rmu2( 1,1)=   49.3d0*0.00001d0        ! [20:25) race=white,other  1/12
      rmu2( 2,1)=   53.1d0*0.00001d0        ! [25:30) race=white,other  BCPT
      rmu2( 3,1)=   62.5d0*0.00001d0        ! [30:35) race=white,other
      rmu2( 4,1)=   82.5d0*0.00001d0        ! [35:40) race=white,other
      rmu2( 5,1)=  130.7d0*0.00001d0        ! [40:45) race=white,other
      rmu2( 6,1)=  218.1d0*0.00001d0        ! [45:50) race=white,other
      rmu2( 7,1)=  365.5d0*0.00001d0        ! [50:55) race=white,other
      rmu2( 8,1)=  585.2d0*0.00001d0        ! [55:60) race=white,other
      rmu2( 9,1)=  943.9d0*0.00001d0        ! [60:65) race=white,other
      rmu2(10,1)= 1502.8d0*0.00001d0        ! [65:70) race=white,other
      rmu2(11,1)= 2383.9d0*0.00001d0        ! [70:75) race=white,other
      rmu2(12,1)= 3883.2d0*0.00001d0        ! [75:80) race=white,other
      rmu2(13,1)= 6682.8d0*0.00001d0        ! [80:85) race=white,other
      rmu2(14,1)=14490.8d0*0.00001d0        ! [85:90) race=white,other
      rmu2( 1,2)=   73.2d0*0.00001d0        ! [20:25) race=black     1/12/99
      rmu2( 2,2)=  100.5d0*0.00001d0        ! [25:30) race=black        BCPT
      rmu2( 3,2)=  143.4d0*0.00001d0        ! [30:35) race=black
      rmu2( 4,2)=  185.4d0*0.00001d0        ! [35:40) race=black
      rmu2( 5,2)=  270.9d0*0.00001d0        ! [40:45) race=black
      rmu2( 6,2)=  402.4d0*0.00001d0        ! [45:50) race=black
      rmu2( 7,2)=  646.6d0*0.00001d0        ! [50:55) race=black
      rmu2( 8,2)=  956.4d0*0.00001d0        ! [55:60) race=black
      rmu2( 9,2)= 1496.8d0*0.00001d0        ! [60:65) race=black
      rmu2(10,2)= 2069.2d0*0.00001d0        ! [65:70) race=black
      rmu2(11,2)= 3128.3d0*0.00001d0        ! [70:75) race=black
      rmu2(12,2)= 4533.9d0*0.00001d0        ! [75:80) race=black
      rmu2(13,2)= 7532.6d0*0.00001d0        ! [80:85) race=black
      rmu2(14,2)=11716.6d0*0.00001d0        ! [85:90) race=black
      rmu2( 1,3)=   43.7d0*0.00001d0        ! [20:25) race=hispanic  5/12/00
      rmu2( 2,3)=   53.3d0*0.00001d0        ! [25:30) race=hispanic     STAR
      rmu2( 3,3)=   70.0d0*0.00001d0        ! [30:35) race=hispanic
      rmu2( 4,3)=   89.7d0*0.00001d0        ! [35:40) race=hispanic
      rmu2( 5,3)=  116.3d0*0.00001d0        ! [40:45) race=hispanic
      rmu2( 6,3)=  170.2d0*0.00001d0        ! [45:50) race=hispanic
      rmu2( 7,3)=  264.6d0*0.00001d0        ! [50:55) race=hispanic
      rmu2( 8,3)=  421.6d0*0.00001d0        ! [55:60) race=hispanic
      rmu2( 9,3)=  696.0d0*0.00001d0        ! [60:65) race=hispanic
      rmu2(10,3)= 1086.7d0*0.00001d0        ! [65:70) race=hispanic
      rmu2(11,3)= 1685.8d0*0.00001d0        ! [70:75) race=hispanic
      rmu2(12,3)= 2515.6d0*0.00001d0        ! [75:80) race=hispanic
      rmu2(13,3)= 4186.6d0*0.00001d0        ! [80:85) race=hispanic
      rmu2(14,3)= 8947.6d0*0.00001d0        ! [85:90) race=hispanic

C** age specific competing hazards (h2) for "average woman"
C** (NCHS mortality 1992:96, excluding death from breast cancer - white, black)
C** (US   mortality 1990:96, excluding death from breast cancer -     hispanic)
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)

      rmu2( 1,4)=   44.12*0.00001d0         ! [20,25) race=white,other 11/21
      rmu2( 2,4)=   52.54*0.00001d0         ! [25,30) race=white,other
      rmu2( 3,4)=   67.46*0.00001d0         ! [30,35) race=white,other
      rmu2( 4,4)=   90.92*0.00001d0         ! [35,40) race=white,other
      rmu2( 5,4)=  125.34*0.00001d0         ! [40,45) race=white,other
      rmu2( 6,4)=  195.70*0.00001d0         ! [45,50) race=white,other
      rmu2( 7,4)=  329.84*0.00001d0         ! [50,55) race=white,other
      rmu2( 8,4)=  546.22*0.00001d0         ! [55,60) race=white,other
      rmu2( 9,4)=  910.35*0.00001d0         ! [60,65) race=white,other
      rmu2(10,4)= 1418.54*0.00001d0         ! [65,70) race=white,other
      rmu2(11,4)= 2259.35*0.00001d0         ! [70,75) race=white,other
      rmu2(12,4)= 3611.46*0.00001d0         ! [75,80) race=white,other
      rmu2(13,4)= 6136.26*0.00001d0         ! [80,84) race=white,other
      rmu2(14,4)=14206.63*0.00001d0         ! [85,90) race=white,other
      rmu2( 1,5)=   86.05*0.00001d0         ! [20,25) race=black    11/21/99
      rmu2( 2,5)=  129.21*0.00001d0         ! [25,30) race=black
      rmu2( 3,5)=  183.85*0.00001d0         ! [30,35) race=black
      rmu2( 4,5)=  256.14*0.00001d0         ! [35,40) race=black
      rmu2( 5,5)=  342.62*0.00001d0         ! [40,45) race=black
      rmu2( 6,5)=  469.96*0.00001d0         ! [45,50) race=black
      rmu2( 7,5)=  678.98*0.00001d0         ! [50,55) race=black
      rmu2( 8,5)= 1028.23*0.00001d0         ! [55,60) race=black
      rmu2( 9,5)= 1530.83*0.00001d0         ! [60,65) race=black
      rmu2(10,5)= 2199.72*0.00001d0         ! [65,70) race=black
      rmu2(11,5)= 3335.91*0.00001d0         ! [70,75) race=black
      rmu2(12,5)= 4571.50*0.00001d0         ! [75,80) race=black
      rmu2(13,5)= 7197.04*0.00001d0         ! [80,84) race=black
      rmu2(14,5)=12978.86*0.00001d0         ! [85,90) race=black
      rmu2( 1,6)=   43.7d0*0.00001d0        ! [20:25) race=hispanic  5/12/00
      rmu2( 2,6)=   53.3d0*0.00001d0        ! [25:30) race=hispanic
      rmu2( 3,6)=   70.0d0*0.00001d0        ! [30:35) race=hispanic
      rmu2( 4,6)=   89.7d0*0.00001d0        ! [35:40) race=hispanic
      rmu2( 5,6)=  116.3d0*0.00001d0        ! [40:45) race=hispanic
      rmu2( 6,6)=  170.2d0*0.00001d0        ! [45:50) race=hispanic
      rmu2( 7,6)=  264.6d0*0.00001d0        ! [50:55) race=hispanic
      rmu2( 8,6)=  421.6d0*0.00001d0        ! [55:60) race=hispanic
      rmu2( 9,6)=  696.0d0*0.00001d0        ! [60:65) race=hispanic
      rmu2(10,6)= 1086.7d0*0.00001d0        ! [65:70) race=hispanic
      rmu2(11,6)= 1685.8d0*0.00001d0        ! [70:75) race=hispanic
      rmu2(12,6)= 2515.6d0*0.00001d0        ! [75:80) race=hispanic
      rmu2(13,6)= 4186.6d0*0.00001d0        ! [80:85) race=hispanic
      rmu2(14,6)= 8947.6d0*0.00001d0        ! [85:90) race=hispanic

C** age specific breast cancer composite incidence (h1*)
C** (SEER incidence 1983:87 - white, black)                               BCPT
C** (SEER incidence 1990:96 -     hispanic)                               STAR
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)

      rlan2( 1,1)=   1.0d0*0.00001d0        ! [20:25) race=white,other  1/12
      rlan2( 2,1)=   7.6d0*0.00001d0        ! [25:30) race=white,other  BCPT
      rlan2( 3,1)=  26.6d0*0.00001d0        ! [30:35) race=white,other
      rlan2( 4,1)=  66.1d0*0.00001d0        ! [35:40) race=white,other
      rlan2( 5,1)= 126.5d0*0.00001d0        ! [40:45) race=white,other
      rlan2( 6,1)= 186.6d0*0.00001d0        ! [45:50) race=white,other
      rlan2( 7,1)= 221.1d0*0.00001d0        ! [50:55) race=white,other
      rlan2( 8,1)= 272.1d0*0.00001d0        ! [55:60) race=white,other
      rlan2( 9,1)= 334.8d0*0.00001d0        ! [60:65) race=white,other
      rlan2(10,1)= 392.3d0*0.00001d0        ! [65:70) race=white,other
      rlan2(11,1)= 417.8d0*0.00001d0        ! [70:75) race=white,other
      rlan2(12,1)= 443.9d0*0.00001d0        ! [75:80) race=white,other
      rlan2(13,1)= 442.1d0*0.00001d0        ! [80:85) race=white,other
      rlan2(14,1)= 410.9d0*0.00001d0        ! [85:90) race=white,other



      rlan2( 1,2)=   1.5d0*0.00001d0        ! [20:25) race=black     1/12/99
      rlan2( 2,2)=  12.2d0*0.00001d0        ! [25:30) race=black        BCPT
      rlan2( 3,2)=  36.5d0*0.00001d0        ! [30:35) race=black
      rlan2( 4,2)=  79.6d0*0.00001d0        ! [35:40) race=black
      rlan2( 5,2)= 137.7d0*0.00001d0        ! [40:45) race=black
      rlan2( 6,2)= 165.4d0*0.00001d0        ! [45:50) race=black
      rlan2( 7,2)= 177.9d0*0.00001d0        ! [50:55) race=black
      rlan2( 8,2)= 224.3d0*0.00001d0        ! [55:60) race=black
      rlan2( 9,2)= 275.0d0*0.00001d0        ! [60:65) race=black
      rlan2(10,2)= 280.3d0*0.00001d0        ! [65:70) race=black
      rlan2(11,2)= 309.9d0*0.00001d0        ! [70:75) race=black
      rlan2(12,2)= 360.2d0*0.00001d0        ! [75:80) race=black
      rlan2(13,2)= 414.2d0*0.00001d0        ! [80:85) race=black
      rlan2(14,2)= 345.2d0*0.00001d0        ! [85:90) race=black



      rlan2( 1,3)=   2.00d0*0.00001d0       ! [20:25) race=hispanic  5/12/00
      rlan2( 2,3)=   7.10d0*0.00001d0       ! [25:30) race=hispanic     STAR
      rlan2( 3,3)=  19.70d0*0.00001d0       ! [30:35) race=hispanic
      rlan2( 4,3)=  43.80d0*0.00001d0       ! [35:40) race=hispanic
      rlan2( 5,3)=  81.10d0*0.00001d0       ! [40:45) race=hispanic
      rlan2( 6,3)= 130.70d0*0.00001d0       ! [45:50) race=hispanic
      rlan2( 7,3)= 157.40d0*0.00001d0       ! [50:55) race=hispanic
      rlan2( 8,3)= 185.70d0*0.00001d0       ! [55:60) race=hispanic
      rlan2( 9,3)= 215.10d0*0.00001d0       ! [60:65) race=hispanic
      rlan2(10,3)= 251.20d0*0.00001d0       ! [65:70) race=hispanic
      rlan2(11,3)= 284.60d0*0.00001d0       ! [70:75) race=hispanic
      rlan2(12,3)= 275.70d0*0.00001d0       ! [75:80) race=hispanic
      rlan2(13,3)= 252.30d0*0.00001d0       ! [80:85) race=hispanic
      rlan2(14,3)= 203.90d0*0.00001d0       ! [85:90) race=hispanic




C** age specific breast cancer composite incidence (h1*)-"average woman"
C** (SEER incidence 1992:96 - white, black)
C** (SEER incidence 1990:96 -     hispanic)
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)

      rlan2( 1,4)=   1.22d0*0.00001d0       ! [20:25) race=white,other 11/21
      rlan2( 2,4)=   7.41d0*0.00001d0       ! [25:30) race=white,other
      rlan2( 3,4)=  22.97d0*0.00001d0       ! [30:35) race=white,other
      rlan2( 4,4)=  56.49d0*0.00001d0       ! [35:40) race=white,other
      rlan2( 5,4)= 116.45d0*0.00001d0       ! [40:45) race=white,other
      rlan2( 6,4)= 195.25d0*0.00001d0       ! [45:50) race=white,other
      rlan2( 7,4)= 261.54d0*0.00001d0       ! [50:55) race=white,other
      rlan2( 8,4)= 302.79d0*0.00001d0       ! [55:60) race=white,other
      rlan2( 9,4)= 367.57d0*0.00001d0       ! [60:65) race=white,other
      rlan2(10,4)= 420.29d0*0.00001d0       ! [65:70) race=white,other
      rlan2(11,4)= 473.08d0*0.00001d0       ! [70:75) race=white,other
      rlan2(12,4)= 494.25d0*0.00001d0       ! [75:80) race=white,other
      rlan2(13,4)= 479.76d0*0.00001d0       ! [80:85) race=white,other
      rlan2(14,4)= 401.06d0*0.00001d0       ! [85:90) race=white,other

      rlan2( 1,5)=   2.65d0*0.00001d0       ! [20:25) race=black    11/21/99
      rlan2( 2,5)=  10.90d0*0.00001d0       ! [25:30) race=black
      rlan2( 3,5)=  32.31d0*0.00001d0       ! [30:35) race=black
      rlan2( 4,5)=  63.15d0*0.00001d0       ! [35:40) race=black
      rlan2( 5,5)= 120.46d0*0.00001d0       ! [40:45) race=black
      rlan2( 6,5)= 191.32d0*0.00001d0       ! [45:50) race=black
      rlan2( 7,5)= 234.05d0*0.00001d0       ! [50:55) race=black
      rlan2( 8,5)= 281.26d0*0.00001d0       ! [55:60) race=black
      rlan2( 9,5)= 303.45d0*0.00001d0       ! [60:65) race=black
      rlan2(10,5)= 340.47d0*0.00001d0       ! [65:70) race=black
      rlan2(11,5)= 377.43d0*0.00001d0       ! [70:75) race=black
      rlan2(12,5)= 394.48d0*0.00001d0       ! [75:80) race=black
      rlan2(13,5)= 378.97d0*0.00001d0       ! [80:85) race=black
      rlan2(14,5)= 349.11d0*0.00001d0       ! [85:90) race=black

      rlan2( 1,6)=   2.00d0*0.00001d0       ! [20:25) race=hispanic  5/12/00
      rlan2( 2,6)=   7.10d0*0.00001d0       ! [25:30) race=hispanic
      rlan2( 3,6)=  19.70d0*0.00001d0       ! [30:35) race=hispanic
      rlan2( 4,6)=  43.80d0*0.00001d0       ! [35:40) race=hispanic
      rlan2( 5,6)=  81.10d0*0.00001d0       ! [40:45) race=hispanic
      rlan2( 6,6)= 130.70d0*0.00001d0       ! [45:50) race=hispanic
      rlan2( 7,6)= 157.40d0*0.00001d0       ! [50:55) race=hispanic
      rlan2( 8,6)= 185.70d0*0.00001d0       ! [55:60) race=hispanic
      rlan2( 9,6)= 215.10d0*0.00001d0       ! [60:65) race=hispanic
      rlan2(10,6)= 251.20d0*0.00001d0       ! [65:70) race=hispanic
      rlan2(11,6)= 284.60d0*0.00001d0       ! [70:75) race=hispanic
      rlan2(12,6)= 275.70d0*0.00001d0       ! [75:80) race=hispanic
      rlan2(13,6)= 252.30d0*0.00001d0       ! [80:85) race=hispanic
      rlan2(14,6)= 203.90d0*0.00001d0       ! [85:90) race=hispanic

C** logistic regression coefficients from GAIL model (BCDDP)

      bet(1)=-0.7494824600d0     ! intercept                         1/12/99
      bet(2)= 0.0108080720d0     ! age >=50 indicator
      bet(3)= 0.0940103059d0     ! age menarchy
      bet(4)= 0.5292641686d0     ! # of breast biopsy
      bet(5)= 0.2186262218d0     ! age 1st live birth
      bet(6)= 0.9583027845d0     ! # 1st degree relatives with breast cancer
      bet(7)=-0.2880424830d0     ! # breast biopsy * age >=50 indicator
      bet(8)=-0.1908113865d0     ! age 1st live birth * # 1st degree rel


C** conversion factors (1-attributable risk) used in BCPT model

      rf2(1,1)=0.5788413d0         ! age < 50, race=white,other        1/12/99
      rf2(2,1)=0.5788413d0         ! age >=50, race=white,other

      rf2(1,2)=0.4145300d0         ! age < 50, race=black              1/12/99
      rf2(2,2)=0.4227500d0         ! age >=50, race=black

      rf2(1,3)=0.5788413d0         ! age < 50, race=hispanic         5/12/2000
      rf2(2,3)=0.5788413d0         ! age >=50, race=hispanic


C** conversion factors (1-attributable risk) used for "average woman"

      rf2(1,4)=1.d0                ! age < 50, race=white avg woman      11/21
      rf2(2,4)=1.d0                ! age >=50, race=white avg woman

      rf2(1,5)=1.d0                ! age < 50, race=black avg woman      11/21
      rf2(2,5)=1.d0                ! age >=50, race=black avg woman

      rf2(1,6)=1.d0                ! age < 50, race=hispanic avg woman    5/12
      rf2(2,6)=1.d0                ! age >=50, race=hispanic avg woman

          incr=0
          if (irkndx .eq. 2) incr=3    ! use cols 4,5,6 from rmu, rlan, rf
                                        ! for race specific "avg women"
                                        ! otherwise use cols 1,2,3 depending
                                        ! on users race                5/12/00

          do i=1,14                                ! select race specific
             rmu (i)=rmu2 (i,incr+irace)         ! competeing baseline haz &
             rlan(i)=rlan2(i,incr+irace)         ! br ca composite incidence
          end do

          rf(1)=rf2(1,incr+irace)                ! selecting correct factors
          rf(2)=rf2(2,incr+irace)                ! based on race


          if (irkndx .ge. 2) then               ! set risk factors to base line

             i1=0                          ! baseline age menarchy
             i2=0                          !          # of previous biopsy
             i3=0                          !          age 1st live birth
             i4=0                          !          # 1st degree relatives

             rhyp=1.0d0                      ! set hyperplasia to 1.0
          end if



          ilev =108*i0 + 36*i1 + 12*i2 + 3*i3 + 1*i4 + 1  ! index in r8itox
                                                            ! matrix of the
                                                            ! covariate pattern
                                                            ! range of 1,2...216

                 ! i0: age ge 50 ind  0=[20, 50)
                 !                    1=[50, 85)


                 ! i1: age menarchy   0=[14, 39] U 99 (unknown)
                 !                    1=[12, 14)
                 !                    2=[ 7, 12)


                 ! i2: # biopsy       0=0 or (99 and ever had biopsy=99 unk)
                 !                    1=1 or (99 and ever had biopsy=1 yes)
                 !                    2=[ 2, 30]


                 ! i3: age 1st live   0=<20, 99 (unknown)
                 !                    1=[20, 25)
                 !                    2=[25, 30) U 0
                 !                    3=[30, 55]


                 ! i4: 1st degree rel 0=0, 99 (unknown)
                 !                    1=1
                 !                    2=[2, 31]



C**  Correspondence between exposure level and covariate factors X
C**  in the logistic model

C**  i-to-X correspondence

          do k=1,216                                 ! col1: intercept of ones
             r8itox(k, 1)=1.0d0
          end do

          do k=1,108                           ! col2: indicator for age ge 50
             r8itox(    k, 2)=0.0d0
             r8itox(108+k, 2)=1.0d0
          end do

          do j=1,2                             ! col3: age menarchy categories
          do k=1,36
             r8itox((j-1)*108+   k, 3)=0.0d0
             r8itox((j-1)*108+36+k, 3)=1.0d0
             r8itox((j-1)*108+72+k, 3)=2.0d0
          end do
          end do

          do j=1,6                                 ! col4: # biopsy categories
          do k=1,12
             r8itox((j-1)*36   +k, 4)=0.0d0
             r8itox((j-1)*36+12+k, 4)=1.0d0
             r8itox((j-1)*36+24+k, 4)=2.0d0
          end do
          end do

          do j=1,18                            ! col5: age 1st live birth cats
          do k=1,3
             r8itox((j-1)*12+  k, 5)=0.0d0
             r8itox((j-1)*12+3+k, 5)=1.0d0
             r8itox((j-1)*12+6+k, 5)=2.0d0
             r8itox((j-1)*12+9+k, 5)=3.0d0
          end do
          end do

          do j=1,72                              ! col6: # 1st degree rel cats
             r8itox((j-1)*3+1, 6)=0.0d0
             r8itox((j-1)*3+2, 6)=1.0d0
             r8itox((j-1)*3+3, 6)=2.0d0
          end do

          do i=1,216                            ! col7: age*#biop interaction
                                                ! col8: age 1st live*# rel int
             r8itox(i, 7)=r8itox(i, 2)*r8itox(i, 4)
             r8itox(i, 8)=r8itox(i, 5)*r8itox(i, 6)
          end do

          do i=1,216
             r8itox(i, 9)=1.0
          end do




C**  Computation of breast cancer risk


C**  sum(bi*Xi) for all covariate patterns

          do i=1,216                       ! ln relative risk from BCDDP model
             sumb(i)=0.0d0
             do j=1,8
                sumb(i)=sumb(i)+bet(j)*r8itox(i,j)
             end do
          end do

          do i=1,108                                     ! eliminate intercept
             sumbb(i)=sumb(i)-bet(1)
          end do

          do i=109,216                             ! eliminate intercept & age
             sumbb(i)=sumb(i)-bet(1)-bet(2)
          end do

          do j=1,6                       ! age specific baseline hazard age<50
             rlan(j)=rlan(j)*rf(1)
          end do

          do j=7,14                     ! age specific baseline hazard age>=50
             rlan(j)=rlan(j)*rf(2)
          end do




          i=ilev                              ! setting i to covariate pattern
                                                ! index ilev of range 1-216

          sumbb(i)=sumbb(i)+dlog(rhyp)

          if (i .le. 108) then
             sumbb(i+108)=sumbb(i+108)+dlog(rhyp)
          end if



          if (ts .le. t(ni+1)) then            ! age & projection age within
                                               ! same 5 year age risk interval

              abs(i)=1.-dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))
     x               *(ts-ti))

              abs(i)=abs(i)*rlan(ni)*dexp(sumbb(i))/
     x               (rlan(ni)*dexp(sumbb(i))+rmu(ni))    ! breast cancer risk


          else                              ! age & projection age not in same
                                            ! 5 year age risk interval

                                            ! calculate risk from
                                            ! 1st age interval

              abs(i)=1.-dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))
     x               *(t(ni+1)-ti))

              abs(i)=abs(i)*rlan(ni)*dexp(sumbb(i))/
     x               (rlan(ni)*dexp(sumbb(i))+rmu(ni))          ! risk for 1st
                                                                ! age interval

              if ((ns-ni) .gt. 0) then
                 if ((t2 .gt. 50.0d0) .and. (t1 .lt. 50.0d0)) then
                                                                     ! ages
                                                                     ! stradles
                                                                     ! age 50

                                                         ! calculate risk from
                                                         ! last age interval

                    r=1.-dexp(-(rlan(ns)*dexp(sumbb(i+108))
     x                 +rmu(ns))*(ts-t(ns)))

                    r=r*rlan(ns)*dexp(sumbb(i+108))
     x               /(rlan(ns)*dexp(sumbb(i+108))+rmu(ns))

                    r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))
     x               *(t(ni+1)-ti))

                    if ((ns-ni) .gt. 1) then

                       do j=ni+1,ns-1
                          if (t(j) .ge. 50.0d0) then
                             r=r*dexp(-(rlan(j)*dexp(sumbb(i+108))
     x                                     +rmu(j))*(t(j+1)-t(j)))
                          else
                             r=r*dexp(-(rlan(j)*dexp(sumbb(i+  0))
     x                                     +rmu(j))*(t(j+1)-t(j)))
                          end if
                       end do
                    end if

                    abs(i)=abs(i) + r

                 else                             ! ages do not stradle age 50

                                                  ! calculate risk from
                                                  ! last age interval

                    r=1.-dexp(-(rlan(ns)*dexp(sumbb(i))+rmu(ns))
     x                         *(ts-t(ns)))

                    r=r*rlan(ns)*dexp(sumbb(i))
     x                        /(rlan(ns)*dexp(sumbb(i))+rmu(ns))

                    r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))*
     x                                                   (t(ni+1)-ti))

                    if ((ns-ni) .gt. 1) then

                       do j=ni+1,ns-1
                          r=r*dexp(-(rlan(j)*dexp(sumbb(i))+rmu(j))
     x                                                   *(t(j+1)-t(j)))
                       end do

                    end if

                    abs(i)=abs(i) + r
                 end if
              end if


              if ((ns-ni) .gt. 1) then
                 if ((t2 .gt. 50.0d0) .and. (t1 .lt. 50.0d0)) then

                                                   ! calculate risk from
                                                   ! intervening age intervals

                    do k=ni+1,ns-1

                       if (t(k) .ge. 50.0d0) then
                          r=1.-dexp(-(rlan(k)*dexp(sumbb(i+108))+
     x                                     rmu(k))*(t(k+1)-t(k)))

                          r=r*rlan(k)*dexp(sumbb(i+108))/
     x                          (rlan(k)*dexp(sumbb(i+108))+rmu(k))
                       else
                          r=1.-dexp(-(rlan(k)*dexp(sumbb(i+  0))+
     x                                       rmu(k))*(t(k+1)-t(k)))

                          r=r*rlan(k)*dexp(sumbb(i))/
     x                          (rlan(k)*dexp(sumbb(i))+rmu(k))
                       end if

                       r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))*
     x                                                (t(ni+1)-ti))

                       do j=ni+1,k-1
                          if (t(j) .ge. 50.0d0) then
                              r=r*dexp(-(rlan(j)*dexp(sumbb(i+108))
     x                                      +rmu(j))*(t(j+1)-t(j)))
                          else
                              r=r*dexp(-(rlan(j)*dexp(sumbb(i+  0))+
     x                                       rmu(j))*(t(j+1)-t(j)))
                          end if
                       end do

                       abs(i)=abs(i) + r
                    end do

                 else
                                                   ! calculate risk from
                                                   ! intervening age intervals

                    do k=ni+1,ns-1
                       r=1.-dexp(-(rlan(k)*dexp(sumbb(i))+rmu(k))*
     x                                               (t(k+1)-t(k)))

                       r=r*rlan(k)*dexp(sumbb(i))/
     x                    (rlan(k)*dexp(sumbb(i))+rmu(k))

                       r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))*
     x                                                (t(ni+1)-ti))

                       do j=ni+1,k-1
                          r=r*dexp(-(rlan(j)*dexp(sumbb(i))+rmu(j))
     x                                              *(t(j+1)-t(j)))
                       end do

                       abs(i)=abs(i) + r

                    end do
                 end if
              end if
          end if




          abss=abs(i)*1000.D0

          if ((abss-dint(abss)).ge.0.5) then
             abss=dint(abss)+1.0d0
          else
             abss=dint(abss)
          end if
          abss=abss/10.D0
C** write the results to screen and output file
      write(*,*) abs(i)
      getabs=abs(i)
      return
      end
C**   ***********Eof getabs ********

C**   ***********BOF getavg ********
      double precision FUNCTION getavg(irndx, 
     * t1, t2, i0, i2, i1, i3, i4, iever
     * , ihyp, rhyp, irace
     * )
      implicit double precision (a-h,o-z)
      integer irndx, t1, t2, i0, i2, i1, i3, i4, iever
C**      , ihyp, rhyp
C**      integer irace
C**      integer irndx, nti, nts, i1, i3, iever, i2, ihypp, i4, irace  
      common/l1/ bet(8), rf2(2,6),  rf(2)                            ! 5/12/00
      common/l2/ abs(216)
      common/l3/ rlan2(14,6), rlan(14), rmu2(14,6), rmu(14),         ! 5/12/00
     x           sumb(216), sumbb(216), t(15)
      double precision  r8itox(216,9)
C**     data ihyp /99/
C**     data
      n=216                            ! # of covariate patterns in GAIL model      
      integer irkndx      
      irkndx=2
      
C** age categories boundaries
      t( 1)=20.0d0
      t( 2)=25.0d0
      t( 3)=30.0d0
      t( 4)=35.0d0
      t( 5)=40.0d0
      t( 6)=45.0d0
      t( 7)=50.0d0
      t( 8)=55.0d0
      t( 9)=60.0d0
      t(10)=65.0d0
      t(11)=70.0d0
      t(12)=75.0d0
      t(13)=80.0d0
      t(14)=85.0d0
      t(15)=90.0d0
      
       ti=t1 !!!SR
       ts=t2 !!!SR
       do i=2,15              ! i-1=14 ==> current age=85, max for current age
          if (ti .lt. t(i)) then
             ni=i-1                     ! ni holds the index for current age
             goto 70
          end if
       end do
70     continue
       do i=2,15
          if (ts .le. t(i)) then
             ns=i-1                     ! ns holds the index for risk assessment age
             goto 80
          end if
       end do
80     continue
 
 
C** age specific competing hazards (h2) - BCPT model or STAR model
C** (SEER mortality 1985:87, excluding death from breast cancer - white, black)
C** (US   mortality 1990:96, excluding death from breast cancer -     hispanic)
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)
      rmu2( 1,1)=   49.3d0*0.00001d0        ! [20:25) race=white,other  1/12
      rmu2( 2,1)=   53.1d0*0.00001d0        ! [25:30) race=white,other  BCPT
      rmu2( 3,1)=   62.5d0*0.00001d0        ! [30:35) race=white,other
      rmu2( 4,1)=   82.5d0*0.00001d0        ! [35:40) race=white,other
      rmu2( 5,1)=  130.7d0*0.00001d0        ! [40:45) race=white,other
      rmu2( 6,1)=  218.1d0*0.00001d0        ! [45:50) race=white,other
      rmu2( 7,1)=  365.5d0*0.00001d0        ! [50:55) race=white,other
      rmu2( 8,1)=  585.2d0*0.00001d0        ! [55:60) race=white,other
      rmu2( 9,1)=  943.9d0*0.00001d0        ! [60:65) race=white,other
      rmu2(10,1)= 1502.8d0*0.00001d0        ! [65:70) race=white,other
      rmu2(11,1)= 2383.9d0*0.00001d0        ! [70:75) race=white,other
      rmu2(12,1)= 3883.2d0*0.00001d0        ! [75:80) race=white,other
      rmu2(13,1)= 6682.8d0*0.00001d0        ! [80:85) race=white,other
      rmu2(14,1)=14490.8d0*0.00001d0        ! [85:90) race=white,other
      rmu2( 1,2)=   73.2d0*0.00001d0        ! [20:25) race=black     1/12/99
      rmu2( 2,2)=  100.5d0*0.00001d0        ! [25:30) race=black        BCPT
      rmu2( 3,2)=  143.4d0*0.00001d0        ! [30:35) race=black
      rmu2( 4,2)=  185.4d0*0.00001d0        ! [35:40) race=black
      rmu2( 5,2)=  270.9d0*0.00001d0        ! [40:45) race=black
      rmu2( 6,2)=  402.4d0*0.00001d0        ! [45:50) race=black
      rmu2( 7,2)=  646.6d0*0.00001d0        ! [50:55) race=black
      rmu2( 8,2)=  956.4d0*0.00001d0        ! [55:60) race=black
      rmu2( 9,2)= 1496.8d0*0.00001d0        ! [60:65) race=black
      rmu2(10,2)= 2069.2d0*0.00001d0        ! [65:70) race=black
      rmu2(11,2)= 3128.3d0*0.00001d0        ! [70:75) race=black
      rmu2(12,2)= 4533.9d0*0.00001d0        ! [75:80) race=black
      rmu2(13,2)= 7532.6d0*0.00001d0        ! [80:85) race=black
      rmu2(14,2)=11716.6d0*0.00001d0        ! [85:90) race=black
      rmu2( 1,3)=   43.7d0*0.00001d0        ! [20:25) race=hispanic  5/12/00
      rmu2( 2,3)=   53.3d0*0.00001d0        ! [25:30) race=hispanic     STAR
      rmu2( 3,3)=   70.0d0*0.00001d0        ! [30:35) race=hispanic
      rmu2( 4,3)=   89.7d0*0.00001d0        ! [35:40) race=hispanic
      rmu2( 5,3)=  116.3d0*0.00001d0        ! [40:45) race=hispanic
      rmu2( 6,3)=  170.2d0*0.00001d0        ! [45:50) race=hispanic
      rmu2( 7,3)=  264.6d0*0.00001d0        ! [50:55) race=hispanic
      rmu2( 8,3)=  421.6d0*0.00001d0        ! [55:60) race=hispanic
      rmu2( 9,3)=  696.0d0*0.00001d0        ! [60:65) race=hispanic
      rmu2(10,3)= 1086.7d0*0.00001d0        ! [65:70) race=hispanic
      rmu2(11,3)= 1685.8d0*0.00001d0        ! [70:75) race=hispanic
      rmu2(12,3)= 2515.6d0*0.00001d0        ! [75:80) race=hispanic
      rmu2(13,3)= 4186.6d0*0.00001d0        ! [80:85) race=hispanic
      rmu2(14,3)= 8947.6d0*0.00001d0        ! [85:90) race=hispanic

C** age specific competing hazards (h2) for "average woman"
C** (NCHS mortality 1992:96, excluding death from breast cancer - white, black)
C** (US   mortality 1990:96, excluding death from breast cancer -     hispanic)
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)

      rmu2( 1,4)=   44.12*0.00001d0         ! [20,25) race=white,other 11/21
      rmu2( 2,4)=   52.54*0.00001d0         ! [25,30) race=white,other
      rmu2( 3,4)=   67.46*0.00001d0         ! [30,35) race=white,other
      rmu2( 4,4)=   90.92*0.00001d0         ! [35,40) race=white,other
      rmu2( 5,4)=  125.34*0.00001d0         ! [40,45) race=white,other
      rmu2( 6,4)=  195.70*0.00001d0         ! [45,50) race=white,other
      rmu2( 7,4)=  329.84*0.00001d0         ! [50,55) race=white,other
      rmu2( 8,4)=  546.22*0.00001d0         ! [55,60) race=white,other
      rmu2( 9,4)=  910.35*0.00001d0         ! [60,65) race=white,other
      rmu2(10,4)= 1418.54*0.00001d0         ! [65,70) race=white,other
      rmu2(11,4)= 2259.35*0.00001d0         ! [70,75) race=white,other
      rmu2(12,4)= 3611.46*0.00001d0         ! [75,80) race=white,other
      rmu2(13,4)= 6136.26*0.00001d0         ! [80,84) race=white,other
      rmu2(14,4)=14206.63*0.00001d0         ! [85,90) race=white,other
      rmu2( 1,5)=   86.05*0.00001d0         ! [20,25) race=black    11/21/99
      rmu2( 2,5)=  129.21*0.00001d0         ! [25,30) race=black
      rmu2( 3,5)=  183.85*0.00001d0         ! [30,35) race=black
      rmu2( 4,5)=  256.14*0.00001d0         ! [35,40) race=black
      rmu2( 5,5)=  342.62*0.00001d0         ! [40,45) race=black
      rmu2( 6,5)=  469.96*0.00001d0         ! [45,50) race=black
      rmu2( 7,5)=  678.98*0.00001d0         ! [50,55) race=black
      rmu2( 8,5)= 1028.23*0.00001d0         ! [55,60) race=black
      rmu2( 9,5)= 1530.83*0.00001d0         ! [60,65) race=black
      rmu2(10,5)= 2199.72*0.00001d0         ! [65,70) race=black
      rmu2(11,5)= 3335.91*0.00001d0         ! [70,75) race=black
      rmu2(12,5)= 4571.50*0.00001d0         ! [75,80) race=black
      rmu2(13,5)= 7197.04*0.00001d0         ! [80,84) race=black
      rmu2(14,5)=12978.86*0.00001d0         ! [85,90) race=black
      rmu2( 1,6)=   43.7d0*0.00001d0        ! [20:25) race=hispanic  5/12/00
      rmu2( 2,6)=   53.3d0*0.00001d0        ! [25:30) race=hispanic
      rmu2( 3,6)=   70.0d0*0.00001d0        ! [30:35) race=hispanic
      rmu2( 4,6)=   89.7d0*0.00001d0        ! [35:40) race=hispanic
      rmu2( 5,6)=  116.3d0*0.00001d0        ! [40:45) race=hispanic
      rmu2( 6,6)=  170.2d0*0.00001d0        ! [45:50) race=hispanic
      rmu2( 7,6)=  264.6d0*0.00001d0        ! [50:55) race=hispanic
      rmu2( 8,6)=  421.6d0*0.00001d0        ! [55:60) race=hispanic
      rmu2( 9,6)=  696.0d0*0.00001d0        ! [60:65) race=hispanic
      rmu2(10,6)= 1086.7d0*0.00001d0        ! [65:70) race=hispanic
      rmu2(11,6)= 1685.8d0*0.00001d0        ! [70:75) race=hispanic
      rmu2(12,6)= 2515.6d0*0.00001d0        ! [75:80) race=hispanic
      rmu2(13,6)= 4186.6d0*0.00001d0        ! [80:85) race=hispanic
      rmu2(14,6)= 8947.6d0*0.00001d0        ! [85:90) race=hispanic

C** age specific breast cancer composite incidence (h1*)
C** (SEER incidence 1983:87 - white, black)                               BCPT
C** (SEER incidence 1990:96 -     hispanic)                               STAR
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)

      rlan2( 1,1)=   1.0d0*0.00001d0        ! [20:25) race=white,other  1/12
      rlan2( 2,1)=   7.6d0*0.00001d0        ! [25:30) race=white,other  BCPT
      rlan2( 3,1)=  26.6d0*0.00001d0        ! [30:35) race=white,other
      rlan2( 4,1)=  66.1d0*0.00001d0        ! [35:40) race=white,other
      rlan2( 5,1)= 126.5d0*0.00001d0        ! [40:45) race=white,other
      rlan2( 6,1)= 186.6d0*0.00001d0        ! [45:50) race=white,other
      rlan2( 7,1)= 221.1d0*0.00001d0        ! [50:55) race=white,other
      rlan2( 8,1)= 272.1d0*0.00001d0        ! [55:60) race=white,other
      rlan2( 9,1)= 334.8d0*0.00001d0        ! [60:65) race=white,other
      rlan2(10,1)= 392.3d0*0.00001d0        ! [65:70) race=white,other
      rlan2(11,1)= 417.8d0*0.00001d0        ! [70:75) race=white,other
      rlan2(12,1)= 443.9d0*0.00001d0        ! [75:80) race=white,other
      rlan2(13,1)= 442.1d0*0.00001d0        ! [80:85) race=white,other
      rlan2(14,1)= 410.9d0*0.00001d0        ! [85:90) race=white,other



      rlan2( 1,2)=   1.5d0*0.00001d0        ! [20:25) race=black     1/12/99
      rlan2( 2,2)=  12.2d0*0.00001d0        ! [25:30) race=black        BCPT
      rlan2( 3,2)=  36.5d0*0.00001d0        ! [30:35) race=black
      rlan2( 4,2)=  79.6d0*0.00001d0        ! [35:40) race=black
      rlan2( 5,2)= 137.7d0*0.00001d0        ! [40:45) race=black
      rlan2( 6,2)= 165.4d0*0.00001d0        ! [45:50) race=black
      rlan2( 7,2)= 177.9d0*0.00001d0        ! [50:55) race=black
      rlan2( 8,2)= 224.3d0*0.00001d0        ! [55:60) race=black
      rlan2( 9,2)= 275.0d0*0.00001d0        ! [60:65) race=black
      rlan2(10,2)= 280.3d0*0.00001d0        ! [65:70) race=black
      rlan2(11,2)= 309.9d0*0.00001d0        ! [70:75) race=black
      rlan2(12,2)= 360.2d0*0.00001d0        ! [75:80) race=black
      rlan2(13,2)= 414.2d0*0.00001d0        ! [80:85) race=black
      rlan2(14,2)= 345.2d0*0.00001d0        ! [85:90) race=black



      rlan2( 1,3)=   2.00d0*0.00001d0       ! [20:25) race=hispanic  5/12/00
      rlan2( 2,3)=   7.10d0*0.00001d0       ! [25:30) race=hispanic     STAR
      rlan2( 3,3)=  19.70d0*0.00001d0       ! [30:35) race=hispanic
      rlan2( 4,3)=  43.80d0*0.00001d0       ! [35:40) race=hispanic
      rlan2( 5,3)=  81.10d0*0.00001d0       ! [40:45) race=hispanic
      rlan2( 6,3)= 130.70d0*0.00001d0       ! [45:50) race=hispanic
      rlan2( 7,3)= 157.40d0*0.00001d0       ! [50:55) race=hispanic
      rlan2( 8,3)= 185.70d0*0.00001d0       ! [55:60) race=hispanic
      rlan2( 9,3)= 215.10d0*0.00001d0       ! [60:65) race=hispanic
      rlan2(10,3)= 251.20d0*0.00001d0       ! [65:70) race=hispanic
      rlan2(11,3)= 284.60d0*0.00001d0       ! [70:75) race=hispanic
      rlan2(12,3)= 275.70d0*0.00001d0       ! [75:80) race=hispanic
      rlan2(13,3)= 252.30d0*0.00001d0       ! [80:85) race=hispanic
      rlan2(14,3)= 203.90d0*0.00001d0       ! [85:90) race=hispanic




C** age specific breast cancer composite incidence (h1*)-"average woman"
C** (SEER incidence 1992:96 - white, black)
C** (SEER incidence 1990:96 -     hispanic)
C** ages [20:25), [25:30), [30:35) .... [70:74), [75:80), [80:85), [85:90)

      rlan2( 1,4)=   1.22d0*0.00001d0       ! [20:25) race=white,other 11/21
      rlan2( 2,4)=   7.41d0*0.00001d0       ! [25:30) race=white,other
      rlan2( 3,4)=  22.97d0*0.00001d0       ! [30:35) race=white,other
      rlan2( 4,4)=  56.49d0*0.00001d0       ! [35:40) race=white,other
      rlan2( 5,4)= 116.45d0*0.00001d0       ! [40:45) race=white,other
      rlan2( 6,4)= 195.25d0*0.00001d0       ! [45:50) race=white,other
      rlan2( 7,4)= 261.54d0*0.00001d0       ! [50:55) race=white,other
      rlan2( 8,4)= 302.79d0*0.00001d0       ! [55:60) race=white,other
      rlan2( 9,4)= 367.57d0*0.00001d0       ! [60:65) race=white,other
      rlan2(10,4)= 420.29d0*0.00001d0       ! [65:70) race=white,other
      rlan2(11,4)= 473.08d0*0.00001d0       ! [70:75) race=white,other
      rlan2(12,4)= 494.25d0*0.00001d0       ! [75:80) race=white,other
      rlan2(13,4)= 479.76d0*0.00001d0       ! [80:85) race=white,other
      rlan2(14,4)= 401.06d0*0.00001d0       ! [85:90) race=white,other

      rlan2( 1,5)=   2.65d0*0.00001d0       ! [20:25) race=black    11/21/99
      rlan2( 2,5)=  10.90d0*0.00001d0       ! [25:30) race=black
      rlan2( 3,5)=  32.31d0*0.00001d0       ! [30:35) race=black
      rlan2( 4,5)=  63.15d0*0.00001d0       ! [35:40) race=black
      rlan2( 5,5)= 120.46d0*0.00001d0       ! [40:45) race=black
      rlan2( 6,5)= 191.32d0*0.00001d0       ! [45:50) race=black
      rlan2( 7,5)= 234.05d0*0.00001d0       ! [50:55) race=black
      rlan2( 8,5)= 281.26d0*0.00001d0       ! [55:60) race=black
      rlan2( 9,5)= 303.45d0*0.00001d0       ! [60:65) race=black
      rlan2(10,5)= 340.47d0*0.00001d0       ! [65:70) race=black
      rlan2(11,5)= 377.43d0*0.00001d0       ! [70:75) race=black
      rlan2(12,5)= 394.48d0*0.00001d0       ! [75:80) race=black
      rlan2(13,5)= 378.97d0*0.00001d0       ! [80:85) race=black
      rlan2(14,5)= 349.11d0*0.00001d0       ! [85:90) race=black

      rlan2( 1,6)=   2.00d0*0.00001d0       ! [20:25) race=hispanic  5/12/00
      rlan2( 2,6)=   7.10d0*0.00001d0       ! [25:30) race=hispanic
      rlan2( 3,6)=  19.70d0*0.00001d0       ! [30:35) race=hispanic
      rlan2( 4,6)=  43.80d0*0.00001d0       ! [35:40) race=hispanic
      rlan2( 5,6)=  81.10d0*0.00001d0       ! [40:45) race=hispanic
      rlan2( 6,6)= 130.70d0*0.00001d0       ! [45:50) race=hispanic
      rlan2( 7,6)= 157.40d0*0.00001d0       ! [50:55) race=hispanic
      rlan2( 8,6)= 185.70d0*0.00001d0       ! [55:60) race=hispanic
      rlan2( 9,6)= 215.10d0*0.00001d0       ! [60:65) race=hispanic
      rlan2(10,6)= 251.20d0*0.00001d0       ! [65:70) race=hispanic
      rlan2(11,6)= 284.60d0*0.00001d0       ! [70:75) race=hispanic
      rlan2(12,6)= 275.70d0*0.00001d0       ! [75:80) race=hispanic
      rlan2(13,6)= 252.30d0*0.00001d0       ! [80:85) race=hispanic
      rlan2(14,6)= 203.90d0*0.00001d0       ! [85:90) race=hispanic

C** logistic regression coefficients from GAIL model (BCDDP)

      bet(1)=-0.7494824600d0     ! intercept                         1/12/99
      bet(2)= 0.0108080720d0     ! age >=50 indicator
      bet(3)= 0.0940103059d0     ! age menarchy
      bet(4)= 0.5292641686d0     ! # of breast biopsy
      bet(5)= 0.2186262218d0     ! age 1st live birth
      bet(6)= 0.9583027845d0     ! # 1st degree relatives with breast cancer
      bet(7)=-0.2880424830d0     ! # breast biopsy * age >=50 indicator
      bet(8)=-0.1908113865d0     ! age 1st live birth * # 1st degree rel


C** conversion factors (1-attributable risk) used in BCPT model

      rf2(1,1)=0.5788413d0         ! age < 50, race=white,other        1/12/99
      rf2(2,1)=0.5788413d0         ! age >=50, race=white,other

      rf2(1,2)=0.4145300d0         ! age < 50, race=black              1/12/99
      rf2(2,2)=0.4227500d0         ! age >=50, race=black

      rf2(1,3)=0.5788413d0         ! age < 50, race=hispanic         5/12/2000
      rf2(2,3)=0.5788413d0         ! age >=50, race=hispanic


C** conversion factors (1-attributable risk) used for "average woman"

      rf2(1,4)=1.d0                ! age < 50, race=white avg woman      11/21
      rf2(2,4)=1.d0                ! age >=50, race=white avg woman

      rf2(1,5)=1.d0                ! age < 50, race=black avg woman      11/21
      rf2(2,5)=1.d0                ! age >=50, race=black avg woman

      rf2(1,6)=1.d0                ! age < 50, race=hispanic avg woman    5/12
      rf2(2,6)=1.d0                ! age >=50, race=hispanic avg woman

          incr=0
          if (irkndx .eq. 2) incr=3    ! use cols 4,5,6 from rmu, rlan, rf
                                        ! for race specific "avg women"
                                        ! otherwise use cols 1,2,3 depending
                                        ! on users race                5/12/00

          do i=1,14                                ! select race specific
             rmu (i)=rmu2 (i,incr+irace)         ! competeing baseline haz &
             rlan(i)=rlan2(i,incr+irace)         ! br ca composite incidence
          end do

          rf(1)=rf2(1,incr+irace)                ! selecting correct factors
          rf(2)=rf2(2,incr+irace)                ! based on race


          if (irkndx .ge. 2) then               ! set risk factors to base line

             i1=0                          ! baseline age menarchy
             i2=0                          !          # of previous biopsy
             i3=0                          !          age 1st live birth
             i4=0                          !          # 1st degree relatives

             rhyp=1.0d0                      ! set hyperplasia to 1.0
          end if



          ilev =108*i0 + 36*i1 + 12*i2 + 3*i3 + 1*i4 + 1  ! index in r8itox
                                                            ! matrix of the
                                                            ! covariate pattern
                                                            ! range of 1,2...216

                 ! i0: age ge 50 ind  0=[20, 50)
                 !                    1=[50, 85)


                 ! i1: age menarchy   0=[14, 39] U 99 (unknown)
                 !                    1=[12, 14)
                 !                    2=[ 7, 12)


                 ! i2: # biopsy       0=0 or (99 and ever had biopsy=99 unk)
                 !                    1=1 or (99 and ever had biopsy=1 yes)
                 !                    2=[ 2, 30]


                 ! i3: age 1st live   0=<20, 99 (unknown)
                 !                    1=[20, 25)
                 !                    2=[25, 30) U 0
                 !                    3=[30, 55]


                 ! i4: 1st degree rel 0=0, 99 (unknown)
                 !                    1=1
                 !                    2=[2, 31]



C**  Correspondence between exposure level and covariate factors X
C**  in the logistic model

C**  i-to-X correspondence

          do k=1,216                                 ! col1: intercept of ones
             r8itox(k, 1)=1.0d0
          end do

          do k=1,108                           ! col2: indicator for age ge 50
             r8itox(    k, 2)=0.0d0
             r8itox(108+k, 2)=1.0d0
          end do

          do j=1,2                             ! col3: age menarchy categories
          do k=1,36
             r8itox((j-1)*108+   k, 3)=0.0d0
             r8itox((j-1)*108+36+k, 3)=1.0d0
             r8itox((j-1)*108+72+k, 3)=2.0d0
          end do
          end do

          do j=1,6                                 ! col4: # biopsy categories
          do k=1,12
             r8itox((j-1)*36   +k, 4)=0.0d0
             r8itox((j-1)*36+12+k, 4)=1.0d0
             r8itox((j-1)*36+24+k, 4)=2.0d0
          end do
          end do

          do j=1,18                            ! col5: age 1st live birth cats
          do k=1,3
             r8itox((j-1)*12+  k, 5)=0.0d0
             r8itox((j-1)*12+3+k, 5)=1.0d0
             r8itox((j-1)*12+6+k, 5)=2.0d0
             r8itox((j-1)*12+9+k, 5)=3.0d0
          end do
          end do

          do j=1,72                              ! col6: # 1st degree rel cats
             r8itox((j-1)*3+1, 6)=0.0d0
             r8itox((j-1)*3+2, 6)=1.0d0
             r8itox((j-1)*3+3, 6)=2.0d0
          end do

          do i=1,216                            ! col7: age*#biop interaction
                                                ! col8: age 1st live*# rel int
             r8itox(i, 7)=r8itox(i, 2)*r8itox(i, 4)
             r8itox(i, 8)=r8itox(i, 5)*r8itox(i, 6)
          end do

          do i=1,216
             r8itox(i, 9)=1.0
          end do




C**  Computation of breast cancer risk


C**  sum(bi*Xi) for all covariate patterns

          do i=1,216                       ! ln relative risk from BCDDP model
             sumb(i)=0.0d0
             do j=1,8
                sumb(i)=sumb(i)+bet(j)*r8itox(i,j)
             end do
          end do

          do i=1,108                                     ! eliminate intercept
             sumbb(i)=sumb(i)-bet(1)
          end do

          do i=109,216                             ! eliminate intercept & age
             sumbb(i)=sumb(i)-bet(1)-bet(2)
          end do

          do j=1,6                       ! age specific baseline hazard age<50
             rlan(j)=rlan(j)*rf(1)
          end do

          do j=7,14                     ! age specific baseline hazard age>=50
             rlan(j)=rlan(j)*rf(2)
          end do




          i=ilev                              ! setting i to covariate pattern
                                                ! index ilev of range 1-216

          sumbb(i)=sumbb(i)+dlog(rhyp)

          if (i .le. 108) then
             sumbb(i+108)=sumbb(i+108)+dlog(rhyp)
          end if



          if (ts .le. t(ni+1)) then            ! age & projection age within
                                               ! same 5 year age risk interval

              abs(i)=1.-dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))
     x               *(ts-ti))

              abs(i)=abs(i)*rlan(ni)*dexp(sumbb(i))/
     x               (rlan(ni)*dexp(sumbb(i))+rmu(ni))    ! breast cancer risk


          else                              ! age & projection age not in same
                                            ! 5 year age risk interval

                                            ! calculate risk from
                                            ! 1st age interval

              abs(i)=1.-dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))
     x               *(t(ni+1)-ti))

              abs(i)=abs(i)*rlan(ni)*dexp(sumbb(i))/
     x               (rlan(ni)*dexp(sumbb(i))+rmu(ni))          ! risk for 1st
                                                                ! age interval

              if ((ns-ni) .gt. 0) then
                 if ((t2 .gt. 50.0d0) .and. (t1 .lt. 50.0d0)) then
                                                                     ! ages
                                                                     ! stradles
                                                                     ! age 50

                                                         ! calculate risk from
                                                         ! last age interval

                    r=1.-dexp(-(rlan(ns)*dexp(sumbb(i+108))
     x                 +rmu(ns))*(ts-t(ns)))

                    r=r*rlan(ns)*dexp(sumbb(i+108))
     x               /(rlan(ns)*dexp(sumbb(i+108))+rmu(ns))

                    r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))
     x               *(t(ni+1)-ti))

                    if ((ns-ni) .gt. 1) then

                       do j=ni+1,ns-1
                          if (t(j) .ge. 50.0d0) then
                             r=r*dexp(-(rlan(j)*dexp(sumbb(i+108))
     x                                     +rmu(j))*(t(j+1)-t(j)))
                          else
                             r=r*dexp(-(rlan(j)*dexp(sumbb(i+  0))
     x                                     +rmu(j))*(t(j+1)-t(j)))
                          end if
                       end do
                    end if

                    abs(i)=abs(i) + r

                 else                             ! ages do not stradle age 50

                                                  ! calculate risk from
                                                  ! last age interval

                    r=1.-dexp(-(rlan(ns)*dexp(sumbb(i))+rmu(ns))
     x                         *(ts-t(ns)))

                    r=r*rlan(ns)*dexp(sumbb(i))
     x                        /(rlan(ns)*dexp(sumbb(i))+rmu(ns))

                    r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))*
     x                                                   (t(ni+1)-ti))

                    if ((ns-ni) .gt. 1) then

                       do j=ni+1,ns-1
                          r=r*dexp(-(rlan(j)*dexp(sumbb(i))+rmu(j))
     x                                                   *(t(j+1)-t(j)))
                       end do

                    end if

                    abs(i)=abs(i) + r
                 end if
              end if


              if ((ns-ni) .gt. 1) then
                 if ((t2 .gt. 50.0d0) .and. (t1 .lt. 50.0d0)) then

                                                   ! calculate risk from
                                                   ! intervening age intervals

                    do k=ni+1,ns-1

                       if (t(k) .ge. 50.0d0) then
                          r=1.-dexp(-(rlan(k)*dexp(sumbb(i+108))+
     x                                     rmu(k))*(t(k+1)-t(k)))

                          r=r*rlan(k)*dexp(sumbb(i+108))/
     x                          (rlan(k)*dexp(sumbb(i+108))+rmu(k))
                       else
                          r=1.-dexp(-(rlan(k)*dexp(sumbb(i+  0))+
     x                                       rmu(k))*(t(k+1)-t(k)))

                          r=r*rlan(k)*dexp(sumbb(i))/
     x                          (rlan(k)*dexp(sumbb(i))+rmu(k))
                       end if

                       r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))*
     x                                                (t(ni+1)-ti))

                       do j=ni+1,k-1
                          if (t(j) .ge. 50.0d0) then
                              r=r*dexp(-(rlan(j)*dexp(sumbb(i+108))
     x                                      +rmu(j))*(t(j+1)-t(j)))
                          else
                              r=r*dexp(-(rlan(j)*dexp(sumbb(i+  0))+
     x                                       rmu(j))*(t(j+1)-t(j)))
                          end if
                       end do

                       abs(i)=abs(i) + r
                    end do

                 else
                                                   ! calculate risk from
                                                   ! intervening age intervals

                    do k=ni+1,ns-1
                       r=1.-dexp(-(rlan(k)*dexp(sumbb(i))+rmu(k))*
     x                                               (t(k+1)-t(k)))

                       r=r*rlan(k)*dexp(sumbb(i))/
     x                    (rlan(k)*dexp(sumbb(i))+rmu(k))

                       r=r*dexp(-(rlan(ni)*dexp(sumbb(i))+rmu(ni))*
     x                                                (t(ni+1)-ti))

                       do j=ni+1,k-1
                          r=r*dexp(-(rlan(j)*dexp(sumbb(i))+rmu(j))
     x                                              *(t(j+1)-t(j)))
                       end do

                       abs(i)=abs(i) + r

                    end do
                 end if
              end if
          end if




          abss=abs(i)*1000.D0

          if ((abss-dint(abss)).ge.0.5) then
             abss=dint(abss)+1.0d0
          else
             abss=dint(abss)
          end if

          abss=abss/10.D0



C** write the results to screen and output file
      write(*,*)abs(i)
      getavg=abs(i)
      return
      end
C**   ***********Eof getavg ********
