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

import { MultipleFilesDownloadComponent } from 'multiplefilesdownload';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      /**
       * 功能描述：多文件下载监听在应用开发中是一个非常常见的需求。本示例将介绍如何使用request上传下载模块实现多文件下载监听，如监听每个文件下载任务的进度，任务暂停，下载完成等下载情况。每个应用最多支持创建10个未完成的任务，相关规格说明请参考request.agent.create。
       * 参数介绍：无
       */
      MultipleFilesDownloadComponent();
    }
    .height('100%')
    .width('100%')
  }
}