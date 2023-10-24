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

export interface GoodResponse {
  code: number
  data: Records
  error: string
}

interface Info {
  id: number
  uri: string
  title: string
  info: string
  label: string
  price: number
}

interface Records {
  records: Array<Info>
  totalCount: number
}

export class TabTitleModel {
  public uri: Resource
  public selectedUri: Resource
  public title: Resource

  constructor(uri: Resource, selectedUri: Resource, title: Resource) {
    this.uri = uri
    this.selectedUri = selectedUri
    this.title = title
  }
}

export interface ShopCartItemDataModel {
  id: number
  uri: Resource
  title: Resource
  label: Resource
  price: Resource
}

export interface  ProductDataModel {
  id: number
  uri: Resource
  title: Resource
  info: Resource | undefined
  label: Resource
  price: Resource
}