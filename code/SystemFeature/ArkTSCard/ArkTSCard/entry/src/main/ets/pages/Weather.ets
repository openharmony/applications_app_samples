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

import common from '@ohos.app.ability.common';
import Base from '@ohos.base';
import Logger from '../util/Logger';

@Entry
@Component
struct Weather {
  private context = getContext(this) as common.UIAbilityContext;
  @StorageLink('isStatic') isStatic: boolean = false;

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .size({ width: 20, height: 18 })
          .margin({ right: 12 })
          .onClick(() => {
            this.context.terminateSelf((err: Base.BusinessError) => {
              Logger.info(`terminateSelf err:${JSON.stringify(err)}`);
            })
          })
        Column() {
          Text($r('app.string.weather'))
            .fontSize(20)
            .fontWeight(700)
            .fontColor('#182431')
            .textAlign(TextAlign.Start)
          if (this.isStatic) {
            Text($r('app.string.static'))
              .margin({
                top: '4px'
              })
              .fontSize(14)
              .fontWeight(400)
              .opacity(0.6)
              .fontColor('#182431')
              .textAlign(TextAlign.Start)
          } else {
            Text($r('app.string.dynamic'))
              .margin({
                top: '4px'
              })
              .fontSize(14)
              .fontWeight(400)
              .opacity(0.6)
              .fontColor('#182431')
              .textAlign(TextAlign.Start)
          }
        }
        .alignItems(HorizontalAlign.Start)
      }.height(56)
      .padding({ left: 16, right: 16 })
      .width('100%')

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, alignContent: FlexAlign.Center }) {
        Column() {
          Image($r('app.media.pic_empty')).width('33%')
          Text($r('app.string.empty'))
            .fontSize(14)
        }
      }.width('100%')
      .height('90%')
    }
    .width('100%')
    .height('100%')
  }
}