# 卡拉API文档

## 服务器地址

卡拉具有两个版本的API，且两个版本的API同时都在运行。一般来说，两个版本的API返回值是完全相同的。但是一个API仅仅用于调试，另一个则用于生产部署。

其中，用于调试的API地址仅允许`http://localhost:8001`的跨域JS访问。用于生产的API仅允许`https://kahla.app.aiursoft.com`的跨域JS访问。

如果你是卡拉的客户端贡献者，请注意在调试环境使用调试API，生产环境使用生产API。

API地址分别是：

* 调试API：    <https://kahla.server.aiursoft.com/debugapi>
* 生产API：    <https://kahla.server.aiursoft.com/api>

文档之后的请求地址，均表示在上面的API地址后增加的内容。

## 身份认证

卡拉的服务器采用了HTTP Authorization头进行身份认证。也就是说，在访问所有需要登录权限的API时，必须增加自定义HTTP头：

    Authorization:Bearer {Credential}

其中，`Credential`值为你在登录时获取到的凭据。

## API目录

* [密码认证](#密码认证)
* [注册账号](#注册账号)
* [查询登录状态](#查询登录状态)

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

```json
{
    "value": "FS1S6CV0BASLHWUVE87851PN8GRZNJ",
    "code": 0,
    "message": "Auth success."
}
```

错误返回值示例：

```json
//用户名或密码错误
{
    "code": -8,
    "message": "Incorrect username or password."
}
```

```json
//参数不符合规范
{
    "items": [
        "The Email field is not a valid e-mail address."
    ],
    "code": -10,
    "message": "Your input contains several errors!"
}
```

### 注册账号

请求地址：

    /RegisterKahla

方法

    HTTP POST

表单：

    Email={Kahla Users Email}&Password={User Password}&ConfirmPassword={Confirm password}

表单编码：

    x-www-form-urlencoded

接口说明：

    本接口能够允许卡拉的用户进行注册。注册后，用户将自动授权卡拉访问他的Aiursoft账号接口。

返回值示例：

```json
{
    "code": 0,
    "message": "Successfully created your account."
}
```

错误返回值示例：

```json
//参数不符合规范
{
    "items": [
        "The Email field is not a valid e-mail address."
    ],
    "code": -10,
    "message": "Your input contains several errors!"
}
```

### 查询登录状态

请求地址：

    /SigninStatus

方法

    HTTP GET

接口说明：

    本接口能够查询当前用户的登录状态。请注意增加文档开头部分提到的HTTP头。

返回值示例：

```json
{
    "value": true,
    "code": 0,
    "message": "Successfully get your signin status."
}
```