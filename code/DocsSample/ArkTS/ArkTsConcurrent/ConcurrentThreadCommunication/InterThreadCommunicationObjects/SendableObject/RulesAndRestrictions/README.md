# ArkTS Sendable使用规则与约束

该工程中展示的代码详细描述可查如下链接：

- [Sendable使用规则与约束](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/sendable-constraints.md)

### 效果预览

|                                   首页                                    |                            执行及结果即时反馈                             |
| :-----------------------------------------------------------------------: | :-----------------------------------------------------------------------: |
| <img src="./screenshots/RulesAndRestrictions_1.png" style="zoom: 50%;" /> | <img src="./screenshots/RulesAndRestrictions_2.png" style="zoom: 50%;" /> |

### 使用说明

1. 在主界面中，点击任意功能按钮可跳转至相应页面，随后点击界面显示的文本字符串即可触发程序执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
achievenon/src/
 ├── main
 │   ├── ets
 │   │   ├── achievenonability
 │   │   ├── pages
 │   │       ├── Index.ets             // 非Sendable class只能实现非Sendable interface和Sendable装饰器修饰类型时仅支持修饰函数类型
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
arrowfunctions/src/
 ├── main
 │   ├── ets
 │   │   ├── arrowfunctionsability
 │   │   ├── pages
 │   │       ├── Index.ets             // 箭头函数不支持共享
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
cannotbeused/src/
 ├── main
 │   ├── ets
 │   │   ├── cannotbeusedability
 │   │   ├── pages
 │   │       ├── Index.ets             // Sendable class和Sendable function不能使用除了@Sendable的其它装饰器
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
inheritedfromnon/src/
 ├── main
 │   ├── ets
 │   │   ├── inheritedfromnonability
 │   │   ├── pages
 │   │       ├── Index.ets             // 非Sendable class只能继承自非Sendable class
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
inheritonly/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets             // Sendable class只能继承自Sendable class
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
nocalculationsupport/src/
 ├── main
 │   ├── ets
 │   │   ├── nocalculationsupportability
 │   │   ├── pages
 │   │       ├── Index.ets             // Sendable class/interface的成员变量不支持使用计算属性名
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
notallowedInside/src/
 ├── main
 │   ├── ets
 │   │   ├── notallowedinsideability
 │   │   ├── pages
 │   │       ├── Index.ets             // Sendable class的内部不允许使用当前模块内上下文环境中定义的变量
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
objectliterals/src/
 ├── main
 │   ├── ets
 │   │   ├── objectliteralsability
 │   │   ├── pages
 │   │       ├── Index.ets             // 不能使用对象字面量/数组字面量初始化Sendable类型
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
templatetype/src/
 ├── main
 │   ├── ets
 │   │   ├── templatetypeability
 │   │   ├── pages
 │   │       ├── Index.ets             // 泛型类中的Sendable class，collections.Array/Map/Set的模板类型必须是Sendable类型
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
typecannot/src/
 ├── main
 │   ├── ets
 │   │   ├── typecannotability
 │   │   ├── pages
 │   │       ├── Index.ets             // 非Sendable类型不可以as成Sendable类型
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
variablenotsupported/src/
 ├── main
 │   ├── ets
 │   │   ├── variablenotsupportedability
 │   │   ├── pages
 │   │       ├── Index.ets             // Sendable class/interface的成员变量不支持使用!断言
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
variablesupport/src/
 ├── main
 │   ├── ets
 │   │   ├── variablesupportability
 │   │   ├── pages
 │   │       ├── Index.ets             // Sendable class/interface成员变量必须是Sendable支持的数据类型
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets      // 自动化测试
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony_5.0.2.58。

3.本示例需要使用DevEco Studio 5.0.1 Release (Build Version: 5.0.5.306, built on December 6, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTsConcurrent/ConcurrentThreadCommunication/InterThreadCommunicationObjects/SendableObject/RulesAndRestrictions > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
