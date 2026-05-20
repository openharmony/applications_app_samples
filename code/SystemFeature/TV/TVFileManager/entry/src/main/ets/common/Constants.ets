/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { MediaType } from '../model/MediaType'

export const TABS: string[] = ['本机', '外部储存'];

export const DEFAULT_TIME_US = 1000;

export const LIST_CACHE_COUNT = 6;

export const DEFAULT_THUMB_WIDTH = 96;

export const DEFAULT_THUMB_HEIGHT = 96;

export interface MediaTypeModel {
  image: Resource
  title: ResourceStr
  mediaType?: MediaType
}

export const MEDIA_TYPE: MediaTypeModel[] = [
  {
    image: $r('app.media.ic_video'),
    title: $r('app.string.media_type_video'),
    mediaType: MediaType.VIDEO
  },
  {
    image: $r('app.media.ic_image'),
    title: $r('app.string.media_type_image'),
    mediaType: MediaType.IMAGE
  },
  {
    image: $r('app.media.ic_doc'),
    title: $r('app.string.media_type_doc'),
    mediaType: MediaType.DOC
  },
  {
    image: $r('app.media.ic_audio'),
    title: $r('app.string.media_type_audio'),
    mediaType: MediaType.AUDIO
  },
  {
    image: $r('app.media.ic_phone'),
    title: $r('app.string.media_type_device', '')
  }
]