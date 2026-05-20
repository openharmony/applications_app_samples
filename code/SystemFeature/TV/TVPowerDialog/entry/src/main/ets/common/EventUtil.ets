import { PointerUtil } from "./PointerUtil";

/**
 * 事件相关工具类
 */
export class EventUtil {
  /**
   * 判断是否触发触摸事件
   * @returns 判断结果
   */
  static isTouchEvent(event: TouchEvent): boolean {


    PointerUtil.changePointStyle(event.type == TouchType.Down)

    if (event.type == TouchType.Down) {
      return false;
    }

    return event.source == SourceType.Mouse || event.source == SourceType.TouchScreen
  }
}