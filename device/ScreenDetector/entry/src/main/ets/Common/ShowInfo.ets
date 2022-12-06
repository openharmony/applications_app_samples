/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import display from '@ohos.display'

const TAG: string = '[ScreenDetector]'
const LIMIT_ZERO: number = 0
const LIMIT_TWO: number = 2
const PIXEL_TO_CM: number = 2.54
var rectInfo = {
  widthSize: 0,
  heightSize: 0,
  widthOfInch: 0,
  heightOfInch: 0,
  widthOfCm: 0,
  heightOfCm: 0,
  diagonalOfInch: 0,
  diagonalOfCm: 0,
  inchPerPixel: 0
}

@Component
export struct ShowInfo {
  private infoDetail?: display.Display
  @Builder infoText(types: Resource, info: string) {
    Row() {
      Text(types).fontSize(18)
      Blank()
      Text(info).fontSize(18)
    }
    .width('100%')
  }
  screenInfo(type: string) {
    switch (type) {
      case 'screenRect':
        return `${this.infoDetail.width.toFixed(LIMIT_ZERO)}` + ' X ' + `${this.infoDetail.height.toFixed(LIMIT_ZERO)}`
      case 'screenDimensions':
        return `${rectInfo.widthSize.toFixed(LIMIT_ZERO)}` + ' X ' + `${rectInfo.heightSize.toFixed(LIMIT_ZERO)}`
      case 'screenDPI':
        return `${this.infoDetail.densityDPI.toFixed(LIMIT_TWO)}` + ' X ' + `${this.infoDetail.densityDPI.toFixed(LIMIT_TWO)}`
      case 'refreshRate':
        return `${this.infoDetail.refreshRate.toFixed(LIMIT_TWO)}` + ' HZ'
      case 'densityRatio':
        return `${this.infoDetail.scaledDensity.toFixed(LIMIT_TWO)}`
      case 'densityDPI':
        return `${this.infoDetail.densityDPI.toFixed(LIMIT_ZERO)}`
      case 'screenInches':
        return `${rectInfo.widthOfInch.toFixed(LIMIT_TWO)}` + ' X ' + `${rectInfo.heightOfInch.toFixed(LIMIT_TWO)}`
      case 'screenCM':
        return `${rectInfo.widthOfCm.toFixed(LIMIT_TWO)}` + ' X ' + `${rectInfo.heightOfCm.toFixed(LIMIT_TWO)}`
      case 'diagonalInches':
        return `${rectInfo.diagonalOfInch.toFixed(LIMIT_TWO)}`
      case 'diagonalCM':
        return `${rectInfo.diagonalOfCm.toFixed(LIMIT_TWO)}`
      case 'pixelsPerInch':
        return `${rectInfo.inchPerPixel.toFixed(LIMIT_ZERO)}`
      default:
        return ''
    }
  }
  aboutToAppear() {
    rectInfo.widthSize = this.infoDetail.width / this.infoDetail.scaledDensity
    rectInfo.heightSize = this.infoDetail.height / this.infoDetail.scaledDensity
    rectInfo.widthOfInch = this.infoDetail.width / this.infoDetail.densityDPI
    rectInfo.heightOfInch = this.infoDetail.height / this.infoDetail.densityDPI
    rectInfo.widthOfCm = PIXEL_TO_CM * rectInfo.widthOfInch
    rectInfo.heightOfCm = PIXEL_TO_CM * rectInfo.heightOfInch
    rectInfo.diagonalOfInch = Math.sqrt(Math.pow(rectInfo.widthOfInch, 2) + Math.pow(rectInfo.heightOfInch, 2))
    rectInfo.diagonalOfCm = PIXEL_TO_CM * rectInfo.diagonalOfInch
    rectInfo.inchPerPixel = this.infoDetail.densityDPI
  }
  build() {
    Column() {
      this.infoText($r('app.string.screenRect'), this.screenInfo('screenRect'))
      this.infoText($r('app.string.screenDimensions'), this.screenInfo('screenDimensions'))
      this.infoText($r('app.string.screenDPI'), this.screenInfo('screenDPI'))
      this.infoText($r('app.string.refreshRate'), this.screenInfo('refreshRate'))
      this.infoText($r('app.string.densityRatio'), this.screenInfo('densityRatio'))
      this.infoText($r('app.string.densityDPI'), this.screenInfo('densityDPI'))
      this.infoText($r('app.string.screenInches'), this.screenInfo('screenInches'))
      this.infoText($r('app.string.screenCM'), this.screenInfo('screenCM'))
      this.infoText($r('app.string.diagonalInches'), this.screenInfo('diagonalInches'))
      this.infoText($r('app.string.diagonalCM'), this.screenInfo('diagonalCM'))
      this.infoText($r('app.string.pixelsPerInch'), this.screenInfo('pixelsPerInch'))
    }
    .padding(5)
    .width('100%')
    .borderRadius(10)
    //.alignItems(HorizontalAlign.Start)
  }
}
