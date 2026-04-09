import { inputEventClient, KeyCode } from '@kit.InputKit';

/**
 * 事件相关工具类
 */
export class EventUtil {
  /**
   * 判断是否触发触摸事件
   * @returns 判断结果
   */
  static isTouchEvent(event: TouchEvent): boolean {


    if (event.type == TouchType.Down) {
      return false;
    }

    return event.source == SourceType.Mouse || event.source == SourceType.TouchScreen
  }

  public static inputTab() {
    let tabDown: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 1,
      isIntercepted: false
    }
    inputEventClient.injectKeyEvent({ keyEvent: tabDown })
    let tabUp: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    }
    inputEventClient.injectKeyEvent({ keyEvent: tabUp })
  }
}