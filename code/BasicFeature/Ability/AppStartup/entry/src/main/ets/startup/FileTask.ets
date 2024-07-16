import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';

@Sendable
export default class FileTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    let filesDir = context.filesDir;
    this.createFile(filesDir);
  }

  createFile(filesDir: string) {
    let srcFile = fs.openSync(filesDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(srcFile.fd, 'test StartupTask_003 file write data');
    let destFile = fs.openSync(filesDir + '/destFile.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    // 读取源文件内容并写入至目的文件
    let bufSize = 4096;
    let readSize = 0;
    let buf = new ArrayBuffer(bufSize);

    class Option {
      public offset: number = 0;
      public length: number = bufSize;
    }

    let option = new Option();
    option.offset = readSize;
    let readLen = fs.readSync(srcFile.fd, buf, option);
    while (readLen > 0) {
      readSize += readLen;
      fs.writeSync(destFile.fd, buf, { length: readLen });
      option.offset = readSize;
      readLen = fs.readSync(srcFile.fd, buf, option);
    }
    // 关闭文件
    fs.closeSync(srcFile);
    fs.closeSync(destFile);
  }


  onDependencyCompleted(dependence: string, result: Object): void {
  }
}

