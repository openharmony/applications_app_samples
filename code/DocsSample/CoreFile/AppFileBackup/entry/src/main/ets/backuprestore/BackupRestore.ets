/*
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

// [Start get_local_cap_ability]
// [Start session_backup]
// [Start session_restore]
import { fileIo as fs } from '@kit.CoreFileKit';
import { backup } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude session_restore]
// [StartExclude session_backup]
// [StartExclude get_local_cap_ability]
import { ReadOptions } from '@kit.CoreFileKit';
import buffer from '@ohos.buffer';
import Logger from '../common/Logger';

const BUFFER: number = 1024; // 读写文件的缓冲区
// [EndExclude get_local_cap_ability]
// [EndExclude session_backup]
// [EndExclude session_restore]

// 此处仅为示例，在组件中可以通过getHostContext获取路径
let filesDir = "/data/storage/el2/base/haps/entry/files";

// [StartExclude session_backup]
// [StartExclude session_restore]
// 获取能力文件
export async function getLocalCapabilities(): Promise<void> {
  try {
    let fileData = await backup.getLocalCapabilities();
    console.info('getLocalCapabilities success');
    let fpath = filesDir + '/localCapabilities.json';
    fs.copyFileSync(fileData.fd, fpath);
    // [StartExclude get_local_cap_ability]
    let file = fs.openSync(fpath, fs.OpenMode.READ_WRITE);
    // 从文件中读取一段内容
    let arrayBuffer = new ArrayBuffer(BUFFER);
    let readOptions: ReadOptions = {
      offset: 0, // 从文件的开头开始读取
      length: arrayBuffer.byteLength
    };
    let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
    // 这个 buf 对象是 arrayBuffer 中从位置 0 开始的前 readLen 字节
    let buf = buffer.from(arrayBuffer, 0, readLen);
    console.info('the content of file: ' + buf.toString());
    // [EndExclude get_local_cap_ability]
    fs.closeSync(fileData.fd);
  } catch (error) {
    console.error(`getLocalCapabilities failed with err, code is ${error.code}, message is ${error.message}`);
  }
}
// [End get_local_cap_ability]
// [EndExclude session_backup]

// 应用备份数据
// 创建SessionBackup类的实例用于备份数据
let gSession: backup.SessionBackup;

function createSessionBackup(): backup.SessionBackup {
  let generalCallbacks: backup.GeneralCallbacks = {
    // onFileReady为服务回调给应用侧数据完成的通知，建议开发者在该接口内不要进行过多的耗时实现，可以通过异步线程实现file.fd数据的处理
    onFileReady: (err: BusinessError, file: backup.File) => {
      if (err) {
        console.error(`onFileReady err, code is ${err.code}, message is ${err.message}`);
      }
      try {
        let bundlePath = filesDir + '/' + file.bundleName;
        if (!fs.accessSync(bundlePath)) {
          fs.mkdirSync(bundlePath);
        }
        // 此处执行copyFileSync会多一次内存拷贝，开发者可以直接使用onFileReady的file.fd来进行数据处理，处理完成后close即可，这样会减少内存消耗
        fs.copyFileSync(file.fd, bundlePath + `/${file.uri}`);
        fs.closeSync(file.fd);
        console.info('onFileReady success');
      } catch (error) {
		let err: BusinessError = error as BusinessError;
        console.error(`onFileReady failed. Code: ${err.code}, message: ${err.message}`);
      }
    },
    onBundleBegin: (err: BusinessError<string | void>, bundleName: string) => {
      if (err) {
        console.error(`onBundleBegin err, code is ${err.code}, message is ${err.message}`);
      } else {
        console.info('onBundleBegin bundleName: ' + bundleName);
      }
    },
    onBundleEnd: (err: BusinessError<string | void>, bundleName: string) => {
      if (err) {
        console.error(`onBundleEnd err, code is ${err.code}, message is ${err.message}`);
      } else {
        console.info('onBundleEnd bundleName: ' + bundleName);
      }
    },
    onAllBundlesEnd: (err: BusinessError) => {
      if (err) {
        console.error(`onAllBundlesEnd err, code is ${err.code}, message is ${err.message}`);
      } else {
        console.info('onAllBundlesEnd');
      }
    },
    onBackupServiceDied: () => {
      console.info('onBackupServiceDied');
    },
    onResultReport: (bundleName: string, result: string) => {
      console.info('onResultReport  bundleName: ' + bundleName);
      console.info('onResultReport  result: ' + result);
    },
    onProcess: (bundleName: string, process: string) => {
      console.info('onProcess bundleName: ' + bundleName);
      console.info('onProcess result: ' + process);
    }
  }
  let sessionBackup = new backup.SessionBackup(generalCallbacks);
  return sessionBackup;
}

// [StartExclude session_backup]
export async function release() {
  try {
    await gSession.release();
    console.info('release success');
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`release err, code is ${err.code}, message is ${err.message}`);
  }
}
// [EndExclude session_backup]
export async function sessionBackup(): Promise<void> {
  gSession = createSessionBackup();
  // 此处可根据backup.getLocalCapabilities()提供的能力文件，选择需要备份的应用
  // 也可直接根据应用包名称进行备份
  const backupApps: string[] = [
    'com.samples.filebackupextension',
  ]
  await gSession.appendBundles(backupApps);
  console.info('appendBundles success');
}
// [End session_backup]
// [EndExclude session_restore]
// 应用数据恢复
// 创建SessionRestore类的实例用于恢复数据
let gSessionRestore: backup.SessionRestore;
let initMap = new Map<string, number>();
let testFileNum = 2; // 初始化文件个数
let testBundleName = 'com.samples.filebackupextension'; // 测试包名
initMap.set(testBundleName, testFileNum);
let countMap = new Map<string, number>();
countMap.set(testBundleName, 0); // 初始化计数

async function publishFile(file: backup.File): Promise<void> {
  console.info('start publishFile');
  let fileMeta: backup.FileMeta = {
    bundleName: file.bundleName,
    uri: ''
  }
  await gSessionRestore.publishFile(fileMeta);
}

function createSessionRestore(): backup.SessionRestore {
  let generalCallbacks: backup.GeneralCallbacks = {
    onFileReady: (err: BusinessError, file: backup.File) => {
      if (err) {
        console.error(`onFileReady err, code is ${err.code}, message is ${err.message}`);
      }
      // 此处开发者请根据实际场景待恢复文件存放位置进行调整 bundlePath
      let bundlePath: string = `${filesDir}/${file.bundleName}/`;
      if (!fs.accessSync(bundlePath)) {
        console.error('onFileReady bundlePath err : ' + bundlePath);
      }
      console.info('fd : ' + file.fd);
      let targetPath = `${bundlePath}${file.uri}`;
      fs.copyFileSync(targetPath, file.fd);
      fs.closeSync(file.fd);
      let currentCount = countMap.get(file.bundleName) || 0; // 如果没有找到对应的计数，则默认返回 0
      countMap.set(file.bundleName, ++currentCount);
      // 恢复数据传输完成后，会通知服务端文件准备就绪
      if (countMap.get(file.bundleName) == initMap.get(file.bundleName)) { // 每个包的所有文件收到后触发publishFile
        publishFile(file);
      }
      console.info('onFileReady success');
    },
    onBundleBegin: (err: BusinessError<string | void>, bundleName: string) => {
      if (err) {
        console.error(`onBundleBegin failed with err, code is ${err.code}, message is ${err.message}`);
      }
      console.info('onBundleBegin success');
    },
    onBundleEnd: (err: BusinessError<string | void>, bundleName: string) => {
      if (err) {
        console.error(`onBundleEnd failed with err, code is ${err.code}, message is ${err.message}`);
      }
      console.info('onBundleEnd success');
    },
    onAllBundlesEnd: (err: BusinessError) => {
      if (err) {
        console.error(`onAllBundlesEnd failed with err, code is ${err.code}, message is ${err.message}`);
      }
      console.info('onAllBundlesEnd success');
    },
    onBackupServiceDied: () => {
      console.info('service died');
    },
    onResultReport: (bundleName: string, result: string) => {
      console.info('onResultReport  bundleName: ' + bundleName);
      console.info('onResultReport  result: ' + result);
    },
    onProcess: (bundleName: string, process: string) => {
      console.info('onProcess bundleName: ' + bundleName);
      console.info('onProcess result: ' + process);
    }
  }
  let sessionRestore = new backup.SessionRestore(generalCallbacks);
  return sessionRestore;
}

export async function sessionRestore(): Promise<void> {
  gSessionRestore = createSessionRestore();
  const restoreApps: string[] = [
    'com.samples.filebackupextension'
  ];
  // 能力文件的获取方式可以根据开发者实际场景进行调整。此处仅为请求示例
  // 开发者也可以根据能力文件内容的结构示例，自行构造能力文件内容
  let fileDat = await backup.getLocalCapabilities();
  await gSessionRestore.appendBundles(fileDat.fd, restoreApps);
  console.info('appendBundles success');
  // 添加需要恢复的应用成功后，请根据需要恢复的应用名称，调用getFileHandle接口获取待恢复应用数文件的文件句柄
  // 应用待恢复数据文件数请依据实际备份文件个数为准，此处仅为请求示例
  let handle: backup.FileMeta = {
    bundleName: restoreApps[0],
    uri: 'manage.json'
  };
  await gSessionRestore.getFileHandle(handle);
  handle.uri = 'part.0.tar';
  await gSessionRestore.getFileHandle(handle);
  console.info('getFileHandle success');
}
// [End session_restore]
