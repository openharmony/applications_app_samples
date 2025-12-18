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
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

// [Start visible_content_position]
// xxx.ets
class MyDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private dataArray: string[] = ['0', '1', '2', '3', '4', '5', '6'];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): string | undefined {
    return this.dataArray[index];
  }

  public addData(index: number, data: string): void {
    this.dataArray.splice(index, 0, data);
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      hilog.info(DOMAIN, 'testTag', 'add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      hilog.info(DOMAIN, 'testTag', 'remove listener');
      this.listeners.splice(pos, 1);
    }
  }
}

@Entry
@Component
export struct SwiperVisibleContentPosition {
  private data: MyDataSource = new MyDataSource();
  @State index: number = 3;

  build() {
    // [StartExclude visible_content_position]
    NavDestination() {
      // [EndExclude visible_content_position]
      Column({ space: 12 }) {
        // [StartExclude visible_content_position]
        // 请将$r('app.string.SwiperVisibleContentPosition_title')替换为实际资源文件，在本示例中该资源文件的value值为"保持可见内容位置不变"
        ComponentCard({ title: $r('app.string.SwiperVisibleContentPosition_title') }) {
          Column({ space: 20 }) {
            // [EndExclude visible_content_position]
            Swiper() {
              LazyForEach(this.data, (item: string) => {
                Text(item.toString())
                  .width('90%')
                  .height(160)
                  .backgroundColor(0xAFEEEE)
                  .textAlign(TextAlign.Center)
                  .fontSize(30)
              })
            }
            .onChange((index) => {
              this.index = index;
            })
            .index(3)
            .maintainVisibleContentPosition(true)
            // [StartExclude visible_content_position]
            .displayArrow({
              showBackground: true,
              isSidebarMiddle: true,
              backgroundSize: 24,
              backgroundColor: Color.White,
              arrowSize: 18,
              arrowColor: Color.Blue
            }, false)
            // [EndExclude visible_content_position]

            Column({ space: 12 }) {
              Text('index:' + this.index).fontSize(20)
              Row() {
                // 在LazyForEach索引为0的位置添加数据
                Button('header data add').height(30).onClick(() => {
                  this.data.addData(0, 'header Data');
                })
                // 删除LazyForEach索引为0的位置数据
                Button('header data delete').height(30).onClick(() => {
                  this.data.deleteData(0);
                })
              }
            }.margin(5)
            // [StartExclude visible_content_position]
          }.width('100%')
        }
        // [EndExclude visible_content_position]
      }.width('100%')
      .margin({ top: 5 })
      // [StartExclude visible_content_position]
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.SwiperVisibleContentPosition_title')替换为实际资源文件，在本示例中该资源文件的value值为"保持可见内容位置不变"
    .title($r('app.string.SwiperVisibleContentPosition_title'))
    // [EndExclude visible_content_position]
  }
}
// [End visible_content_position]