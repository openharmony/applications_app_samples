// [Start rdb_encryptedEStoreGuidelines_index]
import { storeManager, e_secretKeyObserver } from "../entryability/EntryAbility";
import { relationalStore } from '@kit.ArkData';
import { Store } from './Store';

let storeOption = new Store();

let lockStatus: number = 1;

@Entry
@Component
struct Index {
  @State message: string = '';

  build() {
    Row() {
      Column() {
        Button('加锁/解锁')
          .onClick((event: ClickEvent) => {
            if (lockStatus) {
              e_secretKeyObserver.onLock();
              lockStatus = 0;
            } else {
              e_secretKeyObserver.onUnLock();
              lockStatus = 1;
            }
            lockStatus ? this.message = "解锁" : this.message = "加锁";
          })
          .margin("5")
          .backgroundColor('#0D9FFB')
          .width("50%")
          .height("5%")
          .type(ButtonType.Capsule)

        Button('store type')
          .onClick(async (event: ClickEvent) => {
            e_secretKeyObserver.getCurrentStatus() ? this.message = "estore" : this.message = "cstore";
            console.info(`ECDB_Encry current store : ${this.message}`);
          })
          .margin("5")
          .backgroundColor('#0D9FFB')
          .width("50%")
          .height("5%")
          .type(ButtonType.Capsule)

        Button("put")
          .onClick(async (event: ClickEvent) => {
            let store: relationalStore.RdbStore = await storeManager.getCurrentStore(e_secretKeyObserver.getCurrentStatus());
            storeOption.putOnedata(store);
          })
          .margin(5)
          .backgroundColor('#0D9FFB')
          .width("50%")
          .height("5%")
          .type(ButtonType.Capsule)

        Button("Get")
          .onClick(async (event: ClickEvent) => {
            let store: relationalStore.RdbStore = await storeManager.getCurrentStore(e_secretKeyObserver.getCurrentStatus());
            storeOption.getDataNum(store);
          })
          .margin(5)
          .backgroundColor('#0D9FFB')
          .width("50%")
          .height("5%")
          .type(ButtonType.Capsule)

        Button("delete")
          .onClick(async (event: ClickEvent) => {
            let store: relationalStore.RdbStore = await storeManager.getCurrentStore(e_secretKeyObserver.getCurrentStatus());
            storeOption.deleteAlldata(store);
          })
          .margin(5)
          .backgroundColor('#0D9FFB')
          .width("50%")
          .height("5%")
          .type(ButtonType.Capsule)

        Button("update")
          .onClick(async (event: ClickEvent) => {
            let store: relationalStore.RdbStore = await storeManager.getCurrentStore(e_secretKeyObserver.getCurrentStatus());
            storeOption.updateOnedata(store);
          })
          .margin(5)
          .backgroundColor('#0D9FFB')
          .width("50%")
          .height("5%")
          .type(ButtonType.Capsule)

        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End rdb_encryptedEStoreGuidelines_index]