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
// [Start makeObserved_collections_Array_Set_Map]
import { collections } from '@kit.ArkTS';
import { UIUtils } from '@kit.ArkUI';

@Sendable
class Info {
  public id: number = 0;
  public name: string = 'cc';

  constructor(id: number) {
    this.id = id;
  }
}


@Entry
@ComponentV2
struct Page4 {
  scroller: Scroller = new Scroller();
  @Local arrCollect: collections.Array<Info> =
    UIUtils.makeObserved(new collections.Array<Info>(new Info(1), new Info(2)));

  build() {
    Column() {
      // ForEach接口仅支持Array<any>，不支持collections.Array<any>。
      // 但ForEach的实现用到的Array的API，collections.Array都有提供。所以可以使用as类型断言Array。
      // 需要注意断言并不会改变原本的数据类型。
      ForEach(this.arrCollect as object as Array<Info>, (item: Info) => {
        Text(`${item.id}`).onClick(() => {
          item.id++;
        })
      }, (item: Info, index) => item.id.toString() + index.toString())
      Divider()
        .color('blue')
      if (this.arrCollect.length > 0) {
        Text(`the first one ${this.arrCollect[0].id}`)
        Text(`the last one ${this.arrCollect[this.arrCollect.length - 1].id}`)
      }
      Divider()
        .color('blue')

      /****************************改变数据长度的api**************************/
      Scroll(this.scroller) {
        Column({space: 10}) {
          // push: 新增新元素
          Button('push').onClick(() => {
            this.arrCollect.push(new Info(30));
          })
          // pop: 删除最后一个
          Button('pop').onClick(() => {
            this.arrCollect.pop();
          })
          // shift: 删除第一个
          Button('shift').onClick(() => {
            this.arrCollect.shift();
          })
          // unshift: 在数组的开头插入新项
          Button('unshift').onClick(() => {
            this.arrCollect.unshift(new Info(50));
          })
          // splice: 从数组的指定位置删除元素
          Button('splice').onClick(() => {
            this.arrCollect.splice(1);
          })

          // shrinkTo: 将数组长度缩小到给定的长度
          Button('shrinkTo').onClick(() => {
            this.arrCollect.shrinkTo(1);
          })
          // extendTo: 将数组长度扩展到给定的长度
          Button('extendTo').onClick(() => {
            this.arrCollect.extendTo(6, new Info(20));
          })

          Divider()
            .color('blue')

          /****************************************改变数组item本身*****************/
          // sort：从大到小排序
          Button('sort').onClick(() => {
            this.arrCollect.sort((a: Info, b: Info) => b.id - a.id);
          })
          // fill: 用值填充指定部分
          Button('fill').onClick(() => {
            this.arrCollect.fill(new Info(5), 0, 2);
          })

          /*****************************不会改变数组本身API***************************/
          // slice：返回新的数组，根据start end对原数组的拷贝，不会改变原数组，所以直接调用slice不会触发UI刷新
          // 可以构建用例为返回的浅拷贝的数据赋值给this.arrCollect,需要注意这里依然要调用makeObserved，否则this.arr被普通变量赋值后，会丧失观察能力
          Button('slice').onClick(() => {
            this.arrCollect = UIUtils.makeObserved(this.arrCollect.slice(0, 1));
          })
          // map：原理同上
          Button('map').onClick(() => {
            this.arrCollect = UIUtils.makeObserved(this.arrCollect.map((value) => {
              value.id += 10;
              return value;
            }))
          })
          // filter：原理同上
          Button('filter').onClick(() => {
            this.arrCollect = UIUtils.makeObserved(this.arrCollect.filter((value: Info) => value.id % 2 === 0));
          })

          // concat：原理同上
          Button('concat').onClick(() => {
            let array1 = new collections.Array(new Info(100))
            this.arrCollect = UIUtils.makeObserved(this.arrCollect.concat(array1));
          })
        }.height('200%')
      }.height('100%')
    }
    .height('100%')
    .width('100%')
  }
}
// [End makeObserved_collections_Array_Set_Map]