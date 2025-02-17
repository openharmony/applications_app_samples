# 网络状态监听

### 介绍

本示例介绍如何使用[@kit.NetworkKit](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/network/net-mgmt-overview.md)接口监听手机网络状态，根据不同的网络状态对视频进行播放、暂停处理等操作。

### 效果预览

| 视频播放                                                 | 网络设置                                                  |
|------------------------------------------------------|-------------------------------------------------------|
| <img src="./screenshot/video_play.jpg" width="200"/> | <img src="./screenshot/net_setting.jpg" width="200"/> |

**使用说明**

1. 打开应用进入视频播放页面，视频不播放。
2. 点击自动播放设置按钮，进入设置页面，开启或者关闭3G/4G/5G自动播放、WI-FI自动播放。
3. 开启或者关闭蜂窝网络或者WI-FI开关，查看视频是否根据自动播放设置页面中的设置播放或者暂停。
4. 返回首页瀑布流或者杀死应用重新进入首页，查看视频是否根据自动播放设置中的设置和手机网络状态播放或者暂停。


### 工程目录

   ```
   |entry/src/main/ets
   |   |---entryablity
   |   |   |---EntryAbility.ts                            // 程序入口类
   |   |---pages
   |   |   |---SettingPage.ets                            // 自动播放设置页面
   |   |   |---VideoPage.ets                              // 视频播放页面
   |   |---utils
   |   |   |---EmitterData.ets                            // emitter数据结构 
   |   |   |---Logger.ets                                 // 日志打印
   |   |   |---NetUtils.ets                               // 网络监听工具类
   ```

### 实现思路

1. 页面实现

   1.1 在[VideoPage](entry/src/main/ets/pages/VideoPage.ets)中添加Video组件，设置在线视频播放
   
       ```
       Video({
         src: "https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4",
          controller: this.controller
       }).height(300)
         .width('100%')
         .autoPlay(this.autoPlay())
       ```

   1.2 在aboutToAppear方法中添加网络状态监听，并开始监听WI-FI和蜂窝数据的状态。
   
       ```
       emitter.on(NetUtils.getInstance().getEmitterEvent(), (data: emitter.EventData) => {
         if (data) {
           this.netObserver(data);
         } else {
           logger.info("aboutToAppear emitter on error, data is undefined.");
         }
       });
       NetUtils.getInstance().startNetObserve(connection.NetBearType.BEARER_CELLULAR, connection.NetBearType.BEARER_WIFI);
       ```

   1.3 在netObserver方法中，添加不同网络状态的处理。
   
      ```
      netObserver(data: emitter.EventData) {
      ...
        let eventName: NetworkEventName = netEventData.eventName ?? -1;
        switch (eventName) {
          case NetworkEventName.NetAvailable:
            if (netEventData.netType === connection.NetBearType.BEARER_WIFI) {
              if (this.wifiAutoPlay) {
                this.startPlay();
              }
            }
            break;
          case NetworkEventName.NetBlock:
            break;
          case NetworkEventName.NetLost:
            if (netEventData.netType === connection.NetBearType.BEARER_WIFI) {
              this.wifiInterrupt();
            }
            break;
          case NetworkEventName.NetUnavailable:
            if (netEventData.netType === connection.NetBearType.BEARER_WIFI) {
              this.wifiInterrupt();
            }
            break;
          case NetworkEventName.WeakNet:
            // 如果是弱网环境
            if (netEventData.status) {
              Prompt.showToast({ message: "当前网络环境较差，视频播放可能出现卡顿" });
            }
            break;
          default:
            logger.debug("当前网络状态：" + eventName);
            break;
        }
      }
      ```

   1.4 在[SettingPage](entry/src/main/ets/pages/SettingPage.ets)中添加Toggle组件，管理自动播放设置。

      ```
      Toggle({ type: ToggleType.Switch, isOn: this.cellularAutoPlay })
        .selectedColor('#007DFF')
        .switchPointColor('#FFFFFF')
        .onChange((isOn: boolean) => {
          logger.info('Component status:' + isOn);
          AppStorage.setOrCreate('cellular_auto_play', isOn);
          PersistentStorage.persistProp('cellular_auto_play', isOn);
        })
        .width('10%')
      ```
   
2. 网络状态监听工具类[NetUtils](entry/src/main/ets/utils/NetUtils.ets)实现，通过[@kit.NetworkKit](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/network/net-mgmt-overview.md)接口监听网络状态，然后通过emitter将监听结果传递给页面。

   2.1 开启网络监听


      ```
      public startNetObserve(...netType: connection.NetBearType[]) {
        netType.forEach((type: connection.NetBearType) => {
          this.networkObserve(type);
          if (type === connection.NetBearType.BEARER_WIFI) {
            this.wifiStateObserve();
          }
        })
      }
      ```

   2.2 关闭网络监听

      ```
      public stopNetObserve(netType: connection.NetBearType) {
        this.connectionMap.get(netType).unregister(() => {
          logger.info("Success unregister：" + netType.toString());
        })
      }
      ```

   2.3 网络状态监听

      ```
      networkObserve(netType: connection.NetBearType) {
        let netConnection: connection.NetConnection = connection.createNetConnection({
          netCapabilities: {
            bearerTypes: [netType]
          }
        })
        netConnection.register((error: BusinessError) => {
          let result = true;
          if (error) {
            logger.info("NetUtils", "NetType :" + netType + ", network register failed: " + JSON.stringify(error));
            result = false;
          }
          logger.info("NetUtils", "NetType :" + netType + ", network register succeed");
          this.postEvent(NetworkEventName.NetObserverRegister, result, netType);
        });

        netConnection.on('netCapabilitiesChange', (data: connection.NetCapabilityInfo) => {
          logger.info("NetUtils", "NetType :" + netType + ", network netCapabilitiesChange: " + JSON.stringify(data));
          this.postEvent(NetworkEventName.NetCapabilitiesChange, data, netType);
        })

        netConnection.on("netAvailable", (data: connection.NetHandle) => {
          logger.info("NetUtils", "NetType :" + netType + ", network succeeded to get netAvailable: " + JSON.stringify(data));
          // 检查默认数据网络是否被激活，使用同步方式返回接口，如果被激活则返回true，否则返回false。
          this.postEvent(NetworkEventName.NetAvailable, connection.hasDefaultNetSync(), netType);
        });
    
        // 订阅网络阻塞状态事件，当网络阻塞时，如网络性能下降、数据传输出现延迟等情况时，会触发该事件
        netConnection.on('netBlockStatusChange', (data: connection.NetBlockStatusInfo) => {
          logger.info("NetUtils", "NetType :" + netType + ", network netBlockStatusChange " + JSON.stringify(data));
          this.postEvent(NetworkEventName.NetBlock, data, netType)
        });
    
        netConnection.on('netConnectionPropertiesChange', (data: connection.NetConnectionPropertyInfo) => {
          logger.info("NetUtils", "NetType :" + netType + ", network netConnectionPropertiesChange " + JSON.stringify(data));
          this.postEvent(NetworkEventName.NetConnectionPropertiesChange, data, netType);
        });

        // 订阅网络丢失事件，当网络严重中断或正常断开时触发该事件
        // 网络丢失是指网络严重中断或正常断开事件，当断开Wi-Fi时，是属于正常断开网络连接，会触发netLost事件
        netConnection.on('netLost', (data: connection.NetHandle) => {
          this.postEvent(NetworkEventName.NetLost, true, netType)
          logger.info("NetUtils", "NetType :" + netType + ", Succeeded to get netLost: " + JSON.stringify(data));
        });
    
        // 订阅网络不可用事件，当网络不可用时触发该事件
        // 网络不可用是指网络不可用事件，当连接的网络不能使用时，会触发netUnavailable事件。
        netConnection.on('netUnavailable', () => {
          logger.info("NetUtils", "NetType :" + netType + ", Succeeded to get unavailable net event");
          this.postEvent(NetworkEventName.NetUnavailable, true, netType);
        });
    
        this.connectionMap.set(netType, netConnection);
      }
      ```
   2.4 通过emitter将网络监听状态传递给页面

      ```
      private postEvent(eventName: NetworkEventName, status: NetworkData, netType?: connection.NetBearType,
        priority?: emitter.EventPriority) {
        this.emitterEvent.priority = priority;
        emitter.emit(this.emitterEvent, {
          data: new NetEventData(eventName, status, netType)
        })
      }
      ```

### 相关权限

| 权限名 | 权限说明 | 级别 |
|---|---|---|
|ohos.permission.INTERNET|允许使用Internet网络|normal|
|ohos.permission.GET_WIFI_INFO|允许应用获取Wi-Fi信息|normal|
|ohos.permission.GET_NETWORK_INFO|允许应用获取数据网络信息|normal|

### 依赖

本示例需要在有流量卡/Wi-Fi的设备上使用。

### 约束与限制

1. 本示例仅支持标准系统上运行。

2. 本示例为Stage模型，从API version 12开始支持。SDK版本号：5.0.0.71 Release，镜像版本号：OpenHarmony 5.0.1.107。

3. 本示例需要使用DevEco Studio 5.0.2 Release (Build Version: 5.0.7.200, built on January 23, 2025)编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```shell
git init
git config core.sparsecheckout true
echo code/BasicFeature/Connectivity/NetworkObserver/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

