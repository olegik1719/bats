#!/bin/bash
# оригинал здесь: https://habrahabr.ru/sandbox/44866/
#p1='prov1' #имя основного провайдера
#p1='192.168.11.2' # IP MTS
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
		echo "Flag Exists!"
	## Тестим основной канал(через вторую сетевуху): ping && wget
		if (/bin/ping -I $secEth -c $COUNT $test_ping &> /dev/null)&&(wget --bind-address=$secIP $test_wget --max-redirect 0 -O null) 
			### Если Методом пинга тест проходит И Методом wget тест проходит
				then {
					echo "Test passed"
					#### Переключаем каналы:
					# Удаляем "перекрестные" роуты
					route del default gw $secGW dev $mainEth
					route del default gw $mainGW dev $secEth
					# Добавляем "прямые" роуты
					route add default gw $mainGW dev $mainEth
					route add default gw $secGW dev $secEth
					#### Удаляем флажок
					rm $flag
					echo "Flag deleted!"
				}
			### Если не проходит тест, то ничего не делаем.
		fi
	}
# Если флажка нет,(else)
elif (/bin/ping -I $mainEth -c $COUNT $test_ping &> /dev/null)&&(wget --bind-address=$mainIP $test_wget --max-redirect 0 -O null) 
	## Тестим основной канал (уже через первую сетевуху): ping && wget
		then 
			{
				echo "All's good. Nothing else"
			}
		### Если инета нет, то тестируем резервный канал(через вторую сетевуху): ping && wget
		elif (/bin/ping -I $secEth -c $COUNT $test_ping &> /dev/null)&&(wget --bind-address=$secIP $test_wget --max-redirect 0 -O null) 
					#### Если инет через вторую сетевуху:
			then
				{	#### Переключаем каналы
					# Удаляем "прямые" роуты
					route del default gw $secGW dev $secEth
					route del default gw $mainGW dev $mainEth
					# Добавляем "перекрестные" роуты
					route add default gw $mainGW dev $secEth
					route add default gw $secGW dev $mainEth
					#### ставим флажок
					touch $flag
				}
fi
