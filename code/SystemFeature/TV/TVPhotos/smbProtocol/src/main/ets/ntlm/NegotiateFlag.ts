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
enum NegotiateFlag {
  UnicodeEncoding = 1 << 0,
  OemEncoding = 1 << 1,
  TargetNameSupplied = 1 << 2,
  Sign = 1 << 4,
  Seal = 1 << 5,
  Diagram = 1 << 6,
  LanManagerSessionKey = 1 << 7,
  NTLMSessionSecurity = 1 << 9,
  Anonymous = 1 << 11,
  DomainNameSupplied = 1 << 12,
  WorkstationNameSupplied = 1 << 13,
  AlwaysSign = 1 << 15,
  TargetTypeDomain = 1 << 16,
  TargetTypeServer = 1 << 17,
  ExtendedSessionSecurity = 1 << 19,
  Identify = 1 << 20,
  RequestNonNtSessionKey = 1 << 22,
  TargetInfo = 1 << 23,
  Version = 1 << 25,
  Use128BitEncryption = 1 << 29,
  KeyExchange = 1 << 30,
  Use56BitEncryption = 1 << 31
}

export default NegotiateFlag;