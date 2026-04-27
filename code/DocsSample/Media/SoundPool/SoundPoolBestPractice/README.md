# SoundPoolArkTS

## 介绍

本示例展示了SoundPool的建议使用方式。

## 效果预览

| 预览                                      | 
| -------------------------------------------- | 
<img src="./image.png" width="300" />


## 使用说明
1. 编译hap包并安装编译生成的hap包，并打开应用；
2. 点击创建soundpool，点击加载所有音频，之后可以操作各个音频；

## 工程目录

```
SoundPoolArkTS
entry/src/main/ets/
└── pages
    └── Index.ets (播放界面)
entry/src/main/resources/
├── base
│   ├── element
│   │   ├── color.json
│   │   ├── float.json
│   │   └── string.json
│   └── media
│
└── rawfile
    └── demo.mp3 (音频资源)
entry/src/ohosTest/ets/
└── test
    ├── Ability.test.ets (UI测试代码)
    └── List.test.ets (测试套件列表)
```

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API20版本SDK，版本号：6.0.0.47;
   
3. 本示例已支持使DevEvo Build Version: 6.0.2.650, built on March 27, 2026编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Media/SoundPool/SoundPoolBestPractice/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```