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

import { CommonConstants, Logger, PageViewUtils, UserLibraryDao } from '@ohos/common';
import HeadTitleComponent from '../view/HeadTitleComponent';
import DevicesModel from '../viewmodel/DeviceModel';
import { SelectorList } from '../view/SelectDevice';
import router from '@ohos.router';
import { EventActionUIInfoDataItem, actions, triggerCondition } from '../model/SceneCondition';
import { LengthMetrics, promptAction } from '@kit.ArkUI';
import { modifySceneAction } from '../components/modifySceneAction';
import { KeyCode } from '@kit.InputKit';
import { HMRouterMgr } from '@hadss/hmrouter';


@Component
struct SceneActionsDevicetItem {
  @Prop contentItem: EventActionUIInfoDataItem;
  @Prop contentIndex: number;
  @Prop type: number;
  @StorageLink('modesData') modesData: DevicesModel = new DevicesModel();
  @State focusIndex: number = -2;

  @Builder
  modifySceneActionBuilder() {
    Column() {
      modifySceneAction(
        {
          data: this.contentItem,
          cancel: () => this.contentItem.check = false,
          confirm: () => {
            this.contentItem.check = false;
            // 赋值得这么写否则不生效
            if (this.type == 1) {
              this.modesData.eventActionUiInfoData.eventUIInfo[this.contentIndex] = this.contentItem;
            } else {
              this.modesData.eventActionUiInfoData.actionUIInfo[this.contentIndex] = this.contentItem;
            }
          },
        }
      );
    }.height('100%').width('100%');
  }

  build() {
    Column() {
      Row() {
        Text(this.contentItem.name || '')
          .fontSize(this.focusIndex == this.contentIndex ? $r('app.string.font_22') : $r('app.string.font_20'))
          .fontColor(this.focusIndex == this.contentIndex ? $r('app.color.text_color_white') :
          $r('app.color.default_text_color'))
          .focusable(true)
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          })
          .defaultFocus(true)
          .onFocus(() => {
            this.focusIndex = this.contentIndex;
          })
          .onBlur(() => {
            this.focusIndex = -2;
          });

        Row() {
          Text(this.contentItem.selectedName || '请选择')
            .fontSize($r('app.string.font_20'))
            .fontColor($r('app.color.default_text_color'))
            .padding({ right: '9vp' });
          Image($r('app.media.ic_public_arrow_right'))
            .width('12vp')
            .height($r('app.string.icon_height'));
        }
        .focusable(false)
        .onClick(() => {
          this.contentItem.check = true;
        });
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .borderRadius($r('app.string.card_border_radius'))
      .backgroundColor($r('app.color.default_component_color'))
      .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .height($r('app.string.scene_tab_height'));
    }.margin({ bottom: '20vp' })
    .bindSheet(this.contentItem.check, this.modifySceneActionBuilder(), {
      height: $r('app.string.modify_scene_icon_height'),
      blurStyle: BlurStyle.Thick,
      showClose: false,
      preferType: SheetType.CENTER,
      onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
        if (dismissSheetAction.reason == DismissReason.SLIDE_DOWN) {
          dismissSheetAction.dismiss(); //注册dismiss行为
        } else if (dismissSheetAction.reason == DismissReason.TOUCH_OUTSIDE) {
          this.contentItem.check = false;
        }
      }),
    });
  }
}


@Entry
@Component
export struct AddConditionPage {
  @State type: number = 1;
  @State title: Resource = $r('app.string.add_trigger_condition');
  @StorageLink('deviceName') deviceName: string = '';
  @StorageLink('actionName') actionName: string = '';
  @StorageLink('showSelector') showSelector: boolean = false; // 是否展开下拉菜单
  @StorageLink('showSelector1') showSelector1: boolean = false; // 是否展开下拉菜单
  @StorageLink('modesData') modesData: DevicesModel = new DevicesModel();
  @StorageLink('modeId') modeId: string = ''; // 当前选中项id
  @StorageLink('deviceType') deviceType: string = '';
  @StorageLink('actionId') actionId: string = '';
  @StorageLink('triggers') triggerConditions: triggerCondition[] = [];
  @StorageLink('execute') executeActions: actions[] = [];
  @State currentDataStr: string = '';
  @State isLeftIcon: string | Resource = $r('app.media.ic_public_confirm');
  @State isEdit: boolean = false;
  @State focusIndex: number = -1;
  private addClick: (type: number) => void = (type: number) => {
  };

  aboutToAppear() {
    // 重置
    this.modeId = '';
    this.deviceName = '';
    this.deviceType = '';
    this.actionName = '';
    this.actionId = '';
    this.showSelector = false;
    this.showSelector1 = false;
    this.modesData.getDeviceListEmpty();
    this.modesData.getEventActionUiInfoData(1);

    // 判断当前是添加触发条件还是添加执行动作
    if (this.type == 1) {
      this.title = this.isEdit ? $r('app.string.edit_trigger_condition') : $r('app.string.add_trigger_condition');
      if (this.isEdit) {
        let data = JSON.parse(this.currentDataStr) as triggerCondition;
        this.modeId = data.id;
        this.deviceName = data.deviceName;
        this.deviceType = data.deviceType;

        // 获取当前选中关联列表
        let currentList = this.triggerConditions.filter(res => res.deviceName == data.deviceName) || [];
        currentList.forEach(item => {
          this.modesData.eventActionUiInfoData.eventUIInfo.forEach((res, index) => {
            if (item.eventId == res.id) {
              res.selectedValue = item.eventValue || '';
              res.selectedName = item.eventName || '';
            }
          });
        });
      }

    } else {
      this.title = this.isEdit ? $r('app.string.edit_execute_action') : $r('app.string.add_execute_action');
      if (this.isEdit) {
        let data = JSON.parse(this.currentDataStr) as actions;
        this.modeId = data.id;
        this.deviceName = data.deviceName;
        this.deviceType = data.deviceType;

        // 获取当前选中关联列表
        let currentList = this.executeActions.filter(res => res.deviceName == data.deviceName) || [];
        currentList.forEach(item => {
          this.modesData.eventActionUiInfoData.actionUIInfo.forEach((res, index) => {
            if (item.actionId == res.id) {
              res.selectedValue = item.actionValue || '';
              res.selectedName = item.actionName || '';
            }
          });
        });
      }
    }
    console.log(JSON.stringify(this.isEdit), 'isEdit', JSON.stringify(this.type));
  }

  toast(msg: string | Resource) {
    promptAction.showToast({
      message: msg,
      duration: 2000,
      bottom: '160vp'
    });
  }

  onPageShow(): void {
    setTimeout(() => {
      PageViewUtils.tabClick();
    }, 200);
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text(this.title)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .focusable(false);
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: $r('app.string.20_vp') });

        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Column() {
              Row() {
                Text($r('app.string.device_select'))
                  .fontSize(this.focusIndex == -1 ? $r('app.string.font_22') : $r('app.string.font_20'))
                  .fontColor(this.focusIndex == -1 ? $r('app.color.text_color_white') :
                  $r('app.color.default_text_color'))
                  .focusable(true)
                  .focusBox({
                    strokeWidth: LengthMetrics.px(0)
                  })
                  .defaultFocus(true)
                  .onFocus(() => {
                    this.focusIndex = -1;
                  })
                  .onBlur(() => {
                    this.focusIndex = -2;
                  });
                Row() {
                  Text(this.deviceName)
                    .fontSize('14vp')
                    .lineHeight('16vp')
                    .fontColor($r('app.color.text_color_white'))
                    .padding({ right: '9vp' });
                  Image($r('app.media.ic_public_arrow_right'))
                    .width('12vp')
                    .height($r('app.string.icon_height'));
                };
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .borderRadius($r('app.string.card_border_radius'))
              .backgroundColor($r('app.color.default_component_color'))
              .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
              .width(CommonConstants.FULL_WIDTH_PERCENT)
              .height($r('app.string.scene_tab_height'));
            }
            .margin({ top: '22vp' })
            .onClick(() => {
              focusControl.requestFocus('button');
              this.addClick(5);
            });

            if (this.showSelector) {
              SelectorList({
                type: 1
              });
            }
          }
          .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
          .zIndex(1);

          // 触发条件
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Column() {
              ForEach(this.type == 1 ? this.modesData.eventActionUiInfoData.eventUIInfo :
              this.modesData.eventActionUiInfoData.actionUIInfo,
                (item: EventActionUIInfoDataItem, index: number) => {
                  SceneActionsDevicetItem({ contentItem: item, contentIndex: index, type: this.type });
                });
            }
            .margin({ top: '22vp' });

            if (this.showSelector1) {
              SelectorList({
                type: 2
              });
            }
          }
          .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
          .zIndex(0)
          .visibility(this.modeId != '' ? Visibility.Visible : Visibility.Hidden);
        }
        .width('100%')
        .layoutWeight(1);

        Button($r('app.string.sure'), { type: ButtonType.Capsule, stateEffect: true })
          .fontColor($r('app.color.text_color_black'))
          .fontSize('14fp')
          .width(150)
          .backgroundColor($r('app.color.default_button_bg'))
          .padding({
            left: 30,
            right: 30,
            top: 10,
            bottom: 10
          })
          .key('button')
          .onClick(async () => {
            switch (this.type) {
              case 1:
                if (this.isEdit) {
                  let data = JSON.parse(this.currentDataStr) as triggerCondition;
                  let arr = this.modesData.eventActionUiInfoData.eventUIInfo.filter(row => row.selectedName &&
                  row.selectedValue);
                  // 清空已有数据
                  this.triggerConditions = this.triggerConditions.filter(item => data.deviceName !== item.deviceName);

                  // 新增添加数据
                  arr.forEach(item => {
                    this.triggerConditions.unshift(
                      new triggerCondition(this.modeId, this.deviceType, this.deviceName,
                        item.name,
                        item.id, // 唯一标识
                        item.selectedValue, item.selectedName));
                  });
                } else {
                  this.modesData.eventActionUiInfoData.eventUIInfo.forEach(res => {
                    if (res.selectedName && res.selectedValue) {
                      this.triggerConditions.unshift(new triggerCondition(this.modeId, this.deviceType, this.deviceName,
                        res.name,
                        res.id, // 唯一标识
                        res.selectedValue, res.selectedName));
                    }
                  });
                }
                break;
              case 2:
                if (this.isEdit) {
                  let data = JSON.parse(this.currentDataStr) as actions;
                  let arr = this.modesData.eventActionUiInfoData.actionUIInfo.filter(row => row.selectedName &&
                  row.selectedValue);
                  // 清空已有数据
                  this.executeActions = this.executeActions.filter(item => data.deviceName !== item.deviceName);

                  // 新增添加数据
                  arr.forEach(item => {
                    this.executeActions.unshift(
                      new actions(this.modeId, this.deviceType, this.deviceName,
                        item.name,
                        item.id, // 唯一标识
                        item.selectedValue, item.selectedName));
                  });
                } else {
                  this.modesData.eventActionUiInfoData.actionUIInfo.forEach(res => {
                    if (res.selectedName && res.selectedValue) {
                      this.executeActions.unshift(new actions(this.modeId, this.deviceType, this.deviceName, res.name,
                        res.id, // 唯一标识
                        res.selectedValue,
                        res.selectedName));
                    }
                  });
                }
                break;
              default:
                break;
            }
            router.back();
          });
      }
      .width('70%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween);
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .backgroundColor($r('app.color.page_background'))
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        HMRouterMgr.pop();
      }
    });
  }
}