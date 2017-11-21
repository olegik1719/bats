#!/bin/bash
# основано на статье: https://habrahabr.ru/sandbox/44866/
# Полностью переписано под нужды.
# В сетке два шлюза, от разных провайдеров. Переключаемся с главного на резервный при отсутствии инета в главном.
mainGW=192.168.1.1
secGW=192.168.1.2

mainEth=eth0
mainIP=192.168.1.3

secEth=eth1
secIP=192.168.1.4


test_ping='8.8.8.8'
test_wget='https://www.youtube.com/' # хост для тестирования

COUNT='3' # количество пакетов для отправки
log='/var/log/netstatus.log'
flag='/tmp/res_inet_flag'

# Если есть флажок резервного канала (у нас интернет через резервный канал):
route
if [ -f $flag ] 
	then {
		echo `date` Flag Exists! >> $log
	## Тестим основной канал(через вторую сетевуху): ping && wget
		if (/bin/ping -I $secEth -c $COUNT $test_ping &> /dev/null)&&(wget --bind-address=$secIP $test_wget --max-redirect 0 -O null) 
			### Если Методом пинга тест проходит И Методом wget тест проходит
				then {
					echo `date` Test passed >> $log
					#### Переключаем каналы:
					# Удаляем "перекрестные" роуты
					route del default gw $secGW dev $mainEth
					route del default gw $mainGW dev $secEth
					# Добавляем "прямые" роуты
					route add default gw $mainGW dev $mainEth
					route add default gw $secGW dev $secEth
					#### Удаляем флажок
					rm $flag
					echo `date` Flag deleted! >> $log
				}
			### Если не проходит тест, то ничего не делаем.
		fi
	}
# Если флажка нет,(else)
elif (/bin/ping -I $mainEth -c $COUNT $test_ping &> /dev/null)&&(wget --bind-address=$mainIP $test_wget --max-redirect 0 -O null) 
	## Тестим основной канал (уже через первую сетевуху): ping && wget
		then 
			{
				echo `date`  All\'s good. Nothing else >> $log
			}
		### Если инета нет, то тестируем резервный канал(через вторую сетевуху): ping && wget
		elif (/bin/ping -I $secEth -c $COUNT $test_ping &> /dev/null)&&(wget --bind-address=$secIP $test_wget --max-redirect 0 -O null) 
					#### Если инет через вторую сетевуху:
			then
				{	#### Переключаем каналы
					# Удаляем "прямые" роуты
					echo `date` Test passed >> $log
					route del default gw $secGW dev $secEth
					route del default gw $mainGW dev $mainEth
					# Добавляем "перекрестные" роуты
					route add default gw $mainGW dev $secEth
					route add default gw $secGW dev $mainEth
					#### ставим флажок
					touch $flag
					echo `date` Flag deleted! >> $log
				}
fi
