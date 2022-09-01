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

import Logger from '../util/Logger'

const TAG: string = 'BookModel'

export class BookModel {
  id: number
  name: string
  introduction: string

  constructor(id: number, name: string, introduction: string) {
    this.id = id
    this.name = name
    this.introduction = introduction
  }
}

export function getBooksFromResultSet(resultSet) {
  let books = []
  Logger.info(TAG, `getBooksFromResultSet columnNames= ${resultSet.columnNames}, rowCount= ${resultSet.rowCount}`)
  if (resultSet !== null) {
    resultSet.goToFirstRow()
    let idIndex = resultSet.getColumnIndex('id')
    let nameIndex = resultSet.getColumnIndex('name')
    let introductionIndex = resultSet.getColumnIndex('introduction')
    Logger.info(TAG, `ID = ${resultSet.getColumnIndex('id')}, name = ${resultSet.getColumnIndex('name')},
              introduction = ${resultSet.getColumnIndex('introduction')}`)
    for (let i = 0; i < resultSet.rowCount; i++) {
      let id = resultSet.getDouble(idIndex)
      let name = resultSet.getString(nameIndex)
      let introduction = resultSet.getString(introductionIndex)
      Logger.info(TAG, `id = ${id}, name = ${name}, introduction = ${introduction}`)
      books.push(new BookModel(id, name, introduction))
      Logger.info(TAG, `getBooksFromResultSet resultSet books: ${JSON.stringify(books)}`)
      resultSet.goToNextRow()
    }
  }
  return books
}