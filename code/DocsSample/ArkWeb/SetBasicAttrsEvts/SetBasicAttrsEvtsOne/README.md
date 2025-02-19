# 使用隐私模式

### 介绍

1. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-incognito-mode.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

### AllowGeolocation

#### 介绍

1. 本示例主要介绍使用隐私模式，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式，通过allowGeolocation设置隐私模式下的Web组件允许指定来源使用地理位置。

#### 效果预览

| 主页                                                        |
| ----------------------------------------------------------- |
| <img src="screenshots\AllowGeolocation.png" width="360;" /> |

使用说明

1. 将可选参数incognitoMode设置为true，来开启Web组件的隐私模式
2. 点击按钮通过allowGeolocation设置隐私模式下的Web组件允许指定来源使用地理位置。

### ClearAllCookiesSync

#### 介绍

1. 本示例主要介绍使用隐私模式，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式，通过clearAllCookiesSync清除隐私模式下所有cookie。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\ClearAllCookiesSync.png" width="360;" /> |

使用说明

1. 将可选参数incognitoMode设置为true，来开启Web组件的隐私模式。
1. 点击按钮通过clearAllCookiesSync清除隐私模式下所有cookie。

### ConfigCookieSync

#### 介绍

1. 本示例主要介绍使用隐私模式，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式，通过configCookieSync设置隐私模式下指定url的单个cookie的值。

#### 效果预览

| 主页                                                        |
| ----------------------------------------------------------- |
| <img src="screenshots\ConfigCookieSync.png" width="360;" /> |

使用说明

1. 将可选参数incognitoMode设置为true，来开启Web组件的隐私模式。
2. 点击按钮通过configCookieSync设置隐私模式下指定url的单个cookie的值。

### DeleteAllData

#### 介绍

1. 本示例主要介绍使用隐私模式，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式，通过deleteAllData清除隐私模式下Web SQL当前使用的所有存储。

#### 效果预览

| 主页                                                     |
| -------------------------------------------------------- |
| <img src="screenshots\DeleteAllData.png" width="360;" /> |

使用说明

1，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式。

2 ,  点击按钮通过deleteAllData清除隐私模式下Web SQL当前使用的所有存储。

### DeleteGeolocation

#### 介绍

1. 本示例主要介绍使用隐私模式，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式，通过deleteGeolocation清除隐私模式下指定来源的地理位置权限状态。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\DeleteGeolocation.png" width="360;" /> |

使用说明

1. 将可选参数incognitoMode设置为true，来开启Web组件的隐私模式。
2. 点击按钮通过deleteGeolocation清除隐私模式下指定来源的地理位置权限状态。

### ExistCookie

#### 介绍

1. 本示例主要介绍使用隐私模式，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式，通过existCookie查询隐私模式下是否存在cookie。

#### 效果预览

| 主页                                                   |
| ------------------------------------------------------ |
| <img src="screenshots\ExistCookie.png" width="360;" /> |

使用说明

1. 将可选参数incognitoMode设置为true，来开启Web组件的隐私模式。
2. 点击按钮通过existCookie查询隐私模式下是否存在cookie。

### FetchCookieSync

#### 介绍

1. 本示例主要介绍使用隐私模式，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式，通过fetchCookieSync获取隐私模式下指定url对应cookie的值。

#### 效果预览

| 主页                                                       |
| ---------------------------------------------------------- |
| <img src="screenshots\FetchCookieSync.png" width="360;" /> |

使用说明

1. 将可选参数incognitoMode设置为true，来开启Web组件的隐私模式。
2. 点击按钮通过fetchCookieSync获取隐私模式下指定url对应cookie的值。

### GetAccessibleGeolocation

#### 介绍

1. 本示例主要介绍使用隐私模式，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式，通过getAccessibleGeolocation以回调方式异步获取隐私模式下指定源的地理位置权限状态。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\GetAccessibleGeolocation.png" width="360;" /> |

使用说明

1. 将可选参数incognitoMode设置为true，来开启Web组件的隐私模式。
2. 点击按钮通过getAccessibleGeolocation以回调方式异步获取隐私模式下指定源的地理位置权限状态。

### IncognitoMode_one

#### 介绍

1. 本示例主要介绍使用隐私模式，将可选参数incognitoMode设置为true，来开启Web组件的隐私模式，当使用隐私模式时，浏览网页时的Cookie、 Cache Data等数据不会保存在本地的持久化文件，当隐私模式的Web组件被销毁时，Cookie、 Cache Data等数据将不被记录下来。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\IncognitoMode_one.png" width="360;" /> |

使用说明

1. 将可选参数incognitoMode设置为true，创建隐私模式的Web组件。

### IncognitoMode_two

#### 介绍

1. 本示例主要介绍使用隐私模式，通过isIncogntoMode判断当前Web组件是否是隐私模式。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\IncognitoMode_two.png" width="360;" /> |

使用说明

1. 点击按钮通过isIncogntoMode判断当前Web组件是否是隐私模式。

# 在新窗口中打开页面

### OpenPageNewWin

#### 介绍

1. 本示例主要介绍在新窗口中打开页面，通过multiWindowAccess()接口来设置是否允许网页在新窗口打开。
2. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-open-in-new-window.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

#### 效果预览

| 主页                                                        | 新窗口页面                                                  |
| ----------------------------------------------------------- | ----------------------------------------------------------- |
| <img src="screenshots\OpenPageNewWin_1.png" width="360;" /> | <img src="screenshots\OpenPageNewWin_2.png" width="360;" /> |

使用说明

1. 通过multiWindowAccess()接口来设置是否允许网页在新窗口打开。
1. 点击按钮在新窗口打开网页。

#  管理位置权限

### ManageLocPerms

#### 介绍

1. 本示例主要介绍管理位置权限，可以通过onGeolocationShow()接口对某个网站进行位置权限管理。Web组件根据接口响应结果，决定是否赋予前端页面权限。
2. 实现对以下指南文档中 https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/web/web-geolocation-permission.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

#### 效果预览

| 主页                                                        | 提示框                                                      |
| ----------------------------------------------------------- | ----------------------------------------------------------- |
| <img src="screenshots\ManageLocPerms_1.png" width="360;" /> | <img src="screenshots\ManageLocPerms_2.png" width="360;" /> |

使用说明

1. 通过onGeolocationShow()接口对某个网站进行位置权限管理。
1. 点击按钮，Web组件通过弹窗的形式通知应用侧位置权限请求消息。

#  设置深色模式

### 介绍

1. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-set-dark-mode.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

### DarkMode_one

#### 介绍

1. 本示例主要介绍对前端页面进行深色模式配置，使用darkMode()接口可以配置不同的深色模式。

#### 效果预览

| 主页                                                    |
| ------------------------------------------------------- |
| <img src="screenshots\DarkMode_one.png" width="360;" /> |

使用说明

1. 使用darkMode()接口将页面深色模式配置为跟随系统。

### DarkMode_two

#### 介绍

1. 本示例主要介绍对前端页面进行深色模式配置，通过forceDarkAccess()接口可将前端页面强制配置深色模式。

#### 效果预览

| 主页                                                    |
| ------------------------------------------------------- |
| <img src="screenshots\DarkMode_two.png" width="360;" /> |

使用说明

1. 将深色模式配置成WebDarkMode.On，并通过forceDarkAccess()接口将页面强制配置为深色模式。

## 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---|---|---DarkMode_one.ets
|---|---|---DarkMode_two.ets
|---|---|---AllowGeolocation
|---|---|---ClearAllCookiesSync
|---|---|---ConfigCookieSync
|---|---|---DeleteAllData
|---|---|---DeleteGeolocation
|---|---|---ExistCookie
|---|---|---FetchCookieSync
|---|---|---GetAccessibleGeolocation
|---|---|---IncognitoMode_one
|---|---|---IncognitoMode_two
|---|---|---OpenPageNewWin.ets
|---|---|---ManageLocPerms.ets
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```

## 相关权限

[ohos.permission.INTERNET](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)

[ohos.permission.LOCATION](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionlocation)

[ohos.permission.APPROXIMATELY_LOCATION](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionapproximatelylocation)

[ohos.permission.LOCATION_IN_BACKGROUND](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionlocationinbackground)

## 依赖

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例支持API14版本SDK，SDK版本号(API Version 14 Release)。
3. 本示例需要使用DevEco Studio 版本号(5.0.1Release)才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkWeb/SetBasicAttrsEvts/SetBasicAttrsEvtsOne > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
