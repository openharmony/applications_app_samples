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
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

/**
 * 步骤提示按钮
 */
@Preview
@Component
export struct TipButton {
  btnStyle?: BtnStyle;

  build() {
    Button(
      this.btnStyle?.btnRes,
      { type: ButtonType.Capsule, stateEffect: true }
    )
      .onClick(() => {
        this.btnStyle?.clickEvent?.();
      })
      .focusable(true)
      .fontColor(this.btnStyle?.fontColor ?? Color.White)
      .fontSize(this.btnStyle?.fontSize ?? $r('app.string.font_16'))
      .width(this.btnStyle?.width ?? $r('app.string.tip_button_width'))
      .height(this.btnStyle?.height ?? $r('app.string.btn_height'))
      .backgroundColor(this.btnStyle?.backgroundColor ?? $r('app.color.add_text_color'))
      .borderRadius($r('app.string.btn_height'))
      .focusBox({
        margin: LengthMetrics.lpx(5),
        strokeColor: ColorMetrics.resourceColor($r('app.color.add_text_color')),
        strokeWidth: LengthMetrics.lpx(2)
      });
  }
}

interface BtnStyle {
  btnRes: ResourceStr;
  clickEvent?: () => void;
  fontColor?: ResourceColor;
  fontSize?: Length;
  backgroundColor?: ResourceColor;
  width?: Length;
  height?: Length;
}