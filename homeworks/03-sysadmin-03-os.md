## Задача 1
Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd. Обратите внимание, что strace выдаёт результат своей работы в поток stderr, а не в stdout.

**Ответ**: chdir("/tmp")
```commandline
┌ [andr][JpuB67Trl8][~]
└─ > strace /bin/bash -c 'cd /tmp' 2>&1 | grep /tmp
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffc25e45670 /* 55 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=440, ...}) = 0
chdir("/tmp")                           = 0

```
## Задача 2
Попробуйте использовать команду file на объекты разных типов на файловой системе. 

Например:
```
vagrant@netology1:~$ file /dev/tty
/dev/tty: character special (5/0)
vagrant@netology1:~$ file /dev/sda
/dev/sda: block special (8/0)
vagrant@netology1:~$ file /bin/bash
/bin/bash: ELF 64-bit LSB shared object, x86-64
```
Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.

**Ответ**: "/etc/magic.mgc", "/etc/magic"

в man описание:
```commandline
The file(1) command identifies the type of a file using, among other tests, a test for whether the file contains certain “magic patterns”.  The database of
     these “magic patterns” is usually located in a binary file in /usr/share/misc/magic.mgc or a directory of source text magic pattern fragment files in /usr/share/misc/magic.  
```
```commandline
┌ [andr][JpuB67Trl8][~]
└─ > strace file /dev/tty 2>&1 | grep openat
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (Нет такого файла или каталога)
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
```
### Задача 3
Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

**Ответ**: 
* Запускаем длительный процесс `top > top.log` и в другом терминале удаляем файл `rm ~/top.log`.
* Узнаем PID процесса:
```commandline
└─ > lsof /usr/bin/top
COMMAND   PID USER  FD   TYPE DEVICE SIZE/OFF    NODE NAME
top     46115 andr txt    REG  253,0   129072 6030317 /usr/bin/top
```
* Узнаем все дескрипторы процесса: `ls -l /proc/46115/fd`
```commandline
└─ > ls -l /proc/46115/fd
итого 0
lrwx------ 1 andr andr 64 фев 12 20:21 0 -> /dev/pts/2
l-wx------ 1 andr andr 64 фев 12 20:21 1 -> '/home/andr/top.log (deleted)'
l-wx------ 1 andr andr 64 фев 12 20:21 2 -> /dev/null
lrwx------ 1 andr andr 64 фев 12 20:21 3 -> /dev/pts/2
lr-x------ 1 andr andr 64 фев 12 20:21 4 -> /proc/stat
lr-x------ 1 andr andr 64 фев 12 20:21 5 -> /proc/uptime
lr-x------ 1 andr andr 64 фев 12 20:21 6 -> /proc/meminfo
lr-x------ 1 andr andr 64 фев 12 20:21 7 -> /proc/loadavg
```
* Перенаправляем процесс на /dev/null чтобы не расходовалось место под удаленный файл
* Запускаем программу gpb `gdb -p 46115 /usr/bin/top`
* Закрываем существующий поток 
```
(gdb) p close(1)
$1 = 0
```
* Перенаправляем поток в /dev/null и выходим:
```commandline
(gdb) p creat("/dev/null", 0600)
$2 = 1
(gdb) q
A debugging session is active.

	Inferior 1 [process 46115] will be detached.

Quit anyway? (y or n) y
Detaching from program: /usr/bin/top, process 46115
[Inferior 1 (process 46115) detached]
```
* Проверяем что поток перенаправлен и размер файла обнулился:
```commandline
└─ > ls -l /proc/46115/fd
итого 0
lrwx------ 1 andr andr 64 фев 12 20:21 0 -> /dev/pts/2
l-wx------ 1 andr andr 64 фев 12 20:21 1 -> /dev/null
l-wx------ 1 andr andr 64 фев 12 20:21 2 -> /dev/null
lrwx------ 1 andr andr 64 фев 12 20:21 3 -> /dev/pts/2
lr-x------ 1 andr andr 64 фев 12 20:21 4 -> /proc/stat
lr-x------ 1 andr andr 64 фев 12 20:21 5 -> /proc/uptime
lr-x------ 1 andr andr 64 фев 12 20:21 6 -> /proc/meminfo
lr-x------ 1 andr andr 64 фев 12 20:21 7 -> /proc/loadavg
┌ [andr][JpuB67Trl8][~]
└─ > lsof -p 46115
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF       NODE NAME
...
top     46115 andr    0u   CHR  136,2      0t0          5 /dev/pts/2
top     46115 andr    1w   CHR    1,3      0t0          6 /dev/null
top     46115 andr    2w   CHR    1,3      0t0          6 /dev/null
top     46115 andr    3u   CHR  136,2      0t0          5 /dev/pts/2
top     46115 andr    4r   REG    0,5        0 4026532026 /proc/stat
top     46115 andr    5r   REG    0,5        0 4026532027 /proc/uptime
top     46115 andr    6r   REG    0,5        0 4026532025 /proc/meminfo
top     46115 andr    7r   REG    0,5        0 4026532024 /proc/loadavg
```
### Задача 4
Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

**Ответ**: У "зомби" процессов ресурсы освобождены. Остается только запись в таблице процессов. 
Она освободится при вызове wait() родительским процессом.

### Задача 5
В iovisor BCC есть утилита opensnoop:
```
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
```
На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? 

**Ответ**: 
```commandline
┌ [andr][JpuB67Trl8][~]
└─ > sudo -i
[sudo] пароль для andr: 
┌ [root][JpuB67Trl8][~]
└─ > opensnoop-bpfcc 
PID    COMM               FD ERR PATH
948    irqbalance          6   0 /proc/interrupts
948    irqbalance          6   0 /proc/stat
948    irqbalance         -1   2 /proc/irq/25/smp_affinity
948    irqbalance         -1   2 /proc/irq/24/smp_affinity
948    irqbalance          6   0 /proc/irq/30/smp_affinity
948    irqbalance          6   0 /proc/irq/32/smp_affinity
948    irqbalance          6   0 /proc/irq/33/smp_affinity
948    irqbalance         -1   2 /proc/irq/26/smp_affinity
948    irqbalance          6   0 /proc/irq/0/smp_affinity
948    irqbalance          6   0 /proc/irq/1/smp_affinity
948    irqbalance          6   0 /proc/irq/8/smp_affinity
948    irqbalance          6   0 /proc/irq/9/smp_affinity
1877   chrome            286   0 /dev/shm/.com.google.Chrome.NBbRT7
28168  CrBrowserMain      39   0 /proc/meminfo
1919   ThreadPoolForeg    42   0 /home/andr/.cache/google-chrome/Default/Cache/Cache_Data/index-dir/temp-index
1877   chrome            283   0 /dev/shm/.com.google.Chrome.MqGbn8
1877   chrome            287   0 /dev/shm/.com.google.Chrome.7lvZi6
1822   ThreadPoolForeg    28   0 /home/andr/.config/skypeforlinux/.org.chromium.Chromium.a7zvgZ
1822   ThreadPoolForeg    28   0 /home/andr/.config/skypeforlinux/.org.chromium.Chromium.a7zvgZ
^C┌ [root][JpuB67Trl8][~]
```

### Задача 6
Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

**Ответ**: Системный вызов `uname({sysname="Linux", nodename="JpuB67Trl8", ...}) = 0`
>Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
> 

### Задача 7
Чем отличается последовательность команд через ; и через && в bash? Например:
```
root@netology1:~# test -d /tmp/some_dir; echo Hi
Hi
root@netology1:~# test -d /tmp/some_dir && echo Hi
root@netology1:~#
```
Есть ли смысл использовать в bash &&, если применить set -e?

**Ответ**: 
`command1 ; command2` - command2 выполнится независимо от результата выполнения command1

`command1 && command2` - command2 выполнится только в том случае, если command1 выполнится успешно.

`set -e` - немедленно завершит работу, если команда завершается с ненулевым статусом. Значит с && нет смысла использовать.

**Комментарий преподавателя**:
 >С параметром -e оболочка завершится только при ненулевом коде возврата простой команды. Если ошибочно завершится одна из команд, разделённых &&, то выхода из шелла не произойдёт. Так что, смысл есть.
В man это поведение описано:
The shell does not exit if the command that fails is . . . part of any command executed in a && or || list except the command following the final &&
> 
### Задача 8
Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

**Ответ**: 
>`-e` Немедленно завершит работу, если конвейер (который может состоять из одной простой команды), списка или составной команды завершается с ненулевым статусом.
>
>`-u` Обрабатывает неустановленные переменные как ошибку при подстановке.
> 
> `-x` Выводит команды и их аргументы по мере их выполнения.
>
> `-o pipefail` Если задано, возвращаемое значение конвейера - это значение последней (самой правой) команды для завершения с ненулевым статусом или ноль, если все команды в конвейере завершаются успешно. По умолчанию эта опция отключена.
>

Думаю что хорошо для отладки. Выводится доп логирование при выполнении каждой команды, завершается выполение всего скрипта если одна из команд завершится с ошибкой, проверяет что все входные параметры были заданы.

### Задача 9
Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

**Ответ**: 
```commandline
└─ > ps -o stat
STAT
Ss
R+
```
Ss - процессы в состоянии прерываемого сна, с приоритетом лидера сессии

R+ - запущенные или доступные для выполнения (в очереди выполнения), находящихся в группе активных процессов

>               D    uninterruptible sleep (usually IO)
>               I    Idle kernel thread
>               R    running or runnable (on run queue)
>               S    interruptible sleep (waiting for an event to complete)
>               T    stopped by job control signal
>               t    stopped by debugger during the tracing
>               W    paging (not valid since the 2.6.xx kernel)
>               X    dead (should never be seen)
>               Z    defunct ("zombie") process, terminated but not reaped by its parent
>
>       For BSD formats and when the stat keyword is used, additional characters may be displayed:
>
>               <    high-priority (not nice to other users)
>               N    low-priority (nice to other users)
>               L    has pages locked into memory (for real-time and custom IO)
>               s    is a session leader
>               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
>               +    is in the foreground process group

> 