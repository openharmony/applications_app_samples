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

const requestStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2,
    defaultValue: 33
  },
  infoType: {
    type: Number,
    size: 1,
    defaultValue: InfoType.File
  },
  fileInfoClass: {
    type: Number,
    size: 1,
    defaultValue: FileInfoClass.EndOfFileInformation
  },
  bufferLength: {
    type: Number,
    size: 4
  },
  bufferOffset: {
    type: Number,
    size: 2,
    defaultValue: 96
  },
  reserved: {
    type: Number,
    size: 2
  },
  additionalInformation: {
    type: Number,
    size: 4
  },
  fileId: {
    type: String,
    encoding: "hex",
    size: 16
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "bufferLength"
  }
};

const responseStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2
  }
};

export default {
  requestStructure,
  responseStructure
};