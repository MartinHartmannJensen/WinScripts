@ECHO off

::                   User Guide
:: Edit "pathSource" and "pathTarget" to your specific case.
:: The paths can be both files or directories. Files should end with an extension,
:: directories end with nothing. Remember a folder itself will not be copied, but the files and folders inside are. These are
:: then pasted inside the specified folder in "pathTarget". This folder will also be created if non-existent.
:: Edit "copyFrequency" to change how long, in seconds, before copying again.
:: Edit "isLooping" to TRUE if a recurring copy paste is desired. Change to FALSE
:: if you want the script to do a single copy paste every time it is executed, and then exit.
:: Link to XCOPY parameters, to see permissions used: https://technet.microsoft.com/en-us/library/cc771254.aspx

SET pathSource=""
SET pathTarget="C:\Users\User\Desktop\BackupFolder"
SET /A copyFrequency=60*10
SET isLooping=TRUE
:: Parameters used in XCOPY
SET XC_folderPar=/s/e
SET XC_otherPar=/y/k/v/r/h

:: Execution

GOTO :StartupCheckFunc

:mainLoop
CALL :CopyFunc
PING -n %copyFrequency%+1 127.0.0.1 >nul
GOTO :mainLoop

:: Functions

:CopyFunc
XCOPY %XC_folderPar%%XC_otherPar% %pathSource% %pathTarget%
ECHO Timestamp: %TIME%
EXIT /B 0

:StartupCheckFunc
IF %pathSource%=="" (
	ECHO Variables not set. Edit the file to see how to configure.
	PAUSE
	EXIT
)
SET tempXCPAR=
FOR %%i IN (%pathSource%) DO IF EXIST %%~si\NUL SET tempXCPAR=%XC_folderPar%
SET XC_folderPar=%tempXCPAR%
IF %isLooping%==TRUE GOTO :mainLoop
IF %isLooping%==FALSE CALL :CopyFunc
PAUSE
EXIT

