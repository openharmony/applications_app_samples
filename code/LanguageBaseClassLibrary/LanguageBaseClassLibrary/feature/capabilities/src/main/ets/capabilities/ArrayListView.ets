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

import ArrayList from '@ohos.util.ArrayList';
import { AddDialog } from '../components/arraylistcomponents/AddDialog';
import { ArrayListItem } from '../components/arraylistcomponents/ArrayListItem';
import { Information } from '../model/Information';
import { logger } from '@ohos/common/src/main/ets/util/Logger';

const TAG: string = 'ArrayListView';

@Preview
@Component
export struct ArrayListView {
  @State dataSource: Information[] = [];
  private informations: ArrayList<Information> = new ArrayList();
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({
      saveData: (writeInformation: Information) => {
        this.informations.add(writeInformation);
        this.dataSource = this.informations.convertToArray();
        logger.info(TAG, `this.list= ${this.dataSource.length}`);
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default
  });

  build() {
    Column() {
      Row() {
        Blank()
        Button() {
          Image($r('app.media.ic_add'))
            .height(35)
            .width('100%')
            .objectFit(ImageFit.Contain)
            .align(Alignment.End)
        }
        .key('addBtn')
        .width(35)
        .type(ButtonType.Normal)
        .backgroundColor($r("app.color.button_bg"))
        .align(Alignment.End)
        .onClick(() => {
          this.dialogController.open();
          logger.info(TAG, `enter the AddDialog`);
        })
      }
      .width('100%')

      List({ space: 12 }) {
        ForEach(this.dataSource, (item: Information, index: number) => {
          ListItem() {
            ArrayListItem({ information: item, index: index, handleOnClick: this.handleOnClick })
          }
        }, (item: Information, index: number) => JSON.stringify(item) + index)
      }
      .margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
  }

  handleOnClick = (index: number) => {
    this.informations.removeByIndex(index);
    this.dataSource = this.informations.convertToArray();
  }
}