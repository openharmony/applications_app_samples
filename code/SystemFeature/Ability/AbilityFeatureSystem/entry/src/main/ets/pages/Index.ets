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

import appManager from '@ohos.app.ability.appManager';
import common from '@ohos.app.ability.common';
import prompt from '@ohos.promptAction';
import StartOptions from '@ohos.app.ability.StartOptions';
import router from '@ohos.router';
import Want from '@ohos.app.ability.Want';
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
struct Index {
  private context = getContext(this) as common.UIAbilityContext;
  private want: (Want | undefined) = AppStorage.get<Want>('want') || undefined;
  @State list: GroupModel[] = [
    {
      title: '1',
      list: [
        {
          text: $r('app.string.Query_App_Status'),
          rType: '',
          callback: () => {
            appManager.isApplicationRunning('com.samples.abilityFeatureSystem', (err, data) => {
              logger.info(`queryAppStatus err:${JSON.stringify(err)},data:${JSON.stringify(data)}`);
              if (data === true) {
                prompt.showToast({
                  message: $r('app.string.isRunning'), duration: 3000
                });
              } else {
                prompt.showToast({
                  message: $r('app.string.isNotRunning'), duration: 3000
                });
              }
            });
          }
        }
      ]
    },
    {
      title: '2',
      list: [
        {
          text: $r("app.string.Create_Modal_UIExtension"),
          rType: '',
          callback: () => {
            let pickerWant: Want = {
              bundleName: 'com.samples.abilityFeatureSystem',
              abilityName: 'NewUIExtAbility',
              moduleName: 'entry',
              type: 'sysPicker/share',
              parameters: {
                bundleName: 'com.samples.abilityFeatureSystem',
                'ability.want.params.uiExtensionType': 'sysPicker/share',
              }
            };
            try {
              this.context.requestModalUIExtension(pickerWant, (err) => {
                if (err.code) {
                  logger.info(`${TAG} requestModalUIExtension error:${JSON.stringify(err)}`);
                } else {
                  logger.info(`${TAG} requestModalUIExtension success`);
                }
              });
            } catch (err) {
              logger.info(`${TAG} requestModalUIExtension error:${JSON.stringify(err)}`);
            }
          }
        }
      ]
    },
    {
      title: '3',
      list: [
        {
          text: $r('app.string.sendSyncData'),
          rType: '',
          callback: () => {
            router.pushUrl({
              url: "pages/SendSync"
            });
          }
        }
      ]
    },
    {
      title: '4',
      list: [
        {
          text: $r('app.string.StartAbilityAsCaller'),
          rType: 'arrow',
          callback: () => {
            if (this.want === undefined) {
              return;
            }
            let localWant: Want = this.want;
            localWant.bundleName = 'com.samples.abilityFeatureSystem';
            localWant.abilityName = 'NewAbility';
            let startOptions: StartOptions = {
              displayId: 0,
            };
            // 使用启动方的Caller身份信息启动新Ability
            this.context.startAbilityAsCaller(localWant, startOptions, (err, data) => {
              logger.error(`${TAG} startAbilityAsCaller failed,
              err:${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
            })
          }
        }
      ]
    },
    {
      title: '5',
      list: [
        {
          text: $r('app.string.startUIExtensionAbility'),
          rType: 'arrow',
          callback: () => {
            router.pushUrl({
              url: "pages/Transit"
            });
          }
        }
      ]
    }
  ]

  build() {
    Column() {
      Text($r('app.string.system_BasicCharacter_Demo'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .padding({ left: 24, right: 24 })
        .height(56)
        .width('100%')

      Column() {
        List({ space: 0, initialIndex: 0 }) {
          ForEach(this.list, (groupItem: GroupModel, groupIndex: number) => {
            ListItemGroup() {
              ForEach(groupItem.list, (item: ListItemModel, index: number) => {
                ListItem() {
                  Column() {
                    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                      Text(item.text).fontSize(16)
                        .height(48)
                        .fontColor($r('sys.color.ohos_id_color_toolbar_sub_bg_dark'))

                      if (item.rType === 'arrow') {
                        Image($r('app.media.ic_arrow'))
                          .width(24).height(24).padding({ left: 12 })
                      }
                    }.width('100%')

                    if (groupItem.list.length > 1 && index < groupItem.list.length - 1) {
                      Divider().height(2).color($r('app.color.line_color')).opacity(0.05)
                    }
                  }.width('100%')
                }
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
        }
        .scrollBar(BarState.Off)
        .listDirection(Axis.Vertical) // 排列方向
        .friction(0.6)
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
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