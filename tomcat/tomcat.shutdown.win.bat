@echo off
rem %CATALINA_HOME% можно прописать в системных переменных -- путь к томкату
set CATALINA_HOME=
set CATALINA_BASE=%~dp0

call %CATALINA_HOME%\bin\shutdown.bat
