import LogManager from '../../common/Log/LogManager'
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI'
import { systemParameter } from '@kit.BasicServicesKit'
import { preferences } from '@kit.ArkData'
import { fpChangeLpx, vpChangeLpx } from '../IssueReporter/models/IssueDetailInfo'

const TAG = 'NavigationBar'

@Component
export default struct NavigationBar {
  title: ResourceStr = ''
  rightItemImage: Resource = $r('app.media.icon_add')
  isHiddenBack: boolean = false
  isHiddenRight: boolean = true
  isHiddenTitle: boolean = false
  onClickBackHandle?: () => void
  onClickRightItemHandle?: () => void
  private dataPreferences:preferences.Preferences = preferences.getPreferencesSync(getContext(this), { name: 'myStore' });
  @State isOpen: boolean =  this.dataPreferences.getSync('openLog', false) as boolean

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(fpChangeLpx(54))
          .fontColor($r('app.color.default_white'))
          .visibility(!this.isHiddenTitle ? Visibility.Visible : Visibility.Hidden)
      }
      .focusable(false)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height('100%')

    }
    .width('100%')
    .height(vpChangeLpx(100))
    .alignItems(HorizontalAlign.Center)
    .margin({ top: vpChangeLpx(76)})
  }
}