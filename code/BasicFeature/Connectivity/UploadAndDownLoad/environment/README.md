## 上传下载应用服务器使用说明

### HFS下载地址：

https://nchc.dl.sourceforge.net/project/hfs/HFS/2.3m/hfs.exe

### 服务器配置：

1.测试设备和电脑连接同一个局域网。

2.电脑打开下载好的`hfs.exe`可执行文件。

3.hfs客户端配置：

| 电脑端创建一个文件夹，hfs客户端中根节点右键点击bind root to real-folder，绑定到创建的文件夹 | 根节点右键点击Properties | 点击upload选项，勾选anyone后，点击ok |
| ------------------------------------------------------------ | ------------------------ | ------------------------------------ |
| ![bind](src/bind.png)                                        | ![bind](src/prop.png)    | ![bind](src/permission.png)          |

4.**手机端打开应用后**，查看打开客户端的url，修改HFS地址中的url为hfs客户端的url。

|          获取url          |          修改url          |
| :-----------------------: | :-----------------------: |
| ![copy](src/copy_url.png) | ![copy](src/past_url.png) |

5、按照顺序操作1-4步骤后，即可测试上传下载任务。

## 相关依赖

[上传下载](..)应用依赖本服务。