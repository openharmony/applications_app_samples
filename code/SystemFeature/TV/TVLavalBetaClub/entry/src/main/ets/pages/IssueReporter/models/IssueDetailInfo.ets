import LogManager from '../../../common/Log/LogManager'

export class Probability {
  TAG: string = 'Probability'
  // 0-极低、1-一天一次、2-一天多次、3-必现
  _id: string = ''
  des: string = ''
  isSelect: boolean = false // 是否选择

  set id(newId: string) {
    LogManager.hilogIWithTag(this.TAG, `set id: ${JSON.stringify(newId)}`)

    this._id = newId

    switch (newId) {
      case '0': {
        this.des = '极低'
      }
        break

      case '1': {
        this.des = '一天一次'
      }
        break

      case '2': {
        this.des = '一天多次'
      }
        break

      case '3': {
        this.des = '必现'
      }
        break
    }
  }

  get id(): string {
    return this._id
  }
}

export class Attachment {
  type: string = '' // 附件的类型： image、video、audio、file
  id: string = '' // 附件id, 从上传接口获取
  url: string = '' // 附件下载url，从上传文件接口获取
  thumbnail: string | PixelMap = '' //  附件的缩略图，由设备端生成格式 base64编码
}

export class UploadBody {
  code: number = 0
  msg: string = ''
  data: Attachment = new Attachment()
}

@Observed
export default class IssueDetailInfo {
  issueId: string = '' // 问题单id
  devid: string = '' // 设备id
  faultTime: string = '' // 故障时间
  probability: string = '' // 问题概率
  probabilityDesc: string = '' // 问题概率描述
  remark?: string = '' // 备注
  description: string = '' // 问题描述
  status: string = '' // 问题单状态 (0 -有待确认、1-正在处理、2-已解决、3-非问题、4-挂起)
  statusDesc: string = '' // 状态描述
  phone?: string = '' // 电话号码（非必填）
  attachment?: Attachment[] = [] // 附件地址

  probabilityObj?: Probability = new Probability() // 问题概率对象

  timeStamp?: number = 0
  logs?: string = ''
  hasLogTar?: boolean = false
  isNew?: boolean = false
  updateTime?: string = ''
  type?: string = ''
}


export const statusList: string[] = ['有待确认', '正在处理', '已解决', '非问题', '挂起', '上传中', '上传失败', '提交失败', '提交成功']

export const probabilityList: string[] = ['极低', '一天一次', '一天多次', '必现']

export const issueTypeList: string[] = ['功能', '稳定性', '蓝牙', 'OTA']

export class issueUpdateTime {
  id: string = ''
  time: string = ''
}

export const TIME_INT = 1000

export const TIME_INT_VIS = 500

export const PROMPT_TIME = 2000

export function vpChangeLpx(num: number) {
  return px2vp(num) + 'lpx'
}

export function fpChangeLpx(num: number) {
  return px2fp(num) + 'lpx'
}
