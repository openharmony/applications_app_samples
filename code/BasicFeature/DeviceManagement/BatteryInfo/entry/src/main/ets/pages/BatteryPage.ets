/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { ListModel } from '../battery/data/ListModel';
import { BatteryModel } from '../battery/data/BatteryModel';

@Extend(Text) function fancy() {
  .height(72)
  .fontSize(16)
  .fontWeight(500)
}

@Entry
@Component
struct BatteryPage {
  @State table: ListModel[] = [
    new ListModel('Battery SOC', BatteryModel.batterySOC),
    new ListModel('Charging Status', BatteryModel.chargingStatus),
    new ListModel('Health Status', BatteryModel.healthStatus),
    new ListModel('Plugged Type', BatteryModel.pluggedType),
    new ListModel('Voltage', BatteryModel.voltage),
    new ListModel('Technology', BatteryModel.technology),
    new ListModel('Battery Temperature', BatteryModel.batteryTemperature),
    new ListModel('Battery Present', BatteryModel.isBatteryPresent),
    new ListModel('Battery Capacity Level', BatteryModel.batteryCapacityLevel)
  ];

  @Builder NavigationTitle() {
    Column() {
      Text('About Battery')
        .fontColor('#182431')
        .fontSize(30)
        .lineHeight(41)
        .fontWeight(700)
    }
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      Navigation() {
        List({ space: 5 }) {
          ForEach(this.table, (item) => {
            ListItem() {
              Row() {
                Column() {
                  Text(item.title)
                    .width('30%')
                    .textAlign(TextAlign.Start)
                    .padding({ left: 30 })
                    .fancy()
                }

                Column() {
                  Text(item.getValue())
                    .width('70%')
                    .textAlign(TextAlign.End)
                    .padding({ right: 30 })
                    .fancy()
                }
              }
              .backgroundColor(Color.White)
              .borderRadius(24)
              .margin({ left: 12, right: 12 })
            }
          })
        }
        .height('100%')
        .width('100%')
      }
      .title({ builder: this.NavigationTitle, height: 56 })
      .titleMode(NavigationTitleMode.Mini)
      .hideTitleBar(false)
      .hideToolBar(true)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}
