﻿'###############################################################################
'#  Dialogs.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   Dialogs.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#INCLUDE Once "Application.bi"
#IfNDef __USE_GTK__
	#INCLUDE Once "Win/ShlObj.bi"
#EndIf

Const OFN_ENABLEINCLUDENOTIFY = &H400000

#IfDef __USE_GTK__
	Enum OpenOption
		ofReadOnly 
		ofOverwritePrompt 
		ofHideReadOnly
		ofNoChangeDir
		ofShowHelp
		ofNoValidate 
		ofAllowMultiSelect
		ofExtensionDifferent 
		ofPathMustExist 
		ofFileMustExist 
		ofCreatePrompt
		ofShareAware 
		ofNoReadOnlyReturn 
		ofNoTestFileCreate 
		ofNoNetworkButton
		ofNoLongNames 
		ofOldStyleDialog 
		ofNoDereferenceLinks 
		ofEnableIncludeNotify
		ofEnableSizing
	End Enum
#Else
	Enum OpenOption
		ofReadOnly            = OFN_READONLY 
		ofOverwritePrompt     = OFN_OVERWRITEPROMPT 
		ofHideReadOnly        = OFN_HIDEREADONLY
		ofNoChangeDir         = OFN_NOCHANGEDIR
		ofShowHelp            = OFN_SHOWHELP
		ofNoValidate          = OFN_NOVALIDATE 
		ofAllowMultiSelect    = OFN_ALLOWMULTISELECT
		ofExtensionDifferent  = OFN_EXTENSIONDIFFERENT 
		ofPathMustExist       = OFN_PATHMUSTEXIST 
		ofFileMustExist       = OFN_FILEMUSTEXIST 
		ofCreatePrompt        = OFN_CREATEPROMPT
		ofShareAware          = OFN_SHAREAWARE 
		ofNoReadOnlyReturn    = OFN_NOREADONLYRETURN 
		ofNoTestFileCreate    = OFN_NOTESTFILECREATE 
		ofNoNetworkButton     = OFN_NONETWORKBUTTON
		ofNoLongNames         = OFN_NOLONGNAMES 
		ofOldStyleDialog      = OFN_EXPLORER 
		ofNoDereferenceLinks  = OFN_NODEREFERENCELINKS 
		ofEnableIncludeNotify = OFN_ENABLEINCLUDENOTIFY
		ofEnableSizing        = OFN_ENABLESIZING
	End Enum
#EndIf

Type OpenFileDialogOptions
    Count   As Integer
    Options As Integer Ptr
    Declare Sub Include(Value As Integer)
    Declare Sub Exclude(Value As Integer)
    Declare Operator Cast As Integer
End Type

Type Dialog Extends Component
    Public:
        Declare Abstract Function Execute As Boolean
End Type

Type OpenFileDialog Extends Dialog
     Private:
		#IfNDef __USE_GTK__
			Declare Static Function Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
        #EndIf
        Control     As My.Sys.Forms.Control
        FInitialDir   As WString Ptr
        FCaption      As WString Ptr
        FMultiSelect  As Boolean
        FDefaultExt   As WString Ptr
        FFileName     As WString Ptr
        FFileTitle    As WString Ptr
        FFilter       As WString Ptr
     Public:
		FileNames 	As WStringList
		#IfNDef __USE_GTK__
			
        #EndIf
        FilterIndex  As Integer
        Declare Property MultiSelect As Boolean
        Declare Property MultiSelect(Value As Boolean)
        Declare Property InitialDir ByRef As WString
        Declare Property InitialDir(ByRef Value As WString)
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Declare Property DefaultExt ByRef As WString
        Declare Property DefaultExt(ByRef Value As WString)
        Declare Property FileName ByRef As WString
        Declare Property FileName(ByRef Value As WString)
        Declare Property FileTitle ByRef As WString
        Declare Property FileTitle(ByRef Value As WString)
        Declare Property Filter ByRef As WString
        Declare Property Filter(ByRef Value As WString)
        #IfNDef __USE_GTK__
			Handle       As HWND
		#EndIf
        Options      As OpenFileDialogOptions
        Center       As Boolean
        Declare Function Execute As Boolean
        Declare Constructor
        Declare Destructor
        OnFolderChange    As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnSelectionChange As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnTypeChange      As Sub(BYREF Sender As My.Sys.Forms.Control, Index As Integer)
End Type

Type SaveFileDialog Extends Dialog
    Private:
		#IfNDef __USE_GTK__
			Declare Static Function Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
        #EndIf
        Control      As My.Sys.Forms.Control
        FInitialDir   As WString Ptr
        FCaption      As WString Ptr
        FDefaultExt   As WString Ptr
        FFileName     As WString Ptr
        FFilter       As WString Ptr 
    Public:
        FilterIndex  As Integer
        Declare Property InitialDir ByRef As WString
        Declare Property InitialDir(ByRef Value As WString)
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Declare Property DefaultExt ByRef As WString
        Declare Property DefaultExt(ByRef Value As WString)
        Declare Property FileName ByRef As WString
        Declare Property FileName(ByRef Value As WString)
        Declare Property Filter ByRef As WString
        Declare Property Filter(ByRef Value As WString)
        #IfNDef __USE_GTK__
			Handle       As HWND
        #EndIf
        Options      As OpenFileDialogOptions
        Center       As Boolean
        Declare Property Color As Integer
        Declare Property Color(Value As Integer)
        Declare Function Execute As Boolean
        Declare Constructor
        Declare Destructor
        OnFolderChange    As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnSelectionChange As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnTypeChange      As Sub(BYREF Sender As My.Sys.Forms.Control, Index As Integer)
End Type

Type FontDialog Extends Dialog
     Font        As My.Sys.Drawing.Font
     MaxFontSize As Integer
     MinFontSize As Integer
     Declare Function Execute As Boolean
     Declare Constructor
     Declare Destructor
End Type

Type FolderBrowserDialog Extends Dialog
    Private:
		#IfNDef __USE_GTK__
			Declare Static Function Hook(hWnd As HWND, uMsg As uINT, lParam AS LPARAM, lpData As LPARAM) As Integer
        #EndIf
        Control    As My.Sys.Forms.Control
        FCaption    As WString Ptr
        FTitle      As WString Ptr
        FInitialDir As WString Ptr
        FDirectory  As WString Ptr
     Public:
		#IfNDef __USE_GTK__
			Handle     As HWND
		#EndIf
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Declare Property Title ByRef As WString
        Declare Property Title(ByRef Value As WString)
        Declare Property InitialDir ByRef As WString
        Declare Property InitialDir(ByRef Value As WString)
        Declare Property Directory ByRef As WString
        Declare Property Directory(ByRef Value As WString)
        Center     As Boolean
        Declare Function Execute As Boolean
        Declare Constructor
        Declare Destructor
End Type

Type ColorDialog Extends Dialog
     Private:
		#IfNDef __USE_GTK__
			CC              As CHOOSECOLOR
		#EndIf
        _Caption        As WString Ptr
        #IfNDef __USE_GTK__
			Declare Static Function Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
		#EndIf
     Public:
        Parent          As My.Sys.Forms.Control Ptr
        Center          As Integer
        #IfNDef __USE_GTK__
			Handle          As Hwnd
		#EndIf
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Color           As Integer
        Style           As Integer
        #IfNDef __USE_GTK__
			Colors(16)      As COLORREF => {&H0,&H808080,&H000080,&H008080,_
											&H008000,&H808000,&H800000,&H800080,_
											&HFFFFFF,&HC0C0C0,&H0000FF,&H00FFFF,_
											&H00FF00,&HFFFF00,&HFF0000,&HFF00FF _
										}
        #EndIf
        BackColor       As Integer
        Declare Operator Cast As Any Ptr
        Declare Function Execute As Boolean
        Declare Constructor
        Declare Destructor
End Type

#IfNDef __USE_MAKE__
	#Include Once "Dialogs.bas"
#EndIf
