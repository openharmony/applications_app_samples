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
enum PacketType {
  Negotiate = 0x0000,
  SessionSetup = 0x0001,
  LogOff = 0x0002,
  TreeConnect = 0x0003,
  TreeDisconnect = 0x0004,
  Create = 0x0005,
  Close = 0x0006,
  Flush = 0x0007,
  Read = 0x0008,
  Write = 0x0009,
  Lock = 0x000a,
  InputOutputControl = 0x000b,
  Cancel = 0x000c,
  Echo = 0x000d,
  QueryDirectory = 0x000e,
  ChangeNotify = 0x000f,
  QueryInfo = 0x0010,
  SetInfo = 0x0011,
  OplockBreak = 0x0012
};

export default PacketType;