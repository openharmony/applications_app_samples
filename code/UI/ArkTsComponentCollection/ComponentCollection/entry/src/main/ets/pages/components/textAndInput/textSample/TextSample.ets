/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http:// www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import measure from '@ohos.measure';
import { ChangeTextCase, ChangeTextAttribute } from './ChangePanel';
import { TitleBar } from '../../../../common/TitleBar';
import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import Logger from '../../../../util/Logger';

@Extend(Column)
function backgroundStyle() {
  .size({ width: '100%' })
  .margin({ top: 12 })
  .padding(12)
  .borderRadius(24)
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct TextSample {
  @State lineHeight: number = 23;
  @State textMaxLines: number = -1;
  @State letterSpacing: number = 2;
  @State fontColor: string = '#FF000000';
  @State textCase: TextCase = TextCase.Normal;
  @State textAlign: TextAlign = TextAlign.Start;
  @State textOverFlow: TextOverflow = TextOverflow.None;
  @State styleForDecorative: TextDecorationType = TextDecorationType.None;
  @State textContent: Resource = $r('app.string.text_content');
  @State customTextStr: string = 'Text Custom Menu';
  textSize: SizeOptions = measure.measureTextSize({
    textContent: $r('app.string.text_content'),
  });

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
      TitleBar({ title: $r('app.string.text_title') })
      Scroll() {
        Column({ space: 12 }) {
          Column() {
            Text(this.textContent)
              .height(160)
              .minFontSize(16)
              .maxFontSize(20)
              .baselineOffset(0)
              .fontColor(this.fontColor)
              .textAlign(this.textAlign)
              .lineHeight(this.lineHeight)
              .maxLines(this.textMaxLines)
              .letterSpacing(this.letterSpacing)
              .textOverflow({ overflow: this.textOverFlow })
              .decoration({ type: this.styleForDecorative })

            ChangeTextAttribute({
              fontColor: $fontColor,
              textAlign: $textAlign,
              lineHeight: $lineHeight,
              textMaxLines: $textMaxLines,
              letterSpacing: $letterSpacing,
              textOverFlow: $textOverFlow,
              styleForDecorative: $styleForDecorative,
            })

            Row() {
              Text($r('app.string.text_width'))
              Blank()
              Text(this.textSize.width!.toString() + ' px')
                .width(150)
                .fontSize(20)
                .textAlign(TextAlign.Center)

            }
            .size({ width: '100%', height: 42 })
            .padding({ left: 0, right: 0 })
            .borderRadius(0)
            .backgroundColor(Color.Transparent)

            Row() {
              Text($r('app.string.text_height'))
              Blank()
              Text(this.textSize.height!.toString() + ' px')
                .width(150)
                .fontSize(20)
                .textAlign(TextAlign.Center)
            }
            .size({ width: '100%', height: 42 })
            .padding({ left: 0, right: 0 })
            .borderRadius(0)
            .backgroundColor(Color.Transparent)
          }
          .backgroundStyle()

          // Lowercase or uppercase
          Column() {
            Text($r('app.string.text_content_en'))
              .textCase(this.textCase)
              .maxLines(5)

            ChangeTextCase({
              textCase: $textCase
            })
          }
          .backgroundStyle()

          // 文本自定义菜单
          IntroductionTitle({ introduction: $r('app.string.text_custom_menu') })
          Column(){
            Text(this.customTextStr)
              .id('text_custom_menu')
              .copyOption(CopyOptions.LocalDevice)
              .width('95%')
              .height(40)
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
          .backgroundColor(Color.White)
          .padding(12)
          .margin({ bottom: 12 })
          .borderRadius(24)
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen
      }
      .id('text_scroll')
      .margin({ bottom: 100 })
      .size({ width: '100%', height: '100%' })
      .padding({ left: 12, right: 12 })
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}