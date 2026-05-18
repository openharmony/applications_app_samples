# SimpleKeyboard输入法应用

### 介绍
本示例使用[inputMethodEngine](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ime-kit/js-apis-inputmethodengine.md)实现一个轻量级输入法应用SimpleKeyboard，支持在运行OpenHarmony OS的智能终端上。

### 使用说明

1.在设置中切换当前输入法为此输入法。

2.点击应用中的编辑框，拉起输入法键盘。

3.点击键盘可以在编辑框中输入数字内容，点击删除键可以删除文本。

### 工程目录

```
SimpleKeyboard
├── AppScope                                    
│   └── app.json5                               //APP信息配置文件
├── entry/src/main                              //应用首页
│   ├── ets
│   │   ├── common
│   │   │   ├── StyleConfiguration.ets         //适配不同设备下的键盘布局
│   │   ├── components                         //输入法软键盘自定义组件
│   │   ├── entryability                       //应用入口
│   │   │   ├── EntryAbility.ets               //应用入口Ability
│   │   ├── pages
│   │   │   ├── PrivatePreview.ets             //预上屏主页
│   │   ├── model
│   │   │   ├── HardKeyUtils.ets               //外接键盘KeyCode数据
│   │   ├── InputMethodExtensionAbility
│   │   │   ├── InputMethodService.ets         //输入法Ability
│   │   │   |── model                           
│   │   │   |   ├── KeyboardController.ets     //输入法键盘控制
│   │   │   |── pages                           
│   │   │   |   ├── Index.ets                  //输入法主页
│   │   │   |   ├── KeyboardKeyData.ets        //输入法键盘数据
│   └── module.json5
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例需要使用DevEco Studio 版本号(DevEco Studio 6.0.0 Canary1)及以上版本才可编译运行。