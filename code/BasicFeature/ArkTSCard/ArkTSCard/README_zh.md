# ArkTS卡片能力增强

### 介绍

本示例使用动态和静态(form_config.json中isDynamic字段false为静态，true为动态)两种状态的锁屏卡片/deeplink卡片提供方。

### 效果预览

|DeepLink页面|锁屏页面|解锁页面|对应Ability页面|
|-------|-------|-------|-------|
|![FormDeepLink](screenshots/device/FormDeepLink.jpeg)|![lock](screenshots/device/lock.jpeg)|![unlock](screenshots/device/unlock.jpeg)|![music](screenshots/device/music.jpeg)|
|6x4服务卡片页面|桌面6x4卡片|对应Ability页面|
|![addCard](screenshots/device/addCard.png)|![desktopCard](screenshots/device/desktopCard.png)|![music](screenshots/device/music2.png)|

使用说明
1. 执行该工程前，需安装[libs](./libs)路径下的ArkTSUser.hap， 在[libs](./libs)目录下执行hdc install -r ArkTSUser.hap，
2. 执行工程 首页存在“DeepLink”、“锁屏卡片”两个按钮。
3. 点击首页“DeepLink”按钮跳转到FormDeepLink页面，点击任意卡片(静态卡片/动态卡片)可跳转到对应ability。
4. 点击首页“锁屏卡片”按钮跳转到锁屏页面，在锁屏页面点击任意卡片(静态卡片/动态卡片/ 1x1样式 / 1x2样式)跳转到解锁页面，点击解锁按钮跳转回锁屏页面, 再由锁屏页面自动跳转至对应ability。
5. 回退到手机主页面长按app选择服务卡片，可以添加提供方提供的所有卡片。

### 工程目录
```
entry/src/main/ets/			
|---bookability
|   |---bookAbility.ts
│      
|---dynamicbookcard
|   |---pages
|   |	|---DynamicBookCard.ets				// 动态书籍卡片
│          
|---dynamicmusiccard							
|   |---pages
|   |	|---DynamicMusicCard.ets			// 动态音乐卡片
|   |	|---DynamicMusicLockCard.ets		// 动态音乐锁屏卡片1*1
|   |	|---DynamicMusicLockLongCard.ets       // 动态音乐锁屏卡片1*2
|   |	|---DynamicMusicLockUltraLongCard.ets  // 动态音乐锁屏卡片6*4
│
|---dynamicweathercard
|   |---pages
|   |	|---DynamicWeatherCard.ets 			// 动态天气卡片				
│          
|---entryability							
|   |---pages
|   |	|---EntryAbility.ets				
│      
|---entryformability
|   |---EntryFormAbility.ts					// 卡片提供方
│      
|---pages
|   |---Book.ets							// 书籍页面
|   |---Index.ets
|   |---Music.ets							// 音乐页面
|   |---Weather.ets							// 天气页面
│
|---secondability
|   |--- SecondAbility.ts					
│      
|---staticbookcard							
|   |---pages
|   |	|---StaticBookCard.ets				// 静态书籍卡片
│         
|---staticmusiccard
|   |---pages
|   |	|---StaticMusicCard.ets				// 静态音乐卡片
|	|	|---Index.ets
|   |	|---StaticMusicLockCard.ets			// 静态音乐锁屏卡片1*1
|   |	|---StaticMusicLockLongCard.ets		// 静态音乐锁屏卡片1*2
|   |	|---StaticMusicLockUltraLongCard.ets    // 静态音乐锁屏卡片6*4
│          
|---staticweathercard							
|   |---pages
|   |	|---StaticWeatherCard.ets			// 静态天气卡片
│          
|---thirdability
|   |--- ThirdAbility.ts
│      
|---util
|   |--- Logger.ts							// 日志
```

### 具体实现
+ DeepLink卡片：跳转方式支持uri参数跳转，ability参数改为非必填参数，同时设置ability优先级更高
  + 音乐页面拉起(静态卡片/动态卡片)：router由传入指定uri跳转至页面。
  + 书籍页面拉起(静态卡片/动态卡片)：router由abilityName传入书籍页面的Ability跳转至书籍页面。
  + 天气页面拉起(静态卡片/动态卡片)：router由abilityName传入天气页面的Ability与uri指定页面同时传入时，跳转至abilityName指定的天气页面。

+ 锁屏卡片：将提供方跳转页面转接给使用方能力
  + 静态/动态锁屏卡片(1x1样式/1x2样式)支持解锁：卡片使用方设置onAcquired，callback中调用formHost.setRouterProxy转接提供方跳转页面能力，传入formId获取对应want信息后跳转至对应ability。

### 相关权限

[ohos.permission.REQUIRE_FORM](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionagent_require_form)

### 依赖

执行该工程前，需安装[libs](./libs)路径下的ArkTSUser.hap， 在[libs](./libs)目录下执行hdc install -r ArkTSUser.hap，

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568（卡片设置成单色模式在RK3568不生效）；

2.本示例为Stage模型，支持API12版本SDK，版本号：5.0.0.17； 

3.本示例需要使用DevEco Studio NEXT Developer Preview1 (Build Version: 4.1.3.500, built on January 20, 2024)才可编译运行；

4.本示例涉及[ohos.permission.REQUIRE_FORM](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionrequire_form)权限为system_basic级别，需要配置高权限签名；

### 下载
如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/ArkTSCard/ArkTSCard > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```