# 使用硬件熵源生成安全随机数(ArkTS)

### 介绍

随机数主要用于临时会话密钥生成和非对称加密算法密钥生成等场景。在加解密场景中，安全随机数生成器需要具备随机性、不可预测性和不可重现性。 使用更安全的熵源，对随机数而言，就意味着 “结果难以被猜测或复现”，是 “真随机性” 的量化体现。

当前硬件熵源随机数的实现依赖HUKS。对于具备安全环境（如TEE、安全芯片）的系统或设备，开启硬件熵源后，将通过HUKS从TEE中获取安全随机数（其熵源为硬件熵源）作为算法库生成随机数的熵源。由于安全环境依赖硬件支持，在开源仓中仅为模拟实现，需OEM厂商适配。
当前硬件熵源的实现是通过调用HUKS的相关接口完成的。

本示例主要展示了安全随机数生成(await、同步)场景 。该工程中展示的代码详细描述可查如下链接。

- [使用硬件熵源生成安全随机数(ArkTS)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-generate-random-number-hardware.md)

### 效果预览

| 首页效果图                                                   | 执行结果图                                                    |
|---------------------------------------------------------|----------------------------------------------------------|
| <img src="./screenshots/home.png" style="zoom: 50%;" /> | <img src="./screenshots/async.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述执行结果图效果，点击不同按钮可以跳转到不同功能页面，点击跳转页面中按钮可以执行对应操作，并更新文本内容。
3. 运行测试用例SecureRandomNumberGeneration.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 安全随机数生成示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets 
 │   │       ├── SecureRandomNumberGeneration.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API22版本SDK，版本号：6.1.0.17，镜像版本号：OpenHarmony_6.1.0.17。

3.本示例需要使用DevEco Studio 6.0.1 Release(6.0.1.251)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/Security/CryptoArchitectureKit/SecureRandomNumberGeneration > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````