import NavigationBar from '../common/NavigationBar'
import IssueDetailInfo, {
  Attachment,
  fpChangeLpx,
  probabilityList,
  TIME_INT_VIS,
  vpChangeLpx
} from '../IssueReporter/models/IssueDetailInfo'
import router from '@ohos.router';
import LogManager from '../../common/Log/LogManager'
import NetworkManager from '../../common/Network/NetworkManager';
import UrlConstant from '../../common/Constants/UrlConstant';
import promptAction from '@ohos.promptAction';
import DeviceManager from '../../common/Device/DeviceManager';
import { stringToObject } from '../common/utilImage';
import issueReportCardItem from './views/issueReportCardItem'
import issueAttachment from './views/issueAttachment'
import issueReportHistory from './views/issueReportHistory'
import ImagePreViewDialog from './views/ImagePreViewDialog'
import { inputEventClient, KeyCode } from '@kit.InputKit';

const TAG = 'IssueReporterDetail'

class IssueDetailParam {
  issueId: string = ''
  devid: string = ''
}

class IssueHistory {
  title: string = ''
  time: string = ''
  content?: string = ''
}

class IssueHistoryRecord {
  title: string = ''
  createTime: string = ''
  content?: string = ''
}


@Entry
@Component
export default struct IssueReporterDetail {
  scroller: Scroller = new Scroller()
  @State private issueId: string = ''
  @State private statusDesc: string = ''
  @State private probabilityDesc: string = ''
  @State private description: string = ''
  @State private faultTime: string = ''
  @State private remark: string = ''
  @State private attachment: Attachment[] = []
  @State previewImage: boolean = false
  @State previewImageIndex: number = 0
  @State issueHistory: IssueHistory[] = []
  @State private issueType: string = ''

  aboutToAppear() {
    LogManager.hilogIWithTag(TAG, `aboutToAppear enter`)

    this.getDetail()
    this.getHistory()
  }

  tabClick() {
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

    class KeyEvent {
      KeyEvent: inputEventClient.KeyEvent | null = null
    }

    let eventDown: KeyEvent = { KeyEvent: keyDownOpt }
    let eventUp: KeyEvent = { KeyEvent: keyUpOpt }

    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent(eventDown);
      inputEventClient.injectEvent(eventUp);
    } catch (err) {
      console.error('settingList inputEventClient' + err)
    }
  }

  private getDetail() {
    let params = router.getParams() as IssueDetailInfo

    let issueDetailParam: IssueDetailParam = {
      issueId: params.issueId,
      devid: DeviceManager.shareInstance().getUdid()
    }

    NetworkManager.shareInstance().request(UrlConstant.ISSUE_DETAIL, issueDetailParam, (listErr, listResult) => {
      LogManager.hilogIWithTag(TAG, `getDetail, err: ${JSON.stringify(listErr)}, result: ${JSON.stringify(listResult)}`)
      LogManager.hilogIWithTag(TAG, `getDetail, err111: ${JSON.stringify(listErr)}`)
      LogManager.hilogIWithTag(TAG, `getDetail, err111: ${listErr}`)

      if (listErr) {
        promptAction.showToast({
          message: '详情获取失败'
        })
        return
      }
      listResult.result = stringToObject(listResult.result)
      let code = listResult.responseCode as number
      LogManager.hilogIWithTag(TAG, `getDetail, code: ${JSON.stringify(code)}`)

      if (code != 200) {
        promptAction.showToast({
          message: '详情获取失败'
        })
        return
      }

      if (listResult.result['data']) {
        this.issueId = listResult.result['data']['issueId'] ? listResult.result['data']['issueId'] : ''
        this.statusDesc = listResult.result['data']['statusDesc'] ? listResult.result['data']['statusDesc'] : ''
        this.probabilityDesc =
          listResult.result['data']['probability'] ? listResult.result['data']['probability'] : ''
        this.description = listResult.result['data']['description'] ? listResult.result['data']['description'] : ''
        this.faultTime = listResult.result['data']['faultTime'] ? listResult.result['data']['faultTime'] : ''
        this.remark = listResult.result['data']['remark'] ? listResult.result['data']['remark'] : ''
        this.attachment = listResult.result['data']['attachment'] ? listResult.result['data']['attachment'] : []
        this.issueType = listResult.result['data']['type'] ? listResult.result['data']['type'] : ''
      }
    })
  }

  private getHistory() {
    let params = router.getParams() as IssueDetailInfo

    let issueDetailParam: IssueDetailParam = {
      issueId: params.issueId,
      devid: DeviceManager.shareInstance().getUdid()
    }
    NetworkManager.shareInstance()
      .request(UrlConstant.ISSUE_OPERATION_RECORD, issueDetailParam, (listErr, listResult) => {
        LogManager.hilogIWithTag(TAG,
          `getHistory, err: ${JSON.stringify(listErr)}, result: ${JSON.stringify(listResult)}`)
        if (listErr) {
          promptAction.showToast({
            message: '详情获取失败'
          })
          return
        }
        listResult.result = stringToObject(listResult.result)
        // let code = listResult.result['code'] as number
        let code = listResult.responseCode as number
        LogManager.hilogIWithTag(TAG, `getDetail, code: ${JSON.stringify(code)}`)

        if (code != 200) {
          promptAction.showToast({
            message: '详情获取失败'
          })
          return
        }
        if (listResult.result['data'] && listResult.result['data'].records) {
          const reg: RegExp = new RegExp('\\w.*]')
          this.issueHistory = listResult.result['data'].records.map((item: IssueHistoryRecord) => {
            if (reg.test(item.title)) {
              const history: IssueHistory = {
                title: item.title.replace(reg, '管理员-'),
                time: item.createTime,
                content: item.content || ''
              }
              return history
            } else {
              const newReg = new RegExp('\\w.*,')
              const history: IssueHistory = { title: item.title.replace(newReg, '').trim(), time: item.createTime }
              return history
            }
          }
          )
        }
      }
      )
  }

  @Builder
  attachmentTitle() {
    Column() {
      Text($r('app.string.attachment'))
        .fontSize(fpChangeLpx(36))
        .fontWeight(500)
        .fontColor($r('app.color.default_white'))
        .margin({ bottom: vpChangeLpx(24), top: vpChangeLpx(42) })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Column() {
        NavigationBar({
          title: '问题单详情',
          rightItemImage: $r('app.media.icon_add'),
          isHiddenRight: true,
          isHiddenBack: false,
        })
          .padding({ left: vpChangeLpx(449), right: vpChangeLpx(449) })

        Scroll(this.scroller) {
          Column() {
            Column({ space: vpChangeLpx(24) }) {
              issueReportCardItem({
                itemLabel: '问题单号:',
                itemValue: this.issueId,
                isBold: true,
              })
              issueReportCardItem({
                itemLabel: '问题概率:',
                itemValue: this.probabilityDesc,
              })
              issueReportCardItem({
                itemLabel: '问题类型:',
                itemValue: this.issueType,
              })
              issueReportCardItem({
                itemLabel: '创建时间:',
                itemValue: this.faultTime,
              })
              issueReportCardItem({
                itemLabel: '问题描述:',
                itemValue: this.description,
                isDecItem: true
              })
            }
            .backgroundColor($r('app.color.global_default_background'))
            .borderRadius(10)

            issueAttachment({
              thumbnails: this.attachment,
              previewImage: this.previewImage,
              canEdit: false,
              previewImageIndex: this.previewImageIndex,
              titleBuilderParam: this.attachmentTitle,
            })

            issueReportHistory({ issueHistory: this.issueHistory })
          }
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .align(Alignment.Top)
        .padding({ left: vpChangeLpx(449), right: vpChangeLpx(449), top: vpChangeLpx(41) })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.global_default_background'))

      if (this.previewImage) {
        ImagePreViewDialog({
          attachment: this.attachment,
          previewImage: this.previewImage,
          previewImageIndex: this.previewImageIndex
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.global_default_background'))
    .onKeyEvent((event) => {
      console.log('TextPickerDialog:onChange()' + 'onKeyEvent 3')
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        router.back()
      }
    })
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio >= 1.0) {
        setTimeout(() => {
          this.tabClick();
        }, TIME_INT_VIS)
      }
    })
  }
}