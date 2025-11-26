# IPC通信示例

## 介绍

本示例展示了如何使用[@ohos.rpc](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ipc-kit/js-apis-rpc.md) 相关接口，开发一个IPC客户端与服务端通信的完整示例。在此示例中仅演示如何传递字符串信息，若有除此之外接口的诉求，请自行参考接口文档中的示例代码。

## 效果预览

|客户端|服务端|结果|
|-------------------------|----------------------|----------------------|
|![](image/IPC_Client.png)|![](image/IPC_Stub.png)|![](image/result.png)

使用说明：

1. 点击 connectAbility 按钮进行连接服务端，获取到服务端的代理对象proxy，并在此时注册死亡监听，当服务端所在进程死亡时，会触发此监听，提示服务端已死亡，并断开连接服务端；
2. 点击 sendRequest_string 按钮传递字符串信息至服务端，服务端会收到这次传递的字符串（'hello world'）,并返回字符串（'hello rpc'）到客户端，代表此次通信结束；
3. 点击 disconnectAbility 按钮断开连接服务端。

## 工程目录

1. 客户端-IPC_Client

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets       
|---entrybackupability
|   |---EntryBackupAbility.ets       
|---pages
|   |---Index.ets    // 页面布局、客户端实现                              
```

2. 服务端-IPC_Service

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets       
|---entrybackupability
|   |---EntryBackupAbility.ets     
|---pages
|   |---Index.ets
|---serviceeextability          
|   |---ServiceExtAbility.ets   // 服务端实现    
```

以上工程目录中未进行说明的部分，是默认工程目录结构，并未进行修改。

## 具体实现

1. 创建ServiceExtensionAbility，实现服务端

  ```ets
    // 定义服务端
    class Stub extends rpc.RemoteObject {
      constructor(descriptor: string) {
        super(descriptor);
      }
      onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence, option: rpc.MessageOption): boolean | Promise<boolean> {
        // 服务端Stub根据不同的请求code分别执行对应的处理流程
        if (code == 1) {
          let str = data.readString();
          hilog.info(0x0000, 'testTag', 'IPCStub: stub receive str : ' + str);
          // 服务端使用reply回传请求处理的结果给客户端
          reply.writeString('hello rpc');
          return true;
        } else {
          hilog.info(0x0000, 'testTag', 'IPCStub: stub unknown code: ' + code);
          return false;
        }
      }
    }

    // 定义后台服务
    export default class ServiceAbility extends ServiceExtensionAbility {
      // ......

       onConnect(want: Want): rpc.RemoteObject {
         hilog.info(0x0000, 'testTag', 'IPCStub: onConnect');
         // 返回Stub对象，客户端获取后便可以与ServiceExtensionAbility进行通信
         return new Stub('IPCStubTest');
       }

      // ......
    }
  ```

2. 客户端连接服务

  ```ets
    function connectAbility(context:common.UIAbilityContext) {
      hilog.info(0x00000, 'testTag', 'IPCClient: begin to connect Ability');

      let connect: common.ConnectOptions = {
        onConnect: (elementName, remoteProxy) => {
          hilog.info(0x00000, 'testTag', 'IPCClient: onConnect. elementName is :' + JSON.stringify(elementName));
          proxy = remoteProxy;
          // 客户端注册死亡监听
          try {
            proxy.registerDeathRecipient(deathRecipient, 0);
            hilog.info(0x00000, 'testTag', 'IPCClient: registerDeathRecipient success');
          }catch (err) {
            let code = (err as BusinessError).code;
            let message = (err as BusinessError).message;
            hilog.error(0x0000, 'testTag', 'IPCClient: registerDeathRecipient failed, code is ' + code + ', message is ' + message);
          }
        },
        onDisconnect: (elementName) => {
          hilog.info(0x0000, 'testTag', 'IPCClient: onDisconnect. elementName is :' + JSON.stringify(elementName));
          // 客户端移除死亡监听
          try {
            proxy?.unregisterDeathRecipient(deathRecipient, 0);
            hilog.info(0x00000, 'testTag', 'IPCClient: unregisterDeathRecipient success');
          }catch (err) {
            let code = (err as BusinessError).code;
            let message = (err as BusinessError).message;
            hilog.error(0x0000, 'testTag', 'IPCClient: unregisterDeathRecipient failed, code is ' + code + ', message is ' + message);
          }
          proxy = undefined;
        },
        onFailed: (code: number) => {
          hilog.info(0x0000, 'testTag', 'IPCClient: onFailed. code is :' + code);
        },
      }

      try {
        connectId = context.connectServiceExtensionAbility(want, connect);
      }catch (err) {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        hilog.error(0x0000, 'testTag', 'IPCClient: connectAbility failed, code is ' + code + ', message is ' + message);
      }
    }
  ```

3. 客户端发送字符串给服务端

  ```ets
    function sendString() {
      hilog.info(0x00000, 'testTag', 'IPCClient: begin to send String');
      let option = new rpc.MessageOption();
      let data = rpc.MessageSequence.create();
      let reply = rpc.MessageSequence.create();
      // 在data里写入参数，以传递字符串为例
      data.writeString('hello world');
      if (proxy != undefined) {
        proxy.sendMessageRequest(1, data, reply, option)
          .then((result: rpc.RequestResult) => {
            if (result.errCode != 0) {
              hilog.error(0x0000, 'testTag', 'IPCClient: sendMessageRequest failed, errCode: ' + result.errCode);
              return;
            }
            // 从result.reply里读取结果
            let str = result.reply.readString();
            hilog.info(0x0000, 'testTag', 'IPCClient: sendMessageRequest receive str: ' + str);
          })
          .catch((e: Error) => {
            hilog.error(0x0000, 'testTag', 'IPCClient: sendMessageRequest failed, error is ' + JSON.stringify(e));
          })
          .finally(() => {
            data.reclaim();
            reply.reclaim();
          })
      }
    }
  ```

4. 客户端断开连接服务

  ```ets
    function disconnectAbility(context: common.UIAbilityContext) {
      hilog.info(0x00000, 'testTag', 'IPCClient: begin to disconnect Ability');
      if (connectId != undefined) {
        try {
          context.disconnectServiceExtensionAbility(connectId);
        }catch (err) {
          let code = (err as BusinessError).code;
          let message = (err as BusinessError).message;
          hilog.error(0x0000, 'testTag', 'IPCClient: disconnectAbility failed, code is ' + code + ', message is ' + message);
        }
      }
    }
  ```

## 相关权限

不涉及

## 依赖

不涉及

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。

2. 本示例推荐使用DevEco Studio 5.0.2 Beta1 (Build Version: 5.0.7.100 构建 2025年1月16日)及以上版本编译运行。

3. 本示例需要使用@ohos.app.ability.ServiceExtensionAbility，该模块仅对系统应用开放，业务使用时，需自行替换当前工程中的SDK为FULL SDK。使用Full SDK时需要手动从镜像站点获取，并在DevEcoStudio中替换，具体操作可参考[替换指南](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/faqs/full-sdk-switch-guide.md) 。

4. 本示例使用了ServiceExtensionAbility，需要在module.json5中进行相应的配置。如下：

在服务端entry下的module.json5中配置如下字段：[module.json5](../IPC_Stub/entry/src/main/module.json5)，参考第48-54行。

  ```
  "extensionAbilities": [
    {
      "name": "ServiceAbility",
      "srcEntry": "./ets/serviceextability/ServiceExtAbility.ets",
      "type": "service",
      "exported": true,
      "description": "service"
    }
  ]
  ```

## 下载

如需单独下载本工程及服务端，执行如下命令：

  ```
    git init
    git config core.sparsecheckout true
    echo code/SystemFeature/IPC/IPC_sendMessage/ > .git/info/sparse-checkout
    git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
    git pull origin master
  ``` 

## 安装问题（9568344）

因上述应用的module.json5中extensionAbilities字段中type属性为service，普通的安装方法会报错，需要按照以下方式进行安装：

1. 注释module.json5中extensionAbilities字段

![](image/comment.png)

2. 获取app_signature

 ```
   hdc shell bm dump -n <bundleName> | findstr finger
 ```

![](image/app_signature.png)

3. 添加白名单

将rk设备的install_list_capability.json配置文件拉取到本地

  ```
   hdc shell mount -o rw,remount /
   hdc file recv /system/etc/app/install_list_capability.json   ---rk的方式
  ```

![](image/recv_install_list_capability.png)

在拉下来的json文件中添加不能安装成功的应用，格式如下：

  ```
   {
     "install_list": [
        {
          ......
        },
        {
          "bundleName": "应用包名",
          "app_signature" : ["上面获取的app_signature"],
          "allowAppUsePrivilegeExtension": true
        }
     ]
   }
  ```

![](image/configure.png)

4. 将修改后的白名单推送到设备上进行替换并重启

  ```
    hdc shell mount -o rw,remount /
    hdc file send install_list_capability.json /system/etc/app/install_list_capability.json  
    hdc shell chmod 777 /system/etc/app/install_list_capability.json 
    hdc shell reboot
  ```

5. 取消module.json5中extensionAbilities的相关注释，重新安装hap包
   