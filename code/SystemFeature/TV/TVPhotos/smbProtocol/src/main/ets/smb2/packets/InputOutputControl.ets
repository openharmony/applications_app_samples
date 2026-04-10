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
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(0x39))
  .addField('reserved', new StructureField(Number).setSize(2).setDefaultValue(0x00))
  .addField('ctlCode', new StructureField(Number).setSize(4).setDefaultValue(0x0011c017))
  .addField('fileId', new StructureField(String).setEncoding('hex').setSize(16))
  .addField('inputOffset', new StructureField(Number).setSize(4).setDefaultValue(120))
  .addField('inputCount', new StructureField(Number).setSize(4))
  .addField('maxInputResponse', new StructureField(Number).setSize(4).setDefaultValue(0))
  .addField('outputOffset', new StructureField(Number).setSize(4).setDefaultValue(120))
  .addField('outputCount', new StructureField(Number).setSize(4).setDefaultValue(0))
  .addField('maxOutputResponse', new StructureField(Number).setSize(4).setDefaultValue(1024))
  .addField('flags', new StructureField(Number).setSize(4).setDefaultValue(0x00000001))
  .addField('reserved2', new StructureField(Number).setSize(4).setDefaultValue(0))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName('inputCount'));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('reserved', new StructureField(Number).setSize(2))
  .addField('ctlCode', new StructureField(Number).setSize(4))
  .addField('fileId', new StructureField(String).setEncoding('hex').setSize(16))
  .addField('inputOffset', new StructureField(Number).setSize(4).setDefaultValue(120))
  .addField('inputCount', new StructureField(Number).setSize(4))
  .addField('outputOffset', new StructureField(Number).setSize(4))
  .addField('outputCount', new StructureField(Number).setSize(4).setDefaultValue(0))
  .addField('flags', new StructureField(Number).setSize(4))
  .addField('reserved2', new StructureField(Number).setSize(4).setDefaultValue(0))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName('outputCount'));

class InputOutputControlPacket {
  public requestStructure: Structure = requestStructure;
  public responseStructure: Structure = responseStructure;
}

export default new InputOutputControlPacket();
