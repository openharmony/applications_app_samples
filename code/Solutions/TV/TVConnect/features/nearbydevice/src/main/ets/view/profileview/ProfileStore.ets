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
import fs, { ReadOptions } from '@ohos.file.fs';
import { HttpApi } from '@ohos/connect_cloud';
import { Logger } from '@ohos/common';
import { util } from '@kit.ArkTS';
import { RecordObject } from './ProfileBuilder';
import { common } from '@kit.AbilityKit';

export class ProfileStore {
  public static async getProfile(context: common.Context, productId: string): Promise<RecordObject> {
    let parentDir = `${context.filesDir}/profile`;
    let fileDir = `${parentDir}/${productId}_profile.json`;
    Logger.info('ProfileStore', 'fileDir ' + fileDir);
    let fileExists = await ProfileStore.checkFileExists(fileDir);
    if (!fileExists) {
      await ProfileStore.mkdirParent(parentDir);
      await ProfileStore.writeProfileByNetWork(productId, fileDir);
    }
    return ProfileStore.readProfileByStore(fileDir);
  }

  private static async checkFileExists(filePath: string): Promise<boolean> {
    try {
      let stat = await fs.stat(filePath);
      Logger.info('ProfileStore', 'file exists');
      return stat.isFile();
    } catch (err) {
      Logger.info('ProfileStore', 'file not exists');
      return false;
    }
  }

  private static async mkdirParent(filePath: string) {
    try {
      await fs.mkdir(filePath);
    } catch (e) {
      Logger.warn('ProfileStore', 'mkdir parent error' + e?.message);
    }
  }

  private static async writeProfileByNetWork(productId: string, filePath: string): Promise<boolean> {
    Logger.info('ProfileStore', 'write profile ' + productId);
    let fd = -1;
    try {
      let profileObj = await HttpApi.getInstance().getProductProfile(productId);
      let file = await fs.open(filePath, fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE);
      fd = file.fd;
      Logger.info('ProfileStore', 'write fd ' + fd);
      const encoder = new util.TextEncoder('utf-8');
      const data = encoder.encode(JSON.stringify(profileObj));
      await fs.write(file.fd, data.buffer);
      Logger.info('ProfileStore', 'write success ' + productId);
      return true;
    } catch (e) {
      Logger.error('ProfileStore', 'write error ' + e?.message);
      return false;
    } finally {
      if (fd != -1) {
        fs.close(fd);
      }
    }
  }

  private static async readProfileByStore(filePath: string): Promise<RecordObject> {
    Logger.info('ProfileStore', 'read');
    let fd = -1;
    try {
      let file = await fs.open(filePath, fs.OpenMode.READ_ONLY);
      fd = file.fd;
      const stat = await fs.stat(fd);
      const fileSize = stat.size;
      const buffer = new ArrayBuffer(fileSize);
      let opt: ReadOptions = {
        offset: 0,
        length: fileSize,
      };
      await fs.read(fd, buffer, opt);
      let textDecoder = new util.TextDecoder('utf-8', { ignoreBOM: true });
      let uint8Array = new Uint8Array(buffer);
      let string = textDecoder.decodeWithStream(uint8Array);
      return JSON.parse(string) as RecordObject;
    } finally {
      if (fd != -1) {
        fs.close(fd);
      }
    }
  }
}