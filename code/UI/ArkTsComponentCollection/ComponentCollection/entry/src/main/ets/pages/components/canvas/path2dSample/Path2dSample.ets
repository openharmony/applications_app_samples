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
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private Btns: ShowBtnType[] = [
    {
      name: $r('app.string.canvas_beginPath'),
      func: () => {
        this.context.beginPath();
        let path2d:Path2D = new Path2D();
        path2d.moveTo(15, 80);
        path2d.lineTo(280, 160);
        this.context.beginPath();
        this.context.stroke(path2d);
      },
    },
    {
      name: $r('app.string.canvas_moveTo'),
      func: () => {
        let path2d:Path2D = new Path2D();
        path2d.moveTo(10, 10);
        path2d.lineTo(280, 160);
        this.context.beginPath();
        this.context.stroke(path2d);
      },
    },
    {
      name: $r('app.string.canvas_lineTo'),
      func: () => {
        let path2d:Path2D = new Path2D();
        this.context.beginPath();
        path2d.moveTo(10, 10);
        path2d.lineTo(280, 160);
        this.context.stroke(path2d);
      },
    },
    {
      name: $r('app.string.canvas_closePath'),
      func: () => {
        let path2d:Path2D = new Path2D();
        path2d.moveTo(30, 30);
        path2d.lineTo(110, 30);
        path2d.lineTo(70, 90);
        path2d.closePath();
        this.context.beginPath();
        this.context.stroke(path2d);
      },
    },
    {
      name: $r('app.string.canvas_bezierCurveTo'),
      func: () => {
        let path2d:Path2D = new Path2D();
        path2d.moveTo(10, 10);
        path2d.bezierCurveTo(20, 100, 200, 100, 200, 20);
        this.context.beginPath();
        this.context.stroke(path2d);
      },
    },
    {
      name: $r('app.string.canvas_quadraticCurveTo'),
      func: () => {
        let path2d:Path2D = new Path2D();
        path2d.moveTo(20, 20);
        path2d.quadraticCurveTo(100, 100, 200, 20);
        this.context.beginPath();
        this.context.stroke(path2d);
      },
    },
    {
      name: $r('app.string.canvas_arc'),
      func: () => {
        let path2d:Path2D = new Path2D();
        path2d.arc(100, 75, 50, 0, 6.28);
        this.context.beginPath();
        this.context.stroke(path2d);
      },
    },
    {
      name: $r('app.string.canvas_arcTo'),
      func: () => {
        let path2d:Path2D = new Path2D();
        path2d.moveTo(100, 20);
        path2d.arcTo(150, 20, 150, 70, 50);
        this.context.beginPath();
        this.context.stroke(path2d);
      },
    },
    {
      name: $r('app.string.canvas_ellipse'),
      func: () => {
        let path2d:Path2D = new Path2D();
        path2d.ellipse(200, 100, 25, 50, Math.PI * 0.25, Math.PI * 0.5, Math.PI * 2);
        this.context.beginPath();
        this.context.stroke(path2d);
      },
    },
    {
      name: $r('app.string.canvas_rect'),
      func: () => {
        let path2d:Path2D = new Path2D();
        path2d.rect(20, 20, 100, 100); // Create a 100*100 rectangle at (20, 20)
        this.context.beginPath();
        this.context.stroke(path2d);
      },
    },
  ];

  build() {
    Column() {
      TitleBar({ title: $r('app.string.canvas_component_path_2d') })
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
                    item.func();
                  });
              };
            });
          }.Style();


          Text($r('app.string.canvas_clearEffects'))
            .leftTitleStyle();

          Button($r('app.string.canvas_clearRect'))
            .onClick(() => {
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
