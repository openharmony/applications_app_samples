# XML转换

## 介绍

本示例主要介绍了将XML文本转换为JavaScript对象的示例。

## 效果预览

| XML转换页面                                     |
|----------------------------------------|
| ![Index](./screenshots/Index.png)      |

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets // XML转换页面。 
entry/src/ohosTest/
└── ets
    └── test
        └── ConvertXML.test.ets // 将XML文本转换为JavaScript对象的UI自动化用例。
```

## 具体实现

* XML转换页面。
  * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
     * 使用流程：
         * 点击"测试ConvertXML"按钮，创建 ConvertXML 实例，调用 fastConvertToJSObject() 方法转换，将结果对象序列化为 JSON 字符串。日志区域会显示转换后的结果。当前状态更新为"测试ConvertXML完成"。

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
echo code/DocsSample/ArkTS/ArkTsCommonLibrary/XmlGenerationParsingAndConversion/XmlConversion > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master