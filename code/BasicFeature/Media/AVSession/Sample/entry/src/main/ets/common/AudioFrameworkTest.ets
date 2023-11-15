import fs from '@ohos.file.fs';

const TAG = "AVCastDemo";

export  default class AudioFrameworkTest {
  public constructor() {
    console.log(TAG, 'start audio framework test init');
    let context = getContext(this);
    let path = context.filesDir;
    //使用沙箱路径获取文件，实际路径为/data/app/el2/100/base/com.example.avcastdemo/haps/entry/files/sample_3s.wav
    const filePath = path + '/sample_3s.wav';
    console.log(TAG, 'file path: ' + filePath);
    fs.stat(filePath, (err, state) => {
      console.log(TAG, 'get file state suc: size = ' + state?.size + ', err = ' + err);
    })
    console.log(TAG, 'try open file: ' + filePath);
    let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
    console.log(TAG, 'try open file SUC: ' + file.fd);
    fs.close(file);
  }
}