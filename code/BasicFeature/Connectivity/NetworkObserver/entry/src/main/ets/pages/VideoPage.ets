/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { NetEventData, NetUtils, NetworkEventName } from '../utils/NetUtils';
import { emitter } from '@kit.BasicServicesKit';
import { connection } from '@kit.NetworkKit';
import { logger } from '../utils/Logger';
import { Prompt } from '@kit.ArkUI';
import { SettingPage } from './SettingPage';

// 将自动播放设置通过PersistentStorage进行本地持久化存储，避免每次打开应用都需要重新设置
PersistentStorage.persistProp('cellular_auto_play', false);
PersistentStorage.persistProp('wifi_auto_play', false);
const innerEvent: emitter.InnerEvent = {
  // 左上角返回按钮点击事件传递的eventId
  eventId: 6
};

/**
 * 实现步骤：
 * 1. 通过@kit.NetworkKit接口监听网络状态
 * 2. 添加Video组件，播放在线视频
 * 3. 添加自动播放设置toggle，可以在网络状态变化时修改视频播放状态
 */

@Component
export struct VideoPage {
  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack();
  // 视频控制器
  controller: VideoController = new VideoController();
  // WI-FI自动播放
  @StorageLink('wifi_auto_play') wifiAutoPlay: boolean = false;
  // 3G/4G/5G自动播放
  @StorageLink('cellular_auto_play') cellularAutoPlay: boolean = false;
  // 在线视频地址
  private videoUrl: string = 'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4';
  // 注册路由返回函数，案例插件不触发
  popRouter: () => void = () => {
  };
  // 使用流量播放弹窗
  networkDialog: CustomDialogController | null = new CustomDialogController({
    builder: NetworkDialogComponent({
      title: $r('app.string.network_status_observer_cellular_dialog_title'),
      message: $r('app.string.network_status_observer_cellular_dialog_message'),
      cancel: () => {
        // 用户点击取消，则停止播放
        this.pausePlay();
        this.networkDialog?.close();
      },
      confirm: () => {
        // 用户点击确认，则继续播放
        this.startPlay();
        this.networkDialog?.close();
      }
    }),
    cornerRadius: $r('app.integer.network_status_observer_cellular_dialog_message_radius'),
    alignment: DialogAlignment.Center
  })

  // 网络监听回调
  netObserver(data: emitter.EventData) {
    if (!data.data) {
      logger.info('netObserver data.data is undefined.');
      return;
    }
    logger.info('network observe result : ' + NetUtils.getInstance().parseResult(data));
    let netEventData: NetEventData = data.data! as NetEventData;
    let eventName: NetworkEventName = netEventData.eventName ?? -1;
    switch (eventName) {
      case NetworkEventName.NetAvailable:
        // WI-FI是可用状态
        if (netEventData.netType === connection.NetBearType.BEARER_WIFI) {
          // 如果开了WI-FI自动播放，则继续播放
          if (this.wifiAutoPlay) {
            this.startPlay();
          }
        }
        break;
      case NetworkEventName.NetBlock:
        break;
      case NetworkEventName.NetLost:
        // 如果WI-FI网络丢失，则通过wifiInterrupt方法判断是否需要继续播放
        if (netEventData.netType === connection.NetBearType.BEARER_WIFI) {
          this.wifiInterrupt();
        }
        break;
      case NetworkEventName.NetUnavailable:
        // 如果WI-FI不可用，则通过wifiInterrupt方法判断是否需要继续播放
        if (netEventData.netType === connection.NetBearType.BEARER_WIFI) {
          this.wifiInterrupt();
        }
        break;
      case NetworkEventName.WeakNet:
        // 如果是弱网环境，则弹出提示，实际应用开发中可以通过该结果自动实现分辨率自动切换
        if (netEventData.status) {
          Prompt.showToast({
            message: getContext().resourceManager.getStringSync($r('app.string.network_status_observer_weak'))
          });
        }
        break;
      default:
        logger.debug('当前网络状态：' + eventName);
        break;
    }
  }

  /**
   * WI-FI中断时的操作
   * 如果开启了3G/4G/5G自动播放，则继续播放，并且提示正在使用流量播放
   * 如果关闭了3G/4G/5G自动播放，则弹出弹窗，让用户选择是否继续使用流量播放
   */
  wifiInterrupt() {
    if (NetUtils.getInstance().getNetworkConnectionType()[0] === connection.NetBearType.BEARER_CELLULAR) {
      if (this.cellularAutoPlay) {
        Prompt.showToast({
          message: getContext().resourceManager.getStringSync($r('app.string.network_status_observer_user_cellular'))
        });
      } else {
        this.pausePlay();
        this.networkDialog?.open();
      }
    }
  }

  /**
   * 是否自动播放
   * @returns true：自动播放，false，不自动播放
   */
  autoPlay(): boolean {
    let autoPlay: boolean = false;
    // 如果网络是可用的
    if (NetUtils.getInstance().judgeHasNet()) {
      // 获取当前连接的网络类型
      let currentNetType: connection.NetBearType = NetUtils.getInstance().getNetworkConnectionType()[0];
      switch (currentNetType) {
        case connection.NetBearType.BEARER_CELLULAR: // 蜂窝网络
          // 如果开启了3G/4G/5G自动播放，则设置autoPlay为true
          if (this.cellularAutoPlay) {
            autoPlay = true;
          }
          break;
        case connection.NetBearType.BEARER_WIFI: // WIFI网络
        case connection.NetBearType.BEARER_ETHERNET: // 以太网网络（模拟器）
          // 如果设置了WI-FI自动播放，则设置autoPlay为true
          if (this.wifiAutoPlay) {
            autoPlay = true;
          }
          break;
      }
    }
    return autoPlay;
  }

  // 开始播放
  startPlay() {
    if (this.controller) {
      this.controller.start();
    }
  }

  // 暂停播放
  pausePlay() {
    if (this.controller) {
      this.controller.pause();
    }
  }

  onPageShow(): void {
    if (this.autoPlay()) {
      this.startPlay();
    }
  }

  onPageHide(): void {
    this.pausePlay();
  }

  aboutToAppear(): void {
    // 通过emitter接受网络监听结果
    emitter.on(NetUtils.getInstance().getEmitterEvent(), (data: emitter.EventData) => {
      if (data) {
        this.netObserver(data);
      } else {
        logger.info('aboutToAppear emitter on error, data is undefined.');
      }
    });
    // 开启蜂窝网络和WI-FI网络状态的监听
    NetUtils.getInstance()
      .startNetObserve(connection.NetBearType.BEARER_CELLULAR, connection.NetBearType.BEARER_WIFI);
    // 收到eventId为6的事件后执行回调函数
    emitter.on(innerEvent, () => {
      // 在案例主页时，返回瀑布流
      if (this.navPathStack.size() === 0) {
        this.popRouter();
      }
    });
  }

  aboutToDisappear(): void {
    // 当页面销毁时，停止所有网络监听
    NetUtils.getInstance().stopAllNetObserve();
    if (this.controller) {
      this.controller.stop();
    }
    // 销毁事件监听
    emitter.off(innerEvent.eventId);
  }

  @Builder
  buildMap(name: string, param: ESObject) {
    if (name === 'SettingPage') {
      NavDestination() {
        SettingPage()
      }.hideTitleBar(true)
    }
  }

  build() {
    Navigation(this.navPathStack) {
      Column() {
        Row() {
          Text($r('app.string.network_status_observer_auto_play_setting'))
        }.justifyContent(FlexAlign.End)
        .width($r('app.string.network_status_observer_percent_100'))
        .onClick(() => {
          this.navPathStack.pushPath({ name: 'SettingPage' });
        })

        Video({
          src: this.videoUrl,
          controller: this.controller
        })
          .height($r('app.integer.network_status_observer_video_height'))
          .width($r('app.string.network_status_observer_percent_100'))
          .autoPlay(this.autoPlay())
          .id('id_network_status_observer_video')
      }
      .height($r('app.string.network_status_observer_percent_100'))
      .width($r('app.string.network_status_observer_percent_100'))
    }.hideTitleBar(true)
    .hideToolBar(true)
    .navDestination(this.buildMap)

  }
}

// 流量播放提示框
@CustomDialog
export struct NetworkDialogComponent {
  controller?: CustomDialogController;
  // 标题
  title: ResourceStr = '';
  // 提示信息
  message: ResourceStr = '';
  // 取消事件
  cancel: () => void = () => {
  };
  // 确认事件
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Text(this.title)
        .fontSize($r('app.integer.network_status_observer_cellular_dialog_title_font_size'))
        .fontWeight(FontWeight.Bold)
      Text(this.message)
        .padding({
          left: $r('app.integer.network_status_observer_cellular_dialog_message_padding'),
          right: $r('app.integer.network_status_observer_cellular_dialog_message_padding')
        })
        .margin({
          top: $r('app.integer.network_status_observer_cellular_dialog_message_margin_top')
        })
      Line().height(1)
        .backgroundColor(Color.Blue)
      Row() {
        Button($r('app.string.network_status_observer_dialog_cancel'))
          .layoutWeight(1)
          .borderRadius({
            bottomRight: 0,
            topLeft: 0,
            topRight: 0,
            bottomLeft: $r('app.integer.network_status_observer_cellular_dialog_message_radius')
          })
          .type(ButtonType.Normal)
          .backgroundColor(Color.White)
          .fontColor(Color.Grey)
          .onClick(() => {
            this.cancel();
          })
        Line().width(1)
          .backgroundColor(Color.Blue)
        Button($r('app.string.network_status_observer_dialog_confirm'))
          .layoutWeight(1)
          .borderRadius({
            bottomRight: $r('app.integer.network_status_observer_cellular_dialog_message_radius'),
            topLeft: 0,
            topRight: 0,
            bottomLeft: 0
          })
          .type(ButtonType.Normal)
          .backgroundColor(Color.White)
          .fontColor(Color.Blue)
          .onClick(() => {
            this.confirm();
          })
      }.margin({
        top: $r('app.integer.network_status_observer_cellular_dialog_button_margin_top')
      })
    }
    .padding({
      top: $r('app.integer.network_status_observer_cellular_dialog_padding_top')
    })
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.White)
  }
}