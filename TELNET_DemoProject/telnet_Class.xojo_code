#tag Class
Protected Class telnet_Class
Inherits TCPSocket
	#tag Event
		Sub DataAvailable()
		  Var TmpFrame, IAC_Frame_String As String
		  Var TmpFrameLenCounter As Integer
		  
		  Var TmpSOFrame, IAC_SO_Frame_String As String
		  Var TmpSOFrameLenCounter As Integer
		  
		  Var TmpDataFrame  As String
		  Var TmpDataFrameLenCounter As Integer
		  
		  Var Decoded_IAC_Frames as String
		  Var Decoded_IAC_SO_Frames as String
		  
		  Var IAC_StringLength As Integer
		  Var IAC_SO_StringLength As Integer
		  
		  Var i, ii, y as integer
		  
		  While Me.BytesAvailable > 0
		    recvBufferStr = Me.ReadAll(Encodings.ASCII)
		    
		    // // Match and Process TELNET IAC Negotiations
		    Decoded_IAC_Frames =  decodeIacFrames
		    
		    // Count Byte Length of String
		    IAC_StringLength = LenB(decodeIacFrames)
		    
		    // Convert Binary to ASCII and Store in IAC Input Queue
		    Var iacLc as Integer = IAC_StringLength-1 
		    For i = 0 To iacLc
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
		    Decoded_IAC_SO_Frames = decodeIacSoFrames
		    
		    // Count Byte Length of String
		    IAC_SO_StringLength = LenB(decodeIacSoFrames)
		    
		    // Convert Binary to ASCII and Store in IAC SubOptions (SO) Input Queue
		    Var iacSoLc as Integer = IAC_SO_StringLength-1
		    For ii = 0 To iacSoLc
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
		    Var DecodedTELNET_Data as String = DecodeTELNETData()
		    
		    // Count Byte Length of String
		    Var Data_StringLength As Integer = LenB(DecodedTELNET_Data)
		    
		    // Convert Binary to ASCII and Store in Data Queue
		    Var dLc as Integer = Data_StringLength-1
		    For y  = 0 To dLc
		      TmpDataFrame =TmpDataFrame + ChrB(Asc(DecodedTELNET_Data.Mid(y+1,1)))
		      TmpDataFrameLenCounter = TmpDataFrame.LenB
		      dataInputQueue.Add (TmpDataFrame)
		      TmpDataFrame = ""
		      TmpDataFrameLenCounter = 0
		    Next y
		  Wend 
		  // 
		  // Finished Filling Input Queues :: Begin to Process Responses
		  ' processIacOutputResp()
		  ' processIacSoOutputResp()
		  
		  // I NEVER ADDED SENDING THE RESPONSES BACK 
		  
		  RaiseEvent DataAvailable(recvBufferStr)
		  
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


	#tag Method, Flags = &h0
		Sub connectTelnet(TargetHostStr as String, targetPortInt as Integer, optional usernameStr as String, optional passwordStr as String)
		  Var startTimerDbl As Double
		  Var timeOutDbl As Double = 3000000
		  
		  Me.Address = targetHostStr
		  Me.Port = targetPortInt
		  
		  telnetUsernameStr = usernameStr
		  telnetPassStr = passwordStr
		  startTimerDbl = Microseconds
		  
		  // Connect to Destination IP Address and TELNET port 23
		  Me.Connect()
		  
		  Do
		    Me.Poll
		  Loop Until (Me.IsConnected = True Or Microseconds - startTimerDbl > timeOutDbl)
		  
		  If Me.IsConnected = True Then
		    // Send Initial IAC Offer of NVT/TELNET Capabilities to Server
		    sendInitialIacOffer()
		  End If
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function decodeIacFrames() As String
		  Var regExPattStr as String = "("+ChrB(255)+ChrB(251)+").|" + "("+ChrB(255)+ChrB(252)+").|" + "("+ChrB(255)+ChrB(253)+").|" + "("+ChrB(255)+ChrB(254)+").|"
		  Var decodedStr as String = regExParseString(regExPattStr, recvBufferStr)
		  Return decodedStr
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function decodeIacSoFrames() As String
		  Var regExPattStr as String = ChrB(255) + ChrB(250)+"...."
		  Var decodedStr as String = regExParseString(regExPattStr, recvBufferStr)
		  Return decodedStr
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function decodeTelnetData() As String
		  Var regExPattStr as String = "["+ChrB(32)+"-"+ChrB(127)+"]|"+ChrB(13)+ChrB(10)
		  Var decodedStr as String = regExParseString(regExPattStr, recvBufferStr)
		  Return decodedStr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function detectPasswordLoginStyle(ReceivedTELNETdata as String) As Boolean
		  Var regExPattStr as String = "pass|password"
		  Var decodedStr as String = regExParseString(regExPattStr, recvBufferStr)
		  If decodedStr <> "" Then
		    Return True
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function detectUsernameLoginStyle(ReceivedTELNETdata as String) As Boolean
		  Var regExPattStr as String = "(?:user)|(?:username)|(?:login)"
		  Var decodedStr as String = regExParseString(regExPattStr, recvBufferStr)
		  If decodedStr <> "" Then
		    Return True
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub processLogOutReq()
		  Me.Disconnect
		  Me.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function regExParseString(regExPattStr as String, searchStr as String) As String
		  Var IAC_RegEx As RegEx = New Regex
		  Var IAC_RegExMatch As RegExMatch
		  Var IAC_RegEx_HitText As  String
		  IAC_RegEx.Options.Greedy = True
		  IAC_RegEx.Options.MatchEmpty = False
		  IAC_RegEx.Options.StringBeginIsLineBegin = True
		  IAC_RegEx.Options.StringEndIsLineEnd = True
		  IAC_RegEx.Options.TreatTargetAsOneLine = False
		  IAC_RegEx.Options.CaseSensitive = True
		  IAC_RegEx.Options.DotMatchAll = False
		  IAC_RegEx.SearchPattern = regExPattStr
		  IAC_RegExMatch =  IAC_RegEx.Search(searchStr)
		  
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
		Private Sub sendAuthCreds()
		  me.Write EndOfLine
		  me.Flush
		  me.Write telnetUsernameStr + EndOfLine
		  me.Flush
		  me.Write telnetPassStr + EndOfLine
		  Me.Flush
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub sendInitialIacOffer()
		  if UserEcho = True Then
		    write Initial_DoEcho()
		  elseif UserEcho = False Then
		    write Initial_DontEcho()
		  end if
		  
		  If UserSuppressGoAhead = True Then
		    write Initial_DoSuppressGoAhead()
		  Elseif UserSuppressGoAhead = False Then
		    write Initial_DontSuppressGoAhead()
		  End If 
		  
		   if UserNegotiationAboutWindowSize = True Then
		    Write Initial_WIllNegotiationAboutWindowSize()
		  elseif UserNegotiationAboutWindowSize = False Then
		    Write Initial_DontNegotiationAboutWindowSize()
		  end if
		  
		  If UserTerminalType = True Then
		    write Initial_WillTerminalType()
		  Elseif UserTerminalType = False Then
		    write Initial_WontTerminalType()
		  End If
		  
		  If UserRemoteFlowControl = True Then
		    write Initial_WillRemoteFlowControl()
		  Elseif UserRemoteFlowControl = False Then
		    write Initial_WontRemoteFlowControl()
		  End If
		  
		  if UserTerminalSpeed = True then
		    Write Initial_WillTerminalSpeed()
		  elseif UserTerminalSpeed = False then
		    write Initial_WontTerminalSpeed()
		  end if
		  
		  
		  if UserTimingMark = True then
		    Write Initial_DoTimingMark
		  elseif UserTimingMark = False then
		    write Initial_DontTimingMark()
		  end if
		  
		  if UserNewEnvironment = True then
		    Write Initial_WillNewEnvironment()
		  elseif UserNewEnvironment = False then
		    write Initial_WontNewEnvironment()
		  end if
		  
		  if UserXDisplay = True then
		    Write Initial_WillXDIsplay()
		  elseif UserXDisplay = False then
		    write Initial_DontXDisplay()
		  end if
		  
		  // Options We Also Do Not Support
		  write Initial_WontAuthenticateOption()
		  write Initial_WontLineMode()
		  write Initial_DontStatus()
		  
		  
		  Self.Flush
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub sendPasswordCredentials()
		  me.Write EndOfLine
		  me.Flush
		  me.Write telnetPassStr + EndOfLine
		  Me.Flush
		  
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

	#tag Property, Flags = &h21
		Private dataInputQueue() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		iacNawsTermHeightInt As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		iacNawsTermWidthInt As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IacTermTypeStr As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IAC_InputQueue() As String
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
		recvBufferStr As String
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
		telnetPassStr As String
	#tag EndProperty

	#tag Property, Flags = &h0
		telnetUsernameStr As String
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
			Name="recvBufferStr"
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
			Name="iacNawsTermWidthInt"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iacNawsTermHeightInt"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
			Name="IacTermTypeStr"
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
			Name="telnetUsernameStr"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="telnetPassStr"
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
