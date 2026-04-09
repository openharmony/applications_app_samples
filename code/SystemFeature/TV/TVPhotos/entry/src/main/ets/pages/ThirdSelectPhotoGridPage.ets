import { Constants } from '../common/Constants';
import { EventUtil } from '../common/EventUtil';
import Logger from '../common/Logger';
import { ThirdSelectPhotoGridBase } from './components/ThirdSelectPhotoGridBase';

let localStorage = LocalStorage.getShared();
const TAG = 'ThirdSelectPhotoGridPage';

@Entry(localStorage)
@Component
struct ThirdSelectPhotoGridPage {
  @State isFirstEnter: boolean = false;
  @State pageStatus: boolean = false;

  onPageShow() {
    this.pageStatus = true;
  }

  onPageHide() {
    this.pageStatus = false;
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.Pop, duration: 300 })
      .opacity(1)
    PageTransitionExit({ type: RouteType.Push, duration: 300 })
      .opacity(1)
  }

  build() {
    Column() {
      ThirdSelectPhotoGridBase({
        pageStatus: this.pageStatus,
        isFirstEnter: this.isFirstEnter
      })
        .transition({ type: TransitionType.All, opacity: 0 })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.main_color'))
    .onTouch((event) => {
      if (event.type === TouchType.Down) {
        EventUtil.inputTab();
      }
      if (!EventUtil.isTouchEvent(event)) {
        return;
      }
      if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
        return;
      }
    })
  }
}