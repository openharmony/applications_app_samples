# Graphics3d测试用例归档

## 用例表

| 测试功能 | 预置条件         | 输入            | 预期输出                                                                                          | 是否自动 | 测试结果 |
|--|--------------|---------------|-----------------------------------------------------------------------------------------------|------|------|
| 拉起应用 | 	设备正常运行      | 		            | 成功拉起应用                                                                                        | 是    | Pass |
| 主页展示 | 	设备正常运行      | 		            | 展示container、node_base、node_camera、node_light、scene_environment、scene_animation、scene_shader按钮 | 是    | Pass |
| 主页按钮点击 | 	位于主页        | 	点击container  | 	跳转container页面                                                                                | 是    | Pass |
| 删除节点 | 	位于container | 点击remove node | 头盔消失                                                                                          | 是    | Pass |
| 尾端插入节点 | 	位于container | 点击append node | 	头盔出现                                                                                         | 是    | Pass |
| 当中插入节点 | 	位于container | 点击insert node | 	头盔出现                                                                                         | 是    | Pass |
| 返回主页 | 	位于container | 点击back        | 	回到主页                                                                                         | 是    | Pass |
| 主页按钮点击 | 	位于主页        | 	点击node_base  | 	跳转node_base页面                                                                                | 是    | Pass |
| 缩放功能 | 	位于node_base | 点击scale helmet | 头盔缩放                                                                                          | 是    | Pass |
| 旋转功能 | 	位于node_base | 点击rotate helmet | 	头盔旋转                                                                                         | 是    | Pass |
| 旋转父节点 | 	位于node_base | 点击rotate parent | 	头盔旋转                                                                                          | 是    | Pass |
| 节点可见性 | 	位于node_base | 点击root visible | 	头盔可见性                                                                                          | 是    | Pass |
| 层级标记 | 	位于node_base | 点击layer mask | 	头盔层级标记                                                                                          | 是    | Pass |
| 返回主页 | 	位于node_base | 点击back | 	回到主页                                                                                          | 是    | Pass |
| 主页按钮点击 | 	位于主页        | 	点击node_camera  | 	跳转node_camera页面                                                                                | 是    | Pass |
| 改变视场角 | 	位于node_camera | 点击change fov | 	改变视场角                                                                                         | 是    | Pass |
| 改变调色 | 	位于node_camera | 点击Change Tonemap Type | 	tone mapping 类型                                                                                         | 是    | Pass |
| 改变相机背景色 | 	位于node_camera | 点击set clearColor | 	背景色改变                                                                                         | 是    | Pass |
| 改变相机使能 | 	位于node_camera | 点击enabled | 	相机不再响应                                                                                         | 是    | Pass |
| 返回主页 | 	位于node_camera | 点击back | 	回到主页                                                                                          | 是    | Pass |
| 主页按钮点击 | 	位于主页        | 	点击node_light  | 	跳转node_light页面                                                                                | 是    | Pass |
| 改变光源类型 | 	位于node_light | 点击切换光源类型 | 	光源类型转变                                                                                         | 是    | Pass |
| 改变光源颜色 | 	位于node_light | 点击切换光源颜色 | 	光源颜色改变                                                                                         | 是    | Pass |
| 改变光源强度 | 	位于node_light | 点击切换光源强度 | 	光源强度                                                                                         | 是    | Pass |
| 改变光源阴影 | 	位于node_light | 点击切换光源阴影使能 | 	光源阴影使能                                                                                         | 是    | Pass |
| 改变光源使能 | 	位于node_light | 点击切换光源使能 | 	光源使能                                                                                         | 是    | Pass |
| 返回主页 | 	位于node_light | 点击back | 	回到主页                                                                                          | 是    | Pass |
| 主页按钮点击 | 	位于主页        | 	点击node_environment  | 	跳转到点击node_environment页面                                                                            | 是    | Pass |
| 改变环境贴图类型 | 	位于node_environment | 点击change env Img Type | 	环境贴图类型改变                                                                                         | 是    | Pass |
| 改变环境辐照度贴图 | 	位于node_environment | 点击change radiance Img | 	环境辐照贴图改变                                                                                         | 是    | Pass |
| 改变间接漫反射因子 | 	位于node_environment | 点击change indirectDiffuseFactor | 	间接漫反射效果改变                                                                                         | 是    | Pass |
| 改变间接高光反射因子 | 	位于node_environment | 点击change indirectSpecularFactor | 	间接高光反射效果改变                                                                                         | 是    | Pass |
| 改变环境贴图因子 | 	位于node_environment | 点击change environmentMapFactor | 	环境贴图效果改变                                                                                         | 是    | Pass |
| 改变环境辐照度系数 | 	位于node_environment | 点击change irradianceCoefficients | 	环境辐照度系数                                                                                         | 是    | Pass |
| 返回主页 | 	位于点击node_environment | 点击back | 	回到主页                                                                                          | 是    | Pass |
| 主页按钮点击 | 	位于主页        | 	scene_environment  | 	跳转到点击scene_environment页面                                                                            | 是    | Pass |
| 改变环境贴图类型 | 	位于scene_environment | 点击change env Img Type | 	环境贴图类型改变                                                                                         | 是    | Pass |
| 改变环境辐照度贴图 | 	位于scene_environment | 点击change radiance Img | 	环境辐照贴图改变                                                                                         | 是    | Pass |
| 改变间接漫反射因子 | 	位于scene_environment | 点击change indirectDiffuseFactor | 	间接漫反射效果改变                                                                                         | 是    | Pass |
| 改变间接高光反射因子 | 	位于scene_environment | 点击change indirectSpecularFactor | 	间接高光反射效果改变                                                                                         | 是    | Pass |
| 改变环境贴图因子 | 	位于scene_environment | 点击change environmentMapFactor | 	环境贴图效果改变                                                                                         | 是    | Pass |
| 改变环境辐照度系数 | 	位于scene_environment | 点击change irradianceCoefficients | 	环境辐照度系数                                                                                         | 是    | Pass |
| 返回主页 | 	位于点击scene_environment | 点击back | 	回到主页                                                                                          | 是    | Pass |
| 主页按钮点击 | 	位于主页        | 	点击scene_animation  | 	跳转到点击scene_animation页面                                                                            | 是    | Pass |
| 播放动画 | 	位于scene_animation | 点击start | 	动画播放                                                                                         | 是    | Pass |
| 暂停动画 | 	位于scene_animation | 点击pause | 	动画暂停                                                                                         | 是    | Pass |
| 停止动画 | 	位于scene_animation | 点击stop | 	动画停止                                                                                         | 是    | Pass |
| 动画完成 | 	位于scene_animation | 点击finish | 	动画完成                                                                                         | 是    | Pass |
| 动画重新开始 | 	位于scene_animation | 点击restart | 	动画重新播放                                                                                         | 是    | Pass |
| 返回主页 | 	位于位于scene_animation | 点击back | 	回到主页                                                                                          | 是    | Pass |
| 主页按钮点击 | 	位于主页        | 	点击scene_shader  | 	跳转到点击scene_shader页面                                                                            | 是    | Pass |
| 创建shader和材质 | 	位于scene_shader | 点击create shader and change material | 	画面展示shader变化                                                                                         | 是    | Pass |
| 恢复原来材质 | 	位于scene_shader | 点击recovery original material | 	shader恢复到原来画面                                                                                         | 是    | Pass |
| 材质覆盖 | 	位于scene_shader | 点击material override | 	画面展示shader变化                                                                                         | 是    | Pass |
| 返回主页 | 	位于位于scene_shader | 点击back | 	回到主页                                                                                          | 是    | Pass |