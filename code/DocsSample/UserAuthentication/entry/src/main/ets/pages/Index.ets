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

// 本页代码为标准实例，没有使用同步语法，不涉及测试，更多关于测试信息，详见readme。
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

enum PageIndex {
  QUERY_CAPABILITY = 0, // 能力查询页面的索引值
  EXAMPLE_TAB_1 = 1, // 实例1页面的索引值
  EXAMPLE_TAB_2 = 2, // 实例2页面的索引值
  EXAMPLE_TAB_3 = 3, // 实例3页面的索引值
  EXAMPLE_TAB_4 = 4, // 实例4页面的索引值
  CREDENTIAL_QUERIES = 5, // 能力查询页面的索引值
  SIMULATION_VALIDATION = 6 // 模拟认证页面的索引值
};

enum ResultIndex {
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
  @State result: string[] = new Array(8).fill('wait');
  @State credentialDigest: string = '';
  @State whetherSupport: Resource = $r('app.string.waitQuery');
  @State credentialValue: string = '';
  SPACE_GAP: number = 5; // Row组件间隙

  /*
   * obtain-supported-authentication-capabilities.md
   * 以查询设备是否支持认证可信等级≥ATL1的PIN认证功能为例
   */
  // [Start obtain_supported_capabilities]
  obtainingSupported() {
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

  // [End obtain_supported_capabilities]
  // 用于处理示例1，示例2，示例3和示例4的部分操作
  // [Start authentication_example1]
  // [Start authentication_example2]
  // [Start authentication_example3]
  // [Start authentication_example4]
  handleAuthResult(userAuthInstance: userAuth.UserAuthInstance, exampleNumber: number) {
    // [StartExclude authentication_example1]
    // [StartExclude authentication_example2]
    // [StartExclude authentication_example3]
    // [StartExclude authentication_example4]
    try {
      // [EndExclude authentication_example1]
      // [EndExclude authentication_example2]
      // [EndExclude authentication_example3]
      // [EndExclude authentication_example4]
      // userAuthInstance.on异常抛出层
      userAuthInstance.on('result', {
        onResult: (result: userAuth.UserAuthResult) => {
          // [StartExclude authentication_example1]
          // [StartExclude authentication_example2]
          // [StartExclude authentication_example3]
          // [StartExclude authentication_example4]
          this.result[exampleNumber] = (`${result.result}`);
          try {
            // onResult异常抛出层
            try {
              // JSON.stringify异常抛出层
              // [EndExclude authentication_example1]
              // [EndExclude authentication_example2]
              // [EndExclude authentication_example3]
              // [EndExclude authentication_example4]
              Logger.info(`userAuthInstance callback result: ${JSON.stringify(result)}`);
              // [StartExclude authentication_example1]
              // [StartExclude authentication_example2]
              // [StartExclude authentication_example3]
              // [StartExclude authentication_example4]
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error(`JSON stringify catch error. Code is ${err?.code}, message is ${err?.message}`);
            }
            // [EndExclude authentication_example1]
            // [EndExclude authentication_example2]
            // [EndExclude authentication_example3]
            // [EndExclude authentication_example4]
            userAuthInstance.off('result'); // 认证完成后取消订阅
            // [StartExclude authentication_example1]
            // [StartExclude authentication_example2]
            // [StartExclude authentication_example3]
            // [StartExclude authentication_example4]
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(`onResult catch error. Code: ${err?.code}, Message: ${err?.message}`);
          }
          // [EndExclude authentication_example1]
          // [EndExclude authentication_example2]
          // [EndExclude authentication_example3]
          // [EndExclude authentication_example4]
        }
      });
      // 启动认证
      userAuthInstance.start();
      Logger.info('auth start success');
      // [StartExclude authentication_example1]
      // [StartExclude authentication_example2]
      // [StartExclude authentication_example3]
      // [StartExclude authentication_example4]
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`userAuthInstance.on catch error. Code: ${err?.code}, Message: ${err?.message}`);
    }
    // [EndExclude authentication_example1]
    // [EndExclude authentication_example2]
    // [EndExclude authentication_example3]
    // [EndExclude authentication_example4]
  }

  /*
   * start-authentication.md
   * 示例1：
   * 发起用户认证，采用认证可信等级≥ATL3的人脸 + 锁屏密码 + 指纹认证，获取认证结果
   * */
  // [StartExclude authentication_example2]
  // [StartExclude authentication_example3]
  // [StartExclude authentication_example4]
  initiatingUserAuthentication1() {
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
      this.handleAuthResult(userAuthInstance, ResultIndex.EXAMPLE_1);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  // [EndExclude authentication_example2]
  // [End authentication_example1]
  /*
   * start-authentication.md
   * 示例2：
   * 发起用户认证，采用认证可信等级≥ATL3的人脸 + 锁屏密码 + 指纹认证 + 认证类型相关 + 复用设备解锁最大有效时长认证，获取认证结果
   * */
  initiatingUserAuthentication2() {
    // 设置认证参数
    let reuseUnlockResult: userAuth.ReuseUnlockResult = {
      reuseMode: userAuth.ReuseMode.AUTH_TYPE_RELEVANT,
      reuseDuration: userAuth.MAX_ALLOWABLE_REUSE_DURATION,
    };
    try {
      const randData = getRandData();
      if (!randData) {
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
      this.handleAuthResult(userAuthInstance, ResultIndex.EXAMPLE_2);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  // [EndExclude authentication_example3]
  // [End authentication_example2]
  /*
   * start-authentication.md
   * 示例3：
   * 发起用户认证，采用认证可信等级≥ATL3的人脸 + 锁屏密码 + 指纹认证 + 任意应用认证类型相关 + 复用任意应用最大有效时长认证，获取认证结果：
   * */
  initiatingUserAuthentication3() {
    // 设置认证参数
    let reuseUnlockResult: userAuth.ReuseUnlockResult = {
      reuseMode: userAuth.ReuseMode.CALLER_IRRELEVANT_AUTH_TYPE_RELEVANT,
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
      this.handleAuthResult(userAuthInstance, ResultIndex.EXAMPLE_3);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  // [EndExclude authentication_example4]
  // [End authentication_example3]
  /*
   * start-authentication.md
   * 示例4：
   * 以模应用方式进行用户身份认证
   * */
  initiatingUserAuthentication4() {
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
      this.handleAuthResult(userAuthInstance, ResultIndex.EXAMPLE_4);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  // [End authentication_example4]
  // [Start cancel_authentication]
  handleAuthResultAndCanceling(userAuthInstance: userAuth.UserAuthInstance, exampleNumber: number) {
    // [StartExclude cancel_authentication]
    try {
      // userAuthInstance.on异常抛出层
      userAuthInstance.on('result', {
        onResult: (result: userAuth.UserAuthResult) => {
          this.result[exampleNumber] = (`${result.result}`);
          try {
            // onResult异常抛出层
            try {
              // JSON.stringify异常抛出层
              Logger.info(`userAuthInstance callback result: ${JSON.stringify(result)}`);
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error(`JSON stringify catch error. Code is ${err?.code}, message is ${err?.message}`);
            }
            userAuthInstance.off('result'); // 认证完成后取消订阅
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(`onResult catch error. Code: ${err?.code}, Message: ${err?.message}`);
          }
        }
      });
      // [EndExclude cancel_authentication]
      // 启动认证
      userAuthInstance.start();
      Logger.info('auth start success');
      // [StartExclude cancel_authentication]
      // 使用等待函数模拟等待用户认证
      let DELAY_TIME: number = 3000; // 停止3秒
      waiting(DELAY_TIME).then(() => {
        // 延迟后取消认证
        // [EndExclude cancel_authentication]
        userAuthInstance.cancel();
        Logger.info('auth cancel success');
        // [StartExclude cancel_authentication]
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`userAuthInstance.on catch error. Code: ${err?.code}, Message: ${err?.message}`);
    }
    // [EndExclude cancel_authentication]
  }

  /*
   * cancel-authentication.md
   * 发起认证可信等级≥ATL3的人脸+锁屏密码认证后，取消认证请求
   * */
  cancelingUserAuthentication() {
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
      this.handleAuthResultAndCanceling(userAuthInstance, ResultIndex.CANCEL);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`auth catch error. Code is ${err?.code as number}, message is ${err?.message}`);
    }
  }

  // [End cancel_authentication]
  // [Start custom_authentication]
  handleCustomAuthResult(userAuthInstance: userAuth.UserAuthInstance, exampleNumber: number) {
    // [StartExclude custom_authentication]
    try {
    // [EndExclude custom_authentication]
      // userAuthInstance.on异常抛出层
      userAuthInstance.on('result', {
        onResult: (result: userAuth.UserAuthResult) => {
          // [StartExclude custom_authentication]
          this.result[exampleNumber] = (`${result.result}`);
          try {
            // onResult异常抛出层
            try {
              // JSON.stringify异常抛出层
              // [EndExclude custom_authentication]
              Logger.info(`userAuthInstance callback result: ${JSON.stringify(result)}`);
              // [StartExclude custom_authentication]
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error(`JSON stringify catch error. Code is ${err?.code}, message is ${err?.message}`);
            }
            userAuthInstance.off('result'); // 认证完成后取消订阅
            // [EndExclude custom_authentication]
            if (result.result == userAuth.UserAuthResultCode.CANCELED_FROM_WIDGET ||
              result.result == userAuth.UserAuthResultCode.NOT_ENROLLED) {
              // 请开发者自行完成拉起自定义认证界面的实现
              // 此处拉起类似于支付宝输入密码支付的界面
              // [StartExclude custom_authentication]
              promptAction.showToast({
                message: resourceToString($r('app.string.dialogOfCustom')), // 显示文本
                duration: 3000, // 显示时长3000ms
                bottom: 300     // 距离底部的距离300vp
              });
              // [EndExclude custom_authentication]
            }
            // [StartExclude custom_authentication]
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(`onResult catch error. Code: ${err?.code}, Message: ${err?.message}`);
          }
          // [EndExclude custom_authentication]
        }
      });
      // 启动认证
      userAuthInstance.start();
      Logger.info('auth start success');
      // [StartExclude custom_authentication]
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`userAuthInstance.on catch error. Code: ${err?.code}, Message: ${err?.message}`);
    }
    // [EndExclude custom_authentication]
  }

  /*
   * apply-custom-authentication.md
   * 当前示例仅展示如何配置界面、选择切换到自定义认证界面，具体拉起的页面及对应页面的实现，请开发者自行实现
   * */
  applyingCustomAuthentication() {
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
      this.handleCustomAuthResult(userAuthInstance, ResultIndex.CUSTOMIZE);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    }
  }
  // [End custom_authentication]

  /*
   * obtain-enrolled-state-capabilities.md
   * 以查询用户人脸注册凭据的状态为例
   * */
  // [Start obtain_enrolled_capabilities]
  obtainingEnrolledCredentialInformation() {
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

  // [End obtain_enrolled_capabilities]
  comprehensiveFeatures() {
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
      this.handleCustomAuthResult(userAuthInstance, ResultIndex.CUSTOMIZE);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

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
                if (this.obtainingSupported()) {
                  this.result[ResultIndex.WHETHER_SUPPORTED] = 'Support';
                } else {
                  this.result[ResultIndex.WHETHER_SUPPORTED] = 'Not Support';
                }
              })
            Text(this.result[ResultIndex.WHETHER_SUPPORTED])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
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
                this.initiatingUserAuthentication1();
              })
            Text(this.result[ResultIndex.EXAMPLE_1])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
            Blank()
              .height('5%')
            Text($r('app.string.descriptionContent2'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example2'))
              .onClick(async () => {
                this.initiatingUserAuthentication2();
              })
            Text(this.result[ResultIndex.EXAMPLE_2])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
          }
        }.tabBar(this.tabBuilder($r('app.string.exampleTab1'), PageIndex.EXAMPLE_TAB_1, 'exampleTab1'))

        TabContent() {
          Column() {
            Text($r('app.string.descriptionContent3'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example3'))
              .onClick(() => {
                this.initiatingUserAuthentication3();
              })
            Text(this.result[ResultIndex.EXAMPLE_3])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
            Blank()
              .height('5%')
            Text($r('app.string.descriptionContent4'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example4'))
              .onClick(() => {
                this.initiatingUserAuthentication4();
              })
            Text(this.result[ResultIndex.EXAMPLE_4])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
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
                this.cancelingUserAuthentication();
              })
            Text(this.result[ResultIndex.CANCEL])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
          }
        }.tabBar(this.tabBuilder($r('app.string.exampleTab3'), PageIndex.EXAMPLE_TAB_3, 'exampleTab3'))

        TabContent() {
          Column() {
            Text($r('app.string.descriptionContent6'))
              .width('70%')
              .textAlign(TextAlign.Center)
              .fontSize($r('app.float.size_20'))
            Button($r('app.string.example6'))
              .onClick(() => {
                this.applyingCustomAuthentication();
              })
            Text(this.result[ResultIndex.CUSTOMIZE])
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
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
                if (this.obtainingEnrolledCredentialInformation()) {
                  this.credentialDigest = 'credentialDigest is ' + this.obtainingEnrolledCredentialInformation();
                } else {
                  this.credentialDigest = 'Error';
                }
              })
            Text(this.credentialDigest)
              .fontSize($r('app.float.size_40'))
              .textAlign(TextAlign.Center)
          }
        }.tabBar(this.tabBuilder($r('app.string.credentialQueries'), PageIndex.CREDENTIAL_QUERIES, 'credentialQueries'))

        TabContent() {
          Column() {
            Button($r('app.string.refreshSupported'))
              .onClick(() => {
                if (this.obtainingSupported()) {
                  this.whetherSupport = $r('app.string.queryPass');
                } else {
                  this.whetherSupport = $r('app.string.queryError');
                }
              })
              .margin($r('app.float.size_10'))
            Text(this.whetherSupport)
              .fontSize($r('app.float.size_20'))
              .textAlign(TextAlign.Center)
            Blank()
              .height('10%')
            Row({ space: this.SPACE_GAP }) {
              Button($r('app.string.customLogin'))
                .onClick(() => {
                  this.comprehensiveFeatures();
                })
              Button($r('app.string.simpleLogin'))
                .onClick(() => {
                  this.initiatingUserAuthentication2();
                })
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
