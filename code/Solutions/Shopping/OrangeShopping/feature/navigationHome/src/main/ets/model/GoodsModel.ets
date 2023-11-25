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

export class GoodResponse {
  code: number;
  data: Records;
  error: string;

  constructor(code: number, data: Records, error: string) {
    this.code = code;
    this.data = data;
    this.error = error;
  }
}

export class Info {
  id: number;
  uri: string;
  title: string;
  info: string;
  labels: string;
  price: number;

  constructor(id: number, uri: string, title: string, info: string, labels: string, price: number) {
    this.id = id;
    this.uri = uri;
    this.title = title;
    this.info = info;
    this.labels = labels;
    this.price = price;
  }
}

export class Records {
  records: Array<Info>;
  totalCount: number;

  constructor(records: Array<Info>, totalCount: number) {
    this.records = records;
    this.totalCount = totalCount;
  }
}

export class TabTitleModel {
  uri: Resource;
  selectedUri: Resource;
  title: Resource;

  constructor(uri: Resource, selectedUri: Resource, title: Resource) {
    this.uri = uri;
    this.selectedUri = selectedUri;
    this.title = title;
  }
}

export class FavorLiveListsModel {
  id: number;
  imgSrc: Resource;
  title: Resource;
  viewsInfo: Resource;

  constructor(id: number, imgSrc: Resource, title: Resource, viewsInfo: Resource) {
    this.id = id;
    this.imgSrc = imgSrc;
    this.title = title;
    this.viewsInfo = viewsInfo;
  }
}

export class OrderModel {
  id: number;
  img: Resource;
  title: Resource;

  constructor(id: number, img: Resource, title: Resource) {
    this.id = id;
    this.img = img;
    this.title = title;
  }
}

export class ShopCartItemDataModel {
  id: number;
  uri: Resource;
  title: Resource;
  labels: Resource;
  price: Resource;

  constructor(id: number, uri: Resource, title: Resource, labels: Resource, price: Resource) {
    this.id = id;
    this.uri = uri;
    this.title = title;
    this.labels = labels;
    this.price = price;
  }
}

export class SearchTextModel {
  id: number;
  searchText: Resource;

  constructor(id: number, searchText: Resource) {
    this.id = id;
    this.searchText = searchText;
  }
}

export class SwiperModel {
  id: number;
  img: Resource;

  constructor(id: number, img: Resource) {
    this.id = id;
    this.img = img;
  }
}

export class NewProductTitleBarModel {
  id: number;
  title: Resource | undefined = undefined;

  constructor(id: number, title: Resource) {
    this.id = id;
    this.title = title;
  }
}

export class NavDataModel {
  id: number = 0;
  navData: Resource | undefined = undefined;

  constructor(id: number, navData: Resource) {
    this.navData = navData;
    this.id = id;
  }
}

export class TitleBarModel {
  id: number;
  title: Resource | undefined = undefined;
  content: Resource | undefined = undefined;

  constructor(id: number, title: Resource, content: Resource) {
    this.id = id;
    this.title = title;
    this.content = content;
  }
}

export class ProductDataModel {
  id: number;
  uri: ResourceStr;
  title: ResourceStr;
  info: ResourceStr;
  labels: ResourceStr;
  price: ResourceStr;

  constructor(id: number, uri: ResourceStr, title: ResourceStr, info: ResourceStr, labels: ResourceStr, price: ResourceStr) {
    this.id = id;
    this.uri = uri;
    this.info = info;
    this.title = title;
    this.labels = labels;
    this.price = price;
  }
}