# 适配指导案例

### 介绍

本工程主要提供在ArkTS语法规则下将TS代码适配成ArkTS代码的建议示例。

### 效果预览

| 首页                                                      | 基础适配场景页面                                                |
|---------------------------------------------------------|---------------------------------------------------------|
| <img src="./screenshots/Index.png" style="zoom:50%;" /> | <img src="./screenshots/BasicAdaptation.png" style="zoom:50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面中呈现三个按钮，对应三个分页面，点击之后可分别进入到对应的分页面。
3. 运行测试用例AdaptationCases.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   └── pages                                       // ArkTs建议代码
 │   │       ├── app.ets                                 // export default对象
 │   │       ├── ArkTsNoUntypedObjLiterals.ets           // arkts-no-untyped-obj-literals
 │   │       ├── BasicAdaptation.ets                     // Arkts主要适配示例代码
 │   │       ├── file1.ets                               // arkts-no-globalthis
 │   │       ├── file2.ets                               // arkts-no-globalthis
 │   │       ├── GlobalContext.ets                       // arkts-no-globalthis
 │   │       ├── Index.ets                               // 首页
 │   │       ├── module1.ets                             // arkts-no-type-query
 │   │       ├── module2.ets                             // arkts-no-type-query
 │   │       ├── StrictModeCheck.ets                     // 严格模式检查
 │   │       ├── test.d.ets                              // arkts-no-spread
 │   │       ├── UsingStateVariablesOutsideOfStructs.ets // Struct组件外使用状态变量
 │   │       └── UsingUnionTypesInStructs.ets            // Struct支持联合类型的方案
 │   └── tsPages                                         // TypeScript建议代码
 │       ├── app.ts                                      // export default对象
 │       ├── BasicAdaptation.ts                          // ts主要适配示例代码
 │       ├── file1.ts                                    // arkts-no-globalthis
 │       ├── file2.ts                                    // arkts-no-globalthis
 │       ├── main.ts                                     // arkts-limited-esobj
 │       ├── module1.ts                                  // arkts-no-type-query
 │       ├── module2.ts                                  // arkts-no-type-query
 │       ├── test.d.ts                                   // arkts-no-spread
 │       └── testa.ts                                    // arkts-limited-esobj
 ├── ohosTest
 │   └── ets
 │       └── test
 │           ├── Ability.test.ets
 │           ├── BasicAdaptation.test.ets                // 自动化测试代码
 │           └── List.test
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例支持API23版本的SDK，版本号：6.1.0.25；

3.  本示例已支持使用Build Version: 6.0.1.251, built on November 22, 2025；

4.  高等级APL特殊签名说明：无；

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/Start/LearningArkTs/MigrationFromTypeScriptToArkTS/AdaptationCases > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
