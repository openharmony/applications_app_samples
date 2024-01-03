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
import prompt from '@ohos.promptAction';
import StartOptions from '@ohos.app.ability.StartOptions';
import Want from '@ohos.app.ability.Want';
import wantConstant from '@ohos.app.ability.wantConstant';
import CharacterOperation from '../characteroperation/CharacterOperation';
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
  private operation: CharacterOperation = new CharacterOperation(getContext(this));
  private isChinese: boolean = true;
  private isLight: boolean = true;
  @State isAnimation: boolean = false;
  @State list: GroupModel[] = [
    {
      title: '1',
      list: [
        {
          text: $r('app.string.Set_Chinese_language'),
          rType: 'right',
          callback: () => {
            this.isChinese = true;
            this.operation.setZHCNLanguage();
          }
        },
        {
          text: $r('app.string.Set_English_Language'),
          rType: 'right',
          callback: () => {
            this.isChinese = false;
            this.operation.setENUSLanguage();
          }
        }
      ]
    },
    {
      title: '2',
      list: [
        {
          text: $r('app.string.Set_Light_Mode'),
          rType: 'right',
          callback: () => {
            this.isLight = true;
            this.operation.setLightColorMode();
          }
        },
        {
          text: $r('app.string.Set_Dark_Mode'),
          rType: 'right',
          callback: () => {
            this.isLight = false;
            this.operation.setDarKColorMode();
          }
        },
      ]
    },
    {
      title: '3',
      list: [
        {
          text: $r('app.string.Implicit_Launch_Popup'),
          rType: 'arrow',
          callback: () => {
            this.context.startAbility({
              action: "ohos.want.action.viewData",
              type: "text/plain",
              parameters: {
                uri: "filePath"
              }
            }, (error, data) => {
              logger.info(`${TAG} startAbility end: ${JSON.stringify(error)}, ${JSON.stringify(data)}`);
            })
          }
        },
        {
          text: $r('app.string.Implicit_Launch_not_Popup'),
          rType: 'arrow',
          callback: () => {
            this.context.startAbility({
              action: "ohos.want.action.viewData",
              type: "text/plain",
              // 设置flags为FLAG_START_WITHOUT_TIPS 隐式启动未找到时不弹窗
              flags: wantConstant.Flags.FLAG_START_WITHOUT_TIPS,
              parameters: {
                uri: "filePath"
              }
            }, (error, data) => {
              logger.info(`${TAG} startAbility end ${JSON.stringify(error)}, ${JSON.stringify(data)}`);
              prompt.showToast({ message: $r('app.string.Implicit_Launch_not_Popup'), duration: 3000 });
            })
          }
        }
      ]
    },
    {
      title: '5',
      list: [
        {
          text: $r('app.string.CreateStorageData'),
          rType: 'arrow',
          callback: this.operation.createStorageData
        },
        {
          text: $r('app.string.CheckStorageData'),
          rType: 'arrow',
          callback: this.operation.checkStorageData
        },
        {
          text: $r('app.string.ClearStorageData'),
          rType: 'arrow',
          callback: this.operation.clearStorageData
        }
      ]
    },
    {
      title: '8',
      list: [
        {
          text: $r("app.string.setStartOptionsPage"),
          rType: '',
          callback: () => {
            if (this.want === undefined) {
              logger.error(`${TAG} want undefined`);
              return;
            }
            let localWant: Want = this.want;
            localWant.bundleName = 'com.samples.abilityFeature';
            localWant.abilityName = 'NewAbility';
            let startOptions: StartOptions = {
              displayId: 0,
              withAnimation: this.isAnimation,
              windowLeft: 50,
              windowTop: 100,
              windowWidth: 300,
              windowHeight: 400
            };
            this.context.startAbility(localWant, startOptions, (err, data) => {
              if (err && err.code != 0) {
                logger.error(`${TAG} startAbility failed, err: ${JSON.stringify(err)}`);
              } else {
                logger.info(`${TAG} startAbility success. ${JSON.stringify(data)}`);
              }
            })
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
            if (groupItem.title === '8') {
              ListItem() {
                Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                  Text($r('app.string.start_animation'))
                    .fontSize(14)
                    .padding({ left: 12, right: 12 })
                  Text(this.isAnimation ? $r('app.string.close') : $r('app.string.open'))
                    .margin({ right: 12 })
                    .fontSize(14)
                    .onClick(() => {
                      this.isAnimation = !this.isAnimation;
                    }).fontColor($r('sys.color.ohos_id_color_floating_button_bg_normal'))
                }.width("100%")
              }.width("100%").height(25).padding({ top: 10 })
            }
            ListItemGroup() {
              ForEach(groupItem.list, (item: ListItemModel, index: number) => {
                ListItem() {
                  Column() {
                    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                      Text(item.text) {
                      }.fontSize(16)
                      .height(48)
                      .fontColor($r('sys.color.ohos_id_color_toolbar_sub_bg_dark'))

                      if (item.rType === 'arrow') {
                        Image($r('app.media.ic_arrow'))
                          .width(24).height(24).padding({ left: 12 })
                      }
                      else if (item.rType === 'right') {
                        if (groupIndex === 0) {
                          if (this.isChinese) {
                            if (index === 0) {
                              Image($r('app.media.ic_check'))
                                .width(24).height(24)
                            }
                          } else {
                            if (index === 1) {
                              Image($r('app.media.ic_check'))
                                .width(24).height(24)
                            }
                          }
                        }
                        else if (groupIndex === 1) {
                          if (this.isLight) {
                            if (index === 0) {
                              Image($r('app.media.ic_check'))
                                .width(24).height(24)
                            }
                          } else {
                            if (index === 1) {
                              Image($r('app.media.ic_check'))
                                .width(24).height(24)
                            }
                          }
                        }
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