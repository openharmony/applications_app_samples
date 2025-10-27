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

export enum RequestCode {
  ConnectStatus = 3,
  GetRawInfo = 4,
  GetRawName = 5,
  GetPhysicalAddr = 6,
  GetRawUniqueId = 7,
  GetInput = 8,
  SetOutput = 9,
  GetFeature = 10,
  SetFeature = 11,
  GetDescriptor = 12,
};

export enum InputType {
  GetReport = 0,
  ReadBlock = 1,
  ReadNonBlock = 2,
};

export enum OutputType {
  SendReport = 0,
  Write = 1,
};