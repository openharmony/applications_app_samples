/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Logger from '../model/Logger'
import { WebError, HttpError } from '../model/Error'

const TAG: string = 'WebComponent'

@Component
export struct WebComponent {
  private controller: WebController = null
  @Link url: string
  @Link webTitle: string
  @Link browses: string[]
  @Link webError: WebError
  @Link httpError: HttpError
  @Link isLoading: boolean
  @Link isWebError: boolean
  @Link isHttpError: boolean

  aboutToAppear() {
    Logger.info(TAG, `this.url=${this.url}`)
  }

  build() {
    Column() {
      Web({ src: this.url, controller: this.controller })
        .zoomAccess(true)
        .mixedMode(MixedMode.All)
        .onDownloadStart((event?: {
          url: string,
          userAgent: string,
          contentDisposition: string,
          mimetype: string,
          contentLength: number
        }) => {
          if (event) {
            if (event.url || event.mimetype || event.contentLength) {
              AlertDialog.show(
                {
                  title: `userAgent:${event.userAgent}`,
                  message: `url:${event.url}\n mimetype:${event.mimetype}\n contentLength:${event.contentLength}`,
                  confirm: {
                    value: $r('app.string.sure'),
                    action: () => {
                      Logger.log(TAG, 'Button-clicking callback')
                    }
                  },
                  cancel: () => {
                    Logger.log(TAG, 'Closed callbacks')
                  }
                }
              )
            }
          } else {
            Logger.error(TAG, 'onDownloadStart event error')
          }
        })
        .onErrorReceive((event?: {
          request: WebResourceRequest,
          error: WebResourceError
        }) => {
          this.webError.errCode = event.error.getErrorCode()
          this.webError.errInfo = event.error.getErrorInfo()
        })
        .onHttpErrorReceive((event?: {
          request: WebResourceRequest,
          response: WebResourceResponse
        }) => {
          if (event) {
            if (event.response) {
              this.httpError.message = event.response.getReasonMessage()
              this.httpError.code = event.response.getResponseCode()
              this.httpError.data = event.response.getResponseData()
              this.httpError.enCoding = event.response.getResponseEncoding()
              this.httpError.header = JSON.stringify(event.response.getResponseHeader())
              this.httpError.mimeType = event.response.getResponseMimeType()
              this.isHttpError = true
            }
          } else {
            Logger.error(TAG, 'onHttpErrorReceive event error')
          }
        })
        .onTitleReceive((event: { title: string }) => {
          if (event) {
            if (event.title) {
              this.webTitle = event.title
              if (this.webTitle) {
                if (this.webTitle.length > 10) {
                  this.webTitle = this.webTitle.substr(0, 10) + '...'
                }
              }
            }
          } else {
            Logger.error(TAG, 'onTitleReceive event error')
          }
        })
        .onProgressChange((event: { newProgress: number }) => {
          if (event) {
            if (event.newProgress) {
              Logger.info(TAG, `onProgressChange newProgress = ${event.newProgress}`)
            }
          } else {
            Logger.error(TAG, 'onProgressChange event error')
          }
        })
        .onPageBegin((event) => {
          this.isLoading = true
          this.isWebError = false
          if (this.browses.indexOf(this.url, 0) !== -1) {
            this.browses.splice(this.browses.indexOf(this.url, 0), 1)
          }
          this.browses.unshift(this.url)
          Logger.info(TAG, `this.browses = ${JSON.stringify(this.browses)}`)
        })
        .onPageEnd((event) => {
          if (event) {
            this.isLoading = false
          } else {
            Logger.error(TAG, 'onPageEnd event error')
          }
        })
    }
  }
}