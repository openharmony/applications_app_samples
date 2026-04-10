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
 
export class FileSendModel {
  public filePath: string = ''
  public fileName: string = ''
  public size: number = 0
  public type: number = 0
  public deviceName: string = ''
  public thumbnail?: string = ''
  public status?: string = ''
  public data?: ArrayBuffer = new ArrayBuffer(0)
  public offset?: number = 0
  public length?: number = 0
}
