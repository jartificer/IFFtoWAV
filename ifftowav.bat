@echo off
setlocal
where sox
if %ERRORLEVEL% NEQ 0 (
	echo Please install SoX - Sound eXchange and add it to your PATH as an environment variable 
	pause
	exit
)
if "%~1"=="" (
	echo Please run this script from the command prompt, specifying the path for ST-XX as an argument. && echo Usage: ifftowav [stxxpath]
	pause
	exit
) else (goto PROMPT) 

:PROMPT
set /P AREYOUSURE= This will convert all the files residing in subfolders of %~1 to .wav and delete all the original files in those subfolders. Continue? Y/[N]
if /I "%AREYOUSURE%" EQU "Y" (goto MAIN) else (exit /B)
	
:MAIN
cd %1
rem Add iff extension to all files
for /d %%d in (./*) do (pushd %%d & for %%f in (./*) do ren "%%f" "%%f.iff") & popd %%d

rem Convert the files, first checking whether their format is raw or 8svx
for /d %%1 in (*) do ( echo %%1 & pushd %%1 
for %%2 in (*.iff) do find /i /c "FORM" "%%2" & if ERRORLEVEL 1 (sox -t raw -r 8363 -e signed -b 8 -c 1 "%%2" "%%~n2.wav") else (sox -t 8svx -b 8 -c 1 "%%2" "%%~n2.wav" & if ERRORLEVEL 1 (sox -t raw -r 8363 -e signed -b 8 -c 1 "%%2" "%%~n2.wav"))
popd %%1 )

rem Remove the original files

for /d %%d in (./*) do (pushd %%d & for %%f in (./*.iff) do del "%%f") & popd %%d

cd..
endlocal
:END
