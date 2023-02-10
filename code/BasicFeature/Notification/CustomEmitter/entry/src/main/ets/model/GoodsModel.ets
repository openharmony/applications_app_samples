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

export class GoodResponse {
  code: number
  data: Records
  error: string
}

class Info {
  id: number
  uri: string
  title: string
  info: string
  label: string
  price: number
}

class Records {
  records: Array<Info>
  totalCount: number
}

export class TabTitleModel {
  constructor(public uri: Resource, public selectedUri: Resource, public title: Resource) {
    this.uri = uri
    this.selectedUri = selectedUri
    this.title = title
  }
}

export class ShopCartItemDataModel {
  constructor(public id: number, public uri: Resource, public title: Resource, public label: Resource, public price: Resource) {
    this.id = id
    this.uri = uri
    this.title = title
    this.label = label
    this.price = price
  }
}
export class ProductDataModel {
  constructor(public id: number, public uri: Resource, public title: Resource, public info: Resource, public label: Resource, public price: Resource) {
    this.id = id
    this.uri = uri
    this.info = info
    this.title = title
    this.label = label
    this.price = price
  }
}