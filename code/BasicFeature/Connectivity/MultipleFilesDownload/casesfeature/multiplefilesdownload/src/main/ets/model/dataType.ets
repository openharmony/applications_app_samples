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

let nextId: number = 1;

@Observed
export class downloadFilesData {
  // 唯一标识
  id: number;
  // 下载地址
  url: string;
  // 文件下载状态： 0未下载， 1下载成功， 2下载失败, 3已删除
  fileStatus: number;
  // 下载完成的时间戳
  downloadTime: number;

  constructor(
    url: string = '',
    fileStatus: number = 0,
    downloadTime: number = 0,
  ) {
    this.id = nextId++;
    this.url = url;
    this.fileStatus = fileStatus;
    this.downloadTime = downloadTime;
  }
}