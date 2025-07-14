#  静态加载Native模块测试用例归档

## 用例表

| 测试功能                                      | 预置条件         | 输入                                                  | 预期输出                       | 测试结果 |
|--------------------------------------------|----------------|----------------------------------------------------|----------------------------|--------|
| 拉起应用                                    | 设备正常运行       |                                                     | 成功拉起应用                     | Pass   |
| Native模块默认导入测试(default_import)      | 位于模块测试页面   | 点击调用default_import的Button组件                   | 成功完成默认导入，输出显示5             | Pass       |
| Native模块命名导入测试(named_import)       | 位于模块测试页面   | 点击调用named_import的Button组件                     | 成功完成命名导入，输出显示5             | Pass       |
| Native模块命名空间导入测试(namespace_import)| 位于模块测试页面   | 点击调用namespace_import的Button组件                 | 成功完成命名空间导入，输出显示5           | Pass       |
| Native模块直接导入测试(direct_import)      | 位于模块测试页面   | 点击调用direct_import的Button组件                    | 成功完成直接导入，输出显示5             | Pass       |
| Native模块间接导入测试(indirect_import)    | 位于模块测试页面   | 点击调用indirect_import的Button组件                  | 成功完成间接导入，输出日志显示5           | Pass       |
| Native模块命名导出再导入测试(export_named_and_import)| 位于模块测试页面 | 点击调用export_named_and_import的Button组件         | 成功完成导出再导入，输出日志显示hilog.info | Pass       |
| Native模块命名空间导出导入测试(export_namespace_and_import)| 位于模块测试页面 | 点击调用export_namespace_and_import的Button组件     | 成功完成命名空间导出导入，输出日志显示5       | Pass       |