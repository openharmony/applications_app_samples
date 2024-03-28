# Navigation动态路由

### 介绍

本项目提供动态路由的验证，运用了WrapperBuilder的自定义函数打包能力，以及动态路由的跨模块文件引用的能力，解除了har包和hap包的依赖关系，实现了
即使hap包不引用har包，依然能跳转到har包中的页面的能力
目前还不支持动态import变量表达式和跨模块相对路径的文件，所以代码中使用switch作为替代，若后续版本支持，会出相应的补丁
由于环境的差异，不建议下载后直接编译，应先当创建项目，参考示例代码进行编写

### 效果预览
![image](images/Index.jpg)
![image](images/HarA.jpg)
![image](images/HarB.jpg)

使用说明

1. 主页会提供一个NavIndex的导航页，点击按钮会跳转到不同的来自har包的页面

2. 每个har包的页面也存在跳转到别的页面的按钮

### 工程目录

```
.
├── entry // 主页面
│   ├── pages
│   │   ├── Index.ets
│   ├── entryability
│   │   ├── EntryAbility.ets
├── harA
│   ├── pages
│   │   ├── page1.ets
│   │   ├── page2.ets
│   │   ├── page3.ets
│   ├── entryability
│   │   ├── EntryAbility.ets
├── harB 
│   ├── pages
│   │   ├── page1.ets
│   │   ├── page2.ets
│   │   ├── page3.ets
│   ├── entryability
│   │   ├── EntryAbility.ets
├── RouterModule
│   ├── utils
│   │   ├── RouterModule.ets
│   ├── entryability
│   │   ├── EntryAbility.ets 
.
```

### 具体实现

1.创建hapA harA harB

2.创建路由框架RouterModule，使用map存储hap包的路由和har包的页面信息

3.在RouterModule中封装get和set方法，并对外开放，允许外部模块引用和调用

4.创建push方法，允许传入一串url，并对其进行解析，通过拆解出路由名称从map中获取到路由栈，并将目标页面压栈

5.在hap和har包中引入RouterModule，将hap包的路由栈和har包的页面信息通过开放的set方法存入RouterModule

### 相关权限

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。

2. 本示例需要使用DevEco Studio 版本号(Build Version: 4.1.1.500, built on January 21, 2024)及以上版本才可编译运行。

3. 本示例为Stage模型，支持API11版本SDK，SDK版本号(4.1.6.3以上),镜像版本号(4.1.6.3以上)。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/ApplicationModels/DynamicRouter > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
