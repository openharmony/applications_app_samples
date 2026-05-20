# Laval-BetaClub

## 介绍
BetaClub是[Laval社区](https://laval.csdn.net/)为laphone开发者提供的问题提交应用。

## 目录结构
```
├── entry                     # 主业务模块
│   └── src       
│       └── main
│           ├── ets           # 业务代码     
├── Shell                     # 常用脚本
├── signature                 # 签名
├── apis                      # 依赖的定制化api

```

## 开发环境
**IDE:** DevEco Studio 4.0 Release(Build Version: 4.0.0.600)

**SDK:** Full-Sdk 4.0.10.15

## 指纹证书
```
161B018F761647414D959344141CAD4F48525DD8DA9B9286844ACED06781E879
```

## preinstall-config
### install_list.json
```json
{
  "app_dir": "/system/app/com.laval.betaclub",
  "removable": false
}
```

### 构建说明
1. `entry\build\default\outputs\default\entry-default-signed.hap`为开发环境构建的hap，`entry\build\default\outputs\product\entry-product-signed.hap`为生产环境构建的hap。

2. 开发环境和生产环境的主要不同为资源的引用。开发环境引用资源为`entry\src\main\resources`，生产环境引用资源为`entry\src\main\resources_product`。所以，**开发环境新增资源时，需要根据需要同步到生产环境**。

3. 构建生产环境时，需要编译release包。

4. 每次版本发布时，单独提pr去做版本号的升级。

5. 开发之前，需要先将根目录`apis`文件夹里的api声明文件copy到使用的SDK的`ets\api`下并重新sync工程。如果后续有新增或修改的api声明文件，需要放到`apis`下并上库。