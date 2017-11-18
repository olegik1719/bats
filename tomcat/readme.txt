Скопируйте папки с конфигурационными файлами из %tomcat-current% в подпапку Вашего проекта:
conf
logs
temp
webapps
work

Положите в эту же папку скрипты, соответствующий Вашей системе:
tomcat.*.win.bat -- win*
tomcat.*.unix.sh -- *nix (разрешить запуск командой "chmod +x tomcat.*.sh")

Необходимо прописать:
CATALINA_HOME -- папка с распакованным tomcat'ом (с папкой bin);

Желательно прописать(особенно в unix):
CATALINA_BASE -- папка c конфигурационными папками (conf, logs, temp, webapps, work)

Для запуска используйте tomcat.startup*

Для остановки используйте tomcat.shutdown*

Использовались ресурсы:

https://stackoverflow.com/questions/16110528/tomcat-multiple-instances-simultaneously/21945707#21945707
http://www.ramkitech.com/2011/07/running-multiple-tomcat-instances-on.html
