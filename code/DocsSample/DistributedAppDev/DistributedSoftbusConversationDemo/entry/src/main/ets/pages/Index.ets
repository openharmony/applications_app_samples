import { BusinessError } from '@kit.BasicServicesKit'
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit'
import { conversation } from '@kit.DistributedServiceKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = '[ConversationTestPage]';
const DOMAIN = 0x0000;
const messageToSend = 'Hello from ConversationTest!';
const bundleName = 'com.example.demo';
const abilityName = "EntryAbility";
const deviceId = 'networkId_or_Udid'

// 定义消息回调
let messageCallback: conversation.DataCallback = (networkId: string, msg: ArrayBuffer): void => {
  hilog.info(DOMAIN, TAG, 'Received message from: %{public}s', networkId);
  hilog.info(DOMAIN, TAG, 'Message length: %{public}d', msg.byteLength);
  let bufferView = new Uint8Array(msg);
  let messageStr = '';
  for (let i = 0; i< bufferView.length; i++) {
      messageStr = String.fromCharCode(bufferView[i]);
    }
  hilog.info(DOMAIN, TAG, 'Message content: %{public}s', messageStr);
}

@Entry
@Component
struct Index {
  // 权限申请
  requesPermission(): void {
      let permissions: Array<Permissions> = [
          'ohos.permission.DISTRIBUTED_DATASYNC',
          'ohos.permission.sec.ACCESS_UDID'
          ];
      let context: Context = getContext(this);
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      atManager.requestPermissionsFromUser(context, permissions).then((data) => {
        let grantStatus: Array<number> = data.authResults;
        let length: number = grantStatus.length;
        for (let i = 0; i < length; i++) {
          if (grantStatus[i] === 0) {
            hilog.info(DOMAIN, TAG, 'Permission %{public}s granted', permissions[i]);
          } else {
            hilog.info(DOMAIN, TAG, 'Permission %{public}s denied', permissions[i]);
          }
      }
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, TAG, 'Request permission Failed: %{public}s', JSON.stringify(err));
    });
  }

  aboutToAppear(): void {
    hilog.info(DOMAIN, TAG, "aboutToAppear");
    this.requesPermission();
  }

  // 定义消息回调
  getTrustedDevices(): void {
    hilog.info(DOMAIN, TAG, 'getTrustedDevices called');
    try {
      let devices = conversation.getTrustedDevices() as conversation.DeviceNodeInfo[];
      if (devices && devices.length > 0) {
          let deviceInfo = devices.map((d, idx) =>
          `${idx + 1}. ${d.deviceName} (${d.networkId}) - Type:${d.deviceTypeId} - Nearby:${d.nearby}`
            ).join('\n');
          hilog.info(DOMAIN, TAG, 'Found %{public}s devices', devices.length);
          hilog.info(DOMAIN, TAG, 'Devices list: \n %{public}s', deviceInfo);
        } else {
          hilog.info(DOMAIN, TAG, 'Found %{public}s devices', devices.length);
        }
    } catch (err) {
      let error = err as BusinessError;
      hilog.error(DOMAIN, TAG, 'getTrustedDevices error: %{public}s - %{public}s', error.code, error.message);
    }
  }

  // 注册监听器
  registerListener(): void {
    hilog.info(DOMAIN, TAG, 'registerListener called');
    try {
      conversation.registerConversationListener(bundleName, abilityName, messageCallback);
      hilog.info(DOMAIN, TAG, 'Listener registered for %{public}s/%{public}s', bundleName, abilityName);
    } catch (err) {
      let error = err as BusinessError;
      hilog.error(DOMAIN, TAG, 'registerDataListener error: %{public}s - %{public}s', error.code, error.message);
    }
  }

  // 注销监听器
  unregisterListener(): void {
    hilog.info(DOMAIN, TAG, 'unregisterListener called');
    try {
      conversation.unregisterConversationListener(bundleName, abilityName);
      hilog.info(DOMAIN, TAG, 'Listener unregistered');
    } catch (err) {
      let error = err as BusinessError;
      hilog.error(DOMAIN, TAG, 'unregisterDataListener error: %{public}s - %{public}s', error.code, error.message);
    }
  }

  // 发送消息
  sendMessage(): void {
    hilog.info(DOMAIN, TAG, 'sendMessage called');
    try {
      let arrayBuffer = new ArrayBuffer(messageToSend.length);
      let bufferView = new Uint8Array(arrayBuffer);
      for (let i = 0; i < messageToSend.length; i++) {
          bufferView[i] = messageToSend.charCodeAt(i);
        }

      conversation.postConversationData(deviceId, bundleName, abilityName, arrayBuffer)
          .then(() => {
            hilog.info(DOMAIN, TAG, 'Message sent successfully to %{public}s', deviceId);
          })
          .catch((err : BusinessError) => {
            hilog.error(DOMAIN, TAG, 'sendMessage error: %{public}s - %{public}s', err.code, err.message);
          });
    } catch (err) {
      let error = err as BusinessError;
      hilog.error(DOMAIN, TAG, 'sendMessage error: %{public}s - %{public}s', error.code, error.message);
    }
  }



  build() {
    Column() {
      Text('Distributed SoftBus Conversation Test')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20})

      Button('Get Trusted Devices')
        .width('100%')
        .height(40)
        .onClick(() => this.getTrustedDevices())
        .margin({ bottom: 20 })

      Row() {
        Button('Register Listener')
          .onClick(() => this.registerListener())
          .width('45%')

        Button('Unregister Listener')
          .onClick(() => this.unregisterListener())
          .width('45%')
      }
      .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: 20})
  
        Button('Send Message')
          .onClick(() => this.sendMessage())
          .margin({ bottom: 20})
          .width('100%')
          .height(40)
      }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}