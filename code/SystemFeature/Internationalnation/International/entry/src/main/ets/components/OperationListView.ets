/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import LazyDataSource, { BaseData } from '../utils/LazyDataSource';

@Component
export default struct OperationListView {
  private title: string | Resource = '';
  private operations: Array<BaseData> = [];
  private handleItemClick: (index: number) => void = () => {};
  private operationData: LazyDataSource = new LazyDataSource();

  aboutToAppear() {
    this.operationData.dataArray = this.operations;
    this.operationData.notifyDataReload();
  }

  @Builder
  OperationItem($$: Data) {
    Column() {
      if ($$.index !== 0) {
        Divider()
          .color($r('app.color.divider'))
          .width('100%')
          .strokeWidth(1)
          .margin({ top: 10, bottom: 10 })
      }
      Text($$.operationInfo.key)
        .fontSize(22)
        .width('100%')
        .margin({ top: 10, bottom: 10 })
      if ($$.operationInfo.value !== '') {
        Text($$.operationInfo.value)
          .fontColor($r('app.color.gray'))
          .fontSize(20)
          .width('100%')
          .margin({ top: 10, bottom: 10 })
      }
    }
    .width('100%')
    .onClick(() => {
      if (this.handleItemClick) {
        this.handleItemClick($$.index)
      }
    })
  }

  build() {
    Column() {
      Text(this.title)
        .width('95%')
        .margin({ left: 10, top: 15 })
        .fontSize(20)
        .fontColor($r('app.color.gray'))
      Column() {
        List() {
          LazyForEach(this.operationData, (item: BaseData, index: number) => {
            ListItem() {
              this.OperationItem(new Data(item, index));
            }
          }, (item: BaseData) => item.key)
        }
      }
      .width('95%')
      .backgroundColor($r('app.color.white'))
      .margin({ top: 10 })
      .padding(10)
      .border({ color: $r('app.color.white'), width: 1, radius: 15 })
    }
  }
}

class Data {
  operationInfo: BaseData = new BaseData();
  index: number = 0;

  constructor(operationInfo: BaseData, index: number) {
    this.operationInfo = operationInfo;
    this.index = index;
  }
}