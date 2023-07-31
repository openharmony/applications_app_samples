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
struct CanvasSample {
  scroller: Scroller = new Scroller();
  private img: ImageBitmap = new ImageBitmap('/pages/components/canvas/sampleResources/smoothoff.png');

  private Btns: ShowBtnType[] = [
    {
      name: $r('app.string.canvas_fillStyle'),
      func: () => {
        this.context.save();
        this.context.fillStyle = '#0000ff';
        this.context.fillRect(20, 20, 150, 100);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_lineWidth'),
      func: () => {
        this.context.save();
        this.context.lineWidth = 5;
        this.context.strokeRect(25, 25, 85, 105);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_strokeStyle'),
      func: () => {
        this.context.save();
        this.context.lineWidth = 10;
        this.context.strokeStyle = '#0000ff';
        this.context.strokeRect(25, 25, 155, 105);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_lineCap'),
      func: () => {
        this.context.save();
        this.context.beginPath();
        this.context.lineWidth = 8;
        this.context.strokeStyle = '#000000';
        this.context.lineCap = 'round';
        let path: Path2D = new Path2D();
        path.moveTo(30, 50);
        path.lineTo(220, 50);
        this.context.stroke(path);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_lineJoin'),
      func: () => {
        this.context.save();
        this.context.strokeStyle = '#000000';
        this.context.beginPath();
        let path: Path2D = new Path2D();
        this.context.lineWidth = 8;
        this.context.lineJoin = 'miter';
        path.moveTo(30, 30);
        path.lineTo(120, 60);
        path.lineTo(30, 110);
        this.context.stroke(path);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_miterLimit'),
      func: () => {
        this.context.strokeStyle = '#000000';
        this.context.save();
        this.context.beginPath();
        this.context.lineWidth = 8;
        this.context.lineJoin = 'miter';
        this.context.miterLimit = 3;
        let path: Path2D = new Path2D();
        path.moveTo(30, 30);
        path.lineTo(60, 35);
        path.lineTo(30, 37);
        this.context.stroke(path);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_font'),
      func: () => {
        this.context.font = '30px sans-serif';
        this.context.fillText('Hello World', 20, 60);
      },
    },
    {
      name: $r('app.string.canvas_textAlign'),
      func: () => {
        this.context.strokeStyle = '#0000ff';
        this.context.save();
        this.context.beginPath();
        let path: Path2D = new Path2D();
        path.moveTo(140, 10);
        path.lineTo(140, 160);
        this.context.stroke(path);
        this.context.font = '18px sans-serif';
        this.context.textAlign = 'start';
        this.context.fillText('textAlign=start', 140, 60);
        this.context.textAlign = 'end';
        this.context.fillText('textAlign=end', 140, 80);
        this.context.textAlign = 'left';
        this.context.fillText('textAlign=left', 140, 100);
        this.context.textAlign = 'center';
        this.context.fillText('textAlign=center', 140, 120);
        this.context.textAlign = 'right';
        this.context.fillText('textAlign=right', 140, 140);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_textBaseline'),
      func: () => {
        this.context.strokeStyle = '#0000ff';
        this.context.save();
        let path: Path2D = new Path2D();
        path.moveTo(0, 120);
        path.lineTo(400, 120);
        this.context.stroke(path);
        this.context.font = '20px sans-serif';
        this.context.textBaseline = 'top';
        this.context.fillText('Top', 10, 120);
        this.context.textBaseline = 'bottom';
        this.context.fillText('Bottom', 55, 120);
        this.context.textBaseline = 'middle';
        this.context.fillText('Middle', 125, 120);
        this.context.textBaseline = 'alphabetic';
        this.context.fillText('Alphabetic', 195, 120);
        this.context.textBaseline = 'hanging';
        this.context.fillText('Hanging', 295, 120);
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_globalAlpha'),
      func: () => {
        this.context.save();
        this.context.fillStyle = 'rgb(0,0,255)';
        this.context.fillRect(0, 0, 50, 50);
        this.context.globalAlpha = 0.4;
        this.context.fillStyle = 'rgb(0,0,255)';
        this.context.fillRect(50, 50, 50, 50);
        this.context.globalAlpha = 1.0;
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_lineDashOffset'),
      func: () => {
        this.context.save();
        this.context.fillStyle = '#000000';
        let path: Path2D = new Path2D();
        path.arc(100, 75, 50, 0, 6.28);
        this.context.setLineDash([10, 20]);
        this.context.lineDashOffset = 10.0;
        this.context.stroke(path);
        this.context.lineDashOffset = 0.0;
        this.context.restore();
      },
    },
    {
      name: $r('app.string.canvas_globalCompositeOperation'),
      func: () => {
        this.context.fillStyle = 'rgb(255,0,0)';
        this.context.fillRect(20, 20, 50, 50);
        this.context.globalCompositeOperation = 'source-over';
        this.context.fillStyle = 'rgb(0,0,255)';
        this.context.fillRect(50, 50, 50, 50);
        this.context.fillStyle = 'rgb(255,0,0)';
        this.context.fillRect(120, 20, 50, 50);
        this.context.globalCompositeOperation = 'destination-over';
        this.context.fillStyle = 'rgb(0,0,255)';
        this.context.fillRect(150, 50, 50, 50);
      },
    },
    {
      name: $r('app.string.canvas_imageSmoothingEnabled'),
      func: () => {
        this.context.imageSmoothingEnabled = false;
        this.context.scale(0.5, 0.5);
        this.context.drawImage(this.img, 0, 0, 400, 200);
        this.context.scale(1, 1);
      },
    },
  ];
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Column() {
      TitleBar({ title: $r('app.string.canvas_component_attributes') })
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
              .height(200);
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

          Button($r('app.string.canvas_clearRect')).onClick(()=>{
            this.context.restore();
            this.context.fillRect(0, 0, this.context.width, this.context.height);
            this.context.resetTransform();
            this.context.clearRect(0, 0, this.context.width, this.context.height);
          }).width('90%')
            .sampleButton();

        }.width('100%');
      };

    }
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({ left: 20, right: 20 });

  }
}
