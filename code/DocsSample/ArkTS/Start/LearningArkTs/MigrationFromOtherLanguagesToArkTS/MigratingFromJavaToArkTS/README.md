# 从Java到ArkTS的迁移指导

## 介绍

本示例主要介绍了Java开发者在转向ArkTS开发过程中会遇到的误解和陷阱。

## 效果预览

| 首页                                | 
|-----------------------------------|
| ![Index](./screenshots/Index.png) |

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets                // 首页。
entry/src/ohosTest/
└── ets
    └── test
        └── JavaToArkTs.test.ets // UI自动化用例。  
```

## 具体实现

* 从Java到ArkTS的迁移指导
  * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
  * 使用流程：
    * 1、启动应用
         打开应用后，界面将显示"实时状态信息"面板，包含"当前状态"和"日志信息"两个区域。初始状态显示"未初始化"，日志信息显示"暂无日志信息"。
    * 2、测试类型注解功能
       点击"测试类型注解"按钮，应用将演示ArkTS的类型注解和类型推断功能。日志区域会显示变量age、program和version的值，当前状态更新为"测试类型注解完成"。
    * 3、测试函数定义功能
       点击"测试函数定义"按钮，应用将展示常规函数定义和箭头函数的使用。日志区域会显示add函数和multiply函数的计算结果，当前状态更新为"测试函数定义完成"。
    * 4、测试函数重载功能
       点击"测试函数重载"按钮，应用将演示函数重载特性，展示同一个函数名如何接受不同类型的参数。日志区域会显示"foo success"，当前状态更新为"测试函数重载完成"。
    * 5、测试引入容器集功能
       点击"测试引入容器集"按钮，应用将演示如何从@kit.ArkTS引入collections模块，并创建Array实例。日志区域会显示创建的ArrayList元素数量，当前状态更新为"测试引入容器集完成"。
    * 6、测试命名空间功能
       点击"测试命名空间"按钮，应用将展示命名空间的声明和使用方式。日志区域会显示通过Models命名空间创建的User对象信息，当前状态更新为"测试命名空间完成"。
    * 7、测试this上下文功能
       点击"测试this上下文"按钮,应用将演示this上下文绑定问题及解决方案。通过bind方法正确绑定this上下文，避免程序崩溃。当前状态更新为"测试this上下文完成"。
    * 8、测试类型推断功能
       点击"测试类型推断"按钮，应用将演示编译器的自动类型推断能力。日志区域会显示变量num的值和推断出的类型，当前状态更新为"测试类型推断完成"。
    * 9、测试可选属性功能
       点击"测试可选属性"按钮。可选属性测试会显示接口中可选字段的使用效果。操作后状态都会相应更新，日志区域实时显示执行结果。
    * 10、测试联合类型功能
       点击"测试联合类型"按钮。联合类型测试会展示变量如何接受多种类型的值。操作后状态都会相应更新，日志区域实时显示执行结果。

## 依赖

不涉及。

## 相关权限

不涉及。

## 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例支持API20版本SDK，版本号： 6.0.0.43；

3.  本示例已支持使Build Version: 6.0.0.43, built on August 24, 2025；

4.  高等级APL特殊签名说明：无；

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/Start/LearningArkTs/MigrationFromOtherLanguagesToArkTS/MigratingFromJavaToArkTS > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master