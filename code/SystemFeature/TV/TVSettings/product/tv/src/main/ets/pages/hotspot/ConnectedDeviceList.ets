/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { Ratio } from '../../common/Ratio';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { KeyCode } from '../../common/constants/KeyCode';
import lpx from '../../common/Lpx';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { Duration } from '../../common/constants/Duration';
import wifiManager from '@ohos.wifiManager';
import hotspotUtils from '../hotspot/utils/HotspotUtils';
import { EventUtil } from '../../common/EventUtil';

const WIFI_ENTRY_COMPONENT_HEIGHT: number = 98;
const LIST_ITEM_PADDING: number = 6;
const LIST_ITEM_BORDER: number = 2;
const LIST_SPACE: number = 12;
const SINGLE_LIST_ITEM_HEIGHT = WIFI_ENTRY_COMPONENT_HEIGHT + LIST_ITEM_PADDING * 2 + LIST_ITEM_BORDER * 2;
const SCREEN_HEIGHT: number = px2lpx(globalThis.screenHeight);
const BUFFER_HEIGHT: number = 150;

@Entry
@Component
struct ConnectedDeviceList {
  @State numOfConnectedDevice:number = 0
  //获取已连接至本设备热点的设备信息
  @State connectedDeviceInfo:wifiManager.StationInfo[] = []

  //获取被本设备拉入黑名单的设备信息
  @State model: SettingItemTvModel = new SettingItemTvModel()
  @State imageUrl: string = Ratio.resName('app.media.icon_hostpot')
  @State des: string = '个人热点'
  @State focusIndex: number = 0
  scroller: Scroller = new Scroller();

  private pageTranState: boolean = false; //判断是进场动效还是出场动效
  @State isEnabledHotspot:boolean = true
  recvHotspotStaJoinFunc = (result:wifiManager.StationInfo) => {
    try {
      this.connectedDeviceInfo = wifiManager.getStations()
      let number = this.connectedDeviceInfo.length
      console.log(
        'Connect Device List: connectedDeviceInfo nember connectedDeviceInfo',
        this.connectedDeviceInfo,
        number
      );
    } catch (error) {
      console.log('recvHotspotStaJoinFunc failed:' + JSON.stringify(error));
    }
  }

  getFocusFun(index:number) {
    focusControl.requestFocus(index.toString())
  }

  // 通过focusIndex调整列表滚动条
  adjustOffsetY() {
    // 计算列表高度比例和实际高度
    const visibleHeightProportion: number =
      parseInt(this.connectedDeviceInfo ? ConfigData.WH_45_100 : ConfigData.WH_58_100) / 100
    const visibleHeight = SCREEN_HEIGHT * visibleHeightProportion
    // 获取当前滚动位置和可见区域上下边界
    const curYOffset = vp2px(this.scroller.currentOffset()?.yOffset || 0)
    const enableAreaTop = curYOffset + BUFFER_HEIGHT
    const enableAreaBottom = curYOffset + visibleHeight - BUFFER_HEIGHT

    // 计算当前焦点项的上下边界
    const curFocusItemTop = this.focusIndex * SINGLE_LIST_ITEM_HEIGHT + this.focusIndex * LIST_SPACE
    const curFocusItemBottom = curFocusItemTop + SINGLE_LIST_ITEM_HEIGHT

    // 检查焦点项是否在可见区域内
    const isInEnableArea = curFocusItemTop >= enableAreaTop && curFocusItemBottom <= enableAreaBottom

    // 如果已经在可见区域内，无需调整
    if (isInEnableArea) {
      return;
    }
    //计算需要滚动的位置并执行滚动
    const newYOffset: string = curFocusItemTop < enableAreaTop ? (curFocusItemTop - BUFFER_HEIGHT) + 'lpx' :
      (curFocusItemBottom - visibleHeight + BUFFER_HEIGHT) + 'lpx'

    this.scroller.scrollTo({
      xOffset: 0,
      yOffset: newYOffset,
      animation: true
    })
  }

  pageTransition() {
    if (this.pageTranState) {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
    } else {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
    }
  }

  aboutToAppear() {
    wifiManager.on('hotspotStaJoin', this.recvHotspotStaJoinFunc.bind(this));
    wifiManager.on('hotspotStaLeave', this.recvHotspotStaJoinFunc.bind(this));
    console.log('进入ConnectedDeviceList abouttoappear',)
  }

  onPageShow() {
    // 接管焦点通过onKeyEvent控制
    console.log('进入ConnectedDeviceList 页面')
    try {
      if(hotspotUtils.GetConnectDeviceList()){
        this.connectedDeviceInfo = hotspotUtils.GetConnectDeviceList()
      }else {
        this.connectedDeviceInfo = []
      }
    }catch (e) {
      console.log('hotspotUtils.GetConnectDeviceList() error',JSON.stringify(e))
    }
  }

  onPageHide() {
    this.pageTranState = false
  }

  aboutToDisappear(): void {
    wifiManager.off('hotspotStaJoin', this.recvHotspotStaJoinFunc.bind(this));
    wifiManager.off('hotspotStaLeave', this.recvHotspotStaJoinFunc.bind(this));
  }

  build() {
    Row() {
      Column() {
        Text('已连接设备')
          .width(lpx(868))
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(500)
          .textAlign(TextAlign.Start)
          .alignSelf(ItemAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
        Column() {
          //已连接本设备热点列表
          if (this.isEnabledHotspot && this.connectedDeviceInfo.length > 0) {
            List({ space: lpx(12), scroller: this.scroller }) {
              ForEach(this.connectedDeviceInfo, (item: wifiManager.StationInfo, index) => {
                ListItem() {
                  ConnectedDevicesComponent({
                    settingTitle: item.name,
                    settingArrow: '',
                    isFocus: this.focusIndex === index,
                  })
                }
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.Transparent
                    })
                  }
                })
                .borderRadius(lpx(18))
                .focusable(true)
                .padding(lpx(LIST_ITEM_PADDING))
                .border({
                  width: lpx(LIST_ITEM_BORDER),
                  color: this.focusIndex === index ? Color.White : Color.Transparent,
                  style: BorderStyle.Solid,
                  radius: '24lpx'
                })
                .onHover(() => {
                  this.numOfConnectedDevice = index
                  this.focusIndex = index;
                })
                .onTouch((event) => {
                  if (!EventUtil.isTouchEvent(event)) {
                    return;
                  }
                })
              });
            }
            .scrollBar(BarState.Off)
            .width(ConfigData.WH_100_100)
            .margin({
              bottom: lpx(178),
            })
            .height( ConfigData.WH_58_100)
          }
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
        .width(ConfigData.WH_100_100)
      }
      .alignItems(HorizontalAlign.Start)
      .width(ConfigData.WH_50_100)
      .height(ConfigData.WH_100_100)
      .margin({ left: lpx(84) })
      SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
        .width(ConfigData.WH_50_100)
        .height(ConfigData.WH_100_100)
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
    .backgroundColor('rgb(24, 24, 26)')
    .onKeyEvent((event: KeyEvent) => {
      if (event.type === KeyType.Down) {
        if (this.focusIndex >= 0) {
          // 已连接本机热点列表的按键事件
          if (event.keyCode === KeyCode.KEY_DPAD_UP && this.focusIndex != 0) {
            // 向上键
            this.focusIndex--
            this.adjustOffsetY()
          } else if (event.keyCode === KeyCode.KEY_DPAD_DOWN) {
            // 向下键
            if (this.focusIndex < this.connectedDeviceInfo.length - 1) {
              this.focusIndex++
              this.adjustOffsetY()
            }
          } else if (event.keyCode === KeyCode.KEY_ENTER) {
            event.stopPropagation()
          }
        }
      }
    })
  }
}

@Component
struct ConnectedDevicesComponent {
  @Prop settingTitle: string; // 已连接设备名称
  @Prop settingArrow: string; // 图标
  @Prop isFocus: boolean = false
  @State model: SettingItemTvModel = new SettingItemTvModel()
  build() {
    Row() {
      Column() {
        Text(this.settingTitle)
          .fontSize(lpx(36))
          .fontColor(this.isFocus ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
          .fontWeight(FontWeight.Medium)
          .focusable(true)
      }
      .margin({ left: lpx(24) })
      .alignItems(HorizontalAlign.Start)

      Column() {
        Image($r(Ratio.resName('icon_arrow_right')))
          .fillColor(this.isFocus ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.86)')
          .width(lpx(24))
          .height(lpx(48))
          .opacity(this.isFocus ? 1 : 0.25)
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .margin({ right: lpx(24) })
          .visibility(this.model.arrowVisible)
      }
      .margin({ right: lpx(20) })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width(this.isFocus ? lpx(846) : lpx(840))
    .backgroundColor(this.isFocus ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
    .height(lpx(WIFI_ENTRY_COMPONENT_HEIGHT))
    .borderRadius(lpx(18))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}
