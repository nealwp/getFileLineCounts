
:: Get line counts of all files in folder
:: Looks for a folder named as the current Julian Date

@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: Enter the path to directory here
SET path=%cd%\test\

:: find single digit year
SET yearpart=%date:~13, 1%

:: find current Julian Date
FOR /f "tokens=2-4 delims=/ " %%a IN ("%date%") DO (
   SET /A "MM=1%%a-100, DD=1%%b-100, Ymod4=%%c%%4"
)
FOR /f "tokens=%MM%" %%m IN ("0 31 59 90 120 151 181 212 243 273 304 334") DO SET /a jdate=DD+%%m
IF %Ymod4% EQU 0 IF %MM% gtr 2 SET /a jdate+=1


:: handles trimmed zeroes for years ending in '0'
IF %jdate% LSS 100 (
	SET jdate=0%jdate%
) ELSE ( 
	IF %jdate% LSS 10 ( 
		SET jdate=0%jdate%
	)
)

:: if file is found, pipe file names and line counts to temp file
IF EXIST "%path%%yearpart%%jdate%" ( 

%windir%\system32\FIND.exe /c /v "" "%path%%yearpart%%jdate%\*" > line-counts.txt

::read contents of temp file
FOR /f "tokens=*" %%a IN ('type line-counts.txt') DO (
SET line=%%a
ECHO !line!
)
) ELSE (
  ECHO %path%%yearpart%%jdate% does not exist
)

::delete temp file
IF EXIST line-counts.txt ( DEL /f line-counts.txt )

PAUSE