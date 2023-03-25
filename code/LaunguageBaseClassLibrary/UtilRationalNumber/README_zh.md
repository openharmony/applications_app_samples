# 有理数

### 介绍

[util](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-util.md)工具函数提供多种常用函数，如：实现字符串编解码、有理数运算、缓冲区管理、范围判断、Base64编解码、内置对象类型检查等。

本示例使用[util](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-util.md)中RationalNumber相关接口实现有理数运算,展示了util工具类中的有理数运算的一些方法使用。

使用说明：

1.点击按钮“**有理数比较**”，对两个有理数进行比较，比较结果会在文本框中显示。

2.点击按钮“**获取有理数的值**”，将在文本框中显示第一个有理数的整数或浮点型的值。

3.点击按钮“**获取有理数分子分母**”，在文本框中显示有理数的分子分母。

4.点击按钮“**检查是否为0**”，在文本框中显示判断有理数是否为0的结果。

5.点击按钮“**检查是否表示NaN**”，在文本框中显示判断有理数是否为非数字结果。

6.点击按钮“**检查是否为有限值**”，在文本框中显示有理数是否为有限值结果。

### 效果预览

|主页|
|--------------------------------|
|![](./screenshots/device/eTSRationalNumber.png)|

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例已适配API10版本SDK，版本号：4.0.5.1。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。