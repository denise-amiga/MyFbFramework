﻿'###############################################################################
'#  Control.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"
#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#DEFINE QContainerControl(__Ptr__) *Cast(ContainerControl Ptr,__Ptr__)

	Type ContainerControl Extends Control
    Private:
    Protected:
        Declare Virtual Sub ProcessMessage(BYREF message As Message)		
		  Public:
			     Canvas        As My.Sys.Drawing.Canvas
        Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
        Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        Declare Operator Cast As Control Ptr
        Declare Operator Cast As Any Ptr
        Declare Constructor
        Declare Destructor
	End Type

    Function ContainerControl.ReadProperty(ByRef PropertyName As String) As Any Ptr
        FTempString = LCase(PropertyName)
        Select Case FTempString
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function ContainerControl.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        Select Case LCase(PropertyName)
        Case Else: Return Base.WriteProperty(PropertyName, Value)
        End Select
        Return True
    End Function
    
	Sub ContainerControl.ProcessMessage(BYREF Message As Message)
		Base.ProcessMessage(Message)
	End Sub

	Operator ContainerControl.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator

	Operator ContainerControl.Cast As Any Ptr
		Return @This
	End Operator

	Constructor ContainerControl
		ClassName = "ContainerControl"
	End Constructor

	Destructor ContainerControl
	End Destructor
End namespace