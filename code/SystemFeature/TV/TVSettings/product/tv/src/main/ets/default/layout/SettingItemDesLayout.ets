import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/lpx'

const TAG = "SettingItemDesLayout";

@Component
export struct SettingItemDesLayout {
  @Prop imageUrl: string
  @Prop des: string | Resource;

  aboutToAppear() {
    LogUtil.info(TAG + ' aboutToAppear')
  }

  build() {
    Column() {
      Image($r(this.imageUrl))
        .width(ConfigData.WH_40_100)// .height(ConfigData.WH_50_100)
        .objectFit(ImageFit.Contain)
        .aspectRatio(1)

      Text(this.des)
        .fontColor('rgba(255, 255, 255, 0.2)')
        .fontSize(lpx(36))
        .margin({
          top: lpx(24)
        })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}