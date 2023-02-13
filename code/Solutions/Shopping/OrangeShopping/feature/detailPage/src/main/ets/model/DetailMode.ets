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

export class SwiperPicturesModel {
  constructor(public src: Resource) {
    this.src = src
  }
}

export class CommentModel {
  constructor(public url: Resource, public user: string, public img: Resource, public text: string) {
    this.url = url
    this.user = user
    this.img = img
    this.text = text
  }
}

export class ProductDataModel {
  constructor(public id: number, public uri: Resource, public title: Resource, public info: Resource, public labels: Resource, public price: Resource) {
    this.id = id
    this.uri = uri
    this.info = info
    this.title = title
    this.labels = labels
    this.price = price
  }
}