#### InitiatePrintW3CAPI

| 测试功能                | 预置条件     | 输入                        | 预期输出               | 是否自动 | 测试结果 |
| ----------------------- | ------------ | --------------------------- | ---------------------- | -------- | -------- |
| 使用Web组件打印前端页面 | 设备运转正常 | 应用启动成功，点击print按钮 | 触发window.print()操作 | Yes      | Pass     |

#### InitiatePrintAppAPI

| 测试功能                | 预置条件     | 输入                                                | 预期输出     | 是否自动 | 测试结果 |
| ----------------------- | ------------ | --------------------------------------------------- | ------------ | -------- | -------- |
| 使用Web组件打印前端页面 | 设备运转正常 | 应用启动成功，点击createWebPrintDocumentAdapter按钮 | 触发打印操作 | Yes      | Pass     |

#### PreviewPDF

| 测试功能                     | 预置条件     | 输入         | 预期输出                               | 是否自动 | 测试结果 |
| ---------------------------- | ------------ | ------------ | -------------------------------------- | -------- | -------- |
| 使用Web组件的PDF文档预览能力 | 设备运转正常 | 应用启动成功 | Web组件创建时指定默认加载的网络PDF文档 | Yes      | Pass     |

#### CalcAdjustSafeArea

| 测试功能                     | 预置条件                     | 输入         | 预期输出                                    | 是否自动 | 测试结果 |
| ---------------------------- | ---------------------------- | ------------ | ------------------------------------------- | -------- | -------- |
| 网页中安全区域计算和避让适配 | 设备运转正常，开启沉浸式效果 | 应用启动成功 | Web组件根据实际情况对网页元素进行相应的避让 | Yes      | Pass     |

