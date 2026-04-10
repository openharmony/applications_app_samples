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
import PacketType from "./PacketType";
import StructureField from "../StructureField";
import { protocolIdStructureField } from "../Packet";

export const headerSize = 32;

export default interface Header {
  protocolId?: string;
  type?: PacketType;
  status?: number;
  flags?: number;
  flags2?: number;
  processIdHigh?: number;
  securityFeatures?: number;
  securitySignature?: number;
  key?: number;
  connectionId?: number;
  sequenceNumber?: number;
  reserved?: number;
  treeId?: number;
  processIdLow?: number;
  userId?: number;
  multiplexId?: number;
}

export type HeaderName = (
  "protocolId" |
  "type" |
  "status" |
  "flags" |
  "flags2" |
  "processIdHigh" |
  "securityFeatures" |
  "securitySignature" |
  "key" |
  "connectionId" |
  "sequenceNumber" |
  "reserved" |
  "treeId" |
  "processIdLow" |
  "userId" |
  "multiplexId"
);

export type HeaderStructure = {
  [key in HeaderName]?: StructureField;
};

export const headerStructure: HeaderStructure = {
  protocolId: protocolIdStructureField,
  type: {
    type: Number,
    size: 1
  },
  status: {
    type: Number,
    size: 4
  },
  flags: {
    type: Number,
    size: 1
  },
  flags2: {
    type: Number,
    size: 2
  },
  processIdHigh: {
    type: Number,
    size: 2
  },
  securityFeatures: {
    type: Number,
    size: 8
  },
  securitySignature: {
    type: Number,
    size: 8
  },
  key: {
    type: Number,
    size: 4
  },
  connectionId: {
    type: Number,
    size: 2
  },
  sequenceNumber: {
    type: Number,
    size: 2
  },
  reserved: {
    type: Number,
    size: 2
  },
  treeId: {
    type: Number,
    size: 2
  },
  processIdLow: {
    type: Number,
    size: 2
  },
  userId: {
    type: Number,
    size: 2
  },
  multiplexId: {
    type: Number,
    size: 2
  }
};