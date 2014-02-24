@echo off
echo.
echo Copyright (C) 2014 The sayNDK Project
echo.
echo Licensed under the Apache License, Version 2.0 (the "License");
echo you may not use this file except in compliance with the License.
echo You may obtain a copy of the License at
echo.
echo      http://www.apache.org/licenses/LICENSE-2.0
echo.
echo Unless required by applicable law or agreed to in writing, software
echo distributed under the License is distributed on an "AS IS" BASIS,
echo WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
echo See the License for the specific language governing permissions and
echo limitations under the License.
echo.

cd /d %~dp0

rem echo set dos windows size : cols=113, lines=150, color=black
rem mode con cols=113 lines=15 & color 0f

rem set whether shutdown computer or not when call end with the batch.
set /a END_WITH_SHUTDOWN_NO=0
set /a END_WITH_SHUTDOWN_YES=1
set /a END_WITH_SHUTDOWN_YES_TIME=2
set /a END_WITH_SHUTDOWN_FLAG=0

rem set other values to included both MinGW and Cygwin Env.
set /a INSIDE_UTILS_ENV_MINGW=0
set /a INSIDE_UTILS_ENV_CYGWIN=1
set /a INSIDE_UTILS_ENV_BOTHALL=2
set /a INSIDE_UTILS_ENV_FLAG=1

set /a INSIDE_UTILS_ENV_JAVA=1
set /a INSIDE_UTILS_ENV_VISUAL_STUDIO=0
set /a INSIDE_UTILS_ENV_QT=0

set /a SETTINGS_HTTP_PROXY=0

rem set other values to do some user cmds
set /a EOF_ENV_CMD=0
set /a EOF_ENV_BASH=1
set /a EOF_ENV_EOF=3
set /a EOF_ENV_FLAG=3

rem set JAVA SDK values will be used
set /a USED_JAVA_VER_1D6=0
set /a USED_JAVA_VER_1D7=1
set /a USED_JAVA_VER_NONE=3
set /a USED_JAVA_VER_FLAG=1

set INSTALL_ENV_DIR_MINGW=D:/MinGW
set INSTALL_ENV_DIR_CYGWIN=D:/cygwin

set ORIGIN_PATH=%PATH%

SetLocal EnableDelayedExpansion
if %INSIDE_UTILS_ENV_FLAG% EQU %INSIDE_UTILS_ENV_MINGW% (
    echo Init Included MinGW env.
    set "PATH=%INSTALL_ENV_DIR_MINGW%/bin;!PATH!"
    set "PATH=%INSTALL_ENV_DIR_MINGW%/msys/1.0/bin;%INSTALL_ENV_DIR_MINGW%/msys/1.0/local/bin;!PATH!"
) else (
  if %INSIDE_UTILS_ENV_FLAG% EQU %INSIDE_UTILS_ENV_CYGWIN% (
    echo Init Included Cygwin env.
    set "PATH=%INSTALL_ENV_DIR_CYGWIN%/bin;!PATH!"
  ) else (
    if %INSIDE_UTILS_ENV_FLAG% EQU %INSIDE_UTILS_ENV_BOTHALL% (
      echo Init Included MinGW and Cygwin env.
      set "PATH=%INSTALL_ENV_DIR_CYGWIN%/bin;!PATH!"
      set "PATH=%INSTALL_ENV_DIR_MINGW%/bin;!PATH!"
      set "PATH=%INSTALL_ENV_DIR_MINGW%/msys/1.0/bin;%INSTALL_ENV_DIR_MINGW%/msys/1.0/local/bin;!PATH!"
    ) else (
      echo Init Excluded MinGW and Cygwin env.
    )
  )
)
SetLocal DisableDelayedExpansion
echo SayCV_MXE: Add git bin dir to PATH.
set PATH=%PATH%;D:/Program Files (x86)/Git/bin
set PATH=%PATH%;D:/Program Files/Git/bin
echo SayCV_MXE: Add Python bin dir to PATH.
set PATH=D:/Python27;%PATH%
rem echo %PATH%

echo SayCV_MXE: Init HOME directory to here call batfile.
set HOME=%cd%
set ORIGIN_HOME=%cd%

if '%INSIDE_UTILS_ENV_JAVA%' == '1' (
SetLocal EnableDelayedExpansion
echo SayCV_MXE: Set JAVA_HOME Env.
set JAVA_INSTALL_DIR=D:/cygwin/opt/Java
if '%USED_JAVA_VER_FLAG%'=='%USED_JAVA_VER_1D6%' (
	set "JAVA_HOME=!JAVA_INSTALL_DIR!/jdk6"
	set  "JRE_HOME=!JAVA_INSTALL_DIR!/jre6
	set  "CLASSPATH=!JAVA_HOME!/lib;!JRE_HOME!/lib
	echo SayCV_MXE: Set JAVA_HOME Env to 1.6.
) else (
	if '%USED_JAVA_VER_FLAG%'=='%USED_JAVA_VER_1D7%' (
		set "JAVA_HOME=!JAVA_INSTALL_DIR!/jdk7"
		set  "JRE_HOME=!JAVA_INSTALL_DIR!/jre7
		set  "CLASSPATH=!JAVA_HOME!/lib;!JRE_HOME!/lib
		echo SayCV_MXE: Set JAVA_HOME Env to 1.7.
	) else (
		echo SayCV_MXE: Do NOT Needed Set JAVA_HOME Env.
	)
)

echo SayCV_MXE: Add JAVA bin dir to PATH.
set PATH=!JAVA_HOME!/bin;!PATH!;

if not exist "!JRE_HOME!" (
	echo SayCV_MXE: But directory of JRE_HOME NOT Exist.
	set PATH=!JAVA_HOME!/jre/bin;!PATH!;
) else (
	set PATH=!JRE_HOME!/bin;!PATH!;
)
SetLocal DisableDelayedExpansion
)

if '%INSIDE_UTILS_ENV_QT%'=='1' (
SetLocal EnableDelayedExpansion
echo SayCV_MXE: Add QT bin dir to PATH.
set QMAKESPEC=win32-g++
set "QT_SDK_DIR=D:/MinGW/opt/Qt/4.8.4"
set "QT_SDK_DIR=D:/work_coding/bitbucket-SayCV-Hosting/repo_SayCV_UTILS/SayCV_MXE/tmp/qt/qt-everywhere-opensource-src-4.8.4"
set QT64_502_ROOT=!SayCV_MXE_HOME!/usr/opt/Qt64-5.0.2
set Qt32_484_ROOT=!SayCV_MXE_HOME!/usr/opt/Qt32-4.8.4
if '1'=='0' (
	set "PATH=!QT64_502_ROOT!/bin;!PATH!"
	set "PATH=!QT64_502_ROOT!/pre_bin;!PATH!"
	set "QTDIR=!QT64_502_ROOT!"
) else (
	if '1'=='0' (
		set "PATH=!Qt32_484_ROOT!/bin;!PATH!"
		set "PATH=!Qt32_484_ROOT!/ported32/bin;!PATH!"
		set "QTDIR=!Qt32_484_ROOT!"
	) else (
		set "PATH=!QT_SDK_DIR!/bin;!PATH!"
		set "QTDIR=!QT_SDK_DIR!"
	)
)
SetLocal DisableDelayedExpansion
)

if '%INSIDE_UTILS_ENV_VISUAL_STUDIO%'=='1' (
setlocal enabledelayedexpansion
echo SayCV_MXE: Set VCPath and SDKPath.
set      "VCROOT=D:/Program Files (x86)/Microsoft Visual Studio 11.0"
set "VC_IDE_PATH=!VCROOT!/Common7/IDE"
set "VC_BIN_PATH=!VCROOT!/VC/bin"
set      "VCPath=!VCROOT!/VC"
set     "SDKPath=D:/Program Files (x86)/Microsoft SDKs/Windows/v7.1"

echo SayCV_MXE: Add Microsoft Visual Studio IDE dir to PATH.
set "PATH=!PATH!;!VC_IDE_PATH!"

echo SayCV_MXE: Add Microsoft Visual Studio VC bin to PATH.
set "PATH=!PATH!;!VC_BIN_PATH!"

echo SayCV_MXE: Call vcvars32.bat.
call "!VCPath!/bin/vcvars32.bat"
setlocal disabledelayedexpansion
)

if %SETTINGS_HTTP_PROXY% ==1 (
	echo SayCV_MXE: Setting http_proxy on.
	set http_proxy=http://127.0.0.1:8087/
	set https_proxy=http://127.0.0.1:8087/
)

REM ******************************
REM Start ...
REM ##############################

cd ../
set SAY_REPO_HOME=%cd%
cd %HOME%
set SayCV_MXE_HOME=%SAY_REPO_HOME%/repo_SayCV_UTILS/SayCV_MXE
echo SayCV_MXE: Add Apache ant bin dir to PATH.
set PATH=%SayCV_MXE_HOME%/usr/opt/ant/bin;%PATH%;

echo SayCV_MXE: Add Google Go bin dir to PATH.
set GOOS=windows
set GOARCH=386
set GOROOT=%SayCV_MXE_HOME%/usr/opt/go
set PATH=%GOROOT%/bin;%PATH%
set PATH=%GOROOT%/pkg/tool/windows_386;%PATH%

echo SayCV_MXE: Add SayCV_MXE bin dir to PATH.
set PATH=%SayCV_MXE_HOME%/bin;%PATH%;
set CROSS_COMPILE=i686-pc-mingw32-

echo SayCV_MXE: Add ARDUINO IDE dir to PATH.
:::set ARDUINO_IDE_DIR=%SayCV_MXE_HOME%/usr/opt/arduino
:::set ARDUINO=%ARDUINO_IDE_DIR%
:::set PATH=%ARDUINO_IDE_DIR%/bin;%PATH%

echo SayCV_MXE: Add Android SDK adb to PATH.
set ANDROID_SDK_HOME=D:/Android/android-studio/sdk
set ANDROID_HOME=%ANDROID_SDK_HOME%
set PATH=%ANDROID_SDK_HOME%/platform-tools;%PATH%

echo SayCV_MXE: Add Gradle BIN dir to PATH.
set GRADLE_HOME=D:/Android/gradle
set PATH=%GRADLE_HOME%/bin;%PATH%

echo SayCV_MXE: Add Maven BIN dir to PATH.
set M2_HOME=D:/Android/maven/apache-maven
set PATH=%M2_HOME%/bin;%PATH%

echo SayCV_MXE: Settings Customized android libs.
set SAY_JCMS_HOME=%cd%/sayJCMs

echo SayCV_MXE: Add Android Studio IDE dir to PATH.
set "ANDROID_STUDIO_HOME=D:/Android/android-studio"

echo SayCV_MXE: Add sayNDK dir to PATH.

set ANDROID_NDK_ROOT=D:/Android/android-ndk-r9b
set SAY_NDK_ROOT=%SAY_REPO_HOME%/sayndk
if "1"=="1" (
set NDK_ROOT=%ANDROID_NDK_ROOT%
) else (
set NDK_ROOT=%SAY_NDK_ROOT%
)
set NDK_TOOLCHAINS_ROOT=%NDK_ROOT%/toolchains/arm-linux-androideabi-4.8/prebuilt/windows
set NDK_TOOLCHAINS_PREFIX=%NDK_TOOLCHAINS_ROOT%/bin/arm-linux-androideabi
set NDK_TOOLCHAINS_INCLUDE=%NDK_TOOLCHAINS_ROOT%/lib/gcc/arm-linux-androideabi/4.8/include-fixed
set PATH=%NDK_TOOLCHAINS_ROOT%/bin;%PATH%

set NDK_PLATFORM_ROOT=%NDK_ROOT%/platforms/android-18/arch-arm
set NDK_PLATFORM_INCLUDE=%NDK_PLATFORM_ROOT%/usr/include
set NDK_PLATFORM_LIB=%NDK_PLATFORM_ROOT%/usr/lib

set NDK_SYSROOT=%NDK_PLATFORM_ROOT%

set BUILD_PROJECT_DIRECTORIES=%SAY_NDK_ROOT%/build/core/build-project-directories.mk

echo SayCV_MXE: preinstall some files to build.
echo SayCV_MXE: 

echo SayCV_MXE: Settings boolean_skip_checking_stamp_h to enable skip some steps.
set boolean_skip_checking_stamp_h=0
set boolean_skip_checking_stamp_h=1

echo SayCV_MXE: Checked Requirements Finished.

if not exist %JAVA_HOME%/lib/junit.jar (
	cp -rf %HOME%/libs/junit.jar %JAVA_HOME%/lib/junit.jar
)

set  CLASSPATH=%CLASSPATH%;%HOME%/libs
echo %CLASSPATH%
rem ant compile jar run
ant >%HOME%/log-ant.log 2>&1


REM ##############################
REM End ...
REM ******************************

:__subCall_Status_Code__
if "%errorlevel%"=="0" ( 
	echo Done Sucessful.
	goto :__subCall_Call_Branch__
) else (
  if "%errorlevel%"=="1" (
  	echo Done Failed.
  	goto :__subCall_Call_Branch__
  ) else (
    echo Not Found Error.
    echo "errorlevel=%errorlevel%"
  	goto :__subCall_Call_Branch__
  )
)

:__subCall_Call_Branch__
if %EOF_ENV_FLAG% EQU %EOF_ENV_CMD% (
  call :__subCall_CMD__
) else (
  if %EOF_ENV_FLAG% EQU %EOF_ENV_BASH% (
  	call :__subCall_BASH__
  ) else (
  	call :__subCall_EOF__
  )
)

:__subCall_BASH__
  bash --login -i
  goto :__subCall_EOF__

:__subCall_CMD__
  cmd
  goto :__subCall_EOF__

:__subCall_EOF__
  call :__subCall_ShutDown_EOF__
:EOF
	cd %ORIGIN_HOME%
  PAUSE
  EXIT

:__subCall_ShutDown_EOF__
  if "END_WITH_SHUTDOWN_FLAG" == "END_WITH_SHUTDOWN_YES_TIME" (
    at 22:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "It was late, should go to bed£¡"
    at 13:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "The power went out quickly, should quick save game£¡"
    at 15:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "The power went out quickly, should quick save game£¡"
    at 9:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "The power went out quickly, should quick save game£¡"
    at 5:50 every:M,T,W,Th,F,S,Su shutdown -s -t 60 -c "The power went out quickly, should quick save game£¡"
    echo Start timing to close computer£¡
  ) else (
    if "END_WITH_SHUTDOWN_FLAG" == "END_WITH_SHUTDOWN_YES" (
      shutdown -s -t 00
      echo Start to close computer£¡
    ) else (
      echo Do Nothing for shutdown computer!!!
    )
  )
  goto :EOF


