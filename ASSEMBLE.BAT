@echo off
cls



set SOURCE_FILE=WORDLE.asm
set OBJECT_FILE=WORDLE.obj

echo Assembling %SOURCE_FILE%...
tasm /z /zi  src\%SOURCE_FILE%

if errorlevel 1 goto AssemblyFailed

echo Linking %OBJECT_FILE%...
tlink /v %OBJECT_FILE%

if errorlevel 1 goto LinkingFailed

echo Assembly and linking completed successfully.
goto End

:NoSourceFile
echo No source file specified.
echo Usage: assemble.bat <source_file>
goto End

:AssemblyFailed
echo Assembly failed!
goto End

:LinkingFailed
echo Linking failed!
goto End

:End
pause
