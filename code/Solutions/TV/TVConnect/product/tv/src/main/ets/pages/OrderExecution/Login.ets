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
import { promptAction, router } from '@kit.ArkUI';
import http from '@ohos.net.http';
import Net from '../../viewmodel/OrderExecution/netConfig';
import { LoginData, loginData, loginObject } from '../../viewmodel/OrderExecution/logindata';
import { inputEventClient, KeyCode } from '@kit.InputKit';
import {
  registrationMonitoring,
  unRegistrationMonitoring
} from '@ohos/nearbydevice/src/main/ets/pages/DeviceDetailPage';


async function getlogin(loginName: string, loginPassword: string): Promise<Array<LoginData> | null> {
  let httpPostRequest = http.createHttp();

  httpPostRequest.on('headersReceive', (header) => {
    console.info('Get header: ' + JSON.stringify(header));
  });

  return new Promise((resolve, reject) => {
    let url =
      `http://${Net.getInstance().ip}/app-gateway/org-biz/logins?loginName=${loginName}&loginPassword=${loginPassword}`;
    let promise = httpPostRequest.request(url, {
      method: http.RequestMethod.GET,
      connectTimeout: 3000,
      readTimeout: 3000,
      header: {
        'Content-Type': 'application/json'
      }
    });

    promise.then((data) => {
      try {
        let resultObject: loginObject = JSON.parse(data.result as string) as loginObject;

        if (resultObject && Array.isArray(resultObject.data.dataDeptInfoList)) {
          let logins: LoginData[] =
            resultObject.data.dataDeptInfoList.map((item: loginData) => LoginData.fromJSON(item));
          Net.getInstance().setOrgId(logins[0].orgId);
          Net.getInstance().setDeptId(logins[0].deptId);
          resolve(logins);
        } else {
          resolve(null);
        }
      } catch (err) {
        console.error('JSON parse error: ' + err);
        reject(err);
      }
    }).catch((err: Error) => {
      console.error('Request error: ' + JSON.stringify(err));
      reject(err);
    });
  });
}


@Entry
@Component
export default struct Login {
  @State userName: string = '';
  @State Password: string = '';
  @State ip: string = '';
  controller: TextInputController = new TextInputController();

  aboutToAppear(): void {
  }

  aboutToDisappear(): void {
    unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
  }

  build() {
    Column() {
      Image($r('app.media.logo_oh')).width(140).margin({ top: 60 });
      Column() {
        Column() {
          Image($r('app.media.login_ewm')).width(24).position({ x: '89%', y: 14 });
        }
        .focusable(true)
        .defaultFocus(true);

        Line()
          .width(200)
          .height(150)
          .startPoint([260, 0])
          .endPoint([358, 86])
          .stroke($r('app.color.nurse_blue'))
          .position({ x: 0 });
        Column() {
          Image($r('app.media.login_face')).width(48).margin({ top: 60 });
        }
        .focusable(true);

        Text('点击进入人脸识别').fontSize(8).fontColor(Color.Gray).margin({ top: 10, bottom: 15 });
        Text('肝胆外科一病区').fontSize(20).fontColor($r('app.color.nurse_blue')).margin({ top: 10 });
        Text('设备编号：001').fontSize(14).fontColor($r('app.color.nurse_blue')).margin({ top: 5, bottom: 30 });
        //账号
        Row() {
          Row() {
            Image($r('app.media.nurse_icon_user')).width(20).margin({ left: 5 });
          }
          .backgroundColor($r('app.color.nurse_blue'))
          .padding(10)
          .position({ x: 0 })
          .borderRadius({
            bottomLeft: 22,
            bottomRight: 0,
            topRight: 0,
            topLeft: 22
          });

          TextInput({ text: 'hdc', placeholder: '工号', controller: this.controller })
            .key('gonghao')
            .placeholderColor(Color.Gray)
            .placeholderFont({ size: 16, weight: 400 })
            .caretColor(Color.Blue)
            .width(240)
            .height(40)
            .padding({
              left: 50,
              top: 5,
              bottom: 5,
              right: 5
            })
            .margin({ bottom: 25 })
            .fontSize(10)
            .fontColor(Color.Black)
            .border({
              width: 0.5,
              color: $r('app.color.nurse_blue'),
              style: {
                bottom: BorderStyle.Solid,
              }
            })
            .inputFilter('[a-z]', (e) => {
              console.log(JSON.stringify(e));
            })
            .onChange((value: string) => {
              this.userName = value;
            })
            .onKeyEvent((event) => {
              if (event.type == KeyType.Down) {
                if (event.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('passWard');
                }
              }
            });
        }
        .focusable(true)
        .defaultFocus(true)
        .groupDefaultFocus(true)
        .onFocus(() => {
          registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
            focusControl.requestFocus('gonghao');
          });
        });

        //密码
        Row() {
          Row() {
            Image($r('app.media.nurse_icon_pwd')).width(20).margin({ left: 5 });
          }
          .backgroundColor($r('app.color.nurse_blue'))
          .padding(10)
          .position({ x: 0 })
          .borderRadius({
            bottomLeft: 20,
            bottomRight: 0,
            topRight: 0,
            topLeft: 20
          });

          TextInput({ text: '123456', placeholder: '密码' })
            .key('passWard')
            .placeholderColor(Color.Gray)
            .placeholderFont({ size: 16, weight: 400 })
            .width(240)
            .height(40)
            .padding({
              left: 50,
              top: 5,
              bottom: 5,
              right: 5
            })
            .fontSize(10)
            .margin({ bottom: 25 })
            .fontColor(Color.Black)
            .type(InputType.Password)
            .maxLength(9)
            .showPasswordIcon(true)
            .border({
              width: 0.5,
              color: $r('app.color.nurse_blue'),
              style: {
                bottom: BorderStyle.Solid,
              }
            })
            .onChange((value: string) => {
              this.Password = value;
            })
            .onKeyEvent((event) => {
              if (event.type == KeyType.Down) {
                if (event.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('fuwuqi');
                } else if (event.keyCode == KeyCode.KEYCODE_DPAD_UP) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('gonghao');
                } else if (event.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
                  tabClick();
                }
              }
            });
        }
        .focusable(true)
        .groupDefaultFocus(true)
        .onFocus(() => {
          registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
            focusControl.requestFocus('passWard');
          });
        });

        //ip
        Row() {
          Row() {
            Image($r('app.media.nurse_icon_user')).width(20).margin({ left: 5 });
          }
          .backgroundColor($r('app.color.nurse_blue'))
          .padding(10)
          .position({ x: 0 })
          .borderRadius({
            bottomLeft: 20,
            bottomRight: 0,
            topRight: 0,
            topLeft: 20
          });

          TextInput({ text: this.ip, placeholder: '服务器' })
            .key('fuwuqi')
            .placeholderColor(Color.Gray)
            .placeholderFont({ size: 16, weight: 400 })
            .caretColor(Color.Blue)
            .width(240)
            .height(40)
            .padding({
              left: 50,
              top: 5,
              bottom: 5,
              right: 5
            })
            .fontSize(10)
            .fontColor(Color.Black)
            .border({
              width: 0.5,
              color: $r('app.color.nurse_blue'),
              style: {
                bottom: BorderStyle.Solid,
              }
            })
            .onChange((value: string) => {
              this.ip = value;
            })
            .onKeyEvent((event) => {
              if (event.type == KeyType.Down) {
                if (event.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('login');
                } else if (event.keyCode == KeyCode.KEYCODE_DPAD_UP) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('passWard');
                }
              }
            });
        }
        .focusable(true)
        .groupDefaultFocus(true)
        .onFocus(() => {
          registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
            focusControl.requestFocus('fuwuqi');
          });
        });

        Text('登录')
          .key('login')
          .focusable(true)
          .fontSize(16)
          .fontColor(Color.White)
          .height(32)
          .borderRadius(20)
          .padding({ left: 30, right: 30 })
          .margin({ top: 30 })
          .linearGradient({
            angle: 50,
            direction: GradientDirection.Bottom,
            colors: [[0x1d4bef, 0.1], [0x58b4ff, 0.7]]
          })
          .onKeyEvent(async (event) => {
            if (event.type == KeyType.Down && event.keyCode == KeyCode.KEYCODE_ENTER) {
              try {
                Net.getInstance().setIp(this.ip);
                const logins = await getlogin(this.userName, this.Password);
                if (logins) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  // 登录成功后执行路由跳转
                  router.pushUrl({
                    url: 'pages/OrderExecution/PatientList'
                  });
                }
              } catch (error) {
                promptAction.showToast({
                  message: $r('app.string.loginError'),
                  duration: 2000,
                });
                console.error('Error during login and redirect:', error);
              }
            }
          });

      }
      .margin({ top: 40 })
      .width('88%')
      .height('74%')
      .backgroundColor(Color.White)
      .borderRadius(10)
      .shadow({
        radius: 20,
        color: $r('app.color.gray999'),
        offsetX: 2,
        offsetY: 2
      })
      .zIndex(2);

      Row() {
        Text('点击开启操作系统的设置')
          .fontSize(12)
          .fontColor($r('app.color.nurse_blue'))
          .lineHeight(20)
          .margin({ top: 10, bottom: 15 })
          .border({
            width: { bottom: 1 },
            color: $r('app.color.nurse_blue'),
          });
      }
      .backgroundColor(Color.White)
      .borderRadius({ bottomLeft: 10, bottomRight: 10 })
      .width('80%')
      .justifyContent(FlexAlign.Center)
      .shadow({
        radius: 20,
        color: $r('app.color.gray999'),
        offsetX: 2,
        offsetY: 2
      })
      .zIndex(1);
    }
    .width('100%')
    .height('103%')
    .backgroundImage($r('app.media.login_bg'))
    .backgroundImageSize({ width: '100%', height: '100%' });
  }
}

export function tabClick() {
  let keyDownOpt: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };
  let keyUpOpt: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };

  try {
    console.log('settingList inputEventClient', 'TAB');
    // 触发tab点击，使默认焦点组件多态样式生效
    inputEventClient.injectEvent({ KeyEvent: keyDownOpt });
    inputEventClient.injectEvent({ KeyEvent: keyUpOpt });
  } catch (err) {
    console.error('settingList inputEventClient' + err);
  }
}