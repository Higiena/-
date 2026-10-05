; Small launcher that sits next to the app (on the PC or on a USB flash drive).
; Opens the system in its own Edge/Chrome app window and keeps the browser
; profile in .\data next to this exe, so nothing is left in the PC's browser.
Unicode true
!include "LogicLib.nsh"
!define APPURL "https://higiena.github.io/-/"
Name "QR Тестова система"
OutFile "QR-Testova-Sistema.exe"
Icon "app.ico"
RequestExecutionLevel user
SilentInstall silent
SetCompressor /SOLID lzma
VIProductVersion "1.1.0.0"
VIAddVersionKey /LANG=1033 "ProductName" "QR Тестова система"
VIAddVersionKey /LANG=1033 "FileDescription" "QR Тестова система"
VIAddVersionKey /LANG=1033 "FileVersion" "1.1.0"
VIAddVersionKey /LANG=1033 "LegalCopyright" "Higiena"

Var Browser
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

  ${If} $Browser != ""
    Exec '"$Browser" --app=${APPURL} "--user-data-dir=$EXEDIR\data" --no-first-run --no-default-browser-check'
  ${Else}
    ExecShell "open" "${APPURL}"
  ${EndIf}
SectionEnd
