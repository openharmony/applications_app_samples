# Test测试框架
## 介绍 
Test 目录下面包括了 jsunit, uitest 俩个项目, jsunit项目是介绍arkxTest测试框架整体的功能,以及使用示例代码。
 uitest 项目是介绍uitest测试框架整体功能,以及使用示例代码。

# 效果预览
不涉及


## 使用说明
- 下载 jsunit uitest 项目
- 导入本地 DevEco Studio 工具中编译项目
- 查看, 或者执行 ohosTest 目录下面的测试用例，


## jsunit项目

### arkXtest 框架整体功能
- 基础断言能力
- Mock能力
- 数据驱动能力
- 测试用例过滤执行能力

### jsunit项目工程目录
```
entry/src/ohosTest/ets
|---test
|   |--- basicExampleTest
         |---  basicExampleTest.ets              
|   |--- List.test.ets
|---testability  
|---|testrunner

```
### 具体实现

- basicExampleTest.ets  arkXtest 测试框架基础使用示例代码

## uitest 项目

### uiTest 测试框架功能
- [On](#on9)：提供控件特征描述能力，用于控件筛选匹配查找。
- [Component](#component9)：代表UI界面上的指定控件，提供控件属性获取，控件点击，滑动查找，文本注入等能力。
- [Driver](#driver9)：入口类，提供控件匹配/查找，按键注入，坐标点击/滑动，截图等能力。
- [UiWindow<sup>](#uiwindow9)：入口类，提供窗口属性获取，窗口拖动、调整窗口大小等能力。
### uitest项目工程目录
```
entry/src/
|--- main
    |--- ets
         |--- EntryAbility
              |--- EntryAbility.ets
         |--- pages
              |--- Index.ets  
    |--- resources  
|--- ohosTest
     |--- ets
          |--- test
               |--- basicExampleTest
                    |--- basicExampleTest.ets       
          |--- testability
          |--- testrunner
```
### uitest项目目录说明
#### 界面说明

- EntryAbility.ets , Index.ets input 基础用例实现UI页面


#### 具体实现
- basicExampleTest.ets  uitest测试框架基础使用代码示例


## 约束与限制
1.本示例仅支持标准系统上运行,支持设备:RK3568.

2.本示例已适配API version 9 版本SDK，版本号：3.2.10.6. 
> 在编译 uitest项目的时候，需要将SDK 9 中的 ohos.uitest.d.ts 修改为 UiTest.d.ts,否则无法使用UiTest框架

3.本示例需要使用DevEco Studio 3.1 Beta1 (Build Version: 3.1.0.200)及以上版本才可编译运行。



### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Project/Test > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```