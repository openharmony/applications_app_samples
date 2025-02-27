# 验证码布局

### 介绍

本示例介绍如何使用Text组件实现验证码场景，并禁用对内容的选中、复制、光标。

### 效果图预览

<img src="casesfeature/verifycode/src/main/resources/base/media/verify_code.gif" width="300">

**使用说明**

1. 单击组件可弹出输入法
2. 在进行验证码输入时，无法对中间单个数字进行更改，无法选中输入内容，无光标

### 下载安装

1.模块oh-package.json5文件中引入依赖。

```typescript
"dependencies":
{
  "verifycode":
  "har包地址"
}
```

2.ets文件import列表视图组件。

```typescript
import { VerifyCodeViewComponent } from 'verifycode';
```

### 实现思路

1. 因为要禁用复制、选中等功能，这里使用了Text组件，而不是TextInput

    ```typescript
    ForEach(this.codeIndexArray, (item: number, index: number) => {
      Text(this.codeText[item])
        .verifyCodeUnitStyle()
    }, (item: number, index: number) => item.toString())
    ```

1. 绑定输入法，并默认显示键盘
    ```typescript
    this.inputController.attach(true, textConfig);
    ```

1. 订阅输入法插入、删除事件，从而获取输入内容
     ```typescript
     this.inputController.on("insertText", (text: string) => {
       if (this.codeText.length >= this.verifyCodeLength) {
         return;
       }
         this.codeText += text;
     })
     this.inputController.on("deleteLeft", (length: number) => {
       this.codeText = this.codeText.substring(0, this.codeText.length - 1);
     })
     ```
1. 由于这里使用的是Text组件，而非TextInput组件，因此需要每次点击目标的组件的时候都重新绑定，并设置键盘的显示，而不能直接使用showSoftKeyboard
   ```typescript
   Flex(){
      //...
   }.onClick(() => {
      this.attachAndListen();
   })
   ```
1. 当组件失焦的时候解除监听
   ```typescript
    off(): void {
      this.inputController.off("insertText");
      this.inputController.off("deleteLeft");
      this.isListen = false;
      logger.info('detached');
    }
   
    Flex(){
      //...
    }
    .onBlur(() => {
      this.off();
    })
   ```

### 高性能知识点

**不涉及**

### 工程结构&模块类型

   ```
   verifycode                                       // har类型
   |---constants
   |   |---VerifyCodeConstants.ets                  // 常量
   |---view
   |   |---VerifyCodeView.ets                       // 视图层-验证码组件
   ```

### 参考资料

1. [Text](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-js/js-components-basic-text.md)
2. [inputMethod](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-ime-kit/js-apis-inputmethod.md)

### 约束于限制

1.本示例仅支持标准系统上运行。

2.本示例已适配API version 12版本SDK。

3.本示例需要使用DevEco Studio 5.0.0 Release及以上版本才可编译运行

### 下载

如需单独下载本工程，执行如下命令：

  ```
  git init
  git config core.sparsecheckout true
  echo /code/UI/VerifyCode/ > .git/info/sparse-checkout
  git remote add origin https://gitee.com/openharmony/applications_app_samples.git
  git pull origin master
  ```

