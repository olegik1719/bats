Скопируйте папки с конфигурационными файлами из %tomcat-current% в подпапку Вашего проекта:
conf
logs
temp
webapps
work

Положите в эту же папку скрипты, соответствующий Вашей системе:
tomcat.*.win.bat -- win*
tomcat.*.unix.sh -- *nix (разрешить запуск командой "chmod +x tomcat.*.sh")

Для запуска используйте tomcat.startup*

Для остановки используйте tomcat.shutdown*

Использовались ресурсы:

https://stackoverflow.com/questions/16110528/tomcat-multiple-instances-simultaneously/21945707#21945707
http://www.ramkitech.com/2011/07/running-multiple-tomcat-instances-on.html
