# DrawableDescriptorSample 测试用例归档

## 用例表

| 测试功能       | 预置条件       | 输入            | 预期输出      | 是否自动 | 测试结果 |
|------------| -------------- |---------------|-----------| :------- | -------- |
| 加载单张图片 | 设备正常运行   | 无| 界面上方第一张图片能够正常显示 | 是       | Pass     |
| 加载动态图片 | 设备正常运行   | 无| 界面上方第二张图片能够正常显示 | 是       | Pass     |
| 调用OH_ArkUI_DrawableDescriptor_GetStaticPixelMap接口 | 设备正常运行   | 无| DevEco Studio开发环境查看有"GetStaticPixelMap success"相关日志 | 是       | Pass     |
| 调用OH_ArkUI_DrawableDescriptor_GetAnimatedPixelMapArray接口 | 设备正常运行   | 无| DevEco Studio开发环境查看有"GetAnimatedPixelMapArray success"相关日志 | 是       | Pass     |
| 调用OH_ArkUI_DrawableDescriptor_GetAnimatedPixelMapArraySize接口 | 设备正常运行   | 无| DevEco Studio开发环境查看有"GetAnimatedPixelMapArraySize success"相关日志 | 是       | Pass     |
| 调用OH_ArkUI_DrawableDescriptor_Dispose接口 | 设备正常运行   | 无| DevEco Studio开发环境查看有"Dispose success"相关日志 | 是       | Pass     |
| 设置duration属性 | 设备正常运行   | 点击"设置duration"后面的"设置"按钮| duration值能够正常显示 | 是       | Pass     |
| 获取duration属性 | 设备正常运行   | 点击"设置duration"后面的"设置"按钮| duration值能够正常显示 | 是       | Pass     |
| 设置iteration属性 | 设备正常运行   | 点击"设置iteration"后面的"设置"按钮| iteration值能够正常显示 | 是       | Pass     |
| 获取duration属性 | 设备正常运行   | 点击"设置iteration"后面的"设置"按钮| iteration值能够正常显示 | 是       | Pass     |