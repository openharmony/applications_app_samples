import power from '@ohos.power';
import { PowerItemInfo } from '../model/PowerItemInfo'
import { KeyCode } from '../common/KeyCode'
import Logger from '../common/Logger'
import { PowerOperation } from '../common/constant';
import { LengthMetrics } from '@kit.ArkUI';
import { PointerUtil } from '../common/PointerUtil';
import { EventUtil } from '../common/EventUtil';
import { UIExtensionContentSession } from '@kit.AbilityKit';
import { commonEventPowerDataFunc } from '../common/CommonEventUtil';

const TAG = 'PowerCustomDialog';

@Entry
@Component
struct PowerDialog {
  @State list: PowerItemInfo[] = []

  aboutToAppear() {
    let app1 = new PowerItemInfo('app.media.screenout', 'app.media.screenout_focus', false, '熄屏',
      PowerOperation.POWEROPERATION_SUSPEND)
    let app2 = new PowerItemInfo('app.media.shutdown', 'app.media.shutdown_focus', true, '关机',
      PowerOperation.POWEROPERATION_SHUTDOWN)
    let app3 = new PowerItemInfo('app.media.reboot', 'app.media.reboot_focus', false, '重启',
      PowerOperation.POWEROPERATION_REBOOT)
    this.list.push(app1, app2, app3)
    this.getUIContext().getFocusController().activate(true, false)
    PointerUtil.changePointStyle(false);
  }
  aboutToDisappear(): void {
    this.getUIContext().getFocusController().activate(false)
  }

  onBackPress(): boolean | void {
    if (globalThis.session) {
      globalThis.session.terminateSelf()
    }
  }

  onDidBuild(): void {
    if (globalThis.session) {
      (globalThis.session as UIExtensionContentSession ).sendData({
        isReady:'1'
      })
    }
  }

  build() {
    Row() {
      ForEach(this.list, (item: PowerItemInfo, index: number) => {
        FocusMethod({
          powerItemInfo: item, index
        });
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#DB000000')
    .onTouch((event) => {
      EventUtil.isTouchEvent(event);
    })
  }
}

@Component
struct FocusMethod {
  @ObjectLink powerItemInfo: PowerItemInfo
  index: number = -1

  build() {
    Flex({ direction: FlexDirection.Column, alignContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Column() {
        Image(this.powerItemInfo.isFocus ? $r(this.powerItemInfo.onFocusIcon) : $r(this.powerItemInfo.icon))
          .objectFit(ImageFit.Fill)
          .aspectRatio(1)
          .width('200lpx')
          .focusable(true)
          .defaultFocus(this.index == 1)
          .id(this.index.toString())
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          })
      }.padding('8lpx')
      .width('200lpx')
      .height('200lpx')
      .border({
        radius: '100lpx',
        width: this.powerItemInfo.isFocus ? '6lpx' : 0,
        color: Color.White
      })

      Text(this.powerItemInfo.name)
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .fontSize('36lpx')
        .margin({ top: '55lpx' })
    }
    .id(this.powerItemInfo.name)
    .focusable(true)
    .onHover((isHover) => {
      this.powerItemInfo.isFocus = isHover
      focusControl.requestFocus(this.index.toString())
    })
    .onFocus(() => {
      this.powerItemInfo.isFocus = true
    })
    .onBlur(() => {
      this.powerItemInfo.isFocus = false
    })
    .onKeyEvent((event) => {
      if (event.type === 1 && event.keyCode === KeyCode.KEY_ENTER) {
        if (this.powerItemInfo.operationType === PowerOperation.POWEROPERATION_SUSPEND) {
          try {
            // 所有的熄屏逻辑在systemui项目中
            commonEventPowerDataFunc(true);
            globalThis.extensionContext.terminateSelf();
            Logger.info(TAG, 'suspend succeeded')
          } catch (err) {
            Logger.error(TAG, 'suspend failed. info:' + JSON.stringify(err))
          }
        }
        if (this.powerItemInfo.operationType === PowerOperation.POWEROPERATION_REBOOT) {
          try {
            power.reboot('power_dialog');
            Logger.info(TAG, 'reboot succeeded')
          } catch (err) {
            Logger.error(TAG, 'reboot failed. info:' + JSON.stringify(err))
          }
        }
        if (this.powerItemInfo.operationType === PowerOperation.POWEROPERATION_SHUTDOWN) {
          try {
            power.shutdown('');
            Logger.info(TAG, 'shutdown succeeded')
          } catch (err) {
            Logger.error(TAG, 'shutdown failed. info:' + JSON.stringify(err))
          }
        }
      }
    })
    .onTouch((event) => {
      if (!EventUtil.isTouchEvent(event)) {
        return;
      }

      if (this.powerItemInfo.operationType === PowerOperation.POWEROPERATION_SUSPEND) {
        try {
          globalThis.session.terminateSelf()
          globalThis.extensionContext.terminateSelf();
            power.suspend()
            Logger.info(TAG, 'suspend succeeded')
        } catch (err) {
          Logger.error(TAG, 'suspend failed. info:' + JSON.stringify(err))
        }
      }
      if (this.powerItemInfo.operationType === PowerOperation.POWEROPERATION_REBOOT) {
        try {
          power.reboot('power_dialog');
          Logger.info(TAG, 'reboot succeeded')
        } catch (err) {
          Logger.error(TAG, 'reboot failed. info:' + JSON.stringify(err))
        }
      }
      if (this.powerItemInfo.operationType === PowerOperation.POWEROPERATION_SHUTDOWN) {
        try {
          power.shutdown('');
          Logger.info(TAG, 'shutdown succeeded')
        } catch (err) {
          Logger.error(TAG, 'shutdown failed. info:' + JSON.stringify(err))
        }
      }
    })
    .height('297lpx')
    .width('200lpx')
    .margin({ right: '3.5%', left: '3.5%' })
  }
}
