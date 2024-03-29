# DisplaySync测试用例归档

## 用例表

| 测试功能    | 预置条件         | 输入             | 预期输出                  | 是否自动 | 测试结果 |
|---------|--------------|----------------|-----------------------|------|------|
| 拉起应用    | 	设备正常运行      | 		             | 成功拉起应用                | 是    | Pass |
| 主页展示    | 	设备正常运行      | 		             | 展示CustomDraw、PropertyAnimation、XComponent、Animator按钮 | 是    | Pass |
| 主页按钮点击 | 	位于主页        | 	点击CustomDraw | 	跳转自绘制页面      | 是    | Pass |
| 自绘制开始   | 	位于自绘制 | 点击Start   | 数字30、60分别按照30hz、60hz频率放大缩小          | 是    | Pass |
| 自绘制停止  | 	位于自绘制 | 点击Stop           | 	数字30、60变化停止                 | 是    | Pass |
| 自绘制返回主页  | 	位于自绘制        | 点击Back      | 	回到主页             | 是    | Pass |
| 主页按钮点击  | 	位于主页        | 	点击PropertyAnimation | 	跳转属性动画页面      | 是    | Pass |
| 属性动画开始  | 	位于属性动画页面    | 点击Start      | 	三个方块分别按照30hz、40hz、60hz频率来回移动            | 是    | Pass |
| 属性动画返回主页    | 	位于属性动画页面    | 点击Back      | 	回到主页          | 是    | Pass |
| 主页按钮点击    | 	位于主页    | 点击XComponent           | 	跳转XComponent页面                 | 是    | Pass |
| XComponent开始  | 位于XComponent页面         | 点击Start       | 两个方块分别按照30hz、120hz频率来回移动            | 是    | pass |
| XComponent停止  | 位于XComponent页面   | 点击Stop   | 两个方块移动停止              | 是    | pass |
| XComponent返回主页  | 位于XComponent页面   | 点击Back       | 回到主页              | 是    | pass |
| 主页按钮点击  | 位于主页   | 点击Animator    | 跳转Animator动画页面        | 是    | pass |
| Animator动画开始  | 位于Animator页面   | 先点击Create再点击Play    |  三个方块分别按照10hz、30hz、60hz频率放大       | 是    | pass |
| Animator返回主页  | 位于Animator页面   | 点击Back    | 回到主页        | 是    | pass |
