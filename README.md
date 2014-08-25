TELNET_Class_Xojo
=================

Written By:

Mike Cotrone - CCIE #8411 Routing/Switching, CCIE #8411 Voice

Contact Info: (Twitter: @mikecotrone Email: mikec@intelligentvisibility.com)

Note: Read Changelog for details

** Licensed under the "BSD 3-Clause License" - http://opensource.org/licenses/BSD-3-Clause

I wrote this TELNET class to properly negotiate TELNET IAC options and IAC sub-options with my remote hosts in order to properly and efficiently retreive information. This Xojo project is free to use
and has no disclaimers or warranties. Use at your own risk and please email me with any suggestions.

IMPLEMENTATION NOTE:

I didn't implement all of the TELNET options primarly due to the age of this protocol. We do not live in the world of IBM hosts or TN3270 emulation any longer, bandwidth is plentiful, and half duplex communication is dead :)

The Basic Terminal front end that is a part of this Demo is for example purposes only since it is limited.

Please report any bugs or issues at:
https://github.com/IntelligentVisibility/TELNET_Class_Xojo/issues



-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
SUPPORTED OPTIONS:

1. ECHO - User can toggle checkbox (True/False) on Window1 GUI to enabled/disable

2. NAWS - User can toggle checkbox (True/False) to enable/disable and set Width/Length on Window1

3. TERMINAL SPEED - User can toggle checkbox (True/False) to enable/disable and set Terminal speed on Window1

4. REMOTE FLOW CONTROL - User can toggle checkbox (True/False) to enable/disable and set Flow Control Type on Window1

5. SUPPRESS GO AHEAD - User can toggle checkbox (True/False) to enable/disable on Window1

6. TERMINAL TYPE - User can toggle checkbox (True/False) to enable/disable and Select terminal Type (which can you can expand on Window1 controls)

7. LOGOUT OPTION - User can toggle checkbox (True/False) to respond to Server's IAC DO LOGOUT 

8. TIMING MARK - User can toggle checkbox (True/False) to enable/disable timing markers.

9. NEW ENVIRONMENT - User can toggle checkbox (True/False) to enable/disable : It pulls your OS (echo $USER and echo $DISPLAY)

10. X DISPLAY LOCATION - User can toggle checkbox (True/False) to enable/disable : It pulls your OS (echo $DISPLAY)



OPTIONS THAT ARE HARD CODED/ NO NEGOTIATIONS  WITH DEFAULT BEHAVIOR:

1. AUTHENTICATE - We will send "IAC WONT AUTHENTICATE" (Comment: Encryption for TELNET really? :-) This was funny when I found RFC 2941)

2. LINEMODE - We will send "IAC WONT LINEMODE"

3. STATUS - We will send "IAC WONT STATUS"


