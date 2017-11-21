#!/bin/bash
# оригинал здесь: https://habrahabr.ru/sandbox/44866/
#p1='prov1' #имя основного провайдера
#p1='192.168.11.2' # IP MTS

mainEth=eth0
mainGW=192.168.1.1

secEth=eth1
secGW=192.168.1.2

route=/sbin/route

test_ping='8.8.8.8'
test_wget='https://www.youtube.com/' # хост для тестирования

COUNT='3' # количество пакетов для отправки
log='/var/log/netstatus.log'
flag='/tmp/res_inet_flag'

echo `date` Script started >> $log
# Если есть флажок резервного канала (у нас интернет через резервный канал):
#$route >> $log
if [ -f $flag ]
        then {
                echo `date` Flag Exists >> $log
        ## Тестим основной канал(через вторую сетевуху): ping && wget
                if (/bin/ping -I $secEth -c $COUNT $test_ping &> /dev/null)&&[ "$(curl -I -m 5 -I --interface $secEth $test_wget 2>/dev/null | head -n 1 | cut -d$' ' -f2)"=="200" ]
                        ### Если Методом пинга тест проходит И Методом wget тест проходит
                                then {
                                        echo `date` Test passed >> $log
                                        #### Переключаем каналы:
                                        # Удаляем "перекрестные" роуты
                                        $route del default gw $secGW dev $mainEth
                                        $route del default gw $mainGW dev $secEth
                                        # Добавляем "прямые" роуты

                                        $route add default gw $secGW dev $secEth
                                        $route add default gw $mainGW dev $mainEth

                                        #### Удаляем флажок
                                        rm $flag
                                        echo `date` Flag deleted! >> $log
                                }
                        ### Если не проходит тест, то ничего не делаем.
                                else
                                        {
                                                curl -I -m 5 -I --interface $secEth $test_wget 2>/dev/null | head -n 1 | cut -d$' ' -f2 >> $log
                                        }
                fi
        }
# Если флажка нет,(else)
elif (/bin/ping -I $mainEth -c $COUNT $test_ping &> /dev/null)&&[ "$(curl -I -m 5 -I --interface $mainEth $test_wget 2>/dev/null | head -n 1 | cut -d$' ' -f2)"=="200" ]
        ## Тестим основной канал (уже через первую сетевуху): ping && wget
                then
                        {
                                echo `date`  All\'s good. Nothing else >> $log
                        }
                ### Если инета нет, то тестируем резервный канал(через вторую сетевуху): ping && wget
                elif (/bin/ping -I $secEth -c $COUNT $test_ping &> /dev/null)&&[ "$(curl -I -m 5 -I --interface $secEth $test_wget 2>/dev/null | head -n 1 | cut -d$' ' -f2)"=="200" ]
                                        #### Если инет через вторую сетевуху:
                        then
                                {       #### Переключаем каналы
                                        # Удаляем "прямые" роуты
                                        echo `date` Test passed >> $log

                                        $route del default gw $secGW dev $secEth
                                        $route del default gw $mainGW dev $mainEth
                                        # Добавляем "перекрестные" роуты

                                        $route add default gw $mainGW dev $secEth
                                        $route add default gw $secGW dev $mainEth
                                        #### ставим флажок
                                        touch $flag
                                        echo `date` Flag inserted! >> $log
                                }
fi
#$route >> $log

echo `date` Script finished >> $log
echo ---------------------------------------- >> $log
                                                                      
