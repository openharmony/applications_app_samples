/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar'
import promptAction from '@ohos.prompt'
import prompt from '@ohos.prompt';

@Extend(Text)
function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({left: 12, top: 12})
}
@Extend(Text)
function subTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
}

@Extend(Column)
function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}
@Extend(ListItem)
function itemCardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(12)
  .width('100%')
  .padding(10)
}

@Entry
@Component
struct Interaction {
  @State buttonDisabled: boolean = false
  @State listDisabled: boolean = false
  @State alertText: string = ''
  @State handlePopup: boolean = false
  @State handleCustomPopup: boolean = false
  @State mPlacementOnTop: boolean = false
  @State mArrowOffset: number = 0
  @State mPlacement: Placement = Placement.Top
  @State mHitTestMode: HitTestMode = HitTestMode.Default
  @State mBackgroundHandleClick: boolean = false
  @State mForgroundHandleClick: boolean = false
  @State mForgroundChildHandleClick: boolean = false
  @State mComponentDisabled: boolean = false
  @State mComponentFocused: boolean = false
  @State mTabIndex: number = 0
  @State mHoverEffect: HoverEffect = HoverEffect.None;
  private mTouchableTestResult: string = ''
  private mToastTimer = null
  private mMenuLists = [
    {
      value: 'Menu Item 1',
      action: () => {}
    },
    {
      value: 'Menu Item 2',
      action: () => {}
    },
    {
      value: 'Menu Item 3',
      action: () => {}
    },
    {
      value: 'Menu Item 4',
      action: () => {}
    }
  ]

  @Styles normalStyles() {
    .backgroundColor('#0A59F7')
    .borderRadius(10)
    .borderStyle(BorderStyle.Solid)
    .borderWidth(2)
    .borderColor('#33000000')
  }

  @Styles focusedStyles() {
    .backgroundColor(Color.Red)
    .borderRadius(20)
    .borderStyle(BorderStyle.Dashed)
    .borderWidth(2)
    .borderColor('#33000000')
  }

  @Styles pressedStyles() {
    .backgroundColor(Color.Green)
    .borderRadius(40)
    .opacity(0.8)
    .borderWidth(2)
    .borderColor('#33000000')
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
    }.width(200).height(80).padding(10)
  }
  private PlacementsNameArray = ['TopLeft', 'Top', 'TopRight', 'RightTop', 'Right', 'RightBottom', 'LeftTop', 'Left', 'LeftBottom', 'BottomLeft', 'Bottom', 'BottomRight']
  private HitTestModeNameArray = ['Default', 'Block', 'Transparent', 'None']
  private HoverEffectNameArray = ['None', 'Highlight', 'Auto', 'Scale']

  @Builder tabbarTitle(name: string | Resource, index: number) {
    Stack() {
      Text(name)
        .fontSize(22)
        .fontColor(this.mTabIndex === index ? '#0A59F7' : '#000000')

      if (this.mTabIndex === index) {
        Row()
          .backgroundColor('#0A59F7')
          .width('100%')
          .height(2)
          .position({y: 48})
      }
    }.width(48)
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
                .enabled(!this.buttonDisabled)
                .onClick(() => {
                  promptAction.showToast({
                    message: "Button Clicked"
                  })
                })
              Row() {
                Text($r('app.string.button_disabled'))
                  .fontSize(15)
                Checkbox()
                  .select(this.buttonDisabled)
                  .onChange((value: boolean) => {
                    this.buttonDisabled = value
                  })
              }
            }.cardStyle()
            Text($r('app.string.list_disabled'))
              .leftTitleStyle()
            Column() {
              List({space: 5}) {
                ForEach([1,2,3,4,5,6,7,8], (item: string) => {
                  ListItem() {
                    Text(item + "")
                      .fontSize(20)
                  }.width('100%')
                  .itemCardStyle()
                })
              }.height(300)
              .width(200)
              .backgroundColor($r('app.color.background_grey'))
              .enabled(!this.listDisabled)
              .padding(12)

              Row() {
                Text($r('app.string.interaction_disable_list'))
                  .fontSize(15)
                Checkbox()
                  .select(this.listDisabled)
                  .onChange((value: boolean) => {
                    this.listDisabled = value
                  })
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
                        message: "Show alert",
                        confirm: {
                          value: "OK",
                          fontColor: Color.Red,
                          action: () => {
                            this.alertText = 'Get OK'
                          }
                        },
                        cancel: () => {
                          this.alertText = "Get Cancel"
                        }
                      }
                    )
                  })
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
                          value: "Cancel",
                          fontColor: Color.Red,
                          action: () => {
                            this.alertText = "Get Cancel Button"
                          }
                        },
                        cancel: () => {
                          this.alertText = "Get Cancel"
                        }
                      }
                    )
                  })
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
                    }
                  })
              }.cardStyle()

              Text($r('app.string.custom_popup'))
                .leftTitleStyle()
              Column() {
                Flex({ wrap: FlexWrap.Wrap }) {
                  ForEach(this.PlacementsNameArray, (item: string) => {
                    Row() {
                      Radio({ value: item, group: 'placement' })
                        .checked(this.mPlacement === Placement[item])
                        .onChange((checked) => {
                          this.mPlacement = Placement[item]
                        })
                      Text(item)
                        .fontSize(12)
                    }.width('33%')
                  })
                }.width('100%')

                Button($r('app.string.interaction_showcustompopup'))
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
                  })
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
                  Text("Background")
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
                  Text("Forground")
                    .fontColor(Color.White)
                    .fontSize(30)
                  Button("Forground Child")
                    .onClick(() => {
                      this.mForgroundChildHandleClick = true
                      this.handleClickCallback()
                    })
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
            Text("hitTestBehavior:")
              .leftTitleStyle()
            Column() {
              Flex({wrap: FlexWrap.Wrap}) {
                ForEach(this.HitTestModeNameArray, (item: string) => {
                  Row() {
                    Radio({value: item, group: 'hitTestBehavior'})
                      .checked(this.mHitTestMode === HitTestMode[item])
                      .onChange((checked) => {
                        this.mHitTestMode = HitTestMode[item]
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
          Column({space: 10}) {
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
              Text("hoverEffect")
                .leftTitleStyle()
              Column() {
                Flex({wrap: FlexWrap.Wrap}) {
                  ForEach(this.HoverEffectNameArray, (item: string) => {
                    Row() {
                      Radio({value: item, group: 'hovereffect'})
                        .checked(this.mHoverEffect === HoverEffect[item])
                        .onChange((checked) => {
                          this.mHoverEffect = HoverEffect[item]
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
            Blank()
            Row() {
              Blank()
              ForEach([1,2,3,4,5], (item) => {
                Column() {
                  Image($r('app.media.ic_other'))
                    .width(30)
                    .height(30)
                  Text($r('app.string.option'))
                    .fontSize(15)
                }
                .bindMenu(this.mMenuLists)
                Blank()
              })
            }.width('100%')
          }.height('100%')
          .width('100%')
          .padding(20)
        }.tabBar(this.tabbarTitle($r('app.string.menu'), 5))
        .height('100%')
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
                  })
              }.width(200)
            }.cardStyle()
          }.width('100%')
          .padding(12)
        }.tabBar(this.tabbarTitle($r('app.string.multiState'), 6))
      }.layoutWeight(1)
      .onChange((index) => {
        this.mTabIndex = index
      })
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
          result += '背景组件响应点击\n'
        }
        if (this.mForgroundHandleClick) {
          result += '前景组件响应点击\n'
        }
        if (this.mForgroundChildHandleClick) {
          result += '内容组件响应点击\n'
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