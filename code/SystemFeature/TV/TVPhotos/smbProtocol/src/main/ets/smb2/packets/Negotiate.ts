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
import Capability from '../Capability';
import Structure from '../../Structure';

const requestStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2,
    defaultValue: 36
  },
  dialectCount: {
    type: Number,
    signedness: "Unsigned",
    size: 2
  },
  securityMode: {
    type: Number,
    size: 2,
    defaultValue: 1
  },
  reserved: {
    type: Number,
    size: 2
  },
  capabilities: {
    type: Number,
    size: 4
  },
  clientGuid: {
    type: Number,
    size: 16
  },
  clientStartTime: {
    type: Number,
    size: 8
  },
  dialects: {
    type: Number,
    countFieldName: "dialectCount",
    size: 2
  }
};

export interface RequestBody {
  structureSize?: number;
  dialects: number[];
  securityMode?: number;
  capabilities: Capability;
  clientGuid: string;
  clientStartDate: Date;
}
;

const responseStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2
  },
  securityMode: {
    type: Number,
    size: 2
  },
  dialectRevision: {
    type: Number,
    size: 2
  },
  reserved: {
    type: Number,
    size: 2
  },
  serverGuid: {
    type: Number,
    size: 16
  },
  capabilities: {
    type: Number,
    size: 4
  },
  maxTransactSize: {
    type: Number,
    size: 4
  },
  maxReadSize: {
    type: Number,
    size: 4,
  },
  maxWriteSize: {
    type: Number,
    size: 4
  },
  systemTime: {
    type: Number,
    size: 8
  },
  serverStartTime: {
    type: Number,
    size: 8
  },
  securityBufferOffset: {
    type: Number,
    size: 2
  },
  securityBufferLength: {
    type: Number,
    size: 2
  },
  reserved2: {
    type: Number,
    size: 4
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