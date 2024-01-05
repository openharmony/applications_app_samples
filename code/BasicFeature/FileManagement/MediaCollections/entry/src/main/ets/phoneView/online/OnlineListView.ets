/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import util from '@ohos.util'
import Logger from '../../model/Logger'
import { JsonItem } from '../../model/JsonListData'
import OnlineListItemView from './OnlineListItemView'

const TAG: string = "OnlineListView"

@Component
export default struct OnlineListView {
  // 一级列表
  @State jsonDataList: JsonItem[] = []
  @State clickIndex: number = -1

  aboutToAppear() {
    this.readTabJson()
  }

  /**
   * 引入并解析JSON文件
   */
  async readTabJson() {
    let jsonStr: string = ''
    // 引入JSON文件
    try {
      // 1.获取文件内容
      let uint8Array = await getContext(this).resourceManager.getRawFileContent('DTA.exolist.json')
      // 2.创建文本解码器
      let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true })
      // 3.解码
      jsonStr = textDecoder.decodeWithStream(uint8Array, { stream: false })
    } catch (err) {
      Logger.info(TAG, 'JSON file import error：' + err)
    }
    // 解析JSON数据
    this.jsonDataList = JSON.parse(jsonStr) as JsonItem[]
  }

  build() {
    Column() {
      List() {
        ForEach(this.jsonDataList, (item: JsonItem, index: number) => {
          ListItem() {
            OnlineListItemView({
              firstItem: item,
              index: index,
              clickIndex: $clickIndex
            })
          }
        }, (item: JsonItem) => JSON.stringify(item))
      }
      .divider({
        strokeWidth: 1,
        color: Color.Gray,
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0x303030)
  }
}