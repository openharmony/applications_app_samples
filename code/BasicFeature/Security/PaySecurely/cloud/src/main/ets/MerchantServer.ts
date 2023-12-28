/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import cryptoFramework from '@ohos.security.cryptoFramework';
import { PayServer } from './PayServer';
import util from '@ohos.util';
import resourceManager from '@ohos.resourceManager';

interface ProductInfo {
  id: string,
  name: string,
  price: string,
  img: string,
}

enum ErrorCode {
  PLACE_ORDER_BODY_ERROR = 400,
  PLACE_ORDER_ERROR = 401,
}

const TAG = 'MerchantServer';
const PRICE = 100;
const TEXT_ENCODER = new util.TextEncoder();
const BASE64 = new util.Base64Helper();
const PLATFORM_NAME = '测试';
const SIGNER_INPUT = { data: TEXT_ENCODER.encodeInto('This is a test') };
const MERCHANT_PRI_KEY = 'MDECAQEEILoJbGqF0n4C+5KzSc8l6UFli3PAaH2+QYbe5sAxqCquoAoGCCqGSM49AwEH';
const PAY_PUB_KEY = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDFl9UiVDwrIUtTSFVaapGgH7v22lBqnm7kqOjUdNCaJE+eBVhCVT2K3KykPuE4xgtKej2ry+2Hme5MQaZZx7pxNkXE6P69y3m2Vbp1KnFgsXtWYldGA/vrmbXoDhKU4HdsPC4m+9vsELevFjuNyONMMMklF/l+3RdZ0gzRgOmJwIDAQAB';
const TEST_PRODUCTS: ProductInfo[] = Array.from({ length: 10 }, (_, i) => ({
  id: `${i + PRICE}`,
  name: '80包手帕纸卫生抽纸家用',
  price: '¥ 3.90',
  img: 'app.media.icon'
}));


export class MerchantServer {
  private merchantKey: cryptoFramework.KeyPair;
  private payKey: cryptoFramework.KeyPair;
  private static instance: MerchantServer;

  private constructor() {
  }

  public static getInstance(): MerchantServer {
    if (!MerchantServer.instance) {
      MerchantServer.instance = new MerchantServer();
    }
    return MerchantServer.instance;
  }

  public async placeAnOrder(body: ProductInfo): Promise<string> {
    if (!body.id || !body.name || !body.price) {
      throw {
        code: ErrorCode.PLACE_ORDER_BODY_ERROR,
      };
    }
    let isOrderRight = false;
    for (let product of TEST_PRODUCTS) {
      if (product.id === body.id && product.name === body.name && product.price === body.price) {
        isOrderRight = true;
      }
    }
    if (!isOrderRight) {
      throw {
        code: ErrorCode.PLACE_ORDER_ERROR,
      };
    }

    // 下单信息加密传输给支付服务器，生成支付订单
    let temStr = `platformName=${PLATFORM_NAME}&totalPrice=${body.price}&productName=${body.name}&productId=${body.id}`;
    if (!this.payKey) {
      let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024|PRIMES_2');
      this.payKey = await rsaGenerator.convertKey({ data: BASE64.decodeSync(PAY_PUB_KEY) }, null);
    }
    let cipher = cryptoFramework.createCipher('RSA1024|PKCS1');
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, this.payKey.pubKey, null);
    let dataBlob = await cipher.doFinal({ data: TEXT_ENCODER.encodeInto(temStr) });
    let str: string = BASE64.encodeToStringSync(dataBlob.data);
    let order = await PayServer.getInstance().generatePayOrder(str);
    AppStorage.setOrCreate("PayServer", PayServer.getInstance());
    if (!this.merchantKey) {
      let eccGenerator = cryptoFramework.createAsyKeyGenerator('ECC256');
      this.merchantKey = await eccGenerator.convertKey(null, { data: BASE64.decodeSync(MERCHANT_PRI_KEY) });
    }
    let signer = cryptoFramework.createSign('ECC256|SHA256');
    await signer.init(this.merchantKey.priKey);
    let signMessageBlob = await signer.sign(SIGNER_INPUT);
    let result: string = order + '&signer=' + BASE64.encodeToStringSync(signMessageBlob.data);
    return result;
  }

  public getProducts(): ProductInfo[] {
    return TEST_PRODUCTS;
  }
}
