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

export class NewsData {
  title: string;
  image: Resource;
  detail: Resource;
  constructor(title: string, image: Resource, detail: Resource) {
    this.title = title;
    this.image = image;
    this.detail = detail;
  }
}

export function initNewsData(): Array<NewsData> {
  const newsComposition: NewsData[] = [
    { 'title': 'News1', 'image': $r('app.media.new1'), 'detail': $r('app.string.news1') },
    { 'title': 'News2', 'image': null, 'detail': $r('app.string.news2') },
    { 'title': 'News3', 'image': $r('app.media.new3'), 'detail': $r('app.string.news3') },
    { 'title': 'News4', 'image': $r('app.media.new4'), 'detail': $r('app.string.news4') },
    { 'title': 'News5”', 'image': $r('app.media.new5'), 'detail': $r('app.string.news5') }
  ]

  let newsDataArray: Array<NewsData> = []
  for (let index = 0; index < 100; index++) {
    newsComposition.forEach(item => {
      newsDataArray.push(new NewsData(item.title, item.image, item.detail));
    })
  }
  return newsDataArray;
}