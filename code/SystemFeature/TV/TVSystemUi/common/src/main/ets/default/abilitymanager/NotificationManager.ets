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
 

import { notificationManager } from '@kit.NotificationKit';
import { AsyncCallback } from 'basic';
import { NotificationSubscriber } from 'notification/notificationSubscriber';
import { NotificationRequest } from 'notification/notificationRequest';
import Log from '../Log';

const TAG = 'NotificationManager';


export default class NotificationManager {
  public static readonly TYPE_BASIC: number = notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
  public static readonly TYPE_LONG: number = notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT;
  public static readonly TYPE_MULTI: number = notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE;

  static subscribeNotification(
    tag: string, subscriber: NotificationSubscriber, asyncCallback: AsyncCallback<void>
  ): void {
    Log.showDebug(TAG, `subscribeNotification from: ${tag}`);
    notificationManager.subscribe(subscriber, asyncCallback);
  }

  static unsubscribeNotification(tag: string, subscriber: NotificationSubscriber): void {
    Log.showDebug(TAG, `subscribeNotification from: ${tag}`);
    notificationManager.unsubscribe(subscriber).then(() => {
    }).catch(err => {
    });
  }

  static removeAll(tag: string, callback: AsyncCallback<void>): void {
    Log.showDebug(TAG, `removeAll from: ${tag}`);
    notificationManager.removeAll(callback);
  }

  static remove(tag: string, hashCode: string, callback: AsyncCallback<void>): void {
    Log.showDebug(TAG, `remove from: ${tag}`);
    notificationManager.remove(hashCode, callback);
  }

  static getAllActiveNotifications(tag: string, callback: AsyncCallback<NotificationRequest[]>): void {
    Log.showDebug(TAG, `getAllActiveNotifications from: ${tag}`);
    notificationManager.getAllActiveNotifications(callback);
  }
}
