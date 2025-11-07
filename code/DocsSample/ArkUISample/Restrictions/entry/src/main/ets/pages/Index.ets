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
      // $r('app.string.linkWithPrivate_lable')需要替换为开发者所需的资源文件
      Text($r('app.string.linkWithPrivate_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/linkWithPrivate/LlinkWithPrivateCorrectCase'})
        })

      // $r('app.string.linkWithPrivateerr_lable')需要替换为开发者所需的资源文件
      Text($r('app.string.linkWithPrivateerr_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/linkWithPrivate/LlinkWithPrivateErrorCase'})
        })

      // --------------- 2. privateWithLink 目录页面跳转 ---------------
      // $r('app.string.privateWithLink_lable')需要替换为开发者所需的资源文件
      Text($r('app.string.privateWithLink_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/privateWithLink/PrivateWithLinkCorrectCase'})
        })

      // $r('app.string.privateWithLinkerr_lable')需要替换为开发者所需的资源文件
      Text($r('app.string.privateWithLinkerr_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/privateWithLink/PrivateWithLinkEerrorCase'})
        })

      // --------------- 3. privateWithRequire 目录页面跳转 ---------------
      // $r('app.string.privateWithRequire_lable')需要替换为开发者所需的资源文件
      Text($r('app.string.privateWithRequire_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/privateWithRequire/PrivateWithRequireCorrectCase'})
        })

      // $r('app.string.privateWithRequireerr_lable')需要替换为开发者所需的资源文件
      Text($r('app.string.privateWithRequireerr_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/privateWithRequire/PrivateWithRequireErrorCase'})
        })

      // --------------- 4. protectedInStruct 目录页面跳转 ---------------
      // $r('app.string.protectedInStruct_lable')需要替换为开发者所需的资源文件
      Text($r('app.string.protectedInStruct_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/protectedInStruct/ProtectedInStructCorrectCase'})
        })

      // $r('app.string.protectedInStructerr_lable')需要替换为开发者所需的资源文件
      Text($r('app.string.protectedInStructerr_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/protectedInStruct/ProtectedInStructErrorCase'})
        })

      // --------------- 5. publicWithStorageProp 目录页面跳转 ---------------
      // $r('app.string.publicWithStorageProp_lable')需要替换为开发者所需的资源文件
      Text($r('app.string.publicWithStorageProp_lable'))
        .fontSize(16)
        .fontColor('#1890FF')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/publicWithStorageProp/PublicWithStoragePropCorrectCase'})
        })

      // $r('app.string.publicWithStorageProperr_lable')需要替换为开发者所需的资源文件
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