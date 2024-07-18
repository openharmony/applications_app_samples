import fs from '@ohos.file.fs';
import buffer from '@ohos.buffer';
import { RdbStoreUtil, SingleKVStoreUtil } from '../util/SingleKVStore';
import distributedKVStore from '@ohos.data.distributedKVStore';
import { BusinessError } from '@ohos.base';
import relationalStore from '@ohos.data.relationalStore';
import startupManager from '@ohos.app.appstartup.startupManager';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @StorageLink('image') image: PixelMap | undefined = undefined;
  @State fileStr: string = 'fileStr';
  @State kvStoreStr: string = 'kvStoreStr';
  @State rdbStoreStr: string = 'rdbStoreStr';

  aboutToAppear(): void {
    this.readFile();
    this.getKvStoreData();
    this.getRdbStoreData();
  }

  readFile() {
    let filesDir = getContext().filesDir;
    let file = fs.openSync(filesDir + '/destFile.txt', fs.OpenMode.READ_WRITE);
    // 从文件读取一段内容
    let arrayBuffer = new ArrayBuffer(1024);

    class Option {
      public offset: number = 0;
      public length: number = 0;
    };

    let option = new Option();
    option.length = arrayBuffer.byteLength;
    let readLen = fs.readSync(file.fd, arrayBuffer, option);
    let buf = buffer.from(arrayBuffer, 0, readLen);
    this.fileStr = buf.toString();
    // 关闭文件
    fs.closeSync(file);
  }

  getKvStoreData() {
    SingleKVStoreUtil.getKVStore()
      .then((kvStore: distributedKVStore.SingleKVStore) => {
        const KEY_TEST_STRING_ELEMENT = 'key_test_string';
        kvStore.get(KEY_TEST_STRING_ELEMENT, (err, data) => {
          if (err != undefined) {
            console.error(`Failed to get data. Code:${err.code},message:${err.message}`);
            return;
          }
          this.kvStoreStr = data as string;
          console.info(`Succeeded in getting data. Data:${data}`);
        });
      }).catch((err: BusinessError) => {
      console.error(`Failed to create KVManager.message:${err}`);
    });
  }

  getRdbStoreData() {
    RdbStoreUtil.getRdbStore(getContext())
      .then((rdbStore: relationalStore.RdbStore) => {

        let predicates = new relationalStore.RdbPredicates('EMPLOYEE');
        predicates.equalTo('NAME', 'Lisa');

        rdbStore.query(predicates, ['ID', 'NAME', 'AGE', 'SALARY'], (err: BusinessError, resultSet) => {
          if (err) {
            console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
            return;
          }
          console.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
          // resultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
          while (resultSet.goToNextRow()) {
            const id = resultSet.getLong(resultSet.getColumnIndex('ID'));
            const name = resultSet.getString(resultSet.getColumnIndex('NAME'));
            const age = resultSet.getLong(resultSet.getColumnIndex('AGE'));
            const salary = resultSet.getDouble(resultSet.getColumnIndex('SALARY'));
            console.info(`id=${id}, name=${name}, age=${age}, salary=${salary}`);
            this.rdbStoreStr = `id=${id}, name=${name}, age=${age}, salary=${salary}`;
          }
          // 释放数据集的内存
          resultSet.close();
        })
      }).catch((err: BusinessError) => {
      console.error(`Failed to create KVManager.message:${err}`);
    });
  }

  build() {
    Column() {
      Button($r('app.string.Manual_mode'))
        .size({ width: 100, height: 100 })
        .onClick(() => {
          if (!startupManager.isStartupTaskInitialized('ImageKnifeTask')) {
            let startParams = ['ImageKnifeTask'];
            try {
              startupManager.run(startParams).then(() => {
                router.pushUrl({ url: 'pages/ImageKnife' })
              }).catch((error: BusinessError) => {
                console.info("StartupTest promise catch error, error = " + JSON.stringify(error));
                console.info("StartupTest promise catch error, startParams = "
                  + JSON.stringify(startParams));
              })
            } catch (error) {
              let errMsg = JSON.stringify(error);
              let errCode: number = error.code;
              console.log('Startup catch error , errCode= ' + errCode);
              console.log('Startup catch error ,error= ' + errMsg);
            }
          }

        })
      Text(this.fileStr)
      Text(this.kvStoreStr)
      Text(this.rdbStoreStr)
        .margin({ top: 30 })

      Image(this.image).margin({ top: 30 }).width(300)
        .height(300)

    }
    .height('100%')
    .width('100%')
  }
}