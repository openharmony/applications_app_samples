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

import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import { Logger } from '@ohos/feature-file-manager'

export default class FileDataSource implements IDataSource {
  private listener: DataChangeListener
  private fileList: Array<mediaLibrary.FileAsset> = new Array<mediaLibrary.FileAsset>()

  totalCount(): number {
    let count = this.fileList.length
    Logger.debug('totalCount:' + count)
    return count
  }

  getData(index: number): mediaLibrary.FileAsset {
    let file = this.fileList[index]
    Logger.debug('getData index:' + index + ' name:' + file.displayName)
    return file
  }

  pushData(fileAsset: mediaLibrary.FileAsset) {
    this.fileList.push(fileAsset)
    this.listener.onDataAdd(this.totalCount() - 1)
  }

  pushDataList(fileAssets: Array<mediaLibrary.FileAsset>) {
    fileAssets.forEach(element => {
      this.fileList.push(element)
    })
    this.listener.onDataReloaded()
  }

  deleteData(index: number) {
    this.fileList.splice(index, 1) // delete 1 item
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    this.listener = undefined
  }
}