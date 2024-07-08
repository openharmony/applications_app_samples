/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import image from '@ohos.multimedia.image';
import drawing from '@ohos.graphics.drawing';
import font from '@ohos.font';
import { text } from '@kit.ArkGraphics2D';

class TextViewModel {
  public type: number = 0;
  public content: string = '';
  public fontSize: number = 0;
  public fontColor: Color = Color.Black;
  public width: number = 0;
  public height: number = 0;
}

class Results {
  public index: number = 0;
  public lineCount: number = 0;
}

@Entry
@Component
struct TextCollapseTest {
  @State suffixStr: string = '';
  @State suffixStr2: string = '';
  EXPAND_STR: string = this.resourceToString($r('app.string.expand_str'));
  COLLAPSE_STR: string = this.resourceToString($r('app.string.collapse_str'));

  expanded: Boolean = true;
  needProcess: boolean = true;
  lineCount: number = 0;
  collapseIndex: number = 0;
  @State pixelMap: image.PixelMap | undefined = undefined;

  originViewModelList: TextViewModel[] = [
    {
      type: 0,
      content: this.resourceToString($r('app.string.list_content1')),
      fontSize: 8,
      fontColor: Color.Black,
      width: 0,
      height: 0
    },
    {
      type: 0,
      content: this.resourceToString($r('app.string.list_content2')),
      fontSize: 12,
      fontColor: Color.Black,
      width: 0,
      height: 0
    },
    {
      type: 1,
      content: 'app.media.icon',
      fontSize: 12,
      fontColor: Color.Black,
      width: 20,
      height: 20
    },
    {
      type: 0,
      content: this.resourceToString($r('app.string.list_content3')),
      fontSize: 12,
      fontColor: Color.Black,
      width: 0,
      height: 0
    },
    {
      type: 1,
      content: 'app.media.icon',
      fontSize: 12,
      fontColor: Color.Black,
      width: 20,
      height: 20
    },
  ]
  collapseViewModelList: TextViewModel[] = []
  @State textViewModelList: TextViewModel[] = []

  aboutToAppear(): void {
    this.getResultFromNdk();
    this.process();

    font.registerFont({  // 自定义字体
      familyName: 'stxingka123',
      familySrc: $rawfile('STXINGKA.ttf')  // rawfile下
    })
  }

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  layoutText() {
    const color: ArrayBuffer = new ArrayBuffer(160000);
    let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } };
    this.pixelMap = image.createPixelMapSync(color, opts);
    let canvas = new drawing.Canvas(this.pixelMap);
    let myTextStyle: text.TextStyle = {
      color: {
        alpha: 255,
        red: 255,
        green: 0,
        blue: 0
      },
      fontSize: 33,
    };
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
      align: 3,
    }
    let fontCollection = text.FontCollection.getGlobalInstance();
    let paragraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    paragraphGraphBuilder.pushStyle(myTextStyle);
    paragraphGraphBuilder.addText('12312');
    paragraphGraphBuilder.pushStyle(myTextStyle);
    paragraphGraphBuilder.addText('afdsss');

    let paragraph = paragraphGraphBuilder.build();
    paragraph.layoutSync(100);
    let maxWidth = paragraph.getMaxWidth();
    let height = paragraph.getHeight();
    let longestLine = paragraph.getLongestLine();
    let minIntrinsicWidth = paragraph.getMinIntrinsicWidth();
    let maxIntrinsicWidth = paragraph.getMaxIntrinsicWidth();
    let alphabeticBaseline = paragraph.getAlphabeticBaseline();
    let ideographicBaseline = paragraph.getIdeographicBaseline();
    let range: text.Range = { start: 0, end: 1 };
    let rects = paragraph.getRectsForRange(range, text.RectWidthStyle.TIGHT, text.RectHeightStyle.TIGHT);
    let placeholderRects = paragraph.getRectsForPlaceholders();
    let positionWidthAffinity = paragraph.getGlyphPositionAtCoordinate(0, 0);
    let wordRange = paragraph.getWordBoundary(0);
    let lineCount = paragraph.getLineCount();
    if (lineCount > 0) {
      let lineHeight = paragraph.getLineHeight(0);
      let lineWidth = paragraph.getLineWidth(0);
    }
    let didExceed = paragraph.didExceedMaxLines();
    let lines = paragraph.getTextLines();
    paragraph.paint(canvas, 0, 0);
  }

  GetSumbleLen() {
    let myTextStyle: text.TextStyle = {
      fontSize: 12*3.25,
    };
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
    };
    let fontCollection = new text.FontCollection();
    let paragraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    paragraphGraphBuilder.pushStyle(myTextStyle);
    paragraphGraphBuilder.addText(this.EXPAND_STR);
    let paragraph = paragraphGraphBuilder.build();
    paragraph.layoutSync(200*3.25);
    return paragraph.getLineWidth(0);
  }

  getFoldIndex() {
    let myTextStyle: text.TextStyle = {
      color: {
        alpha: 255,
        red: 255,
        green: 0,
        blue: 0
      }
    };
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
    };
    let fontCollection = text.FontCollection.getGlobalInstance();
    fontCollection.loadFontSync('123222', $rawfile('FZBWKSJW.TTF'));
    let paragraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    for (let i = 0; i < 5; i++) {
      let ret: TextViewModel = this.originViewModelList[i];
      let type: number = ret.type;
      let content: string = ret.content;
      let fontSize: number = ret.fontSize;
      let width: number = ret.width;
      let height: number = ret.height;

      if (type == 0) {
        myTextStyle.fontSize = fontSize * 3.25;
        paragraphGraphBuilder.pushStyle(myTextStyle);
        paragraphGraphBuilder.addText(content);
      } else if (type == 1) {
        let myPlaceholderSpan: text.PlaceholderSpan = {
          width: width * 3.25,
          height: height * 3.25,
          align: text.PlaceholderAlignment.ABOVE_BASELINE,
          baseline: text.TextBaseline.ALPHABETIC,
          baselineOffset: 0
        };
        paragraphGraphBuilder.addPlaceholder(myPlaceholderSpan);
      }
    }
    let paragraph = paragraphGraphBuilder.build();
    paragraph.layoutSync(650);
    let curWidth = this.GetSumbleLen();
    let i: number = 53;
    if (paragraph.getLineCount() > 2) {
      let x = 650 - curWidth;
      let y = paragraph.getLineHeight(0) + paragraph.getLineHeight(1)/2;
      let positionWithAffinity = paragraph.getGlyphPositionAtCoordinate(x, y);
      if (positionWithAffinity.affinity == text.Affinity.UPSTREAM) {
        i = positionWithAffinity.position;
      } else {
        i = positionWithAffinity.position + 1;
      }
    }

    const color: ArrayBuffer = new ArrayBuffer(650 * 300 * 4);
    let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: 300, width: 650 } }
    this.pixelMap = image.createPixelMapSync(color, opts);
    let canvas = new drawing.Canvas(this.pixelMap);
    paragraph.paint(canvas, 0, 0);

    let ret: Results = {
      index: i,
      lineCount: paragraph.getLineCount(),
    }
    return ret;
  }

  getResultFromNdk(): void {
    let result: Results = this.getFoldIndex();
    console.log('GetFoldIndex result: ' + JSON.stringify(result));
    this.lineCount = result.lineCount;
    this.collapseIndex = result.index;
    if (this.lineCount <= 2) {
      this.needProcess = false;
      this.textViewModelList = this.originViewModelList;
      return;
    }
    // 裁剪
    let currentIndex = 0;
    for (let i = 0; i < this.originViewModelList.length; i++) {
      let viewModel: TextViewModel = JSON.parse(JSON.stringify(this.originViewModelList[i]));
      if (viewModel.type === 0) {
        currentIndex += viewModel.content.length;
      } else if (viewModel.type === 1) {
        currentIndex += 1;
      }
      if (currentIndex < this.collapseIndex) {
        this.collapseViewModelList.push(viewModel);
      } else {
        if (viewModel.type === 1) {
          break;
        }
        let subLen = this.collapseIndex - (currentIndex - viewModel.content.length);
        viewModel.content = viewModel.content.substring(0, subLen - 1);
        this.collapseViewModelList.push(viewModel);
        break;
      }
    }
  }

  process(): void {
    if (this.expanded) {
      this.collapseText();
    } else {
      this.expandText();
    }
  }

  // 展开文本
  expandText(): void {
    if (!this.needProcess) {
      return;
    }
    this.expanded = true;
    this.textViewModelList = this.originViewModelList;
    this.suffixStr = this.COLLAPSE_STR;
    this.suffixStr2 = '';
  }

  // 收起文本
  collapseText(): void {
    if (!this.needProcess) {
      return;
    }
    this.expanded = false;
    this.textViewModelList = this.collapseViewModelList;
    this.suffixStr = this.EXPAND_STR;
    this.suffixStr2 = this.EXPAND_STR;
  }
  build() {
    Row() {
      Column() {
        Text() {
          ForEach(this.textViewModelList, (item: TextViewModel) => {
            if (item.type === 0) {
              Span(item.content)
                .fontSize(item.fontSize)
                .fontColor(item.height)
            } else if (item.type === 1) {
              ImageSpan($r(item.content))
                .height(item.height)
                .width(item.width)
            }
          })
          if (this.needProcess) {
            if (this.suffixStr == this.COLLAPSE_STR) {
              Span('\n');
            }
            Span(this.suffixStr)
              .fontColor(Color.Orange)
              .id('span_click')
              .onClick(() => {
                this.process();
              })
          }
        }
        .width('640px')
        .borderWidth(1)
        .id('text_click')
        .onClick(() => {
          this.process();
        })

        Image(this.pixelMap)
          .width('640px')
          .height('300px')
          .borderWidth(1)
          .margin(50)
      }
      .width('100%')
    }
    .height('100%')
  }
}