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
import { LoginReq, LoginRes } from './LoginModel';
import { BASE_URL, CONNECT_TIMEOUT, Log, METHOD_GET_SIGN, METHOD_LOGIN, READ_TIMEOUT } from 'library_communication';
import { BusinessError } from '@ohos.base';
import http from '@ohos.net.http';
import {
  ProductConfigCredentialCode,
  ProductConfigCredentialReq,
  ProductConfigCredentialRes
} from './ProductConfigCredentialModel';
import { GlobalStore } from '../util/GlobalStore';
import { GlobalContext } from '../util/GlobalContext';
import common from '@ohos.app.ability.common';

const TAG = 'NetworkApi';

export class NetworkApi {
  private static instance: NetworkApi | null = null;
  private context: common.Context;

  private constructor() {
    this.context = GlobalContext.get().getObject('context') as common.Context;
  }

  public static getInstance(): NetworkApi {
    if (!NetworkApi.instance) {
      NetworkApi.instance = new NetworkApi();
    }
    return NetworkApi.instance;
  }

  public async login(loginReq: LoginReq): Promise<LoginRes> {
    return new Promise((res) => {
      let httpRequest = http.createHttp();
      httpRequest.request(BASE_URL + METHOD_LOGIN, {
        method: http.RequestMethod.POST,
        header: [{
          'Content-Type': 'application/json',
        }],
        extraData: loginReq,
        connectTimeout: CONNECT_TIMEOUT,
        readTimeout: READ_TIMEOUT,
      }, (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          if (data.responseCode == http.ResponseCode.OK) {
            let loginRes = JSON.parse(data.result as string) as LoginRes;
            if (loginRes.data) {
              GlobalStore.getInstance().saveRefreshToken(loginRes.data.refreshToken!);
              GlobalStore.getInstance().saveAccessToken(loginRes.data.accessToken!);
              res(loginRes);
            } else {
              let loginRes = new LoginRes();
              loginRes.code = data.responseCode.toString();
              loginRes.msg = this.context.resourceManager.getStringSync($r('app.string.openvalley_toast_login_fail')
                .id);
              res(loginRes);
            }
          } else {
            let loginRes = new LoginRes();
            loginRes.code = data.responseCode.toString();
            loginRes.msg = data.result.toString();
            res(loginRes);
          }
        } else {
          Log.showError(TAG, JSON.stringify(err));
          let loginRes = new LoginRes();
          loginRes.code = err.code.toString();
          loginRes.msg = err.message.toString();
          res(loginRes);
        }
        httpRequest.destroy();
      });
    });
  }

  public async productConfigCredential(req: ProductConfigCredentialReq): Promise<ProductConfigCredentialRes> {

    return new Promise((res) => {
      let accessToken: string = GlobalStore.getInstance().getAccessToken();
      let tenantId: string = GlobalStore.getInstance().getTenantId();
      let httpRequest = http.createHttp();
      let options: http.HttpRequestOptions = {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Tokenauthorization': accessToken ? 'Bearer ' + accessToken : '',
          'Tenantid': tenantId ? tenantId : ''
        },
        extraData: req,
        connectTimeout: CONNECT_TIMEOUT,
        readTimeout: READ_TIMEOUT,
      };
      httpRequest.request(BASE_URL + METHOD_GET_SIGN, options, (err: BusinessError, data: http.HttpResponse) => {

        if (!err) {
          if (data.responseCode == http.ResponseCode.OK) {
            let credentialRes = JSON.parse(data.result as string) as ProductConfigCredentialRes;
            Log.showInfo(TAG, 'productConfigCredential 1 credentialRes : ' + JSON.stringify(credentialRes));
            res(credentialRes);
          } else {
            let credentialRes = new ProductConfigCredentialRes();
            credentialRes.code = new ProductConfigCredentialCode();
            credentialRes.code.code = data.responseCode.toString();
            credentialRes.code.msg = data.result.toString();
            res(credentialRes);
          }
        } else {
          Log.showError(TAG, JSON.stringify(err));
          let credentialRes = new ProductConfigCredentialRes();
          credentialRes.code = new ProductConfigCredentialCode();
          credentialRes.code.code = err.code.toString();
          credentialRes.code.msg = err.message.toString();
          res(credentialRes);
        }
        httpRequest.destroy();
      });
    });
  }
}

