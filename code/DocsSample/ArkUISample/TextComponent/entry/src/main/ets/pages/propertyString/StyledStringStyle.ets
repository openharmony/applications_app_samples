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
import { LengthMetrics, LengthUnit } from '@kit.ArkUI';
import resource from '../../common/resource';

@Entry
@Component
export struct StyledStringStyle {
  textStyleAttrs: TextStyle = new TextStyle({
    fontWeight: FontWeight.Bolder,
    fontSize: LengthMetrics.vp(24),
    fontStyle: FontStyle.Italic
  });

  mutableStyledString1: MutableStyledString =
    new MutableStyledString(resource.resourceToString($r('app.string.StyledStringStyle_Text_1')), [
    {
      start: 2,
      length: 2,
      styledKey: StyledStringKey.FONT,
      styledValue: this.textStyleAttrs
    },
    {
      start: 7,
      length: 4,
      styledKey: StyledStringKey.FONT,
      styledValue: new TextStyle({ fontColor: Color.Orange, fontSize: LengthMetrics.vp(12) })
    }
  ]);
  mutableStyledString2: MutableStyledString =
    new MutableStyledString(resource.resourceToString($r('app.string.StyledStringStyle_Text_2')), [
    {
      start: 0,
      length: 3,
      styledKey: StyledStringKey.TEXT_SHADOW,
      styledValue: new TextShadowStyle({
        radius: 5,
        type: ShadowType.COLOR,
        color: Color.Red,
        offsetX: 10,
        offsetY: 10
      })
    }
  ]);
  mutableStyledString3: MutableStyledString =
    new MutableStyledString(resource.resourceToString($r('app.string.StyledStringStyle_Text_3')), [
    {
      start: 0,
      length: 3,
      styledKey: StyledStringKey.DECORATION,
      styledValue: new DecorationStyle({ type: TextDecorationType.LineThrough, color: Color.Red })
    }
  ]);
  mutableStyledString4: MutableStyledString =
    new MutableStyledString(resource.resourceToString($r('app.string.StyledStringStyle_Text_4')), [
    {
      start: 0,
      length: 3,
      styledKey: StyledStringKey.BASELINE_OFFSET,
      styledValue: new BaselineOffsetStyle(LengthMetrics.px(20))
    }
  ]);
  mutableStyledString5: MutableStyledString =
    new MutableStyledString(resource.resourceToString($r('app.string.StyledStringStyle_Text_5')), [
    {
      start: 8,
      length: 3,
      styledKey: StyledStringKey.LINE_HEIGHT,
      styledValue: new LineHeightStyle(LengthMetrics.vp(50))
    }
  ]);
  mutableStyledString6: MutableStyledString =
    new MutableStyledString(resource.resourceToString($r('app.string.StyledStringStyle_Text_6')), [
    {
      start: 0,
      length: 2,
      styledKey: StyledStringKey.LETTER_SPACING,
      styledValue: new LetterSpacingStyle(new LengthMetrics(20, LengthUnit.VP))
    }
  ]);

  controller1: TextController = new TextController();
  controller2: TextController = new TextController();
  controller3: TextController = new TextController();
  controller4: TextController = new TextController();
  controller5: TextController = new TextController();
  controller6: TextController = new TextController();

  async onPageShow() {
    this.controller1.setStyledString(this.mutableStyledString1);
    this.controller2.setStyledString(this.mutableStyledString2);
    this.controller3.setStyledString(this.mutableStyledString3);
    this.controller4.setStyledString(this.mutableStyledString4);
    this.controller5.setStyledString(this.mutableStyledString5);
    this.controller6.setStyledString(this.mutableStyledString6);
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.StyledStringStyle_title_1') }) {
          // [Start styled_string_text_style]
          Text(undefined, { controller: this.controller1 })
            .id('1')
            .margin({ top: 10 })
          // [End styled_string_text_style]
        }
        ComponentCard({ title: $r('app.string.StyledStringStyle_title_2') }) {
          // [Start styled_string_text_shadow_style]
          Text(undefined, { controller: this.controller2 }).id('2')
          // [End styled_string_text_shadow_style]
        }
        ComponentCard({ title: $r('app.string.StyledStringStyle_title_3') }) {
          // [Start styled_string_decoration_style]
          Text(undefined, { controller: this.controller3 }).id('3')
          // [End styled_string_decoration_style]
        }
        ComponentCard({ title: $r('app.string.StyledStringStyle_title_4') }) {
          // [Start styled_string_baseline_offset_style]
          Text(undefined, { controller: this.controller4 }).id('4')
          // [End styled_string_baseline_offset_style]
        }
        ComponentCard({ title: $r('app.string.StyledStringStyle_title_5') }) {
          // [Start styled_string_line_height_style]
          Text(undefined, { controller: this.controller5 }).id('5')
          // [End styled_string_line_height_style]
        }
        ComponentCard({ title: $r('app.string.StyledStringStyle_title_6') }) {
          // [Start styled_string_letter_spacing_style]
          Text(undefined, { controller: this.controller6 }).id('6')
          // [End styled_string_letter_spacing_style]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.StyledStringStyle_title'))
  }
}