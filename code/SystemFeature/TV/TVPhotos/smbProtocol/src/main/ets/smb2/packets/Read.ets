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
import Structure from '../../Structure';
import StructureField from '../../StructureField';

const requestStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(49))
  .addField('padding', new StructureField(Number).setSize(1).setDefaultValue(80))
  .addField('flags', new StructureField(Number).setSize(1))
  .addField('length', new StructureField(Number).setSize(4).setDefaultValue(1024))
  .addField('offset', new StructureField(Number).setSize(8))
  .addField('fileId', new StructureField(String).setEncoding("hex").setSize(16))
  .addField('minimumCount', new StructureField(Number).setSize(4))
  .addField('channel', new StructureField(Number).setSize(4))
  .addField('remainingBytes', new StructureField(Number).setSize(4))
  .addField('readChannelInfoOffset', new StructureField(Number).setSize(2))
  .addField('readChannelInfoLength', new StructureField(Number).setSize(2))
  .addField('buffer', new StructureField(buffer.Buffer).setSize(1));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('dataOffset', new StructureField(Number).setSize(1))
  .addField('reserved', new StructureField(Number).setSize(1))
  .addField('dataLength', new StructureField(Number).setSize(4))
  .addField('dataRemaining', new StructureField(Number).setSize(4))
  .addField('reserved2', new StructureField(Number).setSize(4))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName("dataLength"));

class ReadPacket {
  requestStructure: Structure = requestStructure;
  responseStructure: Structure = responseStructure;
}

export default new ReadPacket();
