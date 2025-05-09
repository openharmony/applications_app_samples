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
// [Start certificate_management_dialog_box_development_guide]
import { certificateManagerDialog } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

async function certificateManagerDialogSample() {
  /* context为应用的上下文信息，由调用方自行获取，此处仅为示例 */
  let context: common.Context = getContext();
  /* pageType为页面类型，此处赋值PAGE_MAIN，即拉起证书管理主界面 */
  let pageType: certificateManagerDialog.CertificateDialogPageType =
    certificateManagerDialog.CertificateDialogPageType.PAGE_MAIN;
  try {
    certificateManagerDialog.openCertificateManagerDialog(context, pageType).then(() => {
      console.info('Succeeded in opening certificate manager dialog.');
    }).catch((err: BusinessError) => {
      console.error(`Failed to open certificate manager dialog. Code: ${err.code}, message: ${err.message}`);
    })
  } catch (error) {
    console.error(`Failed to open certificate manager dialog. Code: ${error.code}, message: ${error.message}`);
  }
}


// [End certificate_management_dialog_box_development_guide]
@Entry
@Component
struct Index {
  @State message: string = 'CertManagerDialogGuidelines';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontWeight(FontWeight.Bold)
        .fontSize(25)
      Button($r('app.string.call_certManagerDialogGuidelines'))
        .width('70%')
        .onClick(() => {
          certificateManagerDialogSample();
          this.message = 'CertManagerDialogGuidelines Success';
        })
    }
    .height('100%')
    .width('100%')
  }
}