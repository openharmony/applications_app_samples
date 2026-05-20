import util from '@ohos.util'
import { UploadImageInfo } from '../../common/Constants/TypeData'

export interface ThumbnailInfo {
  thumbnail: string,
  image_name: string
}

export interface AttachmentParams {
  type: string,
  url: string,
  id: string,
  thumbnail: string
}

/**
 * 设置全局的缩略图信息
 * 将缩略图转化为base64后进行存储
 *
 */
export const setImageBase64 = async (image_name_raw: string, readBuffer: ArrayBuffer): Promise<void> => {
  const thumbnailBase64 = encodeToBase64(readBuffer)
  console.info('wbbBase', thumbnailBase64.length)
  console.info('wbbBase', thumbnailBase64)
  let thumbnail: ThumbnailInfo = {
    thumbnail: thumbnailBase64,
    image_name: image_name_raw
  }
  let thumbnails: ThumbnailInfo[];
  if (!!AppStorage.get('thumbnails')) {
    thumbnails = AppStorage.get('thumbnails') as ThumbnailInfo[]
  } else {
    thumbnails = []
  }
  thumbnails.push(thumbnail)
  AppStorage.setOrCreate('thumbnails', thumbnails)
}

export const encodeToBase64 = (readBuffer: ArrayBuffer) => {
  let that = new util.Base64Helper();
  let uint8ArrFromPixel = new Uint8Array(readBuffer)
  let pixelStr = that.encodeToStringSync(uint8ArrFromPixel, util.Type.BASIC)
  return 'data:image/jpeg;base64,' + pixelStr
}

/**
 * 提交完成之后，初始化整合的数据
 * 提单成功之后，清除之前存储的数据
 */
export const initImageCollection = (): void => {
  //当点击提交的时候，清空上次的图片集合信息
  AppStorage.setOrCreate('uploadImageArr', [])
  //当点击提交的时候，清空上次的缩略图集合信息
  AppStorage.setOrCreate('thumbnails', [])
}


/**
 * 组装附件提交参数
 */
export const attachmentParams = (): AttachmentParams[] => {
  let arr: ThumbnailInfo[] = AppStorage.get('thumbnails') || []
  let objKey: string[] = []
  for (let i = 0; i < arr.length; i++) {
    objKey.push(arr[i].image_name)
  }
  let attachmentParams: AttachmentParams[] = []
  let attachmentParamsObj: AttachmentParams = {
    type: "",
    url: "",
    id: "",
    thumbnail: ""
  }
  let arrImage: UploadImageInfo[] = AppStorage.get('uploadImageArr') || []
  arrImage.forEach((item) => {
    const type = item.type
    const url = item.url ?? ''
    const id = item.id ?? ''
    attachmentParamsObj = { type, url, id, thumbnail: arr[objKey.indexOf(item.image_name)].thumbnail }
    if (attachmentParamsObj.type !== 'tar') {
      attachmentParams.push(attachmentParamsObj)
    }
  })
  return attachmentParams
}

export const stringToObject = (input: string | Object | ArrayBuffer): Object | undefined  => {
  if (typeof input === 'string') {
    try {
      return JSON.parse(input)
    } catch (e) {
      console.info('The backend returned illegal data')
    }
    return undefined
  } else {
    return input
  }
}