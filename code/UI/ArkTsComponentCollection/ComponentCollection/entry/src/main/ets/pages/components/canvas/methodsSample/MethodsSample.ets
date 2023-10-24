/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar';

interface ShowBtnType {
  name: Resource,
  func: Function
}

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Grid) function Style() {
  .columnsTemplate('1fr 1fr')
  .columnsGap(12)
  .rowsGap(12)
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .height('100%')
  .padding(15)
  .height(300)
  .align(Alignment.Center)
}

@Extend(Button) function sampleButton() {
  .width('100%')
  .height(40)
  .fontColor(Color.White)
  .alignSelf(ItemAlign.Center)
  .type(ButtonType.Capsule)
}

@Entry
@Component
struct DataPanelSample {
  scroller: Scroller = new Scroller();
  private img: ImageBitmap = new ImageBitmap('/pages/components/canvas/sampleResources/icon.png');
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private offContext: OffscreenCanvasRenderingContext2D = new OffscreenCanvasRenderingContext2D(600, 600, this.settings);
  private Btns: ShowBtnType[] = [
    {
      name: $r('app.string.canvas_fillRect'),
      func: () => {
        this.context.fillStyle = '#000000';
        this.context.fillRect(30, 30, 100, 100);
      },
    },
    {
      name: $r('app.string.canvas_strokeRect'),
      func: () => {
        this.context.fillStyle = '#000000';
        this.context.strokeRect(30, 30, 200, 150);
      },
    },
    {
      name: $r('app.string.canvas_fillText'),
      func: () => {
        this.context.font = '30px sans-serif';
        this.context.fillText('Hello World!', 20, 100);
      },
    },
    {
      name: $r('app.string.canvas_strokeText'),
      func: () => {
        this.context.font = '55px sans-serif';
        this.context.strokeText('Hello World!', 20, 60);
      },
    },
    {
      name: $r('app.string.canvas_measureText'),
      func: () => {
        this.context.font = '50px sans-serif';
        this.context.save();
        this.context.fillText('Hello World!', 20, 100);
        this.context.fillText('width:' + this.context.measureText('Hello World!').width, 20, 200);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_stroke'),
      func: () => {
        this.context.beginPath();
        this.context.fillStyle = '#000000';
        this.context.save();
        let path: Path2D = new Path2D();
        this.context.beginPath();
        path.moveTo(25, 25);
        path.lineTo(25, 105);
        path.lineTo(75, 105);
        path.lineTo(75, 25);
        this.context.strokeStyle = 'rgb(0,0,255)';
        this.context.stroke(path);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_createPattern'),
      func: () => {
        this.context.save();
        let pattern: CanvasPattern | null = this.context.createPattern(this.img, 'repeat');
        if(pattern !== null){
          this.context.fillStyle = pattern;
        }
        this.context.fillRect(0, 0, 200, 200);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_fill'),
      func: () => {
        this.context.fillStyle = '#000000';
        this.context.save();
        this.context.rect(20, 20, 100, 100); // Create a 100*100 rectangle at (20, 20)
        this.context.fill();
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_clip'),
      func: () => {
        let region = new Path2D();
        region.moveTo(30, 90);
        region.lineTo(110, 20);
        region.lineTo(240, 130);
        region.lineTo(60, 130);
        region.lineTo(190, 20);
        region.lineTo(270, 90);
        region.closePath();
        this.context.save();
        this.context.clip(region,'evenodd');
        this.context.fillStyle = 'rgb(0,255,0)';
        this.context.fillRect(0, 0, this.context.width, this.context.height);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_scale'),
      func: () => {
        this.context.fillStyle = '#000000';
        this.context.save();
        this.context.lineWidth = 3;
        this.context.strokeRect(30, 30, 50, 50);
        this.context.scale(2, 2); // Scale to 200%
        this.context.strokeRect(30, 30, 50, 50);
        this.context.scale(1, 1);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_drawImage'),
      func: () => {
        this.context.drawImage(this.img, 0, 0, 500, 500, 0, 0, 400, 200);
      },
    },


    {
      name: $r('app.string.canvas_setLineDash'),
      func: () => {
        this.context.fillStyle = '#000000';
        this.context.save();
        let path: Path2D = new Path2D();
        path.arc(100, 75, 50, 0, 6.28);
        this.context.setLineDash([10, 20]);
        this.context.stroke(path);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_getLineDash'),
      func: () => {
        this.context.fillStyle = '#000000';
        this.context.save();
        let path: Path2D = new Path2D();
        path.arc(100, 75, 50, 0, 6.28);
        this.context.setLineDash([10, 20]);
        this.context.stroke(path);
        let res = this.context.getLineDash();
        console.error(JSON.stringify(res));
        this.context.restore();
      },
    },

  ];

  build() {
    Column() {
      TitleBar({ title: $r('app.string.canvas_component_method') });
      Scroll(this.scroller) {
        Column() {
          Text($r('app.string.canvas_canvasZone'))
            .leftTitleStyle();
          Column() {
            Canvas(this.context)
              .width('100%')
              .height('100%')
              .backgroundColor($r('app.color.canvas_background'))
              .width('100%')
              .height(200)
          }.cardStyle();

          Text($r('app.string.canvas_attributesOperations'))
            .leftTitleStyle();

          Grid(this.scroller) {
            ForEach(this.Btns, (item: ShowBtnType) => {
              GridItem() {
                Button(item.name, { type: ButtonType.Capsule, stateEffect: true })
                  .sampleButton()
                  .onClick(() => {
                    this.context.save();
                    item.func();
                  });
              };
            });
          }.Style();

          Text($r('app.string.canvas_clearEffects'))
            .leftTitleStyle();

          Button($r('app.string.canvas_clearRect'))
            .onClick(() => {
              this.context.restore();
              this.context.fillRect(0, 0, this.context.width, this.context.height);
              this.context.resetTransform();
              this.context.clearRect(0, 0, 900, 200);
            })
            .sampleButton();
        }.width('100%');
      };

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({ left: 20, right: 20 });
  }
}
