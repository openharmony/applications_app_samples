# Web页面预加载优化图片滑动白块

## 介绍

本示例展示Web展示HTML页面图片列表时，在使用懒加载图片的情况下，使用预加载避免滑动过程中图片因未及时加载而出现白块情况，提高使用体验。

## 效果预览图

| 正例 | 反例                                                            |
|---|---------------------------------------------------------------|
|![img](screenshot/web-sliding-white-block-optimization-2.gif)| ![img](screenshot/web-sliding-white-block-optimization-1.gif) |


## 使用说明

运行后向下滑动页面，观察列表图片在滑动过程中是否出现白块现象。

## 原理说明

使用预加载时，HTML页面图片按需加载，当页面在滑动过程中由于拓展了视口高度，预先加载未出现的图片，避免滑动白块问题，提高使用体验。[文章链接](../../../../docs/performance/performance-web-import.md/#预加载优化滑动白块)

## 工程目录

```
entry/src/main/ets
|---pages
|   |---Index.ets                // 首页
|   |---IndexNegavite.ets        // 反例
|   |---IndexPositive.ets        // 正例
```

## 具体实现

1. <img>标签预设白块图片，并设置data-src为真实图片地址。
    ```html
    <img src="https://gitee.com/openharmony/applications_app_samples/raw/master/code/Solutions/IM/Chat/products/phone/entry/src/main/resources/base/media/icon_me_photo.png" data-src="https://gitee.com/harmonyos-cases/cases/raw/master/test/performance/web_slide_white_block/WebSlideWhiteBlockPositive/entry/src/main/resources/base/media/img1.jpg" alt="Image 1">
    ```
2. 在标签进入可视窗口时将date-src地址赋给src，实现图片懒加载，并拓展视口高度，实现预加载。
   ```html
   <script>
      // html结构与上方常规案例相同
      // 可视区域作为根元素，向下扩展50%的margin长度
      const options = {root:document,rootMargin:'0% 0% 100% 0%'};
      // 创建一个IntersectionObserver实例
      const observer = new IntersectionObserver(function(entries,observer){
        entries.forEach(function(entry){
          // 检查图片是否进入可视窗口
          if(entry.isIntersecting){
            const image = entry.target;
            // 将数据源的src赋值给img的src
            image.src = image.dataset.src;
            // 停止观察该图片
            observer.unobserve(image);
            }
        })
      },options);
      
      document.querySelectorAll('img').forEach(img => {observer.observe(img)});
   </script>
   ```

## 相关权限

网络权限： ohos.permission.INTERNET

## 依赖

不涉及

## 约束与限制

1. 本示例仅支持标准系统上运行;

2. 本示例已适配API20版本SDK，SDK版本号(API Version 20 Release),镜像版本号(5.1.0 Release)。

3. 本示例需要使用DevEco Studio 版本号(5.1.0 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Performance/WebSlideWhiteBlock/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```