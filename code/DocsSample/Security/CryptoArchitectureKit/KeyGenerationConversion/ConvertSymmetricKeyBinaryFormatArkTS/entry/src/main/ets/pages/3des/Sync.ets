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

// [Start generate_3des_key_sync]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';

function genKeyMaterialBlob(): cryptoFramework.DataBlob {
  let arr = [
  0xba, 0x3d, 0xc2, 0x71, 0x21, 0x1e, 0x30, 0x56,
    0xad, 0x47, 0xfc, 0x5a, 0x46, 0x39, 0xee, 0x7c,
    0xba, 0x3b, 0xc2, 0x71, 0xab, 0xa0, 0x30, 0x72]; // 密钥长度为192位，即24字节。
  let keyMaterial = new Uint8Array(arr);
  return { data: keyMaterial };
}

function testConvertSymKey() {
  // 创建SymKeyGenerator实例
  let symKeyGenerator = cryptoFramework.createSymKeyGenerator('3DES192');
  // 根据指定的数据生成对称密钥
  let keyMaterialBlob = genKeyMaterialBlob();
  try {
    symKeyGenerator.convertKey(keyMaterialBlob, (error, key) => {
      if (error) { // 如果业务逻辑执行失败，则callback的第一个参数返回错误信息，即异步抛出异常
        let e: BusinessError = error as BusinessError;
        console.error(`convertKey error, ${e.code}, ${e.message}`);
        return;
      }
      console.info('key algName：' + key.algName);
      console.info('key format：' + key.format);
      let encodedKey = key.getEncoded(); // 获取对称密钥的二进制数据，并以字节数组形式输出。长度为24字节
      console.info('key getEncoded hex: ' + encodedKey.data);
    })
  } catch (error) { // 参数检查发现错误立即抛出异常
    let e: BusinessError = error as BusinessError;
    console.error(`convertKey failed, ${e.code}, ${e.message}`);
  }
}
// [End generate_3des_key_sync]

@Entry
@Component
struct Index {
  @State message: string = 'Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_3des_sync'))
        .width('70%')
        .onClick(() => {
          try {
            testConvertSymKey();
            this.message = '3DES Sync Success';
          } catch {
            this.message = '3DES Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}