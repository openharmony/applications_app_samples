# ImageCAPIGuide测试用例

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|:---|:---|:---|:---|:---:|:---:|
| 验证Native图片显示功能 | 1. 需在真机测试 <br/> 2. 构建并安装测试hap <br/> 3. 进入应用 | 1、点击"Show Native UI"按钮 | 1、显示3张图片（pic0.png、pic1.svg、pic2.png）<br/>2、每张图片尺寸为200x200<br/>3、图片带有2px边框 | 否 | Pass |
| 验证图片加载完成事件 | 1. 需在真机测试 <br/> 2. 构建并安装测试hap <br/> 3. 进入应用<br/>4. 连接hilog日志 | 1、点击"Show Native UI"按钮<br/>2、观察日志输出 | 1、HiLog打印："Image loaded: [实际宽度]x[实际高度]"<br/>2、日志域为0x3200，标签为"ImageExample" | 否 | Pass |
| 验证SVG填充颜色功能 | 1. 需在真机测试 <br/> 2. 构建并安装测试hap <br/> 3. 进入应用 | 1、查看第二张图片（pic1.svg） | 1、SVG图片显示为蓝色（0xFF007DFF）<br/>2、图片正常渲染无变形 | 否 | Pass |
| 验证占位图显示功能 | 1. 需在真机测试 <br/> 2. 构建并安装测试hap <br/> 3. 进入应用<br/>4. 删除或损坏pic2.png | 1、点击"Show Native UI"按钮 | 1、第三张图片位置显示占位图pic3.png<br/>2、HiLog打印图片加载错误日志 | 否 | Pass |
| 验证Native组件销毁功能 | 1. 需在真机测试 <br/> 2. 构建并安装测试hap <br/> 3. 进入应用<br/>4. 已显示Native UI | 1、点击"Hide Native UI"按钮 | 1、3张图片从界面消失<br/>2、ContentSlot区域恢复空白<br/>| 否 | Pass |