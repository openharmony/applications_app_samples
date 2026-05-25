import http from '@ohos.net.http';
import {media} from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';

interface FileEntry {
  file: fs.File;
  path: string;
}

export class DownloadPool {
  private flag: boolean = false; // 是否启用缓存
  private fileMap: Map<number, FileEntry> = new Map();

  constructor() {
  }

  private getFilePath(uuid: number, offset: number): string {
    return `/data/storage/el2/base/haps/entry/files/segment_${uuid}_${offset}.data`;
  }
  // [Start downloadWork]
  public downloadWork(request: media.MediaSourceLoadingRequest, uuid: number,
    offset: number, length: number, url: string) {
    let filePath = this.getFilePath(uuid, offset);
    let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    this.fileMap.set(uuid, { file: file, path: filePath });
    this.rangeDownload(offset, length, request, uuid, url, file);
  }

  private rangeDownload(offset: number, length: number, mediaRequest: media.MediaSourceLoadingRequest,
    uuid: number, url: string, file: fs.File) {
    let httpRequest = http.createHttp();
    let headers: Record<string, string> = {};
    headers['Range'] = `bytes=${offset}-${offset + length - 1}`

    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: headers,
      expectDataType: http.HttpDataType.ARRAY_BUFFER
    };

    httpRequest.request(url, options, (err: BusinessError, data: http.HttpResponse) => {
      if (err) {
        console.error(`HTTP request failed: ${JSON.stringify(err)}`);
        httpRequest.destroy();
        return;
      }

      if (data.responseCode == 200 || data.responseCode == 206) {
        let responseHeaders: Record<string, string> = {};
        if (data.header) {
          responseHeaders = data.header as Record<string, string>;
        }
        mediaRequest.respondHeader(uuid, responseHeaders);
        console.info('respondHeader Header: ' + JSON.stringify(responseHeaders));

        if (data.result instanceof ArrayBuffer) {
          fs.write(file.fd, data.result);
          let buf = new ArrayBuffer(length);
          fs.read(file.fd, buf, { offset: 0 ,length: length }).then((num: number) => {
            console.info(`read length ${num}`);
          }) // 若需要缓存，则可在此处保存读到的数据
          mediaRequest.respondData(uuid, offset, data.result);
          console.info(`data.result length ${data.result.byteLength}`);

        }
      } else {
        console.error(`Unexpected response code: ${data.responseCode}`);
      }

      httpRequest.destroy();
    });
  }
  // [End downloadWork]
}

export enum FileType {
  LOCAL,
  URL,
  MEDIA_SOURCE
}

export enum ProgressType {
  TIME_UPDATE,
  GET_PTS
}

export class FileInfo {
  public fileName: string;
  public type: FileType;
  public progress: ProgressType;

  constructor(fileName: string, type: FileType, progress: ProgressType) {
    this.fileName = fileName;
    this.type = type;
    this.progress = progress;
  }
}

