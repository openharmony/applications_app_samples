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
    defaultValue: 49
  },
  dataOffset: {
    type: Number,
    size: 2,
    defaultValue: 112
  },
  length: {
    type: Number,
    size: 4
  },
  offset: {
    type: Number,
    size: 8
  },
  fileId: {
    type: String,
    encoding: "hex",
    size: 16
  },
  channel: {
    type: Number,
    size: 4
  },
  remainingBytes: {
    type: Number,
    size: 4
  },
  writeChannelInfoOffset: {
    type: Number,
    size: 2
  },
  writeChannelInfoLength: {
    type: Number,
    size: 2
  },
  flags: {
    type: Number,
    size: 4
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "length"
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
  count: {
    type: Number,
    size: 4
  },
  remaining: {
    type: Number,
    size: 4
  },
  writeChannelInfoOffset: {
    type: Number,
    size: 2
  },
  writeChannelInfoLength: {
    type: Number,
    size: 2
  }
};

export default {
  requestStructure,
  responseStructure
};