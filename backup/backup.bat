@setlocal enabledelayedexpansion
@echo off

@set dd=%DATE:~0,2%
@set mm=%DATE:~3,2%
@set yyyy=%DATE:~6,4%
@set curdate=%yyyy%-%mm%-%dd%

@set ownName=%~n0

@set LogDir=%~dp0Logs\
if not exist %LogDir% (
	md %LogDir%
)
@if errorlevel 1 set LogDir=%~dp0Logs
@set LogFile=%LogDir%Log-%ownName%-%curdate%.log

@echo ----------------%time%---------------- >> %LogFile%
@echo %time% Script started >> %LogFile%
@echo %time% curdate=%curdate% >> %LogFile%

@rem Setting...
@if "%~1"=="" (
	@set settings=%~dp0%ownName%.ini
) else (
	@set settings=%~dp0%~1
)
@echo %time% settings=%settings% >> %LogFile%
@if not exist %SETTINGS% (
@echo %time% FAIL: ini don't exist! >> %LogFile%
@goto :enderror
)

@for /f "eol=# delims== tokens=1,2" %%i in (%SETTINGS%) do (
@set %%i=%%j
@echo %time% %%i=%%j >> %LogFile%
)

@rem Конечное имя файла архива
@set archieveName=%destination%\!archTmplt:????-??-??=%curdate%!
@echo %time% archieveName=%archieveName% >> %LogFile%
@echo %time% Archieve started!  >> %LogFile%

@rem Если пароль на архив не задан, то не используем его.
@if "%passwd%"=="" (
	@set pPsw=%passwd%
	@echo %time% password is Empty  >> %LogFile%
) else (
	@set pPsw=-p%passwd%
	@echo %time% password is not Empty pPsw=%pPsw%  >> %LogFile%
)

@rem Операция сжатия. Можно использовать все, что угодно. 
@%~dp07za.exe a -ssw -mx9 %pPsw% -r0 %archieveName% %source%
if errorlevel 1 goto error7z
@echo %time% File is ready to send >> %LogFile%

@rem Отправка файла. Используется универсальный SSH. 
@echo %time% Sending started! >> %LogFile%
@%~dp0pscp -l %distuser% -i %~dp0%key% -P 22 -C -scp -p -batch -v %archieveName% %distsrv%:%distsrvpath%
if errorlevel 1 goto errorSSH
@echo %time% File sent >> %LogFile%

@rem Ротация архивов. Средствами SSH. Через plink отправляется Скрипт:
@rem i=0
@rem path=%distsrvpath%
@rem countSave=50
@rem for file in $(ls -r $path/1C7z_????-??-??.7z);do 
@rem 	let "i=i+1"
@rem 	if [[ $i -gt $countSave ]]; then 
@rem 		rm -f $file
@rem 	fi
@rem done

@rem Используется команда, а не скрипт -- для передачи переменной %distsrvpath% -- папка, в которую копируем, ее же чистим.

@echo %time% Rotate started>> %LogFile%
@%~dp0plink -ssh -P 22 -i %~dp0%key% %distuser%@%distsrv% "i=0&&path=%distsrvpath%&&countSave=%countSave%&&for file in $(ls -r $path/%archTmplt%);do let "i=i+1";if [[ $i -gt $countSave ]]; then rm -f $file;fi;done"
if errorlevel 1 goto errorRotate
@echo %time% Rotate finished! >> %LogFile%

goto allsgood

:error7z
@echo %time% There was an error in 7z >> %LogFile%
@set subject="%CompanyName%. Problem with 7z"
@set body=" %ownName%. Go to server and copy files manually. Files wasn't sent to SRV"
goto email

:errorSSH
@echo %time% There was an error in SCP >> %LogFile%
@set subject="%CompanyName%. Problem with SSH"
@set body="%ownName%. Go to server and copy files manually. Files wasn't sent to SRV"
goto email

:errorRotate
@echo %time% There was an error in PLINK >> %LogFile%
@set subject="%CompanyName%. Problem with Rotate"
@set body="%ownName%. Files copied. Anyway go to server and look to rotate!"
goto email

:email
@echo %time% We will send Error mail >> %LogFile%
@%~dp0mailsend -smtp %server% -port %port% -t %toaddress% +cc +bc -f %from% -sub %subject% -M %body% -attach %LogFile% -ssl -auth -user %username% -pass %password% -q
@echo %time% Error mail sent >> %LogFile%

goto enderror

:enderror

@echo %time% Program finished with Error(s) >> %LogFile%
@echo ----------------%time%---------------- >> %LogFile%
exit /b 1

:allsgood
@rem Удаляем созданный архив
@echo %time% All is good! >> %LogFile%
@del %archieveName%
@echo %time% File %archieveName% is removed >> %LogFile%
@echo %time% Program finished normally >> %LogFile%
@echo ----------------%time%---------------- >> %LogFile%

:endTest
