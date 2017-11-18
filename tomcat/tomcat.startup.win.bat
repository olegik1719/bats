@echo off
rem %CATALINA_HOME% можно прописать в системных переменных -- путь к томкату
set CATALINA_HOME=
set CATALINA_BASE=%~dp0
set TITLE=My Tomcat Instance WIN*
call %CATALINA_HOME%\bin\startup.bat %TITLE%

