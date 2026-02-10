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

// [Start Internal_localStorage_multi_instance_2]
// model/PDFData.ets
@ObservedV2
export default class PDFData {
  // 单例实例
  private static instance_: PDFData | null = null;
  @Trace private data: Map<string, string> = new Map();
  @Trace private flag: string = '';

  private constructor() {
  }

  static getInstance(): PDFData {
    if (!PDFData.instance_) {
      PDFData.instance_ = new PDFData();
    }
    return PDFData.instance_;
  }

  setData(key: string, value: string) {
    this.data.set(key, value);
  }

  getData() {
    return this.data;
  }

  setFlage(value: string) {
    this.flag = value;
  }

  getFlag() {
    return this.flag;
  }
}
// [End Internal_localStorage_multi_instance_2]