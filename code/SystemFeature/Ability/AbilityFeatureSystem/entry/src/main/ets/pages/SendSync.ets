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

import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import { logger } from '../util/Logger';

interface GroupModel {
  title?: string;
  list: ListItemModel[];
}

export interface ListItemModel {
  text: Resource,
  rType?: string,
  callback?: () => void,
}

const TAG: string = 'HomeAbility';

@Entry
@Component
struct SendSync {
  private myProxy: (UIExtensionProxy | null) = null;
  @State list: GroupModel[] = [
    {
      title: '1',
      list: [
        {
          text: $r('app.string.sendSyncData'),
          rType: '',
          callback: () => {
            if (this.myProxy === null) {
              logger.error(`${TAG} myProxy null`);
              return;
            }
            let params: Record<string, string> = { 'key': `data from ${TAG}` };
            let result = this.myProxy.sendSync(params);
            prompt.showToast({ message: (`${TAG} onReceive ${result['key']}`), duration: 3000, bottom: 150 });
          }
        }
      ]
    },
  ]

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .size({ width: 20, height: 18 })
            .margin({ right: 18 })
            .onClick(() => {
              router.back({
                url: 'pages/Index'
              });
            })
          Text($r('app.string.SendSyncUIExtAbility_label'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }.height(56)
        .padding({ left: 24, right: 24 })
        .width('100%')
      }

      Column() {
        List({ space: 0, initialIndex: 0 }) {
          ForEach(this.list, (groupItem: GroupModel, groupIndex: number) => {
            ListItemGroup() {
              ForEach(groupItem.list, (item: ListItemModel, index: number) => {
                ListItem() {
                  Column() {
                    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                      Text(item.text)
                        .fontSize(16)
                        .height(48)
                        .fontColor($r('sys.color.ohos_id_color_toolbar_sub_bg_dark'))
                    }.width('100%')
                  }.width('100%')
                }
                .id('sendSync')
                .align(Alignment.Start)
                .onClick(item.callback)
                .width('100%')
                .padding({ left: 12, right: 12 })
              })
            }
            .padding({ top: 4, bottom: 4 })
            .borderRadius(24)
            .width('100%')
            .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .margin({ top: 10, bottom: 10 })
          })
          ListItemGroup() {
            ListItem() {
              UIExtensionComponent({
                bundleName: 'com.samples.abilityFeatureSystem',
                abilityName: 'SendSyncUIExtAbility',
                parameters: {
                  'ability.want.params.uiExtensionType': 'sys/commonUI',
                }
              }).size({ width: '100%', height: '90%' })
                .onRemoteReady((pro: UIExtensionProxy) => {
                  logger.info(`${TAG} onRemoteReady：`);
                  this.myProxy = pro;
                })
            }
          }
          .borderRadius(24)
          .width('100%')
          .margin({ top: 10, bottom: 10 })
        }
        .scrollBar(BarState.Off)
        .listDirection(Axis.Vertical)
        .friction(0.6)
        .edgeEffect(EdgeEffect.Spring)
        .padding({ left: 12, right: 12 })
        .width('100%')
        .height('100%')
      }.width('100%')
    }.width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_text_field_sub_bg'))
    .padding({ top: 36, bottom: 106 })
  }
}