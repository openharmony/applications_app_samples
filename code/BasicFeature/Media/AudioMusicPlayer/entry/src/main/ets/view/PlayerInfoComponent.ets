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

import { BusinessError } from '@kit.BasicServicesKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import { LyricsComponent } from './LyricsComponent';
import { MusicInfoComponent } from './MusicInfoComponent';
import { ControlAreaComponent } from './ControlAreaComponent';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';
import { StyleConstants } from '../common/constants/StyleConstants';
import { PlayerConstants } from '../common/constants/PlayerConstants';
import { SongItem } from '../viewmodel/SongData';
import Logger from '../common/utils/Logger';
import { ColorConversion } from '../common/utils/ColorConversion';

const TAG = 'PlayerInfoComponent'

@Component
export struct PlayerInfoComponent {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageProp('selectIndex') @Watch('getImageColor') selectIndex: number = 0;
  @StorageLink('imageColor') imageColor: string = 'rgba(0, 0, 2, 1.00)';
  @StorageLink('topHeight') topHeight: number = 0;
  @StorageLink('bottomHeight') bottomHeight: number = 0;
  @State imageLabel: PixelMap | Resource = this.songList[this.selectIndex].label;
  @State isShowControl: boolean = true;
  @State isShowControlLg: boolean = false;
  @State isTablet: boolean = true;
  @State isTabletFalse: boolean = false;
  @StorageLink('pageShowTime') pageShowTime: number = 0;
  @State intervalID: number = 0;
  @Link isShowPlay: boolean;
  @StorageLink('isFoldFull') isFoldFull: boolean = false;
  private context: common.UIAbilityContext | undefined = AppStorage.get('context');
  private callback: Callback<display.FoldDisplayMode> = (data: display.FoldDisplayMode) => {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      if (data === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
        this.isFoldFull = true;
      } else {
        this.isFoldFull = false;
      }
    }
  };

  aboutToAppear(): void {
    Logger.info(TAG,`currentBreakpoint is ${BreakpointConstants.BREAKPOINT_SM}`)
    this.getImageColor();
    try {
      if (canIUse('SystemCapability.Window.SessionManager')) {
        let mode = display.getFoldDisplayMode();
        if (mode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
          this.isFoldFull = true;
        }
        display.on('foldDisplayModeChange', this.callback);
      }
    } catch (exception) {
      Logger.error('Failed to register callback. Code: ' + JSON.stringify(exception));
    }
  }

  aboutToDisappear(): void {
    clearInterval(this.intervalID);
    if (canIUse('SystemCapability.Window.SessionManager')) {
      display.off('foldDisplayModeChange', this.callback);
    }
  }

build() {
    Stack() {
      Image(this.imageLabel)
        .size(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
          {
            width: PlayerConstants.BACK_IMAGE
          } :
          {
            height: PlayerConstants.BACK_IMAGE
          })
        .aspectRatio(1)
        .objectFit(ImageFit.Cover)
        .opacity(0.5)
      Row() {
        if (this.isFoldFull) {
          Column() {
            GridRow({
              columns: { md: BreakpointConstants.COLUMN_MD },
              gutter: BreakpointConstants.GUTTER_MUSIC_X
            }) {
              GridCol({
                span: { md: BreakpointConstants.SPAN_SM }
              }) {
                MusicInfoComponent()
              }
              .margin({
                left: $r('app.float.margin_small'),
                right: $r('app.float.margin_small')
              })

              GridCol({
                span: { md: BreakpointConstants.SPAN_SM }
              }) {
                LyricsComponent({ isShowControl: this.isShowControlLg, isTablet: this.isTabletFalse })
              }
              .padding({
                left: $r('app.float.twenty_four')
              })
            }
            .layoutWeight(1)
            .margin({
              bottom: $r('app.float.fold_margin_bottom')
            })
          }
          .layoutWeight(1)
          .padding({
            left: $r('app.float.common_padding'),
            right: $r('app.float.common_padding')
          })
        } else if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG) {
          Column() {
            GridRow({
              columns: { md: BreakpointConstants.COLUMN_MD, lg: BreakpointConstants.COLUMN_LG },
              gutter: BreakpointConstants.GUTTER_MUSIC_X
            }) {
              GridCol({
                span: { md: BreakpointConstants.SPAN_SM, lg: BreakpointConstants.SPAN_SM },
                offset: { lg: BreakpointConstants.OFFSET_MD }
              }) {
                Column() {
                  Image(this.songList[this.selectIndex].label)
                    .width(StyleConstants.FULL_WIDTH)
                    .aspectRatio(1)
                    .borderRadius($r('app.float.cover_radius'))
                  ControlAreaComponent()
                }
                .height(StyleConstants.FULL_HEIGHT)
                .justifyContent(FlexAlign.SpaceBetween)
                .margin({
                  bottom: $r('app.float.common_margin')
                })
              }

              GridCol({
                span: { md: BreakpointConstants.SPAN_SM, lg: BreakpointConstants.SPAN_MD },
                offset: { lg: BreakpointConstants.OFFSET_MD }
              }) {
                LyricsComponent({ isShowControl: this.isShowControlLg, isTablet: this.isTablet })
              }
            }
            .layoutWeight(1)
            .padding({
              left: $r('app.float.common_padding'),
              right: $r('app.float.common_padding'),
              top: $r('app.float.lg_music_top'),
              bottom: $r('app.float.lg_music_margin_bottom')
            })
          }
        } else {
          Stack({ alignContent: Alignment.TopStart }) {
            Swiper() {
              MusicInfoComponent()
                .margin({
                  top: $r('app.float.music_component_top'),
                  bottom: $r('app.float.music_component_bottom')
                })
                .padding({
                  left: $r('app.float.common_padding'),
                  right: $r('app.float.common_padding')
                })
              LyricsComponent({ isShowControl: this.isShowControl, isTablet: this.isTabletFalse })
                .margin({
                  top: $r('app.float.margin_lyric')
                })
                .padding({
                  left: $r('app.float.common_padding'),
                  right: $r('app.float.common_padding')
                })
            }
            .id('mainSwiper')
            .height(StyleConstants.FULL_HEIGHT)
            .indicator(
              new DotIndicator()
                .top($r('app.float.options_padding'))
                .selectedColor($r('app.color.select_swiper'))
                .color($r('app.color.slider_track'))
            )
            .clip(false)
            .loop(false)
            .onChange((index: number) => {
              if (index === 1) {
                this.isShowControl = true;
                this.intervalID = setInterval(() => {
                  this.pageShowTime += 1;
                  if (this.pageShowTime > 5) {
                    this.isShowControl = false;
                    clearInterval(this.intervalID);
                  }
                }, 1000);
              } else {
                this.pageShowTime = 0;
                clearInterval(this.intervalID);
              }
            })
          }
          .height(StyleConstants.FULL_HEIGHT)
        }
      }
      .padding({
        bottom: this.bottomHeight,
        top: this.topHeight
      })
    }
    .id('playerInfoComponent')
    .height(StyleConstants.FULL_HEIGHT)
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor(this.imageColor)
  }

  /**
   * Get largest proportion color of an image.
   */
  getImageColor() {
    if (!this.context) {
      return;
    }
    ColorConversion.setSysBarLightBackground(this.songList[this.selectIndex].isDarkBackground);
    this.context.resourceManager.getMediaContent(this.songList[this.selectIndex].label.id)
      .then((value: Uint8Array) => {
        let buffer = value.buffer as ArrayBuffer;
        image.createImageSource(buffer).createPixelMap().then((pixelMap) => {
          effectKit.createColorPicker(pixelMap, (error, colorPicker) => {
            if (error) {
              Logger.error('Failed to create color picker.');
            } else {
              let color = colorPicker.getLargestProportionColor();
              let colorArr = ColorConversion.dealColor(color.red, color.green, color.blue);
              this.imageColor = `rgba(${colorArr[0]}, ${colorArr[1]}, ${colorArr[2]}, 1)`;
            }
          })
          let headFilter = effectKit.createEffect(pixelMap);
          if (headFilter !== null) {
            headFilter.blur(PlayerConstants.IMAGE_BLUR);
            headFilter.getEffectPixelMap().then((value) => {
              this.imageLabel = value;
            })
          }
        })
          .catch((error: BusinessError) => {
            Logger.error(`${error.code} + ${error.message}`);
          })
      })
      .catch((error: BusinessError) => {
        Logger.error(`${error.code} + ${error.message}`);
      })
  }
}