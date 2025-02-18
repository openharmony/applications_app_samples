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

import { cryptoFramework } from '@kit.CryptoArchitectureKit';

function genSM2KeyPairSpec() {
  let sm2CommonParamsSpec = cryptoFramework.ECCKeyUtil.genECCCommonParamsSpec('NID_sm2');
  let sm2KeyPairSpec: cryptoFramework.ECCKeyPairSpec = {
    algName: 'SM2',
    specType: cryptoFramework.AsyKeySpecType.KEY_PAIR_SPEC,
    params: sm2CommonParamsSpec,
    sk: BigInt('0x6330B599ECD23ABDC74B9A5B7B5E00E553005F72743101C5FAB83AEB579B7074'),
    pk: {
      x: BigInt('0x67F3B850BDC0BA5D3A29D8A0883C4B17612AB84F87F18E28F77D824A115C02C4'),
      y: BigInt('0xD48966CE754BBBEDD6501A1385E1B205C186E926ADED44287145E8897D4B2071')
    },
  };
  return sm2KeyPairSpec;
}

function sm2TestSync() {
  let sm2KeyPairSpec = genSM2KeyPairSpec();
  let generatorBySpec = cryptoFramework.createAsyKeyGeneratorBySpec(sm2KeyPairSpec);
  try {
    let keyPair = generatorBySpec.generateKeyPairSync();
    if (keyPair != null) {
      let sm2CurveName = keyPair.priKey.getAsyKeySpec(cryptoFramework.AsyKeySpecItem.ECC_CURVE_NAME_STR);
      console.info('ECC_CURVE_NAME_STR: ' + sm2CurveName); // NID_sm2
    } else {
      console.error('get key pair result fail!');
    }
  } catch (e) {
    console.error(`get key pair result fail, ${e.code}, ${e.message}`);
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'SM2 Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm2_sync'))
        .width('70%')
        .onClick(() => {
          try {
            sm2TestSync();
            this.message = 'SM2 Sync Success';
          } catch {
            this.message = 'SM2 Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}