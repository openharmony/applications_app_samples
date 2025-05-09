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

// [Start application_file_share]
// [Start get_uri]
import { common } from '@kit.AbilityKit';
import { fileIo as fs, ReadOptions, ListFileOptions } from '@kit.CoreFileKit';
import Logger from '../common/Logger';
import { buffer } from '@kit.ArkTS';
import { fileUri } from '@kit.CoreFileKit';
import { Want, wantConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

// 获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir;

// 分享应用文件
export async function shareFile(fileName: string): Promise<void> {
  // 获取文件的沙箱路径
  let pathInSandbox = context.filesDir + '/' + fileName + '.txt';
  // 将沙箱路径转换为uri
  let uri = fileUri.getUriFromPath(pathInSandbox);
  // [End get_uri]
  Logger.info('FilePath is : ' + uri);
  let want: Want = {
    // 配置被分享文件的读写权限，例如对被分享应用进行读写授权
    flags: wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
    // 配置分享应用的隐式拉起规则
    action: 'ohos.want.action.sendData',
    uri: uri,
    type: 'text/plain',
  };
  await context.startAbility(want)
    .then(() => {
      Logger.info('Invoke getCurrentBundleStats succeeded.');
    })
    .catch((err: BusinessError) => {
      Logger.error(`Invoke startAbility failed, code is ${err.code}, message is ${err.message}`);
    });
}

// [End application_file_share]
// 新建并读写一个文件test1.txt
export function createFile(): number {
  // 新建并打开文件
  let file = fs.openSync(filesDir + '/test1.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  // 写入一段内容至文件
  let writeLen = fs.writeSync(file.fd, 'Share file test1.txt from SandboxShare');
  Logger.info('The length of str is: ' + writeLen);
  // 关闭文件
  fs.closeSync(file);
  return writeLen;
}

// 读取文件内容
export function readFile(fileName: string): string {
  let file = fs.openSync(filesDir + '/' + fileName + '.txt', fs.OpenMode.READ_WRITE);
  // 创建一个大小为1024字节的ArrayBuffer对象，用于存储从文件中读取的数据
  let arrayBuffer = new ArrayBuffer(1024);
  let readOptions: ReadOptions = {
    offset: 0, // 从文件的开头开始读取
    length: arrayBuffer.byteLength
  };
  let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
  let buf = buffer.from(arrayBuffer, 0, readLen); // 这个 Buffer 对象是 arrayBuffer 中从位置 0 开始的前 readLen 字节
  Logger.info('the content of file: ' + buf.toString());
  // 关闭文件
  let str = 'the content of file: ' + buf.toString();
  fs.closeSync(file);
  return str;
}

// 查看文件列表
export function getListFile(): string {
  let str = '';
  let listFileOption: ListFileOptions = {
    recursion: false,
    listNum: 0, // 0 表示不限制文件数量
    filter: {
      suffix: ['.png', '.jpg', '.txt'],
      displayName: ['*'],
      fileSizeOver: 0, // 0 表示列出所有文件，不限制文件大小
      lastModifiedAfter: new Date(0).getTime() // 返回的时间戳是0
    }
  };
  let files = fs.listFileSync(filesDir, listFileOption);
  for (let i = 0; i < files.length; i++) {
    Logger.info(`The name of file: ${files[i]}`);
    str += files[i] + '\n';
  }
  return str;
}
