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
      name: $r('app.string.canvas_addColorStop'),
      func: () => {
        let grad = this.context.createLinearGradient(50, 0, 300, 100);
        grad.addColorStop(0.0, '#ff0000');
        grad.addColorStop(0.5, '#ffffff');
        grad.addColorStop(1.0, '#00ff00');
        this.context.fillStyle = grad;
        this.context.fillRect(0, 0, 400, 400);
      },
    },
    {
      name: $r('app.string.canvas_createLinearGradient'),
      func: () => {
        let grad = this.context.createLinearGradient(0, 0, 200, 200);
        grad.addColorStop(0.0, '#ff0000');
        grad.addColorStop(0.5, '#ffffff');
        grad.addColorStop(1.0, '#00ff00');
        this.context.fillStyle = grad;
        this.context.fillRect(0, 0, 400, 400);
      },
    },
    {
      name: $r('app.string.canvas_createRadialGradient'),
      func: () => {
        let grad = this.context.createRadialGradient(100, 100, 20, 100, 100, 200);
        grad.addColorStop(0.0, '#ff0000');
        grad.addColorStop(0.5, '#ffffff');
        grad.addColorStop(1.0, '#00ff00');
        this.context.fillStyle = grad;
        this.context.fillRect(0, 0, 200, 200);
      },
    },
  ];

  build() {
    Column() {
      TitleBar({ title: $r('app.string.canvas_component_gradient') });
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
              this.context.clearRect(0, 0, 900, 200)
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
