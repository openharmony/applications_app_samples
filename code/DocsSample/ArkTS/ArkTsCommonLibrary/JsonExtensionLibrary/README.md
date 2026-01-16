# JSON扩展库

## 介绍

本示例主要介绍了JSON扩展库主要适用的场景：
* 需要处理BigInt的JSON解析或序列化。
* 需要更严格的参数校验和错误处理。
* 需要在序列化对象时检测循环引用。
* 需要安全的对象操作（has/remove）。

## 效果预览

| 首页                                     | 解析包含嵌套引号的JSON字符串场景                         | 解析包含大整数的JSON字符串场景 |
|----------------------------------------|-----------------------------------------------|--|
| ![Index](./screenshots/Index.png)      | ![ContainingNested](./screenshots/ContainingNested.png)  |![ContainingBigInts](./screenshots/ContainingBigInts.png)|

| 序列化BigInt对象场景 | 序列化浮点数number场景 |
|----------------------------------------|-----------------------------------------------|
| ![BigIntObject](./screenshots/BigIntObject.png) | ![FloatingPointNumbers](./screenshots/FloatingPointNumbers.png) |

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets // 首页。
    └── ParsingContainingBigInts.ets // 解析包含大整数的JSON字符串场景。
    └── ParsingContainingNestedQuotationMarks // 解析包含嵌套引号的JSON字符串场景。
    └── SerializingBigIntObjects.ets // 序列化BigInt对象场景。
    └── SerializingFloatingPointNumbers.ets // 序列化浮点数number场景。    
entry/src/ohosTest/
└── ets
    └── test
        └── ParsingContainingBigInts.test.ets // 解析包含大整数的JSON字符串场景UI自动化用例。
        └── ParsingContainingNestedQuotationMarks.test.ets // 解析包含嵌套引号的JSON字符串场景UI自动化用例。
        └── SerializingBigIntObjects.test.ets // 序列化BigInt对象场景UI自动化用例。
        └── SerializingFloatingPointNumbers.test.ets // 序列化浮点数number场景UI自动化用例。
```

## 具体实现

* 首页包含以下四个分页面。
  * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
  * 解析包含大整数的JSON字符串场景
     * 源码参考：[ParsingContainingBigInts.ets](./entry/src/main/ets/pages/ParsingContainingBigInts.ets)
     * 使用流程：
         * 1、点击进入分页面
         * 2、测试解析包含大整数的JSON字符串场景
           点击"测试解析包含大整数的JSON字符串场景"按钮，应用将演示如何使用BigInt模式解析包含大整数的JSON字符串，避免大整数精度丢失问题。日志区域会显示解析后的number类型和bigint类型数据及其值，展示使用PARSE_AS_BIGINT模式的优势。当前状态更新为"测试解析包含大整数的JSON字符串场景完成"。
  * 解析包含嵌套引号的JSON字符串场景
     * 源码参考：[ParsingContainingNestedQuotationMarks.ets](./entry/src/main/ets/pages/ParsingContainingNestedQuotationMarks.ets)
     * 使用流程：
         * 1、点击进入分页面
         * 2、测试解析包含嵌套引号的JSON字符串场景（方式1）
           点击"测试解析包含嵌套引号的JSON字符串场景, 方式1"按钮，应用将演示通过修改JSON字符串结构的方式处理嵌套引号问题。将原始字符串中的嵌套引号结构修改为正常的JSON对象嵌套结构，日志区域会显示序列化后的对象信息和成功提取的name字段值（zhangsan）。当前状态更新为"测试解析包含嵌套引号的JSON字符串场景, 方式1完成"。
         * 3、测试解析包含嵌套引号的JSON字符串场景（方式2）
           点击"测试解析包含嵌套引号的JSON字符串场景, 方式2"按钮，应用将演示通过双重转义处理嵌套引号的方式。对原始JSON字符串进行双重转义，然后进行两次解析操作，日志区域会显示第一次解析后的对象信息和第二次解析后成功提取的name字段值（zhangsan）。当前状态更新为"测试解析包含嵌套引号的JSON字符串场景, 方式2完成"。
  * 序列化BigInt对象场景
     * 源码参考：[SerializingBigIntObjects.ets](./entry/src/main/ets/pages/SerializingBigIntObjects.ets)
     * 使用流程：
         * 1、点击进入分页面
         * 2、测试序列化BigInt对象场景（方式1）
           点击"测试序列化BigInt对象场景, 方式1"按钮，应用将演示直接序列化BigInt对象的基本用法。日志区域会显示序列化后的BigInt值（112233445566778899），展示JSON扩展库对BigInt对象的直接序列化支持。当前状态更新为"测试序列化BigInt对象场景, 方式1完成"。
         * 3、测试序列化BigInt对象场景（方式2）
           点击"测试序列化BigInt对象场景, 方式2"按钮，应用将演示通过自定义函数处理BigInt对象的序列化。使用replacer函数将BigInt对象预处理为字符串对象，避免序列化错误，日志区域会显示处理后的序列化结果（"112233445566778899"）。当前状态更新为"测试序列化BigInt对象场景, 方式2完成"。
  * 序列化浮点数number场景
     * 源码参考：[SerializingFloatingPointNumbers.ets](./entry/src/main/ets/pages/SerializingFloatingPointNumbers.ets)
     * 使用流程：
         * 1、点击进入分页面
         * 2、测试序列化浮点数number场景
           点击"测试序列化浮点数number场景"按钮，应用将演示浮点数序列化的精度问题及解决方案。展示小数部分不为零的浮点数可以正常序列化（10.12345），小数部分为零的浮点数会丢失精度（10.00变为10），以及通过自定义函数使用toFixed方法保持固定精度的解决方案。日志区域会显示三种情况的序列化结果，帮助理解浮点数精度处理。当前状态更新为"测试序列化浮点数number场景完成"。

## 依赖

不涉及。

## 相关权限

不涉及。

## 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568。

2.  本示例支持API23版本的SDK，版本号：6.1.0.25。

3.  本示例已支持使用Build Version: 6.0.1.251, built on November 22, 2025。

4.  高等级APL特殊签名说明：无。

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTsCommonLibrary/JsonExtensionLibrary > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master