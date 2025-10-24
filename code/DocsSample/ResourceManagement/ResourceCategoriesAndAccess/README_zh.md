# 资源分类与访问

### 介绍

本工程主要实现了[资源分类与访问](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/resource-categories-and-access.md)中功能，开发者可以通过本项目了解如何使用字符串、颜色、字体、间距和图标等资源。

### 效果预览

| 显示页面1                               | 显示页面2                                             |
|-------------------------------------|---------------------------------------------------|
| ![](screenshots/ResourceCategoriesAndAccess1.png) | ![](screenshots/ResourceCategoriesAndAccess2.png) |

### 使用说明

1. 启动项目后，会显示带有文本和图标的页面，展示对应的资源；

### 目录结构

```
entry/src/
|---main
│   |---ets
│   │   |---pages
│   │       |---Index.ets                        // 构建页面，显示单HAP包、系统资源
│   │       |---Second.ets                       // 构建页面，显示跨HSP包资源
│   |---resources                                // 资源文件目录
│       |---base
│       │   |---element
│       │       |---color.json
│       │       |---float.json
│       │       |---plural.json
│       │       |---string.json
│       │   |---media
│       |---en_US
│       │   |---element
│       │       |---string.json
│       |---ja_JP
│       │   |---element
│       │       |---string.json
│       |---rawfile
│       |---zh_CN
│       │   |---element
│       │       |---string.json
library/src/                                     // 模块
|---main
│   |---ets
│   │   |---components
│   │       |---MainPage.ets                     // 模块页面组件
│   |---resources                                // 模块资源文件目录
│       |---base
│       │   |---element
│       │       |---color.json
│       │       |---float.json
│       │       |---string.json
│       │   |---media
│       |---rawfile
```

### 具体实现

- 获取文本的字符串内容、字体颜色、字体大小以及图标资源，显示在页面上，包括单HAP包应用资源、跨HAP/HSP包应用资源、系统资源。
- 单HAP包应用资源可以通过\$r('app.type.name')获取资源，跨HAP/HSP包应用资源可以通过\$r('[模块名].type.name')获取资源，系统资源可以通过\$r('sys.type.name')获取资源。
- 在ets目录下的index.ets文件中可以通过添加Text、Image组件来展示对应的资源。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例为Stage模型，支持API 18版本SDK，版本号：5.1.0.108。
3. 本示例需要使用DevEco Studio 5.0.4 Release（5.0.11.100）及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ResourceManagement/ResourceCategoriesAndAccess/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```