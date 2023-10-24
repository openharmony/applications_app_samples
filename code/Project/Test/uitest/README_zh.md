# 测试框架
### 介绍
本示例展示测试框架中UI测试框架的使用示例。

测试框架arkxtest的详细介绍请[参考](https://gitee.com/openharmony/testfwk_arkxtest) 。

本实例需要引入UiTest接口[@ohos.UiTest](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-uitest.md) 。  

如需日志打印调试，需要引入日志打印接口[@ohos.hilog](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-hilog.md)  。

其中自动化测试用例编写规范文档，请[参考](https://gitee.com/openharmony/applications_app_samples/blob/master/CodeCommitChecklist.md#ui%E8%87%AA%E5%8A%A8%E5%8C%96%E7%94%A8%E4%BE%8B%E7%BC%96%E5%86%99%E8%A7%84%E8%8C%83) 。



### 效果预览
不涉及

使用说明
- 将uitest目录下的项目工程整体导入到DevEco Studio开发工具中。
- 查看ohostest目录下的测试代码实现。
- 在DevEco Studio中执行测试用例代码查看执行效果，执行方式请[参考](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/ohos-openharmony-test-framework-0000001263160453)  

### 工程目录

```
uitest 
|-----entry 
          |-----src/main/pages
                |-----index.ets                         // 放页面组件 
          |-----ohosTest                                // 放自动化测试用例
                |-----ets/test/basicExampleTest
                      |-----basicExampleTest.ets        // 放自动化测试脚本，其中it()就是一个测试用例
|-----AppScope
          |-----app.json5                               // 定义应用唯一的包名："bundleName": "com.samples.test.uitest",
```
 须知

* 前提：引入UiTest依赖：import {Driver,ON,Component,Uiwindow,MatchPattern} from '@ohos.UiTest'  
1、On类提供的接口全部是同步接口，使用者可以使用builder模式链式调用其接口构造控件筛选条件。  
2、Driver和Component类提供的接口全部是异步接口(Promise形式)，需使用await语法。  
3、Ui测试用例均需使用异步语法编写用例，需遵循单元测试框架异步用例编写规范。

### 具体实现

#### uitestUI测试框架示例内容
* 1）在entry的index.ets中放页面组件。
* 2）在ohosTest的test/basicExample.test.ets中it()定义一条测试用例，支持三个参数：用例名称，过滤参数和用例函数。用例操作的行为以异步的形式编写。
* 3）指定唯一的ability即entry：通过want()中指定bundleName和abilityName：EntryAbility。
* 4）启动指定ability(相当于手动运行hap)：通过abilityDelegatorRegistry.getAbilityDelegator.startAbility(want)。
* 5）获取当前应用最顶层的ability对象：通过abilityDelegatorRegistry.getAbilityDelegator.getCurrentTopAbility().then((ability)=>{}) 。
* 6）引入Driver类作为UiTest测试框架的总入口，提供查找控件,定时器，断言，单机back键等能力。
* 7）在第5步.then()中加入需要测试内容 ：  
    * 例如本案例中需要检验是否可以有back键能力：通过driver.pressBack()。  
    * 检验是否可以定时1s后执行能力:通过driver.delayMs(1000)。  
    * 日志打印：建议用例名称中的包名和日志中的包名单独用常量表示，方便包名变更整改，例如：hilog.info(DOMAIN, TAG, BUNDLE + "StartAbility_001, begin")，日志打印格式[参考](https://gitee.com/openharmony/applications_app_samples/blob/master/CodeCommitChecklist.md#ui%E8%87%AA%E5%8A%A8%E5%8C%96%E7%94%A8%E4%BE%8B%E7%BC%96%E5%86%99%E8%A7%84%E8%8C%83)  。
* 8）结束事件done();


### 相关权限
不涉及

### 依赖
不涉及

### 约束与限制
1.本示例仅支持标准系统上运行。

2.本示例从API version 10 版本SDK起开始支持，SDK版本号(API Version 10 Release),镜像版本号(4.0Release)。

3.本示例需要使用DevEco Studio 版本号(4.0Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Project/Test > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
