/*
 * Copyright (c) 2023 Fujian Newland Auto-ID Tech.Co.,Ltd.
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
import BatteryInfoUtil from '../util/BatteryInfoUtil'
import { logger } from '@ohos/common/src/main/ets/util/Logger';
import { getString } from '@ohos/common/src/main/ets/util/ResourceUtil';

/**
 * 电池信息组件
 * 用于显示电池基础信息，包括：电池剩余电量、充电状态、健康状态、充电器类型、电压、技术型号、温度、电量等级、充电类型
 */

const TAG: string = '[Sample_BatteryView]'

@Component
struct BatteryInfoView {
  private mName: string | Resource = '';
  private mIsLine?: boolean = true
  private mViewID?: string = ''
  @Prop mValue: string

  @Builder CustomDivider() {
    Divider()
      .strokeWidth('1px')
      .color($r('sys.color.ohos_id_color_subheading_separator'))
      .margin({
        bottom: px2vp(8)
      })
  }

  build() {
    Column() {
      Row() {
        Text(this.mName)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontWeight(FontWeight.Regular)
          .width('30%')
          .maxLines(2)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .id(this.mViewID)
        Blank()
        Text(this.mValue)
          .fontColor($r('app.color.battery_info_value_text'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
          .width('40%')
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .height(47)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      if (this.mIsLine) {
        Blank()
        this.CustomDivider()
      }
    }
    .width('100%')
    .height(48)
  }
}

@Preview
@Component
export struct BatteryView {
  @StorageLink('BatteryPresent') isBatteryPresent: boolean = true // 是否支持电池或电池是否在位
  @StorageLink('BatterySOC') mBatterySOC: string = '0' // 电池电量
  @StorageLink('ChargingStatus') mChargingStatus: string = '' // 电池充电状态
  @StorageLink('HealthStatus') mHealthStatus: string = '' // 电池健康状态
  @StorageLink('PluggedType') mPluggedType: string = '' // 电池充电器类型
  @StorageLink('Voltage') mVoltage: string = '' // 电池电压
  @StorageLink('Technology') mTechnology: string = '' // 电池技术型号
  @StorageLink('Temperature') mTemperature: string = '' // 电池温度
  @StorageLink('CapacityLevel') mCapacityLevel: string = '' // 电池电量等级
  private BATTERY_VOLTAGE_SYMBOL: string = ''
  private BATTERY_TEMPERATURE_SYMBOL: string = ''

  async aboutToAppear() {
    logger.info(`${TAG} aboutToAppear`)
    this.BATTERY_VOLTAGE_SYMBOL = getString($r('app.string.battery_voltage_symbol'))
    this.BATTERY_TEMPERATURE_SYMBOL = getString($r('app.string.battery_temperature_symbol'))
    // 注册电池电量数据变化监听器
    BatteryInfoUtil.registerEventBatteryChanged()
    // 获取电池相关信息
    this.getInfo()
  }

  private getInfo() {
    logger.info(`${TAG} aboutToAppear isBatteryPresent: ${this.isBatteryPresent}`)
    // 初始化电量信息
    if (this.isBatteryPresent) {
      BatteryInfoUtil.getBatterySOC()
      BatteryInfoUtil.getChargingStatus()
      BatteryInfoUtil.getHealthStatus()
      BatteryInfoUtil.getPluggedType()
      BatteryInfoUtil.getVoltage()
      BatteryInfoUtil.getTechnology()
      BatteryInfoUtil.getBatteryTemperature()
      BatteryInfoUtil.getBatteryCapacityLevel()
    }
  }

  aboutToDisappear() {
    logger.info(`${TAG} aboutToDisappear`)
    BatteryInfoUtil.unregisterEventBatteryChanged()
  }

  build() {
    Scroll() {
      Column() {
        Stack({
          alignContent: Alignment.Center
        }) {
          DataPanel({
            values: [this.isBatteryPresent ? Number(this.mBatterySOC) : 0],
            max: 100,
            type: DataPanelType.Circle }
          )
            .id('batterySOC')
            .width(280)
            .height(280)


          Column() {
            Row() {
              Text(this.isBatteryPresent ? this.mBatterySOC : $r('app.string.battery_soc_0'))
                .fontColor($r('app.color.battery_soc_text'))
                .fontSize($r('sys.float.ohos_id_text_size_headline3'))
              Text($r('app.string.battery_soc_100'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .fontSize($r('sys.float.ohos_id_text_size_headline8'))
                .padding({
                  bottom: px2vp(15)
                })
            }
            .alignItems(VerticalAlign.Bottom)
            .justifyContent(FlexAlign.Center)
            .margin({
              bottom: px2vp(4)
            })

            if (this.isBatteryPresent) {
              Text(this.mHealthStatus)
                .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                .fontSize($r('sys.float.ohos_id_text_size_body1'))
            }
          }
        }
        .width('100%')
        .height(px2vp(390))

        if (this.isBatteryPresent) {
          Column({
            space: px2vp(8)
          }) {
            BatteryInfoView({
              mName: $r('app.string.battery_charging_status'),
              mValue: this.mChargingStatus.toString(),
              mViewID: 'batteryChargingStatus'
            })

            BatteryInfoView({
              mName: $r('app.string.battery_plugged_type'),
              mValue: this.mPluggedType.toString(),
              mViewID: 'batteryPluggedType'
            })

            BatteryInfoView({
              mName: $r('app.string.battery_voltage'),
              mValue: `${this.mVoltage} ${this.BATTERY_VOLTAGE_SYMBOL}`,
              mViewID: 'batteryVoltage'
            })

            BatteryInfoView({
              mName: $r('app.string.battery_technology'),
              mValue: this.mTechnology.toString(),
              mViewID: 'batteryTechnology'
            })

            BatteryInfoView({
              mName: $r('app.string.battery_temperature'),
              mValue: `${this.mTemperature} ${this.BATTERY_TEMPERATURE_SYMBOL}`,
              mViewID: 'batteryTemperature'
            })

            BatteryInfoView({
              mName: $r('app.string.battery_capacity_level'),
              mIsLine: false,
              mValue: this.mCapacityLevel.toString(),
              mViewID: 'batteryCapacityLevel'
            })
          }
          .padding(px2vp(24))
          .margin(px2vp(24))
          .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
          .border({
            radius: $r('sys.float.ohos_id_corner_radius_default_l')
          })
          .id('batteryContext')
        } else {
          Row({ space: 10 }) {
            Image($r('app.media.icon_search_fail'))
              .width(px2vp(32))
              .height(px2vp(32))
              .objectFit(ImageFit.Fill)
              .id('batteryFailIcon')
            Text($r('app.string.battery_information_error'))
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .id('batteryErrorText')
          }
          .height('40%')
          .id('batterySearchFail')
        }
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}