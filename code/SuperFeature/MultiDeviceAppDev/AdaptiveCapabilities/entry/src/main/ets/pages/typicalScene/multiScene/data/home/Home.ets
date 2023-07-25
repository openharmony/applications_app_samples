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

export interface Articles {
  icon: string | Resource
  title: string | Resource
  disc: string | Resource
}

export const ArticlesData: Articles[] = [
  {
    icon: $r("app.media.icon"),
    title: $r('app.string.multiScene_title1'),
    disc: $r('app.string.multiScene_title1_disc')
  },
  {
    icon: $r("app.media.icon"),
    title: $r('app.string.multiScene_title2'),
    disc: $r('app.string.multiScene_title2_disc')
  },
  {
    icon: $r("app.media.icon"),
    title: $r('app.string.multiScene_title3'),
    disc: $r('app.string.multiScene_title3_disc')
  },
  {
    icon: $r("app.media.icon"),
    title: $r('app.string.multiScene_title4'),
    disc: $r('app.string.multiScene_title4_disc')
  },
  {
    icon: $r("app.media.icon"),
    title: $r('app.string.multiScene_title5'),
    disc: $r('app.string.multiScene_title5_disc')
  },{
    icon: $r("app.media.icon"),
    title: $r('app.string.multiScene_title5'),
    disc: $r('app.string.multiScene_title5_disc')
  },{
    icon: $r('app.media.icon'),
    title: $r('app.string.multiScene_title6'),
    disc: $r('app.string.multiScene_title6_disc')
  },
  {
    icon: $r("app.media.icon"),
    title: $r('app.string.multiScene_title7'),
    disc: $r('app.string.multiScene_title7_disc')
  },
  {
    icon: $r('app.media.icon'),
    title: $r('app.string.multiScene_title8'),
    disc: $r('app.string.multiScene_title8_disc')
  },
  {
    icon: $r('app.media.icon'),
    title: $r('app.string.multiScene_title9'),
    disc: $r('app.string.multiScene_title9_disc')
  },
  {
    icon: $r('app.media.icon'),
    title: $r('app.string.multiScene_title10'),
    disc: $r('app.string.multiScene_title10_disc')
  }
]




