import IssueDetailInfo, {
  statusList,
  IssueUpdateTime,
  fpChangeLpx,
  vpChangeLpx,
  TIME_INT_VIS,
  PROMPT_TIME
} from '../models/IssueDetailInfo'
import router from '@ohos.router';
import { PullToRefresh } from '@ohos/pulltorefresh'
import KeyConstant from '../../../common/Constants/KeyConstant';
import DeviceManager from '../../../common/Device/DeviceManager';
import NetworkManager from '../../../common/Network/NetworkManager';
import UrlConstant from '../../../common/Constants/UrlConstant';
import LogManager from '../../../common/Log/LogManager';
import promptAction from '@ohos.promptAction';
import KvManagerService from '../../../common/kvManager/kvManagerService';
import issueReportCardItem from './issueReportCardItem'
import { http } from '@kit.NetworkKit';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import NavigationBar from '../../common/NavigationBar';
import { KeyCode } from '@kit.InputKit';
import { tabClick } from '../../Index';
import { ANIMATION_FIVE } from '../../../common/Constants/TypeData';
import { EventUtil } from '../../common/EventUtil';
import { enterClick } from './issueReportSelectItem';

class Page {
  public current: number = 0
  public size: number = 0
  public devid: string = ''
  public pages?: number
  public total?: number
}

const TAG = 'IssueReporterList'
const sourceToolMouseClick: number = 7

@Entry
@Component
export default struct IssueReporterList {
  @State issueDetailAllInfos: IssueDetailInfo[] = []
  @State issueDetailInfos: IssueDetailInfo[] = []
  @State issueDetailNewInfos: IssueDetailInfo[] = []
  public onClickItemHandle?: (index: number) => void
  scroller: Scroller = new Scroller()
  private page: Page = new Page()
  @StorageLink('isNeedRefresh') @Watch('needRefresh') isNeedRefresh: boolean = false
  @StorageLink('issueInfoCaches') cacheIssueInfos: IssueDetailInfo[] = []
  @State currentIndex: number = 0

  aboutToAppear() {
    this.loadIssueList()
    tabClick();
  }

  aboutToDisappear() {
    const cacheIssueInfos: IssueDetailInfo[] = this.cacheIssueInfos.map((item: IssueDetailInfo) => {
      item.status = item.status === '5' ? '7' : item.status
      item.statusDesc = statusList[Number(item.status)]
      return item
    })
    LogManager.hilogIWithTag(TAG, `KV_ISSUE_KEY, data: ${JSON.stringify(cacheIssueInfos)}`)
    KvManagerService.putValue(KeyConstant.KV_ISSUE_KEY, JSON.stringify(cacheIssueInfos))
  }

  loadIssueList() {
    this.refreshData()
    AppStorage.set(KeyConstant.IS_SHOW_LOADING, true)

    this.getList(() => {
      AppStorage.set(KeyConstant.IS_SHOW_LOADING, false)
      KvManagerService.getValue(KeyConstant.KV_ISSUE_KEY, (data: string) => {
        LogManager.hilogIWithTag(TAG, `KV_ISSUE_KEY, data: ${data}`)
        const cacheIssueInfos = JSON.parse(data) as IssueDetailInfo[]
        AppStorage.setOrCreate('issueInfoCaches', cacheIssueInfos)
      })
    })
  }

  private needRefresh() {
    if (this.isNeedRefresh) {
      this.refreshData()

      this.getList(() => {
        AppStorage.set(KeyConstant.IS_NEED_REFRESH, false)
      })
    }
  }

  private refreshData() {
    let page = new Page()
    page.current = 1
    page.size = 20
    page.devid = DeviceManager.shareInstance().getUdid()
    this.page = page
  }

  private getList(handle: () => void) {
    NetworkManager.shareInstance()
      .request(UrlConstant.ISSUE_LIST + '?' + 'current=' + this.page.current + '&' + 'size=' + this.page.size,
        this.page, (listErr, listResult) => {
          LogManager.hilogIWithTag(TAG,
            `getList, err: ${JSON.stringify(listErr)}, result: ${JSON.stringify(listResult)}`)
          if (handle) {
            handle()
          }

          if (!listResult || !listResult.result) {
            promptAction.showToast({
              message: $r('app.string.warning_prompt'),
              duration: PROMPT_TIME
            })
            return
          }

          let code = listResult.responseCode as number
          LogManager.hilogIWithTag(TAG, `getList, code: ${JSON.stringify(code)}`)

          if (listErr && code != 200) {
            promptAction.showToast({
              message: $r('app.string.warning_prompt'),
              duration: PROMPT_TIME
            })
            return
          }

          if (listResult.result['data']?.records) {
            if (this.page.current == 1) {
              this.issueDetailAllInfos = []
            }
            if (listResult.result['data'].records?.length > 0) {
              for (let index = 0; index < listResult.result['data']?.records.length; index++) {
                this.issueDetailAllInfos.push(listResult.result['data']?.records[index])
              }
            }
            this.checkIssueUpdate()

            this.page.pages = listResult.result['data']['pages']
            this.page.total = listResult.result['data']['total']

            LogManager.hilogIWithTag(TAG, `getList, issueDetailAllInfos: ${JSON.stringify(this.issueDetailAllInfos)}`)
            LogManager.hilogIWithTag(TAG,
              `getList, pages: ${JSON.stringify(this.page.pages)}, total: ${JSON.stringify(this.page.total)}`)
          }
        }, http.RequestMethod.GET)
  }

  private checkIssueUpdate() {
    KvManagerService.getValue(KeyConstant.KV_ISSUE_UPDATE_TIME_KEY, (data: string) => {
      LogManager.hilogIWithTag(TAG, `KV_ISSUE_UPDATE_TIME_KEY, data xx: ${data}`)
      let issueUpdateTimeList: IssueUpdateTime[] = JSON.parse(data) as IssueUpdateTime[]
      let newIssueUpdateTimeList: IssueUpdateTime[] = []
      this.issueDetailAllInfos.forEach((info: IssueDetailInfo) => {
        let hasIssueTime = false
        if (issueUpdateTimeList?.length) {
          for (let index = 0; index < issueUpdateTimeList.length; index++) {
            let issue: IssueUpdateTime = issueUpdateTimeList[index]
            if (info.issueId === issue.id) {
              hasIssueTime = true
              if (info.updateTime !== issue.time) {
                info.isNew = true
                break
              }
            }
          }
        }
        if (!hasIssueTime) {
          newIssueUpdateTimeList.push({ id: info.issueId, time: info.updateTime || '' })
        }
      })
      this.getInfoList()
      KvManagerService.putValue(KeyConstant.KV_ISSUE_UPDATE_TIME_KEY,
        JSON.stringify(issueUpdateTimeList.concat(newIssueUpdateTimeList)))
      LogManager.hilogIWithTag(TAG,
        `issueUpdateTimeList: ${JSON.stringify(issueUpdateTimeList.concat(newIssueUpdateTimeList))}`)
    })
  }

  resetNewKey(info: IssueDetailInfo) {
    LogManager.hilogIWithTag(TAG, `issueUpdateTimeListxxxxxxxx: ${JSON.stringify(info)}`)
    KvManagerService.getValue(KeyConstant.KV_ISSUE_UPDATE_TIME_KEY, (data: string) => {
      LogManager.hilogIWithTag(TAG, `KV_ISSUE_UPDATE_TIME_KEY, data: ${data}`)
      let issueUpdateTimeList: IssueUpdateTime[] = JSON.parse(data) as IssueUpdateTime[]
      this.issueDetailAllInfos = this.issueDetailAllInfos.map((item: IssueDetailInfo) => {
        if (info.issueId === item.issueId) {
          item.isNew = false
        }
        return item
      })
      LogManager.hilogIWithTag(TAG, `issueDetailAllInfos, info: ${JSON.stringify(this.issueDetailAllInfos)}`)
      this.getInfoList()
      if (issueUpdateTimeList?.length) {
        for (let index = 0; index < issueUpdateTimeList.length; index++) {
          let issue: IssueUpdateTime = issueUpdateTimeList[index]
          if (info.issueId === issue.id) {
            issue.time = info.updateTime || ''
            break
          }
        }
      }
      KvManagerService.putValue(KeyConstant.KV_ISSUE_UPDATE_TIME_KEY, JSON.stringify(issueUpdateTimeList))
      LogManager.hilogIWithTag(TAG, `getList, issueDetailAllInfos: ${JSON.stringify(issueUpdateTimeList)}`)
    })
  }

  getInfoList() {
    let infoList: IssueDetailInfo[] = []
    let infoNewList: IssueDetailInfo[] = []
    this.issueDetailAllInfos.forEach((item: IssueDetailInfo) => {
      if (item.isNew) {
        infoNewList.push(item)
      } else {
        infoList.push(item)
      }
    })
    LogManager.hilogIWithTag(TAG, `KV_ISSUE_KEY, data xxxx yyyy 121: ${JSON.stringify(infoNewList)}`)
    LogManager.hilogIWithTag(TAG, `KV_ISSUE_KEY, data xxxx yyyy 121: ${JSON.stringify(infoList)}`)

    this.issueDetailInfos = infoList
    this.issueDetailNewInfos = infoNewList
  }

  @Builder
  tagBuilder(btnKey: string, btnColor: ResourceColor) {
    Row() {
      Text(btnKey)
        .fontSize('36lpx')
        .fontColor(Color.White)
        .fontWeight(900)
    }
    .borderRadius(8)
    .backgroundColor(btnColor)
    .height('51lpx')
    .padding({ left: '9lpx', right: '9lpx' })
  }

  @Builder
  getListView() {
    List({ scroller: this.scroller }) {
      ForEach(this.issueDetailNewInfos.concat(this.cacheIssueInfos, this.issueDetailInfos),
        (item: IssueDetailInfo, index: number) => {
          ListItem() {
            Row() { //用来加加边框
              Column({ space: '18lpx' }) {
                issueReportCardItem({
                  itemLabel: '问题单号:',
                  itemValue: item.issueId,
                  isBold: true,
                  isShow: item.isNew,
                  tagItem: { key: 'new', color: Color.Orange },
                  isFocus: this.currentIndex === index
                })
                issueReportCardItem({
                  itemLabel: '当前状态:',
                  itemValue: (item.status === '6' || item.status === '7') ? '' : item.statusDesc,
                  isShow: item.status === '6' || item.status === '7',
                  tagItem: { key: item.statusDesc, color: Color.Red },
                  isFocus: this.currentIndex === index
                })
                issueReportCardItem({
                  itemLabel: '创建时间:',
                  itemValue: item.faultTime,
                  isFocus: this.currentIndex === index
                })
                issueReportCardItem({
                  itemLabel: '问题描述:',
                  itemValue: item.description,
                  isDecItem: true,
                  isFocus: this.currentIndex === index
                })
              }.layoutWeight(1)
              .borderRadius(vpChangeLpx(24))
              .backgroundColor(this.currentIndex === index ? $r('app.color.default_white') :
              $r('app.color.custom_background'))
              .padding('15lpx')
            }
            .border({
              width: this.currentIndex == index ? '2lpx' : 0,
              radius: '24lpx',
              color: Color.White,
              style: BorderStyle.Solid
            })
            .padding('5lpx')
          }
          .margin('20lpx')
          .key('item' + index)
          .defaultFocus(true)
          .focusBox({
            margin: LengthMetrics.lpx(5),
            strokeColor: ColorMetrics.resourceColor($r('app.color.default_white')),
            strokeWidth: LengthMetrics.lpx(0)
          })
          .onFocus(() => {
            this.currentIndex = index
            this.scroller.scrollToIndex(index, true)
          })
          .onTouch((event) => {
            focusControl.requestFocus('item' + index)
            if (!EventUtil.isTouchEvent(event)) {
              return;
            }
            if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
              return;
            }
          })
          .onHover(() => {
            focusControl.requestFocus('item' + index)
            this.scroller.scrollToIndex(index, true)
          })
          .animation({
            duration: ANIMATION_FIVE,
            curve: Curve.Ease
          })
          .onClick((event) => {
            focusControl.requestFocus('item' + index)
            if (item.status == '5') {
              {
                promptAction.showToast({
                  message: '上传中...'
                })
                return
              }
            }
            this.resetNewKey(item)
            LogManager.hilogIWithTag(TAG, `submitRequest upload, error xx: ${JSON.stringify(item)}`)
            const url = (item.status == '6' || item.status == '7') ? 'pages/IssueReporter/IssueReporterAdd' :
              'pages/IssueReporter/IssueReporterDetail'
            router.pushUrl({
              url,
              params: item
            })
          })
        })
    }
    .edgeEffect(EdgeEffect.None)
    .layoutWeight(1)
    .width('100%')
    .padding({ left: vpChangeLpx(335), right: vpChangeLpx(334) })
    .scrollBar(BarState.On)
    .scrollBarColor(Color.White)
  }

  build() {
    Column() {
      NavigationBar({
        title: $r('app.string.list_of_questions'),
        rightItemImage: $r('app.media.icon_add'),
        isHiddenRight: false,
        isHiddenBack: false,
        onClickRightItemHandle: () => {
        }
      })
        .padding({ left: vpChangeLpx(335), right: vpChangeLpx(334) })

      this.getListView()
    }
    .width('100%')
    .backgroundColor($r('app.color.global_default_background'))
    .justifyContent(FlexAlign.Center)
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        router.back()
      }
    })
  }
}