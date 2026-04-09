export class FileSendModel {
  filePath: string = ''
  fileName: string = ''
  size: number = 0
  type: number = 0
  deviceName: string = ''
  thumbnail?: string = ''
  status?: string = ''
  data?: ArrayBuffer = new ArrayBuffer(0)
  offset?: number = 0
  length?: number = 0
}