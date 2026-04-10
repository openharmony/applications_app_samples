# TVSettings 测试用例归档

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 拉起测试入口 | 1. 已安装主 hap 与 ohosTest hap<br/>2. TV 设备可正常启动应用 | 执行 ohosTest 套件 | 拉起 TestAbility，自动进入 Hypium 用例执行流程 | 是 | 待验证 |
| 应用框架与基础能力回归 | 1. 测试包安装完成<br/>2. Settings 主工程资源完整 | 运行 Ability.test、ApplicationFramework.test、BaseUtilsCore.test、DefaultLayoutCore.test、DataSourceAndController.test | Ability 生命周期、基础工具、默认布局、数据源与控制器能力校验通过 | 是 | 待验证 |
| 蓝牙、网络与热点业务回归 | 1. 设备蓝牙与网络能力可用<br/>2. 相关页面资源可正常加载 | 运行 BluetoothLinksSubpagesDeepBusiness.test、HotspotSystemSubpagesBusiness.test、NetworkBluetoothBusiness.test、NetworkSubpagesDeepBusiness.test | 蓝牙、网络、热点相关页面跳转、状态处理与业务逻辑校验通过 | 是 | 待验证 |
| 显示、音量与输入业务回归 | 1. 显示与输入模块可用<br/>2. 页面路由已注册 | 运行 DisplayVolumeBusiness.test、DisplayVolumeSubpagesDeepBusiness.test、InputEditorsDeepBusiness.test、LinkInputHotspotBusiness.test | 显示、音量、输入编辑及关联页面交互行为校验通过 | 是 | 待验证 |
| 路由与页面总检回归 | 1. 主应用可正常打开<br/>2. 页面清单与路由配置已同步 | 运行 RouteManifestFinalContracts.test、PageInteractionContracts.test、RemainingScatteredPagesWrapUp.test、SystemPagesFinalCoverage.test、SystemRootAndFinalSweep.test | 页面契约、路由清单、系统页覆盖与最终收口校验通过 | 是 | 待验证 |
| 合成矩阵批量回归 | 1. 主应用与测试包已安装<br/>2. 设备性能满足长时间回归执行 | 运行 MegaSyntheticRouteAtlas*、MegaSyntheticNavigationStateReplay*、MegaSyntheticInputReplay*、MegaSyntheticFocusReplay*、MegaSystemRecoveryFlowMatrix.test 等批量用例 | 大批量状态回放、路由矩阵、焦点与输入回归场景校验通过 | 是 | 待验证 |
