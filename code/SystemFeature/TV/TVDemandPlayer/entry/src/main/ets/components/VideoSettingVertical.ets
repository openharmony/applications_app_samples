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
import { log } from '@ohos/utilslibrary';
import { Constants } from '../const/Constants';
import { ItemsType } from '../const/Type'
import { EventUtil } from '../utils/EventUtil';

@Component
export struct VideoSettingVertical {
  handleSubSettingKeyEvent: Function = (e: KeyEvent, t: ItemsType, i: number) => {};
  handleSubSettingTouchEvent: Function = (e: TouchEvent, t: ItemsType) => {};

  @Link activeSettingBtnId: string;
  @Link settingBtnsShow: boolean;
  @Link activeSettingBtnIndex: number;

  activeSettingBtns: ItemsType[] = [];

  build() {
    Column() {
      Blank().layoutWeight(1);

      Column({ space: '7lpx' }) {
        ForEach(this.activeSettingBtns, (t: ItemsType, i) => {
          Stack({ alignContent: Alignment.Center }) {
            Row() {
              Text(`${t.name}`)
                .fontSize(t.id == this.activeSettingBtnId ? '32lpx' : '29lpx')
                .textAlign(TextAlign.Center)
                .fontColor(t.id == this.activeSettingBtnId ? '#ff2d2d2d' : '#ffffffff')
                .width(t.id == this.activeSettingBtnId ? '138lpx' : '128lpx')
                .height('50lpx')
                .borderRadius(globalThis.lpiPx(6))
            }
            .zIndex(1)
            .width(t.id == this.activeSettingBtnId ? '138lpx' : '128lpx')
            .height('50lpx')
            .borderWidth(t.id == this.activeSettingBtnId ? '3lpx' : '0lpx')
            .borderRadius(globalThis.lpiPx(6))
            .borderStyle(BorderStyle.Solid)
            .borderColor('#555555')
            .backgroundColor(t.id == this.activeSettingBtnId ? '#ffffffff' : '#555555')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)

            Text('')
              .zIndex(2)
              .width('142lpx')
              .height('54lpx')
              .focusable(true)
              .focusOnTouch(true)
              .defaultFocus(t.id == this.activeSettingBtnId)
              .key(t.id)
              .id(t.id)
              .onFocus(() => {
                log(`settingBtns Text onFocus`);
                this.activeSettingBtnId = t.id;
              })
              .onKeyEvent(e => {
                this.handleSubSettingKeyEvent(e, t, i);
                e.stopPropagation();
              })
              .onTouch(e => {
                this.handleSubSettingTouchEvent(e, t);
              })
          }
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })
          .width(t.id == this.activeSettingBtnId ? '142lpx' : '128lpx')
          .height(t.id == this.activeSettingBtnId ? '54lpx' : '50lpx')
          .borderWidth('0lpx')
          .borderRadius(globalThis.lpiPx(6))
          .backgroundColor(t.id == this.activeSettingBtnId ? '#ffffffff' : '#454B52')
          .alignContent(Alignment.Center)
        })
      }
      .width('100%')
      .height(`${this.activeSettingBtns.length * 61}lpx`)
      .backgroundColor('#0000ffa1')
      .focusable(true)
      .stateStyles({
        focused: {
          .border({
            color: Color.Transparent
          })
        }
      })
      .onAppear(() => {
        focusControl.requestFocus(this.activeSettingBtnId)
      })
      .onFocus(() => {
      })
      .padding({ left: `${200 * this.activeSettingBtnIndex + 150}lpx`})
      .onTouch((e) => {
        e.stopPropagation();
      })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)

      Blank().height('230lpx');
    }
    .width('100%')
    .height('100%')
  }
}