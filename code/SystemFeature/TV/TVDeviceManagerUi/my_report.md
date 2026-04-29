# 工程检测报告

## 概览

- 生成时间: 2026-04-29 16:38:06
- 工程目录: C:\Users\xiaor\Desktop\TVDeviceManagerUi
- 报告路径: C:\Users\xiaor\Desktop\TVDeviceManagerUi\my_report.md
- 应用名称: com.ohos.devicemanagerui
- 版本号: 1.0.0
- 编译 SDK 版本: 18
- 兼容 SDK 版本: 18
- 文件总数: 205
- 本工程总代码行数: 73946
- ohosTest 代码行数: 17885
- 本工程总代码减去 ohosTest 代码行数: 56061
- ohosTest 文件数: 64
- 头尾空行超标文件数量: 0
- 连续空行超过2行的文件数量: 0
- 空 ets/ts/js/cpp 文件数量: 2


| 扩展名 | 数量 |
| --- | --- |
| .ets | 73 |
| .ts | 28 |
| .protoBin | 24 |
| .json | 23 |
| 无扩展名 | 10 |
| .json5 | 8 |
| .msgpack | 8 |
| .txt | 7 |
| .tsbuildinfo | 4 |
| .jpeg | 3 |
| .png | 3 |
| .md | 2 |
| .cache | 2 |
| .index | 1 |
| .map | 1 |
| .bat | 1 |
| .exe | 1 |
| .abc | 1 |
| .gn | 1 |
| .xml | 1 |
| .gitignore | 1 |
| .h | 1 |
| .linter | 1 |

### 最大文件

- Shell/hdc_std.exe 字节数=3469824
- OAT.xml 字节数=493455
- entry/.preview/cache/.default/.default/compiler.cache.msgpack 字节数=379577
- entry/.preview/cache/.default/entry/src/main/ets/pages/InputPinDialog.protoBin 字节数=206040
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/InputPinDialog.protoBin 字节数=171732
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/test.protoBin 字节数=156029
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.protoBin 字节数=142786
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/.tsbuildinfo 字节数=134986
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/.tsbuildinfo.linter 字节数=125655
- entry/.preview/cache/.default/entry/src/main/ets/pages/PinDialog.protoBin 字节数=119673
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/ConfirmDialog.protoBin 字节数=108591
- entry/.preview/default/intermediates/assets/default/ets/modules.abc 字节数=107708
- figures/figure3.jpeg 字节数=104540
- figures/figure1.jpeg 字节数=99008
- figures/figure2.jpeg 字节数=97398
- entry/.preview/cache/inversedArkTsLinter.tsbuildinfo 字节数=94209
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/PinDialog.protoBin 字节数=93853
- entry/.preview/cache/.tsbuildinfo 字节数=92875
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.protoBin 字节数=75605
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.protoBin 字节数=70501
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/watchCompiler.tsbuildinfo 字节数=70420
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.protoBin 字节数=70019
- entry/.preview/cache/.default/sourceMaps.json 字节数=50289
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/compiler.cache/modules/E%%applications_devicemanager5.0%entry%src%main%ets%pages%test.ets.msgpack 字节数=49885
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/sourceMaps.json 字节数=45399
- entry/.preview/default/intermediates/assets/default/ets/sourceMaps.map 字节数=45399
- entry/src/ohosTest/ets/test/DataPersistence.test.ets 字节数=39142
- entry/src/ohosTest/ets/test/InputDialogMerged.test.ets 字节数=33870
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/compiler.cache/plugins/plugins.msgpack 字节数=33732
- entry/src/ohosTest/ets/test/ExceptionHandling.test.ets 字节数=31517

## 初步检视结果

> **🔴 高风险 需要集中整改**
>
> 当前识别出 4 个高风险模块、2 个待改进模块，建议先聚焦高风险项整改并重新复检。

| 模块 | 状态 | 结论 | 关键指标 | 建议动作 |
| --- | --- | --- | --- | --- |
| Kit 迁移 | 🔴 高风险 | 仍存在遗留 @ohos.* 或 Ability 导入。 | 遗留@ohos=3，Ability=1，@kit=36 | 将遗留命名空间迁移到 @kit，并替换 @ohos.application.Ability。 |
| OAT 门禁 | 🔴 高风险 | OAT.xml 版权门禁存在差异：缺失主体=25，不匹配主体=75。 | 白名单主体=3，已匹配=0，不匹配=100 | 按 OAT.xml 白名单修正文件头版权主体，并重新检查过滤后的版权与许可证规则。 |
| ohosTest 质量 | 🔴 高风险 | ohosTest 重复率偏高且大文件较多，建议优先合并变体测试。 | 重复率=1.14%，大文件=21，家族问题=1 | 优先合并 Detailed / Extensive / Extended 变体测试，减少重复测试模板。 |
| 代码风格 | 🔴 高风险 | 代码风格问题仍需集中清理。 | 缺分号=43，双引号=737，var=2 | 补齐缺失分号，统一优先使用单引号，并将 var 替换为 let/const。 |
| README 文档 | 🟡 待改进 | README 仍缺少必要文件或预览图片引用。 | 问题数=2 | 补齐 README_zh.md、README.en.md、预览截图及相关说明。 |
| 规范一致性 | 🟡 待改进 | 文件头、命名或迁移规范问题仍然存在。 | 年份=4，license=22，命名=1，ets目录ts=25 | 修复 license 头部，将年份更新为 2026，保持 ets/ts/js 文件名为 PascalCase、.h 文件名为全小写、.cpp 文件名为全小写，并完成 ts 到 ets 的迁移。 |
| 签名风险 | 🟢 优秀 | 未发现签名文件或非源码提交流程风险。 | 签名文件=0，build-profile签名=0 | 移除签名数据和非必要提交物，并在 README 中说明例外情况。 |

### 优先处理项

- Kit 迁移: 将遗留命名空间迁移到 @kit，并替换 @ohos.application.Ability。 (遗留@ohos=3，Ability=1，@kit=36)
- OAT 门禁: 按 OAT.xml 白名单修正文件头版权主体，并重新检查过滤后的版权与许可证规则。 (白名单主体=3，已匹配=0，不匹配=100)
- ohosTest 质量: 优先合并 Detailed / Extensive / Extended 变体测试，减少重复测试模板。 (重复率=1.14%，大文件=21，家族问题=1)
- 代码风格: 补齐缺失分号，统一优先使用单引号，并将 var 替换为 let/const。 (缺分号=43，双引号=737，var=2)
- README 文档: 补齐 README_zh.md、README.en.md、预览截图及相关说明。 (问题数=2)
- 规范一致性: 修复 license 头部，将年份更新为 2026，保持 ets/ts/js 文件名为 PascalCase、.h 文件名为全小写、.cpp 文件名为全小写，并完成 ts 到 ets 的迁移。 (年份=4，license=22，命名=1，ets目录ts=25)

### AI 整改提示词

<pre id="ai-rectification-prompt">
你是资深 OpenHarmony / ArkTS 整改助手，请直接在当前工程中落地修复。
工程根目录：C:\Users\xiaor\Desktop\TVDeviceManagerUi
当前整体评估：🔴 高风险；高风险模块=4，告警模块=2，稳定模块=1
检视结论：当前识别出 4 个高风险模块、2 个待改进模块，建议先聚焦高风险项整改并重新复检。
整改目标：严格按当前检视规则逐项整改，只输出当前命中的规则，完成后重新复检。
当前命中规则数：9

必须遵守的整改规则：
按 OAT.xml 白名单修正版权主体并复检过滤规则。当前 allowed-owner=3，matched=0，mismatch=100，示例=@ohos.distributedHardware.deviceManager.d.ts:1 | Header owner 'Huawei Device Co., Ltd' is not listed in OAT.xml.
优先完成 Kit 迁移，清理遗留 @ohos.* 导入并避免继续使用 Ability。当前 遗留@ohos=3，Ability=1，@kit=36，示例=entry/src/ohosTest/ets/test/UiHarnessLocatorStrategy.test.ets:17 | import { DisplayRotation, Driver } from '@ohos.UiTest';
优先收敛 ohosTest 重复模板，压缩大文件并补齐断言。当前 重复率=1.14% ，家族问题=1，大文件=21，无断言=44，todo=0，完全重复文件组=0，示例=BusinessScenarioCatalog | 文件数=2，估算重复行=203
统一代码风格，先补齐分号，再将双引号改为单引号，并移除 var。当前 缺分号=43，双引号=737，var=2，示例=hvigorfile.ts:17 | module.exports = require('@ohos/hvigor-ohos-plugin').appTasks
为 ets / js / cpp 文件补齐 Apache License 2.0 头。当前 missing-license=22，示例=entry/.preview/cache/.default/preview.ets:1 | 前20行缺少 Apache 2.0 许可头
统一将 Copyright (c) 年份更新为 2026。当前 year=4，示例=entry/.preview/cache/.default/entry/src/main/ets/common/constants/StyleConstants.ts:1 | Copyright 年份为 2021
保持 ets / ts / js 文件名为 PascalCase，.h 优先使用全小写，.cpp 文件名为全小写。当前 naming=1，示例=@ohos.distributedHardware.deviceManager.d.ts | 文件名不是大驼峰命名
将已进入 ets 目录的 .ts 迁移为 .ets，并同步修正导入与构建引用。当前 ets-dir-ts=25，build-ts-ref=1，示例=entry/.preview/cache/.default/entry/src/main/ets/Application/MyAbilityStage.ts | ets 目录下仍存在 ts 文件
补齐 README_zh.md、README.en.md、预览截图和必要说明。当前 readme-issues=2，示例=README_zh.md | 缺少中文 README 文件

建议整改顺序：
Kit 迁移：将遗留命名空间迁移到 @kit，并替换 @ohos.application.Ability。；指标：遗留@ohos=3，Ability=1，@kit=36
OAT 门禁：按 OAT.xml 白名单修正文件头版权主体，并重新检查过滤后的版权与许可证规则。；指标：白名单主体=3，已匹配=0，不匹配=100
ohosTest 质量：优先合并 Detailed / Extensive / Extended 变体测试，减少重复测试模板。；指标：重复率=1.14%，大文件=21，家族问题=1
代码风格：补齐缺失分号，统一优先使用单引号，并将 var 替换为 let/const。；指标：缺分号=43，双引号=737，var=2
README 文档：补齐 README_zh.md、README.en.md、预览截图及相关说明。；指标：问题数=2
规范一致性：修复 license 头部，将年份更新为 2026，保持 ets/ts/js 文件名为 PascalCase、.h 文件名为全小写、.cpp 文件名为全小写，并完成 ts 到 ets 的迁移。；指标：年份=4，license=22，命名=1，ets目录ts=25

执行要求：
- 直接修改代码、配置和文档，不要停留在分析层面。
- 保持业务行为不变，不要新增签名文件、密钥、证书或无关资源。
- 每完成一类整改，如有需要同步更新 README 或项目说明。
- 整改完成后重新执行 generate-project-check-report.ps1，并确认高风险项下降。
- 输出结果按“已完成项 / 未完成项 / 剩余风险 / 仍需人工确认项”汇总。
</pre>

## 详细反馈

## Git 信息
- Git是否可用: False
- 是否为Git仓库: False

## README / 预览
- README检查项: README_zh.md, README.en.md, preview image references

| 路径 | 是否存在 | 图片引用数 | 预览关键词数 |
| --- | --- | --- | --- |
| README_zh.md | False | 0 | 0 |
| README.en.md | False | 0 | 0 |

### README问题

- README_zh.md 缺少中文 README 文件
- README.en.md 缺少英文 README 文件

## 依赖引入 / Kit
- @ohos.* 引用数量: 3
- @kit.* 引用数量: 36
- @ohos.application.Ability 引用数量: 1
- 迁移建议: 建议优先使用@kit.*引入，@ohos.*依赖需逐项评估后再迁移。
- Rule: @ohos.application.Ability should migrate to @kit.AbilityKit.
- AI prompt: rewrite import Ability from '@ohos.application.Ability' to use '@kit.AbilityKit', keep the original type semantics, and update related type references.

### @ohos待评审引用

- entry/src/ohosTest/ets/test/UiHarnessLocatorStrategy.test.ets:17 import { DisplayRotation, Driver } from '@ohos.UiTest';
- entry/src/ohosTest/ets/test/base/UiTestHarness.ets:16 import { Component, DisplayRotation, Driver, ON } from '@ohos.UiTest';
- entry/src/ohosTest/ets/TestAbility/TestAbility.ets:17 import Ability from '@ohos.application.Ability';

### @kit已使用引用

- entry/src/main/ets/Application/MyAbilityStage.ets:16 import { AbilityStage } from '@kit.AbilityKit';
- entry/src/main/ets/common/ExtensionWindowTypes.ets:16 import { UIExtensionContentSession, common } from '@kit.AbilityKit';
- entry/src/main/ets/common/Logger.ets:16 import { hilog } from '@kit.PerformanceAnalysisKit';
- entry/src/main/ets/MainAbility/MainAbility.ets:16 import { UIAbility, Want, AbilityConstant } from '@kit.AbilityKit';
- entry/src/main/ets/MainAbility/MainAbility.ets:17 import { window } from '@kit.ArkUI';
- entry/src/main/ets/MainAbility/MainAbility.ets:18 import { BusinessError } from '@kit.BasicServicesKit';
- entry/src/main/ets/pages/ConfirmDialog.ets:15 import { distributedDeviceManager } from '@kit.DistributedServiceKit';
- entry/src/main/ets/pages/ConfirmDialog.ets:18 import { window } from '@kit.ArkUI';
- entry/src/main/ets/pages/ConfirmDialog.ets:20 import { FaultLogger } from '@kit.PerformanceAnalysisKit';
- entry/src/main/ets/pages/InputPinDialog.ets:15 import { distributedDeviceManager } from '@kit.DistributedServiceKit';
- entry/src/main/ets/pages/InputPinDialog.ets:18 import { KeyCode as InputKeyCode } from '@kit.InputKit';
- entry/src/main/ets/pages/InputPinDialog.ets:19 import { window, ColorMetrics } from '@kit.ArkUI';
- entry/src/main/ets/pages/InputPinDialog.ets:20 import { BusinessError } from '@kit.BasicServicesKit';
- entry/src/main/ets/pages/InputPinDialog.ets:21 import { inputEventClient } from '@kit.InputKit';
- entry/src/main/ets/pages/PinDialog.ets:15 import { distributedDeviceManager } from '@kit.DistributedServiceKit';
- entry/src/main/ets/pages/PinDialog.ets:18 import { window } from '@kit.ArkUI';
- entry/src/main/ets/pages/PinDialog.ets:19 import { BusinessError } from '@kit.BasicServicesKit';
- entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ets:16 import { UIExtensionAbility, Want, UIExtensionContentSession } from '@kit.AbilityKit';
- entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ets:17 import { window, display } from '@kit.ArkUI';
- entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ets:18 import { BusinessError } from '@kit.BasicServicesKit';
- entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ets:16 import { UIExtensionAbility, Want, UIExtensionContentSession } from '@kit.AbilityKit';
- entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ets:17 import { window, display } from '@kit.ArkUI';
- entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ets:18 import { deviceInfo, BusinessError } from '@kit.BasicServicesKit';
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:16 import { UIExtensionAbility, Want, UIExtensionContentSession } from '@kit.AbilityKit';
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:17 import { window, display } from '@kit.ArkUI';
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:18 import { deviceInfo, BusinessError } from '@kit.BasicServicesKit';
- entry/src/ohosTest/ets/Application/TestAbilityStage.ts:16 import { hilog } from '@kit.PerformanceAnalysisKit';
- entry/src/ohosTest/ets/Application/TestAbilityStage.ts:17 import { AbilityStage } from '@kit.AbilityKit';
- entry/src/ohosTest/ets/test/base/UiTestHarness.ets:17 import { hilog } from '@kit.PerformanceAnalysisKit';
- entry/src/ohosTest/ets/TestAbility/TestAbility.ets:16 import { hilog } from '@kit.PerformanceAnalysisKit';

### @ohos.application.Ability引用

- entry/src/ohosTest/ets/TestAbility/TestAbility.ets:17 import Ability from '@ohos.application.Ability';

## 代码风格
- 疑似缺少分号数量: 43
- 双引号字符串数量: 737
- var使用数量: 2

### 疑似缺少分号示例

- hvigorfile.ts:17 module.exports = require('@ohos/hvigor-ohos-plugin').appTasks
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/test.ts:81 jsDialog.setController(this.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/test.ts:92 jsDialog.setController(this.
- entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ets:66 this.lineNums = 8
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:26 private lineNums = 0
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:27 private screenScale = 1
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:28 private dialogWidth = StyleConstants.DEFAULT_DIALOG_WIDTH
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:29 private dialogHeight = StyleConstants.DEFAULT_DIALOG_HEIGHT
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:32 globalThis.extensionContext = this.context
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:33 globalThis.windowNum = 0
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:39 globalThis.abilityWant = want
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:40 globalThis.session = session
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:41 const dis = display.getDefaultDisplaySync()
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:58 session.loadContent('pages/Transparent', storage)
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:60 globalThis.session = session
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:67 this.lineNums = 8
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:68 globalThis.style['shareWidth'] = 520
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:69 globalThis.style['shareHeight'] = 365
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:70 globalThis.style['shareCardWidth'] = 336
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:71 globalThis.style['shareCardHeight'] = 97
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:72 globalThis.style['shareCardRadius'] = 16
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:79 globalThis.style['shareCardTextLeft'] = 12
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:80 globalThis.style['shareCardTextTop'] = 6
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:81 globalThis.style['shareBackTop'] = 0
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:82 globalThis.style['shareCardTextWidth'] = 236
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:83 globalThis.style['shareCardSubTop'] = 3
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:84 globalThis.style['shareCardBtnLeft'] = 238
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:85 globalThis.style['swiperHeight'] = 200
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:88 this.lineNums = 6
- entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets:89 globalThis.style['shareWidth'] = 519

### 双引号字符串示例

- entry/.preview/cache/.default/entry/src/main/ets/Application/MyAbilityStage.ts:1 import AbilityStage from "@ohos:app.ability.AbilityStage";
- entry/.preview/cache/.default/entry/src/main/ets/Application/MyAbilityStage.ts:4 console.log("[Demo] MyAbilityStage onCreate");
- entry/.preview/cache/.default/entry/src/main/ets/common/constants/StyleConstants.ts:18 static readonly DEFAULT_INPUT_COLOR = "#2D3945";
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:15 import Ability from "@ohos:app.ability.UIAbility";
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:16 var TAG = "DeviceManagerUI_MainAbility:";
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:19 console.log(TAG + "MainAbility onCreate, ability name is " + want.abilityName + ".");
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:27 console.log(TAG + "MainAbility onWindowStageCreate.");
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:28 windowStage.setUIContent(this.context, "pages/ConfirmDialog", null);
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:32 console.log(TAG + "MainAbility onForeground.");
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:36 console.log(TAG + "MainAbility onBackground.");
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:40 console.log(TAG + "MainAbility onDestroy.");
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:44 console.log(TAG + "MainAbility onWindowStageDestroy.");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:14 return "ConfirmDialog_" + ++__generate__Id;
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:16 import deviceManager from "@ohos:distributedDeviceManager";
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:17 import { StyleConstants } from "@bundle:com.ohos.devicemanagerui/entry/ets/common/constants/StyleConstants";
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:18 import { KeyCode } from "@bundle:com.ohos.devicemanagerui/entry/ets/common/constants/KeyCode";
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:19 import type window from "@ohos:window";
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:21 let TAG = "[DeviceManagerUI:ConfirmDialog]==>";
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:26 this.__message = new ObservedPropertySimple('是否允许对端连接本机', this, "message");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:27 this.__allow = new ObservedPropertySimple('允许', this, "allow");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:28 this.__seconds = new ObservedPropertySimple(60, this, "seconds");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:29 this.__cancel = new ObservedPropertySimple('取消({{seconds}}秒)', this, "cancel");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:30 this.__times = new ObservedPropertySimple(0, this, "times");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:31 this.__ACTION_ALLOW_AUTH = new ObservedPropertySimple(0, this, "ACTION_ALLOW_AUTH");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:32 this.__ACTION_CANCEL_AUTH = new ObservedPropertySimple(1, this, "ACTION_CANCEL_AUTH");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:33 this.__ACTION_AUTH_CONFIRM_TIMEOUT = new ObservedPropertySimple(2, this, "ACTION_AUTH_CONFIRM_TIMEOUT");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:34 this.__focusIndex = new ObservedPropertySimple(-1, this, "focusIndex");
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:142 console.log('initStatue' + "windowNum:" + globalThis.windowNum);
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:157 console.log("onAllow execute" + JSON.stringify(globalThis.abilityWant.parameters));
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:158 console.log("allow" + this.ACTION_ALLOW_AUTH);

### var使用示例

- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:16 var TAG = "DeviceManagerUI_MainAbility:";
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/MainAbility/MainAbility.ts:2 var TAG = "DeviceManagerUI_MainAbility:";

## 签名与提交
- 常规要求：签名文件、signature 文件夹和证书不应提交；如确需提交需在 README 中说明。

| 字段 | 是否存在 |
| --- | --- |
| signingConfigs | False |
| storeFile | False |
| storePassword | False |
| keyAlias | False |
| keyPassword | False |
| profile | False |
| certpath | False |
- build-profile.json5 含签名配置数量: 0
- README 签名说明数量: 1

| 路径 | signingConfigs | 敏感字段数量 |
| --- | --- | --- |
| build-profile.json5 | False | 0 |
| entry/build-profile.json5 | False | 0 |

### build-profile.json5 签名风险

- 无

### README 签名说明

- README.md contains signing note

### README 签名说明缺失

- 无

### 签名相关文件

- 无

## OAT 门禁对照
- OAT gate summary: OAT.xml copyright gate mismatch: missing owner=25, unmatched owner=75.
- OAT.xml allowlist owner count: 3
- Source files checked by OAT gate: 100
- Files matching allowlist owner: 0
- Files missing copyright owner: 25
- Files with unmatched owner: 75

### OAT.xml allowlist owners

- Hunan OpenValley Digital Industry Development Co., Ltd. 
- Fujian Newland Auto-ID Tech.Co.,Ltd. 
- Shenzhen Kaihong Digital Industry Development Co., Ltd. 

| Owner | Count | InOat |
| --- | --- | --- |
| Huawei Device Co., Ltd | 75 | No |

### OAT gate mismatch samples

- @ohos.distributedHardware.deviceManager.d.ts:1 Header owner 'Huawei Device Co., Ltd' is not listed in OAT.xml.
- entry/.preview/cache/.default/preview.ets:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/Application/MyAbilityStage.ts:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/common/constants/KeyCode.ts:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/common/constants/StyleConstants.ts:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/pages/InputPinDialog.ts:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/pages/PinDialog.ts:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ts:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ts:1 Copyright owner is missing from the header.
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/preview.ets:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/Application/MyAbilityStage.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/common/Logger.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/common/constants/KeyCode.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/common/constants/StyleConstants.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/MainAbility/MainAbility.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/ConfirmDialog.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/InputPinDialog.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/PinDialog.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/test.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ts:1 Copyright owner is missing from the header.
- entry/.preview/default/generated/profile/default/BuildProfile.ets:1 Copyright owner is missing from the header.
- entry/.preview/default/generated/r/default/ResourceTable.h:1 Header owner 'Huawei Device Co., Ltd' is not listed in OAT.xml.
- entry/src/main/ets/Application/MyAbilityStage.ets:1 Header owner 'Huawei Device Co., Ltd' is not listed in OAT.xml.
- entry/src/main/ets/common/ExtensionWindowTypes.ets:1 Header owner 'Huawei Device Co., Ltd' is not listed in OAT.xml.
- entry/src/main/ets/common/Logger.ets:1 Header owner 'Huawei Device Co., Ltd' is not listed in OAT.xml.

## 代码检视
- Copyright年份非2026数量: 4
- 缺少 license 头数量: 22
- 命名不符合规范文件数量: 1
- ets目录下ts文件数量: 25
- 构建脚本中 .ts 引用数量: 1
- hvigorfile.js 数量: 0
- hvigorfile.ts 数量: 2
- 迁移建议: If a directory contains ets, rename in-scope .ts files to .ets and review import/module.json5/build-profile.json5/hvigor references.
- hvigor: If hvigorfile.js still exists, migrate it to hvigorfile.ts and keep script references consistent.

### 年份问题示例

- entry/.preview/cache/.default/entry/src/main/ets/common/constants/StyleConstants.ts:1 Copyright 年份为 2021
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts:1 Copyright 年份为 2021
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/common/constants/StyleConstants.ts:1 Copyright 年份为 2021
- entry/.preview/default/generated/r/default/ResourceTable.h:1 Copyright 年份为 2023

### 缺少license头示例

- entry/.preview/cache/.default/preview.ets:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/cache/.default/entry/src/main/ets/Application/MyAbilityStage.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/cache/.default/entry/src/main/ets/common/constants/KeyCode.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/cache/.default/entry/src/main/ets/pages/InputPinDialog.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/cache/.default/entry/src/main/ets/pages/PinDialog.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/preview.ets:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/Application/MyAbilityStage.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/common/Logger.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/common/constants/KeyCode.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/MainAbility/MainAbility.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/ConfirmDialog.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/InputPinDialog.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/PinDialog.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/test.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ts:1 前20行缺少 Apache 2.0 许可头
- entry/.preview/default/generated/profile/default/BuildProfile.ets:1 前20行缺少 Apache 2.0 许可头

### 命名不符合规范示例

- @ohos.distributedHardware.deviceManager.d.ts 文件名不是大驼峰命名

### ets目录下ts文件示例

- entry/.preview/cache/.default/entry/src/main/ets/Application/MyAbilityStage.ts ets 目录下仍存在 ts 文件
- entry/.preview/cache/.default/entry/src/main/ets/common/constants/KeyCode.ts ets 目录下仍存在 ts 文件
- entry/.preview/cache/.default/entry/src/main/ets/common/constants/StyleConstants.ts ets 目录下仍存在 ts 文件
- entry/.preview/cache/.default/entry/src/main/ets/MainAbility/MainAbility.ts ets 目录下仍存在 ts 文件
- entry/.preview/cache/.default/entry/src/main/ets/pages/ConfirmDialog.ts ets 目录下仍存在 ts 文件
- entry/.preview/cache/.default/entry/src/main/ets/pages/InputPinDialog.ts ets 目录下仍存在 ts 文件
- entry/.preview/cache/.default/entry/src/main/ets/pages/PinDialog.ts ets 目录下仍存在 ts 文件
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ts ets 目录下仍存在 ts 文件
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ts ets 目录下仍存在 ts 文件
- entry/.preview/cache/.default/entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/Application/MyAbilityStage.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/common/Logger.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/common/constants/KeyCode.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/common/constants/StyleConstants.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/MainAbility/MainAbility.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/ConfirmDialog.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/InputPinDialog.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/PinDialog.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/pages/test.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ts ets 目录下仍存在 ts 文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ts ets 目录下仍存在 ts 文件
- entry/src/main/ets/common/constants/StyleConstants.ts ets 目录下仍存在 ts 文件
- entry/src/ohosTest/ets/Application/TestAbilityStage.ts ets 目录下仍存在 ts 文件
- entry/src/ohosTest/ets/TestRunner/OpenHarmonyTestRunner.ts ets 目录下仍存在 ts 文件

### 构建脚本 .ts 引用示例

- entry/src/ohosTest/module.json5:20 "srcEntrance": "./ets/Application/TestAbilityStage.ts",

### hvigorfile.js

- 无

### hvigorfile.ts

- hvigorfile.ts 
- entry/hvigorfile.ts 

## 文档与测试
- 期望根目录测试说明文件: com.ohos.devicemanagerui测试说明.md
- 期望测试说明文件是否存在: False
- ohosTest.md 是否存在: False
- README.en.md 是否存在: False

### 根目录测试说明文件

- 无

## ohosTest 代码质量
- ohosTest 目录: entry/src/ohosTest
- 质量结论: ohosTest 重复率偏高且大文件较多，建议优先合并变体测试。
- ohosTest 文件数: 59
- ohosTest 代码行数: 17795
- 平均每个文件行数: 301.61
- 测试用例识别数: 586
- 断言识别数: 46
- 待处理标记数: 0
- 大文件数量: 21（阈值>300行）
- 无断言测试文件数量: 44
- 变体命名文件数量: 5
- 家族问题数量: 1
- 重复文件数量: 1
- 估算重复行数: 203
- 估算重复率: 1.14%
- 完全重复文件组数: 0

### 大文件示例

- entry/src/ohosTest/ets/test/AbilityAndStageLifecycle.test.ets 行数=583
- entry/src/ohosTest/ets/test/AccessibilityAndReadableText.test.ets 行数=373
- entry/src/ohosTest/ets/test/BoundaryConditionTesting.test.ets 行数=509
- entry/src/ohosTest/ets/test/CompatibilityExtended.test.ets 行数=425
- entry/src/ohosTest/ets/test/ComprehensiveIntegration.test.ets 行数=729
- entry/src/ohosTest/ets/test/ConcurrentWindowScenario.test.ets 行数=595
- entry/src/ohosTest/ets/test/ConfirmDialogCore.test.ets 行数=549
- entry/src/ohosTest/ets/test/DataPersistence.test.ets 行数=1252
- entry/src/ohosTest/ets/test/ExceptionBoundaryExtended.test.ets 行数=485
- entry/src/ohosTest/ets/test/ExceptionHandling.test.ets 行数=1009
- entry/src/ohosTest/ets/test/ExtensionWindowMerged.test.ets 行数=549
- entry/src/ohosTest/ets/test/FaultInjectionScenario.test.ets 行数=530
- entry/src/ohosTest/ets/test/InputDialogMerged.test.ets 行数=1062
- entry/src/ohosTest/ets/test/MultiResolutionAdaptation.test.ets 行数=604
- entry/src/ohosTest/ets/test/NetworkConnectivityExtended.test.ets 行数=491
- entry/src/ohosTest/ets/test/NetworkMerged.test.ets 行数=742
- entry/src/ohosTest/ets/test/PerformanceMerged.test.ets 行数=750
- entry/src/ohosTest/ets/test/PerformanceStabilityExtended.test.ets 行数=343
- entry/src/ohosTest/ets/test/PinDialogMerged.test.ets 行数=804
- entry/src/ohosTest/ets/test/SecurityMerged.test.ets 行数=685
- entry/src/ohosTest/ets/test/SecurityPermissionsExtended.test.ets 行数=345

### 无断言测试示例

- entry/src/ohosTest/ets/test/AbilityAndStageLifecycle.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/AccessibilityAndReadableText.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/AccessibilityFeatures.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/BoundaryConditionTesting.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/BusinessScenarioCatalog.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/CompatibilityExtended.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ComprehensiveIntegration.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ConcurrentWindowScenario.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ConfirmDialogCore.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ConstantsAndTypes.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/CoveragePlan.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/DataConsistencyAndRace.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/DataPersistence.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/DialogScalePrecision.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ExceptionBoundaryExtended.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ExceptionHandling.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ExtensionSessionStorageContract.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ExtensionWindowMerged.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ExtensionWindowScenarioExpansion.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/FaultInjectionScenario.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/Foundation.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/InputDialogMerged.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/InputShareStyle.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/InternationalizationSupport.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/LaunchAndTerminationScenario.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/MainAbilityLifecycleContract.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/ModuleContract.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/MultiResolutionAdaptation.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/NetworkConnectivityExtended.test.ets 存在测试定义但未发现断言
- entry/src/ohosTest/ets/test/NetworkMerged.test.ets 存在测试定义但未发现断言

### 待处理标记示例

- 无

### 家族问题示例

- BusinessScenarioCatalog 文件数=2，估算重复行=203

### 完全重复文件示例

- 无

### 头尾空行问题

- 无

### 连续空行问题

- 无

### 空文件

- entry/.preview/cache/.default/preview.ets 空文件
- entry/.preview/default/cache/default/default@PreviewArkTS/esmodule/debug/preview.ets 空文件
