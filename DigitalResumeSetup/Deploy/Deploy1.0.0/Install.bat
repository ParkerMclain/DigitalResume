rem --------------------------------------------------------------------------------
rem           INSTALLATION BATCH FILE AUTOMATIC REMOVE PRIOR VERSION
rem --------------------------------------------------------------------------------

rem Comment out this line to see the messages as the file runs.
@echo off
rem
rem ---------- Set up parameters here (edit as needed) ----------
rem "install" is the name (and full path if needed) of the MSI to install
rem "_AppPoolName" is the TARGETAPPPOOL 

:SETUP
set install=DigitalResumeSetup.msi
set installVirtualDir=C:\inetpub\wwwroot\DigitalResume
set _AppPoolName=DefaultAppPoolv4
set ProjFolder=C:\Users\Administrator\Desktop\DigitalResume
set _Backup=C:\Backup\DigitalResumeSetup

rem ---------- Start ----------
echo ## BEGIN DEPLOYMENT ##
echo.
rem ---------- Backup ---------

if not exist %ProjFolder% goto INSTALL
if not exist %_Backup% mkdir %_Backup%
echo.
XCOPY %ProjFolder% %_Backup% /E/Y/I
if not %Errorlevel% == 0 (
echo "ERROR: Backing the previous content"
goto FAIL
)

echo ## BACKUP COMPLETE ##
echo.

rem ---------- Delete ----------
echo.
del /Q /F %ProjFolder%\*.*
for /D %%D in (%ProjFolder%\*.*) do rd /S /Q "%%D"


echo ## CLEAR PREVIOUS CONTENT COMPLETE ##
echo.

rem ---------- Install ----------
:INSTALL
echo.
echo Installing %install% ...
msiexec /i %install% /qn TARGETSITE=/LM/W3SVC/1 TARGETAPPPOOL=%_AppPoolName% /l %install%.log TARGETVDIR=%installVirtualDir%
IF not %Errorlevel% == 0 goto TESTMSIRESULT
echo %install% installed successfully.

rem ---------- Finished ----------
goto SUCCESS

rem ---------- Send here with MSI result code other than 0.
:TESTMSIRESULT
echo ERROR %Errorlevel%:
IF %Errorlevel% == 1639 echo Invalid command line argument
IF %Errorlevel% == 1638 echo Another version of this product is installed
IF %Errorlevel% == 1637 echo Patch requires a newwer version of windows installer
IF %Errorlevel% == 1636 echo Patch could not be opened
IF %Errorlevel% == 1635 echo Patch not found
IF %Errorlevel% == 1634 echo Component not used on this machine
IF %Errorlevel% == 1633 echo Install not supported on this platform
IF %Errorlevel% == 1632 echo Temp folder is full or inaccessible
IF %Errorlevel% == 1631 echo Windows installer service failed to start
IF %Errorlevel% == 1630 echo Data of this type not supported
IF %Errorlevel% == 1629 echo Data supplied is of wrong type
IF %Errorlevel% == 1628 echo Invalid or unknown table specified
IF %Errorlevel% == 1627 echo Function failed during execution
IF %Errorlevel% == 1626 echo Function could not be executed
IF %Errorlevel% == 1625 echo Installation forbidden by system policy
IF %Errorlevel% == 1624 echo Error applying transforms
IF %Errorlevel% == 1623 echo Unsupported Language
IF %Errorlevel% == 1622 echo Error opening installation log file
IF %Errorlevel% == 1621 echo Error starting Windows Installer Service
IF %Errorlevel% == 1620 echo Installation package could not be opened
IF %Errorlevel% == 1619 echo Installation package not found
IF %Errorlevel% == 1618 echo Another installation is in progress
IF %Errorlevel% == 1617 echo UNUSED
IF %Errorlevel% == 1616 echo Record field does not exist
IF %Errorlevel% == 1615 echo Invalid SQL query syntax
IF %Errorlevel% == 1614 echo Product is uninstalled
IF %Errorlevel% == 1613 echo Package cannot be installed. Upgrade windows installer
IF %Errorlevel% == 1612 echo Install source not available
IF %Errorlevel% == 1611 echo Component qualifier not available
IF %Errorlevel% == 1610 echo Config data corrupt
IF %Errorlevel% == 1609 echo Handle is in an invalid state
IF %Errorlevel% == 1608 echo Unknown property
IF %Errorlevel% == 1607 echo Component ID not registered
IF %Errorlevel% == 1606 echo Feature ID not registered
IF %Errorlevel% == 1605 echo Action only valid for installed products
IF %Errorlevel% == 1604 echo Installation suspended, incomplete
IF %Errorlevel% == 1603 echo Fatal error during installation
IF %Errorlevel% == 1602 echo User cancel installation
IF %Errorlevel% == 1601 echo Windows installer inaccessable
goto FAIL

rem ---------- Finished with a FAIL result ----------
:FAIL
echo.
echo.
echo ###############################################################
echo ******************** DEPLOYMENT FAILURE!!! ********************
echo ###############################################################
echo.
echo.
goto END

rem ---------- Finished with a SUCCESS result ----------
:SUCCESS
echo.
echo.
echo ## DEPLOYMENT SUCCESS ##
echo.
echo.
:END