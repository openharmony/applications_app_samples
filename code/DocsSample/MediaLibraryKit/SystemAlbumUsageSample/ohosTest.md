# 系统相册使用示例工程测试用例归档

## 用例表

| 测试功能       | 预置条件  | 输入                 | 预期输出                     | 是否自动 | 测试结果 |
|------------|-------| -------------------- | ---------------------------- | -------- | -------- |
| 获取收藏夹对象 | 在DevEco Stuido中编译sample工程成功。      |1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的GetFavoriteObject.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run GetFavoriteObject.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。                     | 1.成功找到文件。<br>4.测试结果成功。                 | 是       | Pass     |
| 获取收藏夹中的图片  |   1. 在设备的图库中收藏至少一张图片. <br>2. 在DevEco Stuido中编译sample工程成功。    |1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的GetMediaFromFavorites.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run GetMediaFromFavorites.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。          | 1.成功找到文件。<br>4.测试结果成功。                 | 是       | Pass     |
| 获取视频相册对象    | 在DevEco Stuido中编译sample工程成功。       | 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的GetVideoAlbum.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run GetVideoAlbum.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。         | 1.成功找到文件。<br>4.测试结果成功。                 | 是       | Pass     |
| 从视频相册中获取视频 | 在DevEco Stuido中编译sample工程成功。    | 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的GetVideosFromVideoAlbum.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run GetVideosFromVideoAlbum.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。         | 1.成功找到文件。<br>4.测试结果成功。                 | 是       | Pass     |