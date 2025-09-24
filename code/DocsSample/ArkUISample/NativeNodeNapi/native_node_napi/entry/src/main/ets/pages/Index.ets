/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { router } from '@kit.ArkUI';

interface ListCategories {
  title: string,
  url: string
}

@Entry
@Component
struct MenuIndex {
  private items: ListCategories[] =
    [
      { title: 'Navigation', url: 'pages/page_navigation' },
      { title: 'add your router', url: 'pages/page_navigation' },
      { title: 'accessibility', url: 'pages/page_accessibility' },
      { title: 'embedded component', url: 'pages/page_embedded_component' },
    ];

  build() {
    Scroll(new Scroller()) {
      Column() {
        Text('native_node_napi_sample')
          .fontWeight(FontWeight.Bold)
          .fontSize(20)
          .textAlign(TextAlign.Center)
          .height('5%')
          .margin($r('sys.float.titlebar_title_margin_right'))
        List() {
          ForEach(this.items, (item: ListCategories) => {
            ListItem() {
              Row() {
                Text(item.title)
                  .fontSize($r('sys.float.text_button_font_size'))
                  .fontColor(Color.Black)
                  .textAlign(TextAlign.Start)
                  .height('100%')
                  .width('50%')
                  .padding($r('sys.float.padding_level10'))
                Text('>')
                  .fontSize('25vp')
                  .fontColor(Color.Black)
                  .textAlign(TextAlign.End)
                  .fontColor(Color.Gray)
                  .height('100%')
                  .width('50%')
                  .padding($r('sys.float.padding_level10'))
              }
              .width('100%')
              .height('10%')
              .borderRadius($r('sys.float.select_border_radius_default'))
              .backgroundColor(Color.White)
              .onClick(() => {
                router.pushUrl({ url: item.url })
              })
            }
            .margin($r('sys.float.menu_item_content_align'))
          })
        }.width('95%').height('90%').alignListItem(ListItemAlign.Center)
      }.width('100%')
    }.height('100%').backgroundColor('#2aa1a6b1')
  }
}