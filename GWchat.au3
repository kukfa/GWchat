#include <ListviewConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <Array.au3>
#include <GuiEdit.au3>
#include <Constants.au3>
#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <MsgBoxConstants.au3>
#include <ScrollBarsConstants.au3>
#include <SliderConstants.au3>
#include <GuiTab.au3>
#include "GWA2.au3"

OnAutoItExitRegister("GWreset")

If Not Initialize(WinGetProcess("Guild Wars"), True, True, True) Then
   MsgBox(0, "Error", "Guild Wars is not running.")
   Exit
EndIf

If GetLoggedIn() <> 1 Then
   MsgBox(0, "Error", "Please log in and load into a town.")
   Exit
EndIf

MsgBox(0, "Notice", "Make sure GW is run with administrator privileges" & @CRLF & "Not tested to work on Win8")

#Region Creating GUI
Const $gWindowTitle = "GW Chat Utility v1.1"
Opt("GUICoordMode", 1)

$gGUI = GUICreate($gWindowTitle, 420, 320)

$gTabs = GUICtrlCreateTab(10, 10, 400, 250) ;start tabs

$gTabAll = GUICtrlCreateTabItem("! All")
$gAll = GUICtrlCreateEdit("", 10, 30, 400, 230, BitOR($WS_VSCROLL, $ES_READONLY))

$gTabGuild = GUICtrlCreateTabItem("@ Guild")
$gGuild = GUICtrlCreateEdit("", 11, 30, 400, 230, BitOR($WS_VSCROLL, $ES_READONLY))

$gTabTeam = GUICtrlCreateTabItem("# Team")
$gTeam = GUICtrlCreateEdit("", 11, 30, 400, 230, BitOR($WS_VSCROLL, $ES_READONLY))

$gTabTrade = GUICtrlCreateTabItem("$ Trade")
$gTrade = GUICtrlCreateEdit("", 11, 30, 400, 230, BitOR($WS_VSCROLL, $ES_READONLY))

$gTabAlliance = GUICtrlCreateTabItem("% Alliance")
$gAlliance = GUICtrlCreateEdit("", 11, 30, 400, 230, BitOR($WS_VSCROLL, $ES_READONLY))

$gTabWhisper = GUICtrlCreateTabItem('" Whisper')
$gWhisper = GUICtrlCreateEdit("", 11, 30, 400, 210, BitOR($WS_VSCROLL, $ES_READONLY))
$gRecipient = GUICtrlCreateInput("<recipient>", 11, 240, 398, 20)
GUICtrlSetLimit($gRecipient, 19)

$gTabGlobal = GUICtrlCreateTabItem("Global")
$gGlobal = GUICtrlCreateEdit("", 11, 30, 400, 230, BitOR($WS_VSCROLL, $ES_READONLY))

GUICtrlCreateTabItem("") ;end tabs

$gInput = GUICtrlCreateInput("<message>", 10, 270, 400, 20)
GUICtrlSetLimit($gInput, 119)

$gHideButton = GUICtrlCreateButton("Hide GW", 10, 295, 100, 20)
$gTimestampButton = GUICtrlCreateButton("Timestamp On", 120, 295, 100, 20)
$gExitButton = GUICtrlCreateButton("Exit", 230, 295, 60, 20)

GUISetState(@SW_SHOW)
#EndRegion

Global $timestampstatus = 0

SetEvent('', '', '', 'MessageReceive', '')

$dave = 'cool'
While $dave = 'cool'
   $Msg = GUIGetMsg()
   $inputtext = GUICtrlRead($gInput)
   If GetMapLoading() = 2 Then
	  SetEvent('', '', '', '', '')
	  WaitMapLoading()
	  SetEvent('', '', '', 'MessageReceive', '')

   EndIf
   Switch $Msg
	  Case $GUI_EVENT_CLOSE
		 Exit
	  Case $gExitButton
		 Exit
	  Case $gTimestampButton
		 If GUICtrlRead($gTimestampButton) = "Timestamp On" Then
			$timestampstatus = 1
			GUICtrlSetData($gTimestampButton, "Timestamp Off")
		 Else
			$timestampstatus = 0
			GUICtrlSetData($gTimestampButton, "Timestamp On")
		 EndIf
	  Case $gHideButton
		 HideGW()
		 If GUICtrlRead($gHideButton) = "Hide GW" Then
			GUICtrlSetData($gHideButton, "Unhide GW")
		 Else
			GUICtrlSetData($gHideButton, "Hide GW")
		 EndIf
	  Case $gInput
		 If GUICtrlRead($gTabs) <> 6 Then
			MessageSend(GUICtrlRead($gInput))
			GUICtrlSetData($gInput, "")
		 EndIf
	  Case $gTabs
		 $iCurrTab = GUICtrlRead($gTabs)
		 Switch $iCurrTab
			Case 0
			   GUICtrlSetData($gTabAll, "! All")
			   $allEnd = StringLen(GUICtrlRead($gAll))
			   _GUICtrlEdit_SetSel($gAll, $allEnd, $allEnd)
			   _GUICtrlEdit_Scroll($gAll, $SB_SCROLLCARET)
			Case 1
			   GUICtrlSetData($gTabGuild, "@ Guild")
			   $guildEnd = StringLen(GUICtrlRead($gGuild))
			   _GUICtrlEdit_SetSel($gGuild, $guildEnd, $guildEnd)
			   _GUICtrlEdit_Scroll($gGuild, $SB_SCROLLCARET)
			Case 2
			   GUICtrlSetData($gTabTeam, "# Team")
			   $teamEnd = StringLen(GUICtrlRead($gTeam))
			   _GUICtrlEdit_SetSel($gTeam, $teamEnd, $teamEnd)
			   _GUICtrlEdit_Scroll($gTeam, $SB_SCROLLCARET)
			Case 3
			   GUICtrlSetData($gTabTrade, "$ Trade")
			   $tradeEnd = StringLen(GUICtrlRead($gTrade))
			   _GUICtrlEdit_SetSel($gTrade, $tradeEnd, $tradeEnd)
			   _GUICtrlEdit_Scroll($gTrade, $SB_SCROLLCARET)
			Case 4
			   GUICtrlSetData($gTabAlliance, "% Alliance")
			   $allianceEnd = StringLen(GUICtrlRead($gAlliance))
			   _GUICtrlEdit_SetSel($gAlliance, $allianceEnd, $allianceEnd)
			   _GUICtrlEdit_Scroll($gAlliance, $SB_SCROLLCARET)
			Case 5
			   GUICtrlSetData($gTabWhisper, '" Whisper')
			   $whisperEnd = StringLen(GUICtrlRead($gWhisper))
			   _GUICtrlEdit_SetSel($gWhisper, $whisperEnd, $whisperEnd)
			   _GUICtrlEdit_Scroll($gWhisper, $SB_SCROLLCARET)
			Case 6
			  GUICtrlSetData($gTabGlobal, "Global")
			  $globalEnd = StringLen(GUICtrlRead($gGlobal))
			   _GUICtrlEdit_SetSel($gGlobal, $globalEnd, $globalEnd)
			   _GUICtrlEdit_Scroll($gGlobal, $SB_SCROLLCARET)
		 EndSwitch
   EndSwitch
   Switch $inputtext
	  Case '!'
		 GUICtrlSetState($gTabAll, $GUI_SHOW)
		 GUICtrlSetData($gTabAll, "! All")
		 GUICtrlSetData($gInput, "")
		 $allEnd = StringLen(GUICtrlRead($gAll))
		 _GUICtrlEdit_SetSel($gAll, $allEnd, $allEnd)
		 _GUICtrlEdit_Scroll($gAll, $SB_SCROLLCARET)
	  Case '@'
		 GUICtrlSetState($gTabGuild, $GUI_SHOW)
		 GUICtrlSetData($gTabGuild, "@ Guild")
		 GUICtrlSetData($gInput, "")
		 $guildEnd = StringLen(GUICtrlRead($gGuild))
		 _GUICtrlEdit_SetSel($gGuild, $guildEnd, $guildEnd)
		 _GUICtrlEdit_Scroll($gGuild, $SB_SCROLLCARET)
	  Case '#'
		 GUICtrlSetState($gTabTeam, $GUI_SHOW)
		 GUICtrlSetData($gTabTeam, "# Team")
		 GUICtrlSetData($gInput, "")
		 $teamEnd = StringLen(GUICtrlRead($gTeam))
		 _GUICtrlEdit_SetSel($gTeam, $teamEnd, $teamEnd)
		 _GUICtrlEdit_Scroll($gTeam, $SB_SCROLLCARET)
	  Case '$'
		 GUICtrlSetState($gTabTrade, $GUI_SHOW)
		 GUICtrlSetData($gTabTrade, "$ Trade")
		 GUICtrlSetData($gInput, "")
		 $tradeEnd = StringLen(GUICtrlRead($gTrade))
		 _GUICtrlEdit_SetSel($gTrade, $tradeEnd, $tradeEnd)
		 _GUICtrlEdit_Scroll($gTrade, $SB_SCROLLCARET)
	  Case '%'
		 GUICtrlSetState($gTabAlliance, $GUI_SHOW)
		 GUICtrlSetData($gTabAlliance, "% Alliance")
		 GUICtrlSetData($gInput, "")
		 $allianceEnd = StringLen(GUICtrlRead($gAlliance))
		 _GUICtrlEdit_SetSel($gAlliance, $allianceEnd, $allianceEnd)
		 _GUICtrlEdit_Scroll($gAlliance, $SB_SCROLLCARET)
	  Case '"'
		 GUICtrlSetState($gTabWhisper, $GUI_SHOW)
		 GUICtrlSetData($gTabWhisper, '" Whisper')
		 GUICtrlSetData($gInput, "")
		 $whisperEnd = StringLen(GUICtrlRead($gWhisper))
		 _GUICtrlEdit_SetSel($gWhisper, $whisperEnd, $whisperEnd)
		 _GUICtrlEdit_Scroll($gWhisper, $SB_SCROLLCARET)
   EndSwitch
WEnd

Func MessageReceive($mChannel, $mSender, $mMessage)
   If $mChannel = "All" Then ;tab 0
	  If GUICtrlRead($gTabs) <> 0 Then
		 GUICtrlSetData($gTabAll, "[*] ! All")
	  EndIf
	  If $timestampstatus = 0 Then
		 GUICtrlSetData($gAll, GUICtrlRead($gAll) & @CRLF & $mSender & ': ' & $mMessage)
		 $allEnd = StringLen(GUICtrlRead($gAll))
		 _GUICtrlEdit_SetSel($gAll, $allEnd, $allEnd)
		 _GUICtrlEdit_Scroll($gAll, $SB_SCROLLCARET)
	  Else
		 GUICtrlSetData($gAll, GUICtrlRead($gAll) & @CRLF & '[' & @HOUR & ':' & @MIN & ':' & @SEC & '] ' & $mSender & ': ' & $mMessage)
		 $allEnd = StringLen(GUICtrlRead($gAll))
		 _GUICtrlEdit_SetSel($gAll, $allEnd, $allEnd)
		 _GUICtrlEdit_Scroll($gAll, $SB_SCROLLCARET)
	  EndIf
   ElseIf $mChannel = "Guild" Then ;tab 1
	  If GUICtrlRead($gTabs) <> 1 Then
		 GUICtrlSetData($gTabGuild, "[*] @ Guild")
	  EndIf
	  If $timestampstatus = 0 Then
		 GUICtrlSetData($gGuild, GUICtrlRead($gGuild) & @CRLF & $mSender & ': ' & $mMessage)
		 $guildEnd = StringLen(GUICtrlRead($gGuild))
		 _GUICtrlEdit_SetSel($gGuild, $guildEnd, $guildEnd)
		 _GUICtrlEdit_Scroll($gGuild, $SB_SCROLLCARET)
	  Else
		 GUICtrlSetData($gGuild, GUICtrlRead($gGuild) & @CRLF & '[' & @HOUR & ':' & @MIN & ':' & @SEC & '] ' & $mSender & ': ' & $mMessage)
		 $guildEnd = StringLen(GUICtrlRead($gGuild))
		 _GUICtrlEdit_SetSel($gGuild, $guildEnd, $guildEnd)
		 _GUICtrlEdit_Scroll($gGuild, $SB_SCROLLCARET)
	  EndIf
   ElseIf $mChannel = "Team" Then ;tab 2
	  If GUICtrlRead($gTabs) <> 2 Then
		 GUICtrlSetData($gTabTeam, "[*] # Team")
	  EndIf
	  If $timestampstatus = 0 Then
		 GUICtrlSetData($gTeam, GUICtrlRead($gTeam) & @CRLF & $mSender & ': ' & $mMessage)
		 $teamEnd = StringLen(GUICtrlRead($gTeam))
		 _GUICtrlEdit_SetSel($gTeam, $teamEnd, $teamEnd)
		 _GUICtrlEdit_Scroll($gTeam, $SB_SCROLLCARET)
	  Else
		 GUICtrlSetData($gTeam, GUICtrlRead($gTeam) & @CRLF & '[' & @HOUR & ':' & @MIN & ':' & @SEC & '] ' & $mSender & ': ' & $mMessage)
		 $teamEnd = StringLen(GUICtrlRead($gTeam))
		 _GUICtrlEdit_SetSel($gTeam, $teamEnd, $teamEnd)
		 _GUICtrlEdit_Scroll($gTeam, $SB_SCROLLCARET)
	  EndIf
   ElseIf $mChannel = "Trade" Then ;tab 3
	  If GUICtrlRead($gTabs) <> 3 Then
		 GUICtrlSetData($gTabTrade, "[*] $ Trade")
	  EndIf
	  If $timestampstatus = 0 Then
		 GUICtrlSetData($gTrade, GUICtrlRead($gTrade) & @CRLF & $mSender & ': ' & $mMessage)
		 $tradeEnd = StringLen(GUICtrlRead($gTrade))
		 _GUICtrlEdit_SetSel($gTrade, $tradeEnd, $tradeEnd)
		 _GUICtrlEdit_Scroll($gTrade, $SB_SCROLLCARET)
	  Else
		 GUICtrlSetData($gTrade, GUICtrlRead($gTrade) & @CRLF & '[' & @HOUR & ':' & @MIN & ':' & @SEC & '] ' & $mSender & ': ' & $mMessage)
		 $tradeEnd = StringLen(GUICtrlRead($gTrade))
		 _GUICtrlEdit_SetSel($gTrade, $tradeEnd, $tradeEnd)
		 _GUICtrlEdit_Scroll($gTrade, $SB_SCROLLCARET)
	  EndIf
   ElseIf $mChannel = "Alliance" Then ;tab 4
	  If GUICtrlRead($gTabs) <> 4 Then
		 GUICtrlSetData($gTabAlliance, "[*] % Alliance")
	  EndIf
	  If $timestampstatus = 0 Then
		 GUICtrlSetData($gAlliance, GUICtrlRead($gAlliance) & @CRLF & $mSender & ': ' & $mMessage)
		 $allianceEnd = StringLen(GUICtrlRead($gAlliance))
		 _GUICtrlEdit_SetSel($gAlliance, $allianceEnd, $allianceEnd)
		 _GUICtrlEdit_Scroll($gAlliance, $SB_SCROLLCARET)
	  Else
		 GUICtrlSetData($gAlliance, GUICtrlRead($gAlliance) & @CRLF & '[' & @HOUR & ':' & @MIN & ':' & @SEC & '] ' & $mSender & ': ' & $mMessage)
		 $allianceEnd = StringLen(GUICtrlRead($gAlliance))
		 _GUICtrlEdit_SetSel($gAlliance, $allianceEnd, $allianceEnd)
		 _GUICtrlEdit_Scroll($gAlliance, $SB_SCROLLCARET)
	  EndIf
   ElseIf $mChannel = "Global" or $mChannel = "Advisory" or $mChannel = "Other" Then ;tab 6
	  If GUICtrlRead($gTabs) <> 6 Then
		 GUICtrlSetData($gTabGlobal, "[*] Global")
	  EndIf
	  If $timestampstatus = 0 Then
		 GUICtrlSetData($gGlobal, GUICtrlRead($gGlobal) & @CRLF & $mSender & ': ' & $mMessage)
		 $globalEnd = StringLen(GUICtrlRead($gGlobal))
		 _GUICtrlEdit_SetSel($gGlobal, $globalEnd, $globalEnd)
		 _GUICtrlEdit_Scroll($gGlobal, $SB_SCROLLCARET)
	  Else
		 GUICtrlSetData($gGlobal, GUICtrlRead($gGlobal) & @CRLF & '[' & @HOUR & ':' & @MIN & ':' & @SEC & '] ' & $mSender & ': ' & $mMessage)
		 $globalEnd = StringLen(GUICtrlRead($gGlobal))
		 _GUICtrlEdit_SetSel($gGlobal, $globalEnd, $globalEnd)
		 _GUICtrlEdit_Scroll($gGlobal, $SB_SCROLLCARET)
	  EndIf
   ElseIf $mChannel = "Sent" Then
	  If GUICtrlRead($gTabs) <> 5 Then
		 GUICtrlSetData($gTabWhisper, '[*] " Whisper')
	  EndIf
	  If $timestampstatus = 0 Then
		 GUICtrlSetData($gWhisper, GUICtrlRead($gWhisper) & @CRLF & "-> {" & $mSender & "} " & $mMessage)
		 $whisperEnd = StringLen(GUICtrlRead($gWhisper))
		 _GUICtrlEdit_SetSel($gWhisper, $whisperEnd, $whisperEnd)
		 _GUICtrlEdit_Scroll($gWhisper, $SB_SCROLLCARET)
	  Else
		 GUICtrlSetData($gWhisper, GUICtrlRead($gWhisper) & @CRLF & '[' & @HOUR & ':' & @MIN & ':' & @SEC & '] ' & "-> {" & $mSender & "} " & $mMessage)
		 $whisperEnd = StringLen(GUICtrlRead($gWhisper))
		 _GUICtrlEdit_SetSel($gWhisper, $whisperEnd, $whisperEnd)
		 _GUICtrlEdit_Scroll($gWhisper, $SB_SCROLLCARET)
	  EndIf
   Else
	  If GUICtrlRead($gTabs) <> 5 Then
		 GUICtrlSetData($gTabWhisper, '[*] " Whisper')
	  EndIf
	  If $timestampstatus = 0 Then
		 GUICtrlSetData($gWhisper, GUICtrlRead($gWhisper) & @CRLF & "{" & $mSender & "} " & $mMessage)
		 $whisperEnd = StringLen(GUICtrlRead($gWhisper))
		 _GUICtrlEdit_SetSel($gWhisper, $whisperEnd, $whisperEnd)
		 _GUICtrlEdit_Scroll($gWhisper, $SB_SCROLLCARET)
	  Else
		 GUICtrlSetData($gWhisper, GUICtrlRead($gWhisper) & @CRLF & '[' & @HOUR & ':' & @MIN & ':' & @SEC & '] ' & "{" & $mSender & "} " & $mMessage)
		 $whisperEnd = StringLen(GUICtrlRead($gWhisper))
		 _GUICtrlEdit_SetSel($gWhisper, $whisperEnd, $whisperEnd)
		 _GUICtrlEdit_Scroll($gWhisper, $SB_SCROLLCARET)
	  EndIf

   EndIf
EndFunc

#cs - I wanted to use this when clicking someone's name to whisper them but didn't find any good way to create
a text link to a function.. maybe next time?

Func Whisper($wSender)
   GUICtrlSetState($gTabWhisper, $GUI_SHOW)
   GUICtrlSetData($gRecipient, $wSender)
   _WinAPI_SetFocus(ControlGetHandle("GW Chat Utility v1.0", "", $gInput))
EndFunc
#ce

Func MessageSend($mMsg)
   $CurrentTab = GUICtrlRead($gTabs)
   If $CurrentTab = 0 Then
	  SendChat($mMsg, '!')
   ElseIf $CurrentTab = 1 Then
	  SendChat($mMsg, '@')
   ElseIf $CurrentTab = 2 Then
	  SendChat($mMsg, '#')
   ElseIf $CurrentTab = 3 Then
	  SendChat($mMsg, '$')
   ElseIf $CurrentTab = 4 Then
	  SendChat($mMsg, '%')
   Else
	  SendWhisper(GUICtrlRead($gRecipient), $mMsg)
   EndIf
EndFunc

Func HideGW()
   If WinGetState(GetWindowHandle()) <> 5 Then
	  WinSetState(GetWindowHandle(), "", @SW_HIDE)
   Else
	  WinSetState(GetWindowHandle(), "", @SW_SHOW)
   EndIf
EndFunc

 Func GWreset()
	WinSetTitle(GetWindowHandle(), "", "Guild Wars")
EndFunc