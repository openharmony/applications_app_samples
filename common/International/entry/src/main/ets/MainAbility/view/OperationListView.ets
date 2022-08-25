/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): any {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdded(index)
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChanged(index)
    })
  }
}

class MyDataSource extends BasicDataSource {
  public dataArray: string[] = []

  constructor(ele) {
    super()
    for (var index = 0;index < ele.length; index++) {
      this.dataArray.push(ele[index])
    }
  }

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): any {
    return this.dataArray[index]
  }

  public addData(index: number, data: string): void {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }
}

@Component
export default struct OperationListView {
  private title: string | Resource = ''
  private operations: Array<{
    key: string,
    value: string
  }> = []
  private handleItemClick: (index: number) => void

  @Builder
  OperationItem(operationInfo, index) {
    Column() {
      if (index !== 0) {
        Divider()
          .color(Color.Gray)
          .width('100%')
          .strokeWidth(1)
          .margin({ top: 10, bottom: 10 })
      }
      Text(operationInfo.key)
        .fontSize(25)
        .width('100%')
        .margin({ top: 10, bottom: 10 })
      if (operationInfo.value !== '') {
        Text(operationInfo.value)
          .fontColor(Color.Gray)
          .fontSize(25)
          .width('100%')
          .margin({ top: 10, bottom: 10 })
      }
    }
    .width('100%')
    .onClick(() => {
      if (this.handleItemClick) {
        this.handleItemClick(index)
      }
    })
  }

  build() {
    Column() {
      Text(this.title)
        .width('95%')
        .margin({ left: 10, top: 15 })
        .fontSize(22)
        .fontColor(Color.Gray)
      Column() {
        LazyForEach(new MyDataSource(this.operations), (item, index) => {
          this.OperationItem(item, index)
        }, item => item.key)
      }
      .width('95%')
      .backgroundColor(Color.White)
      .margin({ top: 10 })
      .padding(10)
      .border({ color: Color.White, width: 1, radius: 15 })
    }
  }
}