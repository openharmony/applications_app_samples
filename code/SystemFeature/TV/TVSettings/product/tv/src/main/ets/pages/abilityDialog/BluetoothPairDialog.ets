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

import BluetoothDeviceController from '../../controller/bluetooth/BluetoothDeviceController';
import BluetoothModel, { BondState } from '../../model/bluetoothImpl/BluetoothModel';
import deviceInfo from '@ohos.deviceInfo';
import Display from '@ohos.display';
import pbap from '@ohos.bluetooth.pbap';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import sim from '@ohos.telephony.sim';
import { UIExtensionContentSession } from '@kit.AbilityKit';
import { connection } from '@kit.ConnectivityKit';
import { display } from '@kit.ArkUI';
import { PinType } from '../../MainAbility/BluetoothPairDialogAbility';
import { inputEventClient, KeyCode } from '@kit.InputKit';

const TAG = 'BluetoothPairDialog :';
const deviceTypeInfo = deviceInfo.deviceType;
const PIN_REQUIRED_TIME_OUT: number = 30000;

class InjectedKeyEventPayload {
}

@Entry
@Component
export struct BluetoothPairDialog {
  deviceId: string = '';
  pinCode: string = '';
  pinType: number = -1;
  public pinRequireTimerId: number | null = null;
  bluetoothPairDialogController: CustomDialogController | null = new CustomDialogController({
    builder: PairDialogComponent({
      deviceId: this.deviceId,
      pinType: this.pinType,
      pinCode: this.pinCode,
    }),
    cancel: () => {
    },
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Bottom,
    maskColor: $r('sys.color.mask_fourth'),
  });

  build() {
  }

  aboutToAppear(): void {
    LogUtil.info(`${TAG} bluetooth pairDevice result1 aboutToAppear`);
    this.deviceId = AppStorage.get<string>('PairDeviceId') as string;
    this.pinCode = AppStorage.get<string>('PairPinCode') as string;
    this.pinType = AppStorage.get<number>('PairPinType') as number;
    LogUtil.info(`${TAG} bluetooth pairDevice result1 this.deviceId`+this.deviceId);
    LogUtil.info(`${TAG} bluetooth pairDevice result1 this.pinCode`+this.pinCode);
    LogUtil.info(`${TAG} bluetooth pairDevice result1 this.pinType`+this.pinType);
    this.bluetoothPairDialogController?.open();
    this.pinRequireTimerId = setTimeout(() => {
      LogUtil.info(`${TAG} pinRequired timeout`);
      this.closeDialog();
    }, PIN_REQUIRED_TIME_OUT)

    connection.on('bondStateChange', (data: connection.BondStateParam) => {
      LogUtil.info(`${TAG}bondStateChange, deviceId:${data.deviceId}`);
      if (data.deviceId === this.deviceId) {
        if (data.state === BondState.BOND_STATE_INVALID || data.state === BondState.BOND_STATE_BONDED) {
          LogUtil.info(`${TAG}bondStateChange closeDialog, state:${data.state}`);
          this.closeDialog();
        }
      }
    });
  }

  aboutToDisappear(): void {
    LogUtil.info(`${TAG} aboutToDisappear`);
    clearTimeout(this.pinRequireTimerId);
  }

  private closeDialog(): void {
    this.bluetoothPairDialogController?.close;
    (AppStorage.get<UIExtensionContentSession>(`dialogSession`) as UIExtensionContentSession)?.terminateSelf();
  }
}

@CustomDialog
export struct PairDialogComponent {
  @State focusId: string = ''
  @State defaultFocuscancel:boolean=false
  @State defaultFocuscancelinput:boolean=false
  @State defaultFocuscancelinput2:boolean=false
  deviceId: string = '';
  pinCode: string = '';
  pinType: number = -1;
  deviceName: string = '';
  input: string = '';
  pairDialogController?: PairDialogController;
  controller?: CustomDialogController;
  private isOnClick: boolean = false;
  @State dialogWidth: number | string = 400
  @State paddingValue: ResourceStr | number =
    deviceTypeInfo === 'phone' || deviceTypeInfo === 'default' ? $r('sys.float.padding_level8') : 0

  build() {
    Column() {
      this.dialogContentBuilder()
    }
    .focusable(true)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#cc000000')
  }

  @Builder
  dialogContentBuilder() {
    Column() {
      this.titleBuilder()
      if (this.pinType === PinType.PAIRING_VARIANT_PASSKEY_CONFIRMATION) {
        this.contentForPinType4Builder();
      } else if (this.pinType === PinType.PAIRING_VARIANT_CONSENT ||
        this.pinType === PinType.PAIRING_VARIANT_OOB_CONSENT) {
        this.contentForPinType56Builder();
      } else if (this.pinType === PinType.PAIRING_VARIANT_DISPLAY_PASSKEY ||
        this.pinType === PinType.PAIRING_VARIANT_DISPLAY_PIN) {
        this.contentForPinType02Builder();
      } else if (this.pinType === PinType.PAIRING_VARIANT_PIN ||
        this.pinType === PinType.PAIRING_VARIANT_PIN_16_DIGITS) {
        this.contentForPinType17Builder();
      } else if (this.pinType === PinType.PAIRING_VARIANT_PASSKEY) {
        this.contentForPinType3Builder();
      }
      this.buttonBuilder()
    }
    .focusable(true)
    .backgroundColor('#404040')
    .alignItems(HorizontalAlign.Start)
    .borderRadius('24lpx')
    .width('692lpx')
  }

  @Builder
  titleBuilder() {
    Row() {
      Text($r('app.string.bluetooth_pairing_request'))
        .fontFamily('HarmonyOS Sans')
        .fontWeight(FontWeight.Medium)
        .fontSize('40lpx')
        .fontColor('#FFFFFF')
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .margin({
      top:'48lpx'
    })
  }

  @Builder
  contentForPinType4Builder() {
    Column() {
      Text($r('app.string.bt_pair_required_message', this.deviceName, this.deviceName))
        .fontFamily('HarmonyOS Sans')
        .fontWeight(FontWeight.Medium)
        .fontSize('24lpx')
        .fontColor('#ffffff')
        .margin({
          bottom:'24lpx',
        })
      Text(this.pinCode)
        .fontFamily('HarmonyOS Sans')
        .fontWeight(FontWeight.Medium)
        .fontSize('40lpx')
        .fontColor(Color.White)
        .align(Alignment.Center)
    }.margin({
      top:'48lpx',
      left:'42lpx',
      right:'42lpx'
    })
  }

  @Builder
  contentForPinType56Builder() {
    Column() {
      Text() {
        Span($r('app.string.bluetooth_pairing_media_device_hit'))
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
        Span('\n')
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
        Span(this.deviceName)
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
      }
    }
    .margin({
      top:'24lpx',
      left:'42lpx',
      right:'42lpx'
    })
  }

  @Builder
  contentForPinType02Builder() {
    Column() {
      Text() {
        Span($r('app.string.bluetooth_pairing_media_device_hit'))
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
        Span('\n')
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
        Span(this.deviceName)
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
      }

      Text() {
        Span($r('app.string.bluetooth_pin_required_code_title'))
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
        Span('\n')
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
        Span(this.pinCode)
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
      }

      Text($r('app.string.bluetooth_pin_required_please_enter_message'))
        .fontFamily('HarmonyOS Sans')
        .fontWeight(FontWeight.Medium)
        .fontSize('24lpx')
        .fontColor('#ffffff')

    }
    .alignItems(HorizontalAlign.Start)
    .margin({
      top:'24lpx',
      left:'42lpx',
      right:'42lpx'
    })
  }

  @Builder
  contentForPinType17Builder() {
    Column() {
      TextInput({ text: this.input, placeholder: $r('app.string.bluetooth_usually_message') })
        .width('90%')
        .fontSize('36lpx')
        .fontColor(this.focusId == 'defaultFocuscancelinput' ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.6)')
        .focusable(true)
        .backgroundColor(this.focusId == 'defaultFocuscancelinput'
          ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
        .caretColor(this.focusId == 'defaultFocuscancelinput' ? Color.Black:Color.White)
        .enableKeyboardOnFocus(true)
        .type(InputType.Number)
        .id('defaultFocuscancelinput')
        .defaultFocus(this.defaultFocuscancelinput)
        .onChange((value: string) => {
          this.input = value;
        })
        .onFocus(()=>{
          this.focusId = 'defaultFocuscancelinput'
          focusControl.requestFocus('defaultFocuscancelinput');
        })
        .onKeyEvent((e) => {
          if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
            this.focusId = 'cancel'
            focusControl.requestFocus('cancel');
            e.stopPropagation();
          }
        })

      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
        Text($r('app.string.bluetooth_PinConsist_message'))
          .width('100%')
          .fontFamily('HarmonyOS Sans')
          .fontWeight(FontWeight.Medium)
          .fontSize('24lpx')
          .fontColor('#ffffff')
      }
      .width('100%')
      .margin({top:'12lpx'})

      Text($r('app.string.bluetooth_pinCode_required_message'))
        .fontFamily('HarmonyOS Sans')
        .fontWeight(FontWeight.Medium)
        .fontSize('24lpx')
        .fontColor('#ffffff')
        .margin({top:'12lpx'})
    }
    .alignItems(HorizontalAlign.Start)
    .margin({
      top:'24lpx',
      left:'42lpx'
    })
  }

  @Builder
  contentForPinType3Builder() {
    Column() {
      Column() {
        TextInput({ text: this.input, placeholder: $r('app.string.bluetooth_usually_message') })
          .enableKeyboardOnFocus(true)
          .type(InputType.Number)
          .width('90%')
          .fontSize('36lpx')
          .fontColor(this.focusId == 'defaultFocuscancelinput2' ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.6)')
          .focusable(true)
          .backgroundColor(this.focusId == 'defaultFocuscancelinput2'
            ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
          .caretColor(this.focusId == 'defaultFocuscancelinput2' ? Color.Black:Color.White)

          .id('defaultFocuscancelinput2')
          .defaultFocus(this.defaultFocuscancelinput2)
          .onChange((value: string) => {
            this.input = value;
          })
          .onFocus(()=>{
            this.focusId = 'defaultFocuscancelinput2'
            focusControl.requestFocus('defaultFocuscancelinput2');
          })
          .onKeyEvent((e) => {
            if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
              this.focusId = 'cancel'
              focusControl.requestFocus('cancel');
              e.stopPropagation();
            }
          })
      }
      .justifyContent(FlexAlign.Center)

      Text($r('app.string.bluetooth_pinCode_required_message'))
        .fontFamily('HarmonyOS Sans')
        .fontWeight(FontWeight.Medium)
        .fontSize('24lpx')
        .fontColor('#ffffff')
        .margin({top:'12lpx'})
    }
    .alignItems(HorizontalAlign.Start)
    .margin({
      top:'24lpx',
      left:'42lpx'
    })
  }

  @Builder
  buttonBuilder() {
    Row() {
      Row() {
        Button($r('app.string.pair_cancel'))
          .width('248lpx')
          .height('72lpx')
          .fontWeight(500)
          .backgroundColor(this.focusId === 'cancel' ? '#DBFFFFFF' : '#33FFFFFF')
          .fontColor(this.focusId === 'cancel' ? '#DB000000' : '#DBFFFFFF')
          .fontSize('36lpx')
          .defaultFocus(this.defaultFocuscancel)
          .id('cancel')
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })
          .borderRadius('60lpx')
          .onKeyEvent(e => {
            if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
              e.type == KeyType.Up) {
              LogUtil.info(`${TAG} onClick cancel`);
              LogUtil.info(`${TAG} bluetooth pairDevice result1 onCancelClick this.deviceId=`+this.deviceId);
              LogUtil.info(`${TAG} bluetooth pairDevice result1 onCancelClick this.input=`+this.input);
              this.isOnClick = true;
              this.pairDialogController?.onCancelClick(this.deviceId, this.input);
              e.stopPropagation();
            }
          })
          .onClick(()=>{
            LogUtil.info(`${TAG} onClick cancel`);
            LogUtil.info(`${TAG} bluetooth pairDevice result1 onCancelClick this.deviceId=`+this.deviceId);
            LogUtil.info(`${TAG} bluetooth pairDevice result1 onCancelClick this.input=`+this.input);
            this.isOnClick = true;
            this.pairDialogController?.onCancelClick(this.deviceId, this.input);
          })
          .focusable(true)
      }
      .focusable(true)
      .padding('8lpx')
      .borderRadius('60lpx')
      .height('88lpx')
      .border({
        width: '2lpx',
        color: this.focusId === 'cancel' ? '#ffffff' : 'transparent'
      })

      // 3.按钮
      if (this.pinType !== PinType.PAIRING_VARIANT_DISPLAY_PASSKEY &&
        this.pinType !== PinType.PAIRING_VARIANT_DISPLAY_PIN) {
        Row() {
          Button($r('app.string.bluetooth_pair_button'))
            .width('248lpx')
            .height('72lpx')
            .fontSize('36lpx')
            .fontWeight(500)
            .backgroundColor(this.focusId === 'sure' ? '#DBFFFFFF' : '#33FFFFFF')
            .fontColor(this.focusId === 'sure' ? '#DB000000' : '#DBFFFFFF')
            .focusable(true)
            .id('sure')
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent
                })
              }
            })
            .borderRadius('60lpx')
            .onKeyEvent(e => {
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                LogUtil.info(`${TAG} onClick pair`);
                LogUtil.info(`${TAG} bluetooth pairDevice result1 onPairClick this.deviceId=`+this.deviceId);
                LogUtil.info(`${TAG} bluetooth pairDevice result1 onPairClick this.input=`+this.input);
                this.isOnClick = true;
                this.pairDialogController?.onPairClick(this.deviceId, this.input);
                e.stopPropagation();
              }
            })
            .onClick(()=>{
              LogUtil.info(`${TAG} onClick pair`);
              LogUtil.info(`${TAG} bluetooth pairDevice result1 onPairClick this.deviceId=`+this.deviceId);
              LogUtil.info(`${TAG} bluetooth pairDevice result1 onPairClick this.input=`+this.input);
              this.isOnClick = true;
              this.pairDialogController?.onPairClick(this.deviceId, this.input);
            })
        }
        .focusable(true)
        .padding('8lpx')
        .borderRadius('60lpx')
        .height('88lpx')
        .border({
          width: '2lpx',
          color: this.focusId === 'sure' ? '#ffffff' : 'transparent'
        })
      }
    }
    .focusable(true)
    .width('100%')
    .margin({ top: '48lpx', bottom: '30lpx' })
    .justifyContent(FlexAlign.SpaceAround)
    .onKeyEvent(e => {
      if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Up) {
        this.focusId = 'cancel'
        focusControl.requestFocus('cancel');
        e.stopPropagation();
      }
      if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Up) {
        if(this.pinType !== PinType.PAIRING_VARIANT_DISPLAY_PASSKEY &&
          this.pinType !== PinType.PAIRING_VARIANT_DISPLAY_PIN){
          this.focusId = 'sure'
          focusControl.requestFocus('sure');
          e.stopPropagation();
        }
      }
      if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
        if (this.pinType === PinType.PAIRING_VARIANT_PIN ||
          this.pinType === PinType.PAIRING_VARIANT_PIN_16_DIGITS) {
          this.defaultFocuscancelinput2=false
          this.defaultFocuscancel=false
          this.defaultFocuscancelinput=true
          this.focusId = 'defaultFocuscancelinput'
          focusControl.requestFocus('defaultFocuscancelinput');
          e.stopPropagation();
        } else if (this.pinType === PinType.PAIRING_VARIANT_PASSKEY) {
          this.defaultFocuscancel=false
          this.defaultFocuscancelinput=false
          this.defaultFocuscancelinput2=true
          this.focusId = 'defaultFocuscancelinput2'
          focusControl.requestFocus('defaultFocuscancelinput2');
          e.stopPropagation();
        }
      }
    })
  }

  aboutToAppear(): void {
    let keyDownOpt: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUpOpt: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let eventDown: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventDown, 'KeyEvent', keyDownOpt)
    let eventUp: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventUp, 'KeyEvent', keyUpOpt)

    try {
      inputEventClient.injectEvent(eventDown as never);
      inputEventClient.injectEvent(eventUp as never);
      console.log('手动触发tab点击成功')
    } catch (e) {
      console.log('手动触发tab点击失败')
    }
    if (this.pinType === PinType.PAIRING_VARIANT_PASSKEY_CONFIRMATION) {
      this.focusId = 'cancel'
      this.defaultFocuscancelinput=false
      this.defaultFocuscancelinput2=false
      this.defaultFocuscancel=true
      focusControl.requestFocus('cancel');
    } else if (this.pinType === PinType.PAIRING_VARIANT_CONSENT ||
      this.pinType === PinType.PAIRING_VARIANT_OOB_CONSENT) {
      this.focusId = 'cancel'
      this.defaultFocuscancelinput=false
      this.defaultFocuscancelinput2=false
      this.defaultFocuscancel=true
      focusControl.requestFocus('cancel');
    } else if (this.pinType === PinType.PAIRING_VARIANT_DISPLAY_PASSKEY ||
      this.pinType === PinType.PAIRING_VARIANT_DISPLAY_PIN) {
      this.focusId = 'cancel'
      this.defaultFocuscancelinput=false
      this.defaultFocuscancelinput2=false
      this.defaultFocuscancel=true
      focusControl.requestFocus('cancel');
    } else if (this.pinType === PinType.PAIRING_VARIANT_PIN ||
      this.pinType === PinType.PAIRING_VARIANT_PIN_16_DIGITS) {
      this.defaultFocuscancelinput2=false
      this.defaultFocuscancel=false
      this.defaultFocuscancelinput=true
      this.focusId = 'defaultFocuscancelinput'
      focusControl.requestFocus('defaultFocuscancelinput');
    } else if (this.pinType === PinType.PAIRING_VARIANT_PASSKEY) {
      this.defaultFocuscancel=false
      this.defaultFocuscancelinput=false
      this.defaultFocuscancelinput2=true
      this.focusId = 'defaultFocuscancelinput2'
      focusControl.requestFocus('defaultFocuscancelinput2');
    }
    LogUtil.info(`${TAG} aboutToAppear pinType: ${this.pinType}`);
    this.pairDialogController = new PairDialogController(this.pinType, this.controller);
    this.pairDialogController?.init();
    this.deviceName = BluetoothModel.getDeviceName(this.deviceId);
    if (this.pinType === PinType.PAIRING_VARIANT_DISPLAY_PIN) {
      connection.setDevicePinCode(this.deviceId, this.pinCode ?? '');
    }
    if (display.isFoldable()) {
      try {
        Display.on('foldStatusChange', (status: number) => {
          this.handleFoldStateChange(status);
        });
      } catch (err) {
        LogUtil.error(`${TAG} aboutToAppear pinType: ${this.pinType}`);
      }
    }
  }

  private handleFoldStateChange(status: number): void {
    LogUtil.info(`${TAG} on fold status changed: ${status}`);
    if (status === Display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.dialogWidth = '100%';
      this.paddingValue = $r('sys.float.padding_level8');
    } else {
      this.dialogWidth = 400;
      this.paddingValue = 0;
    }
  }

  aboutToDisappear(): void {
    LogUtil.info(`${TAG} aboutToDisappear ${this.isOnClick}`);
    if (!this.isOnClick) {
      this.pairDialogController?.onCancelClick(this.deviceId, this.input);
    }
    if (display.isFoldable()) {
      try {
        Display.off('foldStatusChange');
      } catch (e) {
        LogUtil.error(`${TAG} unregister foldStatusChange ${e?.message}`);
      }
    }
  }

}

export enum AccessAuthorization {
  UNKNOWN = 0,
  ALLOWED = 1,
  REJECTED = 2,
}

export enum ShareType {
  SHARE_NAME_AND_PHONE_NUMBER = 0,
  SHARE_ALL = 1,
  SHARE_NOTHING = 2
}

class PairDialogController {
  public deviceName: string = '';
  private controller?: CustomDialogController;
  private bluetoothDeviceController: BluetoothDeviceController = new BluetoothDeviceController();
  private pinType: number = -1;
  private pbapServerProfile = pbap.createPbapServerProfile();

  constructor(pinType: number, controller?: CustomDialogController) {
    this.pinType = pinType;
    this.controller = controller;
  }

  init(): void {
    this.bluetoothDeviceController
      .initData()
      .subscribe();
  }

  onPairClick(deviceId: string,  input?: string): void {
    LogUtil.info(`${TAG} onPairClick, deviceId: ${deviceId}, pinType: ${this.pinType}`);
    let pinType: number = this.pinType;
    if (pinType === PinType.PAIRING_VARIANT_PASSKEY_CONFIRMATION || pinType === PinType.PAIRING_VARIANT_CONSENT) {
      this.onPairClickForPinType45(deviceId);
    } else if (pinType === PinType.PAIRING_VARIANT_OOB_CONSENT) {
      this.onPairClickForPinType02ForOther(deviceId);
    } else if (pinType === PinType.PAIRING_VARIANT_DISPLAY_PASSKEY || pinType === PinType.PAIRING_VARIANT_DISPLAY_PIN) {
      this.onPairClickForPinType02ForOther(deviceId);
    } else if (pinType === PinType.PAIRING_VARIANT_PIN || pinType === PinType.PAIRING_VARIANT_PIN_16_DIGITS ||
      pinType === PinType.PAIRING_VARIANT_PASSKEY) {
      this.onPairClickForPinType137(deviceId,input);
    }
    this.closeDialog();
  }

  onCancelClick(deviceId: string, input?: string): void {
    LogUtil.info(`${TAG} onCancelClick, deviceId: ${deviceId}, pinType: ${this.pinType}`);
    let pinType: number = this.pinType;
    if (pinType === PinType.PAIRING_VARIANT_PASSKEY_CONFIRMATION || pinType === PinType.PAIRING_VARIANT_CONSENT) {
      this.onCancelClickForPinType45(deviceId);
    } else if (pinType === PinType.PAIRING_VARIANT_OOB_CONSENT) {
      this.onCancelClickForPinType02ForOther(deviceId);
    } else if (pinType === PinType.PAIRING_VARIANT_DISPLAY_PASSKEY || pinType === PinType.PAIRING_VARIANT_DISPLAY_PIN) {
      this.onCancelClickForPinType02ForOther(deviceId);
    } else if (pinType === PinType.PAIRING_VARIANT_PIN || pinType === PinType.PAIRING_VARIANT_PIN_16_DIGITS ||
      pinType === PinType.PAIRING_VARIANT_PASSKEY) {
      this.onCancelClickForPinType137(deviceId, input);
    }
    this.closeDialog();
  }

  private onPairClickForPinType137(deviceId: string, input?: string): void {
    let accessAuthorizationParams: AccessAuthorization;
    let shareTypeParams: ShareType;
    accessAuthorizationParams = AccessAuthorization.ALLOWED;
    shareTypeParams = ShareType.SHARE_NAME_AND_PHONE_NUMBER;
    LogUtil.info(`${TAG} onPairClickForPinType137 onButton3Click`);
    try {
      this.pbapServerProfile.setPhoneBookAccessAuthorization(deviceId, accessAuthorizationParams);
      this.pbapServerProfile.setShareType(deviceId, shareTypeParams);
      connection.setDevicePinCode(deviceId, input ?? '');
    } catch (err) {
      LogUtil.error('${TAG} onPairClickForPinType137 failed , BusinessError is ' + JSON.stringify(err));
    }
  }

  private onPairClickForPinType02ForOther(deviceId: string): void {
    let accessAuthorizationParams: AccessAuthorization;
    let shareTypeParams: ShareType;
    accessAuthorizationParams = AccessAuthorization.ALLOWED;
    shareTypeParams = ShareType.SHARE_NAME_AND_PHONE_NUMBER;
    LogUtil.info('${TAG} onPairClickForPinType02ForOther onButton3Click');
    try {
      this.pbapServerProfile.setPhoneBookAccessAuthorization(deviceId, accessAuthorizationParams);
      this.pbapServerProfile.setShareType(deviceId, shareTypeParams);
    } catch (err) {
      LogUtil.error('${TAG} onPairClickForPinType02ForOther failed , BusinessError is ' + JSON.stringify(err));
    }
  }

  private onPairClickForPinType45(deviceId: string): void {
    let accessAuthorizationParams: AccessAuthorization;
    let shareTypeParams: ShareType;
    accessAuthorizationParams = AccessAuthorization.ALLOWED;
    shareTypeParams = ShareType.SHARE_NAME_AND_PHONE_NUMBER;
    LogUtil.info(`${TAG} setShareType onPairClickForPinType45`);
    try {
      this.pbapServerProfile.setPhoneBookAccessAuthorization(deviceId, accessAuthorizationParams);
      this.pbapServerProfile.setShareType(deviceId, shareTypeParams);
      connection.setDevicePairingConfirmation(deviceId, true);
    } catch (err) {
      LogUtil.error('${TAG} onPairClickForPinType45 failed , BusinessError is ' + JSON.stringify(err));
    }
  }

  private onCancelClickForPinType137(deviceId: string, input?: string): void {
    LogUtil.info(`[${TAG}] onCancelClickForPinType137 onCancelPair`);
    try {
      this.pbapServerProfile.setPhoneBookAccessAuthorization(deviceId, AccessAuthorization.REJECTED);
      this.pbapServerProfile.setShareType(deviceId, ShareType.SHARE_NOTHING);
      connection.setDevicePairingConfirmation(deviceId, false);
    } catch (err) {
      LogUtil.error('${TAG} onCancelClickForPinType137 failed , BusinessError is ' + JSON.stringify(err));
    }
  }

  private onCancelClickForPinType45(deviceId: string): void {
    LogUtil.info(`[${TAG}] onCancelClickForPinType45 onCancelPair`);
    try {
      this.pbapServerProfile.setPhoneBookAccessAuthorization(deviceId, AccessAuthorization.REJECTED);
      this.pbapServerProfile.setShareType(deviceId, ShareType.SHARE_NOTHING);
      connection.setDevicePairingConfirmation(deviceId, false);
    } catch (err) {
      LogUtil.error('${TAG} onCancelClickForPinType45 failed , BusinessError is ' + JSON.stringify(err));
    }
  }

  private onCancelClickForPinType02ForOther(deviceId: string): void {
    LogUtil.info(`[${TAG}] onCancelClickForPinType02ForOther onCancelPair`);
    try {
      this.pbapServerProfile.setPhoneBookAccessAuthorization(deviceId, AccessAuthorization.REJECTED);
      this.pbapServerProfile.setShareType(deviceId, ShareType.SHARE_NOTHING);
      connection.cancelPairingDevice(deviceId);
    } catch (err) {
      LogUtil.error('${TAG} onCancelClickForPinType02ForOther failed , BusinessError is ' + JSON.stringify(err));
    }
  }

  private closeDialog(): void {
    this.controller?.close;
    this.bluetoothDeviceController.unsubscribe();
    (AppStorage.get<UIExtensionContentSession>(`dialogSession`) as UIExtensionContentSession)?.terminateSelf();
  }
}

