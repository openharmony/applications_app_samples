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

export enum InfoType {
  File = 1,
  Filesystem = 2,
  Security = 3,
  Quota = 4
}

export enum FileInfoClass {
  AllocationInformation = 19,
  BasicInformation = 4,
  DispositionInformation = 13,
  EndOfFileInformation = 20,
  FullEaInformation = 15,
  LinkInformation = 11,
  ModeInformation = 16,
  PipeInformation = 23,
  PositionInformation = 14,
  RenameInformation = 10,
  ShortNameInformation = 40,
  ValidDataLengthInformation = 39
}

const requestStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(33))
  .addField('infoType', new StructureField(Number).setSize(1).setDefaultValue(InfoType.File))
  .addField('fileInfoClass', new StructureField(Number).setSize(1).setDefaultValue(FileInfoClass.EndOfFileInformation))
  .addField('bufferLength', new StructureField(Number).setSize(4))
  .addField('bufferOffset', new StructureField(Number).setSize(2).setDefaultValue(96))
  .addField('reserved', new StructureField(Number).setSize(2))
  .addField('additionalInformation', new StructureField(Number).setSize(4))
  .addField('fileId', new StructureField(String).setEncoding('hex').setSize(16))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName('bufferLength'));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2));

class SetInfoPacket {
  public requestStructure: Structure = requestStructure;
  public responseStructure: Structure = responseStructure;
}

export default new SetInfoPacket();
