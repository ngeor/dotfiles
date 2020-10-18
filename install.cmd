@ECHO OFF
IF /I "%1"=="up" (
	mklink "%USERPROFILE%\.gitconfig_include" "%CD%\gitconfig_include"
	mklink "%USERPROFILE%\.bash_aliases" "%CD%\bash_aliases"
	GOTO:EOF
)

IF /I "%1"=="down" (
	DEL "%USERPROFILE%\.gitconfig_include"
	DEL "%USERPROFILE%\.bash_aliases"
	GOTO:EOF
)

ECHO Please run with up or down as parameter
