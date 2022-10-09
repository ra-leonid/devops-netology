# Запуск playbook

```commandline
ansible-playbook -i inventory/test.yml site.yml
ansible-playbook -i inventory/test.yml site.yml --tags vector -vvv
ansible-playbook site.yml
```

Проверить корректность:
```commandline
ansible-lint site.yml
```


Показать переменные ansible:

```commandline
ansible localhost -m setup
```



# Работа с ролями

Инициализировать новую роль (Создать каталог с заполнением структуры):

```commandline
ansible-galaxy role init lighthouse-role
```
Скачать роли:

```commandline
ansible-galaxy install -r requirements.yml -p roles -f
```

# Molecule

Установка:
```commandline
 pip3 install "molecule==3.5.2" molecule_docker molecule_podman yamllint ansible-lint
```
Инициализировать новую роль (Создать каталог с заполнением структуры):

```commandline
molecule init role new_role
molecule init role --driver-name <driver> <rolename>
molecule init role --driver-name docker new_role
molecule init role --driver-name podman vector-role
```

Добавление драйвера тестирования к существующей роли:

```commandline
molecule init scenario <scenarioname> --driver-name <driver>
molecule init scenario docker --driver-name docker
molecule init scenario --driver-name docker
molecule init scenario podman --driver-name docker
```

Запуск тестирования:
```commandline
molecule test
molecule test --name centos7
molecule test -s docker
molecule test --destroy=never
molecule matrix <taskname>
molecule matrix -s <scenarioname> <taskname>
molecule <taskname>
```

# Печать значения переменной
```yaml
- name: Print var
  debug:
    var: repo_files

```

```yaml
---
- name: Find repo files
  ansible.builtin.find:
    paths: /etc/yum.repos.d
    file_type: file
    patterns: 'CentOS-*'
  register: repo_files

- name: replace line in file
  become: true
  replace:
    path: "{{ item.path }}"
    regexp: '^mirrorlist='
    replace: '#mirrorlist='
  loop:
    "{{ repo_files.files }}"

- name: replace line in file2
  become: true
  replace:
    path: "{{ item.path }}"
    regexp: '#baseurl=http://mirror.centos.org'
    replace: 'baseurl=http://vault.centos.org'
  loop:
    "{{ repo_files.files }}"

- name: Install vector rpm
  become: true
  ansible.builtin.dnf:
    update_cache: true
    disable_gpg_check: true
    name: ./vector.rpm
  notify: Start vector service
```

```yaml
platforms:
  - name: centos7
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
    command: /sbin/init
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    #privileged: true
  - name: centos8
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
    command: /sbin/init
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    #privileged: true
  - name: ubuntu
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
    command: /sbin/init
    privileged: true
    capabilities:
      - SYS_ADMIN
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
```

```commandline
git add . && git commit -m "Удалил лишний каталог" && git push && git tag -a 1.0.10 -m "08-ansible-05-testing molecule" && git push origin --tags
```

# TOX

Установка:
```commandline
pip3 install tox
```

```commandline
docker run --privileged=True -v /home/leonid/PycharmProjects/my_roles/vector-role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
```