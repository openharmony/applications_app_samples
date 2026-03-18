# ArkUI自定义组件支持跨Ability迁移指南文档示例

### 介绍

本示例展示了自定义组件支持跨Ability迁移的能力。从API version 24开始，通过在module.json5配置文件中配置metadata，可以使能自定义组件支持跨Ability迁移，使得自定义组件实例在跨Ability后，状态变量的改变仍能触发UI组件刷新。该工程中展示的代码详细描述可查如下链接：

### 示例文档

1. [创建自定义组件](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-create-custom-components.md)

### 效果预览

| 首页                              | 跨Ability迁移后                    |
|---------------------------------|--------------------------------|
| ![](screenshots/img1.png) | ![](screenshots/img2.png) |

### 使用说明

1. **配置使能跨Ability迁移**：在应用工程的module.json5配置文件的metadata标签中，配置name为enableCustomComponentCrossAbility，value为true，来使能自定义组件支持跨Ability迁移。

2. **创建BuilderNode节点**：在Index页面点击"add node to tree"按钮，创建BuilderNode节点并挂载到NodeContainer下，展示自定义组件。

3. **移除BuilderNode节点**：点击"remove node from tree"按钮，将BuilderNode节点从NodeContainer上移除，但不销毁节点。

4. **拉起新Ability**：点击"start new ability"按钮，拉起ExtraAbility，跳转到ExtraIndex页面。

5. **跨Ability迁移验证**：在ExtraIndex页面中，点击"add node to tree"按钮，将之前创建的BuilderNode节点重新挂载到新的NodeContainer下。此时点击"change message"按钮，可以验证状态变量的改变仍能触发UI刷新，证明自定义组件已成功跨Ability迁移。

6. **销毁BuilderNode节点**：在ExtraIndex页面点击"dispose node"按钮，销毁BuilderNode节点，释放资源。

### 工程目录
```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets              // 主Ability入口
|---entrybackupability
|   |---EntryBackupAbility.ets        // 备份Ability
|---extraability
|   |---ExtraAbility.ets              // 额外的Ability，用于接收迁移的组件
|---pages
|   |---Index.ets                     // 应用主页面
|   |---ExtraIndex.ets                // ExtraAbility页面
|   |---MyNodeController.ets          // NodeController实现，管理BuilderNode
```

### 具体实现

1. **使能配置实现**：在module.json5的module标签下添加metadata配置，设置name为enableCustomComponentCrossAbility，value为true，启用自定义组件跨Ability迁移能力。

2. **BuilderNode管理实现**：通过自定义的MyNodeController继承NodeController，管理全局BuilderNode的创建、挂载、移除和销毁。使用全局变量globalBuilderNode保存BuilderNode实例，使其可以在不同Ability间共享。

3. **跨Ability迁移流程实现**：
   - 在Index页面创建BuilderNode并挂载到NodeContainer
   - 从NodeContainer移除BuilderNode（不销毁）
   - 通过startAbility拉起ExtraAbility
   - 在ExtraIndex页面重新将BuilderNode挂载到新的NodeContainer
   - 验证组件状态变量更新仍能触发UI刷新

4. **状态变量更新验证**：自定义组件ComponentUnderBuilderNode使用@State装饰器声明状态变量message，并添加@Watch监听。在跨Ability迁移后，点击按钮修改message的值，可以正常触发UI刷新和@Watch回调，验证迁移成功。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行, 支持设备：RK3568。

2. 本示例为Stage模型，支持API24版本SDK，版本号：6.1.1.36(24)，镜像版本号：OpenHarmony_6.1.1.36(24)。

3. 不建议在onBackground阶段异步修改迁移组件中的状态变量。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/EnableCustomComponentCrossAbility > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````
