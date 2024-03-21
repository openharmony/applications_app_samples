/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { userAuth } from '@kit.UserAuthenticationKit';
import { logger } from '../common/Logger';
import { addAssetPromise, removeAssetPromise, queryAssetPromise, queryAuthAssetPromise, preQueryAssetPromise, log,
  postQueryAssetPromise } from '../model/AssetModel';

interface AssetItem {
  alias: string;
  secret: string;
  dataLabel: string;
}

function isReserveClickable(reserveAccount: string, reservePassword: string, reserveLabel: string): boolean {
  return reserveAccount !== '' && reservePassword !== '' && reserveLabel != '';
}

async function getAuthTokenCallback(challenge: Uint8Array,
  callback: (isSuccess: boolean, challenge: Uint8Array) => void) {
  const authParam: userAuth.AuthParam = {
    challenge: challenge,
    authType: [userAuth.UserAuthType.PIN,userAuth.UserAuthType.FACE,userAuth.UserAuthType.FINGERPRINT],
    authTrustLevel: userAuth.AuthTrustLevel.ATL1,
  };
  const widgetParam: userAuth.WidgetParam = {
    title: '请输入锁屏密码',
  };
  try {
    let userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
    userAuthInstance.on('result', {
      onResult(result) {
        logger.info('userAuthInstance callback result = ' + JSON.stringify(result));
        if (result.result == 12500000) {
          logger.info('userAuthInstance callback result success');
          callback(true, result.token)
        } else if (result.result == 12500010) {
          promptAction.showToast({ message: $r('app.string.please_set_pwd') })
          callback(false, new Uint8Array(0))
        }
      }
    });
    userAuthInstance.start();
  } catch (error) {
    logger.info('auth catch error: ' + JSON.stringify(error));
    promptAction.showToast({ message: $r('app.string.auth_failed') })
    callback(false, new Uint8Array(0))
  }
}

function convertMapArrayToMapItem(array: Array<Map<string, string>>): Array<AssetItem>
{
  let res = new Array<AssetItem>();
  for (let dataElement of array) {
    let tmp: AssetItem = {
      alias: dataElement.get('alias') as string,
      secret: dataElement.get('secret') as string,
      dataLabel: dataElement.get('label') as string,
    };
    res.push(tmp)
  }
  return res;
}

@Entry
@Component
struct Page {
  private challenge: Uint8Array = new Uint8Array;
  private authToken: Uint8Array = new Uint8Array;
  @State reserveAccount: string = '';
  @State reservePassword: string = '';
  @State reserveLabel: string = '';
  @State deleteAccount: string = '';
  @State deleteLabel: string = '';
  @State checkAccount: string = '';
  @State checkLabel: string = '';
  @State eventType: string = ''
  @State index: number = 0
  @State assetArr: string[] = new Array<string>();
  private tabsController: TabsController = new TabsController();
  @State view: Visibility[] = [Visibility.Hidden, Visibility.Visible, Visibility.None];
  @State indexView: number = 0

  @Builder TabBuilder(index: number, name: string) {
    Column() {
      Row().height(this.index === index ? 8 : 17)
      Text(name)
        .fontColor(0x182413)
        .fontSize(this.index === index ? 30 : 20)
        .fontWeight(this.index === index ? 700 : 500)
        .lineHeight(this.index === index ? 41 : 28)
        .opacity(this.index === index ? 1 : 0.7)
        .fontFamily(this.index === index ? 'HarmonyHeiTi-Bold' : 'HarmonyHeiTi-Medium')
        .margin(this.index == 0 ? {left: 24} : {left: 0})
      Row().height(this.index === index ? 7 : 11)
    }
    .width('100%')
  }

  build() {
    Tabs({
      index: 0,
      controller: this.tabsController }) {
      /*      保存页面      */
      TabContent() {
        Column() {
          Column() {
            /* 账号 */
            Row() {
              Text("*").fontColor(0xFFE84026)
              Text($r('app.string.account'))
                .fontFamily("HarmonyHeiTi")
                .fontSize(16)
                .fontColor(0x182431)
                .lineHeight(22)
                .fontWeight(500)
                .margin({ top: "2.3%", bottom: "1.1%" })
            }
            .width('86.7%').height('7.14%')
            .margin({ top: 4 })

            /* 账号输入 */
            Row() {
              TextInput({ placeholder: $r('app.string.please_input_account') })
                .fontColor(0x182431)
                .defaultFocus(false)
                .id('account_input')
                .padding({ top: '1.70%', right: '48.00px', bottom: '1.70%', left: '0.00px' })
                .backgroundColor(Color.Transparent)
                .borderRadius(0)
                .placeholderFont({ size: 16, weight: 400, family: 'HarmonyHeiTi', style: FontStyle.Normal })
                .onChange((value: string) => {
                  this.reserveAccount = value;
                })
                .onEditChange((isEditing: boolean) => {
                  if (isEditing === true) {
                    this.eventType = 'Down1';
                  }
                })
            }
            .width('86.7%').height('7.14%')

            if (this.eventType === 'Down1') {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: 12,
                  right: 12
                })
                .backgroundColor(0x182431)
            } else {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor('#0D182431')
            }

            /* 密码 */
            Row() {
              Text("*").fontColor(0xFFE84026)
              Text($r('app.string.secret_or_card_num'))
                .fontFamily("HarmonyHeiTi")
                .fontSize(16)
                .fontColor(0x182431)
                .fontWeight(500)
                .margin({ top: "2.3%", bottom: "1.1%" })
            }
            .width('86.7%').height('7.14%')

            /* 密码输入 */
            Row() {
              TextInput({ placeholder: $r('app.string.please_input_secret_or_card_num') })
                .type(InputType.Password)
                .defaultFocus(false)
                .id('secret_input')
                .fontColor(0x182431)
                .padding({ top: '1.70%', right: '0', bottom: '1.70%', left: '0.00px' })
                .backgroundColor(Color.Transparent)
                .placeholderFont({ size: 16, weight: 400, family: 'HarmonyHeiTi', style: FontStyle.Normal })
                .onChange((value: string) => {
                  this.reservePassword = value;
                })
                .onTouch((event: TouchEvent) => {
                  if (event.type === TouchType.Down) {
                    this.eventType = 'Down2';
                  }
                })
                .margin({ top: '0.00vp', right: '-12vp', bottom: '4.00vp', left: '0.00vp' })
            }
            .width('86.7%').height('7.14%')
            if (this.eventType === 'Down2') {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor(0x182431)
            } else {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor('#0D182431')
            }

            /* 标签 */
            Row() {
              Text("*").fontColor(0xFFE84026)
              Text($r('app.string.label'))
                .fontFamily("HarmonyHeiTi")
                .fontSize(16)
                .fontColor(0x182431)
                .fontWeight(500)
                .id('label')
                .margin({ top: "2.3%", bottom: "1.1%" })
            }
            .width('86.7%').height('7.14%')

            /* 标签输入 */
            Row() {
              TextInput({ placeholder: $r('app.string.please_input_label') })
                .fontColor(0x182431)
                .defaultFocus(false)
                .id('label_input')
                .padding({ top: '1.70%', right: '48.00px', bottom: '1.70%', left: '0.00px' })
                .backgroundColor(Color.Transparent)
                .placeholderFont({ size: 16, weight: 400, family: 'HarmonyHeiTi', style: FontStyle.Normal })
                .onChange((value: string) => {
                  this.reserveLabel = value;
                })
                .onTouch((event: TouchEvent) => {
                  if (event.type === TouchType.Down) {
                    this.eventType = 'Down3';
                  }
                })
            }
            .width('86.7%').height('7.14%')
            if (this.eventType === 'Down3') {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor(0x182431).margin({ bottom: 4})
            } else {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor('#0D182431').margin({ bottom: 4})
            }
          }
          .backgroundColor(0xFFFFFF).borderRadius(16)

          Blank()

          Row() {
            /* 底部按钮 */
            Button($r('app.string.save'), { type: ButtonType.Capsule, stateEffect: false })
              .backgroundColor(0x007DFF).fontColor('white')
              .borderRadius(20)
              .width('86.7%')
              .height(40)
              .id('save')
              .enabled(isReserveClickable(this.reserveAccount, this.reservePassword, this.reserveLabel))
              .onClick(() => {
                addAssetPromise(this.reserveAccount, this.reservePassword, this.reserveLabel)
              })
          }
          .margin({ bottom: '8.1%' })
        }
        .height('100%')
      }
      .tabBar(this.TabBuilder(0, "保存"))

      /*      删除页面      */
      TabContent() {
        Column() {
          Column() {
            /* 账号 */
            Row() {
              Text($r('app.string.account'))
                .fontFamily("HarmonyHeiTi")
                .fontSize(16)
                .fontColor(0x182431)
                .lineHeight(22)
                .fontWeight(500)
                .margin({ top: '2.3%', bottom: '1.1%' })
            }
            .width('86.7%').height('7.14%')
            .margin({ top: 4 })

            /* 用户名输入 */
            Row() {
              TextInput({ placeholder: $r('app.string.please_input_account') })
                .fontColor(0x182431)
                .defaultFocus(false)
                .padding({ top: '1.70%', right: '48.00px', bottom: '1.70%', left: '0' })
                .backgroundColor(Color.Transparent)
                .placeholderFont({ size: 16, weight: 400, family: 'HarmonyHeiTi', style: FontStyle.Normal })
                .onChange((value: string) => {
                  this.deleteAccount = value;
                })
                .onTouch((event: TouchEvent) => {
                  if (event.type === TouchType.Down) {
                    this.eventType = 'Down4';
                  }
                })
            }
            .width('86.7%').height('7.14%')

            if (this.eventType === 'Down4') {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor(0x182431)
            } else {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor('#0D182431')
            }

            /* 标签 */
            Row() {
              Text($r('app.string.label'))
                .fontFamily("HarmonyHeiTi")
                .fontSize(16)
                .fontColor(0x182431)
                .fontWeight(500)
                .margin({ top: '2.3%', bottom: '1.1%' })
            }
            .width('86.7%').height('7.14%')

            /* 标签输入 */
            Row() {
              TextInput({ placeholder: $r('app.string.please_input_label') })
                .fontColor(0x182431)
                .defaultFocus(false)
                .padding({ top: '1.70%', right: '48.00px', bottom: '1.70%', left: '0' })
                .backgroundColor(Color.Transparent)
                .placeholderFont({ size: 16, weight: 400, family: 'HarmonyHeiTi', style: FontStyle.Normal })
                .onChange((value: string) => {
                  this.deleteLabel = value;
                })
                .onTouch((event: TouchEvent) => {
                  if (event.type === TouchType.Down) {
                    this.eventType = 'Down5';
                  }
                })
            }
            .width('86.7%').height('7.14%')

            if (this.eventType === 'Down5') {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor(0x182431).margin({ bottom: 4})
            } else {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor('#0D182431').margin({ bottom: 4})
            }
          }
          .backgroundColor(0xFFFFFF).borderRadius(16)

          Blank()
          Row() {
            /* 底部按钮 */
            Button($r('app.string.delete'), { type: ButtonType.Capsule, stateEffect: false })
              .backgroundColor(0x007DFF).fontColor('white')
              .borderRadius(20)
              .width('86.7%')
              .height(40)
              .onClick(() => {
                removeAssetPromise(this.deleteAccount, this.deleteLabel)
              })
          }
          .margin({ bottom: '8.1%' })
        }
        .height('100%')
      }
      .tabBar(this.TabBuilder(1, "删除"))

      /*  更新页面  */
      TabContent() {
        Column() {
          Column() {
            List({ space: 0, initialIndex: 0 }) { // 查询列表
              ForEach(this.assetArr, (item: string) => {
                ListItem() {
                  Column() {
                    /* 账号 */
                    Row() {
                      Row() {
                        Text(item)
                          .fontFamily("HarmonyHeiTi")
                          .fontSize(16)
                          .fontColor(0x182431)
                          .lineHeight(22)
                          .fontWeight(500)
                          .textAlign(TextAlign.Start)
                          .margin({ top: '2.3%', bottom: '1.1%' })
                      }

                      Blank()
                      Row() {
                        Image($r('app.media.forward'))
                          .height(18)
                          .width(9)
                          .fillColor('#182431')
                      }
                    }
                    .width('100%').height('7.14%')
                    .onClick(async () => {
                      let account = await queryAuthAssetPromise(item, this.challenge, this.authToken);
                      router.pushUrl({
                        url: 'pages/UpdatePage',
                        params: { name: item, pwd: account.get('secret'), label: account.get("label") }
                      }, router.RouterMode.Standard, (err) => {
                        if (err) {
                          logger.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                          return;
                        }
                      });
                    });
                  }
                  .margin({ right: 12, left: 12 })
                }
              }, (item: string) => item)
            }
            .listDirection(Axis.Vertical) // 排列方向
            .divider({ strokeWidth: 1, color: '#0D182431', startMargin: 12, endMargin: 12 }) // 每行之间的分界线
            .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
          }
          .margin({ right: 12, left: 12 })
          .backgroundColor(0xFFFFFF).borderRadius(16)
        }
        .height('100%')
      }
      .tabBar(this.TabBuilder(2, "更新"))

      /* 查询页面 */
      TabContent() {
        Column() {
          Column() {
            /* 账号 */
            Row() {
              Text($r('app.string.account'))
                .fontFamily("HarmonyHeiTi")
                .fontSize(16)
                .fontColor(0x182431)
                .lineHeight(22)
                .fontWeight(500)
                .textAlign(TextAlign.Start)
                .margin({ top: '2.3%', bottom: '1.1%' })
            }
            .width('86.7%').height('7.14%')
            .margin({ top: 4 })

            /* 用户名输入 */
            Row() {
              TextInput({ placeholder: $r('app.string.please_input_account') })
                .fontColor(0x182431)
                .defaultFocus(false)
                .padding({ top: '1.70%', right: '48.00px', bottom: '1.70%', left: '0' })
                .backgroundColor(Color.Transparent)
                .placeholderFont({ size: 16, weight: 400, family: 'HarmonyHeiTi', style: FontStyle.Normal })
                .onChange((value: string) => {
                  this.checkAccount = value;
                })
                .onTouch((event: TouchEvent) => {
                  if (event.type === TouchType.Down) {
                    this.eventType = 'Down6';
                  }
                })
            }
            .width('86.7%').height('7.14%')

            if (this.eventType === 'Down6') {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor(0x182431)
            } else {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor('#0D182431')
            }

            /* 标签 */
            Row() {
              Text($r('app.string.label'))
                .fontFamily("HarmonyHeiTi")
                .fontSize(16)
                .fontColor(0x182431)
                .lineHeight(22)
                .fontWeight(500)
                .textAlign(TextAlign.Start)
                .margin({ top: '2.3%', bottom: '1.1%' })
            }
            .width('86.7%').height('7.14%')

            /* 标签输入 */
            Row() {
              TextInput({ placeholder: $r('app.string.please_input_label') })
                .fontColor(0x182431)
                .defaultFocus(false)
                .padding({ top: '1.70%', right: '48.00px', bottom: '1.70%', left: '0' })
                .backgroundColor(Color.Transparent)
                .placeholderFont({ size: 16, weight: 400, family: 'HarmonyHeiTi', style: FontStyle.Normal })
                .onChange((value: string) => {
                  this.checkLabel = value;
                })
                .onTouch((event: TouchEvent) => {
                  if (event.type === TouchType.Down) {
                    this.eventType = 'Down7';
                  }
                })
            }
            .width('86.7%').height('7.14%')

            if (this.eventType === 'Down7') {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor(0x182431).margin({bottom: 4})
            } else {
              Line()
                .width('86.7%')
                .height('0.5vp')
                .margin({
                  left: '12vp',
                  right: '12vp'
                })
                .backgroundColor('#0D182431').margin({bottom: 4})
            }
          }
          .backgroundColor(0xFFFFFF).borderRadius(16)

          Blank()
          Row() {
            /* 底部按钮 */
            Button($r('app.string.search'), { type: ButtonType.Capsule, stateEffect: false })
              .backgroundColor(0x007DFF)
              .borderRadius(20)
              .width('86.7%')
              .height(40)
              .id('search')
              .onClick(async () => {
                // 需要执行的操作
                // 如果查询的时候输入了账号 则表示精确查询 进行二次访问控制
                if (this.checkAccount.length > 0) {
                  let challenge = await preQueryAssetPromise(this.checkAccount);
                  if (challenge.length == 0) {
                      log($r('app.string.query_failed'))
                      return
                  }
                  this.challenge = challenge
                  getAuthTokenCallback(this.challenge, async (isSuccess: boolean, authToken: Uint8Array) => {
                    if (isSuccess) {
                      logger.info('get auth token success!')
                      this.authToken = authToken

                      let account = await queryAuthAssetPromise(this.checkAccount, this.challenge, this.authToken);
                      postQueryAssetPromise(this.challenge)
                      this.challenge = new Uint8Array;
                      this.authToken = new Uint8Array;
                      router.pushUrl({
                        url: 'pages/QueryResultPage',
                        params: {
                          data_array_map: convertMapArrayToMapItem(new Array<Map<string, string>>(account))
                        }
                      }, router.RouterMode.Standard, (err) => {
                        if (err) {
                          logger.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                          return;
                        }
                      });
                    }
                  });
                }
                else {
                  let accountList = queryAssetPromise(this.checkAccount, this.checkLabel);
                  accountList.then(data => {
                    router.pushUrl({
                      url: 'pages/QueryResultPage', // 目标url
                      params: {
                        data_array_map: convertMapArrayToMapItem(data)
                      }
                    }, router.RouterMode.Standard, (err) => {
                      if (err) {
                        logger.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                        return;
                      }
                      logger.info('Invoke pushUrl succeeded.');
                    });
                  })
                }
              })
          }
          .margin({ bottom: '8.1%' })
        }
        .height('100%')

      }
      .tabBar(this.TabBuilder(3, "查询"))
    }
    .scrollable(true)
    .backgroundColor(0xf1f3f5)
    .barMode(BarMode.Fixed)
    .barHeight(56)
    .onChange(async (index: number) => {
      if (index == 2 && this.index != 2) {
        let challenge = await preQueryAssetPromise("");
        logger.info('get challenge success!')
        this.challenge = challenge
        // get auth token
        getAuthTokenCallback(this.challenge, async (isSuccess: boolean, authToken: Uint8Array) => {
          if (isSuccess) {
            logger.info('get auth token success!')
            this.authToken = authToken
            let resultList = await queryAssetPromise('', '');
            for (let accountListElement of resultList) {
              let str = accountListElement.get('alias');
              if (str !== undefined) {
                this.assetArr.push(str)
              }
            }
          }
        });
      } else if (this.challenge.length > 0) {
        postQueryAssetPromise(this.challenge)
        this.challenge = new Uint8Array;
        this.authToken = new Uint8Array;
        this.assetArr = new Array<string>();
      }
      this.index = index;
    })
  }
}
