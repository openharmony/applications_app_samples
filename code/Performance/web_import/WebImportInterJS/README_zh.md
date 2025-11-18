# 支持自定义协议的JavaScript生成字节码缓存（Code Cache）

### 介绍

支持自定义协议的JavaScript生成字节码缓存适用于在页面加载时存在自定义协议的JavaScript文件，支持其生成字节码缓存到本地，在页面非首次加载时节省编译时间。具体操作步骤如下：

1. 开发者首先需要在Web组件运行前，向Web组件注册自定义协议。

2. 其次需要拦截自定义协议的JavaScript，设置ResponseData和ResponseDataID，ResponseData为JavaScript内容，ResponseDataID用于区分JavaScript内容是否发生变更。若JavaScript内容变更，ResponseDataID需要一起变更。

### 效果预览
| 首页                         |
|----------------------------|
| ![](./screenshot/home.jpg) |

**使用说明**

点击桌面应用图标，启动应用。


### 工程目录
```
entry/src/main/ets/
|---pages
|   |---index.ets                           // 首页                                                       
```

### 具体实现

1. 将scheme对象属性isCodeCacheSupported设置为true，支持自定义协议的JavaScript生成字节码缓存。

    ```typescript
    scheme: webview.WebCustomScheme = { schemeName: 'scheme', isSupportCORS: true, isSupportFetch: true, isCodeCacheSupported: true };
    ```

2. 在Web组件运行前，向Web组件注册自定义协议。

    ```typescript
    aboutToAppear(): void {
      try {
        webview.WebviewController.customizeSchemes([this.scheme]);
      } catch (error) {
        const e: BusinessError = error as BusinessError;
        console.error(`ErrorCode: ${e.code}, Message: ${e.message}`);
      }
    }
    ```
   
3. 拦截自定义协议的JavaScript，设置ResponseData和ResponseDataID。ResponseData为JS内容，ResponseDataID用于区分JS内容是否发生变更。

    ```typescript
    // xxx.ets
    Web({
      // 需将'https://www.example.com/'替换为真是的包含自定义协议的JavaScript的Web页面地址。
      src: 'https://www.example.com/',
      controller: this.controller
    })
      .fileAccess(true)
      .javaScriptAccess(true)
      .onInterceptRequest(event => {
        const responseResource: WebResourceResponse = new WebResourceResponse();
        // 拦截页面请求。
        if (event?.request.getRequestUrl() === 'scheme1://www.example.com/test.js') {
          responseResource.setResponseHeader([
            {
              headerKey: 'ResponseDataId',
              // 格式：不超过13位的纯数字。JS识别码，JS有更新时必须更新该字段。
              headerValue: '0000000000001'
            }
          ]);
          responseResource.setResponseData(this.jsData2);
          responseResource.setResponseEncoding('utf-8');
          responseResource.setResponseMimeType('application/javascript');
          responseResource.setResponseCode(200);
          responseResource.setReasonMessage('OK');
          return responseResource;
        }
        return null;
      })
    ```

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行;

2. 本示例已适配API20版本SDK，SDK版本号(API Version 20 Release),镜像版本号(5.1.0 Release)。

3. 本示例需要使用DevEco Studio 版本号(5.1.0 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Performance/web_import/WebImportInterJS/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```