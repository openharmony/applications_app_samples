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

import { osAccount } from '@kit.BasicServicesKit';
import account_osAccount from "@ohos.account.osAccount";

function strToUint8Arr(str: string): Uint8Array {
  const buffer: number[] = [];
  for (let i = 0; i < str.length; i++) {
    const char = str.charAt(i);
    const code = char.codePointAt(0)!;
    if (code < 0x80) {
      buffer.push(code);
    } else if (code < 0x800) {
      buffer.push(0xc0 + (code >> 6));
      buffer.push(0x80 + (code & 0x3f));
    } else if (code < 0x10000) {
      buffer.push(0xe0 + (code >> 12));
      buffer.push(0x80 + ((code >> 6) & 0x3f));
      buffer.push(0x80 + (code & 0x3f));
    }
  }
  return new Uint8Array(buffer);
}

@Entry
@Component
struct SystemAccount {
  @State message: string = 'Nothing';
  @State cid: number = 100;
  @State textPassword: string = ''
  @State oldTextPassword: string = ''

  private async addCred(): Promise<void> {
    try {
      this.cid = await account_osAccount.getAccountManager().getForegroundOsAccountLocalId();
      let userIDM = new account_osAccount.UserIdentityManager();
      let password: Uint8Array = new Uint8Array([0x31, 0x32, 0x33, 0x34, 0x35, 0x36]);
      if (this.textPassword != '') {
        password = strToUint8Arr(this.textPassword);
      }
      let PINAuth = new account_osAccount.PINAuth();
      let credentialInfo :account_osAccount.CredentialInfo = {
        accountId: this.cid,
        credType:account_osAccount.AuthType.PIN,
        credSubType:account_osAccount.AuthSubType.PIN_SIX,
        token:new Uint8Array([])
      }
      PINAuth.unregisterInputer();
      PINAuth.registerInputer({
        onGetData:(authSubType, callback)=>{
          callback.onSetData(account_osAccount.AuthSubType.PIN_SIX, password);
        }
      })
      userIDM.closeSession(this.cid);
      userIDM.openSession(this.cid).then((data)=>{
        console.log('openSession info: ' + JSON.stringify(data));
        userIDM.addCredential(credentialInfo,{
          onResult: (err, extraInfo)=>{
            console.log('addCredential result: ' + JSON.stringify(err));
            console.log('edential info: ' + JSON.stringify(extraInfo));
            if (err == 0) {
              this.message = 'PIN code entry successful';
            } else {
              this.message = 'PIN code entry failed: ' + JSON.stringify(err);
            }
            PINAuth.unregisterInputer();
            userIDM.closeSession(this.cid);
          }})
      }).catch((err: Error)=>{
        console.error('openSession failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to open session:' + JSON.stringify(err);
      })
    } catch (e) {
      console.error('getEnrolledId cur failed, error: ' + JSON.stringify(e));
    }
  }

  private async auth(): Promise<void> {
    try {
      let userIDM = new account_osAccount.UserIdentityManager();
      let userAuth = new account_osAccount.UserAuth();
      let PINAuth = new account_osAccount.PINAuth();
      let password: Uint8Array = new Uint8Array([0x31, 0x32, 0x33, 0x34, 0x35, 0x36]);
      if (this.textPassword != '') {
        password = strToUint8Arr(this.textPassword);
      }
      PINAuth.unregisterInputer();
      PINAuth.registerInputer({
        onGetData:(authSubType, callback)=>{
          callback.onSetData(account_osAccount.AuthSubType.PIN_SIX, password);
        }
      })
      userIDM.closeSession(this.cid);
      userIDM.openSession(this.cid).then((data)=>{
        console.log('openSession info: ' + JSON.stringify(data));
        let authType: osAccount.AuthType = osAccount.AuthType.PIN;
        let authTrustLevel: osAccount.AuthTrustLevel = osAccount.AuthTrustLevel.ATL1;
        userAuth.auth(data, authType, authTrustLevel, {
          onResult: (result: number, extraInfo: osAccount.AuthResult) => {
            console.log('pin auth result = ' + result);
            console.log('pin auth extraInfo = ' + JSON.stringify(extraInfo));
            let authToken = extraInfo.token;
            if(result == 0) {
              this.message = 'PIN code entry successful';
            } else {
              this.message = 'PIN code authentication failed: ' + result;
            }
          }
        });
      }).catch((err: Error)=>{
        console.error('openSession failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to open session:' + JSON.stringify(err);
      })
    } catch (err) {
      console.error('getEnrolledId cur failed, error: ' + JSON.stringify(err));
    }
  }

  private async addBiologyCred(): Promise<void> {
    let faceCredInfo: osAccount.CredentialInfo = {
      credType: osAccount.AuthType.FACE,
      credSubType: osAccount.AuthSubType.FACE_2D,
      token: new Uint8Array([1, 2, 3, 4, 5])
    }
    let fingerprintCredInfo: osAccount.CredentialInfo = {
      credType: osAccount.AuthType.FINGERPRINT,
      credSubType: osAccount.AuthSubType.FINGERPRINT_CAPACITIVE,
      token: new Uint8Array([1, 2, 3, 4, 5])
    }
    try {
      let userIDM = new account_osAccount.UserIdentityManager();
      let userAuth = new account_osAccount.UserAuth();
      let PINAuth = new account_osAccount.PINAuth();
      let password: Uint8Array = new Uint8Array([0x31, 0x32, 0x33, 0x34, 0x35, 0x36]);
      PINAuth.unregisterInputer();
      PINAuth.registerInputer({
        onGetData:(authSubType, callback)=>{
          callback.onSetData(account_osAccount.AuthSubType.PIN_SIX, password);
        }
      })
      userIDM.closeSession(this.cid);
      userIDM.openSession(this.cid).then((data)=>{
        console.log('openSession info: ' + JSON.stringify(data));
        let authType: osAccount.AuthType = osAccount.AuthType.PIN;
        let authTrustLevel: osAccount.AuthTrustLevel = osAccount.AuthTrustLevel.ATL1;
        userAuth.auth(data, authType, authTrustLevel, {
          onResult: (result: number, extraInfo: osAccount.AuthResult) => {
            console.log('pin auth result = ' + result);
            console.log('pin auth extraInfo = ' + JSON.stringify(extraInfo));
            faceCredInfo.token = extraInfo.token;
            fingerprintCredInfo.token = extraInfo.token;
            userIDM.addCredential(faceCredInfo, {
              onResult: (code: number, result: osAccount.RequestResult) => {
                console.log('add face credential, resultCode: ' + code);
                console.log('add face credential, request result: ' + result);
                if(code == 0) {
                  this.message = 'Successfully entered facial credentials';
                } else {
                  this.message = 'Failed to enter facial credentials: ' + code;
                }
              }
            });
            userIDM.addCredential(fingerprintCredInfo, {
              onResult: (code: number, result: osAccount.RequestResult) => {
                console.log('add fingerprint credential, resultCode: ' + code);
                console.log('add fingerprint credential, request result: ' + result);
                if(code == 0) {
                  this.message += 'Successfully entered fingerprint credentials';
                } else {
                  this.message = 'Failed to enter fingerprint credentials: ' + code;
                }
              }
            });
          }
        });
      }).catch((err: Error)=>{
        console.error('openSession failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to open session:' + JSON.stringify(err);
      })
    } catch (err) {
      console.error('getEnrolledId cur failed, error: ' + JSON.stringify(err));
    }
  }

  private async biologyAuth(): Promise<void> {
    try {
      let userIDM = new account_osAccount.UserIdentityManager();
      let userAuth = new account_osAccount.UserAuth();
      let PINAuth = new account_osAccount.PINAuth();
      let password: Uint8Array = new Uint8Array([0x31, 0x32, 0x33, 0x34, 0x35, 0x36]);
      PINAuth.unregisterInputer();
      PINAuth.registerInputer({
        onGetData:(authSubType, callback)=>{
          callback.onSetData(account_osAccount.AuthSubType.PIN_SIX, password);
        }
      })
      userIDM.closeSession(this.cid);
      userIDM.openSession(this.cid).then((data)=>{
        console.log('openSession info: ' + JSON.stringify(data));
        let authType: osAccount.AuthType = osAccount.AuthType.FACE;
        let authTrustLevel: osAccount.AuthTrustLevel = osAccount.AuthTrustLevel.ATL1;
        userAuth.auth(data, authType, authTrustLevel, {
          onResult: (result: number, extraInfo: osAccount.AuthResult) => {
            console.log('face auth result = ' + result);
            console.log('face auth extraInfo = ' + JSON.stringify(extraInfo));
            if(result == 0) {
              this.message = 'Successfully authenticated biometric credentials';
            } else {
              this.message = 'Failed to authenticate biometric credentials: ' + result;
            }
          }
        });
      }).catch((err: Error)=>{
        console.error('openSession failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to open session:' + JSON.stringify(err);
      })
    } catch (err) {
      console.error('getEnrolledId cur failed, error: ' + JSON.stringify(err));
    }
  }

  private async updateCred(): Promise<void> {
    let userIDM = new account_osAccount.UserIdentityManager();
    let userAuth = new account_osAccount.UserAuth();
    let PINAuth = new account_osAccount.PINAuth();
    let oldPassword: Uint8Array = new Uint8Array([0x31, 0x32, 0x33, 0x34, 0x35, 0x36]);
    if (this.oldTextPassword != '') {
      oldPassword = strToUint8Arr(this.oldTextPassword);
    }
    let password: Uint8Array = new Uint8Array([0x31, 0x31, 0x31, 0x31, 0x31, 0x31]);
    if (this.textPassword != '') {
      password = strToUint8Arr(this.textPassword);
    }
    let credentialInfo :account_osAccount.CredentialInfo = {
      accountId:this.cid,
      credType:account_osAccount.AuthType.PIN,
      credSubType:account_osAccount.AuthSubType.PIN_SIX,
      token:new Uint8Array([])
    }
    PINAuth.unregisterInputer();
    PINAuth.registerInputer({
      onGetData:(authSubType, callback)=>{
        callback.onSetData(account_osAccount.AuthSubType.PIN_SIX, oldPassword);
      }
    })
    userIDM.openSession(this.cid).then((data)=>{
      console.log('openSession info: ' + JSON.stringify(data));
      userAuth.authUser(this.cid, data, account_osAccount.AuthType.PIN,
        account_osAccount.AuthTrustLevel.ATL1, {
        onResult:(err, authResult)=>{
          console.log('authUser err: ' + JSON.stringify(err));
          console.log('authUser info: ' + JSON.stringify(authResult));
          console.log('authUser info.userId: ' + authResult.accountId);
          credentialInfo.token = authResult.token;
          PINAuth.unregisterInputer();
          PINAuth.registerInputer({
            onGetData:(subType, callback) =>{
              callback.onSetData(account_osAccount.AuthSubType.PIN_SIX, password)
            }
          })
          userIDM.updateCredential(credentialInfo, {
            onResult:(result: number, extraInfo: osAccount.RequestResult)=>{
              console.log('updateCredential result: ' + JSON.stringify(result));
              console.log('updateCredential extraInfo: ' + JSON.stringify(extraInfo));
              if(result == 0) {
                this.message = 'Successfully updated PIN code credentials';
              } else {
                this.message = 'Failed to update PIN code credentials: ' + JSON.stringify(result);
              }
              PINAuth.unregisterInputer();
              userIDM.closeSession(this.cid);
            }
          })
        }
      })
    }).catch((err: Error)=>{
      console.error('openSession failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to open session:' + JSON.stringify(err);
    })
  }

  private async getCred(): Promise<void> {
    let userIDM = new account_osAccount.UserIdentityManager();
    try {
      userIDM.getAuthInfo((err, data)=>{
        console.log('getAuthInfo err: ' + JSON.stringify(err));
        console.log('getAuthInfo data: ' + JSON.stringify(data));
        this.message = 'Query information length: ' + data.length;
      })
      let enrolledFingerCredInfoList: osAccount.EnrolledCredInfo[] =
        await userIDM.getAuthInfo(osAccount.AuthType.PIN);
    } catch (err) {
      console.error('getAuthInfo failed: ' + JSON.stringify(err));
      this.message = 'Query information failed: ' + JSON.stringify(err);
    }
  }

  private async deleteBiologyCred(): Promise<void> {
    let userIDM = new account_osAccount.UserIdentityManager();
    let userAuth = new account_osAccount.UserAuth();
    let PINAuth = new account_osAccount.PINAuth();
    let credentialId: Uint8Array = new Uint8Array([1, 2, 3, 4, 5]);
    let token: Uint8Array = new Uint8Array([1, 2, 3, 4, 5])
    let credInfoList: osAccount.EnrolledCredInfo[] = 
      await userIDM.getAuthInfo(osAccount.AuthType.FINGERPRINT);
    if (credInfoList.length != 0) {
      credentialId = credInfoList[0].credentialId;
    }
    PINAuth.unregisterInputer();
    PINAuth.registerInputer({
      onGetData:(authSubType, callback)=>{
        callback.onSetData(account_osAccount.AuthSubType.PIN_SIX,
          new Uint8Array([0x31, 0x31, 0x31, 0x31, 0x31, 0x31]));
      }
    })
    userIDM.closeSession(this.cid)
    userIDM.openSession(this.cid).then((data)=>{
      console.log('openSession info: ' + JSON.stringify(data));
      userAuth.authUser(this.cid, data, account_osAccount.AuthType.PIN,
        account_osAccount.AuthTrustLevel.ATL1, {
        onResult:(err, authResult)=>{
          console.log('authUser err: ' + JSON.stringify(err));
          console.log('authUser info: ' + JSON.stringify(authResult));
          console.log('authUser info.userId: ' + authResult.accountId);
          try {
            userIDM.delCred(credentialId, authResult.token, {
              onResult: (result: number, extraInfo: osAccount.RequestResult) => {
                console.log('delCred result = ' + result);
                console.log('delCred extraInfo = ' + JSON.stringify(extraInfo));
                if(result == 0) {
                  this.message = 'Successfully deleted credentials';
                } else {
                  this.message = 'Failed to delete credentials: ' + result;
                }
              }
            });
          } catch (e) {
            console.error('delUser exception = ' + JSON.stringify(e));
            this.message = 'Failed to delete credentials: ' + JSON.stringify(e);
          }
          PINAuth.unregisterInputer();
          userIDM.closeSession(this.cid);
        }
      })
    }).catch((err: Error)=>{
      console.error('openSession failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to open session:' + JSON.stringify(err);
    })
  }

  private async deleteCred(): Promise<void> {
    let userIDM = new account_osAccount.UserIdentityManager();
    let userAuth = new account_osAccount.UserAuth();
    let PINAuth = new account_osAccount.PINAuth();
    let password: Uint8Array = new Uint8Array([0x31, 0x31, 0x31, 0x31, 0x31, 0x31]);
    if (this.textPassword != '') {
      password = strToUint8Arr(this.textPassword);
    }
    PINAuth.unregisterInputer();
    PINAuth.registerInputer({
      onGetData:(authSubType, callback)=>{
        callback.onSetData(account_osAccount.AuthSubType.PIN_SIX, password);
      }
    })
    userIDM.closeSession(this.cid)
    userIDM.openSession(this.cid).then((data)=>{
      console.log('openSession info: ' + JSON.stringify(data));
      userAuth.authUser(this.cid, data, account_osAccount.AuthType.PIN,
        account_osAccount.AuthTrustLevel.ATL1, {
        onResult:(err, authResult)=>{
          console.log('authUser err: ' + JSON.stringify(err));
          console.log('authUser info: ' + JSON.stringify(authResult));
          console.log('authUser info.userId: ' + authResult.accountId);
          console.log('authUser info.token: ' + authResult.token);
          try {
            userIDM.delUser(authResult.token, {
              onResult: (result: number, extraInfo: osAccount.RequestResult) => {
                console.log('delUser result = ' + result);
                console.log('delUser extraInfo = ' + JSON.stringify(extraInfo));
                if(result == 0) {
                  this.message = 'Successfully deleted PIN code credentials';
                } else {
                  this.message = 'Failed to delete PIN code credentials: ' + JSON.stringify(result);
                }

                PINAuth.unregisterInputer();
                userIDM.closeSession(this.cid);
              }
            });
          } catch (e) {
            console.error('delUser exception = ' + JSON.stringify(e));
          }
        }
      })
    }).catch((err: Error)=>{
      console.error('openSession failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to open session:' + JSON.stringify(err);
    })
  }

  build() {
    Column() {
      TextInput({ text: this.textPassword, placeholder: 'input password...'})
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .caretColor(Color.Blue)
        .width(200)
        .height(40)
        .margin(10)
        .fontSize(14)
        .fontColor(Color.Black)
        .onChange((value: string) => {
          this.textPassword = value;
        })
      TextInput({ text: this.oldTextPassword, placeholder: 'old password...'})
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .caretColor(Color.Blue)
        .width(200)
        .height(40)
        .margin(10)
        .fontSize(14)
        .fontColor(Color.Black)
        .onChange((value: string) => {
          this.oldTextPassword = value;
        })
      Text(this.message)
        .id('show')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.ManageSystemAccountCredentials1'))
        .margin(10)
        .id('button1')
        .onClick(() => this.addCred())
      Button($r('app.string.ManageSystemAccountCredentials2'))
        .margin(10)
        .id('button2')
        .onClick(() => this.auth())
      Button($r('app.string.ManageSystemAccountCredentials3'))
        .margin(10)
        .id('button3')
        .onClick(() => this.addBiologyCred())
      Button($r('app.string.ManageSystemAccountCredentials4'))
        .margin(10)
        .id('button4')
        .onClick(() => this.biologyAuth())
      Button($r('app.string.ManageSystemAccountCredentials5'))
        .margin(10)
        .id('button5')
        .onClick(() => this.updateCred())
      Button($r('app.string.ManageSystemAccountCredentials6'))
        .margin(10)
        .id('button6')
        .onClick(() => this.getCred())
      Button($r('app.string.ManageSystemAccountCredentials7'))
        .margin(10)
        .id('button8')
        .onClick(() => this.deleteBiologyCred())
      Button($r('app.string.ManageSystemAccountCredentials8'))
        .margin(10)
        .id('button7')
        .onClick(() => this.deleteCred())
    }
    .height('100%')
    .width('100%')
  }
}