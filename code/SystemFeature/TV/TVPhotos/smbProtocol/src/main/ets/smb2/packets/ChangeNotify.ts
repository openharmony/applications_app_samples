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
import * as util from "../../util";
import Structure from "../../Structure";
import FileAction from "../FileAction";
import ChangeEntry from "../../models/ChangeEntry";
import * as structureUtil from "../../structureUtil";

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

const requestStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2,
    defaultValue: 32
  },
  flags: {
    type: Number,
    size: 2,
    defaultValue: Flags.WatchTreeRecursively
  },
  outputBufferLength: {
    type: Number,
    size: 4,
    defaultValue: 0x00010000
  },
  fileId: {
    type: String,
    encoding: "hex",
    size: 16
  },
  completionFilter: {
    type: Number,
    size: 4,
    defaultValue:
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
  },
  reserved: {
    type: Number,
    size: 4
  }
};

const responseStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2
  },
  outputBufferOffset: {
    type: Number,
    size: 2
  },
  outputBufferLength: {
    type: Number,
    size: 4
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "outputBufferLength"
  }
};

const parseChangeEntry = (entryBuffer: buffer.Buffer): ChangeEntry => {
  const action = entryBuffer.readUInt32LE(0);
  const filenameLength = entryBuffer.readUInt32LE(4);
  const filename = util.toUnixFilePath(entryBuffer.subarray(8, 8 + filenameLength).toString("ucs2"));
  const actionName = structureUtil.parseEnumValue(FileAction, action);
  return { action, actionName, filename };
};

const parseResponseBuffer = (buf: buffer.Buffer) => {
  return structureUtil.parseList<ChangeEntry>(buf, parseChangeEntry);
};

export default {
  requestStructure,
  responseStructure,
  parseResponseBuffer
};