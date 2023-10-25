# 测试框架

### 介绍
本示例展示测试框架中单元测试框架的使用示例。

本实例用到了自动化测试框架代码部件仓arkXtest，测试框架的详细介绍[arkXtest](https://gitee.com/openharmony/testfwk_arkxtest#%E4%BD%BF%E7%94%A8%E6%96%B9%E5%BC%8F) 。   

如需日志打印调试，需要引入日志打印接口[@ohos.hilog](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-hilog.md)  。  

单元测试用例相较于UI自动化测试用例而言更偏重于接口返回数据的校验及逻辑处理。


### 效果预览
不涉及

使用说明
- 将jsunit目录下的项目工程整体导入到DevEco Studio开发工具中。
- 查看ohostest目录下的测试代码实现。
- 在DevEco Studio中执行测试用例代码查看执行效果，执行方式请[参考](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/ohos-openharmony-test-framework-0000001263160453) 。

### 工程目录

```
jsunit
|-----entry 
          |-----src/main/pages
                |-----index.ets                         // 放页面组件 
          |-----ohosTest                                // 放自动化测试用例
                |-----ets/test/basicExampleTest
                      |-----basicExampleTest.ets        // 放自动化测试脚本，其中it()就是一个测试用例
|-----AppScope
          |-----app.json5                               // 定义应用唯一的包名："bundleName": "com.samples.test.jsunit",
```

### 具体实现

#### jsunit单元测试框架示例内容
* 1）在entry的index.ets中放页面组件。
* 2）在ohosTest的test/basicExample.test.ets中it()定义一条测试用例，支持三个参数：用例名称，过滤参数和用例函数。用例操作的行为以异步的形式编写。
* 3）通过Want配置指定唯一的ability即entry：通过want()中指定bundleName：com.samples.test.jsunit和abilityName：EntryAbility。
* 4）启动指定ability(相当于手动运行hap)：通过abilityDelegatorRegistry.getAbilityDelegator.startAbility(want)。
* 5）获取当前应用最顶层的ability对象：通过abilityDelegatorRegistry.getAbilityDelegator.getCurrentTopAbility().then((ability)=>{}) 。
* 6）在第5步.then()中加入需要测试内容：
    * 例如本案例中需要检验当前UIAbility的abilityname是否正确，在第五步中引入断言接口，并检查断言结果是否符合预期：通过expect().assertEqual()断言检查实际值（actualvalue）是否等于期望值（expectvalue）。
* 7）测试完毕： done();


### 相关权限
不涉及

### 依赖
不涉及

### 约束与限制
1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0 Release)。

3.本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Project/Test > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
