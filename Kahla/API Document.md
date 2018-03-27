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

其中，`Credential`值为当前用户在登录时获取到的凭据。

## API目录

* [检查更新](#检查更新)
* [密码认证](#密码认证)
* [注册账号](#注册账号)
* [查询登录状态](#查询登录状态)
* [查询个人资料](#查询个人资料)
* [修改个人资料](#修改个人资料)
* [查看我的好友列表](#查看我的好友列表)
* [删除一位好友](#删除一位好友)
* [完成好友请求](#完成好友请求)

### 检查更新

请求地址：

    /Version

方法

    HTTP GET

接口说明：

    本接口提供了Kahla的客户端版本检查更新功能。

    服务器支持的最新版本为`latestVersion`，其中第一个单位为主发布号，第二个单位为版本号，第三个单位为更新号。

    服务器支持的最老版本为`oldestSupportedVersion`，其中第一个单位为主发布号，第二个单位为版本号，第三个单位为更新号。

    当客户端软件不是最新时，应立即询问用户是否下载新版本。若用户同意，则将用户重定向到`downloadAddress`。

    当客户端软件已经低于最低的支持版本时，强制将用户重定向到`downloadAddress`。

返回值示例：

```json
{
    "latestVersion": "0.7.0",
    "oldestSupportedVersion": "0.7.0",
    "downloadAddress": "https://kahla.aiursoft.com",
    "code": 0,
    "message": null
}
```

### 密码认证

请求地址：

    /AuthByPassword

方法：

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

方法：

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

方法：

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

### 查询个人资料

请求地址：

    /Me

方法：

    HTTP GET

接口说明：

    本接口能够查询当前用户的个人资料。

返回值示例：

```json
{
    "value": {
        "id": "a75dff34-35d0-451d-bae3-af3c206bbc6b",
        "email": "anduin@aiursoft.com",
        "emailConfirmed": false,
        "bio": null,
        "nickName": "Anduin Xue",
        "sex": null,
        "headImgUrl": "https://oss.aiursoft.com/UsersIcon/9XNNIJF9RB.jpg",
        "preferedLanguage": "en",
        "accountCreateTime": "2018-02-09T15:09:23.1468265"
    },
    "code": 0,
    "message": "Successfully get your information."
}
```

错误返回值示例:

```json
{
    "code": -8,
    "message": "Unauthorized!"
}
```

### 修改个人资料

请求地址：

    /UpdateInfo

方法：

    HTTP POST

表单：

    NickName={Kahla Users NickName}&Bio={User Bio}

参数说明：

    NickName最大长度为20，必填；
    Bio最大长度为80，选填。

表单编码：

    x-www-form-urlencoded

接口说明：

    本接口能够允许卡拉的用户修改他们的基本信息。

返回值示例：

```json
{
    "code": 0,
    "message": "Successfully set your personal info."
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

### 查看我的好友列表

请求地址：

    /MyFriends?orderByName={true | false}

方法：

    HTTP GET

参数列表：

|参数名称|参数类型|参数含义|
|--|--|--|
|orderByName|boolean|若为false，则按照最后一条消息的时间逆序排序。若为true，则按照姓名排序|

返回值示例:

```json
{
    "items": [
        {
            "displayName": "1461767262",
            "displayImage": "https://developer.aiursoft.com/images/appdefaulticon.png",
            "latestMessage": "[img]https://oss.aiursoft.com/UserFile/R7ZXD084K0.jpg",
            "latestMessageTime": "2018-02-23T16:29:37.6693943",
            "unReadAmount": 0,
            "conversationId": 3,
            "discriminator": "PrivateConversation",
            "userId": "f61adb9f-b2db-4ad4-92a5-1a7243d6df23"
        },
        {
            "displayName": "2224877382",
            "displayImage": "https://developer.aiursoft.com/images/appdefaulticon.png",
            "latestMessage": "你好\n",
            "latestMessageTime": "2018-03-11T11:37:04.998852",
            "unReadAmount": 0,
            "conversationId": 14,
            "discriminator": "PrivateConversation",
            "userId": "03f1e915-359b-4d69-8bc9-253bfef4690f"
        },
        {
            "displayName": "2539820590",
            "displayImage": "https://developer.aiursoft.com/images/appdefaulticon.png",
            "latestMessage": "Hello\n",
            "latestMessageTime": "2018-03-11T19:51:42.804566",
            "unReadAmount": 0,
            "conversationId": 7,
            "discriminator": "PrivateConversation",
            "userId": "bcf156f0-d4be-436c-8e4b-d1faa72754e9"
        }
    ],
    "code": 0,
    "message": "Successfully get all your friends."
}
```

错误返回值示例：

```json
{
    "items": [
        "The value 'unknown' is not valid."
    ],
    "code": -10,
    "message": "Your input contains several errors!"
}
```

### 删除一位好友

请求地址：

    /DeleteFriend

方法：

    HTTP POST

表单：

    Id={Target User Id}

表单编码：

    x-www-form-urlencoded

接口说明：

    本接口能够删除一位好友。

返回值示例：

```json
{
    "code": 0,
    "message": "Successfully deleted your friend relationship."
}
```

错误返回值示例：

```json
//未授权
{
    "code": -8,
    "message": "Unauthorized!"
}
```

```json
//目标用户不存在
{
    "code": -4,
    "message": "We can not find target user."
}
```

```json
//目标用户存在，但你们根本不是好友
{
    "code": -7,
    "message": "He is not your friend at all."
}
```

### 创建好友请求

请求地址：

    /CreateRequest

方法：

    HTTP POST

表单：

    Id={Target User Id}

表单编码：

    x-www-form-urlencoded

接口说明：

    本接口能够向目标用户发起好友申请。

    在目标用户处理前，一位用户只能发送一次好友申请。

返回值示例：

```json
{
    "code": 0,
    "message": "Successfully created your request!"
}
```

错误返回值示例：

```json
//未授权
{
    "code": -8,
    "message": "Unauthorized!"
}
```

```json
//目标用户不存在
{
    "code": -4,
    "message": "We can not find your target user!"
}
```

```json
//目标用户就是当前用户
{
    "code": -3,
    "message": "You can't request yourself!"
}
```

```json
//存在未处理的请求
{
    "code": -6,
    "message": "There are some pending request hasn't been completed!"
}
```

```json
//你们已经是好友了
{
    "code": -6,
    "message": "You two are already friends!"
}
```

### 完成好友请求

请求地址：

    /CompleteRequest

方法：

    HTTP POST

表单：

    Id={Request Id}&Accept={true|false}

表单编码：

    x-www-form-urlencoded

参数说明：

|参数名称|参数类型|参数含义|
|--|--|--|
|Id|int|要完成的请求的Id，注意不是用户Id|
|Accept|boolean|是否同意。如果需要接受好友请求，应设为true。否则应为false|

接口说明：

    本接口能够完成一个目标用户为当前用户的好友请求。

    若接受了好友请求，那么将会把双方互相加入到对方的好友列表中。

    若拒绝了好友请求，不会有其它操作。

返回值示例：

```json
{
    "code": 0,
    "message": "You have successfully completed this request."
}
```

错误返回值示例：

```json
//未授权
{
    "code": -8,
    "message": "Unauthorized!"
}
```

```json
//找不到目标请求
{
    "code": -4,
    "message": "We can not find target request."
}
```

```json
//请求并不是在向当前用户请求
{
    "code": -8,
    "message": "The target user of this request is not you."
}
```

```json
//你在试图操作一个已经完成的请求
{
    "code": -6,
    "message": "The target request is already completed."
}
```

```json
//请求成功接受了，但这之前你们就已经是好友了
{
    "code": -3,
    "message": "You two are already friends."
}
```