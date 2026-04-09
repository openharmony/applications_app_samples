/**
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
enum FileAttribute {
  None = 0,
  ReadOnly = 1 << 0,
  Hidden = 1 << 1,
  System = 1 << 2,
  Directory = 1 << 4,
  Archive = 1 << 5,
  Normal = 1 << 7,
  Temporary = 1 << 8,
  SparseFile = 1 << 9,
  ReparsePoint = 1 << 10,
  Compressed = 1 << 11,
  Offline = 1 << 12,
  NotContentIndexed = 1 << 13,
  Encrypted = 1 << 14,
  IntegrityStream = 1 << 15,
  NoScrubData = 1 << 17
}

export default FileAttribute;