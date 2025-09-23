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

import router from '@ohos.router';

interface ListCategories {
  title:string,
  url:string
}

@Entry
@Component
struct AnimationIndex {
  @State message: string = 'CApi';
  @State isShow: boolean = false;
  private items : ListCategories[] = [
    {title:'ArkUI_TransitionEdge',url:'pages/animation/AnimationIndexEdge'},
    {title:'ArkUI_RenderFit',url:'pages/animation/AnimationIndexFit'},
    {title:'ArkUI_AnimationCurve, ArkUI_AnimationPlayMode, ArkUI_FinishCallbackType',
      url:'pages/animation/AnimationIndexCurve'},
    {title:'ArkUI_AnimationFillMode, ArkUI_AnimationDirection',url:'pages/animation/AnimationIndexMode'},
    {title:'ArkUI_TranslationOptions, ArkUI_ScaleOptions, ArkUI_RotationOptions',
      url:'pages/animation/AnimationIndexOption'},
  ];

  @Builder cApiMenu() {
    Grid() {
      ForEach(this.items, (item: ListCategories) => {
        GridItem() {
          Button(item.title)
            .key(item.title)
            .width('100%')
            .height('100%')
            .fontSize(10)
            .padding(1)
            .onClick(() => {
              router.pushUrl({ url: item.url });
            })
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .columnsGap(8)
    .rowsGap(8)
    .width('100%')
  }

  build() {
    Scroll(new Scroller()) {
      Column() {
        Stack() {
          Row() {
            Text(this.message)
              .fontSize(22)
              .fontColor(0xFFFFFF)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center)
              .width('100%')
              .height(50)
              .backgroundColor('#FF08528A')
          }.width('100%')
          Button('menu')
            .key('menu')
            .onClick(() => {
              this.isShow = true;
            })
            .fontSize(10)
            .position({top: 5, right: 5})
            .backgroundColor(Color.Transparent)
            .fontColor(Color.Transparent)
            .bindSheet($$this.isShow, this.cApiMenu(), {
              showClose: false,
              preferType: SheetType.BOTTOM
            })
        }

        List({ space: '20vp' }) {
          ForEach(this.items, (item: ListCategories) => {
            ListItem() {
              Button(item.title)
                .fontSize(15)
                .labelStyle({ maxLines: 10 })
                .onClick(() => {
                  router.pushUrl({ url: item.url });
                })
            }
          })
        }.alignListItem(ListItemAlign.Center).margin({ top: '10vp' }).width('90%').height('90%')
      }.width('100%').height('100%').backgroundColor('#FFDDE7F6')
    }
  }
}