# 扫描仪应用demo

### 介绍
本示例使用@ohos.scan接口拉起[打印框架](https://gitee.com/openharmony/print_print_fwk)下的扫描服务，由扫描服务加载扫描仪驱动，完成扫描仪的发现与连接、获取扫描仪选项、设置扫描仪参数、启动扫描仪、获取扫描图片进度、取消扫描的功能。

### 界面预览
![扫描demo](sceenshots/scandemo.png)

使用说明

1.本示例是测试扫描框架接口能力，扫描仪驱动基于sane-backends开发。

2.首页的按钮点击后调用扫描框架对应的接口。

3.启动扫描后，可以通过图片预览按钮查看扫描出的图片。

### 工程目录

```
ScanNapiInterfaceDemo
├── AppScope                                    
│   └── app.json5                               //APP信息配置文件
├── entry/src/main                              
│   ├── ets
│   │   ├── entryability
│   │   ├── scan                          		
│   │   │   ├── log.ts                        	//日志库
│   │   │   ├── scan.ts                       	//扫描接口库
│   │   ├── pages
│   │   │   ├── Index.ets                       //应用界面            
│   └── module.json5
│
├── entry/src/ohosTest       					//测试用例
│   ├── ets/test
│   │   ├── Ability.test.ets                        
│   │   ├── List.test.ets  							//测试列表
│   │   ├── Scan.test.ets                           //扫描接口测试
│   └── module.json5
```

### 具体实现

* 该示例分为7个接口：
  * 搜索扫描仪
    * 使用@ohos.scan中API 12接口scan.on注册发现回调函数，然后调用@ohos.scan中的scan.getScannerList接口开启扫描仪搜索，当发现到扫描仪时，会通过on注册的回调函数，将扫描仪设备信息回调到应用。
    * 源码链接：[scan.ts](./entry/src/main/ets/scan/scan.ts)
    * 参考接口：[@ohos.scan]
    
  * 连接扫描仪
    
    * 使用@ohos.scan中API 12接口scan.openScanner连接扫描仪，传入的参数是扫描仪的id。
    * 源码链接：[scan.ts](./entry/src/main/ets/scan/scan.ts)
    * 参考接口：[@ohos.scan]
    
  * 启动扫描仪
    
    * 使用@ohos.scan中API 12接口scan.startScan启动扫描任务，传入的参数是扫描仪的id和是否开启批处理扫描模式。
    
    * 源码链接，[scan.ts](./entry/src/main/ets/scan/scan.ts)
    
    * 参考接口：[@ohos.scan]

  * 取消扫描
    
    * 使用@ohos.scan中API 12接口scan.cancelScan取消扫描任务，传入的参数是扫描仪的id。
    
    * 源码链接，[scan.ts](./entry/src/main/ets/scan/scan.ts)
    
    * 参考接口：[@ohos.scan]
  * 查询扫描进度
    
    * 使用@ohos.scan中API 12接口scan.getScanProgress查询扫描仪扫描图片的进度。
    
    * 源码链接，[scan.ts](./entry/src/main/ets/scan/scan.ts)
    
    * 参考接口：@ohos.scan
  * 获取扫描仪选项
    
    * 使用@ohos.scan中API 12接口scan.getScanOption查询扫描仪有多少个选项，getScanOptionDesc获取每一个选项具体的描述信息。
    
    * 源码链接，[scan.ts](./entry/src/main/ets/scan/scan.ts)
    
    * 参考接口：@ohos.scan
  * 设置扫描仪参数
    
    * 使用@ohos.scan中API 12接口scan.setScanOption设置某一台扫描仪的选项参数。
    
    * 源码链接，[scan.ts](./entry/src/main/ets/scan/scan.ts)
    
    * 参考接口：@ohos.scan

### 相关权限

[ohos.permission.PRINT]

[ohos.permission.MANAGE_PRINT_JOB]

### 依赖

1.API12版本SDK的@ohos.scan接口。

2.基于[sane-backends](https://gitee.com/openharmony-sig/third_party_backends)开发的扫描仪驱动以及对应厂商型号的扫描仪设备。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API12版本SDK，SDK版本号(API Version 12),镜像版本号(5.0)

3.本示例需要使用DevEco Studio 版本号(5.0.3.403)及以上版本才可编译运行。

4.运行本示例需要连接扫描仪，下载扫描仪对应的驱动。

###  下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Print/ScanNapiInterfaceDemo/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull
```

### 构建说明

1.需要基于[sane-backends](https://gitee.com/openharmony-sig/third_party_backends/)完成扫描仪驱动的开发。

2.扫描仪驱动通过驱动安装应用安装到指定路径。

3.本工程通过Build Hap(s)/APP(s)完成编译构建，然后安装。

4.通过局域网或有线等物理方式连接扫描仪后即可通过主界面的相关按钮实现扫描仪的发现和连接等功能。