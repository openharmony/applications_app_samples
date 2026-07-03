# GlobalReuse（全局复用）测试用例归档

## 用例表

根据提供的测试用例，以下是整理出的测试用例表格：

| 测试功能                              | 预置条件     | 输入                   | 预期输出      | 测试结果 |
|-----------------------------------| ------------ | ---------------------- |-----------| -------- |
| 默认全局复用池场景                            | 设备正常运行 | 点击"Switch components"按钮两次 | 组件A和组件B切换显示，复用组件ReusableComponent在默认复用池中被销毁和重建    | Pass     |
| 全局复用池配置场景                            | 设备正常运行 | 点击"Switch components"按钮两次 | 组件A和组件B切换显示，ReusableComponent被全局复用池接纳并复用    | Pass     |
| 全局复用池信息获取场景                            | 设备正常运行 | 点击"切换组件"、"检查GlobalChild"、"检查LegacyComp"、"设置复用池大小"按钮 | 复用池信息正确打印到日志，设置复用池大小后对应组件实例被释放    | Pass     |
| 多级全局复用池场景                            | 设备正常运行 | 点击"切换 ParentA"、"切换 ChildA"按钮 | 父组件和子组件正确切换，ReusableLeaf跟随ChildA存入全局复用池    | Pass     |
| perInstance所有权模式场景                            | 设备正常运行 | 点击"切换组件"和"增加 +10"按钮 | 组件正确切换，@Consumer状态同步正常工作，Provider值正确增加    | Pass     |
| 预渲染场景                            | 设备正常运行 | 点击"Switch"和"Check pool"按钮 | 预渲染的ReusableComponent被复用，复用池信息正确显示    | Pass     |
| reuseId配置场景                            | 设备正常运行 | 点击"切换A"、"切换B"、"切换C"、"仅清除B"、"打印复用池信息"按钮 | 不同reuseId的组件独立管理，清除指定reuseId时只释放对应组件    | Pass     |
| shared共享池场景                            | 设备正常运行 | 点击"删除Comp1/2/3"和"添加Comp1/2/3"按钮 | 多个CompA实例共用ReusableCompA的全局复用池，组件正确删除和添加    | Pass     |

