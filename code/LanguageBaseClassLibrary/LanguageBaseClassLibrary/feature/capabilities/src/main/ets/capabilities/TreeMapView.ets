/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import emitter from '@ohos.events.emitter';
import { EmptyPage } from '@ohos/common/src/main/ets/components/EmptyPage';
import { KeyValuePair } from '../model/KeyValuePair';
import { TreeMapDataSource } from '../components/treemapcomponents/TreeMapDataSource';
import { KeyValueItemView } from '../components/KeyValueItemView';
import { Constant } from '../Constant';

const MIN_LENGTH = 0;

@Component
export struct TreeMapView {
  private dataSource: TreeMapDataSource = new TreeMapDataSource();
  @State totalCount: number = MIN_LENGTH;

  aboutToAppear() {
    emitter.on({ eventId: Constant.EMITTER_ID_TREE_MAP }, (eventData) => {
      this.dataSource.addData(eventData.data as KeyValuePair);
      this.totalCount = this.dataSource.totalCount();
    });
  }

  aboutToDisappear() {
    emitter.off(Constant.EMITTER_ID_TREE_MAP);
  }

  build() {
    Column() {
      if (this.totalCount > MIN_LENGTH) {
        List() {
          LazyForEach(this.dataSource, (item: KeyValuePair, index: number) => {
            ListItem() {
              KeyValueItemView({ index: index, keyValuePair: item, deleteAction: () => {
                this.dataSource.deleteData(item.key);
                this.totalCount = this.dataSource.totalCount();
              } })
            }
            .height(72)
            .width('100%')
            .margin({ bottom: 20 })
          }, (item: KeyValuePair, index: number) => JSON.stringify(item) + index)
        }
        .width('100%')
        .layoutWeight(1)

      } else {
        EmptyPage()
      }
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }
}