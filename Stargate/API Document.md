# 星门API文档

### 查询我的所有频道

请求地址：

    /Channel/ViewMyChannels?AccessToken=eaae66eae336cbd56bb48dbd810f1551

方法：  

    HTTP GET

接口说明：

    本接口能够针对一个App查询其所有频道。

返回值示例：

    {
        "appId": "6abfa8e1b43a99b36dc82acf57467787",
        "channel": [
            {
                "id": 1,
                "description": "Postman Channel",
                "connectKey": "70YYRYO4A18BV5UX6WNU",
                "createTime": "2018-01-23T15:13:41.5145618",
                "lifeTime": "23:59:59",
                "appId": "6abfa8e1b43a99b36dc82acf57467787"
            },
            {
                "id": 2,
                "description": "Postman Channel2",
                "connectKey": "R4J7OOVDAIDJPYYS6V35",
                "createTime": "2018-01-23T15:13:44.2688574",
                "lifeTime": "23:59:59",
                "appId": "6abfa8e1b43a99b36dc82acf57467787"
            }
        ],
        "code": 0,
        "message": "Successfully get your channels!"
    }

### 创建一个新的频道

请求地址：

    /Channel/CreateChannel

方法：  

    HTTP POST

表单：

    AccessToken={Your Access Token}&Description={Describe your channel}

表单编码：

    x-www-form-urlencoded

接口说明：

    本接口能够针对一个App创建一个新频道。其中，Description不是必需的参数。频道创建后会保留24小时。

返回值示例：

    {
        "channelId": 3,
        "connectKey": "SR943GQSQQ8ULRB6OHFJ",
        "code": 0,
        "message": "Successfully created your channel!"
    }

### 验证一个频道是否仍然存在

请求地址：

    /Channel/ValidateChannel?Id={Your ID}&Key={Connect Key}

方法：  

    HTTP GET

接口说明：

    本接口能够检查一个频道是否存在，以及是否能够使用特定Key连接。本接口不需要AccessToken。

返回值示例：

    // 频道存在且连接Key正确
    {
        "code": 0,
        "message": "Corrent Info."
    }

    // 频道存在但Key不正确
    {
        "code": -8,
        "message": "Wrong connection key!"
    }

    // 频道不存在
    {
        "code": -4,
        "message": "Can not find your channel!"
    }

### 在特定频道推送一条消息

请求地址：

    /Message/PushMessage

方法：  

    HTTP POST

表单：

    AccessToken={Your Access Token}&ChannelId={Target Channel Id}&MessageContent={Some Text Or Json Or XML}

表单编码：

    x-www-form-urlencoded

接口说明：

    本接口能够向特定频道推送特定内容的消息。内容可以是任意类型。注意，参数请进行URL编码。

返回值示例：

    {
        "code": 0,
        "message": "You have successfully created a message at channel:2!"
    }

### 收听一个频道

请求地址：

    ws://stargate.aiursoft.com/Listen/Channel/{Your Channel Id}?Key={Connect Key}

请求方法：

    WebSocket

注意：
    如果你的站点已经支持了HTTPS，建议将地址中的`ws`改为`wss`。目前星门同时支持`ws`和`wss`。

说明：

使用WebSocket连接后，所有该频道的消息都会通过WebSocket的onmessage事件被客户端触发。请参考[前端调用方法](https://github.com/AiursoftWeb/Stargate/blob/master/src/Views/Home/Test.cshtml)。

## 反馈或建议修改API

[Github](https://github.com/AiursoftWeb/Stargate)