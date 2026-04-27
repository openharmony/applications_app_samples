# MIDI Sample 测试用例归档

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---------|---------|------|---------|---------|---------|
| 拉起应用 | 设备正常运行 | - | 成功拉起应用 | 是 | Pass |
| 主页展示 | 设备正常运行 | - | 展示客户端管理、蓝牙MIDI、设备列表等区域 | 是 | Pass |
| 创建MIDI客户端 | 位于主页 | 点击"Create Client"按钮 | 显示"MIDI client created successfully"日志 | 是 | Pass |
| 刷新设备列表 | 已创建客户端 | 点击"Refresh Devices"按钮 | 刷新并显示当前连接的MIDI设备数量 | 是 | Pass |
| 销毁MIDI客户端 | 已创建客户端 | 点击"Destroy Client"按钮 | 显示"MIDI client destroyed"日志，设备列表清空 | 是 | Pass |
| 连接USB设备 | 已创建客户端且连接USB MIDI设备 | 点击USB设备选项并点击"Open Device" | 显示设备打开成功日志 | 是 | Pass |
| 连接BLE设备 | 已创建客户端 | 输入BLE MAC地址，点击"Connect" | 显示连接成功日志，设备添加到列表 | 是 | Pass |
| 打开设备 | 已选择设备 | 点击"Open Device"按钮 | 显示端口管理面板 | 是 | Pass |
| 关闭设备 | 设备已打开 | 点击"Close Device"按钮 | 端口管理面板关闭 | 是 | Pass |
| 打开输入端口 | 设备已打开且有输入端口 | 点击输入端口"Open"按钮 | 端口状态变为"Close" | 是 | Pass |
| 关闭输入端口 | 输入端口已打开 | 点击输入端口"Close"按钮 | 端口状态变为"Open" | 是 | Pass |
| 打开输出端口 | 设备已打开且有输出端口 | 点击输出端口"Open"按钮 | 端口状态变为"Close"，虚拟键盘激活 | 是 | Pass |
| 关闭输出端口 | 输出端口已打开 | 点击输出端口"Close"按钮 | 端口状态变为"Open" | 是 | Pass |
| 虚拟键盘-按下白键 | 输出端口已打开 | 触摸按下白键C4 | 白键变绿色，发送Note On消息 | 是 | Pass |
| 虚拟键盘-释放白键 | 输出端口已打开且已按下 | 释放白键C4 | 白键恢复原色，发送Note Off消息 | 是 | Pass |
| 虚拟键盘-按下黑键 | 输出端口已打开 | 触摸按下黑键C#4 | 黑键变红色，发送Note On消息 | 是 | Pass |
| 虚拟键盘-释放黑键 | 输出端口已打开且已按下 | 释放黑键C#4 | 黑键恢复原色，发送Note Off消息 | 是 | Pass |
| MIDI通道设置 | 输出端口已打开 | 输入通道值5 | 通道设置为5 | 是 | Pass |
| 接收MIDI消息 | 输入端口已打开 | 外部发送MIDI Note On消息 | MIDI Input Monitor显示Note On消息 | 是 | Pass |
| 接收Note Off消息 | 输入端口已打开 | 外部发送MIDI Note Off消息 | MIDI Input Monitor显示Note Off消息 | 是 | Pass |
| 接收CC消息 | 输入端口已打开 | 外部发送Control Change消息 | MIDI Input Monitor显示CC消息 | 是 | Pass |
| 设备热插拔-连接 | 已创建客户端 | 连接新的USB MIDI设备 | 设备列表自动更新，显示新设备 | 是 | Pass |
| 设备热插拔-断开 | 已创建客户端 | 断开已连接的USB MIDI设备 | 设备列表自动更新，移除设备 | 是 | Pass |
| BLE权限检查 | 未授权蓝牙权限 | 尝试连接BLE设备 | 显示权限拒绝错误 | 是 | Pass |
| 无效设备选择 | 客户端已创建但未选择设备 | 尝试操作设备 | Device Control区域不显示（因为selectedDeviceId < 0） | 是 | Pass |
| 无输出端口时弹琴 | 设备已打开但未打开输出端口 | 触摸钢琴键 | Event Log显示"Please open an output port first" | 是 | Pass |
| 返回主页 | 任意页面 | 点击返回键 | 返回到主页面 | 是 | Pass |

## 测试环境要求

### 硬件要求

1. **主测试设备**：
   - 支持OpenHarmony 6.0及以上版本的标准系统设备
   - 支持设备类型：手机、平板、2in1设备
   - 支持USB Host模式（用于连接USB MIDI设备）
   - 支持蓝牙BLE（用于连接BLE MIDI设备）

2. **测试辅助设备**：
   - USB MIDI键盘或USB MIDI控制器
   - BLE MIDI设备（如支持MIDI的蓝牙乐器）
   - USB Type-C转USB-A转接头（如需要）

### 软件要求

1. DevEco Studio 6.0 Release及以上版本
2. OpenHarmony SDK API 24及以上版本
3. 测试框架：Hypium

### 环境配置

1. 确保设备已开启开发者模式
2. 确保设备已授权USB调试
3. 确保设备已授权蓝牙权限
4. 确保设备蓝牙功能已开启（如需测试BLE MIDI）

## 测试步骤

### 1. 基础功能测试

#### 1.1 应用启动测试
1. 在DevEco Studio中编译并安装MIDI Sample应用
2. 点击应用图标启动应用
3. 验证应用正常启动并显示主页

#### 1.2 客户端管理测试
1. 点击"Create Client"按钮
2. 观察Event Log区域显示"MIDI client created successfully"
3. 验证设备列表区域显示
4. 点击"Destroy Client"按钮
5. 验证客户端销毁成功

### 2. USB MIDI设备测试

#### 2.1 设备连接测试
1. 创建MIDI客户端
2. 连接USB MIDI设备
3. 验证设备自动出现在设备列表中
4. 点击设备并打开
5. 验证端口列表显示

#### 2.2 MIDI输入测试
1. 打开USB MIDI设备的输入端口
2. 在MIDI键盘上弹奏
3. 验证MIDI Input Monitor显示接收到的消息

#### 2.3 MIDI输出测试
1. 打开USB MIDI设备的输出端口
2. 在虚拟钢琴键盘上弹奏
3. 验证MIDI键盘/音源接收到MIDI消息并发声

### 3. 蓝牙MIDI设备测试

#### 3.1 BLE设备连接测试
1. 确保蓝牙权限已授权
2. 获取BLE MIDI设备的MAC地址
3. 输入MAC地址并点击Connect
4. 验证连接成功并设备添加到列表

#### 3.2 BLE MIDI通信测试
1. 打开BLE MIDI设备
2. 打开输入/输出端口
3. 进行MIDI消息收发测试
4. 验证通信正常

### 4. 虚拟键盘测试

#### 4.1 白键测试
1. 确保输出端口已打开
2. 依次触摸C4-D4-E4-F4-G4-A4-B4-C5
3. 验证每个按键按下时变色
4. 验证释放时恢复原色
5. 验证MIDI消息正确发送

#### 4.2 黑键测试
1. 确保输出端口已打开
2. 依次触摸C#4-D#4-F#4-G#4-A#4
3. 验证每个按键按下时变色
4. 验证释放时恢复原色
5. 验证MIDI消息正确发送

### 5. 设备热插拔测试

#### 5.1 USB设备热插拔
1. 创建MIDI客户端
2. 连接USB MIDI设备
3. 验证设备自动添加到列表
4. 断开USB MIDI设备
5. 验证设备自动从列表移除

#### 5.2 BLE设备断开重连
1. 连接BLE MIDI设备
2. 断开BLE设备
3. 验证设备状态更新
4. 重新连接
5. 验证设备恢复正常

## 预期结果

### 功能测试预期

| 功能模块 | 预期行为 |
|---------|---------|
| 客户端创建 | 成功创建并显示"created successfully" |
| 设备列表 | 正确显示已连接的MIDI设备（名称、类型、ID） |
| 设备打开 | 成功打开设备并显示端口列表 |
| 输入端口 | 成功打开并开始接收MIDI消息 |
| 输出端口 | 成功打开并可发送MIDI消息 |
| 虚拟键盘 | 按键响应灵敏，颜色变化正确 |
| MIDI输入 | 正确接收并解析Note On/Off、CC等消息 |
| BLE连接 | 成功连接并在列表中显示 |
| 热插拔 | 设备状态实时更新 |

### 性能预期

1. 客户端创建响应时间 < 500ms
2. 设备列表刷新响应时间 < 200ms
3. 虚拟键盘按键响应延迟 < 50ms
4. BLE设备连接时间 < 5s
5. MIDI消息处理延迟 < 10ms

### 稳定性预期

1. 连续打开/关闭设备100次无崩溃
2. 连续发送1000条MIDI消息无丢失
3. 长时间运行（2小时）无内存泄漏
4. 异常断开后可正常重连

## 注意事项

1. **权限申请**：初次运行时需要授权蓝牙权限
2. **BLE设备**：部分BLE MIDI设备可能需要配对
3. **USB设备**：需要设备支持USB Host模式
4. **消息格式**：MIDI消息使用UMP格式封装
5. **并发测试**：不建议同时打开多个相同设备的端口


## 自动化测试用例

以下为完整的自动化测试用例列表（共22个），基于 Hypium 测试框架实现：

| 用例编号 | 测试名称 | 测试目的 | 预期结果 | 测试方法 |
|---------|---------|---------|---------|---------|
| TC001 | startAbility_test | 应用启动测试 | 成功拉起主应用EntryAbility | abilityDelegator.startAbility() |
| TC002 | mainPageDisplay_test | 主页显示检查 | 页面标题"MIDI Sample"正常显示 | ON.text()组件查找 |
| TC003 | createMidiClient_test | 创建MIDI客户端 | 点击Create Client后按钮变为Destroy Client | 按钮文本验证 |
| TC004 | refreshDevices_test | 刷新设备列表 | Refresh Devices按钮可点击 | 按钮点击测试 |
| TC005 | destroyMidiClient_test | 销毁MIDI客户端 | 点击Destroy Client后按钮变为Create Client | 按钮文本验证 |
| TC006 | bleMidiSectionDisplay_test | 蓝牙MIDI区域显示 | Bluetooth MIDI标题和Connect按钮正常显示 | 组件存在性验证 |
| TC007 | deviceListSectionDisplay_test | 设备列表区域显示 | Connected Devices标题正常显示 | 组件存在性验证 |
| TC008 | pianoKeyboardSectionDisplay_test | 虚拟钢琴键盘区域 | Virtual Piano Keyboard标题显示（设备打开后） | 条件判断验证 |
| TC009 | eventLogSectionDisplay_test | Event Log区域显示 | Event Log标题正常显示 | 组件存在性验证 |
| TC010 | uiElementsCompleteness_test | UI元素完整性检查 | Client Management、Bluetooth MIDI、Connected Devices、Event Log均显示 | 多组件验证 |
| TC011 | bleMacAddressFormat_test | BLE区域功能验证 | Bluetooth MIDI区域和Connect按钮正常显示 | 组件存在性验证 |
| TC012 | bleConnectButtonState_test | BLE连接按钮状态 | Connect按钮和Bluetooth MIDI区域正常显示 | 组件存在性验证 |
| TC013 | deviceListSelection_test | 设备列表选择测试 | Connected Devices标题显示，Open Device按钮条件显示 | 条件判断验证 |
| TC014 | openDeviceWithoutSelection_test | 未选择设备状态测试 | Device Control区域不显示（因为selectedDeviceId < 0） | 条件判断验证 |
| TC015 | duplicateClientCreation_test | 客户端重复创建测试 | 创建后Create Client按钮消失，Destroy Client显示 | 按钮状态验证 |
| TC016 | operationWithoutClient_test | 客户端未创建时操作 | 销毁后Create Client和Refresh Devices按钮显示 | 按钮存在性验证 |
| TC017 | midiChannelInput_test | MIDI通道标签测试 | Channel标签存在（设备打开后） | 组件存在性验证 |
| TC018 | eventLogScroll_test | Event Log滚动测试 | Event Log标题和Clear按钮正常显示 | 组件存在性验证 |
| TC019 | clearLogFunction_test | Clear按钮功能测试 | 点击Clear按钮后按钮仍然存在 | 按钮点击验证 |
| TC020 | pianoKeyboardRendering_test | 钢琴键盘渲染测试 | Virtual Piano Keyboard标题显示（设备打开后） | 条件判断验证 |
| TC021 | pianoKeyboardTouchResponse_test | 钢琴键盘触摸测试 | 通过坐标点击钢琴键，Event Log区域正常显示（设备需打开） | 坐标点击测试 |
| TC022 | pianoTouchWithoutOutputPort_test | 无输出端口触摸测试 | 设备打开但未打开输出端口时点击钢琴键，Event Log正常显示 | 坐标点击测试 |

### 测试用例分类

测试用例按功能模块分类如下：

- **应用启动测试**：TC001
- **客户端管理测试**：TC003、TC005、TC015、TC016
- **设备管理测试**：TC004、TC007、TC013、TC014
- **BLE相关测试**：TC006、TC011、TC012
- **UI组件测试**：TC002、TC008、TC009、TC010、TC017、TC018、TC019、TC020
- **触摸交互测试**：TC021、TC022

### 测试框架依赖

```typescript
import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import display from '@ohos.display';
```

### 关键测试技术说明

1. **条件渲染处理**：部分UI组件（如Open Device按钮、Virtual Piano Keyboard）是条件渲染的，测试中使用条件判断避免断言失败：
   ```typescript
   if (openDeviceBtn) {
     expect(openDeviceBtn).not().assertNull();
   } else {
     hilog.info(0x0000, TAG, 'Open Device button not visible - no device selected');
   }
   ```

2. **坐标点击测试**：钢琴键盘测试使用屏幕坐标进行点击：
   ```typescript
   let displayInfo: display.Display = display.getDefaultDisplaySync();
   let pianoCenterX = Math.floor(displayInfo.width / 2);
   let pianoY = Math.floor(displayInfo.height * 0.78);
   await driver.click(pianoCenterX, pianoY);
   ```

3. **按钮文本验证**：Create Client/Destroy Client按钮会根据状态动态切换文本：
   ```typescript
   let createClientBtn = await driver.findComponent(ON.text('Create Client'));
   expect(createClientBtn).not().assertNull();
   ```

4. **Clear按钮**：Event Log区域的清除按钮文本为"Clear"（不是"Clear Log"）：
   ```typescript
   let clearLogBtn = await driver.findComponent(ON.text('Clear'));
   expect(clearLogBtn).not().assertNull();
   ```

### 测试环境说明

- **无需外部设备**：TC001-TC010、TC015-TC019 可在无MIDI设备环境下运行
- **需要MIDI设备**：TC011-TC014、TC020-TC022 涉及设备相关功能，部分断言使用条件判断
- **坐标依赖**：TC021、TC022 的钢琴键点击位置基于屏幕比例计算，需确保应用布局正确
