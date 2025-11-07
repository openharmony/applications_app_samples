# 测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|是否自动|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|拉起应用|	设备正常运行|	无|成功拉起应用|是|Pass|
|加锁/解锁|	无|	点击加锁/解锁按钮|	应用下方显示解锁或者加锁|是|Pass|
|StoreType|	无|	点击StoreType按钮| 若点击（加锁/解锁）后显示解锁则点击（StoreType）后显示estore反之加锁对应显示cstore|是|Pass|
|Put| 先将数据库切换到estore|	点击Put按钮|	log打印Succeeded in putting data.|是|Pass|
|Get| 多次Put数据|	点击Get按钮| log打印Succeeded in getting result set num 数量为Put成功的次数|是|Pass|
|Delete| 无|点击Delete按钮，点击Get按钮| log打印Succeeded in deleting且Get的结果数量减一，若数量已经为0则不打印Succeeded in deleting|是|Pass|
|Update| 无| 点击Update按钮|	若数据库已有数据则修改其中一条数据不增加新的数据，log打印update success|是|Pass|
|切换cstore| 无| 点击加锁/解锁按钮，点击StoreType按钮|	应用下方分别显示加锁和cstore|是|Pass|
|重复验证Put，Get，Delete，Update|	同上述验证条件相同|	点击相应的按钮|	输出结果和上面结果相同|是|Pass|
|数据转移|	数据库切换到cstore，Put多条数据Get后记录数据量|	切换到estore，Get后查看数据量，多次来回切换两个数据库重复此类Put,Get步骤|Get查看estore的数据量为cstore加estore之前的数据量之和,再次切换到cstore直接查询数据量为0|是|Pass|