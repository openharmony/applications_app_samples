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

// [Start specify_ecc_uncompressed_point_get_keypair]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

async function eccPointCompressedToPoint() {
  let pkData =
    new Uint8Array([2, 143, 39, 57, 249, 145, 50, 63, 222, 35, 70, 178, 121, 202, 154, 21, 146, 129, 75, 76, 63, 8, 195,
      157, 111, 40, 217, 215, 148, 120, 224, 205, 82]);
  let returnPoint = cryptoFramework.ECCKeyUtil.convertPoint('NID_brainpoolP256r1', pkData);
  console.info('convertPoint success');
  let eccCommonParamsSpec = cryptoFramework.ECCKeyUtil.genECCCommonParamsSpec('NID_brainpoolP256r1');
  let eccPubKeySpec: cryptoFramework.ECCPubKeySpec = {
    algName: 'ECC',
    specType: cryptoFramework.AsyKeySpecType.PUBLIC_KEY_SPEC,
    params: eccCommonParamsSpec,
    pk: returnPoint
  };
  let generatorBySpec = cryptoFramework.createAsyKeyGeneratorBySpec(eccPubKeySpec);
  let pubKey = await generatorBySpec.generatePubKey();
  let returnData = cryptoFramework.ECCKeyUtil.getEncodedPoint('NID_brainpoolP256r1', returnPoint, 'UNCOMPRESSED');
  console.info('returnData: ' +
    returnData); // 4,143,39,57,249,145,50,63,222,35,70,178,121,202,154,21,146,129,75,76,63,8,195,157,111,
  // 40,217,215,148,120,224,205,82,83,92,185,21,211,184,5,19,114,33,86,85,228,123,242,206,200,98,178,184,
  // 130,35,232,45,5,202,189,11,46,163,156,152
  let eccPkX = pubKey.getAsyKeySpec(cryptoFramework.AsyKeySpecItem.ECC_PK_X_BN);
  console.info('returnPoint x data: ' +
  returnPoint.x); // 64750044510792891439269945828433327517677381559622384455951527515863444933970
  console.info('ECC_PK_X_BN：' +
    eccPkX); // 64750044510792891439269945828433327517677381559622384455951527515863444933970
}
// [End specify_ecc_uncompressed_point_get_keypair]

@Entry
@Component
struct Index {
  @State message: string = 'GetKeyObject';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_getKeyObject'))
        .width('70%')
        .onClick(async () => {
          try {
            await eccPointCompressedToPoint();
            this.message = 'GetKeyObject Success';
          } catch {
            this.message = 'GetKeyObject Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}