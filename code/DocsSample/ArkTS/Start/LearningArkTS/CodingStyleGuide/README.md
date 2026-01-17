# ArkTS编程规范

## 介绍

本文参考业界标准和实践，结合ArkTS语言特点，提供编码指南，以提高代码的规范性、安全性和性能。

## 效果预览

| 首页 |
| -- |
| ![Index](./screenshots/Index.png) |

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets // 首页。
    └── lib.ets // 函数文件。
entry/src/ohosTest/
└── ets
    └── test
        └── JavaToArkTs.test.ets // UI自动化用例。
```

## 具体实现

* ArkTS编程规范
  * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
  * 使用流程：
    * 1、启动应用
         打开应用后，界面将显示"实时状态信息"面板，包含"当前状态"和"日志信息"两个区域。初始状态显示"未初始化"，日志信息显示"暂无日志信息"。
    * 2、ArkTs编译规范-首字母大写的驼峰命名法
         点击"ArkTs编译规范-首字母大写的驼峰命名法"按钮，应用将完成使用首字母大写的驼峰命名法定义的类、枚举与命名空间。日志区域会显示类User和枚举UserType的值，当前状态更新为"测试首字母大写的驼峰命名法完成"。
    * 3、ArkTs编译规范-首字母小写的驼峰命名法
         点击"ArkTs编译规范-首字母小写的驼峰命名法"按钮，应用将完成首字母小写的驼峰命名法定义的函数与变量。日志区域会显示函数sendMsg与findUser的参数，当前状态更新为"测试首字母小写的驼峰命名法完成"。
    * 4、ArkTs编译规范-常量命名全大写
         点击"ArkTs编译规范-常量命名全大写"按钮，应用将完成全大写命名的常量的定义与使用。日志区域会显示MAX_USER_SIZE的值，当前状态更新为"测试常量命名全大写完成"。
    * 5、ArkTs编译规范-布尔变量命名
         点击"ArkTs编译规范-布尔变量命名"按钮，应用将完成定义布尔类型变量的命名方式的反例与正例。当前状态更新为"测试布尔变量命名完成"。
    * 6、ArkTs编译规范-使用空格缩进
         点击"ArkTs编译规范-使用空格缩进"按钮，应用将完成使用空格进行缩进类与函数。当前状态更新为"测试使用空格缩进完成"。
    * 7、ArkTs编译规范-使用大括号
         点击"ArkTs编译规范-使用大括号"按钮，应用将完成使用大括号的反例与正例。当前状态更新为"测试使用大括号完成"。
    * 8、ArkTs编译规范-综合
         点击"ArkTs编译规范-综合"，应用将完成多项编译规范的使用。当前状态更新为"测试综合完成"。

## 依赖

不涉及。

## 相关权限

不涉及。

## 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例支持API23版本的SDK，版本号：6.1.0.25；

3.  本示例已支持使用Build Version: 6.0.1.251, built on November 22, 2025；

4.  高等级APL特殊签名说明：无；

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/Start/LearningArkTS/CodingStyleGuide > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```
