/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

interface BorderBoleTrue {
  topLeft: number;
  topRight: number;
};

interface BorderBoleFalse {
  bottomLeft: number;
  bottomRight: number;
};

interface Length {
  topLeft: number;
  topRight: number;
  bottomLeft: number;
  bottomRight: number;
};

@Component
export struct settingPublicLayout {
  private icon: Resource = $r('app.string.CONTENT_TYPE_UNKNOWN');
  private modeMessage: Resource = $r('app.string.CONTENT_TYPE_UNKNOWN');
  private getModeBol: (mirrorBol: boolean) => void = (mirrorBol: boolean) => {
  };
  private setModeBol: boolean = false;
  private isModeBol: boolean = false;
  private borderBol: boolean = false;
  private borderBole: boolean = false;
  private iconModeBol: boolean = false;
  private backNum: number = 1;
  @State backClBol: boolean = false;
  @Link @Watch('leftSliderChange') leftSliderIndex: number;
  private borderBoleTrue: BorderBoleTrue = {
    topLeft: 16,
    topRight: 16
  };
  private borderBoleFalse: BorderBoleFalse = {
    bottomLeft: 16,
    bottomRight: 16
  };
  private length: Length = {
    topLeft: 16,
    topRight: 16,
    bottomLeft: 16,
    bottomRight: 16
  };

  leftSliderChange() {
    if (this.backNum == this.leftSliderIndex) {
      this.backClBol = true;
    } else {
      this.backClBol = false;
    }
  }

  aboutToAppear() {
    this.leftSliderChange();
  }

  isBorderFn() {
    if (this.isModeBol) {
      if (this.borderBol) {
        if (this.borderBole) {
          return this.borderBoleTrue;
        } else {
          return this.borderBoleFalse;
        }
      } else {
        return this.length;
      }
    } else {
      return null;
    }
  }

  build() {
    Row() {
      Row() {
        Row() {
          Image(this.icon).width(20).height(20).margin({ left: '15px' });
          Text(this.modeMessage).margin({ left: '20px' })
        }

        if (this.iconModeBol) {
          Toggle({ type: ToggleType.Switch, isOn: this.setModeBol })
            .selectedColor($r('app.color.theme_color'))
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              this.getModeBol(isOn);
              console.info('Component status:' + isOn)
            })
        } else {
          Image($r('app.media.ic_camera_set_arrow')).width(20).height(20).margin({ right: 10 })
        }
      }
      .onClick(() => {
        this.leftSliderIndex = this.backNum;
        console.info('leftSliderIndex status:' + this.leftSliderIndex);
        console.info('backNum status:' + this.backNum);
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .borderRadius(15)
      .height('90px')
      .backgroundColor(this.backClBol ? 'rgba(255,0,52,0.10)' : '')
    }
    .padding(2)
    .width('100%')
    .height('100px')
    .borderRadius(this.isBorderFn())
    .backgroundColor(Color.White)
  }
}