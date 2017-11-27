module modBCPTLib

	!
	! example of an enumeration
	!
	enum :: MyEnum             
		enumerator :: e1 = 1, e2, e3
	end enum MyEnum

	!
	! example of a class prototype
	!
	type :: clsBCPTLib

		! example of a static field
		integer, private, static :: Sfield 
		! example of an instance field
		integer, private :: Ifield 
		! example of an enumeration declaration
		type (MyEnum) :: Enum1

	contains
        procedure, nopass :: GetAbsoluteRisk
		! example of a static method declaration
		procedure, nopass :: Sproc
		! example of a static property declaration
		property, nopass  :: Sprop => Get_Sprop, Set_Sprop
		! example of a static constructor
		initial, nopass, private :: Sctor
		! example of an instance method declaration
		procedure, pass :: Iproc
		! example of an instance property declaration
		property, pass :: Iprop => Get_Iprop, Set_Iprop
		! example of an instance constructor
		initial, pass :: Ictor
	end type clsBCPTLib
  
contains  

	!
	! implementation of a static method
	!
    FUNCTION GetAbsoluteRisk(CuurentAge, ProjectionAge, MenarcheAge, FirstLiveBirthAge, EverHadBiopsy, NumberOfBiopsy, HyperPlasia, FirstDegRelatives, Race) 
      integer CuurentAge &
        , ProjectionAge  &
        , MenarcheAge  &
        , FirstLiveBirthAge  &
        , EverHadBiopsy  &
        , NumberOfBiopsy  &
        , HyperPlasia  &
        , FirstDegRelatives  &
        , Race  
       double precision res
       GetAbsoluteRisk = 1.0
      end function
	
	subroutine Sproc (Ivar, Rvar)
		!
		! Place variable declarations here
		!
		integer, intent (in out) :: Ivar 
		real, intent (in out) :: Rvar 
		!
		! Place executable statements here
		!
	end subroutine Sproc
	
	!
	! Implementation of a static property setter
	!
	subroutine Set_Sprop (Value)
		!
		! Place variable declarations here
		!
		integer, value :: Value
		!
		! Place executable statements here
		!
		clsBCPTLib%Sfield = Value   ! “set” the class field
	end subroutine Set_Sprop

	!
	! Implementation of a static property getter
	!
	function Get_Sprop () result (Res)
		!
		! Place variable declarations here
		!
		integer :: Res
		!
		! Place executable statements here
		!
		Res = clsBCPTLib%Sfield   ! “get” the class field value
	end function  Get_Sprop

	!
	! Implementation of a static constructor
	!
	subroutine Sctor ()
		!
		! Place variable declarations here
		!

                !
		! Place source code here
		!
		clsBCPTLib%Sfield = 0
	end subroutine Sctor

	!
	! Implementation of an instance method
	!
	subroutine Iproc (This, Ivar, Rvar)
		!
		! Place variable declarations here
		!
		type (clsBCPTLib) :: This
		integer, intent (in out) :: Ivar 
		real, intent (in out) :: Rvar 
		!
		! Place executable statements here
		!
	end subroutine Iproc

	!
	! implementation of an instance property getter
	!
	function Get_Iprop (This) result (Ires)
		!
		! Place variable declarations here
		!
		type (clsBCPTLib) :: This
		integer :: Ires
		!
		! Place executable statements here
		!
		Ires = This%Ifield   ! “get” the class field value
	end function  Get_Iprop

	!
	! implementation of an instance property setter
	!
	subroutine Set_Iprop (This, Value)
		!
		! Place variable declarations here
		!
		type (clsBCPTLib) :: This
		integer, value :: Value
		!
		! Place executable statements here
		!
		This%Ifield = Value   ! “set” the class field
	end subroutine Set_Iprop

	!
	! implementation of an instance constructor
	!
	subroutine Ictor (This, Value)
		!
		! Place variable declarations here
		!
		type (clsBCPTLib) :: This
		integer, value :: Value
		!
		! Place executable statements here
		!
		This%Ifield = Value
	end subroutine Ictor
  
end module modBCPTLib
