# SimpleKeyboard输入法应用

### 介绍
本示例使用[inputMethodEngine](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ime-kit/js-apis-inputmethodengine.md)实现一个轻量级输入法应用SimpleKeyboard，支持在运行OpenHarmony OS的智能终端上。

### 使用说明

1.在设置中切换当前输入法为此输入法。

2.点击应用中的编辑框，拉起输入法键盘。

3.点击键盘可以在编辑框中输入数字内容，点击删除键可以删除文本。

### 工程目录

```
KikaInput
├── AppScope                                    
│   └── app.json5                                  // APP信息配置文件
├── entry/src/main                                 // 应用首页
│   ├── ets
│   │   ├── entryability                           // 应用入口
│   │   │   ├── EntryAbility.ets                   // 应用入口Ability
│   │   ├── pages
│   │   │   ├── Index.ets                          // 输入法主页
│   │   ├── entryinputmethodextability
│   │   │   ├── model
│   │   │   │   ├── KeyboardController.ets         // 输入法键盘控制
│   │   │   ├── pages
│   │   │   │   ├── Index.ets                      // 输入法键盘页面
│   │   │   │   ├── KeyboardKeyData.ets            // 输入法键盘数据
│   │   │   ├── InputMethodExtAbility.ets          // 输入法Ability
│   └── module.json5
```

### 相关权限

[ohos.permission.GET_BUNDLE_INFO_PRIVILEGED](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionget_bundle_info_privileged)

[ohos.permission.START_ABILITIES_FROM_BACKGROUND](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionstart_abilities_from_background)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例需要使用DevEco Studio 版本号(4.1 Release)及以上版本才可编译运行。

3.本示例需要使用@ohos.application.InputMethodExtensionAbility系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/faqs/full-sdk-switch-guide.md)。