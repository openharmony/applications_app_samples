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

// [Start image_flickering_during_rerenders]
import { hilog } from '@kit.PerformanceAnalysisKit';
const TAG = '[Sample_RenderingControl]';
const DOMAIN = 0xF811;

class ImageFliceringDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: ImageFliceringStringData[] = [];

  public totalCount(): number {
    return this.originDataArray.length;
  }

  public getData(index: number): ImageFliceringStringData {
    return this.originDataArray[index];
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

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    });
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    });
  }
}

class FliceringDataSource extends ImageFliceringDataSource {
  private dataArray: ImageFliceringStringData[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): ImageFliceringStringData {
    return this.dataArray[index];
  }

  public pushData(data: ImageFliceringStringData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

// @Observed类装饰器 和 @ObjectLink 用于在涉及嵌套对象或数组的场景中进行双向数据同步
@Observed
class ImageFliceringStringData {
  public message: string;
  public imgSrc: Resource;

  constructor(message: string, imgSrc: Resource) {
    this.message = message;
    this.imgSrc = imgSrc;
  }
}

@Entry
@Component
struct ImageFlickeringDuringRerenders {
  private data: FliceringDataSource = new FliceringDataSource();

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      // 此处'app.media.img'仅作示例，请开发者自行替换，否则imageSource创建失败会导致后续无法正常执行。
      this.data.pushData(new ImageFliceringStringData(`Hello ${i}`, $r('app.media.img')));
    }
  }

  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: ImageFliceringStringData, index: number) => {
        ListItem() {
          ImageFlickeringChildComponent({ data: item })
        }
        .onClick(() => {
          item.message += '0';
        })
      }, (item: ImageFliceringStringData, index: number) => index.toString()) // 键值不受message属性影响
    }
    .cachedCount(5)
  }
}

@Component
struct ImageFlickeringChildComponent {
  // 用状态变量来驱动UI刷新，而不是通过Lazyforeach的api来驱动UI刷新
  @ObjectLink data: ImageFliceringStringData;

  build() {
    Column() {
      Text(this.data.message).fontSize(50)
        .onAppear(() => {
          hilog.info(DOMAIN, TAG, 'appear: ${this.data.message}');
        })
      Image(this.data.imgSrc)
        .width(500)
        .height(200)
    }.margin({ left: 10, right: 10 })
  }
}
// [End image_flickering_during_rerenders]