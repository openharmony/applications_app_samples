# 媒体资源变更通知示例工程测试用例归档

## 用例表

| 测试功能         | 预置条件   | 输入                 | 预期输出                     | 是否自动 | 测试结果 |
| ---------------- | ------ | -------------------- | ---------------------------- | -------- | -------- |
| 取消 URI 监听         | 在DevEco Stuido中编译sample工程成功。 | 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的cancelListeningURITest.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run cancelListeningURITest.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。| 1.成功找到文件。<br>4.测试结果成功。| 是       | Pass     |
| 注册所有资产的监听器         |  在DevEco Stuido中编译sample工程成功。| 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的RegisterForMonitoringAllAssets.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run RegisterForMonitoringAllAssets.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。| 1.成功找到文件。<br>4.测试结果成功。 | 是       | Pass     |
| 注册相册的监听器         | 1. 在DevEco Stuido中编译sample工程成功。<br>2. 在测试设备的图库应用中，创建用户相册，相册名为”test”。后续测试过程将对这个相册注册监听器。 | 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的RegisterListenerToAlbum.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run RegisterListenerToAlbum.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。| 1.成功找到文件。<br>4.测试结果成功。| 是       | Pass     |
| 注册照片资产的监听器         |  在DevEco Stuido中编译sample工程成功。| 1. 在EevEco Studio当前工程目录中找到ohosTest/ets/Test目录下的RegisterListenerToPhotoAsset.test.ets测试用例文件。<br>2. 选中此文件右键点击后，选中”Run RegisterListenerToPhotoAsset.test.ets”菜单执行测试。此时会先弹出用户授权弹框。<br>3. 在授权弹框点击”允许”授予所申请的权限。<br>4. 等待5秒，查看DevEco Studio的测试用例运行结果。|1.成功找到文件。<br>4.测试结果成功。| 是       | Pass     |