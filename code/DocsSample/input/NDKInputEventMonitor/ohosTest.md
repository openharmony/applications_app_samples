# 输入事件监听（ArkTS）

## 用例表

| 测试功能      | 预置条件       | 输入                | 预期输出                      | 是否自动 | 测试结果 |
|-----------|------------|-------------------|---------------------------|------|------|
| 拉起应用      | 设备正常运行     |                   | 成功拉起应用                    | 是    | Pass |
| 添加按键事件监听  | 未添加按键事件监听  | 点击**Add key event monitor**    | 页面显示**Add key event monitor successfully, return 0**  | 是    | Pass |
| 按键事件监听    | 已添加按键事件监听  | 使用按键              | 页面实时显示监听到的按键事件            | 否    | Pass |
| 移除按键事件监听  | 已添加按键事件监听  | 点击**Remove key event monitor**    | 页面显示**Remove key event monitor successfully, return 0**  | 是    | Pass |
| 按键事件不监听   | 已移除按键事件监听  | 使用按键              | 页面不显示按键事件                 | 否    | Pass |
| 添加鼠标事件监听  | 未添加鼠标事件监听  | 点击**Add mouse event monitor**    | 页面显示**Add mouse event monitor successfully, return 0**  | 是    | Pass |
| 鼠标事件监听    | 已添加鼠标事件监听  | 使用鼠标              | 页面实时显示监听到的鼠标事件            | 否    | Pass |
| 移除鼠标事件监听  | 已添加鼠标事件监听  | 点击**Remove mouse event monitor**    | 页面显示**Remove mouse event monitor successfully, return 0**  | 是    | Pass |
| 鼠标事件不监听   | 已移除鼠标事件监听  | 使用鼠标              | 页面不显示鼠标事件                 | 否    | Pass |
| 添加触摸事件监听  | 未添加触摸事件监听  | 点击**Add touch event monitor**    | 页面显示**Add touch event monitor successfully, return 0**  | 是    | Pass |
| 触摸事件监听    | 已添加触摸事件监听  | 使用触屏功能            | 页面实时显示监听到的触摸事件            | 否    | Pass |
| 移除触摸事件监听  | 已添加触摸事件监听  | 点击**Remove touch event monitor**    | 页面显示**Remove touch event monitor successfully, return 0**  | 是    | Pass |
| 触摸事件不监听   | 已移除触摸事件监听  | 使用触屏功能            | 页面不显示触摸事件                 | 否    | Pass |
| 添加轴事件监听   | 未添加轴事件监听   | 点击**Add axis event monitor**     | 页面显示**Add axis event monitor successfully, return 0**   | 是    | Pass |
| 轴事件监听     | 已添加轴事件监听   | 在触摸板进行捏合动作或滚动鼠标滚轮 | 页面实时显示监听到的轴事件             | 否    | Pass |
| 移除轴事件监听   | 已添加轴事件监听   | 点击**Remove axis event monitor**     | 页面显示**Remove axis event monitor successfully, return 0**   | 是    | Pass |
| 轴事件不监听    | 已移除轴事件监听   | 在触摸板进行捏合动作或滚动鼠标滚轮 | 页面不显示轴事件                  | 否    | Pass |
| 添加捏合轴事件监听 | 未添加捏合轴事件监听 | 点击**Add pinch axis event monitor**   | 页面显示**Add pinch axis event monitor successfully, return 0** | 是    | Pass |
| 捏合轴事件监听   | 已添加捏合轴事件监听 | 在触摸板进行捏合动作        | 页面实时显示监听到的捏合轴事件           | 否    | Pass |
| 移除捏合轴事件监听 | 已添加捏合轴事件监听 | 点击**Remove pinch axis event monitor**   | 页面显示**Remove pinch axis event monitor successfully, return 0** | 是    | Pass |
| 捏合轴事件不监听  | 已移除捏合轴事件监听 | 在触摸板进行捏合动作        | 页面不显示捏合轴事件                | 否    | Pass |
| 添加滚动轴事件监听 | 未添加滚动轴事件监听 | 点击**Add scroll axis event monitor**   | 页面显示**Add scroll axis event monitor successfully, return 0** | 是    | Pass |
| 滚动轴事件监听   | 已添加滚动轴事件监听 | 滚动鼠标滚轮            | 页面实时显示监听到的滚动轴事件           | 否    | Pass |
| 移除滚动轴事件监听 | 已添加滚动轴事件监听 | 点击**Remove scroll axis event monitor**   | 页面显示**Remove scroll axis event monitor successfully, return 0** | 是    | Pass |
| 滚动轴事件不监听  | 已移除滚动轴事件监听 | 滚动鼠标滚轮            | 页面不显示捏合轴事件                | 否    | Pass |




