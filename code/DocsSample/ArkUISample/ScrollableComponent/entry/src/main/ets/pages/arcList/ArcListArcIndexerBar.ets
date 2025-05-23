/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ArcList, ArcListAttribute, ArcListItemAttribute, ArcListItem, LengthMetrics } from '@kit.ArkUI';
import { ColorMetrics, ComponentContent } from '@ohos.arkui.node';
import { util } from '@kit.ArkTS';
import { ArcAlphabetIndexer, ArcAlphabetIndexerAttribute } from '@ohos.arkui.ArcAlphabetIndexer';
import { ComponentCard } from '../../common/Card';

class Contact {
  key: string = util.generateRandomUUID(true);
  name: string;
  firstChar: string;

  constructor(name: string, firstChar: string) {
    this.name = name;
    this.firstChar = firstChar;
  }
}
@Builder
function buildText() {
  Column() {
    Text('Contacts')
      .fontColor('#FFFFFF')
      .fontSize('19fp')

  }
}

@Entry
@Component
export struct ArcListArcIndexerBar {

  @State contacts: Array<object> = [
    new Contact('阿哈', 'A'),
    new Contact('贝贝', 'B'),
    new Contact('彩彩', 'C'),
    new Contact('东东', 'D'),
    new Contact('嗯嗯', 'E'),
    new Contact('芳芳', 'F'),
    new Contact('哥哥', 'G'),
    new Contact('哈哈', 'H'),
    new Contact('吉吉', 'J'),
    new Contact('可可', 'K'),
    new Contact('乐乐', 'L'),
    new Contact('妹妹', 'M'),
    new Contact('妮妮', 'N'),
    new Contact('哦豁', 'O'),
    new Contact('胖胖', 'P'),
    new Contact('琪琪', 'Q'),
    new Contact('然然', 'R'),
    new Contact('叔叔', 'S'),
    new Contact('天天', 'T'),
  ];
  private scrollerForList: Scroller = new Scroller();
  private watchSize: string = '600px'; // 手表默认宽高：233*233
  private fullValue: string[] = [
    '#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  ];
  @State indexerIndex: number = 0;

  context: UIContext = this.getUIContext();
  tabBar1: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(buildText));

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ArcListArcIndexerBar_title') }) {
          Stack() {
            ArcList({ initialIndex: 0, header:this.tabBar1, scroller:this.scrollerForList }) {
              ForEach(this.contacts, (item: Contact) => {
                ArcListItem() {
                  Row() {
                    Text(item.firstChar)
                      .textAlign(TextAlign.Center)
                      .width(30)
                      .height(30)
                      .margin(10)
                      .backgroundColor('#FF9CC998')
                      .borderRadius(20)
                    Text(item.name).fontSize('38px').fontColor('#FFFFFFFF')
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.Start)
                }
                .borderRadius('65px')
                .width('370px')
                .height('130px')
                .backgroundColor('#26FFFFFF')
              }, (item: Contact) => JSON.stringify(item))
            }
            .space(LengthMetrics.px(10))
            .scrollBar(BarState.Off)
            .width(this.watchSize)
            .height(this.watchSize)
            .borderRadius(this.watchSize)
            .backgroundColor(Color.Black)
            .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
              this.indexerIndex = centerIndex + 1;
            })

            ArcAlphabetIndexer({ arrayValue: this.fullValue, selected: this.indexerIndex})
              .autoCollapse(true)
              .width(this.watchSize)
              .height(this.watchSize)
              .usePopup(false)
              .selected(this.indexerIndex!!)
              .onSelect((index: number) => {
                this.indexerIndex = index
                this.scrollerForList.scrollToIndex(this.indexerIndex - 1)
              })
              .hitTestBehavior(HitTestMode.Transparent)
              .selectedColor(ColorMetrics.resourceColor(0xFFFFFF))
              .selectedBackgroundColor(ColorMetrics.resourceColor(0x1F71FF))
              .color(ColorMetrics.resourceColor(0xFFFFFF))
              .popupColor(ColorMetrics.resourceColor(0xFFFFFF))
              .popupBackground(ColorMetrics.resourceColor(0xD8404040))
              .itemSize(LengthMetrics.px(12))
              .selectedFont({
                size: '11.0fp',
                style: FontStyle.Normal,
                weight: 500,
                family: 'HarmonyOS Sans'
              })
              .font({
                size: '11.0fp',
                style: FontStyle.Normal,
                weight: 500,
                family: 'HarmonyOS Sans'
              })

          }.width('600px')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ArcListArcIndexerBar_title'))
  }
}
