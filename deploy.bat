:: This script will deploy the EHU CIS docker containers.
:: Author : Dan Campbell
::
 
@echo off
if %1. ==. goto error
 
if not %1. ==. goto deployment
 
:error
SET msgboxTitle=Error
SET msgboxBody='Missing numerical module code argument! Unable to proceed, please include a numerical module code as an argument.'
SET tmpmsgbox=%temp%\~tmpmsgbox.vbs
IF EXIST "%tmpmsgbox%" DEL /F /Q "%tmpmsgbox%"
ECHO msgbox "%msgboxBody%",0,"%msgboxTitle%">"%tmpmsgbox%"
WSCRIPT "%tmpmsgbox%"
goto :eof
 
:end
 
 
:deployment
@echo off
set /A year=22
set /A module= %1
 
if exist cis-docker\docker-compose.yml (
  echo [INFO] A directory and docker-compose.yml already exists for cis%module%
) else (
  echo [INFO] Downloading...
  git clone https://github.com/Edge-Hill-Univeristy-Web/cis-docker.git
)
 
echo [INFO] Changing Directory
cd cis-docker
 
echo [INFO] Creating environment variable file
 
@echo off
echo MODULE_CODE=%module% > ".env"
echo YEAR=%year% >> ".env"
 
echo [INFO] created .env
echo [INFO] Deploying container for CIS%module%
 
docker-compose up
 
:end
 
:eof
:end
