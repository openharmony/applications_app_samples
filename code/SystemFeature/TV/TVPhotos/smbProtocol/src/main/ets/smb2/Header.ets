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
import PacketType from './PacketType';
import StatusCode from './StatusCode';
import Structure from '../Structure';
import StructureField from '../StructureField';
import { protocolIdStructureField } from '../Packet';

export const headerSize = 64;

export default interface Header {
  protocolId?: string;
  structureSize?: number;
  creditCharge?: number;
  status?: StatusCode;
  type?: PacketType;
  credit?: number;
  flags?: number;
  nextCommand?: number;
  messageId?: bigint;
  clientId?: string;
  treeId?: number;
  sessionId?: string;
  signature?: number;
}

export type HeaderName = (
"protocolId" |
"structureSize" |
"creditCharge" |
"status" |
"type" |
"credit" |
"flags" |
"nextCommand" |
"messageId" |
"clientId" |
"treeId" |
"sessionId" |
"signature"
);

export class HeaderStructure extends Structure {
  protocolId = protocolIdStructureField;
  structureSize = new StructureField(Number).setSize(2).setDefaultValue(headerSize);
  creditCharge = new StructureField(Number).setSize(2);
  status = new StructureField(Number).setSignedness("Unsigned").setSize(4);
  type = new StructureField(Number).setSize(2).setDefaultValue(2);
  credit = new StructureField(Number).setSize(2).setDefaultValue(126);
  flags = new StructureField(Number).setSize(4);
  nextCommand = new StructureField(Number).setSize(4);
  messageId = new StructureField(Number).setSize(8);
  clientId = new StructureField(String).setEncoding("hex").setSize(4);
  treeId = new StructureField(Number).setSize(4);
  sessionId = new StructureField(String).setEncoding("hex").setSize(8);
  signature = new StructureField(Number).setSize(16);
}

export const headerStructure: Structure = new HeaderStructure();
