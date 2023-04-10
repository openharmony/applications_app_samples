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

import { ListModel } from '../thermal/data/ListModel';
import { ThermalModel } from '../thermal/data/ThermalModel';
import systemTime from '@ohos.systemDateTime';

@Extend(Text) function fancy() {
  .height(72)
  .fontSize(16)
  .fontWeight(500)
};

@Entry
@Component
struct ThermalPage {
  @State table: ListModel[] = [
    new ListModel('Thermal level', ThermalModel.getLevel),
    new ListModel('Callback level', null),
    new ListModel('Last callback time', null)
  ];

  onPageShow() {
    this.initThermal();
  }

  onPageHide() {
    ThermalModel.unregisterThermalLevelCallback();
  }

  initThermal() {
    const INDEX_0 = 0;
    const INDEX_1 = 1;
    ThermalModel.registerThermalLevelCallback((level: Number) => {
      this.table[INDEX_0] = new ListModel('Thermal level', null, ThermalModel.getLevel());
      this.table[INDEX_1] = new ListModel('Callback level', null, ThermalModel.getStrLevel(level));
      this.getCurrentTime();
    });
  }

  timestampToTime(timestamp: any) {
    let date = new Date(timestamp);
    let Y = date.getFullYear() + '-';
    let M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';
    let D = (date.getDate() < 10 ? ('0' + date.getDate()) : date.getDate()) + ' ';
    let h = (date.getHours() < 10 ? ('0' + date.getHours()) : date.getHours()) + ':';
    let m = (date.getMinutes() < 10 ? ('0' + date.getMinutes()) : date.getMinutes()) + ':';
    let s = date.getSeconds() < 10 ? ('0' + date.getSeconds()) : date.getSeconds();
    return (Y + M + D + h + m + s) + '';
  }

  getCurrentTime() {
    const INDEX_2 = 2;
    systemTime.getCurrentTime().then((date: any) => {
      this.table[INDEX_2] = new ListModel('Last callback time', null, this.timestampToTime(date));
    });
  }

  @Builder NavigationTitle() {
    Column() {
      Text('Thermal')
        .fontColor('#182431')
        .fontSize(30)
        .lineHeight(41)
        .fontWeight(700)
    }.alignItems(HorizontalAlign.Start)
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
                    .width('40%')
                    .textAlign(TextAlign.Start)
                    .padding({ left: 30 })
                    .fancy()
                }

                Column() {
                  Text(item.getValue())
                    .width('60%')
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
