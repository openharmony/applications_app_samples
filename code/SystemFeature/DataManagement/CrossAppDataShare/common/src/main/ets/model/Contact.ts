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

import type rdb from '@ohos.data.relationalStore'
import DataShareResultSet from '@ohos.data.DataShareResultSet'
import { logger } from '../utils/Logger'

const TAG: string = 'Contact'

export class Contact {
  id: number
  name: string
  phone: string
  email: string
  address: string
  remark: string
}

export function arrayToString(phones: string[]) {
  let phoneResult = ''
  if (phones.length === 1) {
    phoneResult += phones[0]
  } else {
    for (let i = 0;i < phones.length; i++) {
      phoneResult += phones[i]
      if (i < phones.length - 1) {
        phoneResult += ','
      }
    }
  }
  return phoneResult
}

export function getListFromResultSet(resultSet: rdb.ResultSet | DataShareResultSet) {
  logger.info(TAG, 'getListFromResultSet')
  let contacts: Array<Contact> = []
  logger.info(TAG, `row count:${resultSet.rowCount}`)
  resultSet.goToFirstRow()
  for (let i = 0;i < resultSet.rowCount; i++) {
    let contact: Contact = {
      id: resultSet.getDouble(resultSet.getColumnIndex('id')),
      name: resultSet.getString(resultSet.getColumnIndex('name')),
      phone: resultSet.getString(resultSet.getColumnIndex('phone')),
      email: resultSet.getString(resultSet.getColumnIndex('email')),
      address: resultSet.getString(resultSet.getColumnIndex('address')),
      remark: resultSet.getString(resultSet.getColumnIndex('remark'))
    }
    if (!contacts.includes(contact)) {
      contacts.push(contact)
    }
    resultSet.goToNextRow()
  }
  resultSet.close()
  contacts.sort((src1: Contact, src2: Contact) => {
    return src1.name.localeCompare(src2.name, 'zh')
  })
  return contacts
}