# ArkTS使用Node-API接口进行ArrayBuffer相关开发

### 介绍

ArrayBuffer是ArkTS中的一种数据类型，用于表示通用的、固定长度的原始二进制数据缓冲区。它提供了一种在ArkTS中有效地表示和操作原始二进制数据的方式

该工程主要展示了使用Node-API接口进行检查值是否为ArrayBuffer、获取给定的ArrayBuffer对象信息、分离ArrayBuffer信息、判定是否分离ArrayBuffer以及创建指定长度的ArrayBuffer对象，其中展示的代码详细描述可查如下链接。

- [使用Node-API接口进行ArrayBuffer相关开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-napi-about-arraybuffer.md)

### 效果预览

| 首页                                                                   | 执行效果图                                                             |
| ---------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| <img src="./screenshots/NodeAPIArraybuffer1.png" style="zoom: 50%;" /> | <img src="./screenshots/NodeAPIArraybuffer2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述首页效果，分别点击ListItem组件可以执行对应文本内容的Node-API接口并将文本Result:改为执行成功结果，然后在控制台中打印出对应日志。
3. 运行测试用例NodeAPIArraybuffer.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │       ├── Index.d.ts
 │   │       ├── oh-package.json5
 │   │   ├── CMakeLists.txt
 │   │   ├── napi_init.cpp
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets                    // 使用Node-API接口进行Arraybuffer相关开发示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets
 │   │       ├── NodeAPIArraybuffer.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony_5.0.2.58。

3.本示例需要使用DevEco Studio 5.0.1 Release (Build Version: 5.0.5.306, built on December 6, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/NodeAPI/NodeAPIUse/NodeAPIArraybuffer > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
