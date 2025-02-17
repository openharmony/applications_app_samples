# ArkGraphics 3D

## 介绍

本示例通过 ArkGraphics 3D 的接口，利用轻量级的 3D 引擎和渲染管线，实现了 3D 场景创建、3D 场景资源创建和 3D 动画创建。

本示例主要展现了如何利用 ArkGraphics 3D 来实现 3D 图像的渲染，其中利用 Scene、Camera 和 Light 来创建基础的场景，使用 Material、Shader、Image 和Environment 来实现场景资源，采用 Animation 的各种方法来播放 3D 动画。

## 效果预览

|                       Index                       |                       Scene                       |                       Resource                       |                       Animation                       |
| :-----------------------------------------------: | :-----------------------------------------------: | :--------------------------------------------------: | :---------------------------------------------------: |
| <img src=".\screenshots\index.png" width="360" /> | <img src=".\screenshots\scene.png" width="360" /> | <img src=".\screenshots\resource.png" width="360" /> | <img src="./screenshots\animation.png" width="360" /> |

**使用方法：**

1. 在 Index 页面点击 ` BUilding and Managing ArkGraphics 3D Scenes` 按钮，跳转至 Scene 页面；
   - 在 Scene 页面点击 `Model Loading and Display` 按钮，页面跳转至 Model 页面，显现 3D 头盔图像。点击 `Back` 按钮，返回至 Scene 页面；
   - 在 Scene 页面点击 `Creating and Managing a Camera` 按钮，页面跳转至 Camera 页面，显现几何体图像。通过调节 `X-axis`、`Y-axis` 和 `Z-axis` 滑动条，即可分别修改相机的 X 轴，Y 轴和 Z 轴。点击 `Back` 按钮，返回至 Scene 页面；
   - 在 Scene 页面点击 `Creating and Managing Light` 按钮，页面跳转至 Light 页面，显现几何体图像。通过调节 `Red`、`Green` 和 `Blue` 滑动条，即可分别调节光线的红、绿和蓝的颜色通道。点击 `Back` 按钮，返回至 Scene 页面；
   - 在 Scene 页面点击 `Back` 按钮，返回至 `Index` 页面；
2. 在 Index 页面点击 `Creating and using ArkGraphics 3D Resources` 按钮，跳转至 Resource 页面。点击 `Replace with a blank material` 按钮，几何体图像的材质被空白材质替换。点击 `Replace with a Shader material` 按钮，几何体图像的材质被着色器材质替换。点击 `Replace with a Image material`，几何体材质被图像材质替换。点击 `Add to Environment` 按钮，给几何体图像添加背景。点击 `Back` 按钮，返回至 Index 页面；
3. 在 Index 页面点击 `Controlling and Managing ArkGraphics 3D Scene Animations` 按钮，跳转至 Animation 页面。点击 `start` 按钮，播放动画。点击 `pause` 按钮，中止动画。点击 `stop` 按钮，暂停动画。点击 `finish` 按钮，结束动画。点击 `restart` 按钮，重新播放动画。点击 `seek to 30% progress` 按钮，动画从 30% 进度开始播放。点击 `Back` 按钮，返回至 Index 页面；

## 工程目录

```
|--entry/src/main
│  |--ets // ets代码区
│  │  |--entryability
│  │  │  |--EntryAbility.ts // 程序入口类
|  |  |  |--EntryAbility.ets
|  |  |--arkGraphic
│  │  │  |--animation.ets // 动画
|  |  |  |--resource.ets // 场景资源
|  |  |  |--scene.ets // 场景搭建
|  |  |--scene
|  |  |  |--camera.ets // 相机
|  |  |  |--init.ets // 模型加载
|  |  |  |--light.ets // 光线
│  │  |--pages // 页面文件
│  │  |  |--Index.ets // 初始页面
│  │  |--utils // 工具类
|  |--resources // 资源文件目录
```

## 具体实现

1. 创建场景：一个 3D 场景通常由模型、相机和光源三个关键部分组成。其中先加载模型，再生成相机和光源。等 3D 图像加载完毕，可以使 Component3D 组件将渲染好的图像传递给用户。

   - | 接口名                                                 | 描述     |
     | ------------------------------------------------------ | -------- |
     | `Scene.load(): Promise<Scene>`                         | 加载模型 |
     | `SceneResourceFactory.createCamera(): Promise<Camera>` | 创建相机 |
     | `SceneResourceFactory.createLight(): Promise<Light>`   | 创建光源 |

   - | SceneOption 参数     | 描述                                                         |
     | -------------------- | ------------------------------------------------------------ |
     | scene: Scene         | 3D模型资源文件或场景对象，默认值为undefined。 <br/>**说明：目前仅支持GLTF格式资源。** |
     | modelType: ModelType | 3D场景显示合成方式。<br/>**说明：**<br/>一般开发者可以使用默认值而无需关心此项设置。 |

2. 创建场景资源：3D 场景中主要有以下常见资源：

   - 材质（Material）：材质是对场景中物体的光学物理性质的数学建模。在渲染计算的过程中，利用这些物理性质计算与光的相互作用，得到渲染的颜色。ArkGraphics 3D 提供的材质类型基于 PBR 渲染，支持用户参照 PBR 渲染材质类型创建材质资源，得到预期的渲染结果。

   - 图片（Image）： 图片本质上是上一个储存信息的二维内存块(buffer)，用于储存 3D 渲染计算过程需要的相关信息，比如基础色、法线等等。ArkGraphics 3D 提供基于 PNG、JPG、KTX格式创建 Image 资源的能力，支持用户自定义需要的 Image 资源。

   - 着色器（Shader）： 着色器是 GPU 上可以执行的一段程序，可以控制 GPU 执行哪些并行计算操作。AGP 引擎提供的默认着色器实现了 PBR 渲染，开发者只需要指定对应的参数就可以完成不同的 PBR 渲染。ArkGraphics 3D 支持开发者创建自定义的着色器，开发者可以通过自定义着色器自定义渲染计算过程，完全控制渲染计算流程，比如控制某物体不受某光源的影响等。

   - 环境（Environment）： 环境是 3D 场景背景的一种描述，可以基于图片进行创建。通过将一张图片进行正方体或者球体的映射处理，将图片贴在正方体或者球体上，在 3D 场景中模拟真实的环境。ArkGraphics 3D 支持用户创建环境资源，定义 3D 场景的背景。

   - | 接口名                                                       | 描述       |
     | ------------------------------------------------------------ | ---------- |
     | `SceneResourceFactory.createMaterial(): Promise<Material>`   | 创建材质   |
     | `SceneResourceFactory.createImage(): Promise<Image>`         | 创建图片   |
     | `SceneResourceFactory.createShader(): Promise<Shader>`       | 创建着色器 |
     | `SceneResourceFactory.createEnvironment(): Promise<Environment>` | 创建环境   |

	- 尤其需要注意：在 ArkGraphics 3D 中需要将材质（Material）给与子网格（SubMesh）才能成功替换材质。
	
	- | SubMesh 属性           | 说明                     |
	  | ---------------------- | ------------------------ |
	  | name: string           | 名称，没有特殊格式要求。 |
	  | **material: Material** | 材质。                   |
	  | aabb: Aabb             | 轴对齐边界盒。           |

3. 创建动画：动画是3D场景中重要的资源类型，用于控制场景中各种元素的运动。

   - 调用 `start` 方法控制动画开启；

   - 调用 `pause` 方法控制动画暂停；

   - 调用 `stop` 方法控制动画停止，并将动画状态设置为开头；

   - 调用`finish` 方法控制动画结束，并将动画状态设置为结尾；

   - 调用 `restart` 方法控制动画从头开始；

   - 调用 `seek` 方法控制动画设置到指定状态；

   - `onStarted` 方法在动画开始时执行传入的回调；

   - `onFinished` 方法在动画结束时执行传入的回调。

## 相关权限

不涉及。

## 依赖

不涉及。

## 约束与限制

1.本示例仅支持在标准系统上运行；

2.本示例为 Stage 模型，已适配 API version 14 版本 SDK，SDK 版本号（API Version 14 5.0.2.57）；

3.本示例需要使用 DevEco Studio 版本号（5.0.5.306）及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/graphic/Arkgraphics3D/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```