/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { getStringData } from '../../../../data/ResourceDataHandle';

@Extend(Row) function rowStyle() {
  .padding(8)
  .borderRadius(24)
  .width('100%')
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
}

class ContainerInfo {
  label: string = '';
  size: string = '';
}

class ChildInfo {
  text: string = '';
  priority: number = 0;
}

@Entry
@Component
struct LayoutExample {
  // 显示容器大小
  private container: ContainerInfo[] = [
    { label: getStringData($r('app.string.layout_constrain_big_container')), size: '100%' },
    { label: getStringData($r('app.string.layout_constrain_middle_container')), size: '50%' },
    { label: getStringData($r('app.string.layout_constrain_small_container')), size: '30%' }
  ];
  private children: ChildInfo[] = [
    { text: getStringData($r('app.string.layout_constrain_children_one')), priority: 2 },
    { text: getStringData($r('app.string.layout_constrain_children_two')), priority: 1 },
    { text: getStringData($r('app.string.layout_constrain_children_three')), priority: 3 },
    { text: getStringData($r('app.string.layout_constrain_children_four')), priority: 1 },
    { text: getStringData($r('app.string.layout_constrain_children_five')), priority: 2 }
  ];
  private childrenOne: string[] = [getStringData($r('app.string.layout_constrain_one')), getStringData($r('app.string.layout_constrain_two'))];
  @State currentIndex: number = 0;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.layout_constrain') })
      IntroductionTitle({ introduction: $r('app.string.layout_constrain_aspectRatio') })
      Row() {
        Row({ space: 5 }) {
          ForEach(this.childrenOne, (item: string) => {
            // 组件宽度 = 组件高度*1.5 = 90
            Text(item)
              .backgroundColor(0xbbb2cb)
              .fontSize(20)
              .aspectRatio(1.5)
              .height(60)
            // 组件高度 = 组件宽度/1.5 = 60/1.5 = 40
            Text(item)
              .backgroundColor(0xbbb2cb)
              .fontSize(20)
              .aspectRatio(1.5)
              .width(60)
          }, (item: string) => item)
        }
        .size({ width: '100%', height: 100 })
        .backgroundColor(0xd2cab3)
        .clip(true)
      }
      .rowStyle()

      IntroductionTitle({ introduction: $r('app.string.layout_constrain_displayPriority') })
      Row() {
        Column() {
          // 切换父级容器大小
          Button(this.container[this.currentIndex].label).backgroundColor(0x317aff)
            .onClick(() => {
              this.currentIndex = (this.currentIndex + 1) % this.container.length;
            })
            .margin({ bottom: 5 })
            .id('layout_btn')
          // 通过变量设置Flex父容器宽度
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            ForEach(this.children, (item: ChildInfo) => {
              // 使用displayPriority给子组件绑定显示优先级
              Text(item.text)
                .width(50)
                .height(60)
                .fontSize(12)
                .textAlign(TextAlign.Center)
                .backgroundColor(0xbbb2cb)
                .displayPriority(item.priority)
            }, (item: ChildInfo) => item.text)
          }
          .width(this.container[this.currentIndex].size)
          .backgroundColor(0xd2cab3)
        }
        .alignItems(HorizontalAlign.Center)
      }
      .rowStyle()
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}