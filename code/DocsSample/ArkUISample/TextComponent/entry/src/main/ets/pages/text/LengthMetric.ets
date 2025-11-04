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
// [Start Length_Metric]
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
export struct LengthMetric {
  @State message: string = 'This is a long text with extra long sections folded and labeled before and after';
  @State frontTag: string = 'Front label';
  @State backTag: string = 'Post label';
  @State frontPaddingVp: number = 20;
  @State backPaddingVp: number = 10;
  @State fontTagWidthVp: Length = 0;
  @State backTagWidthVp: Length = 0;
  @State backOffsetVpX: Length = 0;
  @State backOffsetVpY: Length = 0;
  @State messageLines: number = 0;
  @State stackWidthVp: number = 300;

  // 显示之前，测算前后标签的位置，中间文本的缩进距离
  aboutToAppear(): void {
    // 计算前标签的宽度fontTagWidthVp，作为message的首行缩进距离
    let frontTagSize: SizeOptions = this.getUIContext().getMeasureUtils().measureTextSize({
      textContent: this.frontTag,
    });
    this.fontTagWidthVp = this.getUIContext().px2vp(Number(frontTagSize.width)) + this.frontPaddingVp * 2

    // 计算frontTag+message占据的行数
    let linesFrontTagPlusMessage = 0;
    let mutableStr = new MutableStyledString(this.message,
      [{
        start: 0,
        length: 1,
        styledKey: StyledStringKey.PARAGRAPH_STYLE,
        styledValue: new ParagraphStyle({ textIndent: LengthMetrics.vp(this.fontTagWidthVp) })
      }]
    )
    let paragraphArr = this.getUIContext()
      .getMeasureUtils()
      .getParagraphs(mutableStr, { constraintWidth: LengthMetrics.vp(this.stackWidthVp) });
    for (let i = 0; i < paragraphArr.length; ++i) {
      linesFrontTagPlusMessage += paragraphArr[i].getLineCount();
    }

    // 后标签offsetX的偏移量backOffsetVpX=frontTag+message最后一行的宽度
    this.backOffsetVpX =
      this.getUIContext().px2vp((paragraphArr[paragraphArr.length-1].getLineWidth(linesFrontTagPlusMessage - 1)))
    // 后标签offsetY的偏移量backOffsetVpY=frontTag+message总高度-最后一行的高度。
    let heightFrontTagPlusMessageVp = 0;
    for (let i = 0; i < paragraphArr.length; ++i) {
      heightFrontTagPlusMessageVp += this.getUIContext().px2vp(paragraphArr[i].getHeight());
    }
    let lastLineHeight =
      this.getUIContext().px2vp(paragraphArr[paragraphArr.length-1].getLineHeight(linesFrontTagPlusMessage - 1))
    this.backOffsetVpY = heightFrontTagPlusMessageVp - lastLineHeight
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Blank()
          .height(200)
        Stack() {
          Text(this.frontTag)
            .padding({ left: this.frontPaddingVp, right: this.frontPaddingVp })
            .backgroundColor('rgb(39, 135, 217)')
          Text(this.message)
            .textIndent(this.fontTagWidthVp)
            .padding(0)
          Text(this.backTag)
            .padding({ left: this.backPaddingVp, right: this.backPaddingVp })
            .backgroundColor('rgb(0, 74, 175)')
            .offset({
              x: this.backOffsetVpX,
              y: this.backOffsetVpY
            })
        }
        .alignContent(Alignment.TopStart) // 顶部起始端对齐
        .width(this.stackWidthVp)
      }
      .height('100%')
      .width('90%')
      .padding('5%')
    }.backgroundColor('#f1f 2f3')
    .title($r('app.string.Length_Metric'))
  }
}

// [End Length_Metric]