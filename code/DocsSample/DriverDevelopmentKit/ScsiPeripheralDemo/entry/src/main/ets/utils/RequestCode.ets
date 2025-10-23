/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export enum RequestCode {
  ConnectStatus = 1,
  GetDeviceInfo = 2,
  Inquiry = 3,
  ReadCapacity = 4,
  TestUnitReady = 5,
  ReadBlockData = 6,
  WriteBlockData = 7,
  VerifyBlockData = 8,
  RequestSense = 9,
  SendCdbData = 10,
};

export enum DirectionType {
  None = -1,
  ToDev = -2,
  FromDev = -3,
  ToFromDev = -4,
};