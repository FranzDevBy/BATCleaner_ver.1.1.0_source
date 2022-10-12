unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, ShellAPI, Windows, Unit2, Unit3, INIFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckGroup1: TCheckGroup;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    MenuFile: TMenuItem;
    MenuClear: TMenuItem;
    MenuClose: TMenuItem;
    MenuBat: TMenuItem;
    MenuTools: TMenuItem;
    MenuProperties: TMenuItem;
    MenuItem4: TMenuItem;
    MenuHelp: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure MenuBatClick(Sender: TObject);
    procedure MenuClearClick(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuHelpClick(Sender: TObject);
    procedure MenuPropertiesClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13, k14: boolean;
  f, m : TextFile;
  FileDir:String;
  s: string;
  y1: string;

implementation

{$R *.lfm}

{ TForm1 }

function  FileExec( const CmdLine: String; bHide, bWait: Boolean): Boolean;
var
  StartupInfo : TStartupInfo;
  ProcessInfo : TProcessInformation;
begin
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    if bHide then
       wShowWindow := SW_HIDE
    else
       wShowWindow := SW_SHOWNORMAL;
  end;

  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, False,
               NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
  if Result then
     CloseHandle(ProcessInfo.hThread);

  if bWait then
     if Result then
     begin
       WaitForInputIdle(ProcessInfo.hProcess, INFINITE);
       WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
     end;
  if Result then
     CloseHandle(ProcessInfo.hProcess);
end;

procedure IniRead();
begin
   ini := TIniFile.Create('settings.ini');
    try

      y1 := ini.ReadString('BATCleaner', 'y1', y1);

    finally
      FreeAndNil(ini);
    end;
end;

procedure Cleaner ();
begin
CreateDir('data'); //создаем папку
FileDir:='data\input.bat';
AssignFile(f,FileDir); //подключаемся к файлу
if not FileExists(FileDir) then
 begin
  Rewrite(f); //создаем файл
  CloseFile(f); //закрываем файл
 end;
AssignFile(f,FileDir);  //откриваем файл
Rewrite(f);

s:='@echo off';
Writeln(f, s);

IniRead();
if (y1='1') then //если в файле settings.ini "1" то выполняем дополнительный код
begin
s:='echo Vypolnyaetsya procedura ochistki ot nenuzhnyh vremennyh fajlov....';
//подождите, выполняется процедура очистки от ненужных временных файлов
Writeln(f, s);
//s:='>logfile.log 2>&1 Call :Kuku';
s:='>logfile_%date%.log 2>&1 Call :Kuku';
Writeln(f, s);
s:='GoTo :Eof';
Writeln(f, s);
s:=':Kuku';
Writeln(f, s);

end;

s:='echo Vypolnyaetsya procedura ochistki ot nenuzhnyh vremennyh fajlov....';
//подождите, выполняется процедура очистки от ненужных временных файлов
Writeln(f, s);
s:='echo Start date: %date%'; //выводим дату начала
Writeln(f, s);
s:='echo Start time: %time:~,-3%'; //вывыодим время начала
Writeln(f, s);
s:='echo.';
Writeln(f, s);

if k1=true then //очистить временные файлы, созданные в процессе работы программ
 begin
      s:='echo //Ochistka vremennych faylov, sozdannych v prozesse raboty programm (*.tmp, *._mp)';
      Writeln(f, s);
      s:='del /f /s /q %systemdrive%\*.tmp';
      Writeln(f, s);
      s:='del /f /s /q %systemdrive%\*._mp';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k2=true then //очистить лог-файлы (*.log)
 begin
      s:='echo //Ochistka log-faylov (*.log)';
      Writeln(f, s);
      s:='del /f /s /q %systemdrive%\*.log';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k3=true then //очистить временные файлы индекса помощи (*.gid)
 begin
      s:='echo //Ochistka vremennych faylov indeksa pomoschi (*.gid)';
      Writeln(f, s);
      s:='del /f /s /q %systemdrive%\*.gid';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k4=true then //очистить файлы восстановления (*.chk)
 begin
      s:='echo //Ochistka faylov vosstanovleniya (*.chk)';
      Writeln(f, s);
      s:='del /f /s /q %systemdrive%\*.chk';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k5=true then //очистить файлы резервных копий (*.old)
 begin
      s:='echo //Ochistka faylov rezervnych kopiy (*.old)';
      Writeln(f, s);
      s:='del /f /s /q %systemdrive%\*.old';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k6=true then //очистить бак-файлы (*.bak)
 begin
      s:='echo //Ochistka bak-faylov (*.bak)';
      Writeln(f, s);
      s:='del /q /f /s %systemdrive%\*.bak';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k7=true then //очистить корзину
 begin
      s:='echo //Ochistka korziny (C:\)';
      Writeln(f, s);
      s:='del /q /s %systemdrive%\$Recycle.bin\*';
      Writeln(f, s);
      s:='for /d %%x in (%systemdrive%$Recycle.bin*) do @rd /s /q "%%x"';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k8=true then //очистить папку Prefetch
 begin
      s:='echo //Ochistka papki Prefetch';
      Writeln(f, s);
      s:='del /f /s /q %windir%\Prefetch\*.*';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k9=true then //очистить временную папку Windows
 begin
      s:='echo //Ochistka vremennoy papki Windows';
      Writeln(f, s);
      s:='rd /s /q %windir%\temp & md %windir%\temp';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k10=true then //очистить временные папки Temp
 begin
      s:='echo //Ochistka vremennych papok TEMP';
      Writeln(f, s);
      s:='del /q /f /s %WINDIR%\Temp\*.*';
      Writeln(f, s);
      s:='del /q /f /s %SYSTEMDRIVE%\Temp\*.*';
      Writeln(f, s);
      s:='del /q /f /s %Temp%\*.*';
      Writeln(f, s);
      s:='del /q /f /s %Tmp%\*.*';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k11=true then //очистить файлы recent
 begin
      s:='echo //Ochistka Recent-faylov';
      Writeln(f, s);
      s:='del /f /q %userprofile%\Recent\*.*';
      Writeln(f, s);

      s:='del /F /Q %APPDATA%\Microsoft\Windows\Recent\*';
      Writeln(f, s);
      s:='del /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*';
      Writeln(f, s);
      s:='del /F /Q %APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*';
      Writeln(f, s);
      s:='REG Delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /VA /F';
      Writeln(f, s);
      s:='REG Delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths /VA /F';
      Writeln(f, s);
      s:='echo.';
      Writeln(f, s);
 end;

if k12=true then //очистить файлы cookies
 begin
      s:='echo //Ochistka Cookies-faylov';
      Writeln(f, s);
      s:='del /f /q %userprofile%\Cookies\*.*';
      Writeln(f, s);

      //MicrosoftEdge
      if FileExists('C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe')then
      begin
      s:='RD /S /Q "%LocalAppData%\MicrosoftEdge\Cookies"';
      Writeln(f, s);
      s:='RD /S /Q "%LocalAppData%\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\INetCookies"';
      Writeln(f, s);
      s:='RD /S /Q "%LocalAppData%\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\MicrosoftEdge\Cookies"';
      Writeln(f, s);
      s:='RD /S /Q "%LocalAppData%\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\#!001\INetCookies"';
      Writeln(f, s);
      s:='RD /S /Q "%LocalAppData%\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\#!001\MicrosoftEdge\Cookies"';
      Writeln(f, s);
      s:='RD /S /Q "%LocalAppData%\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\#!001\MicrosoftEdge\User\Default\DOMStore"';
      Writeln(f, s);
      s:='RD /S /Q "%LocalAppData%\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\#!002\INetCookies"';
      Writeln(f, s);
      s:='RD /S /Q "%LocalAppData%\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\#!002\MicrosoftEdge\Cookies"';
      Writeln(f, s);
      s:='RD /S /Q "%LocalAppData%\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\#!002\MicrosoftEdge\User\Default\DOMStore"';
      Writeln(f, s);
      end;

      //Internet Explorer
      if FileExists('C:\Program Files\Internet Explorer\iexplore.exe')then
      begin
      s:='del /q /f /s %systemdrive%\Users\%USERNAME%\AppData\Local\Microsoft\Intern~1\*.*';
      Writeln(f, s);
      s:='del /q /f /s %systemdrive%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\History\*.*';
      Writeln(f, s);
      s:='del /q /f /s %systemdrive%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\Tempor~1\*.*';
      Writeln(f, s);
      s:='del /q /f /s %systemdrive%\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Cookies\*.*';
      Writeln(f, s);
      s:='del /q /f /s %systemdrive%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\History\*.*';
      Writeln(f, s);
      s:='%systemdrive%\bin\regdelete.exe HKEY_CURRENT_USER "Software\Microsoft\Internet Explorer\TypedURLs"';
      Writeln(f, s);
      end;

      s:='echo.';
      Writeln(f, s);
 end;

if k13=true then //очистить папку кеша браузера
 begin
      s:='echo //Ochistka papku kesha brauzera';
      Writeln(f, s);
      s:='del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"';
      Writeln(f, s);

      s:='del "%systemdrive%\Users\%username%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*" /f /s /q';
      Writeln(f, s);
      s:='del "del "%systemdrive%\Documents and Settings\%username%\Local Settings\Temporary Internet Files\*.*" /f /s /q';
      Writeln(f, s);

      s:='echo.';
      Writeln(f, s);
 end;

if k14=true then //очистить временную папку текущего пользователя
 begin
      s:='echo //Ochistka vremennoy papki tekuschego polzovatelya';
      Writeln(f, s);
      s:='del /f /s /q "%userprofile%\Local Settings\Temp\*.*"';
      Writeln(f, s);
 end;

 s:='echo.';
 Writeln(f, s);
 s:='echo Ochistka ot nenuzhnyh vremennyh fajlov zavershena.'; //очистка завершена
 Writeln(f, s);
 s:='echo End date: %date%'; //выводим дату окончания
 Writeln(f, s);
 s:='echo End time: %time:~,-3%'; //выводим время окончания
 Writeln(f, s);
 s:='echo.';
 Writeln(f, s);


//диалоговое сообщение
s:='Echo %~dp0\msgbox.vbs'; //создаем vbs-скрипт
Writeln(f, s);
s:='Echo MsgBox "Ochistka ot nenuzhnyh vremennyh fajlov zavershena.", vbSystemModal, "Information" >> %~dp0\msgbox.vbs';
Writeln(f, s);
s:='Echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> %~dp0\msgbox.vbs'; //удаление vbs-скриптом самого себя
Writeln(f, s);
s:='Echo strScript = Wscript.ScriptFullName >> %~dp0\msgbox.vbs'; //удаление vbs-скриптом самого себя
Writeln(f, s);
s:='Echo objFSO.DeleteFile(strScript) >> %~dp0\msgbox.vbs'; //удаление vbs-скриптом самого себя
Writeln(f, s);
s:='start %~dp0\msgbox.vbs > nul';
Writeln(f, s);

if (y1='1') then //если в файле settings.ini "1" то выполняем дополнительный код
begin
s:='GoTo :Eof';
Writeln(f, s);
end;

CloseFile(f); //закрываем файл

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
k1:=CheckBox1.checked;
k2:=CheckBox2.checked;
k3:=CheckBox3.checked;
k4:=CheckBox4.checked;
k5:=CheckBox5.checked;
k6:=CheckBox6.checked;
k7:=CheckBox7.checked;
k8:=CheckBox8.checked;
k9:=CheckBox9.checked;
k10:=CheckBox10.checked;
k11:=CheckBox11.checked;
k12:=CheckBox12.checked;
k13:=CheckBox13.checked;
k14:=CheckBox14.checked;

if ((k1=false) and (k2=false) and (k3=false) and (k4=false) and (k5=false)
and (k6=false) and (k7=false) and (k8=false) and (k9=false) and (k10=false)
and (k11=false) and (k12=false) and (k13=false) and (k14=false)) then
 begin
 MessageDlg('Не выбран не один из пунктов!',mtError, [mbOK], 0);
 end
 else
 begin
  if MessageDlg('Запустить процедуру очистки от ненужных временных файлов?',
  mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then
  begin
  Cleaner ();
  FileExec('data\input.bat',False,True); //запускаем bat-файл
  end;
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 CheckBox1.Checked := true;
 CheckBox2.Checked := true;
 CheckBox3.Checked := true;
 CheckBox4.Checked := true;
 CheckBox5.Checked := true;
 CheckBox6.Checked := true;
 CheckBox7.Checked := true;
 CheckBox8.Checked := true;
 CheckBox9.Checked := true;
 CheckBox10.Checked := true;
 CheckBox11.Checked := true;
 CheckBox12.Checked := true;
 CheckBox13.Checked := true;
 CheckBox14.Checked := true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 CheckBox1.Checked := false;
CheckBox2.Checked := false;
CheckBox3.Checked := false;
CheckBox4.Checked := false;
CheckBox5.Checked := false;
CheckBox6.Checked := false;
CheckBox7.Checked := false;
CheckBox8.Checked := false;
CheckBox9.Checked := false;
CheckBox10.Checked := false;
CheckBox11.Checked := false;
CheckBox12.Checked := false;
CheckBox13.Checked := false;
CheckBox14.Checked := false;
end;

procedure TForm1.MenuBatClick(Sender: TObject);
begin
k1:=CheckBox1.checked;
k2:=CheckBox2.checked;
k3:=CheckBox3.checked;
k4:=CheckBox4.checked;
k5:=CheckBox5.checked;
k6:=CheckBox6.checked;
k7:=CheckBox7.checked;
k8:=CheckBox8.checked;
k9:=CheckBox9.checked;
k10:=CheckBox10.checked;
k11:=CheckBox11.checked;
k12:=CheckBox12.checked;
k13:=CheckBox13.checked;
k14:=CheckBox14.checked;

if ((k1=false) and (k2=false) and (k3=false) and (k4=false) and (k5=false)
and (k6=false) and (k7=false) and (k8=false) and (k9=false) and (k10=false)
and (k11=false) and (k12=false) and (k13=false) and (k14=false)) then
 begin
 MessageDlg('Не выбран не один из пунктов!',mtError, [mbOK], 0);
 end
 else
 begin
  FileDir:='data\input.bat';
  if FileExists(FileDir) //проверяем наличие файла по указанному пути
  then
      begin
           if MessageDlg('Сформировать пакетный файл без его выполнения? Существующий  пакетный файл будет перезаписан.',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes
           then
           begin
                Cleaner ();
                ShellExecute(Handle, 'explore', 'data\', nil, nil, SW_SHOWNORMAL); //открываем путь расположения bat-файла
           end;
      end

  else
        begin
           if MessageDlg('Сформировать пакетный файл без его выполнения?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes
           then
           begin
                Cleaner ();
                ShellExecute(Handle, 'explore', 'data\', nil, nil, SW_SHOWNORMAL); //открываем путь расположения bat-файла
           end;
        end;

  end;
 end;


procedure TForm1.MenuClearClick(Sender: TObject);
begin
Button1.click;
end;

procedure TForm1.MenuCloseClick(Sender: TObject);
begin
Close; //закрываем форму
end;

procedure TForm1.MenuHelpClick(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.MenuPropertiesClick(Sender: TObject);
begin
  Form3.ShowModal;
end;


end.

