# 使用UI上下文接口操作界面（UIContext） 测试用例归档

## 用例表

| 测试功能            | 预置条件   | 输入                            | 预期输出      | 是否自动 | 测试结果 |
| ------------------- |--------|-------------------------------|-----------| :------- | -------- |
| 测试在单Ability场景中，直接获取Ability的context属性。 | 设备正常运行 | 通过点击文本组件让文本组件的背景颜色改变          | 文本组件颜色改变  | 是       | Pass     |
| 测试将EntryOptions的useSharedStorage参数设置为true，使用共享的LocalStorage实例对象。 | 设备正常运行 | 通过点击文本组件让文本组件的文字内容改变          | 文本组件内容改变  | 是       | Pass     |
| 测试UIContext替代全局接口 - VpPage | 设备正常运行 | 点击文本'Caculate 20vp to px'      | 显示文本内容    | 是       | Pass     |
| 测试UIContext替代全局接口 - CalendarPickerDialogPage | 设备正常运行 | 点击文本'Show CalendarPicker Dialog' | 显示日历选择对话框 | 是       | Pass     |
| 测试UIContext替代全局接口 - WindowTestPage | 设备正常运行 | 点击文本'Create SubWindow'          | 创建并显示子窗口  | 是       | Pass     |
| 测试UIContext替代全局接口 - NewGlobal | 设备正常运行 | 点击文本'Calculate 20vp to px'          | 显示文本内容    | 是       | Pass     |
