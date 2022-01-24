
# Конспект "Работа с git"

## Пути сохранения настроек:
- /etc/gitconfig - сохраняются настройки system. Распространяются на все репы всех пользователей ПК.
- ~/.gitconfig или ~/.config/git/config - сохраняются настройки global. Распространяются на все репы текущего пользователя ПК.
- .git/config  - сохраняются настройки local. Распространяются только на текущую репу


## Команды настроек:
Посмотреть все настройки:

`git config --list`

Посмотреть все настройки и где они заданы:

`git config --list --show-origin`

Создание псевдонима команд:

`git config --global alias.br branch`

## Команды работы с изменениями:
Краткий вывод состояний файлов репы:

`git status [-s|--short]`

Показать различия файлов между статусами Modified и Unmodified (измененные и те что в последнем коммите в репе):

`git diff`

Сравнивает Staged и Unmodified (проиндексированные и те что в последнем коммите в репе):

`git diff --staged`
`git diff --cached`

Просмотр изменений в графическом редакторе:

`git difftool`

Коммит изменений с вводом комментария в консольном редакторе:

`git commit`

* Флаг `-a` автоматически добавит файлы в индекс.
* Флаг `-m` позволяет ввести комментарий в командной строке.
* Флаг `-v` добавит в комментарий коммита какие были изменения

Пример:
`git commit -v -a -m "Что и почему было изменено"`

Добавление в индекс удаления файлов __у меня нормально добавило удаление и `git add .`__:

`git rm file.txt`
* флаг `-f` удаление файла даже если он уже проиндексирован.
* флаг `--cached` отменить индексирование удаления файла
* флаг `-n` посмотреть что буде если удалить, но ничего не делать

Удаление файлов по шаблону:

`git rm log/\*.log`

Перемещение/переименование файлов:

`git mv file.src file.dect`

## Работа с историей коммитов

Просмотр истории коммитов

`git log`

Флаги:
* `-p` - показывает что было изменено
* `-[1|2|3|..n]` сколько последних коммитов вывести
* `--stat` - выводит статистику по каждому коммиту
* `--pretty=online` - вывести каждый коммит в 1 строку
* `--pretty=format` - вывод комментариев с форматированием

Просмотр конкретного коммита:

`git show 62d641c`

Краткий лог по диапазону коммитов исключая merge-коммиты. Нижняя граница исключается, верхняя - включается:
* `git log 66236fd..01e1ae5 --no-merges --pretty=format:"%h | %ad | %an | %s%d" --date=short` - в диапазоне коммитов
* `git log v2.1.4.59..v2.1.4.60 --no-merges --pretty=format:"%h | %ad | %an | %s%d" --date=short` - в диапазоне тегов
* `git log v2.1.4.59..v2.1.4.60 --no-merges --pretty=format:"%h | %ad | %an | %s%d" --date=short > change.log` - в диапазоне тегов, с выгрузкой в файл "change.log"

Краткий лог по всем коммитам исключая merge-коммиты:
* `git log --no-merges --pretty=format:"%h | %ad | %an | %s%d" --date=short`
* `git log --no-merges --pretty=format:"%h | %ad | %an | %s%d" --date=short > change.log` - с выгрузкой в файл "change.log"

Вывод истории изменений для отчета бизнесу. Нижняя граница исключается, верхняя - включается:
* `git log 07885d5..01e1ae5 --no-merges --pretty=format:"##COMMIT##%n%h%n%ad%n%an%n%s%n%d%n%b%n##FILES##" --name-status > change.log` - в диапазоне коммитов, в файл.
* `git log v2.1.4.59..v2.1.4.60 --no-merges --pretty=format:"##COMMIT##%n%h%n%ad%n%an%n%s%n%d%n%b%n##FILES##" --name-status > change.log` - в диапазоне тегов, в файл.

## Переход по коммитам

Перенос указателя на конкретный коммит:

`git checkout 66236fd` 

Возврат к последнему коммиту:
* `git checkout -` - после однократного перехода
* `git checkout <branch name>`

## Команды отмены

Изменение последнего коммита:

`git commit --amend`

Позволяет увидеть даже объединенные коммиты командой `--amend`:

`git reflog`

Отменить добавление в индекс:

`git restore --staged file.txt`

Отменить изменения в рабочем каталоге:

`git restore file.txt` или `git checkout -- file.xtx`

## Удаленные репозитории

Показать к каким удаленным репозиториям подключен локальный:

`git remote` или расширенная версия `git remote -v`

Подключить локальный репозизиторий к удаленному:

`git remote add [remote-name] [Удаленный_путь]`

Пример:
`git remote add 1336 git@github.com:1336/libgit2.git`

Получить изменения из удаленного репозитория:

`git fetch [remote-name]`

`git fetch --all`

Получить и слить изменения из удаленного репозитория:

`git push [remote-name] [branch-name]`

Просмотреть удаленный репозиторий

`git remote show origin`

Изменить remote-name:

`git remote rename remote-name new-remote-name`

Удалить у себя удаленный репозиторий:

`git remote rm remote-name`

## Работа с тегами
Теги бывают **легковесными** и **аннотированными**.

Просмотр всех тегов

`git tag`

Флаги:
* `-l` - фильтр по тегам. Пример: `git tag -l "v1"`
* `-a` - создание аннотированного тега
* `-m` - комментарий аннотированного тега
* `-d` - удаление тега в локальном репозитории

Создание аннотированного тега:

`git tag -a v0.0.1 -m "Комментарий тега"`

Создание легковесного тега:

`git tag v0.0.2`

Тегитирование существующего коммита:

`git tag -a v0.0.3 9fceb02 -m "Коммит тега"`

Просмотр информации о коммите тега:

`git show v0.0.1`

Отправка тегов в удаленный репозиторий:

`git push origin v0.0.1` или все `git push origin --tags`

Удаление тега в локальном репозитории:

`git tag -d v0.0.1`

Удаление тега в удаленном репозитории:

`git push origin --delete <tagname>`

Создать ветку от определенного коммита:

`git switch -c <branch_name> <tagname>`

Создать ветку от текущего коммита:

`git switch -c <branch_name>`
