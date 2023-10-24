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

import pointer from '@ohos.multimodalInput.pointer';
import promptAction from '@ohos.prompt';
import prompt from '@ohos.prompt';
import window from '@ohos.window';
import { TitleBar } from '../../../../common/TitleBar';
import { getStringData } from '../../../../data//ResourceDataHandle';
import { placementsNameData, hitTestModeNameData, hoverEffectNameData, pointerStyleNameData, PointerStyleName } from '../../UniversialData';
import Logger from '../../../../util/Logger';
import measure from '@ohos.measure';

class MMenu {
  value: string = '';
  icon!: Resource;
  action:  () => void = (): void => {};
}

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Extend(Text) function subTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(ListItem) function itemCardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(12)
  .width('100%')
  .padding(10)
}

@Entry
@Component
struct Interaction {
  @State isMask: boolean = false;
  @State buttonIsDisabled: boolean = false;
  @State listIsDisabled: boolean = false;
  @State alertText: string = '';
  @State handlePopup: boolean = false;
  @State handleCustomPopup: boolean = false;
  @State mPlacementOnTop: boolean = false;
  @State mArrowOffset: number = 0;
  @State mPlacement: Placement = Placement.Top;
  @State mHitTestMode: HitTestMode = HitTestMode.Default;
  @State mBackgroundHandleClick: boolean = false;
  @State mForgroundHandleClick: boolean = false;
  @State mForgroundChildHandleClick: boolean = false;
  @State mComponentDisabled: boolean = false;
  @State mComponentFocused: boolean = false;
  @State mTabIndex: number = 0;
  @State mHoverEffect: HoverEffect = HoverEffect.None;
  @State mPointerStyle: pointer.PointerStyle = pointer.PointerStyle.DEFAULT;
  private mTouchableTestResult: string = '';
  private mToastTimer: number | null = null;
  private mMenuLists: MMenu[] = [
    {
      value: getStringData($r('app.string.components_interaction_menuone')),
      icon: $r('app.media.ic_other'),
      action: () => {
      }
    },
    {
      value: getStringData($r('app.string.components_interaction_menutwo')),
      icon: $r('app.media.ic_other'),
      action: () => {
      }
    },
    {
      value: getStringData($r('app.string.components_interaction_menuthree')),
      icon: $r('app.media.ic_other'),
      action: () => {
      }
    },
    {
      value: getStringData($r('app.string.components_interaction_menufour')),
      icon: $r('app.media.ic_other'),
      action: () => {
      }
    }
  ];

  @Styles normalStyles() {
    .backgroundColor($r('app.color.normal_bg_color'))
    .borderRadius(10)
    .borderStyle(BorderStyle.Solid)
    .borderWidth(2)
    .borderColor($r('app.color.btn_border_color'))
  }

  @Styles focusedStyles() {
    .backgroundColor(Color.Red)
    .borderRadius(20)
    .borderStyle(BorderStyle.Dashed)
    .borderWidth(2)
    .borderColor($r('app.color.btn_border_color'))
  }

  @Styles pressedStyles() {
    .backgroundColor(Color.Green)
    .borderRadius(40)
    .opacity(0.8)
    .borderWidth(2)
    .borderColor($r('app.color.btn_border_color'))
  }

  @Styles disabledStyles() {
    .backgroundColor(Color.Gray)
    .borderRadius(10)
    .opacity(0.8)
    .borderWidth(2)
  }

  @Builder popupBuilder() {
    Row({ space: 20 }) {
      Image($r("app.media.icon")).width(24).height(24)
      Text('Content').fontSize(20).fontColor(Color.White)
    }.width(140).height(40).padding(10)
  }

  @Builder menuBuilder() {
    Menu() {
      MenuItem({ startIcon: $r('app.media.ic_other'), content: $r('app.string.components_interaction_menuone') })
      MenuItemGroup({ header: $r('app.string.components_interaction_menutwo') }) {
        MenuItem({
          startIcon: $r('app.media.ic_other'),
          content: $r('app.string.components_interaction_menuthree')
        })
        MenuItem({
          startIcon: $r('app.media.ic_other'),
          content: $r('app.string.components_interaction_menufour')
        })
      }
    }
  }
  private context: Context = getContext(this)
  private placementsNameArray = placementsNameData
  private hitTestModeNameArray = hitTestModeNameData
  private hoverEffectNameArray = hoverEffectNameData
  private pointerStyleNameArray = pointerStyleNameData

  @Builder tabbarTitle(name: string | Resource, index: number) {
    Column() {
      Text(name)
        .fontSize(22)
        .fontColor(this.mTabIndex === index ? $r('app.color.title_colorone') : $r('app.color.title_colortwo'))
        .margin({ bottom: 5 })

      if (this.mTabIndex === index) {
        Row()
          .width(measure.measureTextSize({textContent:name}).width)
          .backgroundColor($r('app.color.title_colorone'))
          .height(2)
      }
    }
    .margin(8)
    .constraintSize({ minWidth: 32 })
    .height(56)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.components_interaction') })
      Tabs() {
        TabContent() {
          Column() {
            Text($r('app.string.button_disabled'))
              .leftTitleStyle()
            Column() {
              Button($r('app.string.button'))
                .enabled(!this.buttonIsDisabled)
                .onClick(() => {
                  promptAction.showToast({
                    message: 'Button Clicked'
                  })
                })
              Row() {
                Text($r('app.string.button_disabled'))
                  .fontSize(15)
                Checkbox()
                  .select(this.buttonIsDisabled)
                  .onChange((value: boolean) => {
                    this.buttonIsDisabled = value
                  }).id('test_checkbox1')
              }
            }.cardStyle()

            Text($r('app.string.list_disabled'))
              .leftTitleStyle()
            Column() {
              List({ space: 5 }) {
                ForEach([1, 2, 3, 4, 5, 6, 7, 8], (item: string) => {
                  ListItem() {
                    Text(item + "")
                      .fontSize(20)
                  }.width('100%')
                  .itemCardStyle()
                })
              }
              .height(300)
              .width(200)
              .backgroundColor($r('app.color.background_grey'))
              .enabled(!this.listIsDisabled)
              .padding(12)

              Row() {
                Text($r('app.string.interaction_disable_list'))
                  .fontSize(15)
                Checkbox()
                  .select(this.listIsDisabled)
                  .onChange((value: boolean) => {
                    this.listIsDisabled = value
                  }).id('test_checkbox2')
              }
            }.width('100%')
            .cardStyle()
          }.width('100%')
          .padding(12)
        }.tabBar(this.tabbarTitle($r('app.string.disabled'), 0))

        TabContent() {
          Scroll() {
            Column() {
              Text($r('app.string.alert'))
                .leftTitleStyle()
              Column({ space: 12 }) {
                Row() {
                  Text($r('app.string.result'))
                    .fontSize(14)
                  Text(this.alertText)
                    .fontSize(14)
                }.width('100%')
                .padding(12)

                Button($r('app.string.interaction_show_one_alert'))
                  .onClick(() => {
                    AlertDialog.show(
                      {
                        title: 'Alert',
                        message: 'Show alert',
                        confirm: {
                          value: 'OK',
                          fontColor: Color.Red,
                          action: () => {
                            this.alertText = 'Get OK'
                          }
                        },
                        cancel: () => {
                          this.alertText = 'Get Cancel'
                        }
                      }
                    )
                  }).id('test_oneButton')
                Button($r('app.string.interaction_show_two_alert'))
                  .onClick(() => {
                    AlertDialog.show(
                      {
                        title: 'Alert',
                        message: "Show alert",
                        primaryButton: {
                          value: "OK",
                          fontColor: Color.Green,
                          backgroundColor: Color.White,
                          action: () => {
                            this.alertText = 'Get OK'
                          }
                        },
                        secondaryButton: {
                          value: 'Cancel',
                          fontColor: Color.Red,
                          action: () => {
                            this.alertText = 'Get Cancel Button'
                          }
                        },
                        cancel: () => {
                          this.alertText = 'Get Cancel'
                        }
                      }
                    )
                  }).id('test_twoButton')
              }.cardStyle()

              Text($r('app.string.popup'))
                .leftTitleStyle()
              Column() {
                Row() {
                  Text($r('app.string.interaction_placementontop'))
                    .fontSize(15)
                  Checkbox()
                    .select(this.mPlacementOnTop)
                    .onChange((value) => {
                      this.mPlacementOnTop = value
                    })
                  Text($r('app.string.interaction_mask'))
                    .fontSize(15)
                  Checkbox()
                    .select(this.isMask)
                    .onChange((value) => {
                      this.isMask = value
                    })
                }.alignSelf(ItemAlign.Start)

                Text($r('app.string.interaction_arrowoffset'))
                  .fontSize(15)
                  .alignSelf(ItemAlign.Start)
                Row() {
                  Text('0%')
                  Slider({ value: this.mArrowOffset, min: 0, max: 100 })
                    .onChange((value) => {
                      this.mArrowOffset = value
                    })
                    .showTips(true)
                    .layoutWeight(1)
                  Text('100%')
                }.width('100%')
                .padding({ left: 10, right: 10 })

                Button($r('app.string.interaction_showpopup'))
                  .onClick(() => {
                    this.handlePopup = true;
                  })
                  .bindPopup(this.handlePopup, {
                    message: "Display Popup Messages",
                    placementOnTop: this.mPlacementOnTop,
                    arrowOffset: this.mArrowOffset + '%',
                    primaryButton: {
                      value: 'OK',
                      action: () => {
                        this.handlePopup = false
                      }
                    },
                    secondaryButton: {
                      value: 'Cancel',
                      action: () => {
                        this.handlePopup = false
                      }
                    },
                    mask: this.isMask
                  }).id('test_popButton')
              }.cardStyle()

              Text($r('app.string.custom_popup'))
                .leftTitleStyle()
              Column() {
                Flex({ wrap: FlexWrap.Wrap }) {
                  ForEach(this.placementsNameArray, (item: string) => {
                    Row() {
                      Radio({ value: item, group: 'placement' })
                        .checked(this.mPlacement === Placement[item])
                        .onChange((isChecked: boolean) => {
                          if (isChecked) {
                            this.mPlacement = Placement[item]
                          }
                        })
                      Text(item)
                        .fontSize(12)
                    }.width('33%')
                  })
                }.width('100%')

                Button($r('app.string.interaction_showcustompopup'))
                  .margin({ bottom: 30 })
                  .onClick(() => {
                    this.handleCustomPopup = true;
                  })
                  .bindPopup(this.handleCustomPopup, {
                    builder: this.popupBuilder,
                    placement: this.mPlacement,
                    maskColor: '#11000000',
                    onStateChange: (e) => {
                      if (!e.isVisible) {
                        this.handleCustomPopup = false
                      }
                    }
                  }).id('test_customButton')
              }.cardStyle()
            }.width('100%')
            .padding(12)
          }
        }.tabBar(this.tabbarTitle($r('app.string.popup_window'), 1))

        TabContent() {
          Column() {
            Column() {
              Stack() {
                Column() {
                  Text($r('app.string.components_interaction_clicktextone'))
                    .fontColor(Color.White)
                    .fontSize(30)
                }
                .offset({ x: -20, y: -20 })
                .width(200)
                .height(200)
                .onClick(() => {
                  this.mBackgroundHandleClick = true
                  this.handleClickCallback()
                })
                .backgroundColor(Color.Green)
                .stateStyles({
                  pressed: this.pressedStyles,
                  normal: this.normalStyles
                })

                Column() {
                  Text($r('app.string.components_interaction_clicktexttwo'))
                    .fontColor(Color.White)
                    .fontSize(30)
                  Button($r('app.string.components_interaction_clicktextthree'))
                    .onClick(() => {
                      this.mForgroundChildHandleClick = true
                      this.handleClickCallback()
                    }).id('test_forgroundChild')
                }
                .width(200)
                .height(200)
                .offset({ x: 20, y: 20 })
                .hitTestBehavior(this.mHitTestMode)
                .backgroundColor(Color.Green)
                .stateStyles({
                  pressed: this.pressedStyles,
                  normal: this.focusedStyles
                })
              }.width('100%')
              .height(300)
            }.cardStyle()

            Text($r('app.string.touch_test_region'))
              .subTitleStyle()
            Text($r('app.string.components_interaction_hittestbehavior'))
              .leftTitleStyle()
            Column() {
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.hitTestModeNameArray, (item: string) => {
                  Row() {
                    Radio({ value: item, group: 'hitTestBehavior' })
                      .checked(this.mHitTestMode === HitTestMode[item])
                      .onChange((isChecked: boolean) => {
                        if (isChecked) {
                          this.mHitTestMode = HitTestMode[item]
                        }
                      })
                    Text(item)
                      .fontSize(15)
                  }.width('50%')
                })
              }.width('100%')
            }.cardStyle()
          }.width('100%')
          .padding(12)
        }.tabBar(this.tabbarTitle($r('app.string.touch_test'), 2))

        TabContent() {
          Column() {
            Text($r("app.string.touch_hit_test"))
              .leftTitleStyle()
            Column() {
              Stack() {
                Rect({ width: 50, height: 50 })
                  .position({ x: 0, y: 0 })
                  .fill(Color.Green)
                  .hitTestBehavior(HitTestMode.None)
                  .id('test_rect')
                Rect({ width: 50, height: 50 })
                  .position({ x: 250, y: 0 })
                  .fill(Color.Green)
                  .hitTestBehavior(HitTestMode.None)
                Rect({ width: 50, height: 50 })
                  .position({ x: 250, y: 250 })
                  .fill(Color.Green)
                  .hitTestBehavior(HitTestMode.None)
                Rect({ width: 50, height: 50 })
                  .position({ x: 0, y: 250 })
                  .fill(Color.Green)
                  .hitTestBehavior(HitTestMode.None)
                Stack() {
                  Text($r("app.string.response_region"))
                    .fontSize(20)
                    .fontColor(Color.White)
                }
                .width(200)
                .height(200)
                .backgroundColor(Color.Red)
                .stateStyles({
                  pressed: this.pressedStyles,
                  normal: this.normalStyles
                })
                .responseRegion([
                  { x: -50, y: -50, width: 50, height: 50 },
                  { x: 200, y: -50, width: 50, height: 50 },
                  { x: 200, y: 200, width: 50, height: 50 },
                  { x: -50, y: 200, width: 50, height: 50 },
                ])
              }.width(300)
              .height(300)
            }.cardStyle()

            Text($r("app.string.touch_hit_subtitle"))
              .subTitleStyle()
          }.width('100%')
          .padding(12)
        }.tabBar(this.tabbarTitle($r('app.string.touch_region'), 3))

        TabContent() {
          Column({ space: 10 }) {
            Column() {
              Row() {
                Text($r('app.string.hover_region'))
                  .fontSize(15)
                  .fontColor(Color.White)
              }
              .width(200)
              .height(200)
              .backgroundColor(Color.Green)
              .hoverEffect(this.mHoverEffect)
            }.cardStyle()

            Column() {
              Text($r('app.string.components_interaction_hovereffect'))
                .leftTitleStyle()
              Column() {
                Flex({ wrap: FlexWrap.Wrap }) {
                  ForEach(this.hoverEffectNameArray, (item: string) => {
                    Row() {
                      Radio({ value: item, group: 'hovereffect' })
                        .checked(this.mHoverEffect === HoverEffect[item])
                        .onChange((isChecked: boolean) => {
                          if (isChecked) {
                            this.mHoverEffect = HoverEffect[item]
                          }
                        })
                      Text(item)
                        .fontSize(15)
                    }.width('50%')
                  })
                }.width('100%')
              }.cardStyle()
            }
          }.width('100%')
          .padding(12)
        }.tabBar(this.tabbarTitle($r('app.string.hovereffect'), 4))

        TabContent() {
          Column() {
            Scroll() {
              Column() {
                Text($r('app.string.bind_menu_customBuilder'))
                  .leftTitleStyle()
                Column() {
                  Text($r('app.string.click_on_any_action_below'))
                    .leftTitleStyle()
                  Row() {
                    Blank()
                    ForEach([1, 2, 3, 4, 5], (item: number) => {
                      Column() {
                        Image($r('app.media.ic_other'))
                          .width(30)
                          .height(30)
                        Text($r('app.string.option'))
                          .fontSize(15)
                      }
                      .id('menuBuilder' + item)
                      .bindMenu(this.menuBuilder)

                      Blank()
                    })
                  }.width('100%')

                  Blank()
                }.cardStyle().height(250)

                Text($r('app.string.bind_menu_content'))
                  .leftTitleStyle()
                Column() {
                  Text($r('app.string.click_on_any_action_below'))
                    .leftTitleStyle()
                  Row() {
                    Blank()
                    ForEach([1, 2, 3, 4, 5], (item: number) => {
                      Column() {
                        Image($r('app.media.ic_other'))
                          .width(30)
                          .height(30)
                        Text($r('app.string.option'))
                          .fontSize(15)
                      }
                      .id('mMenuLists' + item)
                      .bindMenu(this.mMenuLists)

                      Blank()
                    })
                  }.width('100%')

                  Blank()
                }.cardStyle().height(250)

                Text($r('app.string.bind_content_menu'))
                  .leftTitleStyle()
                Column() {
                  Text($r('app.string.long_press_any_action_below'))
                    .leftTitleStyle()
                  Row() {
                    Blank()
                    ForEach([1, 2, 3, 4, 5], (item: number) => {
                      Column() {
                        Image($r('app.media.ic_other'))
                          .width(30)
                          .height(30)
                        Text($r('app.string.option'))
                          .fontSize(15)
                      }
                      .id('contextMenu' + item)
                      .bindContextMenu(
                        this.menuBuilder,
                        ResponseType.LongPress,
                        {
                          offset: { x: 0, y: 0 }
                        }
                      )
                      Blank()
                    })
                  }.width('100%')

                  Blank()
                }.cardStyle().height(250).margin({ bottom: 70 })
              }
            }
          }.height('100%')
          .width('100%')
          .padding(20)
        }.tabBar(this.tabbarTitle($r('app.string.menu'), 5))

        TabContent() {
          Column() {
            Row() {
              Row() {
                Text($r('app.string.multistatus_region'))
                  .fontSize(15)
                  .fontColor(Color.White)
              }
              .enabled(!this.mComponentDisabled)
              .focusable(this.mComponentFocused)
              .key('item')
              .width(200)
              .height(200)
              .stateStyles({
                normal: this.normalStyles,
                pressed: this.pressedStyles,
                focused: this.focusedStyles,
                disabled: this.disabledStyles,
              })
            }

            Text($r('app.string.status_select'))
              .leftTitleStyle()
            Column() {
              Row() {
                Text($r('app.string.interaction_disable'))
                  .fontSize(15)
                Blank()
                Checkbox()
                  .select(this.mComponentDisabled)
                  .onChange((value: boolean) => {
                    this.mComponentDisabled = value
                  }).id('test_checkbox')
              }.width(200)
            }.cardStyle()
          }.width('100%')
          .padding(12)
        }.tabBar(this.tabbarTitle($r('app.string.multiState'), 6))

        TabContent() {
          Scroll() {
            Column() {
              Text($r('app.string.multi_short_key'))
                .leftTitleStyle()
              Column() {
                Text($r('app.string.on_short_key'))
                  .leftTitleStyle()
                Button($r('app.string.multi_short_key'))
                  .onClick(() => {
                    prompt.showToast({
                      message: getStringData($r('app.string.short_key_pressed')),
                      duration: 1000,
                    });
                  })
                  .keyboardShortcut('a', [ModifierKey.CTRL])
              }.cardStyle()

              Text($r('app.string.set_mouse_style'))
                .leftTitleStyle()
              Column() {
                Flex({ wrap: FlexWrap.Wrap }) {
                  ForEach(this.pointerStyleNameArray, (item: PointerStyleName) => {
                    Row() {
                      Radio({ value: item.key, group: 'pointerStyle' })
                        .id(item.key)
                        .checked(this.mPointerStyle === item.value)
                        .onChange((isChecked: boolean) => {
                          if (isChecked) {
                            this.mPointerStyle = item.value;
                            try {
                              let promise = window.getLastWindow(this.context);
                              promise.then((win)=> {
                                let windowId = win.getWindowProperties().id;
                                Logger.info('Succeeded in obtaining the top window. Data: ' + JSON.stringify(win));
                                if (windowId < 0) {
                                  Logger.info(`Invalid windowId`);
                                  return;
                                }
                                try {
                                  pointer.setPointerStyle(windowId, this.mPointerStyle, error => {
                                    Logger.info(`Set pointer style success`);
                                  });
                                } catch (error) {
                                  Logger.info(`Set pointer style failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                                }
                              }).catch((err: Error)=>{
                                Logger.error('Failed to obtain the top window. Cause: ' + JSON.stringify(err));
                              });
                            } catch (exception) {
                              Logger.error('Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
                            }
                          }
                        })
                      Text(item.key)
                        .fontSize(10)
                    }.width('50%')
                  })
                }.width('100%')
              }.cardStyle()
            }.width('100%')
            .padding(12)
          }
        }.tabBar(this.tabbarTitle($r('app.string.multimode_input'), 7))
      }
      .barOverlap(true)
      .onChange((index) => {
        this.mTabIndex = index
      })
      .barOverlap(true)
      .barMode(BarMode.Scrollable)
    }
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
  }

  handleClickCallback() {
    this.mTouchableTestResult = ""
    if (!this.mToastTimer) {
      this.mToastTimer = setTimeout(() => {
        let result = ''
        if (this.mBackgroundHandleClick) {
          result += getStringData($r('app.string.components_interaction_backgroundresponse'))
        }
        if (this.mForgroundHandleClick) {
          result += getStringData($r('app.string.components_interaction_foregroundresponse'))
        }
        if (this.mForgroundChildHandleClick) {
          result += getStringData($r('app.string.components_interaction_contentresponse'))
        }
        this.mTouchableTestResult = result
        this.mBackgroundHandleClick = false
        this.mForgroundChildHandleClick = false
        this.mForgroundHandleClick = false
        prompt.showToast({
          message: this.mTouchableTestResult
        })
        this.mToastTimer = null;
      }, 40)
    }
  }
}