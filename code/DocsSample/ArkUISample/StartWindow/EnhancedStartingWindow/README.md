# 增强启动页基础使用示例

### 介绍

本示例主要展示了给应用提供的增强启动页的配置能力，可用于元素更复杂的启动页配置。同时，相应资源也具备根据窗口尺寸进行缩放的能力，更易于多设备适配设计，更有利于“一次开发，多端部署”。

### 使用说明

1. 配置增强启动页字段。
2. 配置二级json文件。

### 工程目录

```
DisplayBasicSample

entry/src/
 ├── main
 │   ├── ets
 │   │   └── pages
 │   │      └── Index.ets
 │   ├── resources
 │   │   └── base
 │   │      └── profile
 │   │         └── start_window.json (二级配置文件)
 │   ├── module.json5 (配置项)
 │   └── resources
 ├── ohosTest
 ├── mock
 ├── test
```

### 具体实现

1. **配置增强启动页字段**
   - 在abilities标签中新增startWindow字段指向二级配置json文件，以启用启动页增强配置。
2. **配置二级json文件**
   - 创建json文件并放置到工程目录下，推荐的文件名及路径为resources/base/profile/start_window.json。
   - 启动页资源主要在上、下两个区域进行展示，如果对应区域的资源未配置，则留空，其他区域的位置和尺寸不受影响。

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