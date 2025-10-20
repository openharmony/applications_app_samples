# com.samples.Prop

## 介绍

本示例展示了如何创建自定义弹窗，设置自定义弹窗的背景颜色、圆角半径、对齐方式、边框颜色、边框样式等功能。

## 效果预览

| 首页                                              | CustomDialogController_CAPI页面                                  |OpenCustomDialog_CAPI页面                                              |
| ----------------------------------------------------- |--------------------------------------------------------------| ------------------------------------------------------- |
| <img src="./screenshots/PageOne.png" width="300"/> | <img src="./screenshots/PageTwo.png" width="300"/> | <img src="./screenshots/PageThree.png" width="300"/> |

## 使用说明

1. 安装编译生成的hap包，并打开应用；
2. 首页面会出现页面列表，点击此列表项进入对应页面示例界面；

## 工程目录

```
ArkTsProp2Samlpe
entry
└── src
    │       ├── main
    │       │   ├── ets
    │       │   │   ├── entryability
    │       │   │   │   └── EntryAbility.ets
    │       │   │   ├── entrybackupability
    │       │   │   │   └── EntryBackupAbility.ets
    │       │   │   └── pages
    │       │   │       ├── Index.ets
    │       │   │       ├── PageEight.ets
    │       │   │       ├── PageEighteen.ets
    │       │   │       ├── PageEleven.ets
    │       │   │       ├── PageFifteen.ets
    │       │   │       ├── PageFive.ets
    │       │   │       ├── PageFour.ets
    │       │   │       ├── PageFourteen.ets
    │       │   │       ├── PageNine.ets
    │       │   │       ├── PageOne.ets
    │       │   │       ├── PageSeven.ets
    │       │   │       ├── PageSeventeen.ets
    │       │   │       ├── PageSix.ets
    │       │   │       ├── PageSixteen.ets
    │       │   │       ├── PageTen.ets
    │       │   │       ├── PageThirteen.ets
    │       │   │       ├── PageThree.ets
    │       │   │       ├── PageTow.ets
    │       │   │       └── PageTwelve.ets
    │       │   ├── module.json5
    │       │   └── resources
    │       │       ├── base
    │       │       │   ├── element
    │       │       │   │   ├── color.json
    │       │       │   │   ├── float.json
    │       │       │   │   └── string.json
    │       │       │   ├── media
    │       │       │   │   ├── background.png
    │       │       │   │   ├── foreground.png
    │       │       │   │   ├── layered_image.json
    │       │       │   │   └── startIcon.png
    │       │       │   └── profile
    │       │       │       ├── backup_config.json
    │       │       │       ├── main_pages.json
    │       │       │       └── router_map.json
    │       │       ├── dark
    │       │       │   └── element
    │       │       │       └── color.json
    │       │       └── rawfile
    │       ├── mock
    │       │   └── mock-config.json5
    │       ├── ohosTest
    │       │   ├── ets
    │       │   │   └── test
    │       │   │       ├── Ability.test.ets
    │       │   │       └── List.test.ets
    │       │   └── module.json5
    │       └── test
    │           ├── List.test.ets
    │           └── LocalUnit.test.ets

```

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568等;

2. 本示例支持API20版本SDK，版本号：6.0.0.36;

3. 本示例已支持使DevEco Studio 6.0.0.848 (构建版本：6.0.0.848，构建 2025年10月17日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/Prop > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
