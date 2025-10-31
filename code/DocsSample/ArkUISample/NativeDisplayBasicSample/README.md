# 屏幕管理NativeApi基础使用示例

### 介绍

本示例主要展示了OH_DisplayManager屏幕管理模块用于提供屏幕的信息查询、屏幕状态变化监听、折叠设备的折叠状态变化监听等能力，应用可根据对应的屏幕信息、屏幕状态变化、屏幕折叠状态适配不同的UI界面显示。

屏幕属性的常见使用场景有以下几种：

- 支持查询的屏幕信息，包括屏幕的分辨率、物理像素密度、逻辑像素密度、刷新率、屏幕尺寸、屏幕旋转方向、屏幕旋转角度等。
- 支持屏幕状态变化的监听，包括屏幕旋转变化，屏幕分辨率变化、屏幕刷新率变化等。
- 支持查询当前设备是否为可折叠设备，同时支持折叠状态（展开/折叠）变化的监听。

### 使用说明

本示例包含5个功能：
1. 获取屏幕Rotation属性。
2. 获取挖孔信息。
3. 测试Display监听机制。
4. 折叠设备判断。
5. 测试折叠状态监听。

### 工程目录

```
NativeDisplayBasicSample

entry/src/main/ets/
└── pages
    ├── Index.ets (功能页面)
entry/src/main/
├── cpp
│   ├── types
│   │   └── libnativedisplay
│   │       └── Index.d.ts (函数对应的js映射)
│   ├── napi_init.cpp
│   └── CMakeLists.txt (CMake脚本)
└── resources
    ├── base
    │   ├── element
    │   │   ├── color.json
    │   │   ├── float.json
    │   │   └── string.json
    │   └── media
```

### 具体实现

1. **获取屏幕Rotation属性**
   - 调用OH_NativeDisplayManager_GetDefaultDisplayRotation接口获取默认屏幕的旋转角度，并将此属性信息打印到log中。
2. **获取挖孔信息**
   - 调用OH_NativeDisplayManager_CreateDefaultDisplayCutoutInfo获取挖孔屏、刘海屏、瀑布屏等不可用屏幕区域信息，并将此信息打印到log中。
   - 在使用完此信息后，调用OH_NativeDisplayManager_DestroyDefaultDisplayCutoutInfo销毁挖孔屏、刘海屏、瀑布屏等不可用屏幕区域信息。
3. **测试Display监听机制**
   - 调用OH_NativeDisplayManager_RegisterDisplayChangeListener接口注册屏幕变化的监听，包括屏幕旋转、分辨率变化、刷新率变化、DPI变化都会触发此监听回调。
   - 在不需要监听的时候，调用OH_NativeDisplayManager_UnregisterDisplayChangeListener接口取消屏幕状态变化的监听。
4. **折叠设备判断**
   - 调用通过OH_NativeDisplayManager_IsFoldable接口查询设备是否为折叠设备。
5. **测试折叠状态监听**
   - 调用OH_NativeDisplayManager_RegisterFoldDisplayModeChangeListener注册屏幕展开/折叠状态变化的监听。
   - 在不需要监听的时候，调用OH_NativeDisplayManager_UnregisterFoldDisplayModeChangeListener接口取消屏幕展开/折叠状态变化的监听。

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
echo code/DocsSample/ArkUISample/NativeDisplayBasicSample > .git/info/sparse-checkout
git remote add origin https://gitCode.com/openharmony/applications_app_samples.git
git pull origin master
````