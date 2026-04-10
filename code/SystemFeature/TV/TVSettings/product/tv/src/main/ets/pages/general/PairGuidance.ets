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

import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { LengthMetrics, router } from '@kit.ArkUI';
import { Duration } from '../../common/constants/Duration';

const TAG='PAIRGUIDANCE'

@Entry
@Component
struct PairGuidance {
  @State imageUrl: string = Ratio.resName('icon_remoteController')
  @State des: string = '蓝牙遥控器'
  @State currentController: string = ''
  @StorageProp('isConPoint') isPoint: boolean = false //是否是指向遥控器

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  //封装成组件
  @Builder
  pairGuidance(controller: string, firstText: string, secondText: string, thirdText: string = '') {
    Text(controller + '遥控器配对指导')
      .fontSize(lpx(64))
      .fontWeight(700)
      .fontColor('#dbffffff')
      .margin({ bottom: lpx(54) })
      .letterSpacing(lpx(5))
    Text(firstText)
      .fontSize(lpx(36))
      .fontWeight(500)
      .fontColor('#dbffffff')
      .maxLines(3)
      .margin({ bottom: lpx(32.5) })
      .letterSpacing(lpx(5))
      .lineSpacing(LengthMetrics.lpx(10))
    Text(secondText)
      .fontSize(lpx(36))
      .fontWeight(500)
      .fontColor('#dbffffff')
      .maxLines(3)
      .letterSpacing(lpx(5))
      .lineSpacing(LengthMetrics.lpx(10))
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        Column() {
          if (this.isPoint) {
            Text('指向遥控器配对指导')
              .fontSize(lpx(64))
              .fontWeight(700)
              .fontColor('#dbffffff')
              .margin({ bottom: lpx(54) })
              .letterSpacing(lpx(4))
            Text('-- 配对' + '\n' +
              '1、插入指向遥控器接收器' + '\n' +
              '2、同时按住菜单键和home键5s,直到屏幕出现已连接提示' + '\n')
              .fontSize(lpx(36))
              .fontWeight(500)
              .fontColor('#dbffffff')
              .letterSpacing(lpx(4))
              .lineSpacing(LengthMetrics.lpx(5))
            Text('-- 断开连接(谨慎操作)' + '\n' +
              '1、已连接遥控器' + '\n' +
              '2、同时按住菜单键和设置键5s,直到遥控器无法操作界面' + '\n')
              .fontSize(lpx(36))
              .fontWeight(500)
              .fontColor('#dbffffff')
              .letterSpacing(lpx(4))
              .lineSpacing(LengthMetrics.lpx(5))
            Text('-- 更换接收器或遥控器后重连' + '\n' +
              '1、插入指向遥控器接收器' + '\n' +
              '2、接收器进行删除配对' + '\n' +
              '3、打开接收器蓝牙扫描开关' + '\n' +
              '4、同时按住菜单键和home键5s,直到屏幕出现已连接提示' + '\n')
              .fontSize(lpx(36))
              .fontWeight(500)
              .fontColor('#dbffffff')
              .letterSpacing(lpx(4))
              .lineSpacing(LengthMetrics.lpx(5))
            Text('-- 提示' + '\n' +
              '1、具体配对流程可到指向遥控器连接页面完成' + '\n' +
              '2、若配对不成功，可移除指向遥控接收器后再次插入重试')
              .fontSize(lpx(36))
              .fontWeight(500)
              .fontColor('#dbffffff')
              .letterSpacing(lpx(4))
              .lineSpacing(LengthMetrics.lpx(5))
          } else {
            this.pairGuidance('蓝牙',
              '-- 配对' + '\n' +
                '配对新的蓝牙遥控器，到蓝牙界面，打开蓝牙开关，同时点击菜单键和home键，直到搜索出对应的蓝牙遥控器；点击对应设备列表，进行配对' +
                '\n',
              '-- 删除配对' + '\n' +
                '若已配对蓝牙遥控器，到蓝牙界面，点击已配对的蓝牙遥控器，取消配对' + '\n')
          }
        }
        .width(ConfigData.WH_52_100)
        .height(ConfigData.WH_100_100)
        .padding({ left: lpx(84), right: lpx(84) })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)

        if (this.isPoint) {
          SettingItemDesLayout({ imageUrl: this.imageUrl, des: '指向遥控器' })
            .width(ConfigData.WH_48_100)
            .height(ConfigData.WH_100_100)
        } else {
          SettingItemDesLayout({ imageUrl: this.imageUrl, des: '蓝牙遥控器' })
            .width(ConfigData.WH_48_100)
            .height(ConfigData.WH_100_100)
        }
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
