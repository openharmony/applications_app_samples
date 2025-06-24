# ArkTS使用Node-API进行basic_data_types相关开发

### 介绍

ArkTS的Number类型是一个双精度64位二进制格式IEEE 754值。只有在-2^53+1到2^53-1范围内（闭区间）的整数才能在不丢失精度的情况下被表示，在超过该取值范围的情况下，需要使用BigInt对应的NPI接口来处理更大范围的整数。

该工程主要展示了使用Node-API接口将number类型转换为uint32、int32、int64、double以及前述四种类型转换回number类型，其中展示的代码详细描述可查如下链接。

- [使用Node-API进行basic_data_types相关开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-napi-basic-data-types.md)

### 效果预览

| 首页                                                                      | 执行效果图                                                                |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| <img src="./screenshots/NodeAPIBasicDataTypes1.png" style="zoom: 50%;" /> | <img src="./screenshots/NodeAPIBasicDataTypes2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面
2. 页面呈现上述首页效果，分别点击ListItem组件可以执行对应文本内容的Node-API接口并将文本Result:改为执行成功结果，然后在控制台中打印出对应日志。
3. 运行测试用例NodeAPIBasicDataTypes.test.ets文件对页面代码进行测试可以全部通过。

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
 │   │       ├── Index.ets                       // 使用Node-API接口进行basic_data_types相关开发示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets
 │   │       ├── NodeAPIBasicDataTypes.test.ets  // 自动化测试代码
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
echo code/DocsSample/ArkTS/NodeAPI/NodeAPIUse/NodeAPIBasicDataTypes > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
