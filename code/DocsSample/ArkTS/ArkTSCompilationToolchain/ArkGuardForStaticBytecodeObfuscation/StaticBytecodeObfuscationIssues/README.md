# ArkGuard字节码混淆常见问题（ArkTS-Sta）

 	 ## 介绍
 	 
 	 本文主要介绍ArkTS-Sta的字节码混淆，如何排查功能异常，常规配置问题处理，编译报错处理及运行异常处理。
 	 
 	 ## 效果预览
 	 
 	 不涉及界面
 	 
 	 ## 使用说明
 	 
 	 1. 根据需要，配置混淆选项和keep选项，编译后，在build目录下，查看混淆后的效果即可。
 	 
 	 ## 工程目录
 	 
 	 ```
 	 entry/src/main/ets/
 	 └── pages
 	     └── Index.ets // 初始页面
 	     └── Test2.ets // 文件名示例
         └── abcdcba.ets // 文件名示例
         └── StaticDemo.ets //主要测试示例
         └── testFile.ets // 文件名示例
         └── TestFile2.ets // 文件测试类
         └── Annotations.ets // 注解代码示例
         └── BaseClass.ets //基类代码示例
 	 entry/src/ohosTest/
 	 └── ets
 	     └── test
 	         └── Ability.test.ets // UI自动化用例
 	 ```
 	 
 	 ## 具体实现
 	 
 	 * keep实现
 	     * 方法名，属性名，文件名等keep的实现，源码参考：[StaticDemo.ets](./entry/src/main/ets/pages/StaticDemo.ets)
         * 调用从./Annotations.ets动态导入注解，源码参考：[MainPage.ets](./entry/src/main/ets/pages/MainPage.ets)
 	 
 	 ## 依赖
 	 
 	 无。
 	 
 	 ## 相关权限
 	 
 	 无。
 	 
 	 ## 约束与限制
 	 
 	 1. 本示例支持标准系统上运行，支持设备：RK3568。
 	 
 	 2. 本示例支持API23版本的SDK，版本号：6.1.0.25。
 	 
 	 3. 本示例已支持使用Build Version: 6.0.1.251, built on November 22, 2025。
 	 
 	 4. 高等级APL特殊签名说明：无。
 	 
 	 ## 下载
 	 
 	 如需单独下载本工程，执行如下命令：
 	 
 	 ```git
 	 git init
 	 git config core.sparsecheckout true
 	 echo code/DocsSample/ArkTS/ArkTSCompilationToolchain / ArkGuardForStaticBytecodeObfuscation / StaticBytecodeObfuscationIssues/ > .git/info/sparse-checkout
 	 git remote add origin OpenHarmony/applications_app_samples
 	 git pull origin master
 	 ```