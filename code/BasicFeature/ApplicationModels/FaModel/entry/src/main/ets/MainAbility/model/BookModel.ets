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

import Logger from '../util/Logger'

const TAG: string = 'BookModel'

@Observed
class BookModel {
  public id: number
  public name: string
  public introduction: string

  constructor(id: number, name: string, introduction: string) {
    this.id = id
    this.name = name
    this.introduction = introduction
  }
}

function getBooksFromResultSet(resultSet) {
  let books = []
  Logger.info(TAG, `getBooksFromResultSet columnNames= ${resultSet.columnNames}, rowCount= ${resultSet.rowCount}`)
  if (resultSet) {
    resultSet.goToFirstRow()
    for (let i = 0; i < resultSet.rowCount; i++) {
      let book = new BookModel(
      resultSet.getDouble(resultSet.getColumnIndex('id')),
      resultSet.getString(resultSet.getColumnIndex('name')),
      resultSet.getString(resultSet.getColumnIndex('introduction'))
      )
      books.push(book)
      Logger.info(TAG, `getBooksFromResultSet resultSet book: ${JSON.stringify(book)}`)
      resultSet.goToNextRow()
    }
  }
  return books
}

export { BookModel, getBooksFromResultSet }