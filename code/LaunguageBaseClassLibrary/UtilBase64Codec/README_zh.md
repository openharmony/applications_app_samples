# Base64编解码

### 介绍
本示例使用[@ohos.util](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-util.md)接口展示了Base64编码及解码功能。

### 效果预览
|首页|
|--------|
|![](screenshots/device/main.png)|

使用说明：
1. 点击**编码**按钮，将会把字符串转换为ASCII码，然后对ASCII码进行编码，并在文本框输出编码后的结果;
2. 点击**解码**按钮，将会把编码后输出的结果作为解码器的入参，解码后得到ASCII码数组，然后将ASCII码数组转换为字符串在文本框输出。

### 工程目录
```
entry/src/main/ets/
|---pages
|   |---Index.ets                          // 首页
|---utils                                  
|   |---Logger.ts                          // 日志工具
```

### 具体实现
+ 编解码的功能在Index中，源码参考[Index.ets](entry/src/main/ets/pages/Index.ets)，编解码流程如下:
    + 把需要转换的字符串先使用charCodeAt转换成对应的Unicode编码格式;
    + 初始化util的Base64Helper;
    + 使用字符串编码得到的数组将字符串转化为Uint8Array格式;
    + 使用encodeToStringSync将Uint8Array格式文件转化为可以输出的字符串;
    + 使用decodeSync将编码内容转化为Unicode编码格式的数组;
    + 使用fromCharCode将Unicode格式编码转化为字符串。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持在标准系统上运行;
2. 本示例已适配API10版本SDK，版本号：4.0.5.1;
3. 本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

### 下载
如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/LaunguageBaseClassLibrary/UtilBase64Codec/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```