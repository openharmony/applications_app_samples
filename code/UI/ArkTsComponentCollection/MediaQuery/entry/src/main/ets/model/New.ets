/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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
export interface NewsItem {
  title: Resource | string;
  publisher: Resource | string;
  newId: number;
}

export interface NewsContentItem {
  newId: number;
  content: Resource;
  img: Resource;
}

export interface RouteParams {
  newId: number;
  title: Resource | string;
}

export const newsList: NewsItem[] =
  [{ title: $r('app.string.new_title1'), publisher: $r('app.string.new_publisher1'), newId: 0 },
    { title: $r('app.string.new_title2'), publisher: $r('app.string.new_publisher2'), newId: 1 },
    { title: $r('app.string.new_title3'), publisher: $r('app.string.new_publisher3'), newId: 2 },
    { title: $r('app.string.new_title4'), publisher: $r('app.string.new_publisher4'), newId: 3 }]

export const newsContent: NewsContentItem[] =
  [{ newId: 0, content: $r('app.string.new_content1'), img: $r('app.media.new1') },
    { newId: 1, content: $r('app.string.new_content2'), img: $r('app.media.new2') },
    { newId: 2, content: $r('app.string.new_content3'), img: $r('app.media.new3') },
    { newId: 3, content: $r('app.string.new_content4'), img: $r('app.media.new4') }]

export function getNew(id: number): NewsContentItem | undefined {
  const item = newsContent.find(item => item.newId === id);
  return item ? {
    newId: item.newId, // 显式拷贝每个属性
    content: item.content,
    img: item.img
  } : undefined;
}