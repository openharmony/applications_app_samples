# Extension测试用例归档

## 用例表

| 测试功能                 | 预置条件           |输入| 预期输出                             | 是否自动 |测试结果|
|----------------------|----------------|--------------------------------|----------------------------------|------|--------------------------------|
| 拉起应用                 | startAbility应用 |  设备正常运行 |                  | 成功拉起应用                           | 是    |Pass|
| 访问共享文件成功             | 页面显示正常         |点击屏幕上的uiability在由"test1"的groupId产生的主应用共享目录下创建共享文件按钮| 访问成功，打印日志Try to write str.       | 是    |Pass|
| 访问共享文件失败             | 页面显示正常         |点击屏幕上的uiability在由"test2"的groupId产生的主应用共享目录下创建共享文件按钮| 访问失败，打印日志{"code":13900002}       | 是    |Pass|
| 访问module级别独立extension | 页面显示正常         |点击屏幕上的uiability访问inputmethod module级别的独立extension的沙箱文件按钮| 页面上UIAbility1变为inputtest1 failed | 是    |Pass|
| 访问应用级别独立extension    | 页面显示正常         |点击屏幕上的uiability访问inputmethod module级别的独立extension的沙箱文件按钮| 页面上UIAbility1变为inputtest2 failed | 是    |Pass|
