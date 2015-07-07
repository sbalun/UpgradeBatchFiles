:: Author: Scott Balun 
:: Version 1.0.0 - 5/14/2015
:: Questions, Concerns, etc?  Email sbalun@air-watch.com
:: FOR INTERNAL USE ONLY

@ECHO off

TITLE AirWatch Console DEV67 Upgrade Helper

CLS

ECHO  =====================================================================
ECHO  Currently this tool only supports the DEV MEM Integration Fork
ECHO.
ECHO  This tool will:
ECHO.
ECHO   (1) Delete the previous installer files
ECHO   (2) Copy new database and application installer files to this machine
ECHO   (3) Extract the application installer files from the zip file
ECHO   (4) Start the database installer wizard
ECHO.
ECHO  NOTE: For this to work you must have previously mapped the network 
ECHO       drive that contains the bamboo artifacts. 
ECHO.
ECHO  =====================================================================
ECHO.
ECHO.
ECHO  What is the bamboo build number you wish to use?

:: ==========================================
:: Get the current build number from user 
:: ==========================================

set /p currentBuild=" >>  Enter number and click <return>: "
set /A previousBuild=%currentBuild%-1

:: ==========================================
:: Delete previous installer files (.zip, db, extracted files
:: ==========================================

ECHO.
ECHO !! Deleting the previous application installer folder from the C: drive
ECHO !! Deleting the previous DB installer from the D: drive
ECHO.

:: Need to put logic in here to see if the file on c exists 
:: before trying to delete it

DEL /F /Q C:\AWDF-ADI-JOB1-*
RMDIR /S /Q D:\Installer

:: ===========================================
:: Copy the DB installer from the bamboo share 
:: to the installer folder on the VM.
:: ===========================================
ECHO.
ECHO !! Copying Airwatch DB Installer to D Drive on the VM
ECHO.

xcopy Y:\AWDF-ADI\BADI\build-00%currentBuild%\AirWatch-Build-Artifacts\AirWatch_DB_Integration_8.1_Setup.exe D:\Installer\

ECHO.
:: ===========================================
:: Launch the DB Installer executable
:: ===========================================
ECHO.
ECHO !! Starting the Airwatch DB Installer...
ECHO.

start "" "D:\Installer\AirWatch_DB_Integration_8.1_Setup.exe"

:: ==========================================
:: Open the local VM D:\ directory
:: ==========================================

start D:\Installer

:: ===========================================
:: Copy the App installer from the bamboo share  
:: to the C: drive on the VM
:: ===========================================
ECHO.
ECHO !! Copying Airwatch Application Installer to C drive on the VM
ECHO.

xcopy Y:\AWDF-ADI\JOB1\build-00%currentBuild%\AirWatch-Build-Artifacts\AWDF-ADI-JOB1-%currentBuild%-App_Installer.zip C:\

ECHO.
ECHO.

:: ===========================================
:: Navigate to the 7 zip executable and launch it
:: then extract the Application Installer zip file
:: to D:\Installer\Installer
:: ===========================================

cd "c:\Program Files\7-Zip"

ECHO !! Starting the 7 zip executable and extracting files to D:\Installer

7z x C:\AWDF-ADI-JOB1-%currentBuild%-App_Installer.zip -oD:\

ECHO.
ECHO.


ECHO !! Job Complete !!

Pause

REM ===================================== To Do ================================================
REM 01. Add a menu with the different build forks so that you can pick which build fork to use
REM 02. Map the bamboo builds network drive so you don't need the map drive pre-req
REM 03. Find out how to call this batch file from the start/stop services batch file







