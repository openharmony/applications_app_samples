interface  errCode{
  key:number,
  value:string
}
 const errorCode:errCode[] =[
  {key:201,value:'权限不足,不允许卸载'},
  {key:202,value:'找不到指定的包'},
  {key:401,value:'参数错误,无法删除'},
  {key:17700004,value:'找不到指定的用户id'},
  {key:17700020,value:'预置应用无法卸载'},
  {key:17700040,value:'共享包不允许卸载'},
  {key:17700045,value:'权限不足,不允许卸载'}
]

export default class ErrorCodeHandler {
  handleErrorCode(code:number){
    return errorCode.find(item=>{
        return item.key ==code
    })?.value
  }
}


