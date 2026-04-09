import { StyleConstants } from '../../common/constants/StyleConstants';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';

const TAG = "SettingBackGround";

@Component
export struct SettingBackground {

  aboutToAppear() {
    LogUtil.info(TAG + ' aboutToAppear')
  }

  build() {
    Column()
      .height(ConfigData.WH_100_100)
      .width(ConfigData.WH_100_100)
      .backgroundColor('rgb(24, 24, 26)')
  }
}