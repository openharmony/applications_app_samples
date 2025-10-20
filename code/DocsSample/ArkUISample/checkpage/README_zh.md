## 介绍

本示例展示了inspector检查页面布局。

### 效果预览

| ![image](screenshot/img2.png) |

| ![image](screenshot/img3.png) |

| ![image](screenshot/img4.png) |

## 使用说明
1. 安装编译生成的hap包，并打开应用；
2. 进入首页，可选择不同模块页面；
3. 点击按钮(UIContext查询组件树和组件信息能力)进入ComponentPage，通过点击不同的按钮来触发不同的事件，具体结果在log中查看；
4. 点击按钮(布局回调的基本用法)进入ComponentPage1,通过点击不同的按钮来触发不同的事件，具体结果在log中查看；
5. 点击按钮(组件标识属性的扩展能力)进入ImagePage，显示图片；

## 工程目录

```
TextAreaEventNDK
entry/src/main/ets/
└── pages
    └── ComponentPage.ets (显示UIContext查询组件树和组件信息能力页面)
    └── ComponentPage1.ets (显示布局回调页面)
    └── ImagePage.ets (显示组件标识属性的扩展能力页面)
    └── Index.ets (显示主页面)
└── resources
    ├── base
    │   ├── element
    │   │   ├── color.json
    │   │   ├── float.json
    │   │   └── string.json
    │   └── media
```

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 不支持动效类组件的控件树实时刷新功能。

2. 支持获取组件的属性和样式，但不支持获取controller和Builder对象。

3. 不支持获取组件的方法、事件。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/checkpage > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```