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
 

﻿@Entry
@Component
struct Dialog {
  @StorageProp('isOpenUwb') isOpenUwb: boolean = true;
  @State textValue: string = '';
  @StorageLink('lowCharge') lowCharge: number = -1;
  @StorageLink('isCharge') isCharge: boolean = false;
  onPageHide(): void {
    this.lowCharge = -1;
  }

  build() {
    Column() {
      if (this.lowCharge === -1) {
        Row({ space: '24lpx' }) {
          Toggle({ type: ToggleType.Switch, isOn: this.isOpenUwb })
            .width('65lpx')
            .height('36lpx')
            .focusable(false)
          Text(this.isOpenUwb ? '指向功能已开启' : '指向功能已关闭')
            .fontColor('#dbffffff')
            .fontSize('36lpx')
            .width('252lpx')
            .height('42lpx')
            .focusable(false)
        }
        .focusable(false)
        .width('437lpx')
        .height('90lpx')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .padding({
          top: '24lpx',
          bottom: '24lpx',
          right: '48lpx',
          left: '48lpx'
        })
        .borderRadius('24lpx')
        .backgroundColor('#3C3C3C')
      } else {
          Row({ space: '27lpx' }) {
            Image($r('app.media.low_charge'))
              .width('36lpx')
              .height('36lpx')
            Text(`遥控器电量低于${this.lowCharge}%,` + '请及时充电')
              .fontColor('#dbffffff')
              .fontSize('36lpx')
              .width('539lpx')
              .height('42lpx')
              .focusable(false)
          }
          .focusable(false)
          .width('695lpx')
          .height('90lpx')
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .padding({
            top: '24lpx',
            bottom: '24lpx',
            right: '48lpx',
            left: '48lpx'
          })
          .borderRadius('24lpx')
          .backgroundColor('#3C3C3C')
        }
      }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .margin({ top: '64lpx' })
    .backgroundColor(Color.Transparent)
    .width('100%')
    .height('100%')
  }
}