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
enum FilePipePrinterAccess {
  ReadData = 1 << 0,
  WriteData = 1 << 1,
  AppendData = 1 << 2,
  ReadEa = 1 << 3,
  WriteEa = 1 << 4,
  DeleteChild = 1 << 5,
  Execute = 1 << 6,
  ReadAttributes = 1 << 7,
  WriteAttributes = 1 << 8,
  Delete = 1 << 16,
  ReadControl = 1 << 17,
  WriteDiscretionaryAccessControl = 1 << 18,
  WriteOwner = 1 << 19,
  Synchronize = 1 << 20,
  AccessSystemSecurity = 1 << 24,
  MaximumAllowed = 1 << 25,
  GenericAll = 1 << 28,
  GenericExecute = 1 << 29,
  GenericWrite = 1 << 30,
  GenericRead = 1 << 31
}

export default FilePipePrinterAccess;