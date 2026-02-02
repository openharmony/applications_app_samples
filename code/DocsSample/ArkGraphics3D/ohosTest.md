| 测试功能    | 预置条件         | 输入             | 预期输出                  | 是否自动 | 测试结果 |
|:-------:|:------------:|:--------------:|:---------------------:|:----:|:----:|
| 拉起应用 |    设备正常运行      |                 | 成功拉起应用                                                                                        | 是    | Pass |
| 主页展示 |    设备正常运行      |                 | 展示 Building and Managing ArkGraphics 3D Scenes、Creating and Using ArkGraphics 3D Resources 和 Controlling and Managing ArkGraphics 3D Scene Animations 三种按钮 | 是    | Pass |
| 主页按钮点击 |  位于主页        |  点击 Building and Managing ArkGraphics 3D Scenes 按钮  |     跳转 Scene 页面                                                                    | 是    | Pass |
| Scene 页面按钮点击 | 位于 Scene 页面 | 点击 Model Loading and Display 按钮 | 跳转至 Model 页面，显现头盔                                      | 是    | Pass |
| Model 页面按钮点击 | 位于 Model 页面 | 点击 Back 按钮 |  返回 Scene 页面                                                                        | 是    | Pass |
| Scene 页面按钮点击 | 位于 Scene 页面 | 点击 Creating and Managing a Camera 按钮 |  跳转至 Camera 页面，显现几何体                                     | 是    | Pass |
| Camera 页面按钮点击 | 位于 Camera 页面 | 点击 Back 按钮 |  返回 Scene 页面                                                                         | 是    | Pass |
| Scene 页面 按钮点击 | 位于 Scene 页面 |  点击 Creating and Managing Light 按钮  |     跳转至 Light 页面                                                              | 是    | Pass |
| Light 页面按钮点击 |   位于 Light 页面   |                        点击 Back 按钮                        |                       返回 Scene 页面                        | 是    | Pass |
|  Scene 页面 按钮点击   |   位于 Scene 页面   |                        点击 Back 按钮                        |                           返回主页                           | 是    | Pass |
|      主页按钮点击      |      位于主页       |    点击 Creating and Using ArkGraphics 3D Resources 按钮     |               跳转至 Resource 页面，显现几何体               | 是    | Pass |
| Resource 页面按钮点击 | 位于 Resource 页面 | 点击 Replace with a blank material 按钮 |     用空白材质替换原有的材质                                        | 是    | Pass |
| Resource 页面按钮点击  | 位于 Resource 页面  |           点击 Replace with a image material 按钮            |                   用图像材质替换原有的材质                   | 是    | Pass |
| Resource 页面按钮点击  | 位于 Resource 页面  |           点击 Replace with a shader material 按钮           |                  用着色器材质替换原有的材质                  | 是    | Pass |
| Resource 页面按钮点击  | 位于 Resource 页面  |                 点击 Add to Environment 按钮                 |                           添加场景                           | 是    | Pass |
| Resource 页面按钮点击  | 位于 Resource 页面  |                        点击 Back 按钮                        |                           返回主页                           | 是    | Pass |
| 主页按钮点击 | 位于主页 | 点击 Controlling and Managing ArkGraphics 3D Scene Animations按钮 |    跳转至 Animation 页面                                                                      | 是    | Pass |
| Animation 页面按钮点击 | 位于 Animation 页面 | 点击 Start 按钮 |     开始播放动画                                                                                  | 是    | Pass |
| Animation 页面按钮点击 | 位于 Animation 页面 |                       点击 Pause 按钮                        |                         暂停播放动画                         | 是    | Pass |
| Animation 页面按钮点击 | 位于 Animation 页面 |                        点击 Stop 按钮                        |                         停止播放动画                         | 是    | Pass |
| Animation 页面按钮点击 | 位于 Animation 页面 |                       点击 Finish 按钮                       |                         结束播放动画                         | 是    | Pass |
| Animation 页面按钮点击 | 位于 Animation 页面 |                      点击 Restart 按钮                       |                         重新播放动画                         | 是    | Pass |
| Animation 页面按钮点击 | 位于 Animation 页面 |                点击 seek to 30% progress 按钮                |                     从 30% 开始播放动画                      | 是    | Pass |
| Animation 页面按钮点击 | 位于 Animation 页面 |                        点击 Back 按钮                        |                           返回主页                           | 是    | Pass |