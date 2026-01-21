## SyncMonitor能力增强

案例测试用例

### 用例表

|                     测试功能                      |       预置条件       |     输入      |        预期输出         | 是否自动化 | 测试结果 |
|:---------------------------------------------:|:----------------:|:-----------:|:-------------------:|:-----:|:----:|
|                  测试Monitor和SyncMonitor监听状态变量差异                  |   启动应用进入Compare SyncMonitor With Monitor页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试SyncMonitor监听多个状态变量场景                  |  启动应用进入Monitor multiple variables页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试SyncMonitor监听对象属性的场景                |  启动应用进入Monitor object variable页面   | 点击按钮 | 可正常输出日志|  No   | Pass |
|                  测试@SyncMonitor中监听@ObservedV2中属性的场景                  |  启动应用进入Monitor variables in ObservedV2 class页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试SyncMonitor监听嵌套对象属性的场景                  |  启动应用进入Monitor two layer variables in ObservedV2 class页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试基类和继承类中监听变量属性的场景                  |  启动应用进入Monitor variable in base and derived class页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试监听对象变化，属性未变化的场景                  |  启动应用进入Monitor entire object change but property no change页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试SyncMonitor跟Monitor行为不一样的场景                  |  启动应用进入SyncMonitor behaves differently from Monitor页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试使用通配符监听对象属性的场景                  |  启动应用进入Wildcard monitor object property change页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试使用通配符监听数组项的场景                  |  启动应用进入Wildcard monitor array item change页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试使用通配符监听嵌套对象属性的场景                  |  启动应用进入Wildcard monitor nested object property change页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试使用通配符监听数组第1项对象属性变化的场景                  |  启动应用进入Wildcard monitor array first item change页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试使用SyncMonitor监听变量两次的场景                  |  启动应用进入Monitor the same variable two times页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试使用SyncMonitor监听失效时机场景                  |  启动应用进入Effective and ineffective times of variable monitoring页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试使用SyncMonitor监听Computed变量场景                  |  启动应用进入Monitor computed variable页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
|                  测试使用SyncMonitor监听变量从可访问到不可访问场景                  |  启动应用进入Monitor variable from accessible to inaccessible页面   | 点击按钮 | 可正常输出日志 |  No   | Pass |
