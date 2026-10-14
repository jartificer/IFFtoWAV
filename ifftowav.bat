@echo off
setlocal
where sox
if %ERRORLEVEL% NEQ 0 (
	echo Please install SoX - Sound eXchange and add it to your PATH as an environment variable 
	pause
	exit
)
if "%~1"=="" (
	echo Please run this script from the command prompt, specifying the path for ST-XX as an argument. && echo Usage: ifftowav [stxxpath] [outputpath]
	pause
	exit
)
if not exist "%~1\" (
	echo The folder "%~1" does not exist.
	exit /B 1
)

rem Resolve the full source path
pushd "%~1"
set "SRC=%CD%"
popd

rem Converted files go to [outputpath] if given, otherwise to a sibling folder named after the source with a -WAV suffix
if "%~2"=="" (set "OUT=%SRC%-WAV") else (set "OUT=%~f2")

:PROMPT
set /P AREYOUSURE= This will convert all the files residing in subfolders of "%SRC%" to .wav and save them in "%OUT%". The original files will not be modified. Continue? Y/[N]
if /I "%AREYOUSURE%" EQU "Y" (goto MAIN) else (exit /B)

:MAIN
if not exist "%OUT%\" mkdir "%OUT%"
if not exist "%OUT%\" (
	echo Could not create the output folder "%OUT%".
	exit /B 1
)
pushd "%OUT%"
set "OUT=%CD%"
popd
if /I "%OUT%"=="%SRC%" (
	echo The output folder must be different from the source folder.
	exit /B 1
)

rem Convert the files, first checking whether their format is raw or 8svx.
rem The originals are only read; each converted file is written to the matching subfolder of the output folder.
pushd "%SRC%"
for /d %%1 in (*) do if /I not "%%~f1"=="%OUT%" ( echo %%1 
if not exist "%OUT%\%%1\" mkdir "%OUT%\%%1"
for %%2 in ("%%1\*") do find /i /c "FORM" "%%2" & if ERRORLEVEL 1 (sox -t raw -r 8363 -e signed -b 8 -c 1 "%%2" "%OUT%\%%1\%%~nx2.wav") else (sox -t 8svx -b 8 -c 1 "%%2" "%OUT%\%%1\%%~nx2.wav" & if ERRORLEVEL 1 (sox -t raw -r 8363 -e signed -b 8 -c 1 "%%2" "%OUT%\%%1\%%~nx2.wav"))
)
popd

echo Done. The converted files are in "%OUT%".
endlocal
:END
