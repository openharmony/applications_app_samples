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

// [Start reusable_for_water_flow_usage_scenario]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_ReusableComponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'ReusableComponent_';

class WaterFlowDataSource implements IDataSource {
  private dataArray: number[] = [];
  private listeners: DataChangeListener[] = [];

  constructor() {
    for (let i = 0; i < 60; i++) { // 循环60次
      this.dataArray.push(i);
    }
  }

  // 获取索引对应的数据。
  public getData(index: number): number {
    return this.dataArray[index];
  }

  // 通知控制器增加数据。
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  // 获取数据总数。
  public totalCount(): number {
    return this.dataArray.length;
  }

  // 注册改变数据的控制器。
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 注销改变数据的控制器。
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 在数据尾部增加一个元素。
  public addLastItem(): void {
    this.dataArray.splice(this.dataArray.length, 0, this.dataArray.length);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

@Reusable
@Component
struct ReusableFlowItem {
  @State item: number = 0;

  // 从复用缓存中加入到组件树之前调用，可在此处更新组件的状态变量以展示正确的内容。
  aboutToReuse(params: ESObject) {
    this.item = params.item;
    hilog.info(DOMAIN, TAG, BUNDLE + '=====aboutToReuse====FlowItem==复用了==' + this.item);
  }

  aboutToRecycle(): void {
    hilog.info(DOMAIN, TAG, BUNDLE + '=====aboutToRecycle====FlowItem==回收了==' + this.item);
  }

  build() {
    // 请开发者自行在src/main/resources/base/media路径下添加app.media.app_icon图片，否则运行时会因资源缺失而报错。
    Column() {
      Text('N' + this.item).fontSize(24).height('26').margin(10);
      Image($r('app.media.app_icon'))
        .objectFit(ImageFit.Cover)
        .width(50)
        .height(50);
    }
  }
}

@Entry
@Component
struct Index {
  @State minSize: number = 50; // 最小值50
  @State maxSize: number = 80; // 最大值80
  @State fontSize: number = 24; // 字体大小为24
  @State colors: number[] = [0xFFC0CB, 0xDA70D6, 0x6B8E23, 0x6A5ACD, 0x00FFFF, 0x00FF7F];
  scroller: Scroller = new Scroller();
  dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  private itemWidthArray: number[] = [];
  private itemHeightArray: number[] = [];

  // 计算flow item宽/高。
  getSize() {
    let ret = Math.floor(Math.random() * this.maxSize);
    return (ret > this.minSize ? ret : this.minSize);
  }

  // 保存flow item宽/高。
  getItemSizeArray() {
    for (let i = 0; i < 100; i++) { // 循环100次
      this.itemWidthArray.push(this.getSize());
      this.itemHeightArray.push(this.getSize());
    }
  }

  aboutToAppear() {
    this.getItemSizeArray();
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column({ space: 2 }) {
        Button('back top')
          .height('5%')
          .onClick(() => {
            // 点击后回到顶部。
            this.scroller.scrollEdge(Edge.Top);
          })
        WaterFlow({ scroller: this.scroller }) {
          LazyForEach(this.dataSource, (item: number) => {
            FlowItem() {
              ReusableFlowItem({ item: item })
            }.onAppear(() => {
              if (item + 20 == this.dataSource.totalCount()) { // 阈值为20
                for (let i = 0; i < 50; i++) { // 循环50次
                  this.dataSource.addLastItem();
                }
              }
            })

          })
        }
      }
    }
  }
}
// [End reusable_for_water_flow_usage_scenario]
