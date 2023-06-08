@echo off
cls

cd src/

set SOURCE_FILE=LEXIS.asm
set OBJECT_FILE=LEXIS.obj

echo Assembling %SOURCE_FILE%...
tasm /z /zi  %SOURCE_FILE% > stdout.txt

if errorlevel 1 goto AssemblyFailed

echo Linking %OBJECT_FILE%...
tlink /v %OBJECT_FILE%

if errorlevel 1 goto LinkingFailed

echo Assembly and linking completed successfully.
echo Copying the EXE file...
copy LEXIS.EXE ..\LEXIS.EXE
echo Cleaning generated files...
del *.obj
del *.map
del *.bak
del *.exe
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
cd ..
pause
