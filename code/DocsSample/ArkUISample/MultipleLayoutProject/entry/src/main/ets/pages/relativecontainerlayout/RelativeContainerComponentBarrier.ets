/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
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
//[Start testRelativeContainerComponentBarrier_start]
@Entry
@Component
struct Index {
  build() {
    RelativeContainer() {
      Text('item 1')
        .width(80)
        .height(80)
        .textAlign(TextAlign.Center)
        .backgroundColor('#a3cf62')
        .id('item1')
        .alignRules({
          top: {
            anchor: '__container__',
            align: VerticalAlign.Top
          },
          left: {
            anchor: '__container__',
            align: HorizontalAlign.Start
          }
        })
      Text('item 2')
        .width(80)
        .height(80)
        .textAlign(TextAlign.Center)
        .backgroundColor('#a3cf62')
        .id('item2')
        .alignRules({
          top: {
            anchor: 'item1',
            align: VerticalAlign.Bottom
          },
          left: {
            anchor: 'item1',
            align: HorizontalAlign.End
          }
        })
      Text('item 3')
        .width(80)
        .height(80)
        .textAlign(TextAlign.Center)
        .backgroundColor('#a3cf62')
        .id('item3')
        .alignRules({
          bottom: {
            anchor: 'item2',
            align: VerticalAlign.Top
          },
          left: {
            anchor: 'item2',
            align: HorizontalAlign.End
          }
        })
      Text('outer 1')
        .width(80)
        .height(80)
        .textAlign(TextAlign.Center)
        .backgroundColor('#00ae9d')
        // 定义其位置
        .alignRules({
          top: {
            anchor: 'barrier_bottom',
            align: VerticalAlign.Top
          },
          left: {
            anchor: 'barrier_left',
            align: HorizontalAlign.Start
          }
        })

      Text('outer 2')
        .width(80)
        .height(80)
        .textAlign(TextAlign.Center)
        .backgroundColor('#00ae9d')
        // 定义其位置
        .alignRules({
          top: {
            anchor: 'barrier_top',
            align: VerticalAlign.Top
          },
          left: {
            anchor: 'barrier_right',
            align: HorizontalAlign.Start
          }
        })
    }
    .width('100%')
    .padding(10)
    .barrier([
      {
        id: 'barrier_left',
        direction: BarrierDirection.LEFT,
        referencedId: ['item1', 'item2', 'item3']
      },
      {
        id: 'barrier_right',
        direction: BarrierDirection.RIGHT,
        referencedId: ['item1', 'item2', 'item3']
      },
      {
        id: 'barrier_top',
        direction: BarrierDirection.TOP,
        referencedId: ['item1', 'item2', 'item3']
      },
      {
        id: 'barrier_bottom',
        direction: BarrierDirection.BOTTOM,
        referencedId: ['item1', 'item2', 'item3']
      },
    ])
  }
}
// [End testRelativeContainerComponentBarrier_start]