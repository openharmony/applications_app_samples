# 测试用例归档

## 用例表

| 测试功能                       | 预置条件     | 输入                                                         | 预期显示                                                     | 是否自动 | 测试结果 |
| ------------------------------ | ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------- | -------- |
| 启动应用                       | 设备正常运行 | 1.开启开发板 <br/>2.编译hap包并将hap包及环境烧录进开发板，运行测试用例<br /> | 成功拉起应用。                                               | 否       | 验证通过 |
| swiper设置自定义箭头功能       | 应用位于首页 | 1.点击首页Swiper按钮                                         | 1.第一个swiper左右两侧各有一个圆形的淡灰色的箭头，swiper内容为“0” | 否       | 验证通过 |
| swiper设置自定义导航点功能     | 应用位于首页 | 1.点击首页Swiper按钮                                         | 1.第二个swiper左上角有一个被选中为红色未被选中为灰色的导航栏，swiper内容为“0” | 否       | 验证通过 |
| swiper设置自定义数字导航栏功能 | 应用位于首页 | 1.点击首页Swiper按钮                                         | 1.第三个swiper左上角显示数字导航栏，左侧数字为1/14，其中数字1为红色，14为灰色，swiper内容为“0” | 否       | 验证通过 |
| DatePicker设置为年月模式    | 1.手机正常开机 2.应用正常安装 | 1.打开应用 2.选择DatePicker选项 3.点击"选择DATEPICKER模式"，选择ARKUI_DATEPICKER_YEAR_AND_MONTH选项 | 1.应用成功打开 2.datePicker页面正常跳转 3.显示的datePicker为只有年和月的选项  | 否       | 验证通过 |
| Progress自定义样式功能    | 1.手机正常开机 2.应用正常安装 | 1.打开应用 2.选择Progress选项 3.点击按钮"选择节点类型："，选择ARKUI_PROGRESS_TYPE_LINEAR 4.平滑效果打开，扫描效果打开，线宽输入30，圆角半径输入40，并点击按钮"设置styleOption：" 5.点击按钮"获取styleOption值并销毁" | 1.应用成功打开 2.Progress页面正常跳转 3.显示的Progress组件为linear样式 4.显示的Progress组件为linear样式并线宽为30，圆角半径为40 5.显示"styleOption: scanEffectEnabled = 1 smoothEffectEnabled = 1 strokeWidth = 30.0000000 strikeRadius = 40.0000000"  | 否       | 验证通过 |
| Image背景Y轴覆盖功能    | 1.手机正常开机 2.应用正常安装 | 1.打开应用 2.选择Image选项 3.点击按钮"选择背景覆盖方式ImageRepeat"，选择ARKUI_IMAGE_REPEAT_Y | 1.应用成功打开 2.Image页面正常跳转 3.显示图片的区域背景左侧为应用图标的竖向排列，并在中间单独显示一个应用图标  | 否       | 验证通过 |
| Image图片适应左上角功能    | 1.手机正常开机 2.应用正常安装 | 1.打开应用 2.选择Image选项 3.点击按钮"选择图片适应方式ObjectFit"，选择ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP_START | 1.应用成功打开 2.Image页面正常跳转 3.显示图片的区域背景为草原风景图，并在左上角单独显示一个应用图标  | 否       | 验证通过 |
| TextPicker单列带图标显示功能    | 1.手机正常开机 2.应用正常安装 | 1.打开应用 2.选择TextPicker选项 3.点击按钮"选择TextPicker类型"，选择ARKUI_TEXTPICKER_RANGETYPE_RANGE_CONTENT | 1.应用成功打开 2.TextPicker页面正常跳转 3.按钮"选择TextPicker类型"下方出现新按钮"设置CrossLanguage并获取结果",还有一个显示CrossLanguageOption的Text组件，以及下方出现元素为"应用图标+first"，"应用图标+second"的TextPicker  | 否       | 验证通过 |
| TextPicker级联显示功能    | 1.手机正常开机 2.应用正常安装 | 1.打开应用 2.选择TextPicker选项 3.点击按钮"选择TextPicker类型"，选择ARKUI_TEXTPICKER_RANGETYPE_CASCADE_RANGE_CONTENT 4.点击按钮"设置CrossLanguage并获取结果",选择true | 1.应用成功打开 2.TextPicker页面正常跳转 3.按钮"选择TextPicker类型"下方出现新按钮"设置CrossLanguage并获取结果",还有一个显示"CrossLanguageOption"的Text组件，以及下方出现父节点为"firstParent,secondParent"的级联TextPicker 4.Text组件中显示"CrossLanguageOption = true"  | 否       | 验证通过 |
| Calendar选择框左对齐功能    | 1.手机正常开机 2.应用正常安装 | 1.打开应用 2.选择CalendarPicker选项 3.点击按钮"设置对齐方式"，选择ARKUI_CALENDAR_ALIGNMENT_START，并点击CalendarPicker组件 | 1.应用成功打开 2.CalendarPicker页面正常跳转 3.显示出来的日历选择窗口，和CalendarPicker为左对齐形式  | 否       | 验证通过 |
| ImageAnimator通过String创建并显示    | 1.手机正常开机 2.应用正常安装 | 1.打开应用 2.选择ImageAnimator选项 3.宽度处输入300，高度处输入300，顶部处输入200，左侧处输入200，持续时间处输入200，点击按钮"创建mageAnimator"，选择createImageAnimatorFromString 4.点击按钮"获取FrameInfo值并销毁" | 1.应用成功打开 2.CalendarPicker页面正常跳转 3.显示出来一个动态图片，宽300px，高300px，位于距上边框200px，左侧200px处 4.显示"height = 300 width = 300 top = 200 left = 200 duration = 200"  | 否       | 验证通过 |
| ImageAnimator通过DrawableDescriptor创建并显示    | 1.手机正常开机 2.应用正常安装 | 1.打开应用 2.选择ImageAnimator选项 3.宽度处输入300，高度处输入300，顶部处输入200，左侧处输入200，持续时间处输入200，点击按钮"创建mageAnimator"，选择createImageAnimatorFromDrawableDescriptor 4.点击按钮"获取FrameInfo值并销毁" | 1.应用成功打开 2.CalendarPicker页面正常跳转 3.显示出来一个纯黑图片，宽300px，高300px，位于距上边框200px，左侧200px处 4.显示"height = 300 width = 300 top = 200 left = 200 duration = 200"  | 否       | 验证通过 |
| 基础 Text 样式展示       | 应用加载完成 | 1.查看第一段文本                                         | 1.宽 200vp 高 30vp 带边框，斜体 600 字重，超长跑马灯、不可复制 | 否       | 验证通过 |
| TextInput 输入功能     | 应用加载完成 | 1.点击输入框尝试输入                         | 1.支持输入，第一个样式内联，第二个带清除按钮  | 否       | 验证通过 |
| Button普通样式展示 | 应用位于首页 | 1.点击首页Button按钮 2.点击ButtonType按钮 3.选择ARKUI_BUTTON_TYPE_NORMAL | Button为普通按钮 | 否 | 验证通过 |
| Button胶囊样式展示 | 应用位于首页 | 1.点击首页Button按钮 2.点击ButtonType按钮 3.选择ARKUI_BUTTON_TYPE_CAPSULE | Button为胶囊型按钮 | 否 | 验证通过 |
| Button圆形样式展示 | 应用位于首页 | 1.点击首页Button按钮 2.点击ButtonType按钮 3.选择ARKUI_BUTTON_TYPE_CIRCLE | Button为圆形按钮 | 否 | 验证通过 |
| Button圆角矩形展示 | 应用位于首页 | 1.点击首页Button按钮 2.点击ButtonType按钮 3.选择ARKUI_BUTTON_ROUNDED_RECTANGLE | Button为圆角矩形按钮 | 否 | 验证通过 |
| Slider默认圆形滑块展示 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderBlockStyle按钮 3.选择ARKUI_SLIDER_BLOCK_STYLE_DEFAULT | Slider使用默认圆形滑块 | 否 | 验证通过 |
| Slider图片资源滑块展示 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderBlockStyle按钮 3.选择ARKUI_SLIDER_BLOCK_STYLE_IMAGE | Slider使用图片资源作为滑块 | 否 | 验证通过 |
| Slider自定义形状滑块展示 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderBlockStyle按钮 3.选择ARKUI_SLIDER_BLOCK_STYLE_SHAPE | Slider使用自定义形状作为滑块，示例中为矩形 | 否 | 验证通过 |
| Slider设置滑块在滑轨上 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderStyle按钮 3.选择ARKUI_SLIDER_STYLE_OUT_SET | Slider滑块在滑轨上 | 否 | 验证通过 |
| Slider设置滑块在滑轨内 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderStyle按钮 3.选择ARKUI_SLIDER_STYLE_IN_SET | Slider滑块在滑轨内 | 否 | 验证通过 |
| Slider设置无滑块 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderStyle按钮 3.选择ARKUI_SLIDER_STYLE_NONE | Slider无滑块 | 否 | 验证通过 |
| Slider设置方向为纵向 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderDirection按钮 3.选择ARKUI_SLIDER_DIRECTION_VERTICAL | Slider方向变为为纵向 | 否 | 验证通过 |
| Slider设置方向为横向 | 应用位于首页 | 1.点击首页Slider按钮 2.点击SliderDirection按钮 3.ARKUI_SLIDER_DIRECTION_HORIZONTAL | Slider方向变为为横向 | 否 | 验证通过 |
| Checkbox圆形样式展示 | 应用位于首页 | 1.点击首页CheckboxShape按钮 2.点击菜单CheckboxShape，选择ArkUI_CHECKBOX_SHAPE_CIRCLE | 圆形样式Checkbox，可点击进行复选 | 否 | 验证通过 |
| Checkbox方形样式展示 | 应用位于首页 | 1.点击首页CheckboxShape按钮 2.点击菜单CheckboxShape，选择ArkUI_CHECKBOX_SHAPE_SQUARE | 方形样式Checkbox，可点击进行复选 | 否 | 验证通过 |
| 设置悬停模式下显示区域的类型为屏幕上半部分区域(仅在折叠屏使用) | 应用位于首页 | 1.点击首页HoverModeAreaType按钮 2.点击菜单HoverModeAreaType，选择ARKUI_HOVER_MODE_AREA_TYPE_TOP | 悬停模式下显示区域的类型为屏幕上半部分区域 | 否 | 验证通过 |
| 设置悬停模式下显示区域的类型为屏幕下半部分区域(仅在折叠屏使用) | 应用位于首页 | 1.点击首页HoverModeAreaType按钮 2.点击菜单HoverModeAreaType，选择ARKUI_HOVER_MODE_AREA_TYPE_BOTTOM | 悬停模式下显示区域的类型为屏幕下半部分区域 | 否 | 验证通过 |
| EmbeddedComponent OnErrorCallback回调成功 | 执行 hdc shell param set persist.sys.abilityms.multi_process_model false 后重启，应用位于首页 | 1.点击首页embedded component按钮 | EmbeddedComponent onError回调被触发，打印日志{OnErrorCallback:        code=100018, name=start_ability_fail, message=Start ui extension ability failed, please check the want of UIextensionAbility.} | 否 | 验证通过 |
| EmbeddedComponent OnTerminatedCallback回调成功 | 执行 hdc shell param set persist.sys.abilityms.multi_process_model true 后重启，应用位于首页 | 1.点击首页embedded component按钮 | EmbeddedComponent onError回调被触发，打印日志{OnTerminatedCallback: code=0} | 否 | 验证通过 |
| 文本无障碍属性设置 | 应用位于首页 | 1.点击首页Accessibility按钮 | 观测Get日志设置属性值与Set函数一致 | 否 | 验证通过 |
| visiblity属性设置 | 应用位于首页 | 1.点击首页Public按钮 | 观测页面ArkUI Visibility Demo下方有个设置了属性为VISIBLE的背景色为绿色的Text文本，同时该文本上方有一个Text文本大小的空白区域，为设置了Hidden被隐藏的Text文本。 | 否 | 验证通过 |
| 多态样式属性设置 | 应用位于首页 | 1.点击首页Public按钮 <br/>2.向下滑动，寻找标记为normal和effective的两个按钮 | 点击effective的按钮后，按钮样式发生变化，再次点击，按钮样式还原。 | 否 | 验证通过 |
| 截图属性设置 | 应用位于首页 | 1.点击首页Public按钮 <br/>2.向下滑动，寻找标记为截图的按钮 | 点击截图按钮后，打印出ComponentSnapshot相关日志。 | 否 | 验证通过 |
| ArkUI_HitTestMode属性设置 | 应用位于首页 | 1.点击首页Public按钮 <br/>2.向下滑动，寻找标记为ARKUI_HIT_TEST_MODE_DEFAULT的Text | 有四个分别设置了不同ArkUI_HitTestMode参数的背景色为黄色的Text，下方为设置ARKUI_HIT_TEST_MODE_DEFAULT的红色Text堆叠在设置为ARKUI_HIT_TEST_MODE_TRANSPARENT的绿色文本组件上，同时有设置ARKUI_HIT_TEST_MODE_DEFAULT的蓝色Text。 | 否 | 验证通过 |
| 验证XComponent创建成功 | 应用位于首页 | 1.点击首页XComponent按钮 | 1.包含两个XComponent显示框 | 否 | 验证通过 |