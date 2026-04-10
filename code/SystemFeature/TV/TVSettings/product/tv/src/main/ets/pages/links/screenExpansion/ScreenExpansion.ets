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

import lpx from '../../../common/Lpx';
import { SettingBackground } from '../../../default/layout/SettingBackground';
import { KeyCode } from '@kit.InputKit';
import { LengthMetrics, promptAction, router } from '@kit.ArkUI';
import { Ratio } from '../../../common/Ratio';
import { SettingItemDesLayout } from '../../../default/layout/SettingItemDesLayout';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { EventUtil } from '../../../common/EventUtil';
import { SourcetoolConstants } from '../../../common/constants/StyleConstants';

const TAG = 'ScreenExpansion'

@Entry
@Component
struct ScreenExpansion {
  @State imageUrl: string = Ratio.resName('icon_expansion')
  @State des: string = getContext(this).resourceManager.getStringByNameSync('screen_expansion')
  @State isFocusExpansion: boolean = false
  @State isFocusApplication: boolean = false
  @State diffDisplayEnable: boolean = false

  aboutToAppear(): void {
    try {
      this.diffDisplayEnable = systemParameterEnhance.getSync('persist.display.expand.enabled') == '1'
      console.log(TAG, 'get persist.display.expand.enabled = ' + this.diffDisplayEnable);
    } catch (err) {
      console.log(TAG, 'get persist.display.expand.enabled fail');
    }
  }


  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height('100%')
        .width('100%')

      Row() {
        Column() {
          Column() {
            Text($r('app.string.screen_expansion'))
              .height(lpx(75))
              .lineHeight(lpx(75))
              .fontColor(Color.White)
              .fontSize(lpx(64))
              .fontWeight(500)
              .textAlign(TextAlign.Start)
              .focusable(false)
              .margin({
                top: lpx(48),
                bottom: lpx(48),
                left: lpx(12)
              })

            Row() {
              Row() {
                Text($r('app.string.expansion'))
                  .height(lpx(98))
                  .fontColor(this.isFocusExpansion ? Color.Black : Color.White)
                  .fontSize(lpx(36))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    left: lpx(24)
                  })
                Blank()

                Toggle({ type: ToggleType.Switch, isOn: $$this.diffDisplayEnable })
                  .width(lpx(83))
                  .height(lpx(46))
                  .selectedColor('#2056f7')
                  .switchPointColor(0xe5ffffff)
                  .align(Alignment.Center)
                  .margin({ right: lpx(24) })
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .onChange(()=>{
                    try {
                      systemParameterEnhance.set('persist.display.expand.enabled', this.diffDisplayEnable ? '1' : '0')
                      promptAction.showToast({ message: $r('app.string.diffdisplay_reboot_tip') })
                    } catch (err) {
                      console.error(TAG, `set persist.display.expand.enabled error : ` + JSON.stringify(err))
                    }
                  })
              }
              .onClick(()=>{
                try {
                  this.getUIContext().getFocusController().requestFocus('ScreenExpansion1')
                } catch (error) {
                  console.log('ScreenExpansion','定焦失败')
                }
                try {
                  this.diffDisplayEnable = !this.diffDisplayEnable
                  systemParameterEnhance.set('persist.display.expand.enabled', this.diffDisplayEnable ? '1' : '0')
                  promptAction.showToast({ message: $r('app.string.diffdisplay_reboot_tip') })
                } catch (err) {
                  console.error(TAG, `set persist.display.expand.enabled error : ` + JSON.stringify(err))
                }
              })
              .width(this.isFocusExpansion ? lpx(846) : lpx(840))
              .height(lpx(98))
              .backgroundColor(this.isFocusExpansion ? 'rgba(255, 255, 255, 0.86)' :
                'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
            }
            .height(lpx(118))
            .width(lpx(868))
            .borderRadius(lpx(18))
            .border({
              width: this.isFocusExpansion ? lpx(2) : 0,
              color: Color.White,
              radius: lpx(22),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .focusable(true)
            .defaultFocus(true)
            .id('ScreenExpansion1')
            .onFocus(() => {
              this.isFocusExpansion = true
            })
            .onBlur(() => {
              this.isFocusExpansion = false
            })
            .onHover((isHover: boolean) => {
              this.isFocusExpansion = isHover
            })

            Row() {
              Row() {
                Text($r('app.string.application_to_be_launched'))
                  .height(lpx(98))
                  .fontColor(this.isFocusApplication ? Color.Black : Color.White)
                  .fontSize(lpx(36))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    left: lpx(24)
                  })

                Blank()

                Image($r(Ratio.resName('icon_arrow_right')))
                  .fillColor(this.isFocusApplication ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .width(lpx(24))
                  .height(lpx(48))
                  .opacity(1)
                  .objectFit(ImageFit.Fill)
                  .align(Alignment.Center)
                  .margin({ right: lpx(24) })
                  .focusable(true)
                  .focusBox({
                    strokeWidth: LengthMetrics.px(0)
                  })
              }
              .focusable(true)
              .width(this.isFocusApplication ? lpx(846) : lpx(840))
              .height(lpx(98))
              .backgroundColor(this.isFocusApplication ? 'rgba(255, 255, 255, 0.86)' :
                'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
            }
            .height(lpx(118))
            .width(lpx(868))
            .borderRadius(lpx(18))
            .border({
              width: this.isFocusApplication ? lpx(2) : 0,
              color: Color.White,
              radius: lpx(22),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .margin({
              top: lpx(24)
            })
            .focusable(true)
            .id('ScreenExpansion2')
            .onFocus(() => {
              this.isFocusApplication = true
            })
            .onBlur(() => {
              this.isFocusApplication = false
            })
            .onHover((isHover: boolean) => {
              this.isFocusApplication = isHover
              this.isFocusExpansion = false
            })
            .onTouch((event) => {
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen &&
                event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                return;
              }
            })
            .onClick(() => {
              try {
                this.getUIContext().getFocusController().requestFocus('ScreenExpansion2')
              } catch (error) {
                console.log('ScreenExpansion','定焦失败')
              }
                router.pushUrl({ url: 'pages/links/screenExpansion/Application' })
            })
          }
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
        }
        .width('48%')
        .height('100%')
        .margin({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width('48%')
          .height('100%')
      }
    }
    .height('100%')
    .width('100%')
  }
}
