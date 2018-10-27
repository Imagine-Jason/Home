# 卡拉API文档

## 服务器地址

卡拉的服务器共有三台。

| 服务器地址                                | 允许跨域                               | 是否限制Cookie | 分支   | 用途                               | 对应卡拉客户端分支 |
|-------------------------------------------|----------------------------------------|----------------|--------|------------------------------------|--------------------|
| https://kahla.server.aiursoft.com         | https://kahla.app.aiursoft.com         | 是             | master | 承载生产版本卡拉客户端的数据通讯   | master             |
| https://staging.kahla.server.aiursoft.com | https://staging.kahla.app.aiursoft.com | 是             | dev    | 承载预部署版本卡拉客户端的数据通讯 | dev                |
| https://dev.kahla.server.aiursoft.com     | http://localhost:8001                  | 否             | dev    | 用于开发者本机调试                 | 开发者本地         |

如果你是卡拉的客户端贡献者，请注意在调试环境使用调试API，在预部署环境使用域部署API，在生产环境使用生产API。

文档之后的请求地址，均表示在上面的API地址后增加`/api`的内容。

## 身份认证

卡拉的服务器采用了基于Cookie的身份认证。也就是说，在访问所有需要登录权限的API时，必须携带所有Cookie。

## API目录

* [API根](#API根)
* [检查更新](#检查更新)
* [密码认证](#密码认证)
* [向会话上传文件](#向会话上传文件)
* [下载会话中的文件](#下载会话中的文件)
* [注册账号](#注册账号)
* [查询登录状态](#查询登录状态)
* [查询个人资料](#查询个人资料)
* [修改个人资料](#修改个人资料)
* [修改密码](#修改密码)
* [查看我的好友列表](#查看我的好友列表)
* [删除一位好友](#删除一位好友)
* [完成好友请求](#完成好友请求)
* [查看向我发送的所有好友请求](#查看向我发送的所有好友请求)
* [搜索好友](#搜索好友)
* [搜索群](#搜索群)
* [获取一个会话下的所有消息](#获取一个会话下的所有消息)
* [发送消息](#发送消息)
* [创建群组](#创建群组)
* [加入群组](#加入群组)
* [离开群组](#离开群组)

### API根

请求地址:
    /

方法

    HTTP GET

接口说明

    该API能够显示服务器时间和当前用户状态。用于在开发时方便调试使用。

    另一方面，假若该API无法访问，证明卡拉的服务器遇到了严重故障。因此它可以被用作网络状态检测。

返回值示例：

```json
{
    "code": 0,
    "message": "Welcome to Aiursoft Kahla API!",
    "wikiPath": "https://wiki.aiursoft.com",
    "serverTime": "2018-09-19T23:38:24.831322+08:00",
    "utcTime": "2018-09-19T15:38:24.8318556Z",
    "authenticated": false
}
```

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

### 向会话上传文件

请求地址

    /UploadFile

方法

    HTTTP Post

表单

    表单中必须包含一个文件，其在表单中的名称不限，但我们推荐使用`file`作为其表单名称。

    文件大小不得小于1b，不得超过1000MB。

参数说明：

|参数名称|参数类型|参数含义|
|--|--|--|
|ConversationId|int|要将文件发布到的会话。注意，会话必须存在，并且当然用户已经加入会话！|

表单编码

    multipart/form-data

接口说明

    本接口允许用户上次一个本地的自定义文件，将其存储在卡拉所使用的对象存储服务中。

    在最新版本的API中，将不再返回其公网地址。文件将会被保存在卡拉的私有仓库中，因此无法通过公网URL下载会话中的文件

    本接口可以应用在图片发送和文件发送功能上。

    虽然此API要求了会话ID，并且调用此API能够成功将文件上传，但是并不会在该会话中创建一条消息，也不会在该会话中向参与者推送通知。

    我们建议在调用完成此API后，再通过客户端软件立即调用发送消息API，将取得的文件ID作为消息发送到服务器。

>注意: 文件**仅能保留20天**，超过20天后文件记录会被直接删除！调用后续的下载API可能会因此产生严重错误！。

返回值示例

```json
{
    "value": "https://oss.aiursoft.com/Userfiles/e27bb7e01c534f8796118e16af34ea99.png",
    "message": "Successfully uploaded your file!",
    "code": 0,
    "fileKey": 345,
    "savedFileName": "myfile.png"
}
```

### 下载会话中的文件

请求地址

    /FileDownloadAddress

方法

    HTTTP Post

参数说明：

|参数名称|参数类型|参数含义|
|--|--|--|
|FileKey|int|要生成下载地址的文件ID。文件必须存在，并且文件上传时所记录的Conversation必须已经被当前用户加入。|

接口说明

    本API能够将特定文件生成一次性下载URL。

    为了保证文件安全，也就是未授权的用户不得根据URL直接下载会话中的文件，卡拉将所有对象作为私有存储。当需要下载私有存储中的资源时，必须先生成一次性下载URL。

    注意：每个文件在上传时都已经记录了其上传到的目标conversation ID。其会话必须要求当前用户已经加入才能调用此API。假若用户加入了某个群，取得了群内的文件ID，那么当用户离开该群后，他将不再可以通过此API下载文件。

    注意：向会话中上传的文件过期时间为20天。超过20天的文件将会被自动删除。调用此API可能会返回严重错误。

    注意：本API返回的下载地址仅能请求一次，其就将会被作废！务必在用户每次尝试下载时都调用此API生成一次性下载链接！

返回值示例

```json
{
    "code": 0,
    "message": "Successfully generated your file download address!",
    "fileName": "myfile.png",
    "DownloadPath": "https://oss.aiursoft.com/Download/FromSecret?Sec=asdfasdf"
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

    NickName={Kahla Users NickName}&Bio={User Bio}&HeadImgUrl={Head Image Url}

参数说明：

    NickName最大长度为20，必填；
    Bio最大长度为80，必填，但是允许为空值。
    HeadImgUrl必须为URL格式，选填。

表单编码：

    x-www-form-urlencoded

接口说明：

    本接口能够允许卡拉的用户修改他们的基本信息。

    无论如何，调用本API都会更新用户的昵称。
    无论如何，调用本API都会更新用户的Bio，但是Bio允许为空。
    如果调用时填写了HeadImgUrl，就会更新头像地址。否则不会更新。

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

### 修改密码

请求地址：

    /ChangePassword

方法：

    HTTP POST

表单：

    OldPassword={Old Password}&NewPassword={New Password}&RepeatPassword={Repeat Password}

参数说明：

    OldPassword为旧密码，必填，6到32位
    NewPassword为用户输入的新密码，必填，6到32位
    RepeatPassword为用户输入的新密码，必填，6到32位

表单编码：

    x-www-form-urlencoded

接口说明：

    本接口能够允许卡拉的用户修改密码。

返回值示例：

```json
{
    "code": 0,
    "message": "Successfully changed your password!"
}
```

错误返回值示例：

```json
//参数不符合规范
{
    "items": [
        "The field NewPassword must be a string or array type with a minimum length of '6'."
    ],
    "code": -10,
    "message": "Your input contains several errors!"
}
```

```json
//旧密码错误
{
    "code": -1,
    "message": "Incorrect password."
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

### 查看向我发送的所有好友请求

请求地址

    /MyRequests

请求方法

    HTTP GET

接口说明

    该接口将返回所有向当前用户发送的好友请求。

返回值示例

```json
{
    "items": [
        {
            "id": 27,
            "creatorId": "fe4a3b24-6dfe-4ded-9ad0-e9c4cdf8971f",
            "creator": {
                "id": "fe4a3b24-6dfe-4ded-9ad0-e9c4cdf8971f",
                "bio": null,
                "nickName": "f",
                "sex": null,
                "headImgUrl": "https://cdn.aiursoft.com/images/userdefaulticon.png",
                "preferedLanguage": "en",
                "accountCreateTime": "2018-09-17T02:26:55.0295973Z",
                "emailConfirmed": false,
                "email": "f@f.com"
            },
            "targetId": "6da0802e-18e4-4a76-99a5-47878dd7b8a5",
            "createTime": "2018-09-18T07:13:33.0303038Z",
            "completed": true
        },
        {
            "id": 23,
            "creatorId": "e96bedf3-c4d6-4fbe-bc1d-ee8ba05b9892",
            "creator": {
                "id": "e96bedf3-c4d6-4fbe-bc1d-ee8ba05b9892",
                "bio": null,
                "nickName": "1638255601",
                "sex": null,
                "headImgUrl": "https://cdn.aiursoft.com/images/userdefaulticon.png",
                "preferedLanguage": "en",
                "accountCreateTime": "2018-09-17T02:20:53.9664403Z",
                "emailConfirmed": false,
                "email": "1638255601@qq.com"
            },
            "targetId": "6da0802e-18e4-4a76-99a5-47878dd7b8a5",
            "createTime": "2018-09-17T02:22:13.007078Z",
            "completed": true
        }
    ],
    "code": 0,
    "message": "Successfully get your requests list."
}
```

### 搜索好友

请求地址

    /SearchFriends

请求方法

    HTTP GET

参数说明

|参数名称|参数类型|参数含义|
|--|--|--|
|NickName|string|要搜索的用户NickName，至少1字符，但是我们建议在用户输入至少输入3字符后再调用此API，除非用户强制要求开始搜索1-3字符的内容|
|Take|number|搜索结果最大范围。用于客户端分页|

接口说明

    该接口允许用户搜索所有用户中NickName包含传入值的结果。

返回值示例

```json
{
    "items": [
        {
            "id": "2f1093e7-2375-4824-ab3f-c0116d8b15b9",
            "bio": "Yeah, chairman for life!",
            "nickName": "test1",
            "sex": null,
            "headImgUrl": "https://oss.aiursoft.com/Userfiles/3eb842ac777c44e48532cd744dad4a4e.jpg",
            "preferedLanguage": "en",
            "accountCreateTime": "2018-08-22T15:08:45.6682833Z",
            "emailConfirmed": false,
            "email": "test@test.test"
        },
        {
            "id": "736a7281-8cf3-4916-b78d-9dc974450342",
            "bio": null,
            "nickName": "test2",
            "sex": null,
            "headImgUrl": "https://cdn.aiursoft.com/images/userdefaulticon.png",
            "preferedLanguage": "en",
            "accountCreateTime": "2018-09-17T02:27:01.4267586Z",
            "emailConfirmed": false,
            "email": "test@qq.com"
        }
    ],
    "code": 0,
    "message": "Search result is shown."
}
```

### 搜索群

请求地址

    /SearchGroup

请求方法

    HTTP GET

参数说明

|参数名称|参数类型|参数含义|
|--|--|--|
|GroupName|string|要搜索的群名称，至少3字符。|

接口说明

    该接口允许调用者按照群名称搜索一个群。

返回值示例

```json
{
    "items": [
        {
            "users": null,
            "groupImage": "https://cdn.aiursoft.com/images/appdefaulticon.png",
            "groupName": "eee",
            "id": 1,
            "discriminator": "GroupConversation",
            "aesKey": "b80eda4f25ae4d1b88abb710c2bc28a4",
            "conversationCreateTime": "2018-09-19T16:30:13.9892511",
            "displayName": null,
            "displayImage": null
        }
    ],
    "code": 0,
    "message": "Search result is shown."
}
```

### 获取一个会话下的所有消息

请求地址

    /GetMessage

方法

    HTTP GET

参数列表

|参数名称|参数类型|参数含义|
|--|--|--|
|id|number|目标会话的ID|
|take|number|返回值获取的最大消息数量|

接口说明

    该接口能够返回一个特定会话下的所有消息，无论是已读消息还是未读消息。

    当未传递take参数时，会仅显示最新的15条消息，按发送时间排序。如果指定了take，会显示最新的`take`条消息，按发送时间排序。

    注意：该接口会将所有消息设为已读！

返回值示例

```json
{
    "items": [
        {
            "id": 584,
            "conversationId": 30,
            "senderId": "2f1093e7-2375-4824-ab3f-c0116d8b15b9",
            "sender": {
                "id": "2f1093e7-2375-4824-ab3f-c0116d8b15b9",
                "bio": "Yeah, chairman for life!",
                "nickName": "test",
                "sex": null,
                "headImgUrl": "https://oss.aiursoft.com/Userfiles/3eb842ac777c44e48532cd744dad4a4e.jpg",
                "preferedLanguage": "en",
                "accountCreateTime": "2018-08-22T15:08:45.6682833Z",
                "emailConfirmed": false,
                "email": "test@test.test"
            },
            "sendTime": "2018-09-20T02:15:46.6706281Z",
            "content": "U2FsdGVkX185RThnO1g63f8wBBPtQ8qCrboRiHB2jeVjoSxra+Nwr5TBGGl2cumSwczXj2490fpQIzhuhHi4Oy3gq9Tsk9YiuCXXtzPmlPM=",
            "read": true
        },
        {
            "id": 593,
            "conversationId": 30,
            "senderId": "6da0802e-18e4-4a76-99a5-47878dd7b8a5",
            "sender": {
                "id": "6da0802e-18e4-4a76-99a5-47878dd7b8a5",
                "bio": "let today = new beginning();",
                "nickName": "Anduin Xue",
                "sex": null,
                "headImgUrl": "https://oss.aiursoft.com/UserIcon/2ccdfcbd814d4a9781cbc3b3f047f6ef.png",
                "preferedLanguage": "en",
                "accountCreateTime": "2018-07-03T23:29:38.9450153Z",
                "emailConfirmed": false,
                "email": "anduin@aiursoft.com"
            },
            "sendTime": "2018-09-21T04:23:14.2177076Z",
            "content": "U2FsdGVkX1+XMLYLTehAWnZmVEZX2MTR1K7B6CdHDas=",
            "read": true
        }
    ],
    "code": 0,
    "message": "Successfully get all your messages."
}
```

错误返回值示例

```json
{
    "code": -8,
    "message": "You don't have any relationship with that conversation."
}
```

### 发送消息

请求地址

    /SendMessage

方法

    HTTP POST

表单

    Id={Conversation Id}&Content={Message Content}

表单编码

    x-www-form-urlencoded

参数说明

|参数名称|参数类型|参数含义|
|--|--|--|
|Id|number|会话的ID|
|Content|string|要发送的消息的内容|

接口说明

    本接口向目标会话发送一条消息。

返回值示例

```json
{"code":0,"message":"Your message has been sent."}
```

### 创建群组

请求地址：

    /CreateGroupConversation

方法：

    HTTP POST

表单：

    GroupName={new group name}

表单编码：

    x-www-form-urlencoded

参数说明：

|参数名称|参数类型|参数含义|
|--|--|--|
|GroupName|string|新的群组名称。该名称是全局唯一的。长度在3到25字范围内，允许有空格。|

接口说明：

    本接口能够新建一个群组，并将当前用户加入到该群组中。

    任意两个群组不允许具有相同名称。

返回值示例：

```json
{
    "code": 0,
    "value" : 1234,
    "message": "You have successfully created a new group and joined it!"
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
//已存在同名群组
{
    "code": -7,
    "message": "A group with name: GroupName was already exists!"
}
```

### 加入群组

请求地址

    /JoinGroup

方法

    HTTP POST

表单

    GroupName={target group name}

表单编码

    x-www-form-urlencoded

参数说明

|参数名称|参数类型|参数含义|
|--|--|--|
|GroupName|string|群组名称。该名称是全局唯一的。长度在5到25字范围内。|

接口说明

    本接口能够当前用户加入到该群组中。

返回值示例

```json
{
    "code": 0,
    "message": "You have successfully joint the group: groupName!"
}
```

错误返回值示例：

```json
//已经加入
{
    "code": -6,
    "message": "You have already joined the group: groupName!"
}
```

```json
//目标群组不存在
{
    "code": -4,
    "message": "We can not find a group with name: groupName!"
}
```

### 离开群组

请求地址：

    /LeaveGroup

方法：

    HTTP POST

表单：

    GroupName={target group name}

表单编码：

    x-www-form-urlencoded

参数说明：

|参数名称|参数类型|参数含义|
|--|--|--|
|GroupName|string|群组名称。该名称是全局唯一的。长度在5到25字范围内。|

接口说明：

    本接口能够使当前用户离开目标群组。如果当前用户是该群组的最后一位用户，该群组将自然被删除。

返回值示例：

```json
{
    "code": 0,
    "message": "You have successfully leaved the group: groupName!"
}
```

错误返回值示例：

```json
//当前用户并未加入
{
    "code": -6,
    "message": "You did not joined the group: groupName at all!"
}
```

```json
//目标群组不存在
{
    "code": -4,
    "message": "We can not find a group with name: groupName!"
}
```
