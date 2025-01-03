# 轻量级输入法

### 简介

kikainput是一个轻量级的输入法应用，支持在运行OpenHarmony OS的智能终端上。

实现效果如下：

![](screenshot/device/main.png)

### 目录

```
├─AppScope
│  │  app.json5                                        #应用配置文件
│  └─resources
│      └─base
│          ├─element
│          │      string.json
│          │
│          └─media
│                 app_icon.png
│
├─entry
│  │  .gitignore
│  │  build-profile.json5
│  │  hvigorfile.js
│  │  package.json
│  │
│  └─src
│      └─main
│          │  module.json5                             #项目配置文件
│          │
│          ├─ets
│          │   ├─Application
│          │   │     │  AbilityStage.ts
│          │   │
│          │   ├─model
│          │   │     │  HardKeyUtils.ets
│          │   │     │  KeyboardController.ets
│          │   │     │  KeyboardKeyData.ets
│          │   │
│          │   ├─pages
│          │   │    └─service
│          │   │        └─pages
│          │   │            │  index.ets
│          │   │
│          │   ├─ServiceExtAbility
│          │   │     │  service.ts
│          │   │     │  ServiceExtAbility.ts
│          │   │
│          │   └─test
│          │       │  Ability.test.ets
│          │       │  List.test.ets
│          │
│          └─resources
│              ├─base
│              │   ├─element
│              │   │      string.json
│              │   │
│              │   ├─media
│              │   │        icon.png
│              │   │
│              │   └─profile
│              │           main_pages.json
│              └─rawfile
│                  │    delete.png
│                  │    down.png
│                  │    return.png
│                  │    shift.png
│                  │    shift light.png
│                  │    shift light long.png

```

### 使用场景

**支持语言:** JavaScript

**操作系统限制:** OpenHarmony操作系统

**模型限制:** Stage模型

### 相关权限

不涉及。

### 开发步骤

**1.样式布局，以及逻辑修改**

找到pages/service/pages/index.ets文件进行布局修改。

找到model/KeyboardController.ets文件进行逻辑修改。

**2.配置签名文件然后进行打包**

配置签名文件可以参照:[https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/hapsigntool-guidelines.md]

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例为Stage模型，从API version 9开始支持。

3. 本示例已适配API version 10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0Release);

4. 本示例需要使用DevEco Studio 版本号(4.0Release)及以上版本才可编译运行。

5.如果安装本示例报错为error：install sign info inconsistent，则有可能本应用被设置为系统预置应用，已安装在系统中，此时需使用命令进行替换安装，并在替换安装后对设备进行重启操作，具体命令如下：

hdc shell mount -o rw,remount /

hdc file send ./entry-default-signed.hap /system/app/com.example.kikakeyboard/kikaInput.hap

hdc shell  reboot

等设备重启后即可完成应用的替换安装，无需其他操作。

