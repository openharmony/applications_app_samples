# Stage模型开发指导依赖

### 介绍

本示例是Stage模型开发指导的依赖Hap，用于展示Stage模型开发指导的隐式启动功能。

本示例参考[应用模型](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/application-models)。 

### 效果预览

|主页|
|--------------------------------|
|![newability](screenshots/newability.png)|

使用说明

安装该工程编译的HAP包

### 工程目录
```
entry/src/main/ets/
├── entryability
│   └── EntryAbility.ts													// 主Ability
└── pages
    └── Index.ets														// 应用主界面
```
### 具体实现

* 本示例是Stage模型开发指导依赖的Hap包。

* 需要在[module.json5配置文件](entry/src/main/module.json5)进行配置，具体配置如下：

  ```
  {
    "module": {
      ...
      "abilities": [
        {
          ...
          "skills": [
            {
              "entities": [
                "entity.system.home",
                "entity.system.browsable"
                ...
              ],
              "actions": [
                "action.system.home",
                "ohos.want.action.viewData"
                ...
              ],
              "uris": [
                {
                  "scheme": "https",
                  "host": "www.test.com",
                  "port": "8080",
                  // prefix matching
                  "pathStartWith": "query"
                },
                {
                  "scheme": "http",
                  ...
                }
                ...
              ]
            }
          ]
        }
      ]
    }
  }
  ```


### 相关权限

无。

### 依赖

详见[Stage模型开发指导](https://gitee.com/openharmony/applications_app_samples/blob/master/code/DocsSample/ApplicationModels/StageModelAbilityDevelop/README_zh.md)。

### 约束与限制

1.本示例仅支持标准系统上运行,支持设备:RK3568。

2.本示例为Stage模型，已适配API version 11版本SDK，版本号：4.1.3.1

3.本示例需要使用DevEco Studio 3.1.1 Release (Build Version: 3.1.0.501, built on June 20, 2023)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/ApplicationModels/ImplicitStartRely/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
