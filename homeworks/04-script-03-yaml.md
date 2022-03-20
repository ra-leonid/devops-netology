### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : "71.75.22.222" 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import json
import yaml
import os
import sys
import socket

DEFAULT_URL = {"drive.google.com": "", "mail.google.com": "", "google.com": ""}


def get_settings(file_name, type_setting):
    if os.path.exists(file_name):
        with open(file_name) as file:
            if type_setting == "json":
                data = json.load(file)
            else:
                data = yaml.safe_load(file)
    else:
        data = DEFAULT_URL

    return data


def save_settings(file_name, data, type_setting):
    with open(file_name, "w", encoding="utf-8") as file:
        if type_setting == "json":
            json.dump(data, file, indent=2)
        else:
            yaml.dump(data, file, indent=2, explicit_start=True, explicit_end=True)


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


try:
    type_setting = sys.argv[1].lower()
except IndexError as err:
    print('Не указан обязательный параметр. Допустимые значения "json", "yaml", "yml"')
    exit(1)

if type_setting in ("yaml", "yml"):
    type_setting = "yaml"
elif type_setting == "json":
    pass
else:
    print('Указан неверный параметр. Допустимые значения "json", "yaml", "yml"')
    exit(1)

settings_file_name = f'./settings_script.{type_setting}'

settings = get_settings(settings_file_name, type_setting)

is_change, new_settings = check_availability(settings)

if is_change:
    save_settings(settings_file_name, new_settings, type_setting)

```

### Вывод скрипта при запуске при тестировании:
```
 [ERROR] <drive.google.com> IP mismatch: <> <64.233.165.194>
 [ERROR] <mail.google.com> IP mismatch: <> <173.194.221.17>
 [ERROR] <google.com> IP mismatch: <> <74.125.131.138>
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
  "drive.google.com": "64.233.165.194",
  "mail.google.com": "173.194.221.17",
  "google.com": "74.125.131.101"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
drive.google.com: 64.233.165.194
google.com: 74.125.131.138
mail.google.com: 173.194.221.17
...
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???