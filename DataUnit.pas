unit DataUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, dbf, ImgList;

const
  BaseDir='Base\';
  TargetDir='C:\Users\Public\otchety\gotov\';
  UserDocDir='C:\Users\Public\Chernovik\';
  ServMode=false;

type
  TPartRec = record
    code  : string[10];
    descr,doc : string[250];
    cnt,price  : real;
  end;
  TPartRecArray = array of TPartRec;

  TDataMod = class(TDataModule)
    MAINTYPES: TDbf;
    PRODUCTIONMODELS: TDbf;
    SERVCODES: TDbf;
    SERVPRICE: TDbf;
    PARTSLIST: TDbf;
    SmallImgs: TImageList;
    ReportDBF: TDbf;
    procedure DataModuleCreate(Sender: TObject);
    function  CreateNewReport(copfile : string; const clear : boolean=true):boolean;
    procedure DeleteTemporyFiles;
    function  GetNewID(tablename : string):integer;
    function  GetCurrentUserName: string;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExeDir : string;
  username : string;
  DataMod               : TDataMod;
  MainTypeFName         : string;
  ProductionModelsFName : string;
  ServCodesFName        : string;
  ServPriceFName        : string;
  PartsListFName        : string;
  EmptyRepFName         : string = '';
  TempRepFName          : string;
  CurrentFileName       : string = '';
  ErrorList             : TList;
  WorkTypes : array [1..3] of string = ('предпродажный','гарантийный','не гарантийный');
  clSTATUS1,clSTATUS2    : TColor;


implementation

{$R *.dfm}


function TDataMod.GetCurrentUserName: string;
const
  cnMaxUserNameLen = 254;
var
  sUserName: string;
  dwUserNameLen: DWORD;
begin
  dwUserNameLen := cnMaxUserNameLen - 1;
  SetLength(sUserName, cnMaxUserNameLen);
  GetUserName(PChar(sUserName), dwUserNameLen);
  SetLength(sUserName, dwUserNameLen);
  Result := trim(sUserName);
end;

procedure TDataMod.DataModuleCreate(Sender: TObject);
begin
  ExeDir:=ExtractFilePath(application.exename);
  MainTypeFName:=ExeDir+BaseDir+'MAINTYPES.dbf';
  ProductionModelsFName:=ExeDir+BaseDir+'PRODUCTIONMODELS.dbf';
  ServCodesFName:=ExeDir+BaseDir+'SERVCODES.dbf';
  PartsListFName:=ExeDir+BaseDir+'PARTSLIST.dbf';
  EmptyRepFName:=ExeDir+BaseDir+'EMPTYREPORT.dbf';
  ServPriceFName:=ExeDir+BaseDir+'SERVPRICE.dbf';
  if not((FileExists(MainTypeFName))and(FileExists(ProductionModelsFName))
    and(FileExists(ServCodesFName))and(FileExists(EmptyRepFName))
    and(FileExists(ServPriceFName))and(FileExists(PartsListFName)))then begin
    MessageBox(application.ActiveFormHandle,PChar('Файлы данных не найдены !'+chr(13)+
      'Приложение будет закрыто.'),PChar('Редактор отчетов RENOVA'),MB_ICONERROR+MB_OK);
    Halt(0);
  end;
  if ServMode then begin
    username:=self.GetCurrentUserName;
    if FileExists(ExeDir+BaseDir+'SERVPRICE'+'_'+username+'.dbf') then
      ServPriceFName:=ExeDir+BaseDir+'SERVPRICE'+'_'+username+'.dbf';
   // else MessageBox(application.ActiveFormHandle,PChar('Индивидуальный прайс цен на ремонт не найден !'+chr(13)+
   //   'Будет использоваться базавый прайс.'),PChar('Редактор отчетов RENOVA'),MB_ICONERROR+MB_OK);
  end else username:='';
  MainTypes.TableName:=MainTYpeFName;
  MainTypes.Active:=true;
  ProductionModels.TableName:=ProductionMODELSfname;
  ProductionModels.Active:=true;
  ServCodes.TableName:=ServCodesfname;
  ServCodes.Active:=true;
  ServPrice.TableName:=ServPriceFName;
  ServPrice.Active:=true;
  PartsList.TableName:=PartsListFName;
  PartsList.Active:=true;
  ErrorList:=TList.Create;
  clSTATUS1:=RGB(255,226,212);
  clSTATUS2:=RGB(255,255,224);
end;

function TDataMod.CreateNewReport(copfile : string; const clear : boolean=true):boolean;
var
  firstside,fname : string;
begin
  result:=false;
  firstside:='temprep';
  if (ServMode) then
    if length(username)>0 then firstside:=username else firstside:='noname';
  repeat
    fname:=firstside+FormatDateTime('ddMMyyhhmmsszzz',now)+'.rrp';
    fname:=ExtractFilePath(application.ExeName)+fname;
  until not FileExists(fname);
  CopyFile(PAnsiChar(copfile),PAnsiChar(fname),false);
  FileSetAttr(FName, faHidden);
  TempRepFName:=FName;
  if ReportDBF.Active then ReportDBF.Active:=false;
  try
    ReportDBF.TableName:=FName;
    ReportDBF.Active:=true;
    if clear then while not ReportDBF.IsEmpty do ReportDBF.Delete;
    result:=true;
  except
    MessageBox(application.ActiveFormHandle,PChar('Ошибка создания/открытия файла !'),
      PChar('Редактор отчетов RENOVA'),MB_ICONERROR+MB_OK);
  end;
end;

procedure TDataMod.DeleteTemporyFiles;
var
  msg : string;
begin
  if FileExists(TempRepFName) then begin
    if ReportDBF.Active then ReportDBF.Active:=false;
    if not deletefile(TempRepFName) then msg:=TempRepFName;
    if Length(msg)>0 then begin
      msg:='Не удалось удалить некоторые временные файлы:'+
        chr(13)+ExtractFileName(msg);
      MessageBox(application.ActiveFormHandle,PChar(msg),
      PChar('Редактор отчетов RENOVA'),MB_ICONERROR+MB_OK);
    end;
  end;
end;

function TDataMod.GetNewID(tablename : string): integer;
var
  DBF : TDBF;
begin
  result:=0;
  if FileExists(tablename) then begin
    DBF:=TDBF.Create(self);
    DBF.TableName:=tablename;
    DBF.Active:=true;
    result:=1;
    while DBF.Locate('ID',result,[]) do inc(result);
    DBF.Free;
  end;
end;

end.
