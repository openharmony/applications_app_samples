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

import data_rdb from '@ohos.data.relationalStore'
import common from '@ohos.app.ability.common'
import ContactDataSource from '../common/BasicDataSource'
import RdbModel from '../model/RdbModel'
import { QueryItem } from '../common/QueryItem'
import { TABLE_NAME, SQL_CREATE_TABLE, COLUMNS } from '../model/RdbConst'


@Entry
@Component
struct SearchPage {
  private searchText: string = ''
  private contacts: ContactDataSource = new ContactDataSource()
  private rdbModel = new RdbModel(TABLE_NAME, SQL_CREATE_TABLE, COLUMNS, getContext(this) as common.UIAbilityContext)

  async getData() {
    if (this.searchText === '') {
      this.contacts['dataArray'] = []
      this.contacts.notifyDataReload()
      return
    }
    let predicates = new data_rdb.RdbPredicates(TABLE_NAME)
    predicates.contains('name', this.searchText)
      .or()
      .contains('phone', this.searchText)
      .or()
      .contains('remark', this.searchText)
    this.contacts['dataArray'] = await this.rdbModel.query(predicates)
    this.contacts.notifyDataReload()
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.search_gray'))
          .height('100%').width(40)
          .margin({ left: 16 })
          .objectFit(ImageFit.Contain)

        TextInput({ placeholder: $r('app.string.search_placeholder') })
          .height('85%')
          .width('80%')
          .fontSize(25)
          .margin({ right: 10 })
          .backgroundColor('#FAFAFA')
          .onChange((value: string) => {
            this.searchText = value
            this.getData()
          })
      }
      .width('95%')
      .height('7%')
      .backgroundColor('#FAFAFA')
      .constraintSize({ minHeight: 60 })
      .border({ radius: 45 })
      .margin({ top: 10 })

      List() {
        LazyForEach(this.contacts, item => {
          ListItem() {
            QueryItem({ contact: item })
          }
        }, item => item.name)
      }
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 16, endMargin: 16 })
    }
  }
}