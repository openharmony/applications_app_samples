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

import { CommonConstants, Flow, Logger, PageViewUtils, ScenarioCard, Scene } from '@ohos/common';
import HeadTitleComponent from '../view/HeadTitleComponent';
import { triggerCondition, actions, CustomIconList } from '../model/SceneCondition';
import promptAction from '@ohos.promptAction';
import SceneModel from '../viewmodel/SceneModel';
import { SceneBean } from '../common/bean/SceneBean';
import { ColorMetrics, LengthMetrics, router } from '@kit.ArkUI';
import DeleteAlertDialog from '../view/DeleteAlertDialog';
import dataPreferences from '@ohos.data.preferences';
import { Event, SubsystemAction, Action, DeviceAction } from '@ohos/common/src/main/ets/database/entity/Scene';
import { modifySceneIcon } from '../components/modifySceneIcon';
import DevicesModel from '../viewmodel/DeviceModel';
import { HMRouterMgr } from '@hadss/hmrouter';
import { inputConsumer, inputEventClient, KeyCode } from '@kit.InputKit';
import { inputMethod } from '@kit.IMEKit';

AppStorage.setOrCreate('triggers', []);
AppStorage.setOrCreate('execute', []);


const TAG = 'AddScenePage';

@Component
struct triggerConditionsItem {
  @Prop currentItem: object;

  build() {
    Row() {
      Text(this.currentItem['eventTitleName'] || this.currentItem['actionTitleName'] || '');
      Text(this.currentItem['eventName'] || this.currentItem['actionName'] || '');
    }
    .backgroundColor('rgba(10,89,247,0.05)')
    .height('44vp')
    .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius('8vp');

  }
}

export function registerInputConsumer(keyCode: number, callback: () => void): void {
  let onKeyCode: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyCode,
    finalKeyDownDuration: 0,
    isFinalKeyDown: true
  };
  inputConsumer.on('key', onKeyCode, () => {
    callback && callback();
    Logger.info(TAG, 'inputConsumer keyEvent start');
  });
}

export function unregisterInputConsumer(keyCode: number): void {
  let onKeyCode: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyCode,
    finalKeyDownDuration: 0,
    isFinalKeyDown: true
  };
  inputConsumer.off('key', onKeyCode);
}

export function tabClick() {
  let keyDownOpt: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };
  let keyUpOpt: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };

  try {
    // 触发tab点击，使默认焦点组件多态样式生效
    inputEventClient.injectEvent({ KeyEvent: keyDownOpt });
    inputEventClient.injectEvent({ KeyEvent: keyUpOpt });
  } catch (err) {
    Logger.error('settingList inputEventClient' + err);
  }
}

@Entry
@Component
export struct AddScenePage {
  @State isAddScene: boolean = false;
  @State customName: string = '';
  @State isEdit: boolean = false;
  @State isSceneIconShow: Boolean = false;
  @State title: Resource = $r('app.string.add_custom_scene');
  @State sceneId: string = '';
  @StorageLink('triggers') triggerConditions: triggerCondition[] = [];
  @StorageLink('execute') executeActions: actions[] = [];
  @StorageLink('isUpdate') isUpdate: boolean = false;
  @StorageLink('mySceneList') mySceneList: Scene[] = [];
  @State customIndex: dataPreferences.ValueType = 1;
  @StorageLink('modesData') modesData: DevicesModel = new DevicesModel();
  private addClick: (type: number, isEdit?: boolean, item?: string) => void =
    (type: number, isEdit?: boolean, item?: string) => {
    };
  @State isLeftIcon: string | Resource = '';
  @State scenarioCard: ScenarioCard = {
    scenarioCardId: '',
    title: '',
    version: '0.0.1',
    enabled: true,
    foreground: 'foreground.png',
    logo: 'logo.png',
    author: 'OpenHarmony',
    order: 0,
    tag: 'custom',
    type: 'demo',
    description: '',
  };
  @State flows: Flow[] = [{
    createTime: '2022-10-20 21:24:30',
    hasCustomAction: false,
    id: '413ef2ab-d410-4df9-8560-2c972a909b15',
    repeatInterval: 0,
    repeatTimes: 1,
    title: '',
    type: 'auto',
    version: '0.0.1',
    actions: [{
      actionId: '',
      actionType: '',
      actions: [{} as SubsystemAction],
      conditions: [],
      enabled: true,
      source: 1,
      title: '',
      valid: true,
    } as DeviceAction],
    trigger: {
      events: []
    }
  }];
  @State sceneCurrentIcon: CustomIconList = new CustomIconList('', '', false);
  private deleteController: CustomDialogController = new CustomDialogController({
    builder: DeleteAlertDialog({
      onConfirm: () => {
        this.deleteScene(this.sceneId);
      }
    })
  });
  @State isFocusInput: boolean = false;
  inputController: inputMethod.InputMethodController | null = inputMethod.getController();

  async aboutToAppear() {
    if (this.isEdit) {
      this.title = $r('app.string.edit_custom_scene');
      this.isLeftIcon = $r('app.media.ic_public_setting');
      let result = this.getCustomDetail(this.sceneId);
      this.scenarioCard = result.scenarioCard;
      this.flows = result.flow;
      Logger.info('SubsystemAction result:' + JSON.stringify(result));
      this.customName = result.scenarioCard.title;
      let data: DeviceAction[] = JSON.parse(JSON.stringify(this.flows[0].actions));
      data.forEach((item: DeviceAction, index: number) => {
        let actionInfo: SubsystemAction[] = JSON.parse(JSON.stringify(item.actions));
        this.executeActions.push(new actions(actionInfo[0].deviceInfo.devId, actionInfo[0].deviceInfo.devType,
          actionInfo[0].deviceInfo.devName, '', actionInfo[0].actionId, item.title));
      });
      this.flows[0].trigger.events.forEach((item: Event, index: number) => {
        this.triggerConditions.push(new triggerCondition(item.deviceInfo.devId, item.deviceInfo.devType,
          item.deviceInfo.devName, '', item.operator, item.value));
      });
      Logger.info('triggerConditions this.executeActions:' + JSON.stringify(this.executeActions));
      Logger.info('triggerConditions this.triggerConditions:' + JSON.stringify(this.triggerConditions));
    } else {
      this.title = $r('app.string.add_custom_scene');
      this.getDefaultName();
    }
    this.getMySceneList();
  }

  // 查询自定义场景详情
  getCustomDetail(id: string) {
    let result: Scene = this.mySceneList.filter((item: Scene) => {
      return item.scenarioCard.scenarioCardId == id;
    })[0];
    return result;
  }

  // 删除场景
  async deleteScene(id: string) {
    this.mySceneList = this.mySceneList.filter((item: Scene) => {
      return item.scenarioCard.scenarioCardId != id;
    });
    await SceneModel.getInstance().putPreference(this.mySceneList);
    this.isUpdate = true;
    this.deleteController.close();
    router.back();
  }

  // 获取默认场景名称
  getDefaultName() {
    this.customIndex = SceneModel.getInstance().getDefaultKey('customKey');
    this.customName = '自定义场景' + this.customIndex;
  }

  // 判断是否修改默认名称
  judgeChangeDefaultName(name: string) {
    return name == '自定义场景' + this.customIndex;
  }

  // 查询我的场景列表
  getMySceneList() {
    if (SceneModel.getInstance().hasPreference()) {
      this.mySceneList = SceneModel.getInstance().getPreference();
    }
  }

  toast(msg: string | Resource) {
    promptAction.showToast({
      message: msg,
      duration: 2000,
      bottom: '160vp'
    });
  }

  aboutToDisappear(): void {
    this.triggerConditions = [];
    this.executeActions = [];
    this.isUpdate = true;
  }

  // 保存自定义场景
  async saveScene() {
    if (!this.customName) {
      this.toast($r('app.string.add_scene_name_empty_tip'));
    }
    this.scenarioCard.title = this.customName;
    this.triggerConditions.forEach((item: triggerCondition, index: number) => {
      this.flows[0].trigger.events[index] = {
        type: 'DEVICE_DATA',
        deviceInfo: {
          devId: item.id,
          devName: item.deviceName,
          devType: item.deviceType,
          path: 'filterElement1/alarm'
        },
        operator: item.eventId ? item.eventId : '',
        value: item.eventName ? item.eventName : '',
        strategy: {
          trigger: 'pulse'
        },
        pushMsg: ''
      };
    });
    this.executeActions.forEach((item: actions, index: number) => {
      Logger.info('mySceneList actions:' + JSON.stringify(item));
      let actionItem: SubsystemAction = {} as SubsystemAction;
      actionItem.actionId = item.actionId ? item.actionId : '';
      actionItem.actionType = '';
      actionItem.type = 'DEVICE_COMMAND';
      actionItem.servies = {
        sid: '',
        data: {
          characteristicName1: '',
          characteristicName2: ''
        }
      };
      actionItem.command = 'command';
      actionItem.deviceInfo = {
        devId: item.id,
        devName: item.deviceName,
        devType: item.deviceType,
        path: 'filterElement1/alarm'
      };
      let data: DeviceAction = JSON.parse(JSON.stringify(this.flows[0].actions[0]));
      data.title = item.actionName ? item.actionName : '';
      data.actions[0] = actionItem;
      this.flows[0].actions[index] = data;
    });
    if (this.isEdit) {
      this.flows[0].actions = this.flows[0].actions.slice(0, this.executeActions.length);
      this.flows[0].trigger.events = this.flows[0].trigger.events.slice(0, this.triggerConditions.length);
      this.mySceneList.map((item: Scene) => {
        if (this.sceneId == item.scenarioCard.scenarioCardId) {
          item.scenarioCard.title = this.customName;
          item.flow = this.flows;
        }
      });
      await SceneModel.getInstance().putPreference(this.mySceneList);
    } else {
      this.scenarioCard.scenarioCardId = this.mySceneList.length + 1 + '';
      let scene: Scene = { scenarioCard: this.scenarioCard, flow: this.flows };
      Logger.info('mySceneList scene:' + JSON.stringify(scene));
      this.mySceneList.unshift(scene);
      await SceneModel.getInstance().putPreference(this.mySceneList);
      if (this.judgeChangeDefaultName(this.customName)) {
        SceneModel.getInstance().putCustomKey('customKey', Number(this.customIndex) + 1);
      }
    }
    this.toast($r('app.string.scene_save_tip'));
    // 清空数据
    this.triggerConditions = [];
    this.executeActions = [];
    this.isUpdate = true;
    router.back();
  }

  onPageShow(): void {
    setTimeout(() => {
      PageViewUtils.tabClick();
    }, 200);
  }

  @Builder
  modifySceneIconBuilder() {
    Column() {
      modifySceneIcon(
        {
          cancel: () => this.isSceneIconShow = false,
          confirm: (data) => {
            this.sceneCurrentIcon = data;
            this.isSceneIconShow = false;
          },
        }
      );
    }.height('100%').width('100%');
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
        .margin({ bottom: $r('app.string.40_vp') });

        Column() {
          Scroll() {
            Column() {
              Row() {
                Row() {
                  Image($r(`app.media.${this.sceneCurrentIcon.value}`)).size({
                    width: $r('app.string.scene_current_icon_width'),
                    height: $r('app.string.scene_current_icon_height'),
                  }).objectFit(ImageFit.Contain);
                }
                .width($r('app.string.height_40'))
                .height($r('app.string.height_40'))
                .backgroundColor('#e7e2fc')
                .borderRadius($r('app.string.height_40'))
                .justifyContent(FlexAlign.Center);

                Button($r('app.string.modify_scene_icon'))
                  .key('firstbutton')
                  .fontSize($r('app.string.font_16'))
                  .fontColor($r('app.color.add_scene_button_bg'))
                  .backgroundColor($r('app.color.default_button_bg'))
                  .padding({
                    left: $r('app.string.p_20'),
                    top: $r('app.string.p_6'),
                    bottom: $r('app.string.p_6'),
                    right: $r('app.string.p_12')
                  })
                  .focusable(true)
                  .defaultFocus(true)
                  .focusBox({
                    margin: LengthMetrics.px(5),
                    strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
                    strokeWidth: LengthMetrics.px(2)
                  })
                  .onClick(() => this.isSceneIconShow = true);
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .borderRadius($r('app.string.card_border_radius'))
              .backgroundColor($r('app.color.default_component_color'))
              .padding({
                left: $r('app.string.p_20'),
                top: $r('app.string.p_20'),
                bottom: $r('app.string.p_20'),
                right: $r('app.string.p_12')
              })
              .width(CommonConstants.FULL_WIDTH_PERCENT)
              .bindSheet($$this.isSceneIconShow, this.modifySceneIconBuilder(), {
                height: $r('app.string.modify_scene_icon_height'),
                blurStyle: BlurStyle.Thick,
                showClose: false,
                preferType: SheetType.CENTER,
                onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
                  if (dismissSheetAction.reason == DismissReason.SLIDE_DOWN) {
                    dismissSheetAction.dismiss(); //注册dismiss行为
                  } else if (dismissSheetAction.reason == DismissReason.TOUCH_OUTSIDE) {
                    this.isSceneIconShow = false;
                  }
                }),
                onWillSpringBackWhenDismiss: ((springBackAction: SpringBackAction) => {
                }),
              });

              Row() {
                Text($r('app.string.scene_name'))
                  .fontSize($r('app.string.font_20'))
                  .fontColor($r('app.color.default_button_bg'));
                Row() {
                  TextInput({ placeholder: $r('app.string.placeholder_desc'), text: this.customName })
                    .key('inputBox')
                    .maxLength(12)
                    .width('50%')
                    .textAlign(TextAlign.End)
                    .placeholderFont({ size: $r('app.string.font_14'), weight: 400 })
                    .placeholderColor($r('app.color.text_color_white'))
                    .fontSize($r('app.string.font_20'))
                    .fontColor($r('app.color.text_color_white'))
                    .backgroundColor(Color.Transparent)
                    .onChange((value: string) => {
                      this.customName = value;
                    })
                    .onKeyEvent((event) => {
                      if (event.type === KeyType.Down) {
                        if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN) {
                          tabClick();
                          return;
                        }
                        if (event.keyCode === KeyCode.KEYCODE_DPAD_UP) {
                          focusControl.requestFocus('firstbutton');
                          return;
                        }
                        if (event.keyCode === KeyCode.KEYCODE_ENTER) {
                          focusControl.requestFocus('inputBox');
                          return;
                        }
                      }
                    });
                  Image($r('app.media.ic_public_edit'))
                    .width($r('app.string.icon_width'))
                    .height($r('app.string.icon_height'));
                };
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .borderRadius($r('app.string.card_border_radius'))
              .backgroundColor($r('app.color.default_component_color'))
              .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
              .width(CommonConstants.FULL_WIDTH_PERCENT)
              .height($r('app.string.scene_tab_height'))
              .margin({ top: $r('app.string.margin_card_top') })
              .onFocus(() => {
                this.isFocusInput = true;
              })
              .onBlur(() => {
                this.isFocusInput = false;
              });

              Column() {
                if (this.triggerConditions.length > 0) {
                  ForEach(this.triggerConditions, (item: triggerCondition, index: number) => {
                    Row() {
                      Column() {
                        Text(item.deviceName)
                          .fontSize($r('app.string.font_16'))
                          .fontColor($r('app.color.scene_title_color'))
                          .width(CommonConstants.FULL_WIDTH_PERCENT)
                          .padding({ bottom: $r('app.string.padding_tab_title_left') });

                        triggerConditionsItem({ currentItem: item });
                      }
                      .layoutWeight(1);

                      Image($r('app.media.ic_public_more'))
                        .width($r('app.string.icon_width'))
                        .height($r('app.string.icon_height'))
                        .margin({ left: $r('app.string.p_12') })
                        .bindMenu([
                          {
                            value: $r('app.string.delete'),
                            action: () => {
                              Logger.info('handle Menu1 select');
                              this.triggerConditions.splice(index, 1);
                            }
                          },
                          {
                            value: $r('app.string.edit'),
                            action: () => {
                              focusControl.requestFocus('button');
                              this.addClick(1, true, JSON.stringify(item)); //编辑
                            }
                          }
                        ]);
                    }
                    .justifyContent(FlexAlign.SpaceBetween)
                    .alignItems(VerticalAlign.Center)
                    .borderRadius($r('app.string.card_border_radius'))
                    .backgroundColor(Color.White)
                    .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
                    .width(CommonConstants.FULL_WIDTH_PERCENT)
                    .padding({
                      left: $r('app.string.p_12'),
                      right: $r('app.string.p_12'),
                      top: '16vp',
                      bottom: '16vp'
                    })
                    .width(CommonConstants.FULL_WIDTH_PERCENT)
                    .constraintSize({ minHeight: $r('app.string.scene_tab_height') })
                    .margin({ bottom: $r('app.string.vp_12') });
                  }, (item: triggerCondition) => JSON.stringify(item));
                } else {
                  Row() {
                    Text($r('app.string.add_conditions'))
                      .fontSize($r('app.string.font_20'))
                      .fontColor($r('app.color.default_button_bg'));
                    Image($r('app.media.ic_public_add'))
                      .width($r('app.string.icon_width'))
                      .height($r('app.string.icon_height'))
                      .margin({ left: $r('app.string.p_12') })
                      .focusBox({
                        margin: LengthMetrics.px(2),
                        strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
                        strokeWidth: LengthMetrics.px(2)
                      })
                      .onClick(() => {
                        focusControl.requestFocus('button');
                        this.addClick(1);
                      });
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .alignItems(VerticalAlign.Center)
                  .borderRadius($r('app.string.card_border_radius'))
                  .backgroundColor($r('app.color.default_component_color'))
                  .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
                  .width(CommonConstants.FULL_WIDTH_PERCENT)
                  .padding({
                    left: $r('app.string.p_12'),
                    right: $r('app.string.p_12'),
                    top: '16vp',
                    bottom: '16vp'
                  })
                  .width(CommonConstants.FULL_WIDTH_PERCENT)
                  .constraintSize({ minHeight: $r('app.string.scene_tab_height') });
                }
              }
              .margin({ top: $r('app.string.margin_card_top') });


              Column() {
                if (this.executeActions.length > 0) {
                  ForEach(this.executeActions, (item: actions, index: number) => {
                    Row() {
                      Column() {
                        Text(item.deviceName)
                          .fontSize($r('app.string.font_20'))
                          .fontColor($r('app.color.default_button_bg'))
                          .width(CommonConstants.FULL_WIDTH_PERCENT)
                          .padding({ bottom: $r('app.string.padding_tab_title_left') });

                        triggerConditionsItem({ currentItem: item });
                      }
                      .layoutWeight(1);

                      Image($r('app.media.ic_public_more'))
                        .width($r('app.string.icon_width'))
                        .height($r('app.string.icon_height'))
                        .margin({ left: $r('app.string.p_12') })
                        .bindMenu([
                          {
                            value: $r('app.string.delete'),
                            action: () => {
                              Logger.info('handle Menu1 select');
                              this.executeActions.splice(index, 1);
                            }
                          },
                          {
                            value: $r('app.string.edit'),
                            action: () => {
                              focusControl.requestFocus('button');
                              this.addClick(2, true, JSON.stringify(item)); //编辑
                            }
                          }
                        ]);
                    }
                    .justifyContent(FlexAlign.SpaceBetween)
                    .alignItems(VerticalAlign.Center)
                    .borderRadius($r('app.string.card_border_radius'))
                    .backgroundColor($r('app.color.default_component_color'))
                    .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
                    .width(CommonConstants.FULL_WIDTH_PERCENT)
                    .padding({
                      left: $r('app.string.p_12'),
                      right: $r('app.string.p_12'),
                      top: '16vp',
                      bottom: '16vp'
                    })
                    .width(CommonConstants.FULL_WIDTH_PERCENT)
                    .constraintSize({ minHeight: $r('app.string.scene_tab_height') })
                    .margin({ bottom: $r('app.string.vp_12') });
                  }, (item: actions) => JSON.stringify(item));
                } else {
                  Row() {
                    Text($r('app.string.execute_action'))
                      .fontSize($r('app.string.font_20'))
                      .fontColor($r('app.color.default_button_bg'))
                      .fontWeight(FontWeight.Bold);
                    Image($r('app.media.ic_public_add'))
                      .width($r('app.string.icon_width'))
                      .height($r('app.string.icon_height'))
                      .margin({ left: $r('app.string.p_12') })
                      .focusBox({
                        margin: LengthMetrics.px(2),
                        strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
                        strokeWidth: LengthMetrics.px(2)
                      })
                      .onClick(() => {
                        focusControl.requestFocus('button');
                        this.addClick(2);
                      });
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .alignItems(VerticalAlign.Center)
                  .borderRadius($r('app.string.card_border_radius'))
                  .backgroundColor($r('app.color.default_component_color'))
                  .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
                  .width(CommonConstants.FULL_WIDTH_PERCENT)
                  .padding({
                    left: $r('app.string.p_12'),
                    right: $r('app.string.p_12'),
                    top: '16vp',
                    bottom: '16vp'
                  })
                  .width(CommonConstants.FULL_WIDTH_PERCENT)
                  .constraintSize({ minHeight: $r('app.string.scene_tab_height') });
                }
              }
              .margin({ top: $r('app.string.margin_card_top') });
            }
            .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
            .justifyContent(FlexAlign.Start);
          };
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Start);

        Button($r('app.string.execution_scenario'), { type: ButtonType.Capsule, stateEffect: true })
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
          .focusBox({
            margin: LengthMetrics.px(5),
            strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
            strokeWidth: LengthMetrics.px(2)
          })
          .key('button')
          .onClick(() => {
            if (this.triggerConditions.length == 0 || this.executeActions.length == 0) {
              return;
            }
            this.saveScene();
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
    .onClick(() => {
      focusControl.requestFocus('button');
    })
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        HMRouterMgr.pop();
      }
    });
  }
}