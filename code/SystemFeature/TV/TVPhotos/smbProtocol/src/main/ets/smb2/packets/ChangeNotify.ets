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
import * as util from '../../util';
import Structure from '../../Structure';
import StructureField from '../../StructureField';
import FileAction from '../FileAction';
import ChangeEntry from '../../models/ChangeEntry';
import * as structureUtil from '../../structureUtil';

export enum Flags {
  None,
  WatchTreeRecursively = 1 << 0
}

export enum CompletionFilter {
  FilenameChange = 1 << 0,
  DirnameChange = 1 << 1,
  AttributesChange = 1 << 2,
  SizeChange = 1 << 3,
  LastWriteChange = 1 << 4,
  LastAccessChange = 1 << 5,
  CreationChange = 1 << 6,
  EaChange = 1 << 7,
  SecurityChange = 1 << 8,
  StreamNameChange = 1 << 9,
  StreamSizeChange = 1 << 10,
  StreamWriteChange = 1 << 11
}

const requestStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(32))
  .addField('flags', new StructureField(Number).setSize(2).setDefaultValue(Flags.WatchTreeRecursively))
  .addField('outputBufferLength', new StructureField(Number).setSize(4).setDefaultValue(0x00010000))
  .addField('fileId', new StructureField(String).setEncoding('hex').setSize(16))
  .addField('completionFilter', new StructureField(Number).setSize(4).setDefaultValue(
    CompletionFilter.FilenameChange |
    CompletionFilter.DirnameChange |
    CompletionFilter.AttributesChange |
    CompletionFilter.SizeChange |
    CompletionFilter.LastWriteChange |
    CompletionFilter.LastAccessChange |
    CompletionFilter.CreationChange |
    CompletionFilter.EaChange |
    CompletionFilter.SecurityChange |
    CompletionFilter.StreamNameChange |
    CompletionFilter.StreamSizeChange |
    CompletionFilter.StreamWriteChange
  ))
  .addField('reserved', new StructureField(Number).setSize(4));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('outputBufferOffset', new StructureField(Number).setSize(2))
  .addField('outputBufferLength', new StructureField(Number).setSize(4))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName('outputBufferLength'));

class ChangeEntryModel implements ChangeEntry {
  action: FileAction;
  actionName: string;
  filename: string;

  constructor(action: FileAction, actionName: string, filename: string) {
    this.action = action;
    this.actionName = actionName;
    this.filename = filename;
  }
}

const parseChangeEntry = (entryBuffer: buffer.Buffer): ChangeEntry => {
  const action = entryBuffer.readUInt32LE(0);
  const filenameLength = entryBuffer.readUInt32LE(4);
  const filename = util.toUnixFilePath(entryBuffer.subarray(8, 8 + filenameLength).toString('ucs2'));
  const actionName = structureUtil.parseEnumValue(FileAction, action) ?? '';
  return new ChangeEntryModel(action as FileAction, actionName, filename);
};

const parseResponseBuffer = (buf: buffer.Buffer) => {
  return structureUtil.parseList<ChangeEntry>(buf, parseChangeEntry);
};

class ChangeNotifyPacket {
  public requestStructure: Structure = requestStructure;
  public responseStructure: Structure = responseStructure;
  public parseResponseBuffer = parseResponseBuffer;
}

export default new ChangeNotifyPacket();
