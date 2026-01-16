# 媒体资源使用示例工程测试用例归档

## 用例表

| 测试功能         | 预置条件  | 输入                 | 预期输出                     | 是否自动 | 测试结果 |
| ---------------- |-------| -------------------- | ---------------------------- | -------- | -------- |
| 从媒体库获取媒体资源         |在DevEco Stuido中编译sample工程成功。| 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的GetMediaResource.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run GetMediaResource.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。 | 1.成功找到文件。<br>4.测试结果成功。                 | 是       | Pass     |
| 从媒体库获取媒体库缩略图         |在DevEco Stuido中编译sample工程成功。| 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的GetMediaThumbnails.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run GetMediaThumbnails.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。| 1.成功找到文件。<br>4.测试结果成功。                | 是       | Pass     |
| 将媒体移动到回收站         | 在DevEco Stuido中编译sample工程成功。| 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的MoveMediaToRecycleBin.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run MoveMediaToRecycleBin.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。| 1.成功找到文件。<br>4.测试结果成功。    | 是       | Pass     |
| 重命名媒体资源         |  在DevEco Stuido中编译sample工程成功。| 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的RenameMedia.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run RenameMedia.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。| 1.成功找到文件。<br>4.测试结果成功。 | 是       | Pass     |