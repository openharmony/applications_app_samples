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
import { InfConstants, Logger, NotificationId, NotificationUtils } from '@ohos/common';
import CloudConstants from '../CloudConstants';
import MqttAction from './MqttAction';
import commonEventManager from '@ohos.commonEventManager';
import MqttEngine from './MqttEngine';
import MqttMessageResponse, { NotifyType } from './MqttModel';
import { ConnectType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export default class MqttMessageDispatcher {
  public dispatch(mqttAction: string, message: string) {
    Logger.debug(CloudConstants.CLOUD_TAG, `MqttMessageDispatcher dispatch ${mqttAction}`);
    switch (mqttAction) {
      case MqttAction.TOPIC_DATA_RECEIVE:
        this.dispatcherDataMessage(message);
        break;
      case MqttAction.TOPIC_LOGIN_CONNECT_LOST:
        this.connectLost();
        break;
      case MqttAction.TOPIC_NET_CHANGED:
        this.connectLost();
        break;
      default:
        break;
    }
  }

  private dispatcherDataMessage(message: string) {
    Logger.info(CloudConstants.CLOUD_TAG, `dispatcherDataMessage ${message}`);
    try {
      let response = JSON.parse(message) as MqttMessageResponse;
      this.handleNotifyMessage(response);
    } catch (e) {
      Logger.error(CloudConstants.CLOUD_TAG, `dispatcherDataMessage error ${e?.message}`);
    }
  }

  private handleNotifyMessage(response: MqttMessageResponse) {
    let notifyType = response.header.notifyType;
    let body = response.body;
    switch (notifyType) {
      case NotifyType.DEVICE_STATUS:
        let record: Record<string, string | number> = {};
        let status = body['status'] as string;
        if (status == 'online') {
          record[InfConstants.ON_CONNECT_STATE_CHANGED_TYPE] = ConnectType.ONLINE;
        } else {
          record[InfConstants.ON_CONNECT_STATE_CHANGED_TYPE] = ConnectType.OFFLINE;
        }
        let gatewayId = body[InfConstants.GATEWAY_ID_TYPE] as string;
        let devId = body['devId'] as string;
        record[InfConstants.DEVICE_ID_TYPE] = devId;
        record[InfConstants.GATEWAY_ID_TYPE] = gatewayId;
        let stateJson = JSON.stringify(record);
        this.sendMessage(`KEY_${InfConstants.ON_CONNECT_STATE_CHANGED}`, stateJson);
        break;
      case NotifyType.DEVICE_DATA_CHANGED:
        // 消息传递给device_manager分发
        let bodyJson = JSON.stringify(body);
        this.sendMessage(`KEY_${InfConstants.ON_DEVICE_DATA_CHANGED}`, bodyJson);
        break;
      case NotifyType.BIND_DEVICE:
        let bindJson = JSON.stringify(body);
        this.sendMessage(`KEY_${InfConstants.ON_BIND_DEVICE}`, bindJson);
        break;
      case NotifyType.DEVICE_NAME_UPDATED:
        let updateJson = JSON.stringify(body);
        this.sendMessage(`KEY_${InfConstants.ON_DEVICE_UPDATED}`, updateJson);
        break;
      case NotifyType.DEVICE_DELETE:
        this.sendMessage(`KEY_${InfConstants.ON_DEVICE_DELETE}`, JSON.stringify(body));
        break;
      case NotifyType.DUPLICATE_LOGIN:
        let context = getContext(this) as common.UIAbilityContext;
        let date = new Date(parseInt(response.header.timestamp, 10));
        let mqttClientId = body['mqttClientId'] as string;
        let duplicateLoginTime = date.getFullYear() + '/' + (date.getMonth() + 1) + '/' +
        date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes() + ':' +
        date.getSeconds();
        let duplicateLoginTitle = context.resourceManager.getStringSync($r('app.string.duplicate_login').id);
        let duplicateLoginText =
          duplicateLoginTime + context.resourceManager.getStringSync($r('app.string.duplicate_login').id) + ' ' +
          context.resourceManager.getStringSync($r('app.string.duplicate_login_id').id) + mqttClientId;
        NotificationUtils.publishNotificationBasic(NotificationId.DUPLICATE_LOGIN, duplicateLoginTitle,
          duplicateLoginText).then(() => {
          Logger.info(CloudConstants.CLOUD_TAG, 'Notification sent successfully.');
        })
          .catch((error: BusinessError) => {
            Logger.error(CloudConstants.CLOUD_TAG,
              `Failed to send notification error code: ${error.code}  error message: ${error.message}`);
          });
        let duplicateLoginJson = JSON.stringify(body);
        Logger.info(CloudConstants.CLOUD_TAG,
          'DUPLICATE_LOGIN loginTime:' + duplicateLoginTime + '  DuplicateLoginJson: ' + duplicateLoginJson);
        this.sendMessage(`KEY_${InfConstants.ON_DUPLICATE_LOGIN}`, duplicateLoginJson);
        break;
      default:
        break;
    }
  }

  private sendMessage(event: string, bodyJson: string) {
    let option: commonEventManager.CommonEventPublishData = {
      data: bodyJson
    };
    commonEventManager.publish(event, option, () => {

    });
  }

  private connectLost() {
    MqttEngine.connect(true);
  }
};