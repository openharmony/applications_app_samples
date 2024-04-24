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

import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Want from '@ohos.app.ability.Want';
import { logger } from '../util/Logger';

export interface ListItemModel {
  text: Resource,
  callback?: () => void
}

const TAG: string = 'UIExtensionAbility';
let storage: LocalStorage = LocalStorage.getShared();

@Entry(storage)
@Component
struct Ext {
  private session: (UIExtensionContentSession | undefined) = storage.get<UIExtensionContentSession>('session');
  private want: (Want | undefined) = storage.get<Want>('want');
  @State list: ListItemModel[] = [
    {
      text: $r('app.string.extStartAbilityAsCaller'),
      callback: () => {
        if (this.session === undefined) {
          logger.error(`${TAG} session undefined`);
          return;
        }
        if (this.want === undefined) {
          logger.error(`${TAG} want undefined`);
          return;
        }
        let localWant: Want = this.want;
        localWant.bundleName = 'com.samples.abilityFeatureSystem';
        localWant.moduleName = 'entry';
        localWant.abilityName = 'NewAbility';
        // 使用启动方的Caller身份信息启动新Ability
        this.session.startAbilityAsCaller(localWant, (err, data) => {
          logger.info(`${TAG} startAbilityAsCaller error:${JSON.stringify(err)}  data:${JSON.stringify(data)}`);
        })
      },
    }
  ];

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .size({ width: 20, height: 18 })
            .margin({ right: 18 })
            .onClick(() => {
              if (this.session === undefined) {
                return;
              }
              this.session.sendData({ back: true });
            })
          Text($r('app.string.UIExtAbility_label'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }.height(56)
        .padding({ left: 24, right: 24 })
        .width('100%')
      }

      Column() {
        List({ space: 0, initialIndex: 0 }) {
          ForEach(this.list, (item: ListItemModel, index: number) => {
            ListItemGroup() {
              ListItem() {
                Column() {
                  Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                    Text(item.text) {
                    }.fontSize(16)
                    .fontColor($r('sys.color.ohos_id_color_toolbar_sub_bg_dark'))
                    .height(48)
                  }.width('100%')
                }
              }
              .align(Alignment.Start)
              .onClick(item.callback)
              .width('100%')
              .padding({ left: 12, right: 12 })
            }
            .padding({ top: 4, bottom: 4 })
            .borderRadius(24)
            .width('100%')
            .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .margin({ top: 10, bottom: 10 })
          })
        }
        .scrollBar(BarState.Off)
        .listDirection(Axis.Vertical) // 排列方向
        .friction(0.6)
        .width('100%')
        .height('100%')
        .padding({ left: 12, right: 12 })
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
      }.width('100%')
    }.width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_text_field_sub_bg'))
    .padding({ top: 36, bottom: 106 })
  }
}