# 组件随软键盘弹出避让

### 介绍

本示例介绍使用TextInput组件和LazyForEach实现组件随软键盘弹出避让场景。该场景多用于需要用户手动输入文字类应用。

### 效果图预览

<img src="./casesfeature/keyboardavoid/keyboard_avoid.gif" width="200">

**使用说明**

1. 进入案例时，TextInput获焦，弹出系统键盘，点击空白地方键盘收起；
2. 点击输入框触发TextInput获焦，弹出系统键盘；
3. 点击“弹出键盘”按钮触发TextInput获焦，弹出系统键盘；
4. 在上抬避让模式下， 键盘抬起时组件上抬，键盘收起后让组件恢复；
5. 在缩小避让模式下，键盘抬起时组件上抬并缩小，键盘收起后让组件恢复；

### 实现思路

场景一：通过设置defaultFocus属性为true，使TextInput自动获焦，完成进入案例自动拉起键盘；

场景二：TextInput组件拥有点击获焦能力，输入框使用TextInput组件即可实现点击输入框弹出系统键盘；

场景三：通过使用focusControl.requestFocus API实现textInput获焦拉起键盘；

场景四：通过设置setKeyboardAvoidMode API，将页面的避让模式设置为RESIZE模式，,即可实现键盘拉起时组件上抬避让场景；

场景五 ：通过监听键盘高度，可以实时感知键盘拉起收起状态，实现缩放组件尺寸的调整，达到键盘拉起组件缩小效果，配合KeyboardAvoidMode.RESIZE避让模式，实现组件上抬缩小场景。

1. 创建KeyboardDataSource类，用于KeyboardAvoid和LazyForEach加载数据。源码参考[BasicDataSource.ets](./casesfeature/keyboardavoid/src/main/ets/basicDataResource/BasicDataSource.ets)
```ts
export class KeyboardDataSource {
  private dataArray: string[] = [];
  private listeners: DataChangeListener[] = [];

  constructor(dataArray: string[]) {
    for (let i = 0; i < dataArray.length; i++) {
      this.dataArray.push(dataArray[i]);
    }
  }
  public getData(index: number): string {
    return this.dataArray[index];
  }
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }
// ...
}
```
2. TextInput组件存在默认交互逻辑，默认即为可获焦，通过defaultFocus属性设置实现TextInput组件自动获焦。在输入按钮的点击事件中调用focusControl.requestFocus API，TextInput组件的id为方法参数，即可实现给TextInput组件申请焦点功能。源码参考[KeyboardAvoidIndex.ets](./casesfeature/keyboardavoid/src/main/ets/components/KeyboardAvoidIndex.ets)
```ts
TextInput()
  .defaultFocus(true)
  .key('keyInput')

Button('输入')
  .onClick(() => {
    focusControl.requestFocus('keyInput');
  })
```
3. 通过设置setKeyboardAvoidMode API，将虚拟键盘抬起时页面的避让模式设置为RESIZE模式，KeyboardAvoidMode.RESIZE是压缩Page的大小，Page下设置百分比宽高的组件会跟随Page压缩,即可实现键盘拉起时组件上抬效果。源码参考[KeyboardAvoidIndex.ets](./casesfeature/keyboardavoid/src/main/ets/components/KeyboardAvoidIndex.ets)

```ts
aboutToAppear(): void {
    let context = getContext(this) as common.UIAbilityContext
    context.windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.on('keyboardHeightChange', (data: number) => {
        this.keyboardHeight = px2vp(data);
      })
    })
  }
```

4. 通过监听键盘高度，可以感知到键盘的拉起收起状态，实现缩放组件尺寸的调整，配合KeyboardAvoidMode.RESIZE避让模式，实现组件上抬压缩效果。源码参考[KeyboardAvoidIndex.ets](./casesfeature/keyboardavoid/src/main/ets/components/KeyboardAvoidIndex.ets)

```ts
aboutToAppear(): void {
  window.getLastWindow(getContext(this)).then(currentWindow => {
    currentWindow.on('keyboardHeightChange', (data: number) => {
      this.keyboardHeight = px2vp(data);
    })
  })
}

@Builder
scalingContentComponent(item: string) {
  Column() {
    Image('')
    .borderRadius(8)
    .objectFit(ImageFit.Contain)
    .width(this.keyboardHeight > 0 ? '40' : '80')
    .height(this.keyboardHeight > 0 ? '40' : '80')
    Text(item)
    .fontColor(Color.Black)
    .textAlign(TextAlign.Center)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
  }
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center)
  .width(this.keyboardHeight > 0 ? '110' : '175')
  .height(this.keyboardHeight > 0 ? '110' : '175')
}
```

### 高性能知识点

本示例使用了LazyForEach进行数据懒加载，[liftUpComponents布局](./casesfeature/keyboardavoid/src/main/ets/components/KeyboardAvoidIndex.ets)时会根据可视区域按需创建liftUpContentComponent组件，并在liftUpContentComponent滑出可视区域外时销毁以降低内存占用。

### 工程结构&模块类型  

   ```
   keyboardavoid                            // har类型
   |---pages
   |   |---KeyboardAvoidIndex.ets           // 视图层-应用主页面 
   |---basicDataResource                    
   |   |---BasicDataSource.ets              // 数据模型层-LazyForEach控制器
   ```

### 参考资料

[安全区域](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-universal-attributes-expand-safe-area.md)

[LazyForEach](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-rendering-control-lazyforeach.md)

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例为Stage模型，支持API12版本SDK，SDK版本号（API Version 12 Release）。

3.本示例需要使用DevEco Studio版本号（DevEco Studio 5.0.0 Release）及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```shell
git init
git config core.sparsecheckout true
echo code/UI/KeyboardAvoid/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master