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
import util from '@ohos.util';

export enum PayResult {
  SUCCESS = 200,
  FAIL = 400,
  ERROR = 600,
}

export interface User {
  name: string,
  payPassword: string,
}

const TAG = 'PayServer';
const TEXT_DECODER = util.TextDecoder.create('utf-8', { ignoreBOM: true });
const TEXT_ENCODER = new util.TextEncoder();
const SIGNER_INPUT = { data: TEXT_ENCODER.encodeInto('This is a test') };
const BASE64 = new util.Base64Helper();
// 支付服务端私钥
const PAY_PRI_KEY = 'MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAMMWX1SJUPCshS1NIVVpqkaAfu/baUGqebuSo6NR00JokT54FWEJVPYrcrKQ+4TjGC0p6PavL7YeZ7kxBplnHunE2RcTo/r3LebZVunUqcWCxe1ZiV0YD++uZtegOEpTgd2w8Lib72+wQt68WO43I40wwySUX+X7dF1nSDNGA6YnAgMBAAECgYACZjYJ7h5mt1hz9CzixgfoEhB9lq82tYgFvInyqkD04iBXKlbo+Jpo5KPmek39lmVnuMo6rnDhxoH0DxxLqq8An4Hk6f/G1Eyc681sEicuas4zanpGWtPA3Y+an9ZwwTolVIkiJw6nM4hz8QdEeiFK34Bfl28dz9kg89ZrVomlwQJBAOEJPtA7QPwSuxix2E+BsPVNg/EqXgs+9HoyF+lrH8to5gTAZSjydT03d6FUZOZBsgPB/hL+Avh5YTUjhBV6khcCQQDd7jPFabvcyr5cKyS2TqYGmqTnhDX3LxgB35GE6jLlMO3teIY1HUsQsV2946lE4s7aqcalXa37Dw7yLxwlbGZxAkAggA5TUotzHF1rFpxP90IQW26X0O+eHix+zWdIrdD8tpypyQOTI1ktSyp64U5lNs233zeLlKXnLtiMLSHxXC9nAkAPbZvTwYH5225YYfdvZRBNrTqBjcNip7d3id9H6jAXlsszkwlhb+PkCTCHHuiJjWrr8JmKrXSG24kidPvz7hFBAkABQhnS1b3O4IIs5rdQTwcgBpzUk76csUQFB35g0IMV4jeHE7+84rNJDQ8hgStmyQvrLH8bBjX3xftxvj+q57cd';
// 商户服务端公钥
const MERCHANT_PUB_KEY = 'MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE/4Xcag3k5SBGX52KduDPcYBSEanwpo85kzGceENvQkhG0UinwwxSttkXv9os1pikfChaD5vR2BhXsco54SC/rA==';
// 支付客户端私钥
const PAY_CLIENT_PRI_KEY = 'MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAPvx0A4ex864EDiA8wDwY7/kqVDjzvsoC9pOSkkgMCRoBuWEADHiYoZrgrg9NLtPHONd0SD8Jk4B2eqym4ylB/bk87Jy4bbIdajeM86tvuS2R/RqPlOdFbeRoGFnlPITozGdQImH4eRfwRCnpYZqooIHDkPUWD2gDSuBmKCLqcP/AgMBAAECgYEAlrVgsoGhHjwmn9YrBp3F3Y0H53ZOYxjidjUs5K9XfP+pWHPstepo62W2bUVXnNBHRI7jQWrz8ufSlj0/JRO3Pb6CJp4u3Qw4ty/GAXtNUaaEb8Ll0SFkwu7TiUkHCEjnjF/aCkFVOAxwa2RT0GWs1uj+uqF7KyMylL4RZCyAnCkCQQD+74SDaTomcNHzPpVXyumZpmIxWpkP6GbcA0yjV3aw+K7IIHs20cYiNRXWw51Uh1aHTwqd8+/Ywq6IP9VHZT27AkEA/P8ZIoUZ/QsvIu0eUZRE9JaB4bcfD8RUGetqZhZA6J6Nd6uJ1nut/XG0JGa4wqSqBWGs8BBV6aDNuJzrzOYMjQJBAMMMwphAhEsw+pFfCqhXCY+Ta4FTTdSL/VbL93Dp1FfmjON1ZpA0w6EceI8Or2si+SMhaIAdSR7RJPP90tKDNU0CQExxX8zYXsPgjzuEXfbUUAl/OHtU82O2NJsoUJvL+YzP63rPL/TIpgfARWgCSa02R9EcdD6NEQhoeABiGbVthTkCQF8gsjNa6KIpfqEf4+DZFNO2o28ELyniY4O6xUKHWfiU7vKxRQ2DFYQ8Hv9Q07HB69kXc0p/XLJxjpX0K/Wpn2k=';
const TEST_USER: User = {
  name: 'test',
  payPassword: '123456',
};
const HEXADECIMAL = 36;
const CONTAINS_LETTERS = 2;
const MIN_LENGTH = 2;
const INDEX_ZERO = 0;

export class PayServer {
  private orderString: string;
  private merchantKey: cryptoFramework.KeyPair;
  private payKey: cryptoFramework.KeyPair;
  private payClientKey: cryptoFramework.KeyPair;
  private static instance: PayServer;

  private constructor() {
  }

  public static getInstance(): PayServer {
    if (!PayServer.instance) {
      PayServer.instance = new PayServer();
    }
    return PayServer.instance;
  }

  public async generatePayOrder(body: string): Promise<string> {
    if (!this.payKey) {
      let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024|PRIMES_2');
      this.payKey = await rsaGenerator.convertKey(null, { data: BASE64.decodeSync(PAY_PRI_KEY) });
    }
    let decoder = cryptoFramework.createCipher('RSA1024|PKCS1');
    await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, this.payKey.priKey, null);
    let data = await decoder.doFinal({ data: BASE64.decodeSync(body) });
    let bodyStr = TEXT_DECODER.decodeWithStream(data.data);
    this.orderString = bodyStr + '&orderId=' + Array.from({
      length: 17
    }, () => Math.random().toString(HEXADECIMAL)[CONTAINS_LETTERS]).join('').toUpperCase();
    return this.orderString;
  }

  public async pay(orderString: string, userName: string, password: string): Promise<PayResult> {
    let temArr = orderString.split('&signer=');
    if (temArr.length < MIN_LENGTH || temArr[INDEX_ZERO] !== this.orderString) {
      return PayResult.ERROR;
    }
    if (!this.merchantKey) {
      let eccGenerator = cryptoFramework.createAsyKeyGenerator('ECC256');
      this.merchantKey = await eccGenerator.convertKey({ data: BASE64.decodeSync(MERCHANT_PUB_KEY) }, null);
    }
    let verifyer = cryptoFramework.createVerify('ECC256|SHA256');
    await verifyer.init(this.merchantKey.pubKey);
    let verifyOk = await verifyer.verify(SIGNER_INPUT, { data: BASE64.decodeSync(temArr[1]) });
    if (!verifyOk) {
      return PayResult.ERROR;
    }
    if (!this.payClientKey) {
      let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024|PRIMES_2');
      this.payClientKey = await rsaGenerator.convertKey(null, { data: BASE64.decodeSync(PAY_CLIENT_PRI_KEY) });
    }
    let decoder = cryptoFramework.createCipher('RSA1024|PKCS1');
    await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, this.payClientKey.priKey, null);
    let userNameData = await decoder.doFinal({ data: BASE64.decodeSync(userName) });
    if (TEST_USER.name !== TEXT_DECODER.decodeWithStream(userNameData.data)) {
      return PayResult.FAIL;
    }
    let passwordData = await decoder.doFinal({ data: BASE64.decodeSync(password) });
    if (TEST_USER.payPassword !== TEXT_DECODER.decodeWithStream(passwordData.data)) {
      return PayResult.FAIL;
    }
    return PayResult.SUCCESS;
  }
}