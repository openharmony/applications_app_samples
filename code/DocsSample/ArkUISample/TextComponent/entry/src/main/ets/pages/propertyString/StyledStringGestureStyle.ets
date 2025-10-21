/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ComponentCard } from '../../common/Card';
import { drawing } from '@kit.ArkGraphics2D';

let gUIContext: UIContext;

class MyCustomSpan extends CustomSpan {
  constructor(word: string, width: number, height: number, fontSize: number) {
    super();
    this.word = word;
    this.width = width;
    this.height = height;
    this.fontSize = fontSize;
  }

  onMeasure(measureInfo: CustomSpanMeasureInfo): CustomSpanMetrics {
    return { width: this.width, height: this.height };
  }

  onDraw(context: DrawContext, options: CustomSpanDrawInfo) {
    let canvas = context.canvas;

    const brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 0,
      green: 0,
      blue: 0
    });
    const font = new drawing.Font();
    font.setSize(gUIContext.vp2px(this.fontSize));
    const textBlob =
      drawing.TextBlob.makeFromString(this.word.substring(0, 5), font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachBrush(brush);

    this.onDrawRectByRadius(context, options.x, options.x + gUIContext.vp2px(this.width), options.lineTop,
      options.lineBottom, 20);
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 255,
      blue: 255
    });
    canvas.attachBrush(brush);
    canvas.drawTextBlob(textBlob, options.x, options.lineBottom - 30);
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 228,
      blue: 196
    });
    canvas.attachBrush(brush);
    const textBlob1 =
      drawing.TextBlob.makeFromString(this.word.substring(5), font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob1, options.x + gUIContext.vp2px(100), options.lineBottom - 30);

    canvas.detachBrush();
  }

  onDrawRectByRadius(context: DrawContext, left: number, right: number, top: number, bottom: number, radius: number) {
    let canvas = context.canvas;
    let path = new drawing.Path();

    // 画带radius的rect
    path.moveTo(left + radius, top);
    path.lineTo(right - radius, top);
    path.arcTo(right - 2 * radius, top, right, top + 2 * radius, 270, 90);
    path.lineTo(right, bottom - radius);
    path.arcTo(right - 2 * radius, bottom - 2 * radius, right, bottom, 0, 90);

    path.lineTo(left + 2 * radius, bottom);
    path.arcTo(left, bottom - 2 * radius, left + 2 * radius, bottom, 90, 90);
    path.lineTo(left, top + 2 * radius);
    path.arcTo(left, top, left + 2 * radius, top + 2 * radius, 180, 90);

    canvas.drawPath(path);
  }

  setWord(word: string) {
    this.word = word;
  }

  public  width: number = 160;
  public word: string = 'drawing';
  public height: number = 10;
  public fontSize: number = 16;
}

@Entry
@Component
export struct StyledStringGestureStyle {
  customSpan3: MyCustomSpan = new MyCustomSpan('99VIP88%off', 200, 40, 30);
  textStyle: MutableStyledString = new MutableStyledString('123');
  textController: TextController = new TextController();
  isPageShow: boolean = true;

  aboutToAppear() {
    gUIContext = this.getUIContext();
  }

  async onPageShow() {
    if (!this.isPageShow) {
      return;
    }
    this.isPageShow = false;
    this.textController.setStyledString(new StyledString(this.customSpan3));
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.TStyledStringGestureStyle_title') }) {
          // [Start styled_string_gesture_style]
          Row() {
            Column() {
              Text(undefined, { controller: this.textController })
                .id('text1')
                .copyOption(CopyOptions.InApp)
                .fontSize(30)
            }
            .width('100%')
          }
          .height('100%')
          // [End styled_string_gesture_style]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.TStyledStringGestureStyle_title'))
  }
}