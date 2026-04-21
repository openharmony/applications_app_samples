# ArkTS使用JSVM-API接口从外部内存创建ArrayBuffer

### 介绍

在某些场景下，应用已有一块外部内存（如从文件映射、硬件缓冲区、或其他Native模块分配的内存），希望将其包装为JavaScript的ArrayBuffer对象，以便在JS层进行读写操作。JSVM-API提供了OH_JSVM_CreateArrayBufferFromExternalMemory接口来满足这类场景。

该工程中展示的代码详细描述可查如下链接：

- [使用JSVM-API接口从外部内存创建ArrayBuffer](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-about-external-arraybuffer.md)

### 效果预览

|                                   首页                                   |                            执行及结果即时反馈                            |
| :----------------------------------------------------------------------: | :----------------------------------------------------------------------: |
| <img src="./screenshots/JsvmAboutExternalArraybuffer_1.png" style="zoom:33%;" /> | <img src="./screenshots/JsvmAboutExternalArraybuffer_2.png" style="zoom:33%;" /> |

Hilog中会输出如下日志：

```
JSVM CreateArrayBufferFromExternalMemory: success, byteLength=16
```

### 使用说明

1. 在主界面，可以点击Hello World，开始执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
createarraybufferfromexternalmemory/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libcreatearraybufferfromexternalmemory
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关联
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接口
 │   ├── ets
 │   │   ├── createarraybufferfromexternalmemoryability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：Phone。

2.本示例为Stage模型，支持API26版本SDK。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/JSVMAPI/JsvmUsageGuide/JsvmAboutExternalArraybuffer > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
