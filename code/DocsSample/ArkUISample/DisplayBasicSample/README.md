# 屏幕管理基础使用示例

### 介绍

本示例主要展示了屏幕管理提供管理设备屏幕的一些基础能力，例如获取默认显示设备的相关信息、获取全部显示设备的信息，此外还能对显示设备的插拔行为进行监听。应用可以根据对应的屏幕信息、屏幕状态变化、屏幕折叠状态等适配不同的UI界面显示。

屏幕属性的常见使用场景有以下几种：

- 查询屏幕信息：包括屏幕的分辨率、物理像素密度、逻辑像素密度、刷新率、屏幕尺寸、屏幕旋转方向、屏幕旋转角度等。
- 监听屏幕状态变化，包括屏幕旋转变化，屏幕分辨率变化、屏幕刷新率变化等。
- 查询当前设备是否为可折叠设备，同时支持折叠状态（展开/折叠）变化的监听。

### 使用说明

本示例包含6个功能：
1. 获取Display对象。
2. 获取Display对象属性。
3. 获取挖孔信息。
4. 获取截录屏状态。
5. 测试Display监听机制。
6. 折叠设备判断。

### 工程目录

```
DisplayBasicSample

entry/src/
 ├── main
 │   ├── ets
 │   │   └── pages
 │   │      └── Index.ets (功能页面)
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 ├── mock
 ├── test
```

### 具体实现

1. **获取Display对象**
   - 调用getDefaultDisplaySync()接口获取Display对象，将获取到的Display对象打印到log中。
2. **获取Display对象属性**
   - 调用getDefaultDisplaySync()接口获取Display对象。
   - 通过相关属性查询屏幕的一些基础信息，将属性信息打印到log中。
3. **获取挖孔信息**
   - 调用getCutoutInfo()获取挖孔屏、刘海屏、瀑布屏等不可用的屏幕区域信息，以在UI布局时更好地规避该区域，将对应的信息打印到log中。
4. **获取截录屏状态**
   - 调用display.isCaptured()判断当前设备是否正在截屏、投屏或录屏。
5. **测试Display监听机制**
   - 调用display.on('add'|'remove'|'change')监听设备屏幕变化，支持监听屏幕设备的增加、移除和改变等，在不需要监听的时候，调用display.off('add'|'remove'|'change')关闭对应的监听。
   - 调用display.on('captureStatusChange')开启屏幕截屏、投屏或录屏状态变化的监听；在不需要监听的时候，调用display.off('captureStatusChange')关闭对应的监听。
   - 调用on('availableAreaChange')监听当前屏幕对象（Display对象）的可用区域变化；在不需要监听的时候，调用off('availableAreaChange')关闭对应的监听。
6. **折叠设备判断**
   - 通过display.isFoldable()接口查询当前设备是不是折叠设备。
   - 若当前设备为折叠设备，调用display.on('foldStatusChange')开启折叠设备折叠状态变化的监听；在不需要监听的时候，调用display.off('foldStatusChange')关闭对应的监听。

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行, 支持设备：手机、平板、2in1。（部分字段可能仅支持部分设备，可参考使用说明）
2. api20以上版本

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/DisplayBasicSample > .git/info/sparse-checkout
git remote add origin https://gitCode.com/openharmony/applications_app_samples.git
git pull origin master
````