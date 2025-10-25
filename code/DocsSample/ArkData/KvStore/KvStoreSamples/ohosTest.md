# 测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|是否自动|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|拉起应用|	设备正常运行|	无|成功拉起应用|是|Pass|
|申请权限|	成功拉起应用|	无|弹出提示框|是|Pass|
|CreateKvManager|	无|	点击CreateKvManager按钮|	log打印Succeeded in creating KVManager.|是|Pass|
|GetKvStore|	成功执行CreateKvManager|	点击GetKvStore按钮|	log打印Succeeded in getting KVStore.|是|Pass|
|Put|	成功执行GetKvStore|	点击Put按钮|	log打印Succeeded in putting data.|是|Pass|
|Get|	成功执行GetKvStore，Put|	点击Get按钮|	log打印Succeeded in getting data. Data|是|Pass|
|Delete|	成功执行GetKvStore，Put|	点击Delete按钮，点击Get按钮|	log打印Succeeded in deleting data.，Get执行后log打印Failed to get data. Code:|是|Pass|
|Backup|	成功执行GetKvStore，Put|	点击Backup按钮|	log打印Succeeded in backing up data.|是|Pass|
|Restore|	成功执行Backup|	点击Delete按钮，点击Get按钮，点击Restore按钮，点击Get按钮|	Delete后Get不到数据,Restore后能Get到数据|是|Pass|
|DeleteBackup|	成功执行Backup|	点击DeleteBackup按钮|	log打印Succeed in deleting Backup.data|是|Pass|
|CloseKvStore|	成功执行GetKvStore|	点击CloseKvStore按钮|	log打印Succeeded in closing KVStore，再次执行Put等按钮log打印kvStore not initialized|是|Pass|
|DeleteKvStore|	成功执行GetKvStore|	点击DeleteKvStore按钮|	log打印Succeeded in deleting KVStore，再次执行Put等按钮log打印kvStore not initialized|是|Pass|
|Sync|	AB两台设备组网成功，两台设备开库成功|	A设备点击Put按钮，Sync按钮，B设备点击Get按钮|	log打印中B设备可以get到数据|是|Pass|
|On|	成功执行GetKvStore|	点击On按钮，点击Put数据|	log打印dataChange callback call data:|是|Pass|