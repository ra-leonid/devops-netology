### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ                                                                                                   |
| ------------- |---------------------------------------------------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | Значение присвоено не будет. Выполнение упадёт на этапе сложения, до присвоения результата в переменную |
| Как получить для переменной `c` значение 12?  | Преобразовав `a` к string:  str(a) + b                                                                  |
| Как получить для переменной `c` значение 3?  | Преобразовав `b` к int: a + int(b)                                                                      |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

PATH_REPO = "~/netology/sysadm-homeworks"

bash_command = [f'cd {PATH_REPO}', "git status --porcelain=1"]
result_os = os.popen(' && '.join(bash_command)).read().rstrip()

for result in result_os.split('\n'):

    position = result.find('->')

    if position != -1:
        prepare_result = result[3:position].strip()
    else:
        prepare_result = result[3:].strip()

    print(f'{PATH_REPO}/{prepare_result}')
```

### Вывод скрипта при запуске при тестировании:
```
~/netology/sysadm-homeworks/homeworks/04-script-02-py.md
~/netology/sysadm-homeworks/homeworks/test.py
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

path_repo = sys.argv[1]

bash_command = [f'cd {path_repo}', "git status --porcelain=1"]
result_os = os.popen(' && '.join(bash_command)).read().rstrip()

for result in result_os.split('\n'):

    position = result.find('->')

    if position != -1:
        prepare_result = result[3:position].strip()
    else:
        prepare_result = result[3:].strip()

    print(f'{path_repo}/{prepare_result}')
```

### Вывод скрипта при запуске при тестировании:
```
~/netology/sysadm-homeworks/homeworks/04-script-02-py.md
~/netology/sysadm-homeworks/homeworks/test.py
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import json
import os
import socket


SETTINGS_FILE_NAME = "./settings_script.json"
DEFAULT_URL = {"drive.google.com": "", "mail.google.com": "", "google.com": ""}

def get_settings(file_name):
    if os.path.exists(file_name):
        with open(file_name) as file:
            data = json.load(file)
    else:
        data = DEFAULT_URL

    return data


def check_availability(settings):
    new_settings = {}
    is_change = False

    for url_service, ip in settings.items():
        current_ip = socket.gethostbyname(url_service)
        if current_ip != ip:
            print(f' [ERROR] <{url_service}> IP mismatch: <{ip}> <{current_ip}>')
            is_change = True

        new_settings.update({url_service: current_ip})

    return is_change, new_settings


def save_settings(file_name, data):
    with open(file_name, "w", encoding="utf-8") as file:
        json.dump(data, file)


settings = get_settings(SETTINGS_FILE_NAME)

is_change, new_settings = check_availability(settings)

if is_change:
    save_settings(SETTINGS_FILE_NAME, new_settings)
```

### Вывод скрипта при запуске при тестировании:
```
???
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
#!/usr/bin/env python3

"""
Для работы скрипта, необходимо установить библиотеки PyGithub, requests командой:
pip3 install PyGithub requests

При запуске скрипта заполняем параметры:
- сообщение к pull request
- путь локального репозитория
- наименование удаленного репозитория в виде {owner}/{repo name}
- ветка git репозитория, для загрузки изменений из прода
- token пользователя git репозитория (токен должен быть с правами repo)

Скрипт необходимо запустить до внесения изменений в локальный репозиторий, указав все параметры.
После запуска скрипта будет создана новая ветка и выполниться переключение на неё.
Затем скрипт предложит внести необходимые изменения. Работу скрипта завершать нельзя!!!
После того как все необходимы изменения будут внесены, необходимо продолжить работу скрипта, нажав любую клавишу.
"""
import subprocess
import sys
from github import Github, GithubException


def exec_commands(bash_command):
    try:
        res = subprocess.Popen([' && '.join(bash_command)], stdout=subprocess.PIPE, shell=True)
    except OSError:
        print("error: popen")
        exit(-1)  # if the subprocess call failed, there's not much point in continuing
    res.wait()
    if res.returncode != 0:
        print("  os.wait:exit status != 0\n")
        exit(-1)
    else:
        print(f'os.wait:({res.pid},{res.returncode})')


title = sys.argv[1]
local_repo_path = sys.argv[2]
remote_repo_name = sys.argv[3]
branch_name = sys.argv[4]
token = sys.argv[5]

# Этап внесения изменений в каталог проекта
bash_command = [f'cd {local_repo_path}', "git checkout main", f'git checkout -b {branch_name}']
exec_commands(bash_command)

print("Внесите необходимые изменения.")
input("Для продолжения нажмите Enter")

# Этап отправки изменений в локальный и удаленный репозиторий
bash_command = [f'cd {local_repo_path}', "git add .", f'git commit -m "{title}"', f'git push --set-upstream origin {branch_name}']
exec_commands(bash_command)

# Этап создания pull request
g = Github(token)

repo = g.get_repo(remote_repo_name)

msg = "Это пулл реквест создан автоматически по изменениям из прода!\n\n"
msg += "А яй яй, вносить изменения на-живую нельзя!\n\n"
msg += "Только через поставки ПО!"

try:
    repo.create_pull(title=title, body=msg, base=repo.default_branch, head=branch_name)

except GithubException as err:
    if err.status == 422 and err.data["errors"][0]["message"].startswith("A pull request already exists"):
       print("PR already exists, it was a commit on an open PR")
    raise

```

### Вывод скрипта при запуске при тестировании:
```
???
```