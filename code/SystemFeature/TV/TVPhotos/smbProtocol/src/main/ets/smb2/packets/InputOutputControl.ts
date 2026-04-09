/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import Structure from "../../Structure";

const requestStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2,
    defaultValue: 0x39
  },
  reserved: {
    type: Number,
    size: 2,
    defaultValue: 0x00
  },
  ctlCode: {
    type: Number,
    size: 4,
    defaultValue: 0x0011c017
  },
  fileId: {
    type: String,
    encoding: "hex",
    size: 16
  },
  inputOffset: {
    type: Number,
    size: 4,
    defaultValue: 120
  },
  inputCount: {
    type: Number,
    size: 4
  },
  maxInputResponse: {
    type: Number,
    size: 4,
    defaultValue: 0
  },

  outputOffset: {
    type: Number,
    size: 4,
    defaultValue: 120
  },
  outputCount: {
    type: Number,
    size: 4,
    defaultValue: 0
  },
  maxOutputResponse: {
    type: Number,
    size: 4,
    defaultValue: 1024
  },
  flags: {
    type: Number,
    size: 4,
    defaultValue: 0x00000001
  },
  reserved2: {
    type: Number,
    size: 4,
    defaultValue: 0
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "inputCount"
  }
};

const responseStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2
  },
  reserved: {
    type: Number,
    size: 2
  },
  ctlCode: {
    type: Number,
    size: 4
  },
  fileId: {
    type: String,
    encoding: "hex",
    size: 16
  },
  inputOffset: {
    type: Number,
    size: 4,
    defaultValue: 120
  },
  inputCount: {
    type: Number,
    size: 4
  },
  outputOffset: {
    type: Number,
    size: 4,
  },
  outputCount: {
    type: Number,
    size: 4,
    defaultValue: 0
  },
  flags: {
    type: Number,
    size: 4
  },
  reserved2: {
    type: Number,
    size: 4,
    defaultValue: 0
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "outputCount"
  }
};

export default {
  requestStructure,
  responseStructure
};