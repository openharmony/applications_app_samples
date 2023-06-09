# 游戏2048

### 介绍

本示例使用Grid组件，实现了2048小游戏功能。

需要系统存储信息，运用了用户首选项接口[ohos.data.preferences](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-data-preferences.md) ,

屏幕属性接口[@ohos.display](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-display.md#displaygetdefaultdisplaydeprecated) 。


### 效果预览

|首页|游戏中|游戏结束|
|-------|-------|-------|
|![](screenshots/device/game_init.png)|![](screenshots/device/game_running.png)|![](screenshots/device/game_over.png)|

使用说明

1.每次可以选择上下左右其中一个方向去滑动，每滑动一次，所有的数字方块都会往滑动的方向靠拢外，系统也会在空白的地方随机出现一个数字方块， 相同数字的方块在靠拢、相撞时会相加。

2.当所有数字方块都无法有效滑动时，游戏结束。

### 工程目录
```
entry/src/main/ets/
|---muck
|   |---GameData.ets                        //  mock游戏数据
|---pages
|   |---index.ets                           // 首页
|---model                                  
|   |---GameRule.ets                        // 2048游戏的规则逻辑
|   |---GameModuel.ets                      // 游戏模型定义
|---resources/base                          // 存放游戏资源
|   |---element                             
|   |---media                               
```

### 具体实现
* 界面编写步骤  
  1、使用Grid编写网格界面，并在下方编写start按钮触发gameStart()函数生成gridItem所需数据，并且将游戏状态修改为游戏中，触发游戏规则Init()初始化游戏规则。  
  2、循环渲染gridItem，去生成网格数据，MyGridItem会根据每一个数据渲染每一个网格的数字颜色（<=4?黑:白）和背景色(通过自然对数计算出颜色数组中的当前索引)。  
  3、grid通过gesture()去绑定一组手势up,down,left,right函数, [源码参考](entry/src/main/ets/pages/Index.ets )。  
* 游戏规则编写  
  1、init()函数初始化游戏规则，将所有网格数字设置为0，游戏状态为开始，分数为0，并生成网格数字。[源码参考](entry/src/main/ets/model/GameRule.ets )。  
  2、触发up/down函数，网格沿着colnum移动，最多可移动三次(row大小-1次)，如果当前网格数字===要移动到的网格上的数字，就将要移动的网格数字 + 当前网格数字，将结果加上旧score赋值给最新的score，
  如果移动前的总数字不等于移动后的总数字，生成空白网格数字，[源码参考](entry/src/main/ets/model/GameRule.ets )。  
  3、触发left/right函数，网格沿着row移动，最多可移动三次(column大小-1次)，如果当前网格数字===要移动到的网格上的数字，就将要移动的网格数字 + 当前网格数字，将结果加上旧score赋值给最新的score，
  如果移动前的总数字不等于移动后的总数字，生成空白网格数字，[源码参考](entry/src/main/ets/model/GameRule.ets )。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400 , built on April 7, 2023)及以上版本才可编译运行。

3.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/Solutions/Game/Game2048/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````