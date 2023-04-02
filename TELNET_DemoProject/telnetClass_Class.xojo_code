#tag Class
Protected Class telnet_Class
Inherits TCPSocket
	#tag Event
		Sub Connected()
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  Dim TmpFrame, IAC_Frame_String As String
		  Dim TmpFrameLenCounter As Integer
		  
		  Dim TmpSOFrame, IAC_SO_Frame_String As String
		  Dim TmpSOFrameLenCounter As Integer
		  
		  Dim TmpDataFrame  As String
		  Dim TmpDataFrameLenCounter As Integer
		  
		  Dim Decoded_IAC_Frames as String
		  Dim Decoded_IAC_SO_Frames as String
		  
		  Dim IAC_StringLength As Integer
		  Dim IAC_SO_StringLength As Integer
		  
		  dim i, ii, y as integer
		  
		  While Me.BytesAvailable > 0
		    ReceiveBuffer = Me.ReadAll(Encodings.ASCII)
		    
		    // // Match and Process TELNET IAC Negotiations
		    Decoded_IAC_Frames =  Decode_IAC_Frames
		    
		    // Count Byte Length of String
		    IAC_StringLength = LenB(Decoded_IAC_Frames)
		    
		    // Convert Binary to ASCII and Store in IAC Input Queue
		    For i = 0 To IAC_StringLength-1 
		      TmpFrame =TmpFrame + Str(Asc(Decoded_IAC_Frames.Mid(i+1,1))) + ","
		      TmpFrameLenCounter = TmpFrame.Len
		      If TmpFrameLenCounter = 9 Or TmpFrameLenCounter = 10 Or TmpFrameLenCounter = 11 Or  TmpFrameLenCounter = 12 Then
		        IAC_Frame_String = Mid(TmpFrame,1,TmpFrame.Len-1)
		        IAC_InputQueue.Append (IAC_Frame_String)
		        TmpFrame = ""
		        TmpFrameLenCounter = 0
		      End If
		    Next i
		    
		    // Decode Inbound TELNET IAC SubOption Negotiation Frames
		    Decoded_IAC_SO_Frames = Decode_IAC_SO_Frames
		    
		    // Count Byte Length of String
		    IAC_SO_StringLength = LenB(Decoded_IAC_SO_Frames) 
		    
		    // Convert Binary to ASCII and Store in IAC SubOptions (SO) Input Queue
		    For ii = 0 To IAC_SO_StringLength-1
		      TmpSOFrame =TmpSOFrame + Str(Asc(Decoded_IAC_SO_Frames.Mid(ii+1,1))) + ","
		      TmpSOFrameLenCounter = TmpSOFrame.Len
		      If TmpSOFrameLenCounter = 22 or TmpSOFrameLenCounter = 21 Then
		        IAC_SO_Frame_String = Mid(TmpSOFrame,1,TmpSOFrame.Len-1)
		        IAC_SO_InputQueue.Append (IAC_SO_Frame_String)
		        TmpSOFrame = ""
		        TmpSOFrameLenCounter = 0
		      End If
		    Next ii
		    
		    
		    // // Decode Inbound TELNET Data
		    Dim DecodedTELNET_Data as String = DecodeTELNETData
		    
		    // Count Byte Length of String
		    Dim Data_StringLength As Integer
		    Data_StringLength = LenB(DecodedTELNET_Data)
		    
		    // Convert Binary to ASCII and Store in Data Queue
		    For y  = 0 To Data_StringLength-1
		      TmpDataFrame =TmpDataFrame + Chr(Asc(DecodedTELNET_Data.Mid(y+1,1)))
		      TmpDataFrameLenCounter = TmpDataFrame.LenB
		      Data_InputQueue.Append (TmpDataFrame)
		      TmpDataFrame = ""
		      TmpDataFrameLenCounter = 0
		    Next y
		  Wend 
		  
		  // Finished Filling Input Queues :: Begin to Process Responses
		  mProcessIAC_OutputResponse
		  mProcessIAC_SO_OutputResponse
		  
		  // Send the Data Messages to the Screen Directly since it is TELNET Data
		  ReceiveTELNETData
		  
		  // Live Screen Scroll for GUI
		  mLiveScreenScroll
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Error(err As RuntimeException)
		  If me.LastErrorCode <> 0 then
		    
		    #IF TargetMacOS AND TargetLinux Then
		      if me.LastErrorCode = 22 then
		        RaiseEvent Errors(22,"You are attempting to write to a socket that has been disconnected")
		      elseif me.LastErrorCode = 64 then
		        RaiseEvent Errors(64,"You are attempting to connect to a host that is not responding")
		      elseif me.LastErrorCode = 95 then
		        RaiseEvent Errors(95,"Socket operation was attempted on a non-socket port.")
		      elseif me.LastErrorCode = 96 then
		        RaiseEvent Errors(96,"Destination address is required")
		      elseif me.LastErrorCode = 97 then
		        RaiseEvent Errors(97,"Message was too long")
		      elseif me.LastErrorCode = 98 then
		        RaiseEvent Errors(98,"Protocol is the wrong type for this socket")
		      elseif me.LastErrorCode = 99 then
		        RaiseEvent Errors(99,"Protocol not available")
		      elseif me.LastErrorCode = 100 then
		        RaiseEvent(100,"There was an error opening and initializing the drivers")
		      elseif me.LastErrorCode = 102 then
		        RaiseEvent(102,"TCP/IP Socket Connection was terminated")
		      elseif me.LastErrorCode = 103 then
		        RaiseEvent(103,"Unable to resolve hostname")
		      elseif me.LastErrorCode = 105 then
		        RaiseEvent(105,"The IP Address currently is in use")
		      elseif me.LastErrorCode = 106 then
		        RaiseEvent(106,"The Socket is in an invalid state")
		      elseif me.LastErrorCode = 107 then
		        RaiseEvent(107,"The Port number specified is invalid: [" + str(me.Port) + "]")
		      elseif me.LastErrorCode = 120 then
		        RaiseEvent(120,"Protocol is not supported")
		      elseif me.LastErrorCode = 125 then
		        RaiseEvent(125,"The IP Address currently is in use")
		      else
		        RaiseEvent(Me.LastErrorCode)
		      End If
		      
		    #Elseif TargetWin32 Then
		      RaiseEvent(Me.LastErrorCode)
		    #EndIf
		    
		  end if
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function authenticateResponseFrames(OptionVerb as String) As string
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    
		    Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cAuthenticate)
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    
		    Response = ChrB(cIAC) + ChrB(cWONT) + ChrB(cAuthenticate)
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Do not Reply as server does not want this mode
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Do not Reply as server does not want this mode
		  End If
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Connect(TargetHostStr as String, targetPortInt as Integer, optional usernameStr as String, optional passwordStr as String)
		  // Calling the overridden superclass method.
		  Super.Connect()
		  Dim StartTimer As Double
		  Dim TimeOut As Double = 3000000
		  
		  Me.Address = targetHostStr
		  Me.Port = targetPortInt
		  
		  TELNETUsername = usernameStr
		  TELNETPassword = passwordStr
		  
		  StartTimer = Microseconds
		  
		  // Connect to Destination IP Address and TELNET port 23
		  Me.Connect
		  
		  Do
		    Me.Poll
		    Window1.ConnectButton.Enabled = False
		  Loop Until (Me.IsConnected = True Or Microseconds - StartTimer > TimeOut)
		  
		  If Me.IsConnected = True Then
		    // Send Initial IAC Offer of NVT/TELNET Capabilities to Server
		    mSendInitial_IAC_Offer
		    
		  Elseif Me.IsConnected = False Or Microseconds - StartTimer > TimeOut Then
		    Me.Disconnect
		    Me.Close
		    Window1.ConnectButton.Enabled = True
		  End If
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From TCPSocket
		  // Constructor() -- From SocketCore
		  Super.Constructor
		  
		  // This DEMO sets the following from the UI 
		  // Please Set these However you wish BUT They MUST be Set
		  IAC_NAWS_TerminalHeight = mConvertDecToBin(Window1.TerminalHeightField.Text)
		  IAC_NAWS_TerminalWidth = mConvertDecToBin(Window1.TermWidthField.Text)
		  IAC_TerminalTypeValue = mConvertStringToBin(Uppercase(Window1.TerminalTypeMenu.Text))
		  IAC_TerminalSpeedValue = mConvertDecToBin(Window1.TerminalSpeedMenu.Text)
		  
		  // Gather Display Information from OS
		  OS_Display_Type = mGetDisplayShell
		  
		  // Convert Display from String to Binary
		  IAC_SO_XDisplayBinValue = mConvertStringToBin(OS_Display_Type)
		  
		  OS_USER_Type = mGetUserShell
		  
		  IAC_SO_NewEnvUserShellBinValue = mConvertStringToBin(OS_USER_Type)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function decodeTelnetData() As String
		  Dim Data_RegEx As RegEx
		  Dim Data_RegExMatch As RegExMatch
		  Dim Data_RegEx_HitText As  String
		  
		  Data_RegEx = New RegEx
		  Data_RegEx.Options.Greedy = True
		  Data_RegEx.Options.MatchEmpty = False
		  Data_RegEx.Options.StringBeginIsLineBegin = True
		  Data_RegEx.Options.StringEndIsLineEnd = True
		  Data_RegEx.Options.TreatTargetAsOneLine = False
		  Data_RegEx.Options.CaseSensitive = True
		  Data_RegEx.Options.DotMatchAll = False
		  
		  Data_RegEx.SearchPattern = "["+ChrB(32)+"-"+ChrB(127)+"]|"+ChrB(13)+ChrB(10)
		  Data_RegExMatch =  Data_RegEx.Search(ReceiveBuffer)
		  
		  Do
		    If Data_RegExMatch <> Nil Then
		      Data_RegEx_HitText = Data_RegEx_HitText + Data_RegExMatch.SubExpressionString(0)
		      Data_RegExMatch = Data_RegEx.Search
		    End If
		  Loop Until  Data_RegExMatch Is Nil
		  
		  if Data_RegEx_HitText = Chr(32)+Chr(32)+Chr(32) Then
		    Data_RegEx_HitText = ""
		  end if
		  
		  Return Data_RegEx_HitText
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Decode_IAC_Frames() As String
		  Dim IAC_RegEx As RegEx
		  Dim IAC_RegExMatch As RegExMatch
		  Dim IAC_RegEx_HitText As  String
		  
		  IAC_RegEx = New RegEx
		  IAC_RegEx.Options.Greedy = True
		  IAC_RegEx.Options.MatchEmpty = False
		  IAC_RegEx.Options.StringBeginIsLineBegin = True
		  IAC_RegEx.Options.StringEndIsLineEnd = True
		  IAC_RegEx.Options.TreatTargetAsOneLine = False
		  IAC_RegEx.Options.CaseSensitive = True
		  IAC_RegEx.Options.DotMatchAll = False
		  IAC_RegEx.SearchPattern = "("+ChrB(255)+ChrB(251)+").|" + "("+ChrB(255)+ChrB(252)+").|" + "("+ChrB(255)+ChrB(253)+").|" + "("+ChrB(255)+ChrB(254)+").|"
		  IAC_RegExMatch =  IAC_RegEx.Search(ReceiveBuffer)
		  
		  Do
		    If IAC_RegExMatch <> Nil Then
		      IAC_RegEx_HitText = IAC_RegEx_HitText + IAC_RegExMatch.SubExpressionString(0)
		      IAC_RegExMatch = IAC_RegEx.Search
		    End If
		    
		  Loop Until  IAC_RegExMatch Is Nil
		  
		  Return IAC_RegEx_HitText
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Decode_IAC_SO_Frames() As String
		  Dim IAC_SO_RegEx As RegEx
		  Dim IAC_SO_RegExMatch As RegExMatch
		  Dim IAC_SO_RegEx_HitText As  String
		  
		  IAC_SO_RegEx = New RegEx
		  IAC_SO_RegEx.Options.Greedy = True
		  IAC_SO_RegEx.Options.MatchEmpty = False
		  IAC_SO_RegEx.Options.StringBeginIsLineBegin = True
		  IAC_SO_RegEx.Options.StringEndIsLineEnd = True
		  IAC_SO_RegEx.Options.TreatTargetAsOneLine = False
		  IAC_SO_RegEx.Options.CaseSensitive = True
		  IAC_SO_RegEx.Options.DotMatchAll = False
		  IAC_SO_RegEx.SearchPattern = ChrB(255) + ChrB(250)+"...."
		  IAC_SO_RegExMatch =  IAC_SO_RegEx.Search(ReceiveBuffer)
		  
		  Do
		    If IAC_SO_RegExMatch <> Nil Then
		      IAC_SO_RegEx_HitText = IAC_SO_RegEx_HitText + IAC_SO_RegExMatch.SubExpressionString(0)
		      IAC_SO_RegExMatch = IAC_SO_RegEx.Search
		    End If
		    
		  Loop Until  IAC_SO_RegExMatch Is Nil
		  
		  Return IAC_SO_RegEx_HitText
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_ECHO_ResponseFrames(OptionVerb as String) As string
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    
		    If StateBit_ECHO_InMode = False Then
		      If UserEcho = True Then
		        Response = ChrB(cIAC) + ChrB(cDO) + ChrB(cECHO)
		        StateBit_ECHO_InMode = True
		        
		      Elseif UserEcho = False Then
		        Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cECHO)
		        StateBit_ECHO_InMode = False
		      End If
		      
		    Elseif StateBit_ECHO_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    If StateBit_ECHO_InMode = False Then
		      If UserEcho = True Then
		        Response = ChrB(cIAC) + ChrB(cWILL) + ChrB(cECHO)
		        StateBit_ECHO_InMode = True
		      Elseif UserEcho = False Then
		        Response = ChrB(cIAC) + ChrB(cWONT) + ChrB(cECHO)
		      End If
		    Elseif StateBit_ECHO_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Do not Reply as server does not want this mode
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Do not Reply as server does not want this mode
		  End If
		  
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_LineMode_ResponseFrames(OptionVerb as String) As string
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    Response = ChrB(cIAC)+ChrB(cDONT)+ChrB(cLineMode)
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    Response = ChrB(cIAC)+ChrB(cWONT)+ChrB(cLineMode)
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    
		  End If
		  
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_LogOut_ResponseFrames(OptionVerb as String) As string
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    
		    If StateBit_LogOut_InMode = False Then
		      If UserLogOut = True Then
		        Response = ChrB(cIAC) + ChrB(cDO) + ChrB(cLogOut)
		        StateBit_LogOut_InMode = True
		        
		      Elseif UserLogOut = False Then
		        Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cLogOut)
		        StateBit_LogOut_InMode = False
		      End If
		      
		    Elseif StateBit_LogOut_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    If StateBit_LogOut_InMode = False Then
		      If UserLogOut = True Then
		        Response = ChrB(cIAC) + ChrB(cWILL) + ChrB(cLogOut)
		        
		        // Server Sent a Do LogOut asking us to log out
		        // We reply with a Will or Confirmation of that requst
		        // We logout
		        mProcessLogOutRequest
		        StateBit_LogOut_InMode = False
		      Elseif UserLogOut = False Then
		        Response = ChrB(cIAC) + ChrB(cWONT) + ChrB(cLogOut)
		      End If
		      
		    Elseif StateBit_LogOut_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Do not Reply as server does not want this mode
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Do not Reply as server does not want this mode
		  End If
		  
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_NAWS_ResponseFrames(OptionVerb as String) As string
		  
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    // Client Sends Will Messages not Server - Do Nothing if we do receive a Will (Server sends DO messags)
		    if UserNegotiationAboutWindowSize = False Then
		      Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cNAWS)
		      StateBit_NAWS_InMode = False
		    end if
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Do nothing since the Server doesn not want NAWS
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    
		    if StateBit_NAWS_InMode = False Then
		      If UserNegotiationAboutWindowSize = True Then
		        Response = mSend_SO_NAWS_ResponseFrames(str(cNAWS))
		        StateBit_NAWS_InMode = True
		        
		      Elseif UserNegotiationAboutWindowSize = False Then
		        Response =  ChrB(cIAC) + ChrB(cWONT) + ChrB(cNAWS)
		        StateBit_NAWS_InMode = False
		      End If
		      
		    elseif StateBit_NAWS_InMode = True Then
		      // Do nothing since we are already in mode (Prevent Loops)
		    end if
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Do nothing since the Server doesn not want NAWS
		    
		  End If
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_NewEnvironment_ResponseFrames(OptionVerb as String) As string
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    
		    If StateBit_NewEnvironment_InMode = False Then
		      If UserNewEnvironment = True Then
		        // Server Will Send us IAC SO Frames
		        StateBit_NewEnvironment_InMode = True
		        
		      Elseif UserNewEnvironment = False Then
		        Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cNewEnvironment)
		      End If
		      
		    Elseif StateBit_NewEnvironment_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    If StateBit_NewEnvironment_InMode = False Then
		      If UserNewEnvironment = True Then
		        // Expecting the server to next send us a IAC 250 39 1 (Send) telling us to send our Environment variables
		        StateBit_NewEnvironment_InMode = True
		      Elseif UserNewEnvironment = False Then
		        Response = ChrB(cIAC) + ChrB(cWONT) + ChrB(cNewEnvironment)
		      End If
		    Elseif StateBit_NewEnvironment_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		    
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Do not Reply as server does not want this mode
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Do not Reply as server does not want this mode
		  End If
		  
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_RemoteFlowControl_ResponseFrames(OptionVerb as String) As String
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    
		    If StateBit_RemoteFlowControl_InMode = False Then
		      If UserRemoteFlowControl = True Then
		        Response = mSend_SO_RemoteFlowControl_ResponseFrames(str(cRemoteFlowControlOption))
		        StateBit_RemoteFlowControl_InMode = True
		        
		      Elseif UserRemoteFlowControl = False Then
		        Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cRemoteFlowControlOption)
		        StateBit_RemoteFlowControl_InMode = False
		      End If
		      
		    Elseif StateBit_RemoteFlowControl_InMode = True Then
		      // already in Mode ignore for Loop Prevention
		    End If
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Do nothing since the Server doesn not want RemoteFlowControl
		    StateBit_RemoteFlowControl_InMode = False
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    If StateBit_RemoteFlowControl_InMode = False Then
		      If UserRemoteFlowControl = True Then
		        Response = mSend_SO_RemoteFlowControl_ResponseFrames(str(cRemoteFlowControlOption))
		        StateBit_RemoteFlowControl_InMode = True
		        
		      Elseif UserRemoteFlowControl = False Then
		        Response = ChrB(cIAC) + ChrB(cWONT) + ChrB(cRemoteFlowControlOption)
		        StateBit_RemoteFlowControl_InMode = False
		      End If
		      
		    Elseif StateBit_RemoteFlowControl_InMode = True Then
		      // Ignore since we are In Mode already
		    End If
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Do nothing since the Server doesn not want RemoteFlowControl
		    
		  End If
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_SuppressGoAhead_ResponseFrames(OptionVerb as String) As String
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    // Confirmation ACK from Our Request to Use SGA during Startup
		    // Do Not Ack the Ack :)
		    
		    If StateBit_SuppressGoAhead_InMode = False Then
		      If UserSuppressGoAhead = True Then
		        Response = ChrB(cIAC) + ChrB(cDO) + ChrB(cSuppressGoAheadOption)
		        StateBit_SuppressGoAhead_InMode = True
		      Elseif UserSuppressGoAhead = False Then
		        Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cSuppressGoAheadOption)
		        StateBit_SuppressGoAhead_InMode = False
		      End If
		      
		    Elseif StateBit_SuppressGoAhead_InMode = True Then
		      // already in Mode ignore for Loop Prevention
		    End If
		    
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    
		    If StateBit_SuppressGoAhead_InMode = False Then
		      Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cSuppressGoAheadOption)
		      
		    Elseif StateBit_SuppressGoAhead_InMode = True Then
		      // already in Mode ignore for Loop Prevention
		    End If
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    If StateBit_SuppressGoAhead_InMode = False Then
		      If UserSuppressGoAhead = True Then
		        Response = ChrB(cIAC) + ChrB(cWILL) + ChrB(cSuppressGoAheadOption)
		        StateBit_SuppressGoAhead_InMode = True
		        
		      Elseif UserSuppressGoAhead = False Then
		        Response = ChrB(cIAC) + ChrB(cWONT) + ChrB(cSuppressGoAheadOption)
		      End If
		      
		    Elseif StateBit_SuppressGoAhead_InMode = True Then
		      // Ignore since we are In Mode already
		    End If
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    Response = ChrB(cIAC) + ChrB(cWONT) + ChrB(cSuppressGoAheadOption)
		    
		    
		    
		  End If
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_TerminalSpeed_ResponseFrames(OptionVerb as String) As string
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    If UserTerminalSpeed = True Then
		      // Do Nothing since if we should Send Will and receive Do
		      
		    elseif UserTerminalSpeed = False then
		      Response =  ChrB(cIAC) + ChrB(cDONT) + ChrB(cTerminalSpeed)
		      StateBit_TerminalSpeed_InMode = False
		    end if
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Do nothing as Server does not want to Negotiate
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    
		    if StateBit_TerminalSpeed_InMode = False Then
		      If UserTerminalSpeed = True Then
		        // Server will send us Terminal Speed Control SO
		        StateBit_TerminalSpeed_InMode = True
		        
		      Elseif UserTerminalSpeed = False Then
		        Response =  ChrB(cIAC) + ChrB(cWONT) + ChrB(cTerminalSpeed)
		        StateBit_TerminalSpeed_InMode = False
		      End If
		      
		    elseif StateBit_TerminalSpeed_InMode = True Then
		      // already in Mode ignore for Loop Prevention
		    end if
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Do nothing as Server does not want to Negotiate
		    
		  End If
		  
		  Return Response
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_TerminalType_ResponseFrames(OptionVerb as String) As string
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Don't do anything as the server does not want to negotiate
		    StateBit_TerminalType_InMode = False
		    
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    
		    if StateBit_TerminalType_InMode = False Then
		      If UserTerminalType = True Then
		        // Server will send us Terminal Speed Control SO
		        StateBit_TerminalType_InMode = True
		        
		      Elseif UserTerminalType = False Then
		        Response =  ChrB(cIAC) + ChrB(cWONT) + ChrB(cTerminalTypeOption)
		        StateBit_TerminalType_InMode = False
		      End If
		      
		    elseif StateBit_TerminalType_InMode = True Then
		      // already in Mode ignore for Loop Prevention
		    end if
		    
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Don't do anything as the server does not want to negotiate
		    StateBit_TerminalType_InMode = False
		    
		  End If
		  
		  Return Response
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_TimingMark_ResponseFrames(OptionVerb as String) As string
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    
		    If StateBit_TimingMark_InMode = False Then
		      If UserTimingMark = True Then
		        StateBit_TimingMark_InMode = True
		        
		      Elseif UserTimingMark = False Then
		        Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cTimingMark)
		      End If
		      
		    Elseif StateBit_TimingMark_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    If StateBit_TimingMark_InMode = False Then
		      If UserTimingMark = True Then
		        Response = ChrB(cIAC) + ChrB(cWILL) + ChrB(cTimingMark)
		        StateBit_TimingMark_InMode = True
		      Elseif UserTimingMark = False Then
		        Response = ChrB(cIAC) + ChrB(cWONT) + ChrB(cTimingMark)
		      End If
		    Elseif StateBit_TimingMark_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		    
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Do not Reply as server does not want this mode
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Do not Reply as server does not want this mode
		  End If
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mBuild_XDisplay_ResponseFrames(OptionVerb as String) As string
		  Dim Response As String
		  
		  If OptionVerb = Str(cWILL) Then
		    
		    If StateBit_XDisplay_InMode = False Then
		      If UserXDisplay = True Then
		        // Server Will Send us IAC SO Frames Now
		        StateBit_XDisplay_InMode = True
		        
		      Elseif UserXDisplay = False Then
		        Response = ChrB(cIAC) + ChrB(cDONT) + ChrB(cXDisplay)
		      End If
		      
		    Elseif StateBit_XDisplay_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		  Elseif OptionVerb = Str(cDO)  Then
		    If StateBit_XDisplay_InMode = False Then
		      If UserXDisplay = True Then
		        // Server is Allowing Us to Send Our Display
		        
		        StateBit_XDisplay_InMode = True
		      Elseif UserTimingMark = False Then
		        Response = ChrB(cIAC) + ChrB(cWONT) + ChrB(cXDisplay)
		      End If
		    Elseif StateBit_XDisplay_InMode = True Then
		      // Do Nothing as we are in Mode already
		    End If
		    
		    
		    
		  Elseif OptionVerb = Str(cWONT) Then
		    // Do not Reply as server does not want this mode
		    
		  Elseif OptionVerb = Str(cDONT) Then
		    // Do not Reply as server does not want this mode
		  End If
		  
		  Return Response
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mConvertDecToBin(InputString as String) As String
		  // Convert Input String from Decimal into ASCII Binary
		  Dim Process as String
		  Process = ChrB(Val(InputString))
		  Return Process
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mConvertStringToBin(InputString as String) As String
		  // Convert Input String from Decimal into ASCII Binary
		  Dim Process As String
		  Dim TmpLen As Integer
		  Dim BuildString As String
		  Dim StringToBinaryArray() As String
		  
		  TmpLen = InputString.Len
		  For q As Integer = 0 To TmpLen-1
		    Process =  Str(AscB(InputString.Mid(q+1,1)))
		    StringToBinaryArray.Append Process
		  Next q
		  
		  For ii As Integer = 0 To UBound(StringToBinaryArray)
		    
		     BuildString = BuildString + ChrB(CDbl(StringToBinaryArray(ii)))
		    
		  Next ii
		  
		  Return BuildString
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mDetectPasswordLoginStyle(ReceivedTELNETdata as String) As Boolean
		  // Auto Detect Which Prompt Style the remote side is using
		  Dim DetectPass_RegEx as RegEx
		  Dim DetectPass_RegExMatch as RegExMatch
		  Dim DetectPass_HitText as String
		  
		  
		  DetectPass_RegEx = New RegEx
		  DetectPass_RegEx.Options.caseSensitive = False
		  DetectPass_RegEx.Options.Greedy = True
		  DetectPass_RegEx.Options.MatchEmpty = True
		  DetectPass_RegEx.Options.DotMatchAll = True
		  DetectPass_RegEx.Options.StringBeginIsLineBegin = True
		  DetectPass_RegEx.Options.StringEndIsLineEnd = True
		  DetectPass_RegEx.Options.TreatTargetAsOneLine = False
		  DetectPass_RegEx.SearchPattern = "pass|password"
		  
		  DetectPass_RegExMatch = DetectPass_RegEx.Search(ReceivedTELNETdata)
		  if DetectPass_RegExMatch <> nil then
		    DetectPass_HitText = DetectPass_RegExMatch.SubExpressionString(0)
		  end if
		  
		  
		  if DetectPass_HitText <> "" Then
		    RunAutoLoginDetection = 1
		    Return True
		  elseif DetectPass_HitText = "" then
		    RunAutoLoginDetection = 0
		    Return False
		  End if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mDetectUsernameLoginStyle(ReceivedTELNETdata as String) As Boolean
		  // Auto Detect Which Prompt Style the remote side is using
		  Dim DetectUnamePass_RegEx as RegEx
		  Dim DetectUnamePass_RegExMatch as RegExMatch
		  Dim DetectUnamePass_HitText as String
		  
		  
		  DetectUnamePass_RegEx = New RegEx
		  DetectUnamePass_RegEx.Options.caseSensitive = False
		  DetectUnamePass_RegEx.Options.Greedy = True
		  DetectUnamePass_RegEx.Options.MatchEmpty = True
		  DetectUnamePass_RegEx.Options.DotMatchAll = True
		  DetectUnamePass_RegEx.Options.StringBeginIsLineBegin = True
		  DetectUnamePass_RegEx.Options.StringEndIsLineEnd = True
		  DetectUnamePass_RegEx.Options.TreatTargetAsOneLine = False
		  DetectUnamePass_RegEx.SearchPattern = "(?:user)|(?:username)|(?:login)"
		  
		  DetectUnamePass_RegExMatch = DetectUnamePass_RegEx.Search(ReceivedTELNETdata)
		  if DetectUnamePass_RegExMatch <> nil then
		    DetectUnamePass_HitText = DetectUnamePass_RegExMatch.SubExpressionString(0)
		  end if
		  
		  if DetectUnamePass_HitText <> "" Then
		    RunAutoLoginDetection = 1
		    Return True
		  elseif DetectUnamePass_HitText = "" then
		    RunAutoLoginDetection = 0
		    Return False
		  End if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mFlushIAC_Output_Queue()
		  Dim y as Integer
		  For y = 0 To UBound(IAC_Response_OutputQueue)
		    Me.Write IAC_Response_OutputQueue(y)
		    if y =  IAC_OutputQ_Marker then
		      // Flush the socket half way through the processing to avoid too much latency
		      me.Flush
		    end if
		  next y
		  
		  Me.Flush // Final Flush
		  
		  // Now Empty the Output Queue since we are through
		  Redim IAC_Response_OutputQueue(-1)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub mFlushIAC_SO_OutputQueue()
		  Dim y as integer
		  For y = 0 To UBound(IAC_SO_Response_OutputQueue)
		    Me.Write IAC_SO_Response_OutputQueue(y)
		    if y =  IAC_SO_OutputQ_Marker then
		      // Flush the socket half way through the processing to avoid too much latency
		      me.Flush
		    end if
		  Next y
		  
		  Me.Flush // Final Flush
		  
		  // Now Empty the Output Queue since we are through
		  Redim IAC_SO_Response_OutputQueue(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mGetDisplayShell() As String
		  // Get Display from Shell
		  Dim s As Shell
		  s = New Shell
		  
		  
		  #if TargetMacOS or TargetLinux Then
		    
		    s.Execute("echo $DISPLAY")
		    
		  #elseif TargetWin32 Then
		    
		  #endif
		  
		  
		  Dim TrimStringLen as Integer = Len(S.Result)
		  
		  Dim TrimString as String = Left(s.Result, TrimStringLen-1)
		  
		  Return TrimString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mGetUserShell() As String
		  // Get Display from Shell
		  Dim s As Shell
		  s = New Shell
		  
		  
		  #if TargetMacOS or TargetLinux Then
		    
		    s.Execute("echo $USER")
		    
		    Dim TrimStringLen as Integer = Len(S.Result)
		    Dim TrimString as String = Left(s.Result, TrimStringLen-1)
		    
		  #elseif TargetWin32 Then
		    
		    s.Execute("set username")
		    
		    Dim TrimString as String = Left(s.Result, 9)
		    
		  #endif
		  
		  
		  
		  Return TrimString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mLiveScreenScroll()
		  ScreenTextLen = Window1.ScreenText.Text.Len
		  Window1.ScreenText.ScrollPosition = (ScreenTextLen)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mProcessIAC_OutputResponse()
		  Dim Build_Response As String 
		  Dim OptionVerb As String
		  Dim i,iii as integer
		  Dim CountOurFields As Integer
		  Dim ExtractedDecimalMessage As String
		  
		  // Extract from Input Queue, Convert to Binary, and Submit to Output Queue
		  For i = 0 To UBound(IAC_InputQueue)
		    
		    CountOurFields = IAC_InputQueue(i).CountFields(",") ' Figure out how many fields of messages we have
		    
		    // Reset the OptionVerb
		    OptionVerb = ""
		    
		    For iii  = 1 To CountOurFields
		      ExtractedDecimalMessage =  IAC_InputQueue(i).NthField(",",iii)
		      
		      If ExtractedDecimalMessage = Str(cIAC) Then
		        
		      Elseif ExtractedDecimalMessage = Str(cWILL) Then
		        // Receive an IAC WILL From Server
		        OptionVerb = Str(cWILL)
		        
		        
		      Elseif ExtractedDecimalMessage = Str(cWONT) Then
		        // Receive an IAC WONT From Server
		        OptionVerb = Str(cWONT)
		        
		        
		      Elseif ExtractedDecimalMessage = Str(cDO) Then
		        // Receive an IAC DO From Server
		        OptionVerb = Str(cDO)
		        
		        
		      Elseif ExtractedDecimalMessage = Str(cDONT) Then
		        // Receive an IAC DONT From Server
		        OptionVerb = Str(cDONT)
		        
		        
		      Else 
		        
		        If ExtractedDecimalMessage = Str(cECHO) Then
		          Build_Response = mBuild_ECHO_ResponseFrames(OptionVerb)
		        End If
		        
		        If ExtractedDecimalMessage = Str(cSuppressGoAheadOption) Then
		          Build_Response = mBuild_SuppressGoAhead_ResponseFrames(OptionVerb)
		        End If
		         
		        if ExtractedDecimalMessage = Str(cNAWS) Then
		          Build_Response = mBuild_NAWS_ResponseFrames(OptionVerb)
		        end if
		        ' 
		        if ExtractedDecimalMessage = Str(cRemoteFlowControlOption) Then
		          Build_Response = mBuild_RemoteFlowControl_ResponseFrames(OptionVerb)
		        end if
		        
		        if ExtractedDecimalMessage = Str(cTerminalSpeed) Then
		          Build_Response = mBuild_TerminalSpeed_ResponseFrames(OptionVerb)
		        end if
		        
		        if ExtractedDecimalMessage = Str(cAuthenticate) Then
		          Build_Response = authenticateResponseFrames(OptionVerb)
		        end if
		        
		        if ExtractedDecimalMessage = Str(cLineMode) Then
		          Build_Response = mBuild_LineMode_ResponseFrames(OptionVerb)
		        End If
		        
		        if ExtractedDecimalMessage = Str(cXDisplay) Then
		          Build_Response = mBuild_XDisplay_ResponseFrames(OptionVerb)
		        end if
		        
		        if ExtractedDecimalMessage = Str(cNewEnvironment) Then
		          Build_Response = mBuild_NewEnvironment_ResponseFrames(OptionVerb)
		        end if
		        
		        if ExtractedDecimalMessage = Str(cLogOut) Then
		          Build_Response = mBuild_LogOut_ResponseFrames(OptionVerb)
		        end if
		        
		        if ExtractedDecimalMessage = Str(cTimingMark) Then
		          Build_Response = mBuild_TimingMark_ResponseFrames(OptionVerb)
		        end if
		        
		      end if
		      
		    Next iii
		    
		    // Add Processed frame into the IAC Output Queue
		    IAC_Response_OutputQueue.Append(Build_Response)
		    
		  Next i
		  
		  IAC_OutputQ_Marker = (IAC_InputQueue.Ubound+1)/ 2
		  // Empty the Queue 
		  Redim IAC_InputQueue(-1)
		  
		  // Flush IAC Output Queue
		  mFlushIAC_Output_Queue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mProcessIAC_SO_OutputResponse()
		  Dim Build_Response As String
		  Dim FirstExtracted As String 
		  Dim SecondExtracted As String
		  Dim ThirdExtracted As String
		  Dim FourthExtracted As String
		  Dim i as integer
		  
		  // Extract from Input Queue, Convert to Binary, and Submit to Output Queue
		  For i  = 0 To UBound(IAC_SO_InputQueue)
		    
		    FirstExtracted  =  IAC_SO_InputQueue(i).NthField(",",1)
		    SecondExtracted  =  IAC_SO_InputQueue(i).NthField(",",2)
		    ThirdExtracted =  IAC_SO_InputQueue(i).NthField(",",3)
		    FourthExtracted =  IAC_SO_InputQueue(i).NthField(",",4)
		    
		    If FirstExtracted = Str(255) AND SecondExtracted = Str(250) AND ThirdExtracted = Str(24) Then
		      Build_Response = mSend_SO_TerminalType_ResponseFrames(FourthExtracted)
		      
		    Elseif FirstExtracted = Str(255) AND SecondExtracted = Str(250) AND ThirdExtracted = Str(32)Then
		      Build_Response = mSend_SO_TerminalSpeed_ResponseFrames(FourthExtracted)
		      
		    Elseif FirstExtracted = Str(255) AND SecondExtracted = Str(250) AND ThirdExtracted = Str(39) Then
		      Build_Response = mSend_SO_NewEnvironment_ResponseFrames(FourthExtracted)
		      
		    Elseif FirstExtracted = Str(255) AND SecondExtracted = Str(250) AND ThirdExtracted = Str(35)Then
		      Build_Response = mSend_SO_XDisplay_ResponseFrames(FourthExtracted)
		      
		    End if
		    
		    // Add Processed frame into the IAC Output Queue
		    IAC_SO_Response_OutputQueue.Append(Build_Response)
		    
		  Next i
		  
		  IAC_SO_OutputQ_Marker = (IAC_SO_InputQueue.Ubound+1)/ 2
		  // Empty the Queue
		  Redim IAC_SO_InputQueue(-1)
		  
		  // Flush IAC SO Output Queue
		  mFlushIAC_SO_OutputQueue
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mProcessLogOutRequest()
		  Me.Disconnect
		  Me.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub mSendInitial_IAC_Offer()
		  ' // Send Initial Option Capabilities based on User Selection from the GUI Checkboxes (Window1)
		  
		  if UserEcho = True Then
		    write Initial_DoEcho
		  elseif UserEcho = False Then
		    write Initial_DontEcho
		  end if
		  
		  If UserSuppressGoAhead = True Then
		    write Initial_DoSuppressGoAhead
		  Elseif UserSuppressGoAhead = False Then
		    write Initial_DontSuppressGoAhead
		  End If 
		  
		   if UserNegotiationAboutWindowSize = True Then
		    Write Initial_WIllNegotiationAboutWindowSize
		  elseif UserNegotiationAboutWindowSize = False Then
		    Write Initial_DontNegotiationAboutWindowSize
		  end if
		  
		  If UserTerminalType = True Then
		    write Initial_WillTerminalType
		  Elseif UserTerminalType = False Then
		    write Initial_WontTerminalType
		  End If
		  
		  If UserRemoteFlowControl = True Then
		    write Initial_WillRemoteFlowControl
		  Elseif UserRemoteFlowControl = False Then
		    write Initial_WontRemoteFlowControl
		  End If
		  
		  if UserTerminalSpeed = True then
		    Write Initial_WillTerminalSpeed
		  elseif UserTerminalSpeed = False then
		    write Initial_WontTerminalSpeed
		  end if
		  
		  
		  if UserTimingMark = True then
		    Write Initial_DoTimingMark
		  elseif UserTimingMark = False then
		    write Initial_DontTimingMark
		  end if
		  
		  if UserNewEnvironment = True then
		    // We are willing to Send Display Data
		    Write Initial_WillNewEnvironment
		  elseif UserNewEnvironment = False then
		    write Initial_WontNewEnvironment
		  end if
		  
		  if UserXDisplay = True then
		    // We are willing to Send Display Data
		    Write Initial_WillXDIsplay
		  elseif UserXDisplay = False then
		    write Initial_DontXDisplay
		  end if
		  
		  // Options We Also Do Not Support
		  write Initial_WontAuthenticateOption
		  write Initial_WontLineMode
		  write Initial_DontStatus
		  
		  
		  Self.Flush
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mSendPasswordCredentials()
		  me.Write EndOfLine
		  me.Flush
		  me.Write TELNETPassword + EndOfLine
		  Me.Flush
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mSendUsernamePasswordCredentials()
		  me.Write EndOfLine
		  me.Flush
		  me.Write TELNETUsername + EndOfLine
		  me.Flush
		  me.Write TELNETPassword + EndOfLine
		  Me.Flush
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mSend_SO_NAWS_ResponseFrames(OptionVerb as String) As String
		  Dim SOResponse As String
		  
		  SOResponse = ChrB(cIAC) + ChrB(cSubOptionBegin) + ChrB(cNAWS) + ChrB(cNULL) + IAC_NAWS_TerminalWidth + ChrB(cNULL) + IAC_NAWS_TerminalHeight  + ChrB(cIAC) + ChrB(cSubOptionEnd)
		  
		  Return SOResponse
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mSend_SO_NewEnvironment_ResponseFrames(OptionVerb as String) As String
		  Dim SOResponse As String
		  
		  SOResponse = ChrB(cIAC) + ChrB(cSubOptionBegin) + ChrB(cNewEnvironment) + ChrB(cNewEnvironmentIS) + ChrB(cNewEnvironmentVAR)+ NewEnvDISPLAYInBinary + ChrB(cNewEnvironmentVALUE) + IAC_SO_XDisplayBinValue + ChrB(cNewEnvironmentVAR) + NewEnvUSERInBinary + ChrB(cNewEnvironmentVALUE) + IAC_SO_NewEnvUserShellBinValue + ChrB(cIAC) + ChrB(cSubOptionEnd)
		  
		  Return SOResponse
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mSend_SO_RemoteFlowControl_ResponseFrames(OptionVerb as String) As String
		  Dim SOResponse As String
		  
		  SOResponse = ChrB(cIAC) + ChrB(cSubOptionBegin) + ChrB(cRemoteFlowControlOption) + ChrB(IAC_RemoteFlowControlValue) + ChrB(cIAC) + ChrB(cSubOptionEnd)
		  
		  
		  Return SOResponse
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mSend_SO_TerminalSpeed_ResponseFrames(OptionVerb as String) As String
		  Dim SOResponse As String
		  
		  
		  SOResponse = ChrB(cIAC) + ChrB(cSubOptionBegin) + ChrB(cTerminalSpeed) + Str(IAC_TerminalSpeedValue) + ChrB(39) + Str(IAC_TerminalSpeedValue) + ChrB(cIAC) + ChrB(cSubOptionEnd)
		  
		  Return SOResponse
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mSend_SO_TerminalType_ResponseFrames(OptionVerb as String) As String
		  Dim SOResponse As String
		  
		  SOResponse = ChrB(cIAC) + ChrB(cSubOptionBegin) + ChrB(cTerminalTypeOption) + ChrB(cHereIsMyTerminalType) +  IAC_TerminalTypeValue + ChrB(cIAC) + ChrB(cSubOptionEnd)
		  
		  Return SOResponse
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mSend_SO_XDisplay_ResponseFrames(OptionVerb as String) As String
		  Dim SOResponse As String
		  
		  SOResponse = ChrB(cIAC) + ChrB(cSubOptionBegin) + ChrB(cXDisplay) + ChrB(cHereIsMyXDisplayLocation) + IAC_SO_XDisplayBinValue  + ChrB(cIAC) + ChrB(cSubOptionEnd)
		  
		  Return SOResponse
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ReceiveTelnetData()
		  // Process the received Data Input Queue
		  Dim ReceivedTelnetData  As String
		  Dim i as integer
		  
		  // Grab all of the TELNET Data in the Input Queue
		  For i = 0 To UBound(Data_InputQueue)
		    ReceivedTelnetData = ReceivedTelnetData + Data_InputQueue(i)
		  Next i
		  // Flush Input Queue since we have extracted our TELNET Data
		  redim Data_InputQueue(-1)
		  
		  
		  // Implement Auto Login Prompt Discovery and Auto Login
		  Select Case RunAutoLoginDetection
		  Case 0
		    // This is the First Time through - Detect Login Style
		    UsernamePasswordLoginStyle = mDetectUsernameLoginStyle(ReceivedTelnetData)
		    
		    if UsernamePasswordLoginStyle = False Then
		      // We did not detect username/Password style --- Now Try Password Only Style
		      PasswordLoginStyle = mDetectPasswordLoginStyle(ReceivedTelnetData)
		      
		      if PasswordLoginStyle = true then
		        // Detected Password Only Style -- Now Send the correct Credentials Automatically
		        if AutoLoginServiceEnabled = True Then
		          mSendPasswordCredentials
		        elseif AutoLoginServiceEnabled = False Then
		          // Well, We detected the Login Style, but the programmer didn't pass in the Username/Password to the TELNET method
		        end if
		        
		      elseif PasswordLoginStyle = False Then
		        // Well, we tried and there appears to be no Authentication here. Keep going :)
		      end if
		      
		    elseif UsernamePasswordLoginStyle = true Then
		      // Hooray! We have Detected a Username And Password Style -- Now Send credentials
		      if AutoLoginServiceEnabled = True Then
		        mSendUsernamePasswordCredentials
		      elseif AutoLoginServiceEnabled = False Then
		        // Well, We detected the Login Style, but the programmer didn't pass in the Username/Password to the TELNET method
		      end if
		      
		    end if
		    
		  Case 1
		    // Do nothing as we don't want to Detect login style Everytime we receive any TELNET Data
		  End Select
		  
		  RaiseEvent DataAvailable(ReceivedTelnetData)
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event DataAvailable(responseStr as String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error(ErrorCodeInt as Integer, optional ErrorCodeStr as String)
	#tag EndHook


	#tag Property, Flags = &h0
		AutoLoginServiceEnabled As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ConnectPort As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			IAC_TerminalTypeValue
		#tag EndNote
		Data_InputQueue() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IAC_InputQueue() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IAC_NAWS_TerminalHeight As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IAC_NAWS_TerminalWidth As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_OutputQ_Marker As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IAC_RemoteFlowControlValue As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_Response_OutputQueue() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_ServiceValue As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IAC_SO_InputQueue() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_SO_NewEnvUserShellBinValue As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_SO_OutputQ_Marker As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_SO_Response_OutputQueue() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_SO_XDisplayBinValue As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_SubOptionBegin As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_SubOptionBeginServiceValue As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_SubOptionEnd As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IAC_TerminalSpeedValue As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IAC_TerminalTypeValue As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IAC_Verb As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC DO ECHO
			  ' The sender of this command REQUESTS that the receiver of this command begin echoing
			  ' Or confirms that the receiver of this command is expected to echo data characters it receives over the TELNET connection back to the sender.
			  
			  return ChrB(cIAC)+ChrB(cDO)+ChrB(cECHO)
			End Get
		#tag EndGetter
		Initial_DoEcho As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC DON'T ECHO
			  ' The sender of this command DEMANDS the receiver of this command stop, or not start, echoing data characters it receives over the 
			  ' TELNET connection.
			  
			  return ChrB(cIAC)+ChrB(cDONT)+ChrB(cECHO)
			End Get
		#tag EndGetter
		Initial_DontEcho As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC WILL NAWS
			  ' Sent by the Telnet client to suggest that NAWS be used.
			  
			  Return ChrB(cIAC)+ChrB(cDONT)+ChrB(cNAWS)
			End Get
		#tag EndGetter
		Initial_DontNegotiationAboutWindowSize As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC DON'T STATUS
			  ' Sender refuses to carry on any further discussion of the current
			  ' status of options.
			  
			  return ChrB(cIAC)+ChrB(cDONT)+ChrB(cStatus)
			End Get
		#tag EndGetter
		Initial_DontStatus As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC DON'T SUPPRESSS-GO-AHEAD
			  ' The sender of this command demands that the receiver of the
			  ' command start or continue transmitting GAs when transmitting data.
			  
			  Return ChrB(cIAC)+ChrB(cDONT)+ChrB(cSuppressGoAheadOption)
			End Get
		#tag EndGetter
		Initial_DontSuppressGoAhead As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return ChrB(cIAC)+ChrB(cDONT)+ChrB(cTimingMark)
			End Get
		#tag EndGetter
		Initial_DontTimingMark As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return ChrB(cIAC)+ChrB(cDONT)+ChrB(cXDisplay)
			End Get
		#tag EndGetter
		Initial_DontXDisplay As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC DO STATUS
			  ' Sender of DO wishes to be able to send requests for status-of-options
			  ' information, or confirms that he is willing to send such requests.
			  
			  return ChrB(cIAC)+ChrB(cDO)+ChrB(cStatus)
			End Get
		#tag EndGetter
		Initial_DoStatus As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC DO SUPPRESS-GO-AHEAD
			  ' The sender of this commannd requests that the sender of data start
			  ' suppressing GA when transmitting data, or the sender of this
			  ' command confirms that the sender of data is expected to suppress
			  ' transmission of GAs.
			  
			  return ChrB(cIAC)+ChrB(cDO)+ChrB(cSuppressGoAheadOption)
			End Get
		#tag EndGetter
		Initial_DoSuppressGoAhead As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return ChrB(cIAC)+ChrB(cDO)+ChrB(cTimingMark)
			End Get
		#tag EndGetter
		Initial_DoTimingMark As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC WILL NAWS
			  ' Sent by the Telnet client to suggest that NAWS be used.
			  
			  Return ChrB(cIAC)+ChrB(cWILL)+ChrB(cNAWS)
			End Get
		#tag EndGetter
		Initial_WIllNegotiationAboutWindowSize As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC DON'T STATUS
			  ' Sender refuses to carry on any further discussion of the current
			  ' status of options.
			  
			  return ChrB(cIAC)+ChrB(cWILL)+ChrB(cNewEnvironment)
			End Get
		#tag EndGetter
		Initial_WillNewEnvironment As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //IAC WILL TOGGLE-FLOW-CONTROL
			  ' Sender is willing to enable and disable flow control upon command.
			  
			  return ChrB(cIAC)+ChrB(cWILL)+ChrB(cRemoteFlowControlOption)
			End Get
		#tag EndGetter
		Initial_WillRemoteFlowControl As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC WILL TERMINAL-SPEED
			  ' Sender is willing to send terminal type information in a subsequent sub-negotiation
			  
			  Return ChrB(cIAC)+ChrB(cWILL)+ChrB(cTerminalSpeed)
			End Get
		#tag EndGetter
		Initial_WillTerminalSpeed As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC WILL TERMINAL-TYPE
			  ' Sender is willing to send terminal type information in a subsequent sub-negotiation
			  
			  Return ChrB(cIAC)+ChrB(cWILL)+ChrB(cTerminalTypeOption)
			End Get
		#tag EndGetter
		Initial_WillTerminalType As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC WILL TERMINAL-TYPE
			  ' Sender is willing to send terminal type information in a subsequent sub-negotiation
			  
			  Return ChrB(cIAC)+ChrB(cWILL)+ChrB(cXDisplay)
			End Get
		#tag EndGetter
		Initial_WillXDisplay As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //IAC WONT AUTHENTICATION
			  ' The client side of the connection sends this command to indicate that it refuses to send or receive authentication information;
			  ' The server side must send this command if it receives a DO AUTHENTICATION command.
			  
			  Return ChrB(cIAC)+ChrB(cWONT)+ChrB(cAuthenticate)
			  
			End Get
		#tag EndGetter
		Initial_WontAuthenticateOption As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC DO SUPPRESS-GO-AHEAD
			  ' The sender of this commannd requests that the sender of data start
			  ' suppressing GA when transmitting data, or the sender of this
			  ' command confirms that the sender of data is expected to suppress
			  ' transmission of GAs.
			  
			  return ChrB(cIAC)+ChrB(cWONT)+ChrB(cLineMode)
			End Get
		#tag EndGetter
		Initial_WontLineMode As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC WON'T NAWS
			  ' Sent by the Telnet client to refuse to use NAWS.
			  
			  Return ChrB(cIAC)+ChrB(cWONT)+ChrB(cNAWS)
			End Get
		#tag EndGetter
		Initial_WontNegotiationAboutWindowSize As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC DON'T STATUS
			  ' Sender refuses to carry on any further discussion of the current
			  ' status of options.
			  
			  return ChrB(cIAC)+ChrB(cDONT)+ChrB(cNewEnvironment)
			End Get
		#tag EndGetter
		Initial_WontNewEnvironment As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC WONT TOGGLE-FLOW-CONTROL
			  
			  ' Sender refuses to enable and disable flow control.  Nothing is implied about whether sender does or does not use flow control.
			  ' It is simply unwilling to enable and disable it using this protocol.
			  
			  return ChrB(cIAC)+ChrB(cWONT)+ChrB(cRemoteFlowControlOption)
			End Get
		#tag EndGetter
		Initial_WontRemoteFlowControl As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC WILL TERMINAL-SPEED
			  ' Sender is willing to send terminal type information in a subsequent sub-negotiation
			  
			  Return ChrB(cIAC)+ChrB(cWONT)+ChrB(cTerminalSpeed)
			End Get
		#tag EndGetter
		Initial_WontTerminalSpeed As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // IAC WON'T TERMINAL-TYPE
			  ' Sender refuses to send terminal type information
			  
			  Return ChrB(cIAC)+ChrB(cWONT)+ChrB(cTerminalTypeOption)
			End Get
		#tag EndGetter
		Initial_WontTerminalType As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return ChrB(cIAC)+ChrB(cWONT)+ChrB(cXDisplay)
			End Get
		#tag EndGetter
		Initial_WontXDisplay As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mConnectionStatus As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Converts DISPLAY to Binary
			  
			  return ChrB(68) + ChrB(73) + ChrB(83) + ChrB(80) + ChrB(76) + ChrB(65) + ChrB(89)
			End Get
		#tag EndGetter
		NewEnvDISPLAYInBinary As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Converts USER to binary
			  
			  return ChrB(85) + ChrB(83) + ChrB(69) + ChrB(82)
			End Get
		#tag EndGetter
		NewEnvUSERInBinary As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		OS_Display_Type As String
	#tag EndProperty

	#tag Property, Flags = &h0
		OS_USER_Type As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PasswordLoginStyle As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ReceiveBuffer As String
	#tag EndProperty

	#tag Property, Flags = &h0
		RunAutoLoginDetection As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		ScreenTextLen As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_ECHO_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_LogOut_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_NAWS_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_NewEnvironment_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_RemoteFlowControl_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_SuppressGoAhead_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_TerminalSpeed_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_TerminalType_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_TimingMark_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StateBit_XDisplay_InMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		TELNETPassword As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TELNETUsername As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TerminalHeight As String = "80"
	#tag EndProperty

	#tag Property, Flags = &h0
		TerminalSpeed As String = "9600"
	#tag EndProperty

	#tag Property, Flags = &h0
		TerminalType As String = "Xterm"
	#tag EndProperty

	#tag Property, Flags = &h0
		TerminalWidth As String = "120"
	#tag EndProperty

	#tag Property, Flags = &h0
		TrackCursorPos As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		UserEcho As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		UserLogOut As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		UsernamePasswordLoginStyle As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		UserNegotiationAboutWindowSize As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		UserNewEnvironment As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		UserRemoteFlowControl As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		UserSuppressGoAhead As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		UserTerminalSpeed As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		UserTerminalType As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		UserTimingMark As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		UserXDisplay As Boolean = False
	#tag EndProperty


	#tag Constant, Name = cAuthenticate, Type = Double, Dynamic = False, Default = \"37", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cDO, Type = Double, Dynamic = False, Default = \"253", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cDONT, Type = Double, Dynamic = False, Default = \"254", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cECHO, Type = Double, Dynamic = False, Default = \"01", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cFlowControlOFF, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cFlowControlON, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cFlowControlXON, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cFlowControlXRestartAny, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cHereIsMyTerminalType, Type = Double, Dynamic = False, Default = \"00", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cHereIsMyXDisplayLocation, Type = Double, Dynamic = False, Default = \"00", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cIAC, Type = Double, Dynamic = False, Default = \"255", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cLineMode, Type = Double, Dynamic = False, Default = \"34", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cLogOut, Type = Double, Dynamic = False, Default = \"18", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cNAWS, Type = Double, Dynamic = False, Default = \"31", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cNewEnvironment, Type = Double, Dynamic = False, Default = \"39", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cNewEnvironmentESC, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cNewEnvironmentIS, Type = Double, Dynamic = False, Default = \"00", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cNewEnvironmentUSERVAR, Type = Double, Dynamic = False, Default = \"3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cNewEnvironmentVALUE, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cNewEnvironmentVAR, Type = Double, Dynamic = False, Default = \"00", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cNULL, Type = Double, Dynamic = False, Default = \"00", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cRemoteFlowControlOption, Type = Double, Dynamic = False, Default = \"33", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cSendYourTerminalType, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cSendYourXDisplayLocation, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cStatus, Type = Double, Dynamic = False, Default = \"5", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cSubOptionBegin, Type = Double, Dynamic = False, Default = \"250", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cSubOptionEnd, Type = Double, Dynamic = False, Default = \"240", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cSubOptionHereIsMyTerminalType, Type = Double, Dynamic = False, Default = \"00", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cSuppressGoAheadOption, Type = Double, Dynamic = False, Default = \"03", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cTerminalSpeed, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cTerminalTypeOption, Type = Double, Dynamic = False, Default = \"24", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cTimingMark, Type = Double, Dynamic = False, Default = \"6", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cWILL, Type = Double, Dynamic = False, Default = \"251", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cWONT, Type = Double, Dynamic = False, Default = \"252", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cXDisplay, Type = Double, Dynamic = False, Default = \"35", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
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
			Name="Address"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReceiveBuffer"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WontAuthenticateOption"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WillTerminalType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WIllNegotiationAboutWindowSize"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DoSuppressGoAhead"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DoStatus"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserEcho"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserSuppressGoAhead"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DontSuppressGoAhead"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DontStatus"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserNegotiationAboutWindowSize"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WontNegotiationAboutWindowSize"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IAC_NAWS_TerminalWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IAC_NAWS_TerminalHeight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserTerminalType"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WontTerminalType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IAC_TerminalTypeValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DontEcho"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DoEcho"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WillRemoteFlowControl"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserRemoteFlowControl"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WontRemoteFlowControl"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScreenTextLen"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrackCursorPos"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IAC_RemoteFlowControlValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserTerminalSpeed"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DontNegotiationAboutWindowSize"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IAC_TerminalSpeedValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WillTerminalSpeed"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WontTerminalSpeed"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WontXDisplay"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WontLineMode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WontNewEnvironment"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserLogOut"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserTimingMark"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DontTimingMark"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DoTimingMark"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OS_Display_Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserXDisplay"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WillXDisplay"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_DontXDisplay"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Initial_WillNewEnvironment"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UserNewEnvironment"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NewEnvDISPLAYInBinary"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NewEnvUSERInBinary"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OS_USER_Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TELNETUsername"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TELNETPassword"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunAutoLoginDetection"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UsernamePasswordLoginStyle"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoLoginServiceEnabled"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PasswordLoginStyle"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TerminalHeight"
			Visible=false
			Group="Behavior"
			InitialValue="80"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TerminalWidth"
			Visible=false
			Group="Behavior"
			InitialValue="120"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TerminalType"
			Visible=false
			Group="Behavior"
			InitialValue="Xterm"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TerminalSpeed"
			Visible=false
			Group="Behavior"
			InitialValue="9600"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
