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
import { Logger } from '@ohos/common';
import router from '@ohos.router';
import { TabItem } from '../common/bean/TabItem';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

let TAG = 'SceneTabPage';

@Component
export default struct SceneTabPage {
  @Prop currentIndex: number = 0;
  @State focusIndex: number = 0;
  private tabItems: TabItem[] = [];
  changeTab: (tab: number) => void = (tab: number) => {
  };
  addClick: () => void = () => {
  };

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Row() {
        ForEach(this.tabItems, (item: TabItem, index: number) => {
          Column() {
            Text(item.title)
              .fontColor(this.focusIndex == index ? $r('app.color.text_color_focus') :
              $r('app.color.default_text_color'))
              .fontSize(this.focusIndex == index ? $r('app.string.font_20') : $r('app.string.font_16'))
              .padding({ right: $r('app.string.padding_tab_title_left') })
              .margin({ right: $r('app.string.padding_tab_title_left') })
              .onClick(() => {
                this.focusIndex = index;
                this.changeTab(index);
              })
              .focusBox({
                strokeWidth: LengthMetrics.px(0)
              })
              .onFocus(() => {
                this.focusIndex = index;
                this.changeTab(index);
              })
              .onBlur(() => {
                this.focusIndex = -1;
              });
          }
          .padding({ bottom: $r('app.string.vp_10') })
          .margin({ right: px2vp(64) })
          .borderWidth({ bottom: this.currentIndex == index ? 3 : 0 })
          .borderStyle(BorderStyle.Solid)
          .borderColor(this.focusIndex == index ? $r('app.color.text_color_focus') :
          $r('app.color.default_text_color'));
        });
      };

      Image($r('app.media.add_scene'))
        .width($r('app.string.add_scene_width'))
        .height($r('app.string.add_scene_height'))
        .focusBox({
          margin: LengthMetrics.px(2),
          strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
          strokeWidth: LengthMetrics.px(2)
        })
        .onClick(() => {
          this.addClick();
        });
    }
    .width('100%')
    .height($r('app.string.scene_tab_height'))
    .padding({ left: $r('app.string.padding_tab_left'), right: $r('app.string.padding_tab_left') });
  }
}