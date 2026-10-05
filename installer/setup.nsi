Unicode true
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "Sections.nsh"

!define APPNAME "QR Тестова система"
!define APPID   "QRTestovaSistema"
!define APPURL  "https://higiena.github.io/-/"
!define VERSION "1.2.0"
!define LAUNCHER "QR-Testova-Sistema.exe"
!define UK "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPID}"

Name "${APPNAME}"
OutFile "..\QR-Testova-Sistema-Setup.exe"
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
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_WELCOMEPAGE_TITLE "Инсталиране на ${APPNAME}"
!define MUI_WELCOMEPAGE_TEXT "Този инсталатор ще постави ${APPNAME} на компютъра ви или на флашка.$\r$\n$\r$\nСистемата се отваря в собствен прозорец и винаги зарежда най-новите тестове от интернет.$\r$\n$\r$\nАко изберете флашка, на компютъра няма да остане нищо – програмата се стартира директно от флашката на всеки компютър.$\r$\n$\r$\nНатиснете „Напред“, за да продължите."
!define MUI_DIRECTORYPAGE_TEXT_TOP "Изберете къде да се инсталира ${APPNAME}.$\r$\n$\r$\nЗа флашка: натиснете „Преглед…“ и изберете флашката (напр. E:\)."
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE DirLeave
!define MUI_FINISHPAGE_RUN "$INSTDIR\${LAUNCHER}"
!define MUI_FINISHPAGE_RUN_TEXT "Стартирай ${APPNAME} сега"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "Bulgarian"

Section "-Core"
  SetOutPath "$INSTDIR"
  File "app.ico"
  File "${LAUNCHER}"
  RMDir /r "$INSTDIR\data"
  WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Икона на работния плот" SecDesktop
  CreateShortcut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\${LAUNCHER}" "" "$INSTDIR\app.ico" 0
SectionEnd

Section "Меню „Старт“ и списъка с приложения" SecStart
  CreateDirectory "$SMPROGRAMS\${APPNAME}"
  CreateShortcut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "$INSTDIR\${LAUNCHER}" "" "$INSTDIR\app.ico" 0
  CreateShortcut "$SMPROGRAMS\${APPNAME}\Деинсталиране.lnk" "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "${UK}" "DisplayName" "${APPNAME}"
  WriteRegStr HKCU "${UK}" "DisplayIcon" "$INSTDIR\app.ico"
  WriteRegStr HKCU "${UK}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "${UK}" "Publisher" "Higiena"
  WriteRegStr HKCU "${UK}" "URLInfoAbout" "${APPURL}"
  WriteRegStr HKCU "${UK}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${UK}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKCU "${UK}" "NoModify" 1
  WriteRegDWORD HKCU "${UK}" "NoRepair" 1
  WriteRegDWORD HKCU "${UK}" "EstimatedSize" 400
SectionEnd

; Is $INSTDIR on a removable drive (USB flash)? -> portable: leave nothing on the PC
Var IsRemovable
Function CheckRemovable
  StrCpy $IsRemovable 0
  StrCpy $0 $INSTDIR 3
  System::Call 'kernel32::GetDriveTypeW(w r0) i .r1'
  ${If} $1 == 2
    StrCpy $IsRemovable 1
    !insertmacro UnselectSection ${SecDesktop}
    !insertmacro UnselectSection ${SecStart}
  ${EndIf}
FunctionEnd

Function DirLeave
  Call CheckRemovable
  ${If} $IsRemovable == 1
    MessageBox MB_ICONINFORMATION|MB_OK "Избрана е флашка.$\r$\n$\r$\nИконите на работния плот и в менюто „Старт“ са изключени, за да не остава нищо на този компютър.$\r$\n$\r$\nЗа да стартирате системата, отворете флашката и щракнете два пъти върху „${LAUNCHER}“."
  ${EndIf}
FunctionEnd

Function .onInit
  ${If} ${Silent}
    Call CheckRemovable
  ${EndIf}
FunctionEnd

Section "Uninstall"
  Delete "$DESKTOP\${APPNAME}.lnk"
  Delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
  Delete "$SMPROGRAMS\${APPNAME}\Деинсталиране.lnk"
  RMDir "$SMPROGRAMS\${APPNAME}"
  RMDir /r "$INSTDIR\data"
  Delete "$INSTDIR\${LAUNCHER}"
  Delete "$INSTDIR\${APPID}.url"
  Delete "$INSTDIR\app.ico"
  Delete "$INSTDIR\uninstall.exe"
  RMDir "$INSTDIR"
  DeleteRegKey HKCU "${UK}"
SectionEnd
