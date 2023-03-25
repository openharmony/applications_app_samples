# 位置信息

### 介绍

本示例使用 [geolocation](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-geolocation.md) 实现获取当前位置的经纬度，然后通过 [http](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-http.md) 将经纬度作为请求参数，获取到该经纬度所在的城市。通过 [AlphabetIndexer](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-alphabet-indexer.md) 容器组件实现按逻辑结构快速定位容器显示区域。

### 效果预览
|首页|
|--------|
|![](screenshots/devices/zh/position.png)|

使用说明
1. 进入主页，点击国内热门城市，配送地址会更新为选择的城市。点击右边字母索引条，可快速定位到想要选择的城市区域，点击该城市后若该城市还细化到区，继续点击该城市的区，配送地址会更新为城市/区，若未细化到区，则只选择城市。
2. 若测试机支持GPS，点击国内热门城市上面的定位图标，应用会获取本机所在经纬度，然后根据经纬度获取所在城市，定位图标后的城市会进行刷新，当前城市数据为模拟数据。

### 工程目录
```
position/src/main/ets/
|---components
|   |---mock
|   |   |---LocationMock.ts                         // 城市信息mock数据
|   |---model
|   |   |---data.ts                                 // AlphabetIndexer索引
|   |---net
|   |   |---HttpRequestResponse.ts                  // 网络请求
|   |---pages
|   |   |---Location.ts                             // 页面
|   |---utils
|   |   |---DataSource.ts                           // 懒加载数据格式
|   |   |---Logger.ts                               // 日志工具
```

### 具体实现
+ 本示例展示获取定位的功能在页面中直接调用，使用geolocation.on方法获取当前位置的经纬度，然后监听经纬度变化发送request请求获取对应城市信息，源码参考[Location.ets](position/src/main/ets/components/pages/Location.ets)。

### 相关权限

[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.LOCATION_IN_BACKGROUND](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

[ohos.permission.APPROXIMATELY_LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：GPS定位功能仅支持部分机型。
2. 本示例为Stage模型，已适配API10版本SDK，版本号：4.0.5.1。
3. 本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/DeviceManagement/Location/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```