/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import prompt from '@ohos.prompt'
import common from '@ohos.app.ability.common'
import { Record } from '../model/Record'
import MediaManager from '../model/MediaManager';

@CustomDialog
export struct RenameDialog {
  private controller: CustomDialogController
  private record: Record = new Record(getContext(this) as common.UIAbilityContext)
  private newName: string = ''
  private renameCallback: (newName: string) => void
  private recordList: Array<Record> = [];
  private mediaManager = new MediaManager(getContext(this) as common.UIAbilityContext);
  
  async aboutToAppear() {
    this.newName = this.record.fileAsset.title
    this.recordList = await this.mediaManager.queryAllAudios();
  }

  build() {
    Column() {
      TextInput({ placeholder: 'input name', text: this.record.fileAsset.title })
        .type(InputType.Normal)
        .placeholderColor(Color.Gray)
        .maxLength(20)
        .fontSize(19)
        .onChange((value: string) => {
          this.newName = value
        })
        .key('renameInput')
      Row() {
        Button() {
          Text($r('app.string.sure'))
            .fontColor(Color.Blue)
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          if (this.newName === '') {
            prompt.showToast({ message: 'input name' })
            return
          }
          this.controller.close()
          let filterResult: Array<Record> = this.recordList.filter((item: Record) => {
            return item.fileAsset.title === this.newName;
          })
          if (this.newName != this.record.fileAsset.title && filterResult.length === 0) {
            this.renameCallback(this.newName)
          } else {
            prompt.showToast({ message: 'File name already exists' });
          }
        })

        Button() {
          Text($r('app.string.cancel'))
            .fontColor(Color.Red)
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          this.controller.close()
        })
      }
      .width('100%')
      .margin({ top: '3%' })
    }
    .padding('3%')
  }
}