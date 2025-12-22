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
import { common } from '@kit.AbilityKit';

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
  private context1 = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State contacts: Array<object> = [
    new Contact('Alice', 'A'),
    new Contact('Bob', 'B'),
    new Contact('Charlie', 'C'),
    new Contact('Diana', 'D'),
    new Contact('Eve', 'E'),
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
  private scrollerForList: Scroller = new Scroller();
  @State indexerIndex: number = 0;
  context: UIContext = this.getUIContext();
  tabBar1: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(buildText));

  // [Start create_SideSlip_start]
  @Builder
  itemEnd(item: Contact) {
    // 构建尾端滑出组件
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.ic_public_delete_filled'))
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
        // this.contacts为列表数据源，可根据实际场景构造，indexOf方法可获取将被删除数据在数据源中的索引
        let index = this.contacts.indexOf(item);
        // 从数据源删除指定数据项
        this.contacts.splice(index, 1);
      })
    })
  }
  // [End create_SideSlip_start]

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // 请将$r('app.string.ArcListSideSlip_title')替换为实际资源文件，在本示例中该资源文件的value值为"响应列表项侧滑"
        ComponentCard({ title: $r('app.string.ArcListSideSlip_title') }) {
          Stack() {
            ArcList({ initialIndex: 0, header: this.tabBar1, scroller: this.scrollerForList }) {
              ForEach(this.contacts, (item: Contact) => {
                // [Start bind_swipeAction_start]
                // 构建ArcList时，通过ForEach基于数据源this.contacts循环渲染ArcListItem
                ArcListItem() {
                  // [StartExclude bind_swipeAction_start]
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
                  // [EndExclude bind_swipeAction_start]
                }
                .swipeAction({
                  end: {
                    // index为该ArcListItem在ArcList中的索引值。
                    builder: () => {
                      this.itemEnd(item);
                    },
                  }
                }) // 设置侧滑属性.
                // [End bind_swipeAction_start]
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
    // 请将$r('app.string.ArcListSideSlip_title')替换为实际资源文件，在本示例中该资源文件的value值为"响应列表项侧滑"
    .title($r('app.string.ArcListSideSlip_title'))
  }
}