# Проект создания 1 ВМ Container Optimized со статическим IP адресом на YandexCloud

## Подготовка
1. Установить Terraform из зеркала Яндекса. [Подробнее тут](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart)
2. [Получить токен](https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token)
3. Создать файл `.auto.tfvars` в корне проекта

```sh
cp .auto.tfvars.example .auto.tfvars
```
4. Зарезервировать статический [IP адрес](https://cloud.yandex.ru/docs/vpc/operations/get-static-ip)
5. Указать все переменные в `.auto.tfvars`.
6. После успешного создания ВМ будет выдана строка для подключения. 

### Как узнать id зарезервированного статического адреса?

Используйте `yc cli`

```
yc vpc address list
+----------------------+------+---------------+----------+-------+
|          ID          | NAME |    ADDRESS    | RESERVED | USED  |
+----------------------+------+---------------+----------+-------+
| e9blfxxxxtvfgh145aun |      | xx.xx.xxx.xxx | true     | false |
+----------------------+------+---------------+----------+-------+
```

```
vm-info = {
  "connect" = "ssh  your_login@static_ip"
}
```

## Команды
`terraform init` - первоначальная инициализация.  
`terraform plan` - **всегда** использовать для проверки изменений.  
`terraform apply` - применение изменений.  
`terraform destroy` - удалить всю инфру.  `Удалит все, что было создано`   
`terraform refresh` - обновление состояния из инфры. Команда обновить файл состояния, код не будет затронут. Если не обновить код, то применения может отметить на инфре изменения, которые были сделаны без кода.

---

[Начало работы с Terraform](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart)  
[Подробную информацию о ресурсах провайдера смотрите в документации](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs)