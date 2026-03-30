import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import CommonConstants from '../../common/CommonConstants';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State serialQueueResult: string = 'Not Executed';

  build() {
        Column({ space: CommonConstants.COLUMN_SPACE }) {
          Row() {
            Text($r('app.string.title'))
              .fontSize($r('app.float.title_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height($r('app.float.title_text_height'))
              .align(Alignment.Center)
              .maxLines(CommonConstants.TITLE_MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .height($r('app.float.title_height'))
          .width(CommonConstants.FILL_PARENT)
          .justifyContent(FlexAlign.Center)
          Row() {
            Text($r('app.string.FFRT_SerialQueue_des'))
              .fontSize($r('app.float.text_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height($r('app.float.description_text_height'))
              .align(Alignment.Start)
              .maxLines(CommonConstants.TEXT_MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .padding({ left: $r('app.float.text_padding'), right: $r('app.float.text_padding') })
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
          Row() {
            Text(this.serialQueueResult)
              .fontSize($r('app.float.output_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
          }
          .width(CommonConstants.PARTIAL_PARENT)
          .borderRadius($r('app.float.display_area_border_radius'))
          .height($r('app.float.display_area_height'))
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
          .backgroundColor(Color.White)
          Row() {
            Button($r('app.string.FFRT_SerialQueue_lable'))
              .id("FFRTSerialQueueC")
              .fontSize($r('app.float.button_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height(CommonConstants.FILL_PARENT)
              .width($r('app.float.button_width'))
              .onClick(() => {
                this.serialQueueResult = 'Submit Success C';
                hilog.info(DOMAIN, 'TestTag', 'FFRT Serial Queue C Demo %{public}d', testNapi.serial_queue_exec(true));
              })
          }
          .height($r('app.float.button_height'))
          .width(CommonConstants.FILL_PARENT)
          .justifyContent(FlexAlign.Center)
          .margin({ top: $r('app.float.button_margin'), bottom: $r('app.float.button_margin')})
          Row() {
            Button($r('app.string.FFRT_SerialQueue_Cpp_lable'))
              .id("FFRTSerialQueueCpp")
              .fontSize($r('app.float.button_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height(CommonConstants.FILL_PARENT)
              .width($r('app.float.button_width'))
              .onClick(() => {
                this.serialQueueResult = 'Submit Success Cpp';
                hilog.info(DOMAIN, 'TestTag', 'FFRT Serial Queue Cpp Demo %{public}d', testNapi.serial_queue_exec(false));
              })
          }
          .height($r('app.float.button_height'))
          .width(CommonConstants.FILL_PARENT)
          .justifyContent(FlexAlign.Center)
          .margin({ top: $r('app.float.button_margin'), bottom: $r('app.float.button_margin')})
          Row() {
            Text($r('app.string.Print_des'))
              .fontSize($r('app.float.text_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height($r('app.float.description_text_height'))
              .align(Alignment.Start)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .padding({ left: $r('app.float.text_padding'), right: $r('app.float.text_padding') })
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
        }
        .width(CommonConstants.FILL_PARENT)
        .height(CommonConstants.FILL_PARENT)
        .backgroundColor($r('app.color.background_color'))
    }
}
