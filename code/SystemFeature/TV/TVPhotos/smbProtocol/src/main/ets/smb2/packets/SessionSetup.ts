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
import Structure from '../../Structure';

const requestStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2,
    defaultValue: 25
  },
  flags: {
    type: Number,
    size: 1
  },
  securityMode: {
    type: Number,
    size: 1,
    defaultValue: 1
  },
  capabilities: {
    type: Number,
    size: 4,
    defaultValue: 1
  },
  channel: {
    type: Number,
    size: 4
  },
  securityBufferOffset: {
    type: Number,
    size: 2,
    defaultValue: 88
  },
  securityBufferLength: {
    type: Number,
    size: 2
  },
  previousSessionId: {
    type: Number,
    size: 8
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "securityBufferLength"
  }
};

const responseStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2
  },
  sessionFlags: {
    type: Number,
    size: 2
  },
  securityBufferOffset: {
    type: Number,
    size: 2
  },
  securityBufferLength: {
    type: Number,
    size: 2
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "securityBufferLength"
  }
};

export default {
  requestStructure,
  responseStructure
};