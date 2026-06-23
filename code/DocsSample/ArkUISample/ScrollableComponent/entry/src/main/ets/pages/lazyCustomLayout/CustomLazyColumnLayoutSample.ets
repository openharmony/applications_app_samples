/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { LazyDynamicLayout, LazyDynamicLayoutAttribute } from '@kit.ArkUI';
import { LazyColumnLayoutAlgorithm } from './LazyColumnLayoutAlgorithm';

class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  protected dataArray: T[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): T {
    return this.dataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }
}

class MyDataSource<T> extends BasicDataSource<T> {
  public pushData(data: T): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

// [Start lazy_custom_layout_create]
@Component
export struct CustomLazyColumnLayoutSample {
  // [StartExclude lazy_custom_layout_create]
  // [Start lazy_custom_layout_dynamic_param]
  @State @Watch('onRowGapChange') rowGap: number = 5;
  // [End lazy_custom_layout_dynamic_param]
  private arr: MyDataSource<string> = new MyDataSource<string>();
  private lazyAlgorithm: LazyColumnLayoutAlgorithm = new LazyColumnLayoutAlgorithm(this.getUIContext());

  // [Start lazy_custom_layout_unit_convert]
  onRowGapChange(): void {
    this.lazyAlgorithm.setRowGap(this.getUIContext().vp2px(this.rowGap));
  }
  // [End lazy_custom_layout_unit_convert]
  // [EndExclude lazy_custom_layout_create]

  aboutToAppear(): void {
    this.lazyAlgorithm.setRowGap(this.getUIContext().vp2px(this.rowGap));
    for (let i = 0; i < 50; i++) {
      this.arr.pushData(`Item ${i}`);
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        List() {
          // [Start lazy_custom_layout_on_visible_indexes_change]
          LazyDynamicLayout(this.lazyAlgorithm) {
            // [StartExclude lazy_custom_layout_on_visible_indexes_change]
            // [StartExclude lazy_custom_layout_create]
            LazyForEach(this.arr, (item: string) => {
              Text(item)
                .height(80)
                .width('100%')
                .borderRadius(8)
                .backgroundColor('#E0E0FF')
                .padding(10)
                .textAlign(TextAlign.Center)
            })
            // [EndExclude lazy_custom_layout_create]
            // [EndExclude lazy_custom_layout_on_visible_indexes_change]
          }
          .onVisibleIndexesChange((child: number[]) => {
            console.info(`onVisibleIndexesChange: ${child}`);
          })
          // [End lazy_custom_layout_on_visible_indexes_change]
          .width('100%')
        }
        .width('100%')
        .height('100%')
        .padding({ left: 12, right: 12 })

        Button(`RowGap: ${this.rowGap}vp`)
          .fontSize(12)
          .onClick(() => {
            this.rowGap = this.rowGap === 5 ? 10 : 5;
          })
          .margin({ bottom: 20 })
      }
      .height('100%')
      .width('100%')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.customLazyColumnLayout_title'))
  }
}
// [End lazy_custom_layout_create]