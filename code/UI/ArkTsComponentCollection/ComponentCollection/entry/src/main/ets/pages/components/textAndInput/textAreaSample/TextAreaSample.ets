/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import ShowToast from '../../../../util/ShowToast';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { textAreaControlPanel } from './ChangePanel';
import Logger from '../../../../util/Logger';

@Extend(Column) function cardStyle() {
  .borderRadius(16)
  .backgroundColor($r('app.color.white'))
  .width('100%')
  .padding(12)
}

@Entry
@Component
struct TextAreaSample {
  @State textAreaSet: string = '';
  @State placeholderColor: Color = Color.Blue;
  @State textAlign: TextAlign = TextAlign.Start;
  @State caretColor: Color = Color.Blue;
  @State copyOptions: CopyOptions = CopyOptions.None;
  @State isLimit: boolean = false;
  @State customTextStr: string = 'TextArea Custom Menu TextArea Custom Menu TextArea Custom Menu';
  controller: TextAreaController = new TextAreaController();

  onCreateMenu(menuItems: Array<TextMenuItem>) {
    menuItems.forEach((value, index) => {
      value.icon = $r('app.media.icon');
      if (value.id.equals(TextMenuItemId.COPY)) {
        value.content = 'copy change';
      }
      if (value.id.equals(TextMenuItemId.SELECT_ALL)) {
        value.content = 'select_all change';
      }
    });
    let item1: TextMenuItem = {
      content: 'custom1',
      icon: $r('app.media.icon'),
      id: TextMenuItemId.of('custom1'),
    };
    let item2: TextMenuItem = {
      content: 'custom2',
      id: TextMenuItemId.of('custom2'),
      icon: $r('app.media.icon'),
    };
    menuItems.push(item1);
    menuItems.unshift(item2);
    return menuItems;
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.textarea_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.textarea_show') })
          TextArea({
            text: this.textAreaSet,
            placeholder: 'This textArea can contain more than one line, please input your word.',
            controller: this.controller
          })
            .id(`textarea_001`)
            .placeholderColor(this.placeholderColor)
            .placeholderFont({ size: 20, weight: 400 })
            .backgroundColor($r('app.color.white'))
            .textAlign(this.textAlign)
            .caretColor(this.caretColor)
            .copyOption(this.copyOptions)
            .borderRadius(16)
            .width('100%')
            .height(80)
            .fontSize(20)
            .enableKeyboardOnFocus(false)
            .maxLength(this.isLimit ? 100 : undefined)
            .showCounter(this.isLimit, { thresholdPercentage: 1, highlightBorder: true })
            .onChange(() => {
              ShowToast.shortToast('The input have changed.');
            })
            .onCopy(() => {
              ShowToast.shortToast('copy');
            })
            .onCut(() => {
              ShowToast.shortToast('cut');
            })
            .onPaste(() => {
              ShowToast.shortToast('paste');
            })
          IntroductionTitle({ introduction: $r('app.string.textarea_control') })
          Column() {
            textAreaControlPanel({
              placeholderColor: $placeholderColor,
              textAlign: $textAlign,
              caretColor: $caretColor,
              copyOption: $copyOptions,
            })
          }.cardStyle()

          Row() {
            Text($r('app.string.textarea_character_limit'))
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: this.isLimit })
              .onChange((isOn) => {
                this.isLimit = isOn;
              })
              .id('textarea_character_limit')
          }
          .width('100%')
          .borderRadius(24)
          .height(56)
          .backgroundColor(Color.White)
          .padding({ left: 12, right: 18 })
          .margin({ left: 12, right: 12, top: 12 })

          // 文本自定义菜单
          IntroductionTitle({ introduction: $r('app.string.text_custom_menu') })
          TextArea({ text: this.customTextStr, controller: this.controller })
            .id('text_area_custom_menu')
            .copyOption(CopyOptions.LocalDevice)
            .borderRadius(16)
            .width('100%')
            .height(80)
            .fontSize(20)
            .backgroundColor($r('app.color.white'))
            .editMenuOptions({
              onCreateMenu: this.onCreateMenu, onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
                if (menuItem.id.equals(TextMenuItemId.of('custom2'))) {
                  Logger.info(`intercept id: custom2 start: ${textRange.start}, end: ${textRange.end}`);
                  return true;
                }
                if (menuItem.id.equals(TextMenuItemId.COPY)) {
                  Logger.info(`intercept COPY start: ${textRange.start}, end: ${textRange.end}`);
                  return true;
                }
                if (menuItem.id.equals(TextMenuItemId.SELECT_ALL)) {
                  Logger.info(`non-intercept SELECT_ALL start: ${textRange.start}, end: ${textRange.end}`);
                  return false;
                }
                return false;
              }
            })
        }
        .width('100%')
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 100 })
    }
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
  }
}