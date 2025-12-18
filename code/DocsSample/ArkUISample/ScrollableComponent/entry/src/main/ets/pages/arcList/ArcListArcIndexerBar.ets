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

import { ComponentCard } from '../../common/Card';
import { ArcAlphabetIndexer, ArcAlphabetIndexerAttribute } from '@ohos.arkui.ArcAlphabetIndexer';
import { util } from '@kit.ArkTS';
import { ColorMetrics, ComponentContent } from '@ohos.arkui.node';
// [Start arcAlphabetIndexer_start]
import { ArcList, ArcListAttribute, ArcListItemAttribute, ArcListItem, LengthMetrics } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

// [StartExclude arcAlphabetIndexer_start]
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
    Text($r('app.string.contacts'))
      .fontColor('#FFFFFF')
      .fontSize('19fp')
  }
}
// [EndExclude arcAlphabetIndexer_start]
const alphabets: string[] = [
  '#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N',
  'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
];

@Entry
@Component
export struct ArcListArcIndexerBar {

  // [StartExclude arcAlphabetIndexer_start]
  private watchSize: string = '600px'; // 手表默认宽高：233*233
  private context1 = this.getUIContext().getHostContext() as common.UIAbilityContext;

  @State contacts: Array<object> = [
    // 请在resources\base\element\string.json文件中配置name为'name_xxx' ，value为非空字符串的资源
    new Contact(this.context1.resourceManager.getStringByNameSync('name_aha'), 'A'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_beibei'), 'B'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_caicai'), 'C'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_dongdong'), 'D'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_enen'), 'E'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_fangfang'), 'F'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_gege'), 'G'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_haha'), 'H'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_jiji'), 'J'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_keke'), 'K'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_lele'), 'L'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_meimei'), 'M'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_nini'), 'N'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_ohuo'), 'O'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_pangpang'), 'P'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_qiqi'), 'Q'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_ranran'), 'R'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_shushu'), 'S'),
    new Contact(this.context1.resourceManager.getStringByNameSync('name_tiantian'), 'T'),
  ];
  // [EndExclude arcAlphabetIndexer_start]
  // 索引条选中项索引
  @State indexerIndex: number = 0;
  // 列表绑定的滚动控制器
  private arcListScroller: Scroller = new Scroller();

  // [StartExclude arcAlphabetIndexer_start]
  context: UIContext = this.getUIContext();
  tabBar1: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(buildText));
  // [EndExclude arcAlphabetIndexer_start]

  build() {
    // [StartExclude arcAlphabetIndexer_start]
    NavDestination() {
      Column({ space: 12 }) {
        // $r('app.string.ArcListArcIndexerBar_title')需要替换为开发者所需的资源文件
        ComponentCard({ title: $r('app.string.ArcListArcIndexerBar_title') }) {
          // [EndExclude arcAlphabetIndexer_start]
          Stack({alignContent: Alignment.End}) {
            ArcList({ initialIndex: 0, header:this.tabBar1, scroller:this.arcListScroller }) {
              // [StartExclude arcAlphabetIndexer_start]
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
              // [EndExclude arcAlphabetIndexer_start]
            }
            // [StartExclude arcAlphabetIndexer_start]
            .space(LengthMetrics.px(10))
            .scrollBar(BarState.Off)
            .width(this.watchSize)
            .height(this.watchSize)
            .borderRadius(this.watchSize)
            .backgroundColor(Color.Black)
            // [EndExclude arcAlphabetIndexer_start]
            .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
              // 根据列表滚动到的索引值，重新计算对应索引条的位置this.selectedIndex
              this.indexerIndex = centerIndex + 1;
            })
            // [StartExclude arcAlphabetIndexer_start]
            .id('arcIndexTest')
            // [EndExclude arcAlphabetIndexer_start]
            // 弧形索引条组件
            ArcAlphabetIndexer({ arrayValue: alphabets, selected: this.indexerIndex})
              .selected(this.indexerIndex!!)
              .onSelect((index: number) => {
                // 选中索引项后，列表跳转到相应位置
                this.indexerIndex = index
                this.arcListScroller.scrollToIndex(this.indexerIndex - 1)
              })
              // [StartExclude arcAlphabetIndexer_start]
              .autoCollapse(true)
              .width(this.watchSize)
              .height(this.watchSize)
              .usePopup(false)
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
            // [EndExclude arcAlphabetIndexer_start]
          }
          // [StartExclude arcAlphabetIndexer_start]
          .width('600px')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // $r('app.string.ArcListArcIndexerBar_title')需要替换为开发者所需的资源文件
    .title($r('app.string.ArcListArcIndexerBar_title'))
    // [EndExclude arcAlphabetIndexer_start]
  }
}
// [End arcAlphabetIndexer_start]