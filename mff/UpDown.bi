﻿'###############################################################################
'#  UpDown.bi                                                                  #
'#  This file is part of MyFBFramework                                           #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"
'Const UDN_DELTAPOS = (UDN_FIRST - 1)

Namespace My.Sys.Forms
    #DEFINE QUpDown(__Ptr__) *Cast(UpDown Ptr,__Ptr__)

    Enum UpDownOrientation
        udVertical,udHorizontal
    End Enum

    Enum UpDownAlignment
        udRight,udLeft
    End Enum

    Type UpDown Extends Control
        Private:
            FPosition     As Integer
            FMinValue     As Integer
            FMaxValue     As Integer
            FStyle        As Integer
            FArrowKeys    As Boolean
            FIncrement    As Integer
            FAlignment    As Integer
            FThousands    As Boolean
            FWrap         As Boolean
            FUDAccel(1)   As UDACCEL
            AStyle(2)     As Integer
            AAlignment(2) As Integer
            AWrap(2)      As Integer
            AArrowKeys(2) As Integer
            AAThousand(2) As Integer
            FAssociate    As Control Ptr
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Sub ProcessMessage(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            Declare Sub SetRange(AMin As Integer, AMax As Integer)
        Public:
            Declare Property MinValue As Integer
            Declare Property MinValue(Value As Integer)
            Declare Property MaxValue As Integer
            Declare Property MaxValue(Value As Integer)
            Declare Property Increment As Integer
            Declare Property Increment(Value As Integer)
            Declare Property Position  As Integer
            Declare Property Position(Value As Integer)
            Declare Property ArrowKeys As Boolean
            Declare Property ArrowKeys(Value As Boolean)
            Declare Property Thousands As Boolean
            Declare Property Thousands(Value As Boolean)
            Declare Property Wrap As Boolean
            Declare Property Wrap(Value As Boolean)
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Property Associate As Control Ptr
            Declare Property Associate(Value As Control Ptr)
            Declare Operator Cast As Control Ptr
            Declare Constructor
            Declare Destructor
            OnChanging   As Sub(BYREF Sender As UpDown,Value As Integer,Direction As Integer)
    End Type

    Property UpDown.MinValue As Integer
        Return FMinValue
    End Property

    Property UpDown.MinValue(Value As Integer)
        FMinValue = Value
        If Handle Then SendMessage(Handle, UDM_SETRANGE, 0, MakeLong(FMaxValue, FMinValue))
    End Property

    Property UpDown.MaxValue As Integer
       Return FMaxValue 
    End Property

    Property UpDown.MaxValue(Value As Integer)
        FMaxValue = Value
        If Handle Then SendMessage(Handle, UDM_SETRANGE, 0, MakeLong(FMaxValue, FMinValue))
    End Property

    Property UpDown.Position As Integer
        If Handle Then
            FPosition = LoWord(SendMessage(Handle, UDM_GETPOS, 0, 0))
        End If
        Return FPosition
    End Property

    Property UpDown.Position(Value As Integer)
        FPosition = Value
        If Handle Then 
            SendMessage(Handle, UDM_SETPOS, 0, MakeLong(FPosition, 0))
            If FAssociate Then
               FAssociate->Text = Str(Position)
            End If
        End If
    End Property

    Property UpDown.Increment As Integer
        Return FIncrement
    End Property

    Property UpDown.Increment(Value As Integer)
        If Value <> FIncrement then
            FIncrement = Value
            If Handle then
               SendMessage(Handle, UDM_GETACCEL, 1, CInt(@FUDAccel(0)))
               FUDAccel(0).nInc = Value
               SendMessage(Handle, UDM_SETACCEL, 1, CInt(@FUDAccel(0)))
            End If
        End If
    End Property

    Property UpDown.Thousands As Boolean
        Return FThousands
    End Property

    Property UpDown.Thousands(Value As Boolean)
        If FThousands <> Value Then
            FThousands = Value
            Base.Style = WS_CHILD OR UDS_SETBUDDYINT OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment)) OR AWrap(Abs_(FWrap)) OR AArrowKeys(Abs_(FArrowKeys)) OR AAThousand(Abs_(FThousands))
        End If
    End Property

    Property UpDown.Wrap As Boolean
        Return FWrap
    End Property

    Property UpDown.Wrap(Value As Boolean)
        If FWrap <> Value Then
            FWrap = Value
            Base.Style = WS_CHILD OR UDS_SETBUDDYINT OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment)) OR AWrap(Abs_(FWrap)) OR AArrowKeys(Abs_(FArrowKeys)) OR AAThousand(Abs_(FThousands))
        End If
    End Property

    Property UpDown.Style As Integer
        Return FStyle
    End Property

    Property UpDown.Style(Value As Integer)
        Dim As Integer OldStyle,Temp
        OldStyle = FStyle
        If FStyle <> Value Then
            FStyle = Value
            If OldStyle = 0 Then
                Temp = This.Width
                This.Width = Height
                Height = Temp
            End If
            Base.Style = WS_CHILD OR UDS_SETBUDDYINT OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment)) OR AWrap(Abs_(FWrap)) OR AArrowKeys(Abs_(FArrowKeys)) OR AAThousand(Abs_(FThousands))
        End If
    End Property

    Property UpDown.Associate As Control Ptr
        Return FAssociate
    End Property

    Property UpDown.Associate(Value As Control Ptr)
        FAssociate = Value
        If FAssociate Then
           If UCase(FAssociate->ClassName) = "TEXTBOX" Then
              SendMessage(Handle, UDM_SETBUDDY, CInt(FAssociate->Handle), 0)
              FAssociate->Text = WStr(Position)
           Else
           End If
        End If
    End Property

    Sub UpDown.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QUpDown(Sender.Child)
                SendMessage(.Handle, UDM_SETRANGE, 0, MakeLong(.FMaxValue, .FMinValue))
                SendMessage(.Handle, UDM_SETPOS, 0, MakeLong(.FPosition, 0))
                SendMessage(.Handle, UDM_GETACCEL, 1, CInt(@.FUDAccel(0)))
                .FUDAccel(0).nInc = .FIncrement
                SendMessage(.Handle, UDM_SETACCEL, 1, CInt(@.FUDAccel(0)))
                .Position = .FPosition
            End With
        End If
    End Sub

    Sub UpDown.WndProc(BYREF Message As Message)
    End Sub

    Sub UpDown.ProcessMessage(BYREF Message As Message)
        Select Case Message.Msg
        Case WM_SIZE
            Dim As Rect R
            GetClientRect Handle,@R
            InvalidateRect Handle,@R,True
        Case CM_NOTIFY
            Dim As NMHDR Ptr NM
            NM = Cast(LPNMHDR,Message.lParam)
            If NM->Code = UDN_DELTAPOS Then
                Dim As NM_UPDOWN Ptr NMUD
                NMUD = Cast(NM_UPDOWN Ptr,Message.lParam)
                If OnChanging Then OnChanging(This,NMUD->iPos,NMUD->iDelta)
            End If
        End Select
    End Sub

    Operator UpDown.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor UpDown
        Dim As Boolean Result
        Dim As INITCOMMONCONTROLSEX ICC
        ICC.dwSize = SizeOF(ICC)
        ICC.dwICC  = ICC_UPDOWN_CLASS
        Result = InitCommonControlsEx(@ICC)
        If Not Result Then InitCommonControls
        AStyle(0)        = 0
        AStyle(1)        = UDS_HORZ
        AAlignment(0)    = UDS_ALIGNRIGHT
        AAlignment(1)    = UDS_ALIGNLEFT
        AWrap(0)         = 0
        AWrap(1)         = UDS_WRAP
        AArrowKeys(0)    = 0
        AArrowKeys(1)    = UDS_ARROWKEYS
        AAThousand(0)    = UDS_NOTHOUSANDS
        AAThousand(1)    = 0
        FMinValue        = 0
        FMaxValue        = 100
        FArrowKeys       = True
        FIncrement       = 1
        FAlignment       = 0
        FStyle           = 0
        FThousands       = True
        FUDAccel(0).nInc = FIncrement
        With This
            .RegisterClass "UpDown", UPDOWN_CLASS
            .Child             = @This
            .ChildProc         = @WndProc
            WLet FClassName, "UpDown"
            WLet FClassAncestor, UPDOWN_CLASS
            .ExStyle           = 0
            Base.Style             = WS_CHILD OR UDS_SETBUDDYINT OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment)) OR AWrap(Abs_(FWrap)) OR AArrowKeys(Abs_(FArrowKeys)) OR AAThousand(Abs_(FThousands))
            .Width             = GetSystemMetrics(SM_CXVSCROLL)
            .Height            = GetSystemMetrics(SM_CYVSCROLL)
            .Height            = .Height + (.Height \ 2)
            .OnHandleIsAllocated = @HandleIsAllocated
        End With  
    End Constructor

    Destructor UpDown
    End Destructor
End namespace
