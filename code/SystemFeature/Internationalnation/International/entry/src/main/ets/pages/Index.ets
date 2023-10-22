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
import router from '@ohos.router';
import TitleBar from '../components/TitleBar';
import OperationView from '../components/OperationView';
import ResourceUtil from '../utils/ResourceUtil';

const operationUrls: Array<string> = ['international/pages/Language', 'international/pages/DateAndTime', 'international/pages/Examples'];

@Entry
@Component
struct Index {
  @State operations: Array<string> = [];

  aboutToAppear() {
    this.getOperation();
  }

  async getOperation() {
    this.operations = await ResourceUtil.getStringArray($r('app.strarray.operation_arr').id);
  }

  build() {
    Column() {
      TitleBar()
      ForEach(this.operations, (item: string, index: number) => {
        Row() {
          OperationView({ mKey: item, value: '', handleClick: () => {
            router.push({
              url: operationUrls[index]
            });
          } })
        }
      }, (item: string) => item)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.f5f5f5'))
  }
}