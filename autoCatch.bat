chcp 65001
@echo off 
%1 %2
ver|find "5.">nul&&goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin

setlocal enabledelayedexpansion

::上传到ftp服务器目标路径
set newmac=6C-2B-59-54-D2-4E
::设置指定目录，多个目录用英文逗号隔开，如果路径中有空格，请给该路径加上英文双引号 
set dire=C:\ftpMonitoring
::设置指定上传文件后缀名，多个后缀用英文逗号隔开，同样有空格的要用英文双引号括起来
set ext=*.doc,*.docx,*.jpg,*png,*.pdf
::ftp上传失败出现的代码
set failCode="421 425 426 450 451 452 500 501 502 503 504 530 532 550 551 552 553"

set ftpulr=172.16.121.20
set ftpuser=ftp123
set ftppwd=12345678
set ftpport=21


::需要管理者模式运行
for /f "tokens=12 " %%c in ('ipconfig /all ^| find /i "Physical"') do (
	set mac=%%c
	echo !mac!
)



:Loop
set "Change="
echo 正在监控文件夹中 ...

for  %%a in (%dire%) do (
	:: 设置当前为执行下面命令的路径
    pushd "%%~a"

    for %%b in (%ext%) do (
        for /f "delims=" %%c in ('dir /b "%%~b"') do (
		 echo 输入的是 "%%~a\%%~c"
		 set Change=1
		 goto label
		)
    )
)

:label
::判断是否成功上传到FTP
set result=0

if defined Change (

	echo open %ftpulr% %ftpport%>openFtp.txt
	echo %ftpuser%>>openFtp.txt
	echo %ftppwd%>>openFtp.txt
	::echo cd !mac!>>openFtp.txt
	echo cd %newmac%>>openFtp.txt
	
	for  %%a in (%dire%) do (
		:: 设置当前为执行下面命令的路径
		pushd "%%~a"
		for %%b in (%ext%) do (
			for /f "delims=" %%c in ('dir /b "%%~b"') do (
			 ::二进制
			 echo binary>>openFtp.txt
			 echo put "%%~a\%%~c">>openFtp.txt
			 ::记录上传的文件
			 echo "%%~a\%%~c">moveFile.txt
			)
		)

	)

	echo bye>>openFtp.txt
	echo Transport data......
	

	ftp -s:openFtp.txt >execute.txt

	for /f %%c in (execute.txt) do (
		echo %failCode%|findstr /c:"%%c">nul 2>nul && (
		 set result=1
		)
	)

	if !result!==0 (
       for /f "delims=" %%i in (moveFile.txt) do (
           Md "uploaded" 2>nul
		   echo %%i
           move "%%~i" "uploaded\"
        )
    )
	
)

popd
goto Loop