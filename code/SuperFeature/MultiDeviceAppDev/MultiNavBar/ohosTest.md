##  用例表

| 测试功能 | 预置条件     | 输入                                                         | 预期输出                                                     | 是否自动 | 测试结果 |
| -------- | ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------- | -------- |
| 布局效果 | 应用正常拉起 | 窗口拖拽至360vp                                              | 导航栏以底部Tabs呈现，Tabs页签上下布局                       | 是       | Pass     |
| 布局效果 | 应用正常拉起 | 窗口拖拽至580vp                                              | 导航栏以底部Tabs呈现，Tabs页签左右布局                       | 是       | Pass     |
| 布局效果 | 应用正常拉起 | 窗口拖拽至800vp                                              | 导航栏以侧边Tabs呈现，Tabs页签只显示图标                     | 是       | Pass     |
| 布局效果 | 应用正常拉起 | 窗口拖拽至800vp，点击汉堡按钮                                | 导航栏以侧边导航栏呈现，侧边导航栏内容包含账户信息、搜索框、导航栏一级入口和二级入口、底部工具栏 | 是       | Pass     |
| 布局效果 | 应用正常拉起 | 窗口拖拽至800vp，点击搜索图标                                | 导航栏以侧边导航栏呈现，侧边导航栏内容包含账户信息、搜索框、导航栏一级入口和二级入口、底部工具栏 | 是       | Pass     |
| 布局效果 | 应用正常拉起 | 窗口拖拽至1080vp                                             | 导航栏以侧边导航栏呈现，侧边导航栏内容包含账户信息、搜索框、导航栏一级入口和二级入口、底部工具栏 | 是       | Pass     |
| 布局效果 | 应用正常拉起 | 窗口拖拽至1080vp，点击汉堡按钮                               | 导航栏以侧边Tabs呈现，Tabs页签显示图标 + 文字                | 是       | Pass     |
| 布局效果 | 应用正常拉起 | 窗口拖拽至1080vp，拖动侧边导航栏                             | 侧边导航栏可在240vp~280vp自由调节                            | 是       | Pass     |
| 布局效果 | 应用正常拉起 | 窗口拖拽至1080vp，点击底部工具栏添加按钮，点击汉堡按钮，点击更多图标按钮 | 底部工具栏以菜单的形式呈现                                   | 是       | Pass     |