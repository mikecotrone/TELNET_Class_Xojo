#tag Window
Begin Window Window1
   BackColor       =   &cC8C8C800
   Backdrop        =   0
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   553
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   1328403147
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   False
   Title           =   "TELNET Client"
   Visible         =   True
   Width           =   953
   Begin GroupBox ConnectGroupBox
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   ""
      Enabled         =   True
      Height          =   71
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   690
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   24
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   9
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   250
      Begin TextField PortField
         AcceptTabs      =   False
         Alignment       =   1
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &cFFFFFF00
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "ConnectGroupBox"
         Italic          =   False
         Left            =   833
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "23"
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   22
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   59
      End
      Begin TextField IPField
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &cFFFFFF00
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "ConnectGroupBox"
         Italic          =   False
         Left            =   710
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "telehack.com"
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   22
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   121
      End
      Begin PushButton DisconnectButton
         AutoDeactivate  =   True
         Bold            =   False
         ButtonStyle     =   0
         Cancel          =   False
         Caption         =   "Disconnect"
         Default         =   False
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "ConnectGroupBox"
         Italic          =   False
         Left            =   802
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   20
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   48
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   91
      End
      Begin PushButton ConnectButton
         AutoDeactivate  =   True
         Bold            =   False
         ButtonStyle     =   0
         Cancel          =   False
         Caption         =   "Connect"
         Default         =   True
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "ConnectGroupBox"
         Italic          =   False
         Left            =   710
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   19
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   48
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   89
      End
   End
   Begin GroupBox OptionGroupBox
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   ""
      Enabled         =   True
      Height          =   203
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   690
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   25
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   206
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   250
      Begin CheckBox TerminalTypeCheckbox
         AutoDeactivate  =   True
         Bold            =   False
         Caption         =   "Terminal Type Option"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   23
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "OptionGroupBox"
         Italic          =   False
         Left            =   700
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         State           =   1
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   270
         Transparent     =   True
         Underline       =   False
         Value           =   True
         Visible         =   True
         Width           =   183
      End
      Begin CheckBox SuppressGoAheadCheckbox
         AutoDeactivate  =   True
         Bold            =   False
         Caption         =   "Supress Go Ahead Option"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "OptionGroupBox"
         Italic          =   False
         Left            =   700
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         State           =   1
         TabIndex        =   6
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   235
         Transparent     =   True
         Underline       =   False
         Value           =   True
         Visible         =   True
         Width           =   183
      End
      Begin CheckBox EchoOptionCheckbox
         AutoDeactivate  =   True
         Bold            =   False
         Caption         =   "Echo Option"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "OptionGroupBox"
         Italic          =   False
         Left            =   700
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         State           =   1
         TabIndex        =   5
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   217
         Transparent     =   True
         Underline       =   False
         Value           =   True
         Visible         =   True
         Width           =   100
      End
      Begin CheckBox RemoteFlowControlCheckbox
         AutoDeactivate  =   True
         Bold            =   False
         Caption         =   "Remote Flow Control Option"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   21
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "OptionGroupBox"
         Italic          =   False
         Left            =   700
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         State           =   0
         TabIndex        =   7
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   253
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   227
      End
      Begin CheckBox TerminalSpeedCheckbox
         AutoDeactivate  =   True
         Bold            =   False
         Caption         =   "Terminal Speed Option"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   21
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "OptionGroupBox"
         Italic          =   False
         Left            =   700
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         State           =   0
         TabIndex        =   9
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   307
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   227
      End
      Begin CheckBox NegotationAboutWindowSizeCheckbox
         AutoDeactivate  =   True
         Bold            =   False
         Caption         =   "Negotation About Window Size Option"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   21
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "OptionGroupBox"
         Italic          =   False
         Left            =   700
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         State           =   1
         TabIndex        =   8
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   289
         Transparent     =   True
         Underline       =   False
         Value           =   True
         Visible         =   True
         Width           =   250
      End
      Begin CheckBox LogOutCheckbox
         AutoDeactivate  =   True
         Bold            =   False
         Caption         =   "Respond to Server Initiated LogOut"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   21
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "OptionGroupBox"
         Italic          =   False
         Left            =   700
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         State           =   0
         TabIndex        =   10
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   325
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   227
      End
      Begin CheckBox TimingMarkCheckbox
         AutoDeactivate  =   True
         Bold            =   False
         Caption         =   "Allow Timing Mark Option"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   21
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "OptionGroupBox"
         Italic          =   False
         Left            =   700
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         State           =   0
         TabIndex        =   11
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   343
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   227
      End
      Begin CheckBox XDisplayCheckbox
         AutoDeactivate  =   True
         Bold            =   False
         Caption         =   "Send X DIsplay Location Option"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   21
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "OptionGroupBox"
         Italic          =   False
         Left            =   700
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         State           =   0
         TabIndex        =   12
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   362
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   227
      End
   End
   Begin GroupBox TermLenWidGroupbox
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   ""
      Enabled         =   True
      Height          =   140
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   690
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   26
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   412
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   250
      Begin TextField TermWidthField
         AcceptTabs      =   True
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &cFFFFFF00
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         Italic          =   False
         Left            =   710
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   14
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "80"
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   432
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   95
      End
      Begin TextField TermHeightField
         AcceptTabs      =   True
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &cFFFFFF00
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         Italic          =   True
         Left            =   825
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   15
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "120"
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   432
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   95
      End
      Begin Label TermWidthLabel1
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   25
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         Italic          =   False
         Left            =   710
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Terminal Width"
         TextAlign       =   0
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   412
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   88
      End
      Begin Label TermHeightLabel
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   25
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         Italic          =   False
         Left            =   825
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Terminal Height"
         TextAlign       =   0
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   412
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   88
      End
      Begin PopupMenu TerminalTypePopUpMenu
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         InitialValue    =   ""
         Italic          =   False
         Left            =   710
         ListIndex       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   16
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   479
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   95
      End
      Begin Label TerminalTypeLabel
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   25
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         Italic          =   False
         Left            =   710
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   5
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Terminal Type"
         TextAlign       =   0
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   455
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   88
      End
      Begin PopupMenu FlowControlMenu
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   False
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         InitialValue    =   ""
         Italic          =   False
         Left            =   825
         ListIndex       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   17
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   479
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   95
      End
      Begin Label FlowControlLabel
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   25
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         Italic          =   False
         Left            =   825
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   7
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Flow Control"
         TextAlign       =   0
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   455
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   88
      End
      Begin PopupMenu TerminalSpeedMenu
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   False
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         InitialValue    =   ""
         Italic          =   False
         Left            =   710
         ListIndex       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   18
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   523
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   113
      End
      Begin Label TerminalTypeLabel1
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   25
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TermLenWidGroupbox"
         Italic          =   False
         Left            =   710
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   9
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Terminal Speed"
         TextAlign       =   0
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   501
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   88
      End
   End
   Begin GroupBox ScreenTextGroupBox
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   ""
      Enabled         =   True
      Height          =   543
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   10
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   27
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   9
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   675
      Begin DesktopTextArea ScreenText
         AcceptTabs      =   False
         Alignment       =   1
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &cFDFDFD00
         Bold            =   False
         Border          =   True
         Enabled         =   True
         Format          =   ""
         Height          =   509
         HelpTag         =   ""
         HideSelection   =   True
         Index           =   -2147483648
         InitialParent   =   "ScreenTextGroupBox"
         Italic          =   False
         Left            =   17
         LimitText       =   0
         LineHeight      =   0.0
         LineSpacing     =   1.0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         ReadOnly        =   False
         Scope           =   0
         ScrollbarHorizontal=   True
         ScrollbarVertical=   True
         Styled          =   False
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   &c4AC73100
         TextFont        =   "System"
         TextSize        =   12.0
         TextUnit        =   0
         Top             =   16
         Transparent     =   True
         Underline       =   False
         UnicodeMode     =   0
         UseFocusRing    =   False
         Visible         =   True
         Width           =   661
      End
   End
   Begin CheckBox NewEnvironmentCheckbox
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Send New Environment Option"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   21
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   700
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      State           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   11.0
      TextUnit        =   0
      Top             =   381
      Transparent     =   True
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   227
   End
   Begin GroupBox AutoLoginGroupBox
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   ""
      Enabled         =   True
      Height          =   113
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   690
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   33
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   86
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   250
      Begin TextField AutoLoginPassword
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &cFFFFFF00
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "AutoLoginGroupBox"
         Italic          =   False
         Left            =   710
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Mask            =   ""
         Password        =   True
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   4
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   161
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   False
         Visible         =   True
         Width           =   196
      End
      Begin Label AutoLoginUname
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   25
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "AutoLoginGroupBox"
         Italic          =   False
         Left            =   710
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Username"
         TextAlign       =   0
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   93
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   146
      End
      Begin TextField AutoLoginUnameField
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &cFFFFFF00
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "AutoLoginGroupBox"
         Italic          =   False
         Left            =   710
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   117
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   False
         Visible         =   True
         Width           =   189
      End
      Begin Label TermHeightLabel1
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   25
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "AutoLoginGroupBox"
         Italic          =   False
         Left            =   710
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Password"
         TextAlign       =   0
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   11.0
         TextUnit        =   0
         Top             =   138
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   146
      End
   End
   Begin telnet_Class telnetClass
      Address         =   ""
      AutoLoginServiceEnabled=   False
      IAC_RemoteFlowControlValue=   0
      IAC_TerminalSpeedValue=   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Initial_DoEcho  =   ""
      Initial_DontEcho=   ""
      Initial_DontNegotiationAboutWindowSize=   ""
      Initial_DontStatus=   ""
      Initial_DontSuppressGoAhead=   ""
      Initial_DontTimingMark=   ""
      Initial_DontXDisplay=   ""
      Initial_DoStatus=   ""
      Initial_DoSuppressGoAhead=   ""
      Initial_DoTimingMark=   ""
      Initial_WIllNegotiationAboutWindowSize=   ""
      Initial_WillNewEnvironment=   ""
      Initial_WillRemoteFlowControl=   ""
      Initial_WillTerminalSpeed=   ""
      Initial_WillTerminalType=   ""
      Initial_WillXDisplay=   ""
      Initial_WontAuthenticateOption=   ""
      Initial_WontLineMode=   ""
      Initial_WontNegotiationAboutWindowSize=   ""
      Initial_WontNewEnvironment=   ""
      Initial_WontRemoteFlowControl=   ""
      Initial_WontTerminalSpeed=   ""
      Initial_WontTerminalType=   ""
      Initial_WontXDisplay=   ""
      LockedInPosition=   False
      NewEnvDISPLAYInBinary=   ""
      NewEnvUSERInBinary=   ""
      OS_Display_Type =   ""
      OS_USER_Type    =   ""
      PasswordLoginStyle=   False
      Port            =   0
      RunAutoLoginDetection=   0
      Scope           =   0
      ScreenTextLen   =   0
      TabPanelIndex   =   0
      TerminalHeight  =   "80"
      TerminalSpeed   =   "9600"
      TerminalType    =   "Xterm"
      TerminalWidth   =   "120"
      TrackCursorPos  =   0
      UserEcho        =   False
      UserLogOut      =   False
      UsernamePasswordLoginStyle=   False
      UserNegotiationAboutWindowSize=   False
      UserNewEnvironment=   False
      UserRemoteFlowControl=   False
      UserSuppressGoAhead=   False
      UserTerminalSpeed=   False
      UserTerminalType=   True
      UserTimingMark  =   True
      UserXDisplay    =   False
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  IPField.SetFocus
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function cmdMove(moveValue as Integer) As String
		  moveCounter = moveCounter + moveValue
		  Var val as Integer = (cmdBufferArray.Ubound + moveCounter)
		  
		  // BAIL OUT IF WE HAVE < 0
		  if Val < 0  or Val > cmdBufferArray.Ubound Then  
		    Return ""
		    
		  Else
		    Return cmdBufferArray(Val)
		  end if
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private cmdBufferArray() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private keyBuffer As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private moveCounter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private UserInputStream As String
	#tag EndProperty


#tag EndWindowCode

#tag Events DisconnectButton
	#tag Event
		Sub Action()
		  telnetClass.Disconnect
		  telnetClass.Close
		  ScreenText.Text = ""
		  Window1.ConnectButton.Enabled = True
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ConnectButton
	#tag Event
		Sub Action()
		  // MAP USER VARIABLES
		  Var targetHostStr As String = Window1.IPField.Text
		  Var targetPortInt as Integer = PortField.Text.ToInteger
		  Var usernameStr As String = AutoLoginUnameField.Text
		  Var passwordStr As String = AutoLoginPassword.Text
		  Var iacNawsTermHeightInt as Integer = TermHeightField.Text.ToInteger
		  Var iacNawsTermWidthInt as Integer = TermWidthField.Text.ToInteger
		  
		  // DETECT TO USE AUTO LOGIN
		  Var isAutoLoginBln as Boolean
		  if usernameStr <> "" AND passwordStr <> "" then
		    isAutoLoginBln = True
		  end if
		  
		  // PERFORM CONNCETION
		  telnetClass.AutoLoginServiceEnabled = isAutoLoginBln
		  telnetClass.iacNawsTermHeightInt = iacNawsTermHeightInt
		  telnetClass.iacNawsTermWidthInt = iacNawsTermWidthInt
		  telnetClass.connectTelnet(targetHostStr, targetPortInt, usernameStr, passwordStr)
		  
		  // SET& FOCUS TO U TEXTAREAI
		  ScreenText.SetFocus()
		  
		  
		  // // Gather Display Information from OS
		  // OS_Display_Type = mGetDisplayShell
		  // IAC_SO_XDisplayBinValue = convertStringToBin(OS_Display_Type)
		  // OS_USER_Type = mGetUserShell
		  // IAC_SO_NewEnvUserShellBinValue = convertStringToBin(OS_USER_Type)
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TerminalTypeCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserTerminalType = True
		    
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserTerminalType = False
		    
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SuppressGoAheadCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserSuppressGoAhead = True
		    
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserSuppressGoAhead = False
		    
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events EchoOptionCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserEcho = True
		    
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserEcho = False
		    
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events RemoteFlowControlCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserRemoteFlowControl = True
		    FlowControlMenu.Enabled = True
		    
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserRemoteFlowControl = False
		    FlowControlMenu.Enabled = False
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TerminalSpeedCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserTerminalSpeed = True
		    TerminalSpeedMenu.Enabled = true
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserTerminalSpeed = False
		    TerminalSpeedMenu.Enabled = False
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events NegotationAboutWindowSizeCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserNegotiationAboutWindowSize = True
		    
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserNegotiationAboutWindowSize = False
		    
		  end if
		  
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LogOutCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserLogOut = True
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserLogOut = False
		    
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TimingMarkCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserTimingMark = True
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserTimingMark = False
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events XDisplayCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserXDisplay = True
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserXDisplay = False
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TermHeightField
	#tag Event
		Sub TextChange()
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TerminalTypePopUpMenu
	#tag Event
		Sub Open()
		  Var DataPop as String
		  Var Last, Counter as Integer
		  
		  DataPop="XTerm,VT100,IBM-3275-2,Unknown"
		  Last=CountFields(DataPop,",")
		  
		  For Counter=1 to last
		    me.addRow NthField(DataPop,",",counter)
		  Next
		  
		  
		  me.ListIndex = 0
		  
		  
		  
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  
		  if me.Text = "XTERM"  then
		    
		  elseif me.Text = "VT100" then
		    
		  elseif me.Text = "IBM-3275-2" then
		    
		  elseif me.Text = "Unknown" then
		    
		    
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events FlowControlMenu
	#tag Event
		Sub Open()
		  Var DataPop as String
		  Var Last, Counter as Integer
		  
		  DataPop="On,Off,XON,Restart Any,None"
		  Last=CountFields(DataPop,",")
		  
		  For Counter=1 to last
		    me.addRow NthField(DataPop,",",counter)
		  Next
		  
		  me.ListIndex = 4
		  
		  
		  
		  
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  
		  if me.Text = "On"  then
		    telnetClass.IAC_RemoteFlowControlValue = telnetClass.cFlowControlON
		  elseif me.Text = "Off" then
		    telnetClass.IAC_RemoteFlowControlValue = telnetClass.cFlowControlOFF
		  elseif me.Text = "XON" then
		    telnetClass.IAC_RemoteFlowControlValue = telnetClass.cFlowControlXON
		  elseif me.Text = "Restart Any" then
		    telnetClass.IAC_RemoteFlowControlValue = telnetClass.cFlowControlXRestartAny
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TerminalSpeedMenu
	#tag Event
		Sub Open()
		  Var DataPop as String
		  Var Last, Counter as Integer
		  
		  DataPop="None,9600/9600,14400/14400"
		  Last=CountFields(DataPop,",")
		  
		  For Counter=1 to last
		    me.addRow NthField(DataPop,",",counter)
		  Next
		  
		  
		  me.ListIndex = 0
		  
		  
		  
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  
		  if me.Text = "None" Then
		    
		  elseif me.Text = "9600/9600"  then
		    telnetClass.IAC_TerminalSpeedValue = "9600"
		  elseif me.Text = "14400/14400" then
		    telnetClass.IAC_TerminalSpeedValue = "14400"
		    
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ScreenText
	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Want to Send one Character at a time to the NVT
		  if telnetClass.IsConnected = True then
		    
		    if Key.Asc = 8 then
		      // USER PRESSES DELETE KEY
		      
		      // Measure Current Text Length
		      Var TextLength as Integer = Me.Text.Len
		      Var TrimmedText as Integer =  TextLength - 1
		      Var NewText as String = Me.Text.Mid(1,TrimmedText)
		      
		      // MOVE CUSOR BACK ONE CHARACTER ON TEXT AREA
		      // DELETE KEY STROKE FROM BUFFER
		      Var bufferTextLength as Integer = keyBuffer.Len
		      Var keyBufferMinusOne as Integer = bufferTextLength - 1
		      keyBuffer = keyBuffer.Mid(1,keyBufferMinusOne)
		      
		      if bufferTextLength = 0 Then 
		        Return True
		      Else
		        me.Text = NewText
		      end if
		      // SEND PROPER TELNET DELETE SEQUENCE // 'BS' + 'SPACE' + 'BS'
		      Var del as String = ChrB(8)+ChrB(32)+ChrB(8)
		      telnetClass.Write(del)
		      
		    Elseif Key.Asc = 13 Then
		      // USER PRESSES ENTER/RETURN KEY
		      
		      // ADD COMMAND TO COMMAND BUFFER
		      cmdBufferArray.Append keyBuffer
		      keyBuffer = ""
		      telnetClass.Write(Key)
		      
		    Else
		      // USER PRESSES ANY OTHER KEY
		      // ADD TO KEY BUFFER
		      keyBuffer =  keyBuffer + Key
		      telnetClass.Write(Key)
		    End if
		    
		    
		  end if
		  Return True
		  
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events NewEnvironmentCheckbox
	#tag Event
		Sub Action()
		  if me.Value = true then
		    // Is Checked
		    telnetClass.UserNewEnvironment = True
		  elseif me.Value = False then
		    // Not Checked
		    telnetClass.UserNewEnvironment = False
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events telnetClass
	#tag Event
		Sub DataAvailable(responseStr as String)
		  Var formatedScreenOutput As String = ConvertEncoding(responseStr, Encodings.ASCII)
		  Window1.ScreenText.AddText(FormatedScreenOutput)
		End Sub
	#tag EndEvent
	#tag Event
		Sub Error(ErrorCodeInt as Integer, optional ErrorCodeStr as String)
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=false
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
