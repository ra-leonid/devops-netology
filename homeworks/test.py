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
import os
import sys
from time import sleep
from github import Github, GithubException


title = sys.argv[1]
local_repo_path = sys.argv[2]
remote_repo_name = sys.argv[3]
branch_name = sys.argv[4]
token = sys.argv[5]

"""title = "commit for pull request"
local_repo_path = "/home/leonid/PycharmProjects/test"
remote_repo_name = "ra-leonid/test_pr_py"
branch_name = "iss53"
token = "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"
"""
branch_name = "iss59"

# Этап внесения изменений в каталог проекта
bash_command = [f'cd {local_repo_path}', "git checkout main"]
# TODO По правильному, нужно реализовать обработку корректно ли выполнилась команда, но по условию задачи это не требовалось ;-)
os.popen(' && '.join(bash_command))
sleep(1)
os.popen(f'git checkout -b {branch_name}')

print("Внесите необходимые изменения.")
input("Для продолжения нажмите Enter")

# Этап отправки изменений в локальный и удаленный репозиторий
bash_command = [f'cd {local_repo_path}', "git add .", f'git commit -m "{title}"', f'git push --set-upstream origin {branch_name}']
# TODO По правильному, нужно реализовать обработку корректно ли выполнилась команда, но по условию задачи это не требовалось ;-)
# os.popen(' && '.join(bash_command))
rez = os.popen('git add .')
rez = os.popen(f'git commit -m "{title}"')
rez = os.popen(f'git push --set-upstream origin {branch_name}')

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
