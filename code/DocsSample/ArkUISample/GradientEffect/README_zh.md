# ArkUI使用滚动类指南文档示例

### 介绍

本示例展示了[@Once：初始化同步一次](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-internationalization.md)UI国际化的使用方法：

使用说明：
1. 该工程可以选择在模拟器和开发板上运行。
2. 点击构建，即可在生成的应用中点击对应的按钮，观察自定义占位节点的不同应用。
3. 进入”DocsSample/ArkUISample/GradientEffect/entry/src/ohosTest/ets/test/index.test.ets“文件，可以对本项目进行UI的自动化测试。
### 效果预览

| 首页                                 | 列表类组件目录                            | 列表中显示数据示例                            |
|------------------------------------|------------------------------------|------------------------------------|
| ![](screenshots/device/image1.png) | ![](screenshots/device/image2.png) | ![](screenshots/device/image3.png) |

### 使用说明

1. 在主界面，可以点击对应卡片，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
|---entryability
|---homePage
|   |---DirectionGradientEffect.ets     //角度渐变效果  
|   |---LinearGradientEffect.ets       //线性渐变效果
|   |---RadialGradientEffect.ets      //径向渐变效果
|---pages
|   |---Index.ets                       // 应用主页面
entry/src/ohosTest/
|---ets
|   |---index.test.ets                 // 示例代码测试代码
```
### 具体实现

1. 选择需添加渐变的组件（如Column、Button），调用.linearGradient()方法。
2. 配置angle参数（如 180° 表示从上到下，45° 表示从左上到右下），确定渐变方向。
3. 在colors参数中设置两个颜色断点，格式为[[色值1, 比重1], [色值2, 比重2]]（例：[[0xf56c6c, 0.0], [0xffffff, 1.0]]，0.0 为起始点，1.0 为结束点）。
4. 无需设置repeating（默认 false），确保渐变仅在组件内完整显示一次。
5. 在组件的linearGradient配置中，设置repeating: true，启用重复渐变；
6. 定义 2-3 个高对比度颜色（如红0xf56c6c、橙0xE6A23C），并将颜色断点的比重范围缩小（例：[[0xf56c6c, 0.0], [0xE6A23C, 0.3]]）。
7. 调整angle为 0°（水平方向），让渐变沿横向循环。

### 相关权限

不涉及。

### 依赖

不涉及。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/GradientEffect > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````