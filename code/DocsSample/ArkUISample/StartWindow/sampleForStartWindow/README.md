# 简易启动页基础使用示例

### 介绍

本示例主要展示了给应用提供的简易启动页的配置能力，开发者可以根据应用需要，配置使用自定义设计的图标资源和颜色资源。

### 效果预览

| 预览                               |
|------------------------------------|
| ![](screenshots/device/image2.png) |

### 使用说明

1. 配置启动页图标资源。
2. 配置启动页背景色资源。

### 工程目录

```
DisplayBasicSample

entry/src/
 ├── main
 │   ├── ets
 │   │   └── pages
 │   │      └── Index.ets
 │   ├── module.json5 (配置项)
 │   └── resources
 ├── ohosTest
 ├── mock
 ├── test
```

### 具体实现

1. **配置启动页图标资源**
   - 使用期望的图标资源配置module.json5文件的abilities标签中startWindowIcon字段。
   - startWindowIcon用于展示应用图标，不会随窗口尺寸进行缩放。
   - 建议避免设计针对单个产品全屏尺寸的startWindowIcon图标资源，防止在其他尺寸设备的显示效果无法自动适配。
2. **配置启动页背景色资源**
   - 使用期望的背景色资源配置module.json5文件的abilities标签中startWindowBackground字段。

| 示意图                             |
|------------------------------------|
| ![](screenshots/device/image1.png) |

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

从API version 20开始，支持在手机、平板、PC/2in1设备上使用

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/StartWindow/sampleForStartWindow > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````