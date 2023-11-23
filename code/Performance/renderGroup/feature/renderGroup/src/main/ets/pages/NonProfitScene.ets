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

import { NonIconItem } from '../view/NonIconView';
import router from '@ohos.router'

// GridRow列数
const COLUMNS: number = 6;
// GridRow横向间隙
const GUTTER_X: number = 0;
// GridRow纵向间隙
const GUTTER_Y: number = 0;

// IconItem相关数据
class IconItemSource {
  image: string | Resource = ''
  text: string | Resource = ''

  constructor(image: string | Resource = '', text: string | Resource = '') {
    this.image = image;
    this.text = text;
  }
}

@Component
export struct NonProfitScene {
  // renderGroup接口是否开启
  @State renderGroupFlag: boolean = false;
  private iconItemSourceList: IconItemSource[] = [];

  aboutToAppear() {
    // 遍历添加60个IconItem的数据
    for (let index = 0; index < 20; index++) {
      const numStart: number = index * 3;
      // 此处循环使用三张图片资源
      this.iconItemSourceList.push(new IconItemSource($r('app.media.nearby'), `item${numStart + 1}`));
      this.iconItemSourceList.push(new IconItemSource($r('app.media.scan'), `item${numStart + 2}`));
      this.iconItemSourceList.push(new IconItemSource($r('app.media.shop'), `item${numStart + 3}`));
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Row() {
          Image($r("app.media.back"))
            .id('returnBtn')
            .height($r('app.integer.RenderGroup_scene_back_image_size'))
            .width($r('app.integer.RenderGroup_scene_back_image_size'))
            .onClick(() => {
              router.back();
            })

          Text($r('app.string.RenderGroup_nonProfit_scene_title'))
            .fontSize($r('app.integer.RenderGroup_scene_title_font'))
            .lineHeight($r('app.integer.RenderGroup_scene_title_lineHeight'))
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .margin({
              left: $r('app.integer.RenderGroup_scene_title_margin_left')
            })
        }
        .margin({
          left: $r('app.integer.RenderGroup_scene_row_margin_left')
        })

        Stack({ alignContent: Alignment.End }) {
          Button(this.renderGroupFlag ? $r('app.string.RenderGroup_button_on') : $r('app.string.RenderGroup_button_off'), {
            type: ButtonType.Normal,
            stateEffect: true
          })
            .id("renderGroupSwitch")
            .fontSize($r('app.integer.RenderGroup_scene_button_fontSize'))
            .borderRadius($r('app.integer.RenderGroup_scene_button_borderRadius'))
            .backgroundColor($r('app.color.RenderGroup_scene_button_backgroundColor'))
            .width($r('app.integer.RenderGroup_scene_title_button_width'))
            .height($r('app.integer.RenderGroup_scene_title_button_height'))
            .margin({
              right: $r('app.integer.RenderGroup_scene_button_margin_right')
            })
            .onClick(() => {
              this.renderGroupFlag = !this.renderGroupFlag;
            })
        }
      }
      .height($r('app.integer.RenderGroup_scene_title_row_height'))
      .width($r('app.string.layout_100_percent'))
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceBetween)

      // IconItem放置在grid内
      GridRow({
        columns: COLUMNS,
        gutter: { x: GUTTER_X, y: GUTTER_Y },
        breakpoints: { value: ["400vp", "600vp", "800vp"], reference: BreakpointsReference.WindowSize },
        direction: GridRowDirection.Row
      }) {
        ForEach(this.iconItemSourceList, (item: IconItemSource) => {
          GridCol() {
            NonIconItem({ image: item.image, text: item.text, renderGroupFlag: this.renderGroupFlag })
          }
          .height($r('app.integer.RenderGroup_scene_GridCol_height'))
          .width($r('app.string.layout_17_percent'))
        })
      }
      .width($r('app.string.layout_100_percent'))
      .height($r('app.string.layout_100_percent'))
    }
    .width($r('app.string.layout_100_percent'))
    .height($r('app.string.layout_100_percent'))
    .alignItems(HorizontalAlign.Center)
  }
}