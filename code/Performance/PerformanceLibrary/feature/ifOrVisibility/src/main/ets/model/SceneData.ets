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
import { SceneMsg } from './SceneMsg'

export let sceneData: Array<SceneMsg> = [
  {
    title: $r('app.string.animate_better_use_visibility'),
    uri: 'pages/ifOrVisibility/AnimateBetterUseVisibility'
  },
  {
    title: $r('app.string.animate_worse_use_if'),
    uri: 'pages/ifOrVisibility/AnimateWorseUseIf'
  },
  {
    title: $r('app.string.start_better_use_if'),
    uri: 'pages/ifOrVisibility/StartBetterUseIf'
  },
  {
    title: $r('app.string.start_worse_use_visibility'),
    uri: 'pages/ifOrVisibility/StartWorseUseVisibility'
  },
  {
    title: $r('app.string.better_use_stack'),
    uri: 'pages/ifOrVisibility/RenderControlBetterWithStack'
  },
  {
    title: $r('app.string.worse_not_use_stack'),
    uri: 'pages/ifOrVisibility/RenderControlWorseWithoutStack'
  },
  {
    title: $r('app.string.better_reusable'),
    uri: 'pages/ifOrVisibility/IfBetterWithReusable'
  },
  {
    title: $r('app.string.worse_reusable'),
    uri: 'pages/ifOrVisibility/IfWorseWithoutReusable'
  }
]