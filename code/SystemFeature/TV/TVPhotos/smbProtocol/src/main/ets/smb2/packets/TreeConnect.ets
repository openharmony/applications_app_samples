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
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(9))
  .addField('reserved', new StructureField(Number).setSize(2))
  .addField('pathOffset', new StructureField(Number).setSize(2).setDefaultValue(72))
  .addField('pathLength', new StructureField(Number).setSize(2))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName("pathLength"));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('shareType', new StructureField(Number).setSize(1))
  .addField('reserved', new StructureField(Number).setSize(1))
  .addField('shareFlags', new StructureField(Number).setSize(4))
  .addField('capabilities', new StructureField(Number).setSize(4))
  .addField('maximalAccess', new StructureField(Number).setSize(4));

class TreeConnectPacket {
  requestStructure: Structure = requestStructure;
  responseStructure: Structure = responseStructure;
}

export default new TreeConnectPacket();
