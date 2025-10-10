# NativeDialogSample 测试用例归档

## 用例表

| 测试功能                                     | 预置条件       | 输入                            | 预期输出                                                  | 是否自动 | 测试结果 |
|------------------------------------------| -------------- |-------------------------------|-------------------------------------------------------| :------- | -------- |
| 显示弹框成功示例验证            | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br /> 2.点击点此打开弹窗按钮  查看验证结果 | 显示弹框成功 | 是       | Pass     |
| 应用退出示例验证            | 应用位于首页 | 1.点击 退出应用 查看验证结果 | 应用退出成功                              | 是       | Pass     |
| 显示弹框成功示例验证      | 应用位于首页 | 1.点击 .CustomDialogController_CAPI对接示例按钮<br/>2.点击 点此打开弹窗按钮 查看验证结果 | 显示弹框成功        | 是       | Pass     |
| 弹窗关闭示例验证 | 应用位于首页 | 1.点击  .CustomDialogController_CAPI对接示例按钮<br/>2.点击 点此打开弹窗按钮<br/>3.点击 点此打开弹窗按钮 查看验证结果 | 弹窗关闭成功         | 是       | Pass     |
| 系统默认的对齐方式示例验证 | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 设置自定义弹窗对齐方式<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 弹窗位置在顶部成功 | 是 | Pass |
| 是否开启模态样式实例验证 | 应用位于首页 | 1.点击 .CustomDialogController_CAPI对接示例按钮<br/>2.点击设置属性按钮<br/>3.点击 是否开启模态样式的弹窗。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5点击弹框中Close Dialog 按钮<br/>6点击重置属性按钮 | 选择 是  弹框周边为灰色<br/>选择 否  弹窗周边无灰色 | 是 | Pass |
| 是否允许通过点击遮罩层退出示例验证 | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 是否允许通过点击遮罩层退出。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 选择 是  点击弹框外弹窗可以退出<br/>选择 否 点击弹框外弹窗不可以退出 | 是 | Pass |
| 设置自定义弹窗遮罩属性示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击设置属性按钮<br/>3.点击 设置自定义弹窗遮罩属性。<br/>4点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮 查看验证结果<br/>6.点击 重置属性按钮 | 弹窗周边为红色 | 是 | Pass |
| 背景颜色示例验证 | 应用位于首页 | 1.点击 .CustomDialogController_CAPI对接示例按钮<br/>2.点击设置属性<br/>3.点击 背景颜色：白色。<br/>4.点击点此打开弹窗按钮 查看验证结果<br/>5.点击弹框中Close Dialog 按钮<br/>6.点击重置属性 | 弹窗中为白色 | 是 | Pass |
| 设置弹窗背板圆角半径示例验证 | 应用位于首页 | 2.点击 .CustomDialogController_CAPI对接示例按钮<br/>3.点击 设置属性按钮<br/>4.点击 设置弹窗背板圆角半径。<br/>5.点击 点此打开弹窗按钮 查看验证结果<br/>6.点击 弹框中Close Dialog 按钮<br/>7.点击重置属性按钮 | 弹窗中的圆角比不设置任何属性点击打开弹窗是四边圆角值小 | 是 | Pass |
| 设置弹窗宽度占栅格宽度的个数示例验证 | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性<br/>3.点击 设置弹窗宽度占栅格宽度的个数。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性 | 属性设置结果显示<br/>Set the number of grid widths that the popup occupies to 20 | 是 | Pass |
| 弹窗容器样式是否可以自定义示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 弹窗容器样式是否可以自定义。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 选择 是  点击弹框无边框<br/>选择 否  点击弹框有边框 | 是 | Pass |
| 弹窗容器是否使用自定义弹窗动画示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 弹窗容器是否使用自定义弹窗动画。<br/>4.点击 点此打开弹窗按钮  查看验证结果<br/>6.点击 弹框中Close Dialog 按钮<br/>7.点击 重置属性按钮 | 属性设置结果显示<br/>Apply custom transition effects to the modal | 是 | Pass |
| 触发系统定义的返回操作失效示例验证 | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性<br/>3.点击 触发系统定义的返回操作失效。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性 | 屏幕下最下方的三角形返回按钮失效 | 是 | Pass |
| 显示弹框示例验证 | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br/>2.点击 点此打开弹窗按钮 查看验证结果<br/>3.点击 弹框中Close Dialog 按钮<br/>4.点击 重置属性按钮 | 显示弹框成功 | 是 | Pass |
| 弹框关闭示例验证 | 应用位于首页 | 1.点击 .CustomDialogController_CAPI对接示例按钮<br/>2.点击 点此打开弹窗按钮<br/>3.点击 弹框中Close Dialog 按钮  查看验证结果<br/>4.点击 重置属性 按钮 | 显示弹框关闭成功 | 是 | Pass |
| 弹窗避让键盘模式示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击  是否开启模态样式的弹窗 选择 否<br/>4.点击  弹窗避让键盘模式 <br/>5.点击 点此打开弹窗按钮 查看验证结果<br/>6.点击  输出框最右边 显示出键盘<br/>7.点击 弹框中Close Dialog 按钮<br/>8.点击 重置属性按钮 | 键盘覆盖了弹窗 | 是 | Pass |
| 设置弹窗的显示层级示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 设置弹窗的显示层级 选择 ARKUI_LEVEL_MODE_OVERLAY 。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 属性设置结果显示ARKUI_LEVEL_MODE_OVERLAY | 是 | Pass |
| 设置弹窗的显示层级示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 设置弹窗的显示层级 选择 ARKUI_LEVEL_MODE_EMBEDDED。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 属性设置结果显示ARKUI_LEVEL_MODE_EMBEDDED | 是 | Pass |
| 设置弹窗显示层级页面下的节点id示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性<br/>3.点击设置弹窗显示层级页面下的节点id。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性 | 属性设置结果显示<br/>Sets the level uniqueId to 0 for a custom dialog box | 是 | Pass |
| 设置嵌入式弹窗蒙层的显示区域示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性<br/>3.点击 设置嵌入式弹窗蒙层的显示区域。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性 | 属性设置结果显示<br/>ARKUI_IMMERSIVE_MODE_DEFAULT / ARKUI_IMMERSIVE_MODE_EXTEND | 是 | Pass |
| 设置自定义弹窗显示的顺序示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性<br/>3.点击 设置自定义弹窗显示的顺序。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性 | 属性设置结果显示<br/>Set the display order of the custom dialog box to 0 | 是 | Pass     |
| 弹框状态变化示例验证                     | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br/>2.点击点此打开弹窗按钮  查看验证结果<br/>3.点击 弹框中Close Dialog 按钮 | 显示弹框成功<br/> 弹框状态变化 (回调函数  实质不绘制)        | 是       | Pass     |
| 边框颜色示例验证                         | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 边框颜色：黄色。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 边框颜色为黄色                                               | 是       | Pass     |
| 边框样式示例验证                         | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 边框样式：点状。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 边框样式为点状                                               | 是       | Pass     |
| 默认边宽示例验证                         | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br/>2.点击点此打开弹窗按钮  查看验证结果<br/>3.点击 重置属性按钮 | 显示弹窗有边宽 <br/>属性设置结果中 显示 width: 300vp         | 是       | Pass     |
| 默认边高示例验证                         | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br/>2.点击点此打开弹窗按钮  查看验证结果<br/>3.点击 重置属性按钮 | 显示弹窗有边宽 <br/>属性设置结果中 显示 height: 200vp        | 是       | Pass     |
| 背板阴影示例验证                         | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 背板阴影。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 边框周围有阴影                                               | 是       | Pass     |
| 自定义弹窗的背板阴影示例验证             | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 自定义弹窗的背板阴影。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 弹框内为红色 边框周围有阴影                                  | 是       | Pass     |
| 背板模糊材质示例验证                     | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 背板模糊材质。<br/>4.点击 点此打开弹窗按钮 查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 弹框内为灰色                                                 | 是       | Pass     |
| 悬停态下自定义弹窗默认展示区域示例验证   | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  悬停态下自定义弹窗默认展示区域  选择  上半屏  或 下半屏。<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 属性设置结果显示<br/>Effective only on foldable screens      | 是 | Pass |
| 是否响应悬停态示例验证 | 应用位于首页 | 1.点击 CustomDialogController_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 是否响应悬停态。<br/>4.点击 点此打开弹窗按钮   查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 属性设置结果显示<br/>Effective only on foldable screens | 是 | Pass |
| 是否获取焦点示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  是否开启模态样式弹窗  选择否<br/>4.点击  是否获取焦点  选择 是。<br/>5.点击  点此打开弹窗按钮   查看验证结果<br/>6.点击  弹框中Close Dialog 按钮<br/>7.点击  重置属性按钮 | 点击输入框 打开键盘 点击弹框内区域 键盘自动回收 | 是 | Pass |
| 是否获取焦点示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  是否开启模态样式弹窗  选择否<br/>4.点击  是否获取焦点  选择 否。<br/>5.点击  点此打开弹窗按钮   查看验证结果<br/>6.点击  弹框中Close Dialog 按钮<br/>7.点击  重置属性按钮 | 点击输入框 打开键盘 点击弹框内区域 键盘不回收 | 是 | Pass |
| 设置弹窗的背景模糊效果示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  设置弹窗的背景模糊效果。<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 设置自定义弹窗的背景效果参数 | 是 | Pass |
| 设置自定义弹窗的背景效果参数示例验证 | 应用位于首页 | 1.点击  CustomDialogController_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  设置自定义弹窗的背景效果参数。<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 弹框内部颜色有变化 | 是 | Pass |
| 弹框创建/打开/关闭示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  点此打开弹窗按钮   查看验证结果<br/>3.点击  弹框中Close Dialog 按钮<br/>4.点击  重置属性按钮 | 弹框创建、打开、关闭成功 | 是 | Pass |
| 应用退出示例验证 | 应用位于首页 | 1.点击   关闭应用按钮 | 应用退出 | 是 | Pass |
| 设置弹窗的显示层示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 设置弹窗的显示层级  是  /  否 <br/>4.点击 点此打开弹窗按钮   查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 属性设置结果显示<br/>ARKUI_LEVEL_MODE_OVERLAY  /  ARKUI_LEVEL_MODE_EMBEDDED | 是 | Pass |
| 设置背景颜色示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 背景颜色：红色 <br/>4.点击 点此打开弹窗按钮   查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 背景颜色：红色 | 是 | Pass |
| 圆角半径示例验证 | 应用位于首页 | 1.点击 OpenCustomDialog_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 圆角半径：15<br/>4.点击 点此打开弹窗按钮   查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 弹窗中的圆角比不设置任何属性点击打开弹窗是四边圆角值小 | 是 | Pass |
| 边框颜色示例验证 | 应用位于首页 | 1.点击 OpenCustomDialog_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 边框颜色：黄色<br/>4.点击 点此打开弹窗按钮   查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 弹框边框颜色为 黄色 | 是 | Pass |
| 边框样式示例验证 | 应用位于首页 | 1.点击 OpenCustomDialog_CAPI对接示例按钮<br/>2.点击 设置属性按钮<br/>3.点击 边框样式：点状<br/>4.点击 点此打开弹窗按钮   查看验证结果<br/>5.点击 弹框中Close Dialog 按钮<br/>6.点击 重置属性按钮 | 弹框边框样式为 点状 | 是 | Pass |
| 边框宽跟高示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  点此打开弹窗按钮   查看验证结果<br/>3.点击  弹框中Close Dialog 按钮<br/>4.点击  重置属性按钮 | 属性设置结果显示<br/>width: 300vp   height: 200vp | 是 | Pass |
| 背板阴影示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  背板阴影<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 弹框边框有阴影 | 是 | Pass |
| 自定义背板阴影示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  自定义背板阴影<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 弹框边框有阴影  弹框后有黑色边框                             | 是 | Pass |
| 背板材质示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  轻薄材质模糊<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 弹框内变灰色 | 是 | Pass |
| 对齐模式示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击 对齐模式：垂直居中开始<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 弹框垂直居中开始 | 是 | Pass |
| 是否开启模态样式示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击 是否开启模态样式  是/否<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 是   弹框边框外颜色无变化                                         否   弹框边框外颜色无变化 | 是 | Pass |
| 弹窗是否在子窗口显示此弹窗示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击 弹窗是否在子窗口显示此弹窗  开启/ 关闭<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 开启   再点设置属性栏   属性栏 在弹框页面下                     关闭   再点设置属性栏   属性栏 在弹框页面下 | 是 | Pass |
| 自定义弹窗遮罩属性 示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  自定义弹窗遮罩属性<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 弹框内外显示红色 | 是 | Pass |
| 避让键盘的模式示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  是否开启模态  选择 否 <br/>4.点击  避让键盘的模式 避让 / 不避让<br/>5.点击  点此打开弹窗按钮   查看验证结果<br/>6.点击  弹框中Close Dialog 按钮<br/>7.点击  重置属性按钮 | 不避让      弹框在 点击输入框打开显示键盘后 弹框不避让               避让          弹框在 点击输入框打开显示键盘后 弹框向上移动 进行避让键盘 | 是 | Pass |
| 是否响应悬停态示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮（仅折叠屏显示）<br/>2.点击  设置属性按钮<br/>3.点击 是否响应悬停态<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 属性设置结果显示<br/>Effective only on foldable screens | 是 | Pass |
| 悬停态下弹窗默认展示区域示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮（仅折叠屏显示）<br/>2.点击  设置属性按钮<br/>3点击  悬停态下弹窗默认展示区域  选择 上半屏 / 下半屏<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 上半屏 属性设置结果显示 ARKUI_LEVEL_MODE_OVERLAY       下半屏 属性设置结果显示 ARKUI_LEVEL_MODE_EMBEDDED | 是 | Pass |
| 注册系统关闭自定义弹窗的监听事件示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  注册系统关闭自定义弹窗的监听事件。<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 屏幕最下方三角形系统返回 按键失效 | 是 | Pass |
| 弹框状态示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  点此打开弹窗按钮   查看验证结果<br/>3.点击  弹框中Close Dialog 按钮<br/>4.点击  重置属性按钮 | 弹框状态显示<br/>DIALOG_UNINITIALIZED<br/>DIALOG_INITIALIZED<br/>DIALOG_APPEARING<br/>DIALOG_DISAPPEARED | 是 | Pass |
| 背景模糊效果示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  背景模糊效果。<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 弹框内变为深色 | 是 | Pass |
| 背景效果参数示例验证 | 应用位于首页 | 1.点击  OpenCustomDialog_CAPI对接示例按钮<br/>2.点击  设置属性按钮<br/>3.点击  背景效果参数。<br/>4.点击  点此打开弹窗按钮   查看验证结果<br/>5.点击  弹框中Close Dialog 按钮<br/>6.点击  重置属性按钮 | 弹框内变为深色                                               | 是 | Pass |



