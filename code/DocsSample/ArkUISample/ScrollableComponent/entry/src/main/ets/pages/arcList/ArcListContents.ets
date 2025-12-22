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
// [Start arcListContentsTitle_start]
import { ArcList, ArcListAttribute, ArcListItemAttribute, ArcListItem, LengthMetrics } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import { ComponentCard } from '../../common/Card';
import { common } from '@kit.AbilityKit';

class Contact {
  key: string = util.generateRandomUUID(true);
  name: string;
  icon: Resource;

  constructor(name: string, icon: Resource) {
    this.name = name;
    this.icon = icon;
  }
}

@Entry
@Component
export struct ArcListContents {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private contacts: Array<object> = [
    // 请在resources\base\element\string.json文件中配置name为'name_xxx' ，value为非空字符串的资源
    new Contact(this.context.resourceManager.getStringByNameSync('name_xiaohong'), $r('app.media.ic_contact')),
    new Contact(this.context.resourceManager.getStringByNameSync('name_xiaolan'), $r('app.media.ic_contact')),
    new Contact(this.context.resourceManager.getStringByNameSync('name_xiaowang'), $r('app.media.ic_contact')),
    new Contact(this.context.resourceManager.getStringByNameSync('name_xiaoli'), $r('app.media.ic_contact')),
    new Contact(this.context.resourceManager.getStringByNameSync('name_xiaoming'), $r('app.media.ic_contact'))
  ];

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // 请将$r('app.string.ArcListContents_title')替换为实际资源文件，在本示例中该资源文件的value值为"迭代弧形列表内容"
        ComponentCard({ title: $r('app.string.ArcListContents_title') }) {
          ArcList({ initialIndex: 2 }) {
            ForEach(this.contacts, (item: Contact) => {
              ArcListItem() {
                Row() {
                  Image(item.icon)
                    .width(40)
                    .height(40)
                    .margin(10)
                    .backgroundColor('#FF9CC998')
                    .borderRadius(20)
                  Text(item.name).fontSize('38px').fontColor('#FFFFFFFF')
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
              }
              .borderRadius('65px')
              .width('410px')
              .height('130px')
              .backgroundColor('#26FFFFFF')
            }, (item: Contact) => JSON.stringify(item))
          }
          .space(LengthMetrics.px(10))
          .width('466px')
          .height('466px')
          .borderRadius('233px')
          .backgroundColor(Color.Black)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.ArcListContents_title')替换为实际资源文件，在本示例中该资源文件的value值为"迭代弧形列表内容"
    .title($r('app.string.ArcListContents_title'))
  }
}
// [End arcListContentsTitle_start]