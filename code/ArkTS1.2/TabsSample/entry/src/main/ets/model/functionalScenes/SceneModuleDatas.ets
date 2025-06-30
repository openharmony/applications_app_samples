/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { SceneModuleInfo } from './SceneModuleInfo';
import { $r } from '@ohos.arkui.component'
export const SCENE_MODULE_LIST: SceneModuleInfo[] = [
  new SceneModuleInfo(
    $r('app.media.backgroundblur_my_select'),
    '应用开发性能优化入门引导',
    'performance/PerformanceIntroView',
    '性能优化',
    1,
    3,
    $r('app.media.backgroundblur_my_select'),
    '',
    'README.md'
  ),
  new SceneModuleInfo(
    $r('app.media.backgroundblur_my_select'),
    '性能优化实操宝典',
    'performance/PerformancePracticeView',
    '性能优化',
    2,
    4,
    $r('app.media.backgroundblur_my_select'),
    '',
    'performance-optimization-practical-guidance.md'
  ),
  new SceneModuleInfo(
    $r('app.media.backgroundblur_my_select'),
    'UI 框架基础使用',
    'uiframework/UIFrameworkBasicsView',
    '界面开发',
    3,
    2,
    $r('app.media.backgroundblur_my_select'),
    '',
    'ui-framework.md'
  ),
  new SceneModuleInfo(
    $r('app.media.backgroundblur_my_select'),
    '动效开发实战',
    'animation/AnimationPracticeView',
    '界面开发',
    4,
    4,
    $r('app.media.backgroundblur_my_select'),
    '',
    'animation-guide.md'
  ),
  new SceneModuleInfo(
    $r('app.media.backgroundblur_my_select'),
    '数据存储与文件操作',
    'storage/StorageModuleView',
    '基础能力',
    5,
    3,
    $r('app.media.backgroundblur_my_select'),
    '',
    'storage-and-file.md'
  ),
  new SceneModuleInfo(
    $r('app.media.backgroundblur_my_select'),
    '路由与模块解耦',
    'router/RouterNavigationView',
    '路由跳转',
    6,
    3,
    $r('app.media.backgroundblur_my_select'),
    '',
    'router-guide.md'
  )
];
