Unicode true
!include "MUI2.nsh"
!include "LogicLib.nsh"

!define APPNAME "QR Тестова система"
!define APPID   "QRTestovaSistema"
!define APPURL  "https://higiena.github.io/-/"
!define VERSION "1.0.0"

Name "${APPNAME}"
OutFile "QR-Testova-Sistema-Setup.exe"
InstallDir "$LOCALAPPDATA\${APPID}"
RequestExecutionLevel user
SetCompressor /SOLID lzma
BrandingText "${APPNAME}"

VIProductVersion "${VERSION}.0"
VIAddVersionKey /LANG=1026 "ProductName" "${APPNAME}"
VIAddVersionKey /LANG=1026 "FileDescription" "Инсталатор на ${APPNAME}"
VIAddVersionKey /LANG=1026 "FileVersion" "${VERSION}"
VIAddVersionKey /LANG=1026 "ProductVersion" "${VERSION}"
VIAddVersionKey /LANG=1026 "LegalCopyright" "Higiena"

!define MUI_ICON "app.ico"
!define MUI_UNICON "app.ico"
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE "Инсталиране на ${APPNAME}"
!define MUI_WELCOMEPAGE_TEXT "Този инсталатор ще добави ${APPNAME} на компютъра ви:$\r$\n$\r$\n•  икона на работния плот$\r$\n•  икона в менюто „Старт“$\r$\n$\r$\nСистемата се отваря в собствен прозорец и винаги зарежда най-новите тестове от интернет.$\r$\n$\r$\nНатиснете „Напред“, за да продължите."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Стартирай ${APPNAME} сега"
!define MUI_FINISHPAGE_RUN_FUNCTION LaunchApp

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "Bulgarian"

Var Browser

; Find Microsoft Edge (preinstalled on Windows 10/11), else Google Chrome
Function FindBrowser
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
FunctionEnd

!macro MakeShortcut LNK
  ${If} $Browser != ""
    CreateShortcut "${LNK}" "$Browser" "--app=${APPURL}" "$INSTDIR\app.ico" 0 SW_SHOWNORMAL "" "${APPNAME}"
  ${Else}
    ; no Edge/Chrome found: open in the default browser instead
    CreateShortcut "${LNK}" "$INSTDIR\${APPID}.url" "" "$INSTDIR\app.ico" 0
  ${EndIf}
!macroend

Section "Install"
  SetOutPath "$INSTDIR"
  File "app.ico"
  WriteINIStr "$INSTDIR\${APPID}.url" "InternetShortcut" "URL" "${APPURL}"
  WriteINIStr "$INSTDIR\${APPID}.url" "InternetShortcut" "IconFile" "$INSTDIR\app.ico"
  WriteINIStr "$INSTDIR\${APPID}.url" "InternetShortcut" "IconIndex" "0"

  Call FindBrowser
  !insertmacro MakeShortcut "$DESKTOP\${APPNAME}.lnk"
  CreateDirectory "$SMPROGRAMS\${APPNAME}"
  !insertmacro MakeShortcut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
  CreateShortcut "$SMPROGRAMS\${APPNAME}\Деинсталиране.lnk" "$INSTDIR\uninstall.exe"

  WriteUninstaller "$INSTDIR\uninstall.exe"
  !define UK "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPID}"
  WriteRegStr HKCU "${UK}" "DisplayName" "${APPNAME}"
  WriteRegStr HKCU "${UK}" "DisplayIcon" "$INSTDIR\app.ico"
  WriteRegStr HKCU "${UK}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "${UK}" "Publisher" "Higiena"
  WriteRegStr HKCU "${UK}" "URLInfoAbout" "${APPURL}"
  WriteRegStr HKCU "${UK}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${UK}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKCU "${UK}" "NoModify" 1
  WriteRegDWORD HKCU "${UK}" "NoRepair" 1
  WriteRegDWORD HKCU "${UK}" "EstimatedSize" 200
SectionEnd

Function LaunchApp
  Call FindBrowser
  ${If} $Browser != ""
    Exec '"$Browser" --app=${APPURL}'
  ${Else}
    ExecShell "open" "${APPURL}"
  ${EndIf}
FunctionEnd

Section "Uninstall"
  Delete "$DESKTOP\${APPNAME}.lnk"
  Delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
  Delete "$SMPROGRAMS\${APPNAME}\Деинсталиране.lnk"
  RMDir "$SMPROGRAMS\${APPNAME}"
  Delete "$INSTDIR\app.ico"
  Delete "$INSTDIR\${APPID}.url"
  Delete "$INSTDIR\uninstall.exe"
  RMDir "$INSTDIR"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPID}"
SectionEnd
