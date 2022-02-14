### 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
**Команда**: `git show aefea`

**Ответ**: `aefead2207ef7e2aa5dc81a34aedf0cad4c32545`

### 2. Какому тегу соответствует коммит 85024d3?
**Команда**: `git show 85024d3`

**Ответ**: `tag: v0.12.23`

### 3. Сколько родителей у коммита b8d720? Напишите их хеши.
**Команда**: `git show b8d720`

**Ответ**: 2 родителя, `56cd7859e 9ea88f22f`

### 4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
**Команда**:git log v0.12.23..v0.12.24 --oneline

**Ответ**:
```33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release
```

### 5.Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
**Команда**: `git log -S'func providerSource(' --oneline`

**Ответ**: `8c928e835 main: Consult local directories as potential mirrors of providers`

### 6. Найдите все коммиты в которых была изменена функция globalPluginDirs.

Ищем файл функции: `git grep 'func globalPluginDirs(.*)'`

**Ответ**: `plugins.go`

Ищем изменения: `git log -L :globalPluginDirs:plugins.go`

**Ответ**:
```78b12205587fe839f10d946ea3fdc06719decb05
52dbf94834cb970b510f2fba853a5b49ad9b1a46
41ab0aef7a0fe030e84018973a64135b11abcd70
66ebff90cdfaa6938f26f908c7ebad8d547fea17
8364383c359a6b738a436d1b7745ccdce178df47
```
### 7. Кто автор функции synchronizedWriters?
**Команда**: `git log -S'func synchronizedWriters(' --pretty=format:'%h - %an'`

**Ответ**: `Martin Atkins`

