# RulesAndRestrictions 测试用例归档

## 用例表

| 测试功能                                                     | 预置条件                              | 输入            | 预期输出               | 是否自动 | 测试结果 |
| ------------------------------------------------------------ | ------------------------------------- | --------------- | ---------------------- | -------- | -------- |
| 拉起应用                                                     | 设备正常运行                          |                 | 成功拉起应用           | 是       | Pass     |
| Sendable class只能继承自Sendable class                       | 位于InheritOnly模块Index.ets          | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 非Sendable class只能继承自非Sendable class                   | 位于InheritedFromNon模块Index.ets     | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 非Sendable class只能实现非Sendable interface                 | 位于AchieveNon模块Index.ets           | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| Sendable class/interface成员变量必须是Sendable支持的数据类型 | 位于VariableSupport模块Index.ets      | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| Sendable class/interface的成员变量不支持使用!断言            | 位于VariableNotSupported模块Index.ets | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| Sendable class/interface的成员变量不支持使用计算属性名       | 位于NoCalculationSupport模块Index.ets | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 泛型类中的Sendable class，collections.Array，collections.Map，collections.Set的模板类型必须是Sendable类型 | 位于TemplateType模块Index.ets         | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| Sendable class的内部不允许使用当前模块内上下文环境中定义的变量 | 位于NotAllowedInside模块Index.ets     | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| Sendable class和Sendable function不能使用除了@Sendable的其它装饰器 | 位于CannotBeUsed模块Index.ets         | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 不能使用对象字面量/数组字面量初始化Sendable类型              | 位于ObjectLiterals模块Index.ets       | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 非Sendable类型不可以as成Sendable类型                         | 位于TypeCannot模块Index.ets           | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 箭头函数不支持共享                                           | 位于ArrowFunctions模块Index.ets       | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| Sendable装饰器修饰类型时仅支持修饰函数类型                   | 位于achievenon模块Index.ets           | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |