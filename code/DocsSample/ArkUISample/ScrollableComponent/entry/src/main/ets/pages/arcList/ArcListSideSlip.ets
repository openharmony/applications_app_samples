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

import { ArcList, ArcListAttribute, ArcListItemAttribute, ArcListItem } from '@kit.ArkUI';
import { ComponentContent, LengthMetrics } from '@ohos.arkui.node';
import { util } from '@kit.ArkTS';
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
    Text('Contacts ')
      .fontColor('#FFFFFF')
      .fontSize('19fp')

  }
}

@Entry
@Component
export struct ArcListSideSlip {
  @State contacts: Array<object> = [
    new Contact('Alice', 'A'),
    new Contact('Bob', 'B'),
    new Contact('Charlie', 'C'),
    new Contact('Diana', 'D'),
    new Contact('Eve', 'E'),
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

  @State indexerIndex: number = 0;
  context: UIContext = this.getUIContext();
  tabBar1: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(buildText));

  @Builder
  itemEnd(item: Contact) {
    // 构建尾端滑出组件
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.MaterialSymbolsDelete'))
        .width(20)
        .height(20)
    }
    .width(20)
    .height(20)
    .backgroundColor(Color.Black)
    .onClick(() => {
      this.getUIContext()?.animateTo({
        duration: 1000,
        curve: Curve.Smooth,
        iterations: 1,
        playMode: PlayMode.Normal,
      }, () => {
        let index = this.contacts.indexOf(item);
        this.contacts.splice(index, 1);
      })

    })
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ArcListSideSlip_title') }) {
          Stack() {
            ArcList({ initialIndex: 0, header: this.tabBar1, scroller: this.scrollerForList }) {
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
                  .backgroundColor('#26FFFFFF')
                  .borderRadius('65px')
                  .width('90%')
                  .justifyContent(FlexAlign.Start)
                }
                .swipeAction({
                  end: {
                    // index为该ArcListItem在ArcList中的索引值。
                    builder: () => {
                      this.itemEnd(item);
                    },
                  }
                }) // 设置侧滑属性.
                .borderRadius('65px')
                .width('400px')
                .height('130px')

              }, (item: Contact) => JSON.stringify(item))
            }
            .space(LengthMetrics.px(10))
            .scrollBar(BarState.Auto)
            .width('466px')
            .height('466px')
            .borderRadius('233px')
            .backgroundColor(Color.Black)
            .margin(50)
            .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
              this.indexerIndex = centerIndex + 1;
            })
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ArcListSideSlip_title'))
  }
}