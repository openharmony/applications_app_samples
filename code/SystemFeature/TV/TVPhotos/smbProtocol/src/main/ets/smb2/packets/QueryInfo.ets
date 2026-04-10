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
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(0x29))
  .addField('infoType', new StructureField(Number).setSize(1).setDefaultValue(0x01))
  .addField('fileInfoClass', new StructureField(Number).setSize(1).setDefaultValue(0x03))
  .addField('outputBufferLength', new StructureField(Number).setSize(4))
  .addField('inputBufferOffset', new StructureField(Number).setSize(2).setDefaultValue(0x0068))
  .addField('reserved', new StructureField(Number).setSize(2))
  .addField('inputBufferLength', new StructureField(Number).setSize(4))
  .addField('additionalInformation', new StructureField(Number).setSize(4))
  .addField('flags', new StructureField(Number).setSize(4))
  .addField('fileId', new StructureField(String).setEncoding('hex').setSize(16));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('outputBufferOffset', new StructureField(Number).setSize(2))
  .addField('outputBufferLength', new StructureField(Number).setSize(4))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName('outputBufferLength'));

class QueryInfoPacket {
  public requestStructure: Structure = requestStructure;
  public responseStructure: Structure = responseStructure;
}

export default new QueryInfoPacket();
