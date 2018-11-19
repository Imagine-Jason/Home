# 卡拉API文档

## 服务器地址

卡拉的服务器共有三台。

| 服务器地址                                | 允许跨域                               | 限制Cookie | 分支   | 用途                               | 对应卡拉客户端 |
|-|-|-|-|-|-|
| server.kahla.app | https://web.kahla.app         | 是             | master | 承载生产版本卡拉服务器   | master |
| staging.server.kahla.app | https://staging.kahla.app | 是             | dev    | 承载预部署版本卡拉服务器 | dev |
| dev.server.kahla.app | http://localhost:8001                  | 否             | dev    | 用于开发者本机调试卡拉App                 | 本地 |

如果你是卡拉的客户端贡献者，请注意在调试环境使用调试API，在预部署环境使用域部署API，在生产环境使用生产API。

## 身份认证

卡拉的服务器采用了基于Cookie的身份认证。也就是说，在访问所有需要登录权限的API时，必须携带所有Cookie。

卡拉的客户端在运行时，必须工作在目标服务器所允许的跨域地址内，否则将无法携带Cookie。

## 通讯协议

卡拉的所有服务器通讯都使用强制HTTPS和HSTS协议。
