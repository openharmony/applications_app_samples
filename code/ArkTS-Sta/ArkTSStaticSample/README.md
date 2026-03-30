# ArkTS-Static演示工程

### 介绍

本示例工程为一个OpenHarmony ArkTS演示工程。主要展示了同一业务能力在library中提供动态（`ArkTS-Dyn`）与静态（`ArkTS-Sta`）两套实现的功能。通过`dispatch`层在运行时按系统API版本自动分发具体实现。对外暴露统一接口，业务侧（entry）无需关心底层使用的是哪套实现。

工程library统一导出了`DataParser`,`DataSource`,`CardData`和`ResolverRegistry`等核心能力供上层调用。

### 效果预览

效果如下所示：

| 主页面                                                   |  
|--------------------------------------------------------|
| ![main](entry/src/main/resources/base/media/main.png) |


### 使用说明

1.  启动应用进入主页面。
2.  页面会自动调用统一接口`DataParser.parse`解析 JSON 数据，并通过`LazyForEach`渲染为应用卡片列表。
3.  若需验证不同版本的运行时分发逻辑，可在控制台日志中观察`dispatch/DataParser.js`的输出：
      - 当设备`sdkApiVersion >= 23`时，日志应显示走静态实现。
      - 当设备`sdkApiVersion < 23`时，日志应显示走动态实现。

### 工程目录

```text
entry/src/main/ets/
|---pages
|   |---Index.ets                       // 示例页面入口，注册 card resolver，调用 DataParser.parse，渲染列表
library/src/main/ets/
|---components
|   |---dispatch
|   |   |---DataParser.js               // 运行时版本分发逻辑层
|   |---dyn                             // 动态实现目录，纯 TS 侧逻辑
|   |   |---CardData.ts
|   |   |---DataParser.ts
|   |   |---DataSource.ts
|   |   |---ResolverRegistry.ts
|   |---sta                             // 静态实现目录
|   |   |---CardData.ets
|   |   |---DataParser.ets
|   |   |---DataSource.ets
|   |   |---ResolverRegistry.ets
|   |---sta_bridge                      // TS与ETS桥接层 (EtsFactory / InitStatic)，完成实例初始化
|   |---sta_dummy                       // 静态空实现目录，提供兜底保障
|   |---sta_wrapper
|   |   |---DataParserStaW.ts           // 静态适配动态的实现层，解决静态实现适配动态接口的数据格式转换问题
|   |---Index.ets                       // library 统一出口，对外导出 dyn 公共类型与接口
```

### 具体实现

本工程的核心在于“统一接口封装”与“按版本双实现分发”。

  * **动态版本分发**：业务侧统一调用`library`出口。在DataParser.js中，系统会根据 API 版本判断选择相应的实现。
      * 若 `sdkApiVersion >= 23`：选择静态实现包装器`DataParserStaW`。
      * 若 `sdkApiVersion < 23`：选择动态实现`DataParserDyn`。
  * **动态实现逻辑 (Dyn)**：采用更直接的纯TS侧逻辑进行数据处理。
  * **静态实现逻辑 (Sta)**：结合使用了`taskpool`和`jsonx.JsonElement`等静态能力，并通过`sta_bridge`桥接与`sta_wrapper`包装器来适配动态接口格式。
  * 两者底层逻辑处理完毕后，均返回统一的数据模型类型（`CardData`和`DataSource`），确保entry业务层渲染逻辑的一致性。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.  本示例仅支持在标准系统上运行。
2.  本示例推荐使用当前最新版本的API和SDK编译运行。
3.  本示例推荐使用当前最新版本的DevEco Studio。
4.  业务扩展说明：若新增业务卡片类型，需在`ResolverRegistry`注册新类型并补充相应的解析逻辑，同时务必保持ArkTS-Dyn和ArkTS-Sta两侧能力的一致性。

### 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/ArkTS-Sta/ArkTSStaticSample/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
