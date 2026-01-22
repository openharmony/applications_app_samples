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
// [Start prikey_decoding]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';

let priKeyPkcs1EncodingStr : string =
'-----BEGIN RSA PRIVATE KEY-----\n'+
  'Proc-Type: 4,ENCRYPTED\n'+
  'DEK-Info: AES-128-CBC,815A066131BF05CF87CE610A59CC69AE\n\n'+
  '7Jd0vmOmYGFZ2yRY8fqRl3+6rQlFtNcMILvcb5KWHDSrxA0ULmJE7CW0DSRikHoA\n'+
  't0KgafhYXeQXh0dRy9lvVRAFSLHCLJVjchx90V7ZSivBFEq7+iTozVp4AlbgYsJP\n'+
  'vx/1sfZD2WAcyMJ7IDmJyft7xnpVSXsyWGTT4f3eaHJIh1dqjwrso7ucAW0FK6rp\n'+
  '/TONyOoXNfXtRbVtxNyCWBxt4HCSclDZFvS9y8fz9ZwmCUV7jei/YdzyQI2wnE13\n'+
  'W8cKlpzRFL6BWi8XPrUtAw5MWeHBAPUgPWMfcmiaeyi5BJFhQCrHLi+Gj4EEJvp7\n'+
  'mP5cbnQAx6+paV5z9m71SKrI/WSc4ixsYYdVmlL/qwAK9YliFfoPl030YJWW6rFf\n'+
  'T7J9BUlHGUJ0RB2lURNNLakM+UZRkeE9TByzCzgTxuQtyv5Lwsh2mAk3ia5x0kUO\n'+
  'LHg3Eoabhdh+YZA5hHaxnpF7VjspB78E0F9Btq+A41rSJ6zDOdToHey4MJ2nxdey\n'+
  'Z3bi81TZ6Fp4IuROrvZ2B/Xl3uNKR7n+AHRKnaAO87ywzyltvjwSh2y3xhJueiRs\n'+
  'BiYkyL3/fnocD3pexTdN6h3JgQGgO5GV8zw/NrxA85mw8o9im0HreuFObmNj36T9\n'+
  'k5N+R/QIXW83cIQOLaWK1ThYcluytf0tDRiMoKqULiaA6HvDMigExLxuhCtnoF8I\n'+
  'iOLN1cPdEVQjzwDHLqXP2DbWW1z9iRepLZlEm1hLRLEmOrTGKezYupVv306SSa6J\n'+
  'OA55lAeXMbyjFaYCr54HWrpt4NwNBX1efMUURc+1LcHpzFrBTTLbfjIyq6as49pH\n'+
  '-----END RSA PRIVATE KEY-----';

async function prikeyDecoding() {
  let asyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
  asyKeyGenerator.convertPemKey(null, priKeyPkcs1EncodingStr, '123456')
    .then(keyPair => {
      let priKey = keyPair.priKey;
      if (priKey) {
        console.info('convertPemKey result: success.');
      }
    }).catch((error: BusinessError) => {
    console.error(`convertPemKey failed: errCode: ${error.code}, message: ${error.message}`);
  });
}
// [End prikey_decoding]

@Entry
@Component
struct Index {
  @State message: string = 'Prikey Decoding';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_prikey_decoding'))
        .width('70%')
        .onClick(async () => {
          try {
            await prikeyDecoding();
            this.message = 'Prikey Decoding Success';
          } catch {
            this.message = 'Prikey Decoding Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}