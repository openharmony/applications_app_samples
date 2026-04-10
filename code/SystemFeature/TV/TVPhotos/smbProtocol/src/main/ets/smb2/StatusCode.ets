/**
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
enum StatusCode {
  Success = 0x00000000,
  Pending = 0x00000103,
  MoreProcessingRequired = 0xc0000016,
  FileNameNotFound = 0xc0000034,
  FilePathNotFound = 0xc000003a,
  FileClosed = 0xc0000128,
  LoginFail = 0xC000006D,
  InvalidParam = 0xC000000D,
  NotSupport = 0xC00000BB,
  InvalidLockSequence = 0xc00000c9,
  BadNetworkName = 0xc00000cc
}

export const getStatusMessage = (statusCode: number): string => {
  let names = Object.getOwnPropertyNames(StatusCode)
  let name = names.find((key) => {
    return StatusCode[key] === statusCode
  })
  return name ?? `${statusCode}`
}

export default StatusCode
