# TVSystemUi 测试报告

## 设备

| 设备 | 识别名称 |
|---|---|
| rk3568 | `rk3568` |
| 大屏 | `TV` |

## 系统UI组件清单

| 组件名称 | 功能描述 | 设备支持 |
|---|---|---|
| 导航栏 (NavigationBar) | 系统导航功能，包含返回、主页、最近任务等按钮 | rk3568、大屏 |
| 控制面板 (ControlPanel) | 系统设置快捷面板，包含亮度调节、WiFi开关、投屏等功能 | rk3568、大屏 |
| 音量面板 (VolumePanel) | 系统音量调节界面 | rk3568、大屏 |
| 对话框组件 (Dialog) | 系统对话框和提示框组件 | rk3568、大屏 |
| 通知管理 (NotificationManagement) | 系统通知管理和设置界面 | rk3568、大屏 |

## 核心功能模块

| 模块名称 | 包名 | 功能描述 |
|---|---|---|
| 系统UI主模块 | com.ohos.systemui | 系统UI核心功能 |
| 导航服务 | com.ohos.navigationservice | 导航栏功能服务 |
| 控制面板服务 | com.ohos.systemui.controlpanel | 控制面板功能服务 |
| 音量面板服务 | com.ohos.systemui.volumepanel | 音量调节功能服务 |
| 对话框服务 | com.ohos.systemui.dialog | 系统对话框服务 |
| 通知管理服务 | com.ohos.systemui.notificationmanagement | 通知管理功能服务 |

## 验证点

| 项目 | rk3568  | 大屏 |
|---|---|---|
| 导航栏显示 | 正常显示  | 正常显示 |
| 控制面板功能 | 功能正常  | 功能正常 |
| 音量调节界面 | 正常显示  | 正常显示 |
| 系统对话框 | 正常显示  | 正常显示 |
| 通知管理 | 功能正常  | 功能正常 |
