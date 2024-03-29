# Домашнее задание к занятию "11.01 Введение в микросервисы"

## Задача 1: Интернет Магазин

Руководство крупного интернет магазина у которого постоянно растёт пользовательская база и количество заказов рассматривает возможность переделки своей внутренней ИТ системы на основе микросервисов. 

Вас пригласили в качестве консультанта для оценки целесообразности перехода на микросервисную архитектуру. 

Опишите какие выгоды может получить компания от перехода на микросервисную архитектуру и какие проблемы необходимо будет решить в первую очередь.

---
### Ответ:
Прежде всего необходимо определить, для чего мы хотим внедрить микросервисную архитектуру, какие задачи решить? Сам переход от монолита к микросервисам не должен являться самоцелью, он не решит всех проблем (а в какой-то части может и добавить). За него придется платить сложностью развития и эксплуатации системы.
Внедрение микросервисов может оказаться неоправданным, на ранних этапах становления организации, когда ещё не определена её структура. Такой подход скорее всего подходит более "зрелым" организациям, которые уже не могут мириться с недостатками монолита, тормозящими развитие информационной системы.

#### При грамотном проектировании архитектуры, можно получить следующие преимущества:
1. **Масштабируемость** - причем возможность масштабировать отдельные сервисы у которых есть в этом потребность. Также есть возможность более "точеного" выделения инфраструктурных ресурсов, только такого типа и только тем сервисам, где это требуется.
2. **Устойчивость к ошибкам** - само использование микросервисов не гарантирует что система будет устойчива к ошибкам. Но при грамотном архитектурном проектировании и реализации паттерна "устойчивости к ошибкам", система на микросервисах может стать таковой.
3. **Возможность использовать разные технологии** - для каждой задачи (микросервиса) можно подобрать наиболее оптимальный язык, инструмент, инфраструктуру на которой он будет функционировать максимально эффективно. Но, необходимо контролировать используемый стек технологий, чтобы система не стала слишком сложной.
4. **Простота развертывания** - при слабом связывании микросервисов, они будут менее зависимы друг от друга, а значит их можно будет развертывать с различной частотой и небольшими изменениями, с учетом потребностей конкретного сервиса. Такой подход позволяет нивелировать риски, которые присущи большим внедрениям монолитов, повысить скорость, частоту и надежность релизов.
5. **Простота замены** (по мне - так это частный случай использования различных технологий) - при необходимости, когда возможности технологии отдельного сервиса, достигли своих пределов, его можно реализовать на других технологиях.
6. **Отражение структуры организации** - не соглашусь с авторами, что это преимущество. Скорее всего - это требование предъявляемое к микросервисам, залог их успешного функционирования и развития. При проектировании системы на микросервисах, **необходимо** руководствоваться принципом, что сервис должен выполнять функцию одного из блоков (аспектов) финансово-хозяйственной деятельности организации. Нельзя мельчить - это слишком усложнит систему, но и слишком укрупнять тоже - это приведет к "внутренним" зависимостям внутри сервиса. Необходимо найти баланс.

#### Какие проблемы необходимо решить в первую очередь:
1. Как монолит разделить на микросервисы? Микросервисы должны обладать низкой свзязанностью и высоким сцеплением.Т.е. решать близкие по смыслу задачи и не сильно зависеть от других сервисов.
2. Какой использовать тип взаимодействия и протоколы интеграции между сервисами?
3. Какой использовать подход к безопасности во взаимодействии сервисов?
4. Кто будет являться владельцем сервиса (в части разработки, бизнес-функции)? 
   1. Сервис общий - изменяй кто хочешь
   2. За сервис отвечает конкретная команда и она его меняет
   3. Командна сервиса выступает в качестве ревьюеров, при изменении его разработчиками извне. 

---
### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---