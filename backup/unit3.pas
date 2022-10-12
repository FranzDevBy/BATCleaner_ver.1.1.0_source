unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, INIFiles;

type

  { TForm3 }

  TForm3 = class(TForm)
    ButtonOk: TButton;
    CheckBox1: TCheckBox;
    GroupBox1: TGroupBox;
    procedure ButtonOkClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;
  ini : TIniFile;
  y1: string;


implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.ButtonOkClick(Sender: TObject);
begin
  Close; //закрываем форму
end;

procedure TForm3.CheckBox1Change(Sender: TObject);
begin

     if (CheckBox1.Checked = false) then y1:= '0';
     if (CheckBox1.Checked = true) then y1:='1';

     ini := TIniFile.Create('settings.ini');
     try

      ini.WriteString('BATCleaner', 'y1', y1);

    finally
      FreeAndNil(ini);
    end;

end;


procedure TForm3.FormActivate(Sender: TObject);

begin
   ini := TIniFile.Create('settings.ini');
    try

      y1 := ini.ReadString('BATCleaner', 'y1', y1);

    finally
      FreeAndNil(ini);
    end;

    if (y1='1') then (CheckBox1.Checked := true)
    else (CheckBox1.Checked := false)
    end;

end.

