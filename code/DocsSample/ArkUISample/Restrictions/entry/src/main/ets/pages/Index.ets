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
@Entry
@Component
struct Index {

  build() {
    Column({ space: 20 }) {

      // --------------- 1. linkWithPrivate 目录页面跳转 ---------------
      // 请将$r('app.string.linkWithPrivate_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 linkWithPrivate 正确案例"
      Text($r('app.string.linkWithPrivate_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/linkWithPrivate/LlinkWithPrivateCorrectCase'})
        })

      // 请将$r('app.string.linkWithPrivateerr_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 linkWithPrivate 错误案例"
      Text($r('app.string.linkWithPrivateerr_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/linkWithPrivate/LlinkWithPrivateErrorCase'})
        })

      // --------------- 2. privateWithLink 目录页面跳转 ---------------
      // 请将$r('app.string.privateWithLink_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 privateWithLink 正确案例"
      Text($r('app.string.privateWithLink_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/privateWithLink/PrivateWithLinkCorrectCase'})
        })

      // 请将$r('app.string.privateWithLinkerr_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 privateWithLink 错误案例"
      Text($r('app.string.privateWithLinkerr_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/privateWithLink/PrivateWithLinkEerrorCase'})
        })

      // --------------- 3. privateWithRequire 目录页面跳转 ---------------
      // 请将$r('app.string.privateWithRequire_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 privateWithRequire 正确案例"
      Text($r('app.string.privateWithRequire_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/privateWithRequire/PrivateWithRequireCorrectCase'})
        })

      // 请将$r('app.string.privateWithRequireerr_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 privateWithRequire 错误案例"
      Text($r('app.string.privateWithRequireerr_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/privateWithRequire/PrivateWithRequireErrorCase'})
        })

      // --------------- 4. protectedInStruct 目录页面跳转 ---------------
      // 请将$r('app.string.protectedInStruct_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 protectedInStruct 正确案例"
      Text($r('app.string.protectedInStruct_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/protectedInStruct/ProtectedInStructCorrectCase'})
        })

      // 请将$r('app.string.protectedInStructerr_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 protectedInStruct 错误案例"
      Text($r('app.string.protectedInStructerr_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/protectedInStruct/ProtectedInStructErrorCase'})
        })

      // --------------- 5. publicWithStorageProp 目录页面跳转 ---------------
      // 请将$r('app.string.publicWithStorageProp_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 publicWithStorageProp 正确案例"
      Text($r('app.string.publicWithStorageProp_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/publicWithStorageProp/PublicWithStoragePropCorrectCase'})
        })

      // 请将$r('app.string.publicWithStorageProperr_lable')替换为实际资源文件，在本示例中该资源文件的value值为"跳转到 publicWithStorageProp 错误案例"
      Text($r('app.string.publicWithStorageProperr_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/publicWithStorageProp/PublicWithStoragePropErrorCase'})
        })

    }
    .height('100%')
    .width('100%')
    .padding(20)
    .justifyContent(FlexAlign.Start)
  }
}