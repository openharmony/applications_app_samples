| 测试功能              | 预置条件 | 输入         | 预期输出                                              |是否自动|测试结果|
|-------------------|------|------------|---------------------------------------------------|--------|--------|
| 拉起应用 | 设备正常运行 | 启动应用 | 成功拉起应用，显示主页面 |是|Pass|
| 创建并激活媒体会话 | 应用已启动，在主页面 | 1. 点击'创建并激活媒体会话'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入CreateAVSession页面<br>2. 成功创建并激活AVSession<br>3. 页面显示session创建和激活日志<br>4. 成功返回主页面 |是|Pass|
| 设置循环模式 | 应用已启动，在主页面 | 1. 点击'设置循环模式'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入SettingTheLoopMode页面<br>2. 注册setLoopMode事件监听器<br>3. 通过controller触发setLoopMode命令<br>4. 页面显示循环模式设置日志<br>5. 成功返回主页面 |是|Pass|
| 设置进度条 | 应用已启动，在主页面 | 1. 点击'设置进度条'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入SettingTheProgressBar页面<br>2. 成功设置播放进度信息<br>3. 页面显示进度设置成功日志<br>4. 成功返回主页面 |是|Pass|
| 设置元数据 | 应用已启动，在主页面 | 1. 点击'设置元数据'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入SetAVMetadata页面<br>2. 成功设置媒体元数据（标题、艺术家等）<br>3. 页面显示元数据设置成功日志<br>4. 成功返回主页面 |是|Pass|
| 适配蓝牙方式一 | 应用已启动，在主页面 | 1. 点击'适配蓝牙方式一：命令监听'按钮<br>2. 点击'hello world'文本 | 1. 成功进入AdaptingToBluetoothMethodOne页面<br>2. 注册play/pause命令监听器<br>3. 通过controller触发play和pause命令<br>4. 页面显示播放控制日志<br>5. 成功返回主页面 |是|Pass|
| 适配蓝牙方式二 | 应用已启动，在主页面 | 1. 点击'适配蓝牙方式二：按键监听'按钮<br>2. 点击'hello world'文本 | 1. 成功进入AdaptingToBluetoothMethodTwo页面<br>2. 注册handleKeyEvent按键监听器<br>3. 等待蓝牙设备按键事件（需真实蓝牙设备）<br>4. 页面显示监听器注册日志<br>5. 成功返回主页面 |是|Pass|
| 显示媒体资源标签 | 应用已启动，在主页面 | 1. 点击'显示媒体资源标签'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入DisplayTagsOfMediaAssets页面<br>2. 成功设置媒体资源标签信息<br>3. 页面显示标签设置日志<br>4. 成功返回主页面 |是|Pass|
| 收藏媒体资源 | 应用已启动，在主页面 | 1. 点击'收藏媒体资源'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入FavoritingMediaAssets页面<br>2. 注册toggleFavorite事件监听器<br>3. 页面显示监听器注册日志<br>4. 成功返回主页面 |是|Pass|
| 执行进度控制 | 应用已启动，在主页面 | 1. 点击'执行进度控制'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入PerformingProgressControl页面<br>2. 注册seek事件监听器<br>3. 通过controller触发seek命令<br>4. 页面显示"on seek , the time is 5000"等日志<br>5. 成功返回主页面 |是|Pass|
| 设置快进快退 | 应用已启动，在主页面 | 1. 点击'设置快进快退'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入SettingFastForward页面<br>2. 注册fastForward和rewind监听器<br>3. 设置skipIntervals元数据<br>4. 页面显示设置成功日志<br>5. 成功返回主页面 |是|Pass|
| 设置通用状态信息 | 应用已启动，在主页面 | 1. 点击'设置通用状态信息'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入SettingGeneralStateInformation页面<br>2. 成功设置播放状态信息<br>3. 页面显示状态设置成功日志<br>4. 成功返回主页面 |是|Pass|
| 设置歌词 | 应用已启动，在主页面 | 1. 点击'设置歌词'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入SettingLyrics页面<br>2. 成功设置歌词信息<br>3. 页面显示歌词设置成功日志<br>4. 成功返回主页面 |是|Pass|
| 设置播放列表信息 | 应用已启动，在主页面 | 1. 点击'设置播放列表信息'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入SettingPlaylistInformation页面<br>2. 成功设置播放列表信息<br>3. 页面显示设置成功日志<br>4. 成功返回主页面 |是|Pass|
| 处理不支持的命令 | 应用已启动，在主页面 | 1. 点击'处理不支持的命令'按钮进入页面<br>2. 点击'hello world'文本 | 1. 成功进入HandlingUnsupportedCommands页面<br>2. 演示注册和取消事件监听<br>3. 页面显示操作日志<br>4. 成功返回主页面 |是|Pass|