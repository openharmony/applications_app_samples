/*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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
import InputMethodExtensionAbility from '@ohos.InputMethodExtensionAbility';
import keyboardController from './model/KeyboardController';
import Want from '@ohos.app.ability.Want';
import fs, { ReadOptions } from '@ohos.file.fs';
import { logger } from '../utils/Logger';

export default class InputDemo1Service extends InputMethodExtensionAbility {
  onCreate(want: Want): void {
    keyboardController.onCreate(this.context); // 初始化窗口并注册对输入法框架的事件监听
    let filesDir = this.context.filesDir;
    let filesDir2 = this.context.getApplicationContext().filesDir;
    // 创建inputmethod module级别的独立extension的沙箱文件 /entry
    let file1 = fs.openSync(filesDir + '/inputtest1.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    // 写入一段内容至文件
    let writeLen = fs.writeSync(file1.fd, 'main Try to write str.');
    logger.info('main The length of str is:' + writeLen);
    // 关闭文件
    fs.closeSync(file1);
    // 创建inputmethod应用级别的独立extension的沙箱文件
    let file2 = fs.openSync(filesDir2 + '/inputtest2.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    // 写入一段内容至文件
    let writeLen2 = fs.writeSync(file2.fd, 'main Try to write str.'); //返回流文件length
    logger.info('main The length of str is:' + writeLen2);
    // 关闭文件
    fs.closeSync(file2);

    //预期结果，无法读写
    try {
      fs.openSync(filesDir + '/inputtest3.txt', fs.OpenMode.READ_WRITE);
    } catch (e) {
      logger.error(`input openSync module err: ${JSON.stringify(e)}`);
    }

    //预期结果，无法读写
    try {
      fs.openSync(filesDir2 + '/inputtest4.txt', fs.OpenMode.READ_WRITE);
    } catch (e) {
      logger.error(`input openSync app err: ${JSON.stringify(e)}`);
    }

    // inputmethod 访问其配置groupId的宿主应用的共享沙箱 访问成功 用户开启非严格模式 可以读写
    this.context.getGroupDir('test1', (err, data) => {
      if (err) {
        logger.error(`1：getGroupDir failed, err: ${JSON.stringify(err)}`);
      } else {
        filesDir = data;
        try {
          let file = fs.openSync(filesDir + '/groupTest1.txt', fs.OpenMode.READ_WRITE);
          let writeLen = 0;
          try {
            writeLen = fs.writeSync(file.fd, '1:inputMethod Try to write str.');
          } catch (e) {
            logger.error(`1：fs.writeSync err: ${JSON.stringify(e)}`);
          }
          logger.info('1：The length of str is:' + writeLen);
          // 从文件读取一段内容
          let arrayBuffer = new ArrayBuffer(1024);
          let readOptions: ReadOptions = {
            offset: 0,
            length: arrayBuffer.byteLength
          };
          let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
          let buf = buffer.from(arrayBuffer, 0, readLen);
          logger.info('1:the content of file:' + buf.toString());
          // 关闭文件
          fs.closeSync(file);
        } catch (e) {
          logger.error(`1：fs.openSync err: ${JSON.stringify(e)}`);
        }
      }
    });

    // 访问失败 没有权限
    this.context.getGroupDir('test2', (err, data) => {
      if (err) {
        logger.error(`2：getGroupDir failed, err: ${JSON.stringify(err)}`);
      } else {
        filesDir = data;
        try {
          let file = fs.openSync(filesDir + '/groupTest2.txt', fs.OpenMode.READ_WRITE);
          let writeLen = 0;
          try {
            writeLen = fs.writeSync(file.fd, '2:inputMethod Try to write str.');
          } catch (e) {
            logger.error(`2：fs.writeSync err: ${JSON.stringify(e)}`);
          }
          logger.info('2：The length of str is:' + writeLen);
          // 从文件读取一段内容
          let arrayBuffer = new ArrayBuffer(1024);
          let readOptions: ReadOptions = {
            offset: 0,
            length: arrayBuffer.byteLength
          };
          let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
          let buf = buffer.from(arrayBuffer, 0, readLen);
          logger.info('2:the content of file:' + buf.toString());
          // 关闭文件
          fs.closeSync(file);
        } catch (e) {
          logger.error(`2：fs.openSync err: ${JSON.stringify(e)}`);
        }
      }
    });
  }

  onDestroy(): void {
    keyboardController.onDestroy(); // 销毁窗口并去注册事件监听
  }
}