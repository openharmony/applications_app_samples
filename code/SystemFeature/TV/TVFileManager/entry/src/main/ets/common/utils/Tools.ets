/*
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

import { fileExtensionInfo } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';

import { FileInfo } from '../data/FileInfo';

export function IsFile(mode: number): boolean {
  return (mode & fileExtensionInfo.DocumentFlag.REPRESENTS_FILE) > 0;
}

export function IsDevice(mode: number): boolean {
  return (mode & fileExtensionInfo.DeviceType.DEVICE_EXTERNAL_USB) > 0;
}

export interface DirInfo {
  name: string;
  path: string;
  type: 'file' | 'dir';
}

export interface FileItemInfo extends DirInfo {
  size: number;
}

type DirType = DirInfo | string;

const TextDecoder: util.TextDecoder = new util.TextDecoder('utf-8', { ignoreBOM: true });
const TextEncoder: util.TextEncoder = new util.TextEncoder();
const KB: number = 1024;
const MB: number = KB * 1024;
const GB: number = MB * 1024;

export class Tools {

  public static byte2Str(limit: number): string {
    let size: string = '';
    if (limit < KB) {
      size = limit.toFixed(2) + 'B';
    } else if (limit < MB) {
      size = (limit / KB).toFixed(2) + 'KB';
    } else if (limit < GB) {
      size = (limit / MB).toFixed(2) + 'MB';
    } else {
      size = (limit / GB).toFixed(2) + 'GB';
    }

    let sizeStr: string = size + '';
    let index: number = sizeStr.indexOf('.');
    let dou: string = sizeStr.substr(index + 1, 2);
    if (dou === '00') {
      return sizeStr.substring(0, index) + sizeStr.substr(index + 3, 2);
    }
    return size;
  }

  public static parseUri2FileID(uri: string): number {
    if (uri && uri.indexOf('/') > 0) {
      return 0;
    }
    return -1;
  }

  public static arrayToString(arr: ArrayBuffer): string {
    return TextDecoder.decode(new Uint8Array(arr));
  }

  public static stringToArray(str: string): Uint8Array {
    return TextEncoder.encode(str);
  }

  public static parseFileInfo(obj: FileInfo): FileItemInfo {
    return {
      name: obj.fileName || '',
      path: obj.uri || '',
      type: obj.size === 0 ? 'dir' : 'file',
      size: obj.size || 0
    };
  }

  public static isEmpty(text: string): boolean {
    return !text || text.length === 0;
  }
}
