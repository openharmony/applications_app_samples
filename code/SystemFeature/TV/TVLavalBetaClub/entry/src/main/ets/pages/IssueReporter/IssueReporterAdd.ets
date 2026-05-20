import NavigationBar from '../common/NavigationBar'
import IssueReporterDetailItem, { IssueReporterDetailItemType } from './views/IssueReporterDetailItem'
import {
  Probability,
  Attachment,
  UploadBody,
  probabilityList,
  statusList,
  issueTypeList,
  TIME_INT_VIS,
  fpChangeLpx,
  vpChangeLpx,
  TIME_INT,
  PROMPT_TIME
} from '../IssueReporter/models/IssueDetailInfo'
import IssueDetailInfo from '../IssueReporter/models/IssueDetailInfo'
import promptAction from '@ohos.promptAction';
import LogManager from '../../common/Log/LogManager'
import NetworkManager from '../../common/Network/NetworkManager'
import DeviceManager from '../../common/Device/DeviceManager';
import UrlConstant from '../../common/Constants/UrlConstant'
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import KeyConstant from '../../common/Constants/KeyConstant';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { attachmentParams, initImageCollection } from '../common/utilImage';
import kvManagerService from '../../common/kvManager/kvManagerService';
import issueReportSelectItem, { registerInputConsumer, unregisterInputConsumer } from './views/issueReportSelectItem'
import issueAttachment, { PhotoModel } from './views/issueAttachment'
import { zlib } from '@kit.BasicServicesKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { ColorMetrics, LengthMetrics, window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { tabClick } from '../Index';
import { inputMethod } from '@kit.IMEKit';
import { bundleManager } from '@kit.AbilityKit';
import { PointerUtil } from '../../common/Utils/PointerUtil';
import { EventUtil } from '../common/EventUtil';

const TAG = 'IssueReporterAdd'

class SubmitInfo {
  issueId: string = '' // 问题单id
  devid: string = '' // 设备id
  faultTime: string = '' // 故障时间
  probability: string = '' // 问题概率
  description: string = '' // 问题描述
  logs: string = '' // 日志
  phone?: string = '' // 手机
  attachment?: Attachment[] = [] // 附件
  phoneModel?: string = '' // 手机型号
  softwareVersion?: string = '' // 软件版本
  type: string = '' // 问题类型
}

const BYTE_TO_MB: number = 1024 * 1024
const  sourceToolMouseClick: number = 7
@Entry
@Component
export default struct IssueReporterAdd {
  context = getContext(this) as Context
  scroller: Scroller = new Scroller()
  private probabilitys: Probability[] = []
  private probabilityStrs: string[] = []
  @State faultTime: string = ''
  @State probability: string = ''
  @State probabilityDesc: string = ''
  @State description: string = ''
  private photoInfos: PhotoModel[] = []
  private photoAtts: Attachment[] = []
  private logAtt: Attachment = new Attachment()
  @State private isShowLoading: boolean = false
  private isManualBack: boolean = true // 物理back是否可用
  private timeStamp: number = 0
  private attachment: Attachment[] = []
  private logChange: boolean = false
  private attachmentChange: boolean = false
  @State private attachmentType: IssueReporterDetailItemType = IssueReporterDetailItemType.attachment
  private hasLogTar: boolean = false
  textAreaController: TextAreaController = new TextAreaController()
  inputController: inputMethod.InputMethodController | null = inputMethod.getController();
  @State previewImage: boolean = false
  @State previewImageIndex: number = 0
  @State issueType: string = ''
  @State isResubmit: boolean = false
  @State issueId: string = ''
  private allSize = 0
  @State newCachesBase: IssueDetailInfo[] = []
  private dataPreferences: preferences.Preferences =
    preferences.getPreferencesSync(getContext(this), { name: 'myStore' });
  @State flag: boolean = false
  @State isFocusInput: boolean = false
  @State isFocusUpload: boolean = false
  @State isFocusSubmit: boolean = false
  private numberCharacters: number = 1023
  isSelectPhotoFunc: () => void = () => {
  }
  @StorageLink('issueReportTime') issueReportTime: string = '';
  @StorageLink('issueReportDate') issueReportDate: string = '';

  @State focus_: boolean = false;   //解决6320该页面在输入需求描述区域无法正常上下  false代表下键 true代表上
   focusController = this.getUIContext().getFocusController();
   issueAttachmentFocusKey:string='FocusUpload'
  onBackPress() {
    return !this.isManualBack
  }
  onPageShow() {
    this.issueReportTime = ''
    this.issueReportDate = ''
  }

  async aboutToAppear() {
    let probability0 = new Probability()
    probability0.id = '0'

    let probability1 = new Probability()
    probability1.id = '1'

    let probability2 = new Probability()
    probability2.id = '2'

    let probability3 = new Probability()
    probability3.id = '3'

    this.probabilitys.push(probability3, probability2, probability1, probability0)

    for (let index = 0; index < this.probabilitys.length; index++) {
      this.probabilityStrs.push(this.probabilitys[index].des)
    }

    this.setIssueInfo()

    this.inputController = inputMethod.getController()
  }

  setIssueInfo() {
    let params = router.getParams() as IssueDetailInfo
    LogManager.hilogIWithTag(TAG, `setIssueInfo, info: ${JSON.stringify(params)}`)

    if (params) {
      this.isResubmit = true
      this.faultTime = params.faultTime
      this.probability = params.probability
      this.probabilityDesc = params.probabilityDesc
      this.description = params.description
      this.timeStamp = params.timeStamp || 0
      this.logAtt = new Attachment()
      this.logAtt.url = params.logs || ''
      this.attachment = params.attachment || []
      this.attachmentType =
        this.attachment?.length ? IssueReporterDetailItemType.attachmentDisplay : IssueReporterDetailItemType.attachment
      this.hasLogTar = params.hasLogTar || false
      this.issueType = params.type || ''
    }
  }

  private async submit() {
    this.isManualBack = false
    if(this.issueReportDate && this.issueReportTime){
      this.faultTime = this.issueReportDate + " " + this.issueReportTime
    }
    if (this.faultTime.length == 0) {
      this.isManualBack = true

      promptAction.showToast({
        message: '请选择故障时间'
      })
      return
    }
    LogManager.hilogIWithTag(TAG, `submit, faultTime: ${JSON.stringify(this.faultTime)}`)

    if (this.probability.length == 0) {
      this.isManualBack = true

      promptAction.showToast({
        message: '请选择问题概率'
      })
      return
    }
    LogManager.hilogIWithTag(TAG, `submit, probability: ${JSON.stringify(this.probability)}`)

    if (this.description.length == 0) {
      this.isManualBack = true

      promptAction.showToast({
        message: '请填写问题描述'
      })
      return
    }
    LogManager.hilogIWithTag(TAG, `submit, description: ${JSON.stringify(this.description)}`)

    if (this.issueType.length == 0) {
      this.isManualBack = true

      promptAction.showToast({
        message: '请选择问题类型'
      })
      return
    }
    LogManager.hilogIWithTag(TAG, `submit, description: ${JSON.stringify(this.issueType)}`)

    if (!this.timeStamp) {
      this.timeStamp = new Date().getTime()
    }

    if (this.allSize / BYTE_TO_MB > 100) {
      promptAction.showToast({
        message: '附件大小不能超过100M'
      })
      return
    }
    this.issueInfoCache('5', false, false)
    router.back()

    // 增加蒙版
    this.isShowLoading = true

    if (this.photoInfos.length > 0 && this.attachmentChange) {
      // 每次上传前都清空所有文件和配置
      this.photoAtts = []
      this.deleteFiles(KeyConstant.UPLOAD_ATTACHMENT_PATH_FOLDER)

      this.uploadAttachment()
    } else {
      this.submitLogs()
    }
  }

  // 生成随机uuid
  generateRandomString(): string {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < 8; i++) {
      const randomIndex = Math.floor(Math.random() * characters.length);
      result += characters.charAt(randomIndex);
    }
    return result;
  }

  issueInfoCache(status: string, isDelete: Boolean = false, hasAttachment: Boolean = true) {

    let allCache: IssueDetailInfo[] = AppStorage.get('issueInfoCaches') || [];
    LogManager.hilogIWithTag(TAG, `issueInfoCache, ${JSON.stringify(allCache)}`)

    let submitInfo: IssueDetailInfo = {
      issueId: this.issueId,
      devid: DeviceManager.shareInstance().getUdid(),
      status,
      statusDesc: statusList[Number(status)],
      faultTime: this.faultTime,
      probability: this.probability,
      probabilityDesc: probabilityList[Number(this.probability)],
      description: this.description,
      timeStamp: this.timeStamp,
      logs: '',
      hasLogTar: this.hasLogTar,
      attachment: this.attachment,
      type: this.issueType
    }

    if (hasAttachment && this.photoInfos?.length) {
      submitInfo.attachment = attachmentParams()
    }

    let newCaches: IssueDetailInfo[] = []
    if (allCache && allCache.length) {
      if (isDelete) {
        newCaches = allCache.filter((item: IssueDetailInfo) => item.timeStamp !== submitInfo.timeStamp)
      } else {
        let hasInfo: boolean = false
        newCaches = allCache.map((item: IssueDetailInfo) => {
          if (item.timeStamp === submitInfo.timeStamp) {
            hasInfo = true
            return submitInfo
          } else {
            return item
          }
        })

        if (!hasInfo) {
          newCaches.unshift(submitInfo)
        }

      }
    } else {
      newCaches.push(submitInfo)
    }
    LogManager.hilogIWithTag(TAG, `issueInfoCache-newCaches, ${JSON.stringify(newCaches)}`)
    AppStorage.setOrCreate('issueInfoCaches', newCaches)
    kvManagerService.putValue(KeyConstant.KV_ISSUE_KEY, JSON.stringify(newCaches))
  }

  private async uploadAttachment() {
    let allPromise: Promise<boolean>[] = [];
    for (let index = 0; index < this.photoInfos.length; index++) {
      let photoInfo = this.photoInfos[index]
      let file = fileIo.openSync(photoInfo.uri);
      let photoFd = file.fd
      fs.copyFileSync(photoFd,
        this.context.cacheDir + '/' + KeyConstant.UPLOAD_ATTACHMENT_PATH_FOLDER + '/' + photoInfo.displayName)
      let photoNameArr = photoInfo.displayName.split('.')
      let photoType = photoNameArr[photoNameArr.length - 1]

      let curFileType: string = 'image'
      switch (photoInfo.photoType) {
        case photoAccessHelper.PhotoType.IMAGE: {
          curFileType = 'image'
        }
          break

        case photoAccessHelper.PhotoType.VIDEO: {
          curFileType = 'video'
        }
          break
      }

      const promise = new Promise<boolean>((resolve, reject) => {
        NetworkManager.shareInstance()
          .upload(this.issueId, this.context, UrlConstant.UPLOAD_FILE, KeyConstant.UPLOAD_ATTACHMENT_PATH_FOLDER + '/',
            photoInfo.displayName, photoType, curFileType, (uploadErr, uploadResult) => {
              LogManager.hilogIWithTag(TAG,
                `submit upload, err: ${JSON.stringify(uploadErr)}, result: ${JSON.stringify(uploadResult)}`)

              if (uploadErr || !uploadResult || !uploadResult['body']) {
                LogManager.hilogIWithTag(TAG, `submit upload fail`)
                reject(false)
              } else {
                let photoAtt: Attachment = (uploadResult['body'] as UploadBody).data
                if (!photoAtt) {
                  reject(false)
                } else {
                  photoAtt.type = curFileType

                  LogManager.hilogIWithTag(TAG, `submit upload, photoAtt: ${JSON.stringify(photoAtt)}`)
                  this.photoAtts.push(photoAtt)
                  resolve(true)
                }

              }
            })
      })
      allPromise.push(promise)
    }
    Promise.allSettled(allPromise).then((res: PromiseSettledResult<boolean>[]) => {
      LogManager.hilogIWithTag(TAG, `PromiseSettledResult, res: ${JSON.stringify(res)}`)
      this.issueInfoCache('5')
      this.submitLogs()
    })
  }

  private async submitLogs() {
    if (!this.logChange) {
      if (this.logAtt.url) {
        this.submitIssue()
        return
      }
      if (this.hasLogTar) {
        this.uploadLogs(`${KeyConstant.CACHE_LOG_PATH_FOLDER}/`, `allLogs${this.timeStamp}.zip`)
        return
      }
    }

    let uid: number = AppStorage.get<number>("appUid") as number;
    LogManager.hilogIWithTag(TAG, `submitLogs uid: ${uid}`);
    if (uid === undefined) {
      LogManager.hilogIWithTag(TAG, `submitLogs error uid is undefined`);
      this.issueInfoCache('6')
      return;
    }

    let typeIndex = issueTypeList.indexOf(this.issueType)
    const type = typeIndex > -1 ? typeIndex : 0
    // 获取日志
    try {
      let srcPathHilog = KeyConstant.SANDBOX_MAP + '/hilog'
      let srcPathFaultLog = KeyConstant.SANDBOX_MAP + '/faultlog'
      let dstPath = this.context.cacheDir + '/' + KeyConstant.CACHE_LOG_PATH_FOLDER
      let dstDirUriLocal: string = fileUri.getUriFromPath(dstPath);
      LogManager.hilogIWithTag(TAG, 'dstDirUriLocal ' + JSON.stringify(dstDirUriLocal));
      let srcLogUri: string = fileUri.getUriFromPath(srcPathHilog);
      await fs.copy(srcLogUri, dstDirUriLocal)
      let srcFaultLogUriLocal: string = fileUri.getUriFromPath(srcPathFaultLog);
      await fs.copy(srcFaultLogUriLocal, dstDirUriLocal)
      LogManager.hilogIWithTag(TAG, 'srcFaultLogUriLocal ' + JSON.stringify(srcFaultLogUriLocal));

      let files: string[] = fs.listFileSync(dstPath + '/hilog')
      const gzFiles: string[] = files.filter(file => file.endsWith('.gz'));
      let latestTimestamp = ''
      for (const file of gzFiles) {
        const timestamp = this.extractTimestamp(file);
        if (timestamp) {
          if (timestamp > latestTimestamp) {
            latestTimestamp = timestamp;
          }
        }
      }
      let latestTimesFiles = this.filterFilesByTimestamp(gzFiles, latestTimestamp)
      // 只保留最新的日志文件
      for (const file of files) {
        if (!latestTimesFiles.includes(file)) {
          const filePath = dstPath + '/hilog' + '/' + file
          fs.unlinkSync(filePath);
          console.log(TAG, `已删除文件: ${filePath}`);
        }
      }

      this.uploadLogs(`${KeyConstant.CACHE_LOG_PATH_FOLDER}/`, `allLogs${this.timeStamp}.zip`)
    } catch (err) {
      promptAction.showToast({
        message: '抓取日志失败'
      })
      this.issueInfoCache('6')
      LogManager.hilogIWithTag(TAG, 'logCatcher.catchLog: ' + JSON.stringify(err));
    }
  }

  // 提取文件名中的时间戳
  extractTimestamp(filename: string): string | null {
    const regex = /\d{8}-\d{6}/;
    const match = filename.match(regex);
    return match ? match[0] : null;
  }

  filterFilesByTimestamp(files: string[], timestamp: string): string[] {
    // 构建正则表达式模式，用于匹配文件名中的时间戳
    const pattern = new RegExp(`\\d{8}-\\d{6}`);
    return files.filter(file => {
      // 从文件名中提取时间戳
      const match = file.match(pattern);
      if (match) {
        // 检查提取的时间戳是否与目标时间戳相同
        return match[0] === timestamp;
      }
      return false;
    });
  }

  // 删除文件
  async deleteFile(filePath: string): Promise<void> {
    return new Promise((resolve, reject) => {
      fs.unlink(filePath, (err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  }

  // 提取 Reason: 后面的内容
  extractReasonContent(content: string): string {
    const reasonIndex = content.indexOf('Reason:');
    if (reasonIndex === -1) {
      return '';
    }
    const startIndex = reasonIndex + 'Reason:'.length;
    return content.slice(startIndex).trim();
  }

  // 读取文件夹下所有文件内容，并删除 Reason: 后面内容相同的前一份文件
  async processFilesInFolder(folderPath: string): Promise<void> {
    try {
      // 读取文件夹下的所有文件
      const files = await new Promise<string[]>((resolve, reject) => {
        fs.listFile(folderPath, (err, files) => {
          if (err) {
            reject(err);
          } else {
            resolve(files);
          }
        });
      });
      LogManager.hilogIWithTag(TAG, `srcPath stst1: ${JSON.stringify(files)}`)
      const reasonContentMap = new Map<string, string>();

      for (const file of files) {
        const filePath: string = folderPath + '/' + file
        LogManager.hilogIWithTag(TAG, `srcPath stst2: ${JSON.stringify(filePath)}`)
        const content = fs.readTextSync(filePath)
        LogManager.hilogIWithTag(TAG, `content: ${JSON.stringify(content)}`)
        const reasonContent = this.extractReasonContent(content);
        LogManager.hilogIWithTag(TAG, `reasonContent: ${JSON.stringify(reasonContent)}`)
        if (reasonContentMap.has(reasonContent) && reasonContent !== '') {
          // 如果 Reason: 后面的内容已经存在，则删除当前文件
          await this.deleteFile(filePath);
          LogManager.hilogIWithTag(TAG, `Deleted file: ${filePath}`);
        } else if (reasonContent !== '') {
          // 如果 Reason: 后面的内容不存在，则记录文件路径
          reasonContentMap.set(reasonContent, filePath);
          LogManager.hilogIWithTag(TAG, `Reason: 后面的内容不存在，则记录文件路径 `);
        }
      }
    } catch (error) {
      console.error(TAG, 'Error processing files:', error);
    }
  }

  private async uploadLogs(folder: string, fileName: string) {
    // 上传日志
    if (!this.hasLogTar) {
      this.hasLogTar = true

      // 将faultLog中的重复log进行去重
      const folderPath = `${this.context.cacheDir}/${KeyConstant.CACHE_LOG_PATH_FOLDER}/faultlog/`;
      let logArrays: string[] = ['debug', 'faultlogger', 'temp']
      logArrays.forEach((item: string) => {
        let path = folderPath + item
        this.processFilesInFolder(path).then(() => {
          LogManager.hilogIWithTag(TAG, `folderPath path: ${JSON.stringify(path)}`)
        })
      })
      // 将所有log压缩保存
      let path = `${this.context.cacheDir}/cache_logs`
      let inFile = path + '/allLogs'
      let outFile = path + '/' + fileName;
      let options: zlib.Options = {};
      await zlib.compressFile(inFile, outFile, options)
    }
    try {
      NetworkManager.shareInstance()
        .upload(this.issueId, this.context, UrlConstant.UPLOAD_FILE, 'cache_logs/', fileName, 'zip', 'zip',
          (uploadErr, uploadResult) => {
            LogManager.hilogIWithTag(TAG,
              `submitRequest upload, err: ${JSON.stringify(uploadErr)}, result: ${JSON.stringify(uploadResult)}`)
            if (uploadErr || !uploadResult['body'] || uploadResult['headers']['content-type'] == 'text/html') {
              promptAction.showToast({
                message: $r('app.string.warning_net_prompt'),
                duration: PROMPT_TIME
              })
              this.issueInfoCache('6')
              return
            }
            let logAtt: Attachment = (JSON.parse(uploadResult['body']) as UploadBody).data
            this.logAtt = logAtt
            if (this.hasLogTar) {
              try {
                fs.rmdirSync(`${this.context.cacheDir}/${KeyConstant.CACHE_LOG_PATH_FOLDER}/hilog`)
                fs.rmdirSync(`${this.context.cacheDir}/${KeyConstant.CACHE_LOG_PATH_FOLDER}/faultlog`)
                fs.unlinkSync(`${this.context.cacheDir}/cache_logs/${fileName}`)
              } catch (e) {
                LogManager.hilogIWithTag(TAG, `rmdirSync upload, error: ${JSON.stringify(e)}`)
              }
            }

            LogManager.hilogIWithTag(TAG, `submitRequest upload, logAtt: ${JSON.stringify(logAtt)}`)
            this.issueInfoCache('5')
            this.submitIssue()
          })
    } catch (e) {
      LogManager.hilogIWithTag(TAG, `submitRequest upload, error: ${JSON.stringify(e)}`)
    }
  }

  private async submitIssue() {
    let productModel: string = DeviceManager.shareInstance().getProductModel()
    const bundleInfo = await bundleManager.getBundleInfoForSelf(0x00000000)
    let submitInfo: SubmitInfo = {
      issueId: this.issueId,
      devid: DeviceManager.shareInstance().getUdid(),
      phoneModel: productModel === 'LHT16' ? '始祖鸟' : '黄鹂',
      softwareVersion: bundleInfo.versionName,
      faultTime: this.faultTime,
      probability: this.probability,
      description: this.description,
      logs: '',
      type: this.issueType,
    }
    LogManager.hilogIWithTag(TAG, `submitInfo.attachment 22: ${JSON.stringify(this.photoAtts)}`)
    LogManager.hilogIWithTag(TAG, `submitInfo.attachment 22: ${JSON.stringify(this.attachment)}`)
    if (this.photoAtts.length > 0) {
      submitInfo.attachment = attachmentParams()
      LogManager.hilogIWithTag(TAG, `submitInfo.attachment 11: ${JSON.stringify(submitInfo)}`)
    } else if (this.attachment?.length && !this.attachmentChange) {
      LogManager.hilogIWithTag(TAG, `submitInfo.attachment ee: ${JSON.stringify(submitInfo)}`)
      submitInfo.attachment = this.attachment
    }

    // 提单
    NetworkManager.shareInstance().request(UrlConstant.ISSUE_REPORT, submitInfo, (reporterErr, reportResult) => {

      LogManager.hilogIWithTag(TAG, `submitParams: ${JSON.stringify(submitInfo)}`)
      LogManager.hilogIWithTag(TAG,
        `submitRequest request, err: ${JSON.stringify(reporterErr)}, result: ${JSON.stringify(reportResult)}`)

      // 取消蒙版
      this.isShowLoading = false
      if (reporterErr) {
        this.isManualBack = true
        this.issueInfoCache('7')
        promptAction.showToast({
          message: '提单失败'
        })
        return
      }

      let code = reportResult.responseCode as number
      LogManager.hilogIWithTag(TAG, `submitRequest request, code: ${JSON.stringify(code)}`)

      if (code != 200) {
        this.isManualBack = true
        this.issueInfoCache('7')

        promptAction.showToast({
          message: '提单失败'
        })
        return
      }
      this.issueInfoCache('8', true)

      promptAction.showToast({
        message: '提单成功'
      })
      this.isManualBack = true
      initImageCollection()
      // 通知列表刷新
      AppStorage.set(KeyConstant.IS_NEED_REFRESH, true)
    })
  }

  // 删除本地文件
  private deleteFiles(path: string) {
    let dirPath = this.context.cacheDir + '/' + path
    let files = fs.listFileSync(dirPath)
    LogManager.hilogIWithTag(TAG, `deleteFiles, files: ${JSON.stringify(files)}`)
    for (let index = 0; index < files.length; index++) {
      fs.unlinkSync(dirPath + '/' + files[index])
    }
  }

  @Builder
  attachmentTitle() {
    Column() {
      Row() {
        Text($r('app.string.attachment_uploaded'))
          .fontSize(fpChangeLpx(36))
          .fontWeight(500)
          .fontColor($r('app.color.default_white'))

        Column() {
          Image(this.isFocusUpload ? $r('app.media.upload_on') : $r('app.media.upload_off'))
            .width(vpChangeLpx(58))
            .height(vpChangeLpx(52))
            .key('FocusUpload')
            .focusable(true)
            .onFocus(() => {
              this.isFocusUpload = true
            })
            .onBlur(() => {
              this.isFocusUpload = false
            })
            .focusBox({
              margin: LengthMetrics.px(2),
              strokeColor: ColorMetrics.resourceColor($r('app.color.button_transParent')),
              strokeWidth: LengthMetrics.px(0)
            })
        }
        .margin({ left: vpChangeLpx(8) })
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.flag = !this.flag
          AppStorage.setOrCreate('isSelectPhoto', this.flag)
        })
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ bottom: '24lpx' })
  }

  build() {
    Column() {
      NavigationBar({
        title: $r('app.string.create_a_new_questionnaire'),
        rightItemImage: $r('app.media.icon_add'),
        isHiddenRight: true,
        isHiddenBack: false,
      })
        .padding({ left: vpChangeLpx(449), right: vpChangeLpx(449) })

      List({ scroller: this.scroller }) {
        ListItem() {
          issueReportSelectItem({
            title: $r('app.string.probability_of_problem'),
            itemType: IssueReporterDetailItemType.filter,
            filters: this.probabilityStrs,
            filter: this.probabilityDesc,
            selectedFilterNumber: Number(this.probability),
            selectedFilterHandle: (filter, index) => {
              this.probability = this.probabilitys[index].id
            }
          })
        }
        .defaultFocus(true)
        .focusable(true)
        .onFocus(() => {
          this.scroller.scrollToIndex(0, true, ScrollAlign.CENTER)
        })

        ListItem() {
          issueReportSelectItem({
            title: $r('app.string.mean_date_to_failure'),
            itemType: IssueReporterDetailItemType.date,
            itemValue: this.faultTime,
            selectedDateHandle: (time) => {
              this.logChange = true
              this.faultTime = time
            }
          })
        }
        .focusable(true)
        .onFocus(() => {
          this.scroller.scrollToIndex(1, true, ScrollAlign.CENTER)
        })

        ListItem() {
          issueReportSelectItem({
            title: $r('app.string.mean_time_to_failure'),
            itemType: IssueReporterDetailItemType.time,
            itemValue: this.faultTime,
            selectedTimeHandle: (time) => {
              this.logChange = true
              this.faultTime = time
            }
          })
        }
        .focusable(true)
        .onFocus(() => {
          this.scroller.scrollToIndex(1, true, ScrollAlign.CENTER)
        })

        ListItem() {
          issueReportSelectItem({
            title: $r('app.string.question_type'),
            itemType: IssueReporterDetailItemType.filter,
            filters: issueTypeList,
            filter: this.issueType,
            selectedFilterNumber: issueTypeList.indexOf(this.issueType),
            selectedFilterHandle: (filter, index) => {
              this.issueType = issueTypeList[index]
              this.logChange = true
            }
          })
        }
        .id('question_type')
        .focusable(true)
        .onFocus(() => {
          this.scroller.scrollToIndex(2, true, ScrollAlign.CENTER)
        })

        ListItem() {
          Row() {
            Column() {
              Column() {
                Row() {
                  Text($r('app.string.problem_description'))
                    .fontSize(fpChangeLpx(36))
                    .fontWeight(500)
                    .fontColor(this.isFocusInput ? $r('app.color.global_default_background') :
                      $r('app.color.default_white'))
                  Text('*')
                    .fontColor(Color.Red)
                    .fontSize(fpChangeLpx(36))
                }
                .margin({ left: vpChangeLpx(12) })
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .margin({ bottom: vpChangeLpx(35) })

              Column() {
                TextArea({
                  text: this.description,
                  placeholder: $r('app.string.placeholder_input'),
                  controller: this.textAreaController
                })
                  .key('TextArea')
                  .enterKeyType(EnterKeyType.Done)
                  .placeholderFont({ size: fpChangeLpx(24) })
                  .placeholderColor(this.isFocusInput ? $r('app.color.global_default_background') :
                    $r('app.color.default_white'))
                  .height(vpChangeLpx(100))
                  .barState(BarState.Auto)
                  .fontSize(fpChangeLpx(28))
                  .fontColor(this.isFocusInput ? $r('app.color.global_default_background') :
                    $r('app.color.default_white'))
                  .maxLength(1024)
                  .enableKeyboardOnFocus(true)
                  .backgroundColor($r('app.color.button_transParent'))
                  .onChange((value: string) => {
                    LogManager.hilogIWithTag(TAG, `TextArea onChange, value: ${JSON.stringify(value)}`)
                    this.description = value
                    if (value.length > this.numberCharacters) {
                      promptAction.showToast({
                        message: $r('app.string.character_exceeding_prompt')
                      })
                    }
                  })
                  .onKeyEvent((event) => {
                    if (event.type === KeyType.Down) {
                      if (event.keyCode === KeyCode.KEYCODE_ENTER) {
                        focusControl.requestFocus('TextArea')
                        return;
                      }
                      if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN) {
                        tabClick()
                        return;
                      }
                      if (event.keyCode === KeyCode.KEYCODE_DPAD_UP) {
                        focusControl.requestFocus('question_type')
                        return;
                      }
                    }
                  })
              }
              .width('100%')
              .height(vpChangeLpx(100))
              .borderRadius(vpChangeLpx(24))

            }
            .onTouch((event) => {
              focusControl.requestFocus('TextArea')
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
                return;
              }
            })
            .onHover((isHover: boolean) => {
              focusControl.requestFocus('TextArea')
            })
            .height(vpChangeLpx(239))
            .padding(vpChangeLpx(24))
            .borderRadius(vpChangeLpx(18))
            .backgroundColor(this.isFocusInput ? $r('app.color.default_white') : $r('app.color.choose_background'))
          }
          .focusable(true)
          .onFocus(() => {
            this.isFocusInput = true
          })
          .onBlur(() => {
            this.isFocusInput = false
          })
          .height(vpChangeLpx(259))
          .padding({ left: vpChangeLpx(10), right: vpChangeLpx(10) })
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .border(this.isFocusInput ?
            { width: vpChangeLpx(2), color: $r('app.color.default_white'), radius: vpChangeLpx(24) } : null)
          .margin({ bottom: vpChangeLpx(24) })
        }
        .onFocus(()=>{
          this.scroller.scrollToIndex(3, false, ScrollAlign.START)
        })

        ListItem() {
          issueAttachment({
            thumbnails: this.attachment,
            previewImage: this.previewImage,
            previewImageIndex: this.previewImageIndex,
            canEdit: true,
            titleBuilderParam: this.attachmentTitle.bind(this),
            selectedPhotoHandle: (photoInfos, photoSize) => {
              this.photoInfos = photoInfos
              this.allSize = photoSize
              this.attachmentChange = true
            },
            keyFocus: this.issueAttachmentFocusKey
          })
            .padding({ left: vpChangeLpx(10), right: vpChangeLpx(10) })
        }
        .focusable(true)
        .onFocus(() => {
          this.scroller.scrollToIndex(4, true, ScrollAlign.START)
        })

        ListItem() {
          Row() {
            Row() {
              Button(this.isResubmit ? $r('app.string.resubmit') : $r('app.string.submit'))
                .key('Submit')
                .fontSize(this.isResubmit ? fpChangeLpx(36) : fpChangeLpx(42))
                .width(this.isResubmit ? vpChangeLpx(300) : vpChangeLpx(280))
                .height(vpChangeLpx(80))
                .borderRadius(vpChangeLpx(55))
                .fontSize(fpChangeLpx(48))
                .fontColor(this.isFocusSubmit ? $r('app.color.global_default_background') :
                  $r('app.color.default_white'))
                .backgroundColor(this.isFocusSubmit ? $r('app.color.default_white') : $r('app.color.button_gray'))
                .focusBox({
                  margin: LengthMetrics.lpx(2),
                  strokeColor: ColorMetrics.resourceColor($r('app.color.default_white')),
                  strokeWidth: LengthMetrics.lpx(0)
                })
                .onClick((event) => {
                  focusControl.requestFocus('Submit')
                  this.dataPreferences.putSync('openLog', false)
                  this.dataPreferences.flush()
                  // 生成问题单唯一Id
                  this.issueId = this.generateRandomString()
                  this.submit()
                })
                .onHover((isHover: boolean) => {
                  focusControl.requestFocus('Submit')
                })
                .onTouch((event) => {
                  focusControl.requestFocus('Submit')
                  if (!EventUtil.isTouchEvent(event)) {
                    return;
                  }
                  if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
                    return;
                  }
                })
                .onFocus(() => {
                  this.isFocusSubmit = true
                  registerInputConsumer(KeyCode.KEYCODE_DPAD_DOWN, () => {
                    tabClick()
                  })
                })
                .onBlur(() => {
                  this.isFocusSubmit = false
                  unregisterInputConsumer(KeyCode.KEYCODE_DPAD_DOWN)
                })
            }
            .width(this.isResubmit ? vpChangeLpx(320) : vpChangeLpx(300))
            .height(vpChangeLpx(100))
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .margin({ top: vpChangeLpx(24) })
            .border({
              width: this.isFocusSubmit? '2lpx' : 0,
              radius: '50lpx',
              color: Color.White,
              style: BorderStyle.Solid
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .focusable(true)
        .onFocus(() => {
          this.scroller.scrollToIndex(5, true, ScrollAlign.START)
        })
      }
      .margin({
        bottom: vpChangeLpx(24),
        top: vpChangeLpx(20)
      })
      .scrollBar(BarState.On)
      .scrollBarColor(Color.White)
      .layoutWeight(1)
      .align(Alignment.Top)
      .padding({ left: vpChangeLpx(449), right: vpChangeLpx(449) })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.global_default_background'))
    .onKeyEvent((event) => {
      if (event.keyCode==KeyCode.KEYCODE_DPAD_UP) {
        this.focus_=true
      }else if (event.keyCode==KeyCode.KEYCODE_DPAD_DOWN) {
        this.focus_=false
      }
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        router.back()
      }
    })
  }
}