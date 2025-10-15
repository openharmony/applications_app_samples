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
import {
  installUserCADialogSample,
  uninstallUserCADialogSample,
  certDetailDialogSample
} from '../samples/CertManagerCaDialogSample';
import { certificateManagerDialogSample } from '../samples/CertManagerDialogSample';

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
      Button($r('app.string.call_installUserCADialog'))
        .width('70%')
        .onClick(() => {
          installUserCADialogSample();
          this.message = 'installUserCADialogSample Success';
        })
      Button($r('app.string.call_uninstallUserCADialog'))
        .width('70%')
        .onClick(() => {
          uninstallUserCADialogSample();
          this.message = 'uninstallUserCADialogSample Success';
        })
      Button($r('app.string.call_certDetailDialog'))
        .width('70%')
        .onClick(() => {
          certDetailDialogSample();
          this.message = 'certDetailDialogSample Success';
        })
    }
    .height('100%')
    .width('100%')
  }
}