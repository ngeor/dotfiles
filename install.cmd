@ECHO OFF
IF /I "%1"=="up" (
	mklink "%USERPROFILE%\.bash_aliases" "%CD%\bash_aliases"
	mklink "%USERPROFILE%\.gitconfig_include" "%CD%\gitconfig_include"
    mklink "%USERPROFILE%\AppData\Roaming\Code\User\keybindings.json" "%CD%\vscode\keybindings.json"
    mklink "%USERPROFILE%\AppData\Roaming\Code\User\settings.json" "%CD%\vscode\settings.json"
	GOTO:EOF
)

IF /I "%1"=="down" (
	DEL "%USERPROFILE%\.bash_aliases"
	DEL "%USERPROFILE%\.gitconfig_include"
    DEL "%USERPROFILE%\AppData\Roaming\Code\User\keybindings.json"
    DEL "%USERPROFILE%\AppData\Roaming\Code\User\settings.json"
	GOTO:EOF
)

ECHO Please run with up or down as parameter
