# bat文件说明
文件上传ftp服务器批处理
使用需知：工作目录默认设置为：C：\ ftpMonitoring（可通过编辑autoCatch.bat更改监听上传目录，建议不要路径包含中文或空格），使用前需要配置指定的FTP服务器地址端口和用户密码。  
init.bat：简单的启动执行计划bat命令，单击鼠标右键即可运行该文件，可以让autoCatch.bat文件启动（不显示黑框），支持win7 / win10大多数版本系统。  
autoCatch.bat：监听工作目录指定后缀文件（可编辑更改），上传到指定FTP服务器路径（可通过newmac更改目标路径）。  
---
autoCatch.bat执行时会出现三个txt文件，以及一个目录，  
openFtp.txt：执行上传文件的命令  
execute.txt：执行上传的命令日志  
moveFile.txt：移动上传成功文件到上载目录的命令  
已上传目录：已上传成功的文件，转移到该目录
