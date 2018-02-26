# 卡拉API文档

## 服务器地址

卡拉具有两个版本的API，且两个版本的API同时都在运行。一般来说，两个版本的API返回值是完全相同的。但是一个API仅仅用于调试，另一个则用于生产部署。

其中，用于调试的API地址仅允许`http://localhost:8001`的跨域JS访问。用于生产的API仅允许`https://kahla.app.aiursoft.com`的跨域JS访问。

如果你是卡拉的客户端贡献者，请注意在调试环境使用调试API，生产环境使用生产API。

API地址分别是：

* 调试API：    <https://kahla.server.aiursoft.com/debugapi>
* 生产API：    <https://kahla.server.aiursoft.com/api>

文档之后的请求地址，均表示在上面的API地址后增加的内容。

### 密码认证

请求地址：

    /AuthByPassword

方法

    HTTP POST

表单：

    Email={Kahla Users Email}&Password={User Password}

表单编码：

    x-www-form-urlencoded

接口说明：

    本接口能够允许卡拉的用户进行密码登录。在登录成功后，会返回一个形式为30位随机字符串的令牌。该令牌能够标识用户具有已登录的权限。令牌永不过期，这意味着客户端不需要，也不应当保存用户的密码。

返回值示例：

    {
        "value": "FS1S6CV0BASLHWUVE87851PN8GRZNJ",
        "code": 0,
        "message": "Auth success."
    }

