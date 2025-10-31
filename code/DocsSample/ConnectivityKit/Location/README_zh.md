# 位置信息

### 介绍

本示例使用 [geolocation](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geolocation.md) 实现获取当前位置的经纬度。

### 效果预览
|首页|
|--------|
|![](screenshot/Sample.png)|

使用说明
1. 进入主页，点击国内热门城市，配送地址会更新为选择的城市。点击右边字母索引条，可快速定位到想要选择的城市区域，点击该城市后若该城市还细化到区，继续点击该城市的区，配送地址会更新为城市/区，若未细化到区，则只选择城市。
2. 若测试机支持GPS，点击国内热门城市上面的定位图标，应用会获取本机所在经纬度，然后根据经纬度获取所在城市，定位图标后的城市会进行刷新，当前城市数据为模拟数据。

### 工程目录
```
entry/src/main/
|---ets
|   |---mock
|   |   |---LocationMock.ets                        // 城市信息mock数据
|   |---pages
|   |   |---SamplePage.ets                          // geoLocation调用示例
|   |---utils
|   |   |---EntryAbility.ts                         // 权限申请
```

### 具体实现
+ 本示例展示获取定位的功能在页面中直接调用，使用geolocation.on方法获取当前位置的经纬度，然后监听经纬度变化发送request请求获取对应城市信息，源码参考[Location.ets](position/src/main/ets/components/pages/Location.ets)。

### 相关权限

[ohos.permission.LOCATION](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md#ohospermissionlocation)

[ohos.permission.APPROXIMATELY_LOCATION](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md#ohospermissionapproximately_location)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony_5.0.2.57。

3.本示例需要使用DevEco Studio NEXT Developer Preview2 (Build Version: 5.0.5.306， built on December 12, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ConnectivityKit/Location/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```