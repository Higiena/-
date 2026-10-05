; Small launcher that sits next to the app (on the PC or on a USB flash drive).
; Opens the system in its own Edge/Chrome app window using a throw-away browser
; profile in the PC's TEMP folder (fast local disk, unlike a USB stick), and
; deletes that profile when the window is closed, so nothing is left behind.
Unicode true
!include "LogicLib.nsh"
!define APPURL "https://higiena.github.io/-/"
Name "QR Тестова система"
OutFile "QR-Testova-Sistema.exe"
Icon "app.ico"
RequestExecutionLevel user
SilentInstall silent
SetCompressor /SOLID lzma
VIProductVersion "1.2.0.0"
VIAddVersionKey /LANG=1033 "ProductName" "QR Тестова система"
VIAddVersionKey /LANG=1033 "FileDescription" "QR Тестова система"
VIAddVersionKey /LANG=1033 "FileVersion" "1.2.0"
VIAddVersionKey /LANG=1033 "LegalCopyright" "Higiena"

Var Browser
Var TmpProfile
Section
  StrCpy $Browser ""
  ReadRegStr $Browser HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" ""
  ${If} $Browser == ""
    ReadRegStr $Browser HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" ""
  ${EndIf}
  ${If} $Browser == ""
  ${AndIf} ${FileExists} "$PROGRAMFILES32\Microsoft\Edge\Application\msedge.exe"
    StrCpy $Browser "$PROGRAMFILES32\Microsoft\Edge\Application\msedge.exe"
  ${EndIf}
  ${If} $Browser == ""
    ReadRegStr $Browser HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" ""
  ${EndIf}
  ${If} $Browser == ""
    ReadRegStr $Browser HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" ""
  ${EndIf}

  ${If} $Browser == ""
    ExecShell "open" "${APPURL}"
    Goto cleanup_old
  ${EndIf}

  ; throw-away profile on the local disk; remove leftovers from an earlier run first
  StrCpy $TmpProfile "$TEMP\QRTestovaSistema-profile"
  RMDir /r "$TmpProfile"
  ExecWait '"$Browser" --app=${APPURL} "--user-data-dir=$TmpProfile" --no-first-run --no-default-browser-check --disable-sync'
  Sleep 1500
  RMDir /r "$TmpProfile"

  cleanup_old:
  ; older versions kept the profile on the flash drive itself – remove it
  RMDir /r "$EXEDIR\data"
SectionEnd
