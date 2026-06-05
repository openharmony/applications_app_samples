# 通用互联

## 介绍
通用互联APP用于openharmony生态设备控制，能够运行在HOS Next大屏和OHOS大屏设备上。

## 软件架构
软件架构说明

#### 代码目录

通用互联APP代码目录：

```
/ohos-connect-hap
├── product/tv               # 主entry模块目录
│   └── src
│       ├── main
│           ├── ets             # ets模块目录
│                ├── common             # 公共工具存放目录
│                ├── entryability       # EntryAbility
│                ├── pages              # 页面存放目录
│                ├── view               # 组件存放目录
│                ├── viewmodel          # 数据模块存放目录
│           ├── resources       # 资源配置文件存放目录
│               ├── base                # 默认语言场景，图片资源，字体大小，颜色资源内容存放目录
│               ├── en_US               # 英文语言场景资源内容存放目录
│               ├── zh_CN.element       # 中文语言场景资源内容存放目录
│           └── module.json5    # APP配置文件
│
│ ── common                     # 公共工具存放目录
│   └── src
│       ├── main
│           ├── ets             # ets模块目录
│                ├── constants          # 公共常量
│                ├── database           # 设备文件数据库
│                ├── inf                # 协议抽象接口
│                ├── utils              # 公共工具
│           ├── resources       # 资源配置文件存放目录
│               ├── base                # 默认语言场景，图片资源，字体大小，颜色资源内容存放目录
│               ├── en_US               # 英文语言场景资源内容存放目录
│               ├── zh_CN.element       # 中文语言场景资源内容存放目录
│           └── module.json5    # 模块配置文件
│       └── index.ets           # ets模块导出文件
│ 
│ ── connect_ble                # 蓝牙协议
│   └── src
│       ├── main
│           ├── ets             # ets模块目录
│                └── components         # 蓝牙协议相关实现文件
│           └── module.json5    # 模块配置文件
│       └── index.ets           # ets模块导出文件
│ 
│ ── connect_wifi               # wifi协议
│   └── src
│       ├── main
│           ├── ets             # ets模块目录
│                └── components         # wifi协议相关实现文件
│           └── module.json5    # 模块配置文件
│       └── index.ets           # ets模块导出文件
│ 
│ 
│ ── connect_iot                # iot-connect 协议
│   └── src
│       ├── main
│           ├── ets             # ets模块目录
│                └── components         # iot-connect 协议相关实现文件
│           └── module.json5    # 模块配置文件
│       └── index.ets           # ets模块导出文件
│ 
│ ── devicelibrary              # 设备库Tab
│   └── src
│       ├── main
│           ├── ets             # ets模块目录
│                ├── components                 # 模块内部文件
│                           ├── detail          # 详情页面
│                           ├── library         # 设备库页面
│                           └── search          # 搜索页面
│                ├── constanst                  # 公共常量  
│                └── viewmodel                  # viewmodel
│           └── module.json5    # 模块配置文件
│       └── index.ets           # ets模块导出文件
│ 
│ ── mine                       # Tab
│   └── src
│       ├── main
│           ├── ets             # ets模块目录
│                ├── components                 # components
│                ├── model                      # model
│                └── viewmodel                  # viewmodel
│           └── module.json5    # 模块配置文件
│       └── index.ets           # ets模块导出文件
│ 
│ ── nearbydevice              # 附近设备Tab
│   └── src
│       ├── main
│           ├── ets             # ets模块目录
│                ├── constanst                  # components
│                ├── model                      # model
│                ├── pages                      # 功能页面
│                ├── utils                      # 工具类
│                ├── view                       # view
│                └── viewmodel                  # viewmodel
│           └── module.json5    # 模块配置文件
│       └── index.ets           # ets模块导出文件
│ 
│ ── scenelibrary              # 附近设备Tab
│   └── src
│       ├── main
│           ├── ets             # ets模块目录
│                ├── common                     # common
│                ├── model                      # model
│                ├── pages                      # 功能页面
│                ├── res                        # res
│                ├── utils                      # 工具类
│                ├── view                       # view
│                └── viewmodel                  # viewmodel
│           └── module.json5    # 模块配置文件
│       └── index.ets           # ets模块导出文件
├── signature              # 证书文件目录
├── LICENSE                # 许可文件
```

## 安装教程

#### 环境配置

点击下文的连接地址下载 DevEco Studio 开发工具，参考安装指导进行默认安装。开发工具自带 SDK 工具包，无需下载 SDK 工具包。

1. 开发工具版本：DevEco Studio NEXT Developer Beta1(5.0.3.403)
2. SDK版本：API 12


#### 代码编译

1. 使用 DevEco Studio 打开上文 clone 的工程目录；
2. 连接设备，点击 DevEco Studio 工具拦右上角 Project Structure 选项，进入 SigningConfigs 菜单，登录华为开发者账号，使用自动签名；
3. 连接设备，点击 DevEco Studio 工具拦 run tv 按钮运行至设备；


## 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request
