# Install
https://www.vpnbook.com/

Скачать Server: Download PL226 Server OpenVPN Certificate Bundle 
Установить OpenVpn:
sudo apt-get install openvpn

Создаем файл с данными авторизации:
vim ~/vpnbook/auth.txt

vpnbook
dd4e58m

Редактируем файл подключения к прокси:
vim vpnbook-pl226-udp53.ovpn

Найдите строку «auth-user-pass» и замените её на «auth-user-pass auth.txt», где auth.txt это имя файла, в котором вы сохранили логин и пароль.

# Command run
cd ~/vpnbook
sudo openvpn --config ~/vpnbook/vpnbook-pl226-udp53.ovpn
sudo openvpn --config ~/vpnbook/vpnbook-pl226-tcp443.ovpn