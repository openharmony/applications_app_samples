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

import systemTime from '@ohos.systemDateTime';
import { ListModel } from '../model/ListModel';
import { RadiusColumn } from '../components/RadiusColumn';
import { ThermalUtil} from '../util/ThermalUtil';

@Extend(Text) function fancy() {
  .height(50)
  .fontSize(16)
  .fontWeight(500)
};

@Component
export struct Thermal {
  @State table: ListModel[] = [
    new ListModel('Thermal level', ThermalUtil.getLevel),
    new ListModel('Callback level', null),
    new ListModel('Last callback time', null)
  ];

  aboutToAppear() {
    this.initThermal();
  }

  aboutToDisappear() {
    ThermalUtil.unregisterThermalLevelCallback();
  }

  build() {
    List() {
      ForEach(this.table, (item) => {
        ListItem() {
          RadiusColumn() {
            Row() {
              Text(item.title)
                .textAlign(TextAlign.Start)
                .fancy()
              Blank()
              Text(item.getValue())
                .textAlign(TextAlign.End)
                .fancy()
            }
            .width('100%')
          }
        }
      })
    }
    .margin({ top: 12, bottom: 12 })
    .width('100%')
  }

  initThermal() {
    const INDEX_0 = 0;
    const INDEX_1 = 1;
    ThermalUtil.registerThermalLevelCallback((level: Number) => {
      this.table[INDEX_0] = new ListModel('Thermal level', null, ThermalUtil.getLevel());
      this.table[INDEX_1] = new ListModel('Callback level', null, ThermalUtil.getStrLevel(level));
      this.getCurrentTime();
    });
  }

  getCurrentTime() {
    const INDEX_2 = 2;
    systemTime.getCurrentTime().then((date: number) => {
      this.table[INDEX_2] = new ListModel('Last callback time', null, ThermalUtil.timestampToTime(date));
    });
  }
}