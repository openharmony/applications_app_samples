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
import buffer from '@ohos.buffer';
import Capability from '../Capability';
import Structure from '../../Structure';
import StructureField from '../../StructureField';

const requestStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(36))
  .addField('dialectCount', new StructureField(Number).setSignedness("Unsigned").setSize(2))
  .addField('securityMode', new StructureField(Number).setSize(2).setDefaultValue(1))
  .addField('reserved', new StructureField(Number).setSize(2))
  .addField('capabilities', new StructureField(Number).setSize(4))
  .addField('clientGuid', new StructureField(Number).setSize(16))
  .addField('clientStartTime', new StructureField(Number).setSize(8))
  .addField('dialects', new StructureField(Number).setCountFieldName("dialectCount").setSize(2));

export interface RequestBody {
  structureSize?: number;
  dialects: number[];
  securityMode?: number;
  capabilities: Capability;
  clientGuid: string;
  clientStartDate: Date;
}
;

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('securityMode', new StructureField(Number).setSize(2))
  .addField('dialectRevision', new StructureField(Number).setSize(2))
  .addField('reserved', new StructureField(Number).setSize(2))
  .addField('serverGuid', new StructureField(Number).setSize(16))
  .addField('capabilities', new StructureField(Number).setSize(4))
  .addField('maxTransactSize', new StructureField(Number).setSize(4))
  .addField('maxReadSize', new StructureField(Number).setSize(4))
  .addField('maxWriteSize', new StructureField(Number).setSize(4))
  .addField('systemTime', new StructureField(Number).setSize(8))
  .addField('serverStartTime', new StructureField(Number).setSize(8))
  .addField('securityBufferOffset', new StructureField(Number).setSize(2))
  .addField('securityBufferLength', new StructureField(Number).setSize(2))
  .addField('reserved2', new StructureField(Number).setSize(4))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName("securityBufferLength"));

class NegotiatePacket {
  requestStructure: Structure = requestStructure;
  responseStructure: Structure = responseStructure;
}

export default new NegotiatePacket();
