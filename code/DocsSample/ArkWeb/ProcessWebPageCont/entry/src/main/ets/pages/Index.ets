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

@Entry
@Component
struct Index {
  build() {
    Column({ space: 10 }) {
      Button('InitiatePrintW3CAPI')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/InitiatePrintW3CAPI' });
        })
      Button('InitiatePrintAppAPI')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/InitiatePrintAppAPI' });
        })
      Button('PreviewPDF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/PreviewPDF' });
        })
      Button('CalcAdjustSafeArea')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/CalcAdjustSafeArea' });
        })
      Button('LoadNetworkPdf')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/LoadNetworkPdf' });
        })
      Button('LoadSandboxPdf')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/LoadSandboxPdf' });
        })
      Button('LoadRawfilePdf')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/LoadRawfilePdf' });
        })
      Button('PdfEvent')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/PdfEvent' });
        })
    }.height('100%')
    .width('100%')
  }
}
