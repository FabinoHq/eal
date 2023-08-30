::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                                                            ::
::                                                                            ::
::                                                                            ::
::                                                                            ::
::                                                                            ::
::                                                                            ::
::                                                                            ::
::                                                                            ::
::                                                                            ::
::                                                                            ::
::                                                                            ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   This is free and unencumbered software released into the public domain.  ::
::                                                                            ::
::   Anyone is free to copy, modify, publish, use, compile, sell, or          ::
::   distribute this software, either in source code form or as a compiled    ::
::   binary, for any purpose, commercial or non-commercial, and by any        ::
::   means.                                                                   ::
::                                                                            ::
::   In jurisdictions that recognize copyright laws, the author or authors    ::
::   of this software dedicate any and all copyright interest in the          ::
::   software to the public domain. We make this dedication for the benefit   ::
::   of the public at large and to the detriment of our heirs and             ::
::   successors. We intend this dedication to be an overt act of              ::
::   relinquishment in perpetuity of all present and future rights to this    ::
::   software under copyright law.                                            ::
::                                                                            ::
::   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,          ::
::   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF       ::
::   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.   ::
::   IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR        ::
::   OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,    ::
::   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR    ::
::   OTHER DEALINGS IN THE SOFTWARE.                                          ::
::                                                                            ::
::   For more information, please refer to <https://unlicense.org>            ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    EAL : Extended Assembly Language                                        ::
::     compilecppO2.bat : Windows cpp O2 make compilation file                ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Get Visual Studio installation path
for /f "delims=" %%i in ('call^
 "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"^
 -all -legacy -property installationPath') do set VCInstallationPath=%%i

:: Setup Visual Studio environment
call "%VCInstallationPath%\VC\Auxiliary\Build\vcvars64.bat"

:: Build with ml64
call cl /c /FA /O2 /std:c++17 main.cpp

:: Link
call link ^
 /out:"main.exe" ^
 /subsystem:console /machine:x64 /largeaddressaware /nodefaultlib ^
 /release /nologo /tlbid:1 /opt:icf /opt:ref /ltcg:off ^
 /tsaware /nxcompat /dynamicbase /highentropyva ^
 /manifestuac:"level='asInvoker' uiAccess='false'" ^
 "kernel32.lib" "libucrt.lib" "libcmt.lib" "libvcruntime.lib" ^
 main.obj

:: "libcmt.lib" "libvcruntime.lib" "libucrt.lib" "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib"
