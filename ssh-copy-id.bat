@echo off

set ARGS_COUNT=%*
set /a COUNT=0
for %%A in (%ARGS_COUNT%) do set /a COUNT+=1

if %COUNT% LSS 2 (
    echo Too few arguments
    echo Syntax: ssh-copy-id.bat "PATH_TO_PUBKEY" login@server port
    echo Default port for SSH is 22
    exit /b
)
REM Get the file name, user and server address, and port
set FILENAME=%~1
set REMOTE_SERVER=%~2
set PORT=%~3

REM Append the file contents to the server
type "%FILENAME%" | ssh -p %PORT% %REMOTE_SERVER% "mkdir -p .ssh && cat >> .ssh/authorized_keys"

REM Check the ssh exit code
if %ERRORLEVEL% neq 0 (
    echo An error occurred while appending the file contents on the server.
    exit /b
)

REM Successfully appended the file contents on the server
echo The contents of the file %FILENAME% have been successfully appended to the file on the server %REMOTE_SERVER%.
exit /b
