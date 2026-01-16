## PersistenceV2能力增强

案例测试用例

### 用例表

|                     测试功能                      |       预置条件       |     输入      |        预期输出         | 是否自动化 | 测试结果 |
|:---------------------------------------------:|:----------------:|:-----------:|:-------------------:|:-----:|:----:|
|                  PersistenceV2持久化循环引用对象场景                  |  启动应用进入Circular Reference of Object页面   | 点击按钮 | 第一次打开应用，界面显示'a, b'，第二次打开应用，界面显示'aa, bb'，持久化成功 |  No   | Pass |
|                  PersistenceV2持久化自定义class中属性为Number场景                  |  启动应用进入Non Top Level Number of class页面   | 点击按钮 | 第一次打开应用，界面显示'this.number.value: Infinity, is instanceof Number true'， 第二次打开应用，界面显示'this.number.value: -Infinity, is instanceof Number true' |  No   | Pass |
|                  PersistenceV2持久化Array<ClassA>场景                  |  启动应用进入Top Level Array ClassA页面   | 点击按钮 | 第一次打开应用，界面显示'this.number.value: Infinity, is instanceof Number true'，第二次打开应用，界面显示'this.number.value: -Infinity, is instanceof Number true' |  No   | Pass |
|                  PersistenceV2持久化Array<ClassA>, 测试各种Array API的场景                  |  启动应用进入Top Level Array<ClassA> APIS页面   | 点击按钮 | 点击'array.push(0)'，重启应用，Repeat数组项是：1, 2, 0 |  No   | Pass |
|                  PersistenceV2持久化collections.Array<ClassA>的场景                  |  启动应用进入Top Level Collections Array页面   | 点击按钮 | 点击'array.push(0)'，重启应用，Repeat数组项是：1, 2, 0， 点击'array.pop()'，重启应用，Repeat数组项是：1, 2 |  No   | Pass |
