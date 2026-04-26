# TVDemandPlayer 测试报告

## 设备

| 设备 | 识别名称 |
|---|---|
| rk3568 | `rk3568` |
| 大屏 | `TV` |

## 应用功能模块清单

| 模块名称 | 功能描述 | 设备支持 |
|---|---|---|
| 网络视频播放 (HttpVideoList) | 在线媒体资源展示与播放功能 | rk3568、大屏 |
| 本地视频播放 (LocalVideoList) | 本地媒体文件浏览与播放功能 | rk3568、大屏 |
| 文件管理器拉起播放 | 通过文件管理器直接播放指定视频文件 | rk3568、大屏 |
| DLNA播放 (DlnaPlayer) | DLNA设备发现与媒体投屏功能 | rk3568、大屏 |
| 分布式流转 (DistributedStreaming) | 跨设备视频流转功能 | rk3568、大屏 |

## 核心功能模块

| 模块名称 | 包名 | 功能描述 |
|---|---|---|
| 主应用模块 | com.ohos.tvdemandplayer | 视频播放器核心功能 |
| 播放器服务 | com.ohos.tvdemandplayer.avplayer | 视频播放控制服务 |
| DLNA服务 | com.ohos.tvdemandplayer.dlnaservice | DLNA设备连接与媒体控制 |
| 分布式服务 | com.ohos.tvdemandplayer.distributed | 跨设备流转功能服务 |
| 文件管理服务 | com.ohos.tvdemandplayer.filemanager | 本地文件浏览与管理 |

## 验证点

| 项目 | rk3568  | 大屏 |
|---|---|---|
| 网络视频播放 | 功能正常  | 功能正常 |
| 本地视频播放 | 功能正常  | 功能正常 |
| 文件管理器拉起 | 功能正常  | 功能正常 |
| DLNA播放功能 | 功能正常  | 功能正常 |
| 分布式流转 | 功能正常  | 功能正常 |