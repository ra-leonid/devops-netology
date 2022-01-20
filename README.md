# devops-netology

## В папке terraform будут игнорироваться файлы:
- все файлы имеющие одного из родителей ".terraform"
- все файлы с расширением "tfstate"
- все файлы с любым расширением если в имени файла есть подстрока ".tfstate."
- файлы crash.log либо файлы начинающиеся на "crash." и заканчивающиеся на ".log"
- все файлы с расширением "tfvars"
- файлы "override.tf" и "override.tf.json"
- файлы заканчивающиеся на "_override.tf", "_override.tf.json"
- файлы ".terraformrc", "terraform.rc"
