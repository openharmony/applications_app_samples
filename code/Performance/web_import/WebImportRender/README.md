# Web预渲染优化

### 介绍

本示例展示如何通过自定义组件封装NodeContainer，对Web页面启动和跳转场景进行预渲染优化。

### 效果预览图

| 首页                         | 跳转页面                         |
|----------------------------|------------------------------|
| ![](./screenshot/home.png) | ![](./screenshot/second.png) |

**使用说明**  
  
进入首页，点击加载下一页，页面可以成功跳转。

#### 原理说明

预渲染优化适用于Web页面启动和跳转场景，例如，进入首页后，跳转到二级页面。与预连接、预下载不同的是，预渲染需要开发者额外创建一个新的ArkWeb组件，并在后台对其进行预渲染，此时该组件并不会立刻挂载到组件树上，即不会对用户呈现(组件状态为Hidden和InActive)，开发者可以在后续使用中按需动态挂载。

具体原理如下图所示，首先需要定义一个自定义组件封装ArkWeb组件，该ArkWeb组件被离线创建，被包含在一个无状态的节点NodeContainer中，并与相应的NodeController绑定。该ArkWeb组件在后台完成预渲染后，在需要展示该ArkWeb组件时，再通过NodeController将其挂载到ViewTree的NodeContainer中，即通过NodeController绑定到对应的NodeContainer组件。预渲染通用实现的步骤如下：

创建自定义ArkWeb组件：开发者需要根据实际场景创建封装一个自定义的ArkWeb组件，该ArkWeb组件被离线创建。 创建并绑定NodeController：实现NodeController接口，用于自定义节点的创建、显示、更新等操作的管理。并将对应的NodeController对象放入到容器中，等待调用。 绑定NodeContainer组件：将NodeContainer与NodeController进行绑定，实现动态组件页面显示。

[文章链接](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/performance/performance-web-import.md#%E9%A2%84%E6%B8%B2%E6%9F%93%E4%BC%98%E5%8C%96)

### 工程目录

   ```
   entry/src/main/ets
   |---pages
   |---|---Index.ets        // 首页
   |---|---common.ets       // 自定义Web组件
   |---|---Second.ets       // 跳转页面

   ```

### 具体实现

1. 创建载体，并创建ArkWeb组件。[详细代码](entry/src/main/ets/entryability/EntryAbility.ets)
   
2. 创建NodeContainer和对应的NodeController，渲染后台ArkWeb组件。[详细代码](entry/src/main/ets/pages/common.ets)

3. 通过NodeContainer使用已经预渲染的页面。[详细代码](entry/src/main/ets/pages/Index.ets)

4. 通过NodeContainer预渲染跳转页面。[详细代码](entry/src/main/ets/pages/Second.ets)

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行;

2. 本示例已适配API20版本SDK，SDK版本号(API Version 20 Release),镜像版本号(5.1.0 Release)。

3. 本示例需要使用DevEco Studio 版本号(5.1.0 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Performance/web_import/WebImportRender/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```