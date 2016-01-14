@ECHO off
:: !Important - If you are using an earlier version than Windows 7, please go to the
:: "Functions" section and change "SleepFunc" to use PING instead of TIMEOUT

:: Description:
:: Continuously copies all files and folders recursively, within the specified
:: folder "pathSource", to the folder "pathTarget".
:: A specified max number of backups will be stored and updated here.

:: The folder path containing the files to backup
SET pathSource=pathNotSet
:: The path to the folder containing backups. Folders within this one, will be named after their creation date
SET pathTarget=C:\Users\User\BackupFolder
:: Set how often, in seconds, a backup should be made
SET /a copyFrequency=60*10
:: Set amount of backups stored
SET backupTotal=5



CALL :StartupCheck

:mainLoop
CALL :CountBackups
IF %backupCount% GEQ %backupTotal% CALL :DeleteOldestFolder
CALL :CreateBackup
CALL :SleepFunc
GOTO :mainLoop

:: Functions

:CreateBackup
SET ts=%DATE:/=-% %TIME::=_%
SET timeStamp=%ts:~0,-3%
XCOPY /s/e/y/k/r/i "%pathSource%" "%pathTarget%\%timeStamp%"
ECHO Backup "%timeStamp%" created!
EXIT /b 0

:SleepFunc
TIMEOUT %copyFrequency%
:: PING -n %copyFrequency%+1 127.0.0.1 >nul
EXIT /b 0

:StartupCheck
IF %pathSource%==pathNotSet (
	ECHO Variables not set. Edit the file to configure values.
	PAUSE
	EXIT
)
EXIT /b 0

:CountBackups
SET /a backupCount=0
FOR /f "delims=" %%i IN ('dir "%pathTarget%" /b /ad-h') DO SET /a backupCount=backupCount+1
EXIT /b 0

:DeleteOldestFolder
FOR /f "delims=" %%i IN ('dir "%pathTarget%" /b /ad-h /t:c /od') DO (
	SET oldestFolder=%%i
	GOTO :end_delOldLoop
)
:end_delOldLoop
RMDIR /s /q "%pathTarget%\%oldestFolder%"
EXIT /b 0