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
import { log } from '@ohos/utilslibrary'
import { PlayerBtnsType, VideoSettingBtnsType } from '../const/Type'
import { getTimeStr } from '../utils/Utils';
import { curves } from '@kit.ArkUI';
import { Constants } from '../const/Constants';

const BUTTON_ACTIVE_SIZE: string = '85lpx';
const BUTTON_NORMAL_SIZE: string = '70lpx';
const FOCUSECOLOR = 'rgba(255,255,255,0.2)'
const BORDERADIUS = 8
const ITEM_FONT_SIZE = '22lpx'

@Component
export struct VideoControllerVertical {
  handleControlKeyEvent: Function = (e: KeyEvent, item: PlayerBtnsType) => {};
  handleSettingKeyEvent: Function = (e: KeyEvent, item: VideoSettingBtnsType, ind: number) => {};
  handleSettingTouchEvent: Function = (e: TouchEvent, ind: number) => {};

  playerBtns: Array<PlayerBtnsType> = [];
  videoSettingBtns: VideoSettingBtnsType[] = [];

  @Link currentTime: number;
  @Link totalTime: number;
  @Link screenW: number;

  @Link isPlaying: boolean;
  @Link focusId: string;
  @Link isTransferDialogShow: boolean;
  @Link settingBtnsShow: boolean; // 设置视频属性弹窗是否显示隐藏
  @Link isBarShow: boolean;

  build() {
    if (this.isBarShow) {
      Column() {
        Blank().layoutWeight(1)

        // 进度条
        Row() {
          // 当前播放时间
          Text(getTimeStr(this.currentTime || 0))
            .fontSize('14lpx')
            .fontColor(Color.White)
            .width('70lpx')
            .textAlign(TextAlign.End)
            .padding({ right: '5lpx' })
          // 进度条
          Slider({
            value: this.currentTime || 0,
            min: 0,
            max: this.totalTime,
            style: SliderStyle.OutSet
          })
            .focusable(false)
            .blockSize({ width: '12lpx', height: '12lpx' })
            .showTips(true)
            .trackColor('#ff646a6e')
            .selectedColor('#FFFFFF')
            .width(`${this.screenW - 140}lpx`)
            .height('30lpx')
            .borderRadius('2lpx')
            .zIndex(1)

          // 视频总时间
          Text(getTimeStr(this.totalTime || 0))
            .fontSize('14lpx')
            .fontColor(Color.White)
            .width('70lpx')
            .textAlign(TextAlign.Start)
            .padding({ left: '5lpx' })
        }
        .width('100%')
        .height('50lpx')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)

        // 设置按钮
        Row() {
          // 分辨率、倍速、声道、音轨切换、画面尺寸
          ForEach(this.videoSettingBtns, (item: VideoSettingBtnsType, ind) => {
            Stack() {
              Row() {
                Text(`${item.name}`)
                  .fontSize(ITEM_FONT_SIZE)
                  .textAlign(TextAlign.Center)
                  .fontColor(Color.White)
                  .width('154lpx')
                  .height('50lpx')
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
              }
              .backgroundColor(this.focusId == item.id ? FOCUSECOLOR : Color.Transparent)
              .border({
                color: Color.Transparent,
                radius: BORDERADIUS
              })
              .zIndex(1)
              .width('166lpx')
              .height('66lpx')
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)


              Text('')
                .zIndex(2)
                .width('170lpx')
                .height('68lpx')
                .focusable(true)
                .focusOnTouch(true)
                .defaultFocus(item.id == this.focusId)
                .key(item.id)
                .id(item.id)
                .onFocus(() => {
                  this.focusId = item.id;
                  this.settingBtnsShow = false;
                })
                .onKeyEvent(e => {
                  this.handleSettingKeyEvent(e, item, ind);
                })
                .onTouch((e) => {
                  this.handleSettingTouchEvent(e, ind);
                })
            }
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent
                })
              }
            })
            .width('170lpx')
            .height('68lpx')
            .margin({
              left: '0lpx',
              right: '34lpx',
              top: '8lpx',
              bottom: '8lpx'
            })
          }, (item: VideoSettingBtnsType, ind) => {
            return item.id + ind;
          })
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100lpx')

        // 操作栏
        Row() {
          // 停止、播放、暂停、上一个、下一个、分布式流转
          ForEach(this.playerBtns, (item: PlayerBtnsType, ind) => {
            Stack() {
              Row() {
                if (ind == 2) {
                  Image(this.isPlaying
                    ?
                    item.id == this.focusId ? $rawfile('ic_pause_active.svg') : item.activeImg
                    :
                    item.id == this.focusId ? $rawfile('ic_play_active.svg') : item.defaultImg)
                    .width(item.id == this.focusId ? BUTTON_ACTIVE_SIZE : BUTTON_NORMAL_SIZE)
                    .height(item.id == this.focusId ? BUTTON_ACTIVE_SIZE : BUTTON_NORMAL_SIZE)

                } else {
                  Image(item.id == this.focusId ? item.activeImg : item.defaultImg)
                    .width(item.id == this.focusId ? BUTTON_ACTIVE_SIZE : BUTTON_NORMAL_SIZE)
                    .height(item.id == this.focusId ? BUTTON_ACTIVE_SIZE : BUTTON_NORMAL_SIZE)

                }
              }
              .zIndex(1)
              .width(BUTTON_ACTIVE_SIZE)
              .height(BUTTON_ACTIVE_SIZE)
              .justifyContent(FlexAlign.Center)

              Text('')
                .zIndex(2)
                .width(BUTTON_ACTIVE_SIZE)
                .height(BUTTON_ACTIVE_SIZE)
                .defaultFocus(item.id === this.focusId)
                .focusable(true)
                .focusOnTouch(true)
                .key(item.id)
                .id(item.id)
                .onFocus(() => {
                  this.focusId = item.id;
                  this.isTransferDialogShow = false
                })
                .onKeyEvent(e => {
                  this.handleControlKeyEvent(e, item);
                  e.stopPropagation();
                })
                .onClick(()=>{
                  item.onclick()
                })
            }
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent
                })
              }
            })
            .width('150lpx')
            .height(BUTTON_ACTIVE_SIZE)
          }, (item: PlayerBtnsType, ind) => {
            return item.id + ind;
          })
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height(BUTTON_ACTIVE_SIZE)

        Blank().height(`10lpx`)
      }
      .transition(
        TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.BOTTOM).animation({
          duration: 200,
          curve: Curve.EaseOut
        }),
        TransitionEffect.move(TransitionEdge.BOTTOM)).animation({
          duration: 400,
          curve: Curve.EaseIn
        })
      )
      .width('100%')
      .height('100%')
    }
  }
}