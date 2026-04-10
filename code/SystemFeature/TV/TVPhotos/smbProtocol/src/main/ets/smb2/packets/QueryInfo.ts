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

const requestStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2,
    defaultValue: 0x29
  },
  infoType: {
    type: Number,
    size: 1,
    defaultValue: 0x01
  },
  fileInfoClass: {
    type: Number,
    size: 1,
    defaultValue: 0x03
  },
  outputBufferLength: {
    type: Number,
    size: 4
  },
  inputBufferOffset: {
    type: Number,
    size: 2,
    defaultValue: 0x0068
  },
  reserved: {
    type: Number,
    size: 2
  },
  inputBufferLength: {
    type: Number,
    size: 4
  },
  additionalInformation: {
    type: Number,
    size: 4
  },

  flags: {
    type: Number,
    size: 4
  },
  fileId: {
    type: String,
    encoding: "hex",
    size: 16,
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


export default {
  requestStructure,
  responseStructure
};