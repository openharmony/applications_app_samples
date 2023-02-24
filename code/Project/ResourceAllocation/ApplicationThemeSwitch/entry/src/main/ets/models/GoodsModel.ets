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
  labels: string
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

export class FavorLiveListsModel {
  constructor(public id: number, public imgSrc: Resource, public title: Resource, public viewsInfo: Resource) {
    this.id = id
    this.imgSrc = imgSrc
    this.title = title
    this.viewsInfo = viewsInfo
  }
}

export class OrderModel {
  constructor(public id: number, public img: Resource, public title: Resource) {
    this.id = id
    this.img = img
    this.title = title
  }
}

export class ShopCartItemDataModel {
  constructor(public id: number, public uri: Resource, public title: Resource, public labels: Resource, public price: Resource) {
    this.id = id
    this.uri = uri
    this.title = title
    this.labels = labels
    this.price = price
  }
}

export class SearchTextModel {
  constructor(public id: number, public searchText: Resource) {
    this.id = id
    this.searchText = searchText
  }
}

export class SwiperModel {
  constructor(public id: number, public img: Resource) {
    this.id = id
    this.img = img
  }
}

export class NewProductTitleBarModel {
  constructor(public id: number, public title: Resource) {
    this.id = id
    this.title = title
  }
}

export class NavDataModel {
  constructor(public navData: Resource, public id: number) {
    this.navData = navData
    this.id = id
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
  constructor(public id: number, public uri: Resource, public title: Resource, public info: Resource,
              public labels: Resource, public price: Resource) {
    this.id = id
    this.uri = uri
    this.info = info
    this.title = title
    this.labels = labels
    this.price = price
  }
}