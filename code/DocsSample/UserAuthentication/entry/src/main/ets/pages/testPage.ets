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

/* 此页面仅用于测试，使用了同步语法，但实际不建议使用同步语法，
 * 请在运行测试时将src/main/ets/entryability/EntryAbility.ets中的
 * windowStage.loadContent('pages/Index', ...)
 * 修改为windowStage.loadContent('pages/testPage', ...)
 */

import { BusinessError } from '@kit.BasicServicesKit';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { JSON } from '@kit.ArkTS';
import { promptAction } from '@kit.ArkUI';
import { userAuth } from '@kit.UserAuthenticationKit';
import Logger from '../common/Logger';

// 用于获取资源字符串
function resourceToString(resource: Resource): string {
  let result: string = '';
  try {
    result = getContext().resourceManager.getStringSync(resource);
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`catch error. Code is ${err?.code}, message is ${err?.message}`);
  }
  if (result === '' || result === undefined) {
    return 'undefined';
  } else {
    return result;
  }
}

// 用于异步等待
async function waiting(times: number): Promise<void> {
  // 返回一个 Promise，表示等待 times 毫秒
  return new Promise<void>(resolve => setTimeout(resolve, times));
}

function getRandData(): Uint8Array | null {
  const rand = cryptoFramework.createRandom();
  const len: number = 16;
  let randData: Uint8Array | null = null;
  let retryCount = 0;
  while (retryCount < 3) {
    randData = rand?.generateRandomSync(len)?.data;
    if (randData) {
      break;
    }
    retryCount++;
  }
  return randData;
}

/*
 * obtain-supported-authentication-capabilities.md
 * 以查询设备是否支持认证可信等级≥ATL1的PIN认证功能为例
 */
export function obtainingSupported() {
  try {
    // 查询认证能力是否支持
    userAuth.getAvailableStatus(userAuth.UserAuthType.PIN, userAuth.AuthTrustLevel.ATL1);
    Logger.info('current auth trust level is supported');
    return true;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`current auth trust level is not supported. Code is ${err?.code}, message is ${err?.message}`);
    return false;
  }
}

// 用于处理示例1，示例2，示例3和示例4的部分操作
function handleAuthResult(userAuthInstance: userAuth.UserAuthInstance): Promise<number> {
  return new Promise<number>((resolve, reject) => {
    try {
      // userAuthInstance.on异常抛出层
      userAuthInstance.on('result', {
        onResult(result) {
          try {
            // onResult异常抛出层
            try {
              // JSON.stringify异常抛出层
              Logger.info(`userAuthInstance callback result: ${JSON.stringify(result)}`);
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error(`JSON stringify catch error. Code is ${err?.code}, message is ${err?.message}`);
              reject(err);
            }
            userAuthInstance.off('result'); // 认证完成后取消订阅
            resolve(result.result); // 返回认证结果
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(`onResult catch error. Code: ${err?.code}, Message: ${err?.message}`);
            reject(err);
          }
        }
      });
      // 启动认证
      userAuthInstance.start();
      Logger.info('auth start success');
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`userAuthInstance.on catch error. Code: ${err?.code}, Message: ${err?.message}`);
      reject(err);
    }
  });
}

/*
 * start-authentication.md
 * 示例1：
 * 发起用户认证，采用认证可信等级≥ATL3的人脸 + 锁屏密码 + 指纹认证，获取认证结果
 * */
export async function initiatingUserAuthentication1() {
  try {
    const randData = getRandData();
    if(!randData){
      return;
    }
    // 设置认证参数
    const authParam: userAuth.AuthParam = {
      challenge: randData,
      authType: [userAuth.UserAuthType.PIN, userAuth.UserAuthType.FACE, userAuth.UserAuthType.FINGERPRINT],
      authTrustLevel: userAuth.AuthTrustLevel.ATL3,
    };
    // 配置认证界面
    const widgetParam: userAuth.WidgetParam = {
      title: resourceToString($r('app.string.title')),
    };
    // 获取认证对象
    const userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
    Logger.info('get userAuth instance success');
    // 订阅认证结果
    const result = await handleAuthResult(userAuthInstance);
    return result;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    return err.code;
  }
}

/*
 * start-authentication.md
 * 示例2：
 * 发起用户认证，采用认证可信等级≥ATL3的人脸 + 锁屏密码 + 指纹认证 + 认证类型相关 + 复用设备解锁最大有效时长认证，获取认证结果
 * */
export async function initiatingUserAuthentication2() {
  // 设置认证参数
  let reuseUnlockResult: userAuth.ReuseUnlockResult = {
    reuseMode: userAuth.ReuseMode.AUTH_TYPE_RELEVANT,
    reuseDuration: userAuth.MAX_ALLOWABLE_REUSE_DURATION,
  };
  try {
    const randData = getRandData();
    if(!randData){
      return;
    }
    const authParam: userAuth.AuthParam = {
      challenge: randData,
      authType: [userAuth.UserAuthType.PIN, userAuth.UserAuthType.FACE, userAuth.UserAuthType.FINGERPRINT],
      authTrustLevel: userAuth.AuthTrustLevel.ATL3,
      reuseUnlockResult: reuseUnlockResult,
    };
    // 配置认证界面
    const widgetParam: userAuth.WidgetParam = {
      title: resourceToString($r('app.string.title')),
    };
    // 获取认证对象
    const userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
    Logger.info('get userAuth instance success');
    // 订阅认证结果
    const result = await handleAuthResult(userAuthInstance);
    return result;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    return err.code;
  }
}

/*
 * start-authentication.md
 * 示例3：
 * 发起用户认证，采用认证可信等级≥ATL3的人脸 + 锁屏密码 + 指纹认证 + 任意应用认证类型相关 + 复用任意应用最大有效时长认证，获取认证结果：
 * */
export async function initiatingUserAuthentication3() {
  // 设置认证参数
  let reuseUnlockResult: userAuth.ReuseUnlockResult = {
    reuseMode: userAuth.ReuseMode.CALLER_IRRELEVANT_AUTH_TYPE_RELEVANT,
    reuseDuration: userAuth.MAX_ALLOWABLE_REUSE_DURATION,
  }
  try {
    const randData = getRandData();
    if(!randData){
      return;
    }
    const authParam: userAuth.AuthParam = {
      challenge: randData,
      authType: [userAuth.UserAuthType.PIN, userAuth.UserAuthType.FACE, userAuth.UserAuthType.FINGERPRINT],
      authTrustLevel: userAuth.AuthTrustLevel.ATL3,
      reuseUnlockResult: reuseUnlockResult,
    };
    // 配置认证界面
    const widgetParam: userAuth.WidgetParam = {
      title: resourceToString($r('app.string.title')),
    };
    // 获取认证对象
    const userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
    Logger.info('get userAuth instance success');
    // 订阅认证结果
    const result = await handleAuthResult(userAuthInstance);
    return result;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    return err.code;
  }
}

/*
 * start-authentication.md
 * 示例4：
 * 以模应用方式进行用户身份认证
 * */
export async function initiatingUserAuthentication4() {
  // 设置认证参数
  try {
    const randData = getRandData();
    if(!randData){
      return;
    }
    const authParam: userAuth.AuthParam = {
      challenge: randData,
      authType: [userAuth.UserAuthType.PIN, userAuth.UserAuthType.FACE, userAuth.UserAuthType.FINGERPRINT],
      authTrustLevel: userAuth.AuthTrustLevel.ATL3,
    };
    // 配置认证界面
    const widgetParam: userAuth.WidgetParam = {
      title: resourceToString($r('app.string.title')),
      uiContext: getContext(),
    };
    // 获取认证对象
    const userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
    Logger.info('get userAuth instance success');
    // 订阅认证结果
    const result = await handleAuthResult(userAuthInstance);
    return result;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    return err.code;
  }
}

function handleAuthResultAndCanceling(userAuthInstance: userAuth.UserAuthInstance): Promise<number> {
  return new Promise<number>((resolve, reject) => {
    try {
      // userAuthInstance.on异常抛出层
      userAuthInstance.on('result', {
        onResult(result) {
          try {
            // onResult异常抛出层
            try {
              // JSON.stringify异常抛出层
              Logger.info(`userAuthInstance callback result: ${JSON.stringify(result)}`);
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error(`JSON stringify catch error. Code is ${err?.code}, message is ${err?.message}`);
              reject(err);
            }
            userAuthInstance.off('result'); // 认证完成后取消订阅
            resolve(result.result); // 返回认证结果
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(`onResult catch error. Code: ${err?.code}, Message: ${err?.message}`);
            reject(err);
          }
        }
      });
      // 启动认证
      userAuthInstance.start();
      Logger.info('auth start success');
      // 使用等待函数模拟等待用户认证
      let DELAY_TIME: number = 3000; // 停止3秒
      waiting(DELAY_TIME).then(() => {
        // 延迟后取消认证
        userAuthInstance.cancel();
        Logger.info('auth cancel success');
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`userAuthInstance.on catch error. Code: ${err?.code}, Message: ${err?.message}`);
      reject(err);
    }
  });
}

/*
 * cancel-authentication.md
 * 发起认证可信等级≥ATL3的人脸+锁屏密码认证后，取消认证请求
 * */
export async function cancelingUserAuthentication() {
  try {
    const randData = getRandData();
    if(!randData){
      return;
    }
    // 设置认证参数
    const authParam: userAuth.AuthParam = {
      challenge: randData,
      authType: [userAuth.UserAuthType.PIN, userAuth.UserAuthType.FACE, userAuth.UserAuthType.FINGERPRINT],
      authTrustLevel: userAuth.AuthTrustLevel.ATL3,
    };
    // 配置认证界面
    const widgetParam: userAuth.WidgetParam = {
      title: resourceToString($r('app.string.title')),
    };
    // 获取认证对象
    const userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
    Logger.info('get userAuth instance success');
    // 使用 Promise 来监听认证结果
    const result = await handleAuthResultAndCanceling(userAuthInstance);
    return result;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`auth catch error. Code is ${err?.code as number}, message is ${err?.message}`);
    if (err?.message === 'Authentication cancelled after waiting') {
      err.code = userAuth.UserAuthResultCode.CANCELED;
    }
    return err.code;
  }
}

function handleCustomAuthResult(userAuthInstance: userAuth.UserAuthInstance): Promise<number> {
  return new Promise<number>((resolve, reject) => {
    try {
      // userAuthInstance.on异常抛出层
      userAuthInstance.on('result', {
        onResult(result) {
          try {
            // onResult异常抛出层
            try {
              // JSON.stringify异常抛出层
              Logger.info(`userAuthInstance callback result: ${JSON.stringify(result)}`);
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error(`JSON stringify catch error. Code is ${err?.code}, message is ${err?.message}`);
              reject(err);
            }
            userAuthInstance.off('result'); // 认证完成后取消订阅
            if (result.result == userAuth.UserAuthResultCode.CANCELED_FROM_WIDGET ||
              result.result == userAuth.UserAuthResultCode.NOT_ENROLLED) {
              // 请开发者自行完成拉起自定义认证界面的实现
              // 此处拉起类似于支付宝输入密码支付的界面
              promptAction.showToast({
                message: resourceToString($r('app.string.dialogOfCustom')), // 显示文本
                duration: 3000, // 显示时长
                bottom: 300     // 距离底部的距离
              });
            }
            resolve(result.result); // 返回认证结果
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(`onResult catch error. Code: ${err?.code}, Message: ${err?.message}`);
            reject(err);
          }
        }
      });
      // 启动认证
      userAuthInstance.start();
      Logger.info('auth start success');
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`userAuthInstance.on catch error. Code: ${err?.code}, Message: ${err?.message}`);
      reject(err);
    }
  });
}

/*
 * apply-custom-authentication.md
 * 当前示例仅展示如何配置界面、选择切换到自定义认证界面，具体拉起的页面及对应页面的实现，请开发者自行实现
 * */
async function applyingCustomAuthentication() {
  try {
    const randData = getRandData();
    if(!randData){
      return;
    }
    const authParam: userAuth.AuthParam = {
      challenge: randData,
      authType: [userAuth.UserAuthType.FACE],
      authTrustLevel: userAuth.AuthTrustLevel.ATL3,
    }; // 配置认证界面需设置navigationButtonText
    const widgetParam: userAuth.WidgetParam = {
      title: resourceToString($r('app.string.title')),
      navigationButtonText: resourceToString($r('app.string.navigationButtonText')),
      // 该参数仅在单指纹、单人脸场景下支持，该密码并非系统密码，而是应用自己设置的密码
    };
    // 获取认证对象
    const userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
    Logger.info('get userAuth instance success');
    // 订阅认证结果
    const result = await handleCustomAuthResult(userAuthInstance);
    return result;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    return err.code;
  }
}

/*
 * obtain-enrolled-state-capabilities.md
 * 以查询用户人脸注册凭据的状态为例
 * */
function obtainingEnrolledCredentialInformation() {
  try {
    let enrolledState = userAuth.getEnrolledState(userAuth.UserAuthType.PIN);
    Logger.info(`get current enrolled state success, enrolledState: ${JSON.stringify(enrolledState)}`);
    return enrolledState.credentialDigest;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`get current enrolled state failed, Code is ${err?.code}, message is ${err?.message}`);
    return false;
  }
}

async function comprehensiveFeatures() {
  let reuseUnlockResult: userAuth.ReuseUnlockResult = {
    reuseMode: userAuth.ReuseMode.AUTH_TYPE_RELEVANT,
    reuseDuration: userAuth.MAX_ALLOWABLE_REUSE_DURATION,
  };
  try {
    const randData = getRandData();
    if(!randData){
      return;
    }
    const authParam: userAuth.AuthParam = {
      challenge: randData,
      authType: [userAuth.UserAuthType.FACE],
      authTrustLevel: userAuth.AuthTrustLevel.ATL3,
      reuseUnlockResult: reuseUnlockResult
    }; // 配置认证界面需设置navigationButtonText
    const widgetParam: userAuth.WidgetParam = {
      title: resourceToString($r('app.string.title')),
      navigationButtonText: resourceToString($r('app.string.navigationButtonText')),
      // 该参数仅在单指纹、单人脸场景下支持，该密码并非系统密码，而是应用自己设置的密码
    };
    // 获取认证对象
    const userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
    Logger.info('get userAuth instance success');
    // 订阅认证结果
    const result = await handleCustomAuthResult(userAuthInstance);
    return result;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    return err.code;
  }
}

enum PageIndex {
  QUERY_CAPABILITY = 0, // 能力查询页面的索引值
  EXAMPLE_TAB_1 = 1, // 实例1页面的索引值
  EXAMPLE_TAB_2 = 2, // 实例2页面的索引值
  EXAMPLE_TAB_3 = 3, // 实例3页面的索引值
  EXAMPLE_TAB_4 = 4, // 实例4页面的索引值
  CREDENTIAL_QUERIES = 5, // 能力查询页面的索引值
  SIMULATION_VALIDATION = 6 // 模拟认证页面的索引值
}

enum TextIdIndex {
  WHETHER_SUPPORTED = 0, // 能力查询结果的索引值
  EXAMPLE_1 = 1, // 实例1结果的索引值
  EXAMPLE_2 = 2, // 实例2结果的索引值
  EXAMPLE_3 = 3, // 实例3结果的索引值
  EXAMPLE_4 = 4, // 实例4结果的索引值
  CANCEL = 5, // 实例5结果的索引值
  CUSTOMIZE = 6, // 实例6结果的索引值
  QUERY_CREDENTIALS = 7 // 能力查询结果的索引值
};

@Entry
@Component
struct Index {
  @State currentIndex: number = 0; // 最开始索引页面为第一页
  @State test: string[] = new Array(8).fill('wait'); // 一共9个后续测试需要判断的值所以设置数组大小为9
  @State credentialDigest: string = '';
  @State whetherSupport: Resource = $r('app.string.waitQuery');
  @State credentialValue: string = '';
  SPACE_GAP: number = 5;

  @Builder
  tabBuilder(title: Resource, targetIndex: number, tabId: string) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? $r('app.color.tab_selected_color') :
        $r('app.color.tab_not_selected_color'))
        .fontSize($r('app.float.size_13'))
    }
    .width('100%')
    .height($r('app.float.size_50'))
    .justifyContent(FlexAlign.Center)
    .id(tabId)
  }

  build() {
    Column() {
      Tabs() {
        TabContent() {
          Column() {
            Text($r('app.string.whetherSupported'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.query'))
              .onClick(() => {
                if (obtainingSupported()) {
                  this.test[TextIdIndex.WHETHER_SUPPORTED] = 'Pass';
                } else {
                  this.test[TextIdIndex.WHETHER_SUPPORTED] = 'Error';
                }
              })
            Text(this.test[TextIdIndex.WHETHER_SUPPORTED])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
              .id('text' + TextIdIndex.WHETHER_SUPPORTED)
          }
        }.tabBar(this.tabBuilder($r('app.string.queryCapability'), PageIndex.QUERY_CAPABILITY, 'queryCapability'))

        TabContent() {
          Column() {
            Text($r('app.string.descriptionContent1'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example1'))
              .onClick(async () => {
                let msg = initiatingUserAuthentication1();
                if (await msg === userAuth.UserAuthResultCode.SUCCESS) {
                  this.test[TextIdIndex.EXAMPLE_1] = 'Pass';
                } else {
                  this.test[TextIdIndex.EXAMPLE_1] = 'Error';
                }
              })
              .id('button1')
            Text(this.test[TextIdIndex.EXAMPLE_1])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
              .id('text' + TextIdIndex.EXAMPLE_1)
            Blank()
              .height('5%')
            Text($r('app.string.descriptionContent2'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example2'))
              .onClick(async () => {
                let msg = await initiatingUserAuthentication2();
                if (msg === userAuth.UserAuthResultCode.SUCCESS) {
                  this.test[TextIdIndex.EXAMPLE_2] = 'Pass';
                } else {
                  this.test[TextIdIndex.EXAMPLE_2] = 'Error';
                }
              })
              .id('button2')
            Text(this.test[TextIdIndex.EXAMPLE_2])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
              .id('text' + TextIdIndex.EXAMPLE_2)
          }
        }.tabBar(this.tabBuilder($r('app.string.exampleTab1'), PageIndex.EXAMPLE_TAB_1, 'exampleTab1'))

        TabContent() {
          Column() {
            Text($r('app.string.descriptionContent3'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example3'))
              .onClick(async () => {
                let msg = initiatingUserAuthentication3();
                if (await msg === userAuth.UserAuthResultCode.SUCCESS) {
                  this.test[TextIdIndex.EXAMPLE_3] = 'Pass';
                } else {
                  this.test[TextIdIndex.EXAMPLE_3] = 'Error';
                }
              })
              .id('button3')
            Text(this.test[TextIdIndex.EXAMPLE_3])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
              .id('text' + TextIdIndex.EXAMPLE_3)
            Blank()
              .height('5%')
            Text($r('app.string.descriptionContent4'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example4'))
              .onClick(async () => {
                let msg = await initiatingUserAuthentication4();
                if (msg === userAuth.UserAuthResultCode.SUCCESS) {
                  this.test[TextIdIndex.EXAMPLE_4] = 'Pass';
                } else {
                  this.test[TextIdIndex.EXAMPLE_4] = 'Error';
                }
              })
              .id('button4')
            Text(this.test[TextIdIndex.EXAMPLE_4])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
              .id('text' + TextIdIndex.EXAMPLE_4)
          }
        }.tabBar(this.tabBuilder($r('app.string.exampleTab2'), PageIndex.EXAMPLE_TAB_2, 'exampleTab2'))

        TabContent() {
          Column() {
            Text($r('app.string.descriptionContent5'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example5'))
              .onClick(async () => {
                let msg = cancelingUserAuthentication();
                if (await msg === userAuth.UserAuthResultCode.CANCELED) {
                  this.test[TextIdIndex.CANCEL] = 'Pass';
                } else {
                  this.test[TextIdIndex.CANCEL] = 'Error';
                }
              })
            Text(this.test[TextIdIndex.CANCEL])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
              .id('text' + TextIdIndex.CANCEL)
          }
        }.tabBar(this.tabBuilder($r('app.string.exampleTab3'), PageIndex.EXAMPLE_TAB_3, 'exampleTab3'))

        TabContent() {
          Column() {
            Text($r('app.string.descriptionContent6'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example6'))
              .onClick(async () => {
                let msg = await applyingCustomAuthentication();
                if (msg == userAuth.UserAuthResultCode.CANCELED_FROM_WIDGET ||
                  msg == userAuth.UserAuthResultCode.NOT_ENROLLED) {
                  this.test[TextIdIndex.CUSTOMIZE] = 'Pass';
                } else {
                  this.test[TextIdIndex.CUSTOMIZE] = 'Error';
                }
              })
            Text(this.test[TextIdIndex.CUSTOMIZE])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
              .id('text' + TextIdIndex.CUSTOMIZE)
          }
        }.tabBar(this.tabBuilder($r('app.string.exampleTab4'), PageIndex.EXAMPLE_TAB_4, 'exampleTab4'))

        TabContent() {
          Column() {
            Text($r('app.string.queryCredentials'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.query'))
              .onClick(() => {
                if (obtainingEnrolledCredentialInformation()) {
                  this.test[TextIdIndex.QUERY_CREDENTIALS] = 'Pass';
                  this.credentialDigest = 'credentialDigest is ' + obtainingEnrolledCredentialInformation();
                } else {
                  this.test[TextIdIndex.QUERY_CREDENTIALS] = 'Error';
                }
              })
            Text(this.test[TextIdIndex.QUERY_CREDENTIALS])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
              .id('text' + TextIdIndex.QUERY_CREDENTIALS)
            Text(this.credentialDigest)
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
          }
        }.tabBar(this.tabBuilder($r('app.string.credentialQueries'), PageIndex.CREDENTIAL_QUERIES, 'credentialQueries'))

        TabContent() {
          Column() {
            Button($r('app.string.refreshSupported'))
              .onClick(() => {
                if (obtainingSupported()) {
                  this.whetherSupport = $r('app.string.queryPass');
                } else {
                  this.whetherSupport = $r('app.string.queryError');
                }
              })
              .id('button1')
              .margin($r('app.float.size_10'))
            Text(this.whetherSupport)
              .fontSize($r('app.float.size_20'))
              .textAlign(TextAlign.Center)
            Blank()
              .height('10%')
            Row({ space: this.SPACE_GAP }) {
              Button($r('app.string.customLogin'))
                .onClick(() => {
                  comprehensiveFeatures();
                })
                .id('button2')
              Button($r('app.string.simpleLogin'))
                .onClick(() => {
                  initiatingUserAuthentication2();
                })
                .id('button3')
            }
            .margin($r('app.float.size_10'))

            Blank()
              .height('10%')
            Text($r('app.string.credentialDescription'))
              .width('80%')
              .fontSize($r('app.float.size_20'))
              .textAlign(TextAlign.Center)
            Button($r('app.string.refreshTheCredentials'))
              .onClick(() => {
                try {
                  let enrolledState = userAuth.getEnrolledState(userAuth.UserAuthType.PIN);
                  Logger.info(`get current enrolled state success, enrolledState: ${JSON.stringify(enrolledState)}`);
                  this.credentialValue = enrolledState.credentialDigest + '';
                } catch (error) {
                  const err: BusinessError = error as BusinessError;
                  Logger.error(`get current enrolled state failed, Code is ${err?.code}, message is ${err?.message}`);
                }
              })
              .id('button4')
              .margin($r('app.float.size_10'))
            Text(this.credentialValue)
              .fontSize($r('app.float.size_20'))
              .textAlign(TextAlign.Center)
          }
        }
        .tabBar(this.tabBuilder($r('app.string.simulationValidation'), PageIndex.SIMULATION_VALIDATION,
          'simulationValidation'))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth('90%')
      .barHeight('5%')
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .width('100%')
      .height('100%')
      .scrollable(true)
    }.height('100%')
  }
}
