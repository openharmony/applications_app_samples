import LogManager from '../Log/LogManager'
import http from '@ohos.net.http'
import UrlConstant from '../Constants/UrlConstant'
import base, { BusinessError } from '@ohos.base'
import request from '@ohos.request';
import { Context } from '@ohos.abilityAccessCtrl'
import { UploadImageInfo } from '../Constants/TypeData'
import promptAction from '@ohos.promptAction';

const TAG = 'NetworkManager'

const OVERTIME = 30

export class BusinessErrorImpl implements base.BusinessError {
  code: number = 0
  name: string = ''
  message: string = ''
}

export default class NetworkManager {
  private static manager: NetworkManager

  public static shareInstance(): NetworkManager {
    if (!NetworkManager.manager) {
      NetworkManager.manager = new NetworkManager()
    }
    return NetworkManager.manager
  }

  public request(apiUrl: string, params: object | ArrayBuffer | string, callback: (err: base.BusinessError, data: http.HttpResponse) => void, method?: http.RequestMethod, filename?: string, contentType?: string, expectDataType?: http.HttpDataType, baseUrl?: string) {
    LogManager.hilogIWithTag(TAG, `request, apiUrl: ${JSON.stringify(apiUrl)}, params: ${JSON.stringify(params)}, expectDataType: ${JSON.stringify(expectDataType)}, contentType: ${JSON.stringify(contentType)}, baseUrl: ${JSON.stringify(baseUrl)}, method: ${JSON.stringify(method)}`)

    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header: Object) => {
      LogManager.hilogIWithTag(TAG, `request, headersReceive: ${JSON.stringify(header)}`)
    });

    let url = (baseUrl == undefined ? UrlConstant.BASE_URL : baseUrl) + apiUrl
    let requestMethod = method == undefined ? http.RequestMethod.POST : method
    let requestExpectDataType = expectDataType == undefined ? http.HttpDataType.OBJECT : expectDataType
    let requestContentType = contentType == undefined ? 'application/json' : contentType

    LogManager.hilogIWithTag(TAG, `request, url: ${JSON.stringify(url)}, params: ${JSON.stringify(params)}, requestMethod: ${JSON.stringify(requestMethod)}, requestContentType: ${JSON.stringify(requestContentType)}, requestExpectDataType: ${JSON.stringify(requestExpectDataType)}, filename: ${JSON.stringify(filename)}`)
    httpRequest.request(
      url,
      {
        method: requestMethod,
        extraData: params,
        expectDataType: requestExpectDataType,
        header: {
          'content-Type': requestContentType,
        }
      },
      (err: base.BusinessError, data: http.HttpResponse) => {
        LogManager.hilogIWithTag(TAG, `request, data: ${JSON.stringify(data)}, err: ${JSON.stringify(err)}`)

        if (callback) {
          callback(err, data)
        }

        httpRequest.off('headersReceive');
        httpRequest.destroy();
      });
  }

  public upload(issueId: string, context: Context, apiUrl: string, folder: string, fileName: string, fileType: string, type: string, callback: (err?: base.BusinessError, data?: object) => void, baseUrl?: string) {
    LogManager.hilogIWithTag(TAG, `upload, apiUrl: ${JSON.stringify(apiUrl)}, fileName: ${JSON.stringify(fileName)}, fileType: ${JSON.stringify(fileType)}, folder: ${JSON.stringify(folder)}`)

    let uploadTask: request.UploadTask

    let url = (baseUrl == null ? UrlConstant.BASE_URL : baseUrl) + apiUrl

    let uploadConfig: request.UploadConfig = {
      url: url,
      header: {
        'Content-Type': 'multipart/form-data',
      },
      method: 'POST',
      files: [
        {
          filename: fileName,
          name: 'file',
          uri: 'internal://cache/' + folder + fileName,
          type: fileType
        }
      ],
      data: [{
        name: 'issueId', value: issueId,
      }]
    }
    LogManager.hilogIWithTag(TAG, `upload, uploadConfig: ${JSON.stringify(uploadConfig)}`)

    request.uploadFile(context, uploadConfig).then((data) => {
      LogManager.hilogIWithTag(TAG, `uploadFile success data: ${JSON.stringify(data)}`)

      let upLoadProgress = 0
      let upLoadNewProgress = 0
      let upLoadProgressNum = 0
      let timer: number = setInterval(() => {
        if (upLoadProgress === upLoadNewProgress) {
          upLoadProgressNum++
        } else {
          upLoadProgressNum = 0
          upLoadProgress = upLoadNewProgress
        }
        if (upLoadProgressNum >= OVERTIME) {
          uploadTask.delete().then((result: boolean) => {
            callback(new BusinessErrorImpl(), undefined)
            clearInterval(timer)
            LogManager.hilogIWithTag(TAG, 'Succeeded in removing the download task.');
          }).catch((err: BusinessError) => {
            LogManager.hilogIWithTag(TAG, `Failed to remove the download task. Code: ${err.code}, message: ${err.message}`);
          });
        }
      }, 1000)

      uploadTask = data
      uploadTask.on('headerReceive', (header) => {
        LogManager.hilogIWithTag(TAG, `upload header: ${JSON.stringify(header)}`)
        interface HeaderData {
          url?: string
          id?: string
        }
        interface BodyData {
          data?: HeaderData
        }
        interface HeadersData {
          body?:BodyData
        }
        interface ReceiveData {
          headers?: HeadersData
        }
        let uploadImage: UploadImageInfo = {
          type: type,
          image_name: fileName,
        }
        let headers = (header as ReceiveData).headers
        if (!!headers) {
          const headerData = headers?.body?.data as HeaderData
          if (headerData) {
            uploadImage.url = headerData.url
            uploadImage.id = headerData.id
          }
        }
        let uploadImageArr: UploadImageInfo[];
        if (!!AppStorage.get('uploadImageArr')) {
          uploadImageArr = AppStorage.get('uploadImageArr') as UploadImageInfo[]
        } else {
          uploadImageArr = []
        }
        if (uploadImage.url) {
          uploadImageArr.push(uploadImage)
          AppStorage.setOrCreate('uploadImageArr', uploadImageArr)
        }
        LogManager.hilogIWithTag(TAG, `upload content: ${JSON.stringify(uploadImageArr)}`)

        clearInterval(timer)

        if (callback) {
          callback(undefined, header)
        }
      })

      uploadTask.on('progress', (uploadedSize, totalSize) => {
        upLoadNewProgress = uploadedSize
        LogManager.hilogIWithTag(TAG, `upload totalSize: ${JSON.stringify(totalSize)}, uploadedSize: ${JSON.stringify(uploadedSize)}`)
      })

      uploadTask.on('complete', (taskStates) => {
        for (let index = 0; index < taskStates.length; index++) {
          LogManager.hilogIWithTag(TAG, `upload complete taskState: ${JSON.stringify(taskStates[index])}`)
        }
      })

      uploadTask.on('fail', (taskStates) => {
        for (let index = 0; index < taskStates.length; index++) {
          LogManager.hilogIWithTag(TAG, `upload fail taskState: ${JSON.stringify(taskStates[index])}`)
        }

        clearInterval(timer)

        if (callback) {
          let err = new BusinessErrorImpl()
          err.message = 'uploadTaskOnFail'
          callback(err, undefined)
        }
      })

    }).catch((err: base.BusinessError) => {
      LogManager.hilogIWithTag(TAG, `uploadFile err: ${JSON.stringify(err)}`)

      if (callback) {
        callback(err, undefined)
      }
    })
  }

  public down(context: Context, url: string, fileName: string, callback?: (fileUrl: string) => void) {
    let downloadTask: request.DownloadTask;
    try {
      request.downloadFile(context, {
        url,
        filePath: `${context.cacheDir}/${fileName}.mp4`
      }).then((data: request.DownloadTask) => {
        downloadTask = data;
        downloadTask.on('progress', (uploadedSize, totalSize) => {
          LogManager.hilogIWithTag(TAG, `down totalSize: ${JSON.stringify(totalSize)}, downSize: ${JSON.stringify(uploadedSize)}`)
        })

        downloadTask.on('complete', () => {
          downloadTask.getTaskInfo().then((downloadInfo: request.DownloadInfo) => {
            LogManager.hilogIWithTag(TAG, `downloadInfo: ${JSON.stringify(downloadInfo)}}`)
            if (!!callback) {
              callback(downloadInfo.filePath)
            }
          }).catch((err: BusinessError) => {
            promptAction.showToast({
              message: '视频下载失败'
            })
            if (!!callback) {
              callback('')
            }
            LogManager.hilogIWithTag(TAG, `Failed to query the download task. Code: ${err.code}, message: ${err.message}`)
          });
        })

        downloadTask.on('fail', (err: number) => {
          LogManager.hilogIWithTag(TAG, `Failed to download the task. Code: ${err}--${fileName}`);
          promptAction.showToast({
            message: '视频下载失败'
          })
          if (!!callback) {
            callback('')
          }
        })
      }).catch((err: BusinessError) => {
        promptAction.showToast({
          message: '视频下载失败'
        })
        if (!!callback) {
          callback('')
        }
        LogManager.hilogIWithTag(TAG, `Failed to request the download. Code: ${err.code}, message: ${err.message}`);
      })
    } catch (err) {
      promptAction.showToast({
        message: '视频下载失败'
      })
      if (!!callback) {
        callback('')
      }
      LogManager.hilogIWithTag(TAG, `Failed to request the download. err: ${JSON.stringify(err)}`);
    }
  }
}