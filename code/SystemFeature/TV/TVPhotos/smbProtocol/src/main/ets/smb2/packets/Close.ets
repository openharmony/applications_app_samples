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
import Structure from "../../Structure";
import StructureField from "../../StructureField";

const requestStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(24))
  .addField('flags', new StructureField(Number).setSize(2))
  .addField('reserved', new StructureField(Number).setSize(4))
  .addField('fileId', new StructureField(String).setEncoding("hex").setSize(16));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('flags', new StructureField(Number).setSize(2))
  .addField('reserved', new StructureField(Number).setSize(4))
  .addField('creationTime', new StructureField(Number).setSize(8))
  .addField('lastAccessTime', new StructureField(Number).setSize(8))
  .addField('lastWriteTime', new StructureField(Number).setSize(8))
  .addField('changeTime', new StructureField(Number).setSize(8))
  .addField('allocationSize', new StructureField(Number).setSize(8))
  .addField('endOfFile', new StructureField(Number).setSignedness("Signed").setSize(8))
  .addField('fileAttributes', new StructureField(Number).setSize(4));

class ClosePacket {
  requestStructure: Structure = requestStructure;
  responseStructure: Structure = responseStructure;
}

export default new ClosePacket();
