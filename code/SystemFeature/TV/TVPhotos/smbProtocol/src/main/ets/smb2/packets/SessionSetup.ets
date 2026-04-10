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
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(25))
  .addField('flags', new StructureField(Number).setSize(1))
  .addField('securityMode', new StructureField(Number).setSize(1).setDefaultValue(1))
  .addField('capabilities', new StructureField(Number).setSize(4).setDefaultValue(1))
  .addField('channel', new StructureField(Number).setSize(4))
  .addField('securityBufferOffset', new StructureField(Number).setSize(2).setDefaultValue(88))
  .addField('securityBufferLength', new StructureField(Number).setSize(2))
  .addField('previousSessionId', new StructureField(Number).setSize(8))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName('securityBufferLength'));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('sessionFlags', new StructureField(Number).setSize(2))
  .addField('securityBufferOffset', new StructureField(Number).setSize(2))
  .addField('securityBufferLength', new StructureField(Number).setSize(2))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName('securityBufferLength'));

class SessionSetupPacket {
  public requestStructure: Structure = requestStructure;
  public responseStructure: Structure = responseStructure;
}

export default new SessionSetupPacket();
