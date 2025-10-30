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