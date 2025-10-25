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

// [Start mail_ability]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const TAG = 'MailAbility';
const DOMAIN = 0x0000;
export default class EntryAbility extends UIAbility {
  private windowStage: window.WindowStage | null = null;

  private email: string[] | undefined;
  private cc: string[] | undefined;
  private bcc: string[] | undefined;
  private subject: string | undefined;
  private body: string | undefined;
  private stream: string[] | undefined;
  // [Start mail_ability_on_create]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, TAG, `onCreate, want=${JSON.stringify(want)}`);
    super.onCreate(want, launchParam);
    this.parseWant(want);
  }
  // [End mail_ability_on_create]

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, TAG, `onNewWant, want=${JSON.stringify(want)}`);
    super.onNewWant(want, launchParam);
    this.parseWant(want);
    if (!this.windowStage) {
      hilog.error(DOMAIN, TAG, 'windowStage is null');
      this.context.terminateSelf();
      return;
    }
    this.loadPage(this.windowStage);
  }

  private parseWant(want: Want): void {
    this.email = this.decodeStringArr(want.parameters?.email as string[]);
    this.cc = this.decodeStringArr(want.parameters?.cc as string[]);
    this.bcc = this.decodeStringArr(want.parameters?.bcc as string[]);
    this.subject = decodeURI(want.parameters?.subject as string);// 使用decodeURI()方法对邮件主题进行url解码，其他字段处理方法相同
    this.body = decodeURI(want.parameters?.body as string);// 使用decodeURI()方法对邮件内容进行url解码，其他字段处理方法相同
    this.stream = this.decodeStringArr(want.parameters?.stream as string[]);
  }

  // 使用decodeURI()方法对string数组内容进行解码
  private decodeStringArr(source: string[] | undefined): string[] {
    let target: string[] = [];
    source?.forEach(e => {
      target.push(decodeURI(e));
    })
    return target;
  }

  private loadPage(windowStage: window.WindowStage): void {
    const storage: LocalStorage = new LocalStorage({
      'email': this.email,
      'cc': this.cc,
      'bcc': this.bcc,
      'subject': this.subject,
      'body': this.body,
      'stream': this.stream
    } as Record<string, Object>);

    windowStage.loadContent('pages/ComposeMailPage', storage);

  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, `onDestroy`);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, `onWindowStageCreate`);
    this.windowStage = windowStage;
    this.loadPage(this.windowStage);
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, TAG, `onWindowStageDestroy`);
  }

  onForeground(): void {
    hilog.info(DOMAIN, TAG, `onForeground`);
  }

  onBackground(): void {
    hilog.info(DOMAIN, TAG, `onBackground`);
  }
}
// [End mail_ability]