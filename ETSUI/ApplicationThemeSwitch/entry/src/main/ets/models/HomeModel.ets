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

export class TabTitleModel {
  constructor(public id: number, public uri: Resource, public selectedUri: Resource, public title: Resource) {
    this.id = id
    this.uri = uri
    this.selectedUri = selectedUri
    this.title = title
  }
}

export class SearchTextModel {
  constructor(public searchText: Resource) {
    this.searchText = searchText
  }
}

export class NavigationDataModel {
  constructor(public navigationData: Resource, public id: number) {
    this.navigationData = navigationData
    this.id = id
  }
}

export class SwiperModel {
  constructor(public img: Resource) {
    this.img = img
  }
}

export class TitleBarModel {
  constructor(public id: number, public title: Resource, public content: Resource) {
    this.id = id
    this.title = title
    this.content = content
  }
}

export class ProductDataModel {
  constructor(public id: number, public detail: ProductDataDetail) {
    this.id = id
    this.detail = detail
  }
}

export class ProductDataDetail {
  uri: Resource
  info: Resource
  title: Resource
  labels: Resource
  price: Resource
}

export class GoodResponse {
  code: number
  data: Records
  error: string
}

class Records {
  records: Array<RecordsInfo>
  totalCount: number
}

class RecordsInfo {
  id: number
  detail: RecordDetails
}

class RecordDetails {
  uri: string
  title: string
  info: string
  labels: string
  price: number
}