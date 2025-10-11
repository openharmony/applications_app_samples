# 测试用例归档

## 用例表

| 测试功能                       | 预置条件     | 输入                                                         | 预期显示                                                     | 是否自动 | 测试结果 |
| ------------------------------ | ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------- | -------- |
| 启动应用                       | 设备正常运行 | 1.开启开发板 <br/>2.编译hap包并将hap包及环境烧录进开发板，运行测试用例<br /> | 成功拉起应用。                                               | 否       | 验证通过 |
| swiper设置自定义箭头功能       | 应用位于首页 | 1.点击首页Swiper按钮                                         | 1.第一个swiper左右两侧各有一个圆形的淡灰色的箭头，swiper内容为“0” | 否       | 验证通过 |
| swiper设置自定义导航点功能     | 应用位于首页 | 1.点击首页Swiper按钮                                         | 1.第二个swiper左上角有一个被选中为红色未被选中为灰色的导航栏，swiper内容为“0” | 否       | 验证通过 |
| swiper设置自定义数字导航栏功能 | 应用位于首页 | 1.点击首页Swiper按钮                                         | 1.第三个swiper左上角显示数字导航栏，左侧数字为1/14，其中数字1为红色，14为灰色，swiper内容为“0” | 否       | 验证通过 |
| 基础 Text 样式展示       | 应用加载完成 | 1.查看第一段文本                                         | 1.宽 200vp 高 30vp 带边框，斜体 600 字重，超长跑马灯、不可复制 | 否       | 验证通过 |
| TextInput 输入功能     | 应用加载完成 | 1.点击输入框尝试输入                         | 1.支持输入，第一个样式内联，第二个带清除按钮  | 否       | 验证通过 |
| 基础 Button 样式展示         | 应用位于首页 | 1.点击首页Button按钮 2.点击ButtonType按钮 3.选择ARKUI_BUTTON_TYPE_NORMAL                           | 1.button为普通按钮                      | 否       | 验证通过 |
| 基础 Button 样式展示         | 应用位于首页 | 1.点击首页Button按钮 2.点击ButtonType按钮 3.选择ARKUI_BUTTON_TYPE_CAPSULE                          | 1.button为胶囊型按钮                     | 否       | 验证通过 |
| 基础 Button 样式展示         | 应用位于首页 | 1.点击首页Button按钮 2.点击ButtonType按钮 3.选择ARKUI_BUTTON_TYPE_CIRCLE                           | 1.button为圆形按钮                      | 否       | 验证通过 |
| 基础 Button 样式展示         | 应用位于首页 | 1.点击首页Button按钮 2.点击ButtonType按钮 3.选择ARKUI_BUTTON_ROUNDED_RECTANGLE                     | 1.button为圆角矩形按钮                   | 否       | 验证通过 |
| slider设置BlockStyle属性功能 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderBlockStyle按钮 3.选择ARKUI_SLIDER_BLOCK_STYLE_DEFAULT             | 1.slider使用默认圆形滑块                  | 否       | 验证通过 |
| slider设置BlockStyle属性功能 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderBlockStyle按钮 3.选择ARKUI_SLIDER_BLOCK_STYLE_IMAGE               | 1.slider使用图片资源作为滑块               | 否       | 验证通过 |
| slider设置BlockStyle属性功能 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderBlockStyle按钮 3.选择ARKUI_SLIDER_BLOCK_STYLE_SHAPE               | 1.slider使用自定义形状作为滑块，示例中为矩形   | 否       | 验证通过 |
| slider设置Style属性功能 | 应用位于首页 | 1.点击首页Slider按钮  2.点击SliderStyle按钮 3.选择ARKUI_SLIDER_STYLE_OUT_SET                       | 1.slider滑块在滑轨上                           | 否       | 验证通过 |
| slider设置Style属性功能 | 应用位于首页 | 1.点击首页Slider按钮  2.点击SliderStyle按钮 3.选择ARKUI_SLIDER_STYLE_IN_SET                        | 1.slider滑块在滑轨内                                  | 否       | 验证通过 |
| slider设置Style属性功能 | 应用位于首页 | 1.点击首页Slider按钮  2.点击SliderStyle按钮 3.选择ARKUI_SLIDER_STYLE_NONE                          | 1.slider无滑块                                        | 否       | 验证通过 |
| slider设置DirectionType属性功能 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderDirection按钮 3.选择ARKUI_SLIDER_DIRECTION_VERTICAL       | 1.slider方向变为为纵向                                       | 否       | 验证通过 |
| Chebox形状设置为圆形功能     | 应用位于首页 | 1.点击首页CheckboxShape按钮 2.点击菜单CheckboxShape，选择ArkUI_CHECKBOX_SHAPE_CIRCLE               | 1.圆形样式checkbox，可点击进行复选                        | 否       | 验证通过 |
| Chebox形状设置为方形功能     | 应用位于首页 | 1.点击首页CheckboxShape按钮 2.点击菜单CheckboxShape，选择ArkUI_CHECKBOX_SHAPE_SQUARE               | 1.圆形样式checkbox，可点击进行复选                        | 否       | 验证通过 |
| 设置悬停模式下显示区域的类型为屏幕上半部分区域    | 应用位于首页 | 1.点击首页HoverModeAreaType按钮 2.点击菜单HoverModeAreaType，选择ARKUI_HOVER_MODE_AREA_TYPE_TOP    | 1.悬停模式下显示区域的类型为屏幕上半部分区域  | 否       | 验证通过 |
| 设置悬停模式下显示区域的类型为屏幕下半部分区域    | 应用位于首页 | 1.点击首页HoverModeAreaType按钮 2.点击菜单HoverModeAreaType，选择ARKUI_HOVER_MODE_AREA_TYPE_BOTTOM | 1.悬停模式下显示区域的类型为屏幕下半部分区域  | 否       | 验证通过 |
| EmbeddedComponent OnErrorCallback回调成功 | 执行 hdc shell param set persist.sys.abilityms.multi_process_model false 后重启，应用位于首页 | 1.点击首页embedded component按钮 | EmbeddedComponent onError回调被触发，打印日志{OnErrorCallback:        code=100018, name=start_ability_fail, message=Start ui extension ability failed, please check the want of UIextensionAbility.} | 否 | 验证通过 |
| EmbeddedComponent OnTerminatedCallback回调成功 | 执行 hdc shell param set persist.sys.abilityms.multi_process_model true 后重启，应用位于首页 | 1.点击首页embedded component按钮 | EmbeddedComponent onError回调被触发，打印日志{OnTerminatedCallback: code=0} | 否 | 验证通过 |
| 文本无障碍属性设置 | 应用位于首页 | 1.点击首页Accessibility按钮 | 观测Get日志设置属性值与Set函数一致 | 否 | 验证通过 |
| visiblity属性设置 | 应用位于首页 | 1.点击首页Public按钮 | 观测页面ArkUI Visibility Demo下方有个设置了属性为VISIBLE的背景色为绿色的Text文本，同时该文本上方有一个Text文本大小的空白区域，为设置了Hidden被隐藏的Text文本。 | 否 | 验证通过 |
| 多态样式属性设置 | 应用位于首页 | 1.点击首页Public按钮 <br/>2.向下滑动，寻找标记为normal和effective的两个按钮 | 点击effective的按钮后，按钮样式发生变化，再次点击，按钮样式还原。 | 否 | 验证通过 |
| 截图属性设置 | 应用位于首页 | 1.点击首页Public按钮 <br/>2.向下滑动，寻找标记为截图的按钮 | 点击截图按钮后，打印出ComponentSnapshot相关日志。 | 否 | 验证通过 |
| ArkUI_HitTestMode属性设置 | 应用位于首页 | 1.点击首页Public按钮 <br/>2.向下滑动，寻找标记为ARKUI_HIT_TEST_MODE_DEFAULT的Text | 有四个分别设置了不同ArkUI_HitTestMode参数的背景色为黄色的Text，下方为设置ARKUI_HIT_TEST_MODE_DEFAULT的红色Text堆叠在设置为ARKUI_HIT_TEST_MODE_TRANSPARENT的绿色文本组件上，同时有设置ARKUI_HIT_TEST_MODE_DEFAULT的蓝色Text。 | 否 | 验证通过 |
| 验证XComponent创建成功 | 应用位于首页 | 1.点击首页XComponent按钮 | 1.包含两个XComponent显示框 | 否 | 验证通过 |