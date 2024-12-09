/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
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

@Component
export struct SearchView {
  // List组件里可以绑定的可滚动组件的控制器
  private scroller: Scroller = new Scroller();
  // 搜索列表
  @Link searchList: string[];
  // 选定的城市
  @Link changeValue: string;

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      List({ space: 14, initialIndex: 0, scroller: this.scroller }) {
        ForEach(this.searchList, (item: string) => {
          ListItem() {
            Column() {
              Text(item)
                .height(30)
                .fontSize(14)
            }.onClick(() => {
              this.changeValue = item;
            })
          }
        })
      }
      .layoutWeight(1)
      .edgeEffect(EdgeEffect.None)
      .divider({
        strokeWidth: $r('app.integer.citysearch_divider_strokeWidth'),
        color: $r('app.color.citysearch_divider_color'),
        startMargin: $r('app.integer.citysearch_divider_start'),
        endMargin: $r('app.integer.citysearch_divider_end')
      })
      .listDirection(Axis.Vertical)
      .sticky(StickyStyle.Header)
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
  }
}