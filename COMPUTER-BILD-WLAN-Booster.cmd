rem https://www.computerbild.de/download/COMPUTER-BILD-WLAN-Booster-24522189.html

rem Der „COMPUTER BILD-WLAN-Booster“ sorgt dafür, dass Sie mit Ihrem Notebook schneller im Internet surfen. 
rem Aus Stromspargründen nutzt Windows den Energiesparmodus „Ausbalanciert“, worin das Tempo des WLAN-Chips im 
rem Laptop-Akkubetrieb auf Tempo-Stufe 2 von 4 gebremst ist. Der „WLAN-Booster“ aktiviert das Performance-Level 4 
rem („Höchstleistung“) und hebt so die Beschränkung auf. Zunächst ermittelt das Batch-Skript, welcher Energiesparplan aktiv ist, 
rem und fragt die aktuelle Tempostufe ab. Das Tool nennt Ihnen beide Informationen und bietet bei aktivierter Stufe 1, 2 oder 3 an, 
rem die vierte Stufe einzuschalten. Ist bereits die Höchstleistung aktiviert, haben Sie die Möglichkeit, zur stromsparenden Standardeinstellung zurückzukehren.

@echo off
mode con lines=75 cols=155
title COMPUTER BILD-WLAN-Booster



ipconfig | findstr "Drahtlos-LAN-Adapter" > NUL
if %errorlevel%==1 GOTO 0
if %errorlevel%==0 GOTO 1


:0
echo Kein WLAN-Adapter erkannt, eventuell wird das Tool an einem Desktop-PC genutzt.
echo Ein Desktop-PC hat auch generell keinen Akku.
echo.
echo.
echo In der Folge ergibt eine Optimierung via Tool bei Ihnen wohl keinen Sinn.
echo.
echo Zum Beenden des Tools ...
pause
goto ende


:1
for /f "tokens=4" %%a in ('powercfg -GETACTIVESCHEME') do (set "guid=%%a")
for /f "tokens=5" %%a in ('powercfg -GETACTIVESCHEME') do (set "name=%%a")

for /f "tokens=6" %%a in ('powercfg -GETACTIVESCHEME') do (set "n2=%%a")

for /f "tokens=7" %%a in ('powercfg -GETACTIVESCHEME') do (set "n3=%%a")

for /f "tokens=8" %%a in ('powercfg -GETACTIVESCHEME') do (set "n4=%%a")


for /f "tokens=5" %%a in ('powercfg -q %guid% 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 ^| findstr "Gleichstromeinstellung: 0x00000000"') do set suche=%%a

echo HINWEIS: Setzen Sie dieses Tool bitte nur auf einem Notebook ein, an einem Desktop-PC ergibt eine Optimierung keinen Sinn.
timeout /t 3 >NUL
cls

ver | findstr /il "10." > nul
IF %ERRORLEVEL% EQU 0 GOTO W10

ver | findstr /il "6.3." > nul
IF %ERRORLEVEL% EQU 0 GOTO W8.1

ver | findstr /il "6.2." > nul
IF %ERRORLEVEL% EQU 0 GOTO W8

ver | findstr /il "6.1." > nul
IF %ERRORLEVEL% EQU 0 GOTO W7



:W10

set farbenwahl=
set green=%farbenwahl%[32m
set rot=%farbenwahl%[31m
set gelb=%farbenwahl%[33m
set blau=%farbenwahl%[36m
set Weiss=%farbenwahl%[37m


echo %blau%
echo Windows verwendet voreingestellt den Ausbalanciert-Energiesparplan.
echo Darin arbeitet der WLAN-Chip im Notebook-Akku-Betrieb auf Tempostufe 2 von 4.
echo.
echo.


goto %suche%



:0x00000000
color f
echo %weiss%
timeout /t 2 >NUL
echo --- --- ---
echo EIN CHECK IHRES SYSTEMS HAT ERGEBEN:
echo %green%
echo.
timeout /t 2 >NUL
echo Die WLAN-Leistung im aktuell aktivierten Plan %name% %n2% %n3% %n4% ... ist auf Stufe 4 von 4 eingestellt,
echo sodass kein Tuning erforderlich ist.
echo.
echo Die momentane Konfiguration entspricht dem Untereinstellungs-Modus "H”chstleistung".
echo --- --- ---
echo.
timeout /t 1 >NUL
echo %gelb%
echo Wollen Sie die Tempo-Stufe-Einstellung "2 von 4" (wieder) aktivieren, sodass der WLAN-Adapter-Chip im Akku-Betrieb etwas Strom spart?
echo %weiss%
echo --------- ... Hierzu ... ... ...
echo %rot%
pause
cls
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 2

echo MSGBOX "Fertig mit dem Systemeingriff, Windows sollte nun im Akku-Betrieb des Notebooks die WLAN-Performance-Stufe 2 von 4 verwenden. Dies ist ein Performance-Kompromiss. Damit sparen Sie Strom." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs


echo MSGBOX "Zur Kontrolle der neuen Einstellung schliessen Sie dieses Tweaking-Tool mit Klick auf ''OK''. Sodann erscheinen die erweiterten Energieprofil-Einstellungen von Windows: Doppelklicken Sie darin ''Drahtlosadaptereinstellungen > Energiesparmodus''. Die vom Tweaking-Tool gesetzte Einstellung neben ''Auf Akku'' sollte hier nun ''Mittlerer Energiesparmodus'' lauten." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

control powercfg.cpl,,1
goto exit


:0x00000001
color f
timeout /t 2 >NUL
echo %weiss%
echo --- --- ---
echo EIN CHECK IHRES SYSTEMS HAT ERGEBEN:
echo.
timeout /t 2 >NUL
echo %rot%
echo Die WLAN-Leistung im aktuell aktivierten Plan %name% %n2% %n3% %n4% ... ist auf Tempo-Stufe 3 von 4 eingestellt.
echo.
echo Die momentane Konfiguration entspricht dem Untereinstellungs-Modus "Minimaler Energiesparmodus".
echo %green%
echo  ( ... statt "H”chstleistung )
echo %rot%
echo --- --- ---
echo.
echo.
timeout /t 1 >NUL
echo %gelb%
echo Um die Drosselung des Tempos zu beheben bzw. zu entfernen ...
pause
cls
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
cls

echo MSGBOX "Optimierung abgeschlossen, im Akku-Betrieb sollte der WLAN-Chip dadurch nun fortan schneller sein." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

echo MSGBOX "Zur Kontrolle der neuen Einstellung schliessen Sie dieses Tweaking-Tool mit Klick auf ''OK''. Sodann erscheinen die erweiterten Energieprofil-Einstellungen von Windows: Doppelklicken Sie darin ''Drahtlosadaptereinstellungen > Energiesparmodus''. Die vom Tweaking-Tool gesetzte Einstellung neben ''Auf Akku'' sollte hier nun ''Hoechstleistung'' lauten." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

control powercfg.cpl,,1
goto exit






:0x00000002
color f
timeout /t 2 >NUL
echo %weiss%
echo --- --- ---
echo EIN CHECK IHRES SYSTEMS HAT ERGEBEN:
echo.
timeout /t 2 >NUL
echo %rot%
echo Die WLAN-Leistung im aktuell aktivierten Plan %name% %n2% %n3% %n4% ... ist auf Tempo-Stufe 2 von 4 eingestellt.
echo.
echo Die momentane Konfiguration entspricht dem Untereinstellungs-Modus "Mittlerer Energiesparmodus".
echo %green%
echo  (  ... statt "H”chstleistung)
echo %rot%
echo --- --- ---
echo.
echo.
timeout /t 1 >NUL
echo %gelb%
echo Um die Drosselung des Tempos zu beheben bzw. zu entfernen ...
pause
cls
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
cls

echo MSGBOX "Optimierung abgeschlossen, im Akku-Betrieb sollte der WLAN-Chip dadurch nun fortan schneller sein." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

echo MSGBOX "Zur Kontrolle der neuen Einstellung schliessen Sie dieses Tweaking-Tool mit Klick auf ''OK''. Sodann erscheinen die erweiterten Energieprofil-Einstellungen von Windows: Doppelklicken Sie darin ''Drahtlosadaptereinstellungen > Energiesparmodus''. Die vom Tweaking-Tool gesetzte Einstellung neben ''Auf Akku'' sollte hier nun ''Hoechstleistung'' lauten." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

control powercfg.cpl,,1
goto exit


:0x00000003
color f
timeout /t 2 >NUL
echo %weiss%
echo --- --- ---
echo EIN CHECK IHRES SYSTEMS HAT ERGEBEN:
echo.
timeout /t 2 >NUL
echo %rot%
echo Die WLAN-Leistung im aktuell aktivierten Plan %name% %n2% %n3% %n4% ... ist auf Tempo-Stufe 1 von 4 eingestellt.
echo.
echo Die momentane Konfiguration entspricht dem Untereinstellungs-Modus "Maximaler Energiesparmodus".
echo %green%
echo  ( ... statt "H”chstleistung )
echo %rot%
echo --- --- ---
echo.
echo.
timeout /t 1 >NUL
echo %gelb%
echo Um die Drosselung des Tempos zu beheben bzw. zu entfernen ...
pause
cls
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
cls

echo MSGBOX "Optimierung abgeschlossen, im Akku-Betrieb sollte der WLAN-Chip dadurch nun fortan schneller sein." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

echo MSGBOX "Zur Kontrolle der neuen Einstellung schliessen Sie dieses Tweaking-Tool mit Klick auf ''OK''. Sodann erscheinen die erweiterten Energieprofil-Einstellungen von Windows: Doppelklicken Sie darin ''Drahtlosadaptereinstellungen > Energiesparmodus''. Die vom Tweaking-Tool gesetzte Einstellung neben ''Auf Akku'' sollte hier nun ''Hoechstleistung'' lauten." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

control powercfg.cpl,,1
goto exit












:W7

:W8

:W8.1

echo Windows verwendet voreingestellt den Ausbalanciert-Energiesparplan.
echo Darin arbeitet der WLAN-Chip im Notebook-Akku-Betrieb auf Tempostufe 2 von 4.
echo.
echo.


goto %suche%


:0x00000000
timeout /t 2 >NUL
color 2
echo --- --- ---
echo EIN CHECK IHRES SYSTEMS HAT ERGEBEN:
echo.
timeout /t 2 >NUL
echo Die WLAN-Leistung im aktuell aktivierten Plan %name% %n2% %n3% %n4% ... ist auf Stufe 4 von 4 eingestellt,
echo sodass kein Tuning erforderlich ist.
echo.
echo Die momentane Konfiguration entspricht dem Untereinstellungs-Modus "H”chstleistung".
echo --- --- ---
echo.
echo.
timeout /t 1 >NUL
echo Wollen Sie die Tempo-Stufe-Einstellung "2 von 4" (wieder) aktivieren, sodass der WLAN-Adapter-Chip im Akku-Betrieb Strom spart?
echo Hierzu ...
echo.
pause
cls
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 2

echo MSGBOX "Fertig mit dem Systemeingriff, Windows sollte nun im Akku-Betrieb des Notebooks die WLAN-Performance-Stufe 2 von 4 verwenden. Dies ist ein Performance-Kompromiss. Damit sparen Sie Strom." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs


echo MSGBOX "Zur Kontrolle der neuen Einstellung schliessen Sie dieses Tweaking-Tool mit Klick auf ''OK''. Sodann erscheinen die erweiterten Energieprofil-Einstellungen von Windows: Doppelklicken Sie darin ''Drahtlosadaptereinstellungen > Energiesparmodus''. Die vom Tweaking-Tool gesetzte Einstellung neben ''Auf Akku'' sollte hier nun ''Mittlerer Energiesparmodus'' lauten." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

control powercfg.cpl,,1
goto exit


:0x00000001
timeout /t 2 >NUL
color 4
echo --- --- ---
echo EIN CHECK IHRES SYSTEMS HAT ERGEBEN:
echo.
timeout /t 2 >NUL
echo Die WLAN-Leistung im aktuell aktivierten Plan %name% %n2% %n3% %n4% ... ist auf Tempo-Stufe 3 von 4 eingestellt.
echo.
echo Die momentane Konfiguration entspricht dem Untereinstellungs-Modus "Minimaler Energiesparmodus".
echo  ( ... statt "H”chstleistung )
echo --- --- ---
echo.
echo.
timeout /t 1 >NUL
echo Um die Drosselung des Tempos zu beheben bzw. zu entfernen ...
pause
cls
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
cls

echo MSGBOX "Optimierung abgeschlossen, im Akku-Betrieb sollte der WLAN-Chip dadurch nun fortan schneller sein." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

echo MSGBOX "Zur Kontrolle der neuen Einstellung schliessen Sie dieses Tweaking-Tool mit Klick auf ''OK''. Sodann erscheinen die erweiterten Energieprofil-Einstellungen von Windows: Doppelklicken Sie darin ''Drahtlosadaptereinstellungen > Energiesparmodus''. Die vom Tweaking-Tool gesetzte Einstellung neben ''Auf Akku'' sollte hier nun ''Hoechstleistung'' lauten." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

control powercfg.cpl,,1
goto exit






:0x00000002
timeout /t 2 >NUL
color 4
echo --- --- ---
echo EIN CHECK IHRES SYSTEMS HAT ERGEBEN:
echo.
timeout /t 2 >NUL
echo Die WLAN-Leistung im aktuell aktivierten Plan %name% %n2% %n3% %n4% ... ist auf Tempo-Stufe 2 von 4 eingestellt.
echo.
echo Die momentane Konfiguration entspricht dem Untereinstellungs-Modus "Mittlerer Energiesparmodus".
echo  (  ... statt "H”chstleistung)
echo --- --- ---
echo.
echo.
timeout /t 1 >NUL
echo Um die Drosselung des Tempos zu beheben bzw. zu entfernen ...
pause
cls
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
cls

echo MSGBOX "Optimierung abgeschlossen, im Akku-Betrieb sollte der WLAN-Chip dadurch nun fortan schneller sein." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

echo MSGBOX "Zur Kontrolle der neuen Einstellung schliessen Sie dieses Tweaking-Tool mit Klick auf ''OK''. Sodann erscheinen die erweiterten Energieprofil-Einstellungen von Windows: Doppelklicken Sie darin ''Drahtlosadaptereinstellungen > Energiesparmodus''. Die vom Tweaking-Tool gesetzte Einstellung neben ''Auf Akku'' sollte hier nun ''Hoechstleistung'' lauten." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

control powercfg.cpl,,1
goto exit


:0x00000003
timeout /t 2 >NUL
color 4
echo --- --- ---
echo EIN CHECK IHRES SYSTEMS HAT ERGEBEN:
echo.
timeout /t 2 >NUL
echo Die WLAN-Leistung im aktuell aktivierten Plan %name% %n2% %n3% %n4% ... ist auf Tempo-Stufe 1 von 4 eingestellt.
echo.
echo Die momentane Einstellung entspricht dem Untereinstellungs-Modus "Maximaler Energiesparmodus".
echo  ( ... statt "H”chstleistung )
echo --- --- ---
echo.
echo.
timeout /t 1 >NUL
echo Um die Drosselung des Tempos zu beheben bzw. zu entfernen ...
pause
cls
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
cls

echo MSGBOX "Optimierung abgeschlossen, im Akku-Betrieb sollte der WLAN-Chip dadurch nun fortan schneller sein." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

echo MSGBOX "Zur Kontrolle der neuen Einstellung schliessen Sie dieses Tweaking-Tool mit Klick auf ''OK''. Sodann erscheinen die erweiterten Energieprofil-Einstellungen von Windows: Doppelklicken Sie darin ''Drahtlosadaptereinstellungen > Energiesparmodus''. Die vom Tweaking-Tool gesetzte Einstellung neben ''Auf Akku'' sollte hier nun ''Hoechstleistung'' lauten." > %temp%\popup.vbs
call %temp%\popup.vbs
del %temp%\popup.vbs

control powercfg.cpl,,1
goto exit



:exit
