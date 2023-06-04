unit ReportUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, StdCtrls, ComCtrls, ActnList, ToolWin, ExtCtrls,
  Menus, ShellAPI, AppEvnts, frxClass, frxDBSet, frxExportPDF, frxExportMail,
  frxExportODF, frxExportXLS;

const
  AppCaption='Отчеты RENOVA 1.2';

type
  TGridRange = record
    left,Top,Right,Bottom : integer;
    Text                  : string[255];
    FieldName             : string[250];
    Align                 : cardinal;
    datatype              : real;
    BrushColor, PenColor  : TColor;
    Font                  : TFont;
  end;
  TRangeList = array of TGridRange;

  TMyGrid = class(TStringGrid)
  protected
    procedure Paint; override;
  private
    { Private declarations }
    FRanges        : TRangeList;
    FFixedPenColor : TColor;
    FFixedFont     : TFont;
    modif          : boolean;
    FScale         : integer;          //масштабирование размеров ячеек и штрифтов
    procedure SetScale(sc : integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    function   AddRange(X1,Y1,X2,Y2:integer;txt:string; const dtype : real = 1; const alng : cardinal = DT_CENTER):integer;
    procedure  ClearRanges;
    procedure  ChangeText(X1,Y1:integer; txt : string);
    property   Modified : boolean read modif write modif;
    property   Scale : integer read FScale write SetScale;
  end;

  TReportForm = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    BtmPn: TPanel;
    TopPn: TPanel;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    ControlBar1: TControlBar;
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    NewRecord: TAction;
    EditRecord: TAction;
    DelRecord: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    SaveAs: TAction;
    NewReport: TAction;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    SaveDlg: TSaveDialog;
    Save: TAction;
    ToolButton6: TToolButton;
    OpenDlg: TOpenDialog;
    Open: TAction;
    ToolButton7: TToolButton;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    ScalePn: TPanel;
    ScaleLB: TLabel;
    DecScaleLB: TLabel;
    IncScaleLB: TLabel;
    ScaleTB: TTrackBar;
    CloseApp: TAction;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    RowSizingBtn: TToolButton;
    CloseReport: TAction;
    N13: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    ReopenMI: TMenuItem;
    ViewSetMI: TMenuItem;
    N15: TMenuItem;
    IncScaleMI: TMenuItem;
    DecScaleMI: TMenuItem;
    N14: TMenuItem;
    N251: TMenuItem;
    N501: TMenuItem;
    N1001: TMenuItem;
    N1501: TMenuItem;
    N1251: TMenuItem;
    RowSizingMI: TMenuItem;
    PrintReport: TAction;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    none1: TMenuItem;
    PaintErrorsBtn: TToolButton;
    PaintErrorsMI: TMenuItem;
    ExportMI: TMenuItem;
    EmailMI: TMenuItem;
    N17: TMenuItem;
    Ecxel1: TMenuItem;
    DFods1: TMenuItem;
    ODFodt1: TMenuItem;
    PDFpdf1: TMenuItem;
    ToolButton11: TToolButton;
    ExportODSBtn: TToolButton;
    ExportXLSBtn: TToolButton;
    CopyRecord: TAction;
    N16: TMenuItem;
    ToolButton12: TToolButton;
    frxXLSExport1: TfrxXLSExport;
    frxODSExport1: TfrxODSExport;
    frxODTExport1: TfrxODTExport;
    frxPDFExport1: TfrxPDFExport;
    frxMailExport1: TfrxMailExport;
    frxReport: TfrxReport;
    frxUDS: TfrxUserDataSet;
    UserNameLB: TLabel;
    SaveReadyRepMI: TMenuItem;
    N18: TMenuItem;
    ResultLb: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewRecordExecute(Sender: TObject);
    procedure EditRecordExecute(Sender: TObject);
    procedure NewReportExecute(Sender: TObject);
    procedure SaveAsExecute(Sender: TObject);
    function  SaveReport(SaveAs: boolean):boolean;
    procedure SaveExecute(Sender: TObject);
    procedure OpenExecute(Sender: TObject);
    procedure UpdateBtns(Sender: TObject);
    procedure UpdateGrid(selID : integer);
    procedure CreateGrid;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure IncScaleLBClick(Sender: TObject);
    procedure DelRecordExecute(Sender: TObject);
    procedure CloseAppExecute(Sender: TObject);
    procedure RowSizingBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OpenFileList(flist : TStringList);
    procedure OpenFile(fname : string);
    procedure CloseReportExecute(Sender: TObject);
    procedure ApplicationEvents1ShowHint(var HintStr: string;
      var CanShow: Boolean; var HintInfo: THintInfo);
    procedure N1Click(Sender: TObject);
    procedure ReopenClick(Sender: TObject);
    procedure ReopenMIClick(Sender: TObject);
    function  SaveExistsReports:boolean;
    procedure AddToReopenList(fname:string);
    procedure PrintReportExecute(Sender: TObject);
    procedure frxReportGetValue(const VarName: string; var Value: Variant);
    procedure PaintErrorsBtnClick(Sender: TObject);
    procedure ExportReport(Sender: TObject);
    procedure CopyRecordExecute(Sender: TObject);
    procedure SaveReadyRepMIClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
    { Public declarations }
  end;

var
  ReportForm: TReportForm;

implementation

{$R *.dfm}

uses DataUnit, RecordEditprUnit, MonthWin;

const
  ReopenListFilename='reopenlist.lst';

var
  Grid       : TMyGrid;
  ReopenList : TStringList;
  wsum,msum,psum   : real;
  wcnt : integer;

//-------------------- создание нового отчета ----------------------------------

//проверка существование отчата и предложение его сохранить
function  TReportForm.SaveExistsReports:boolean;
begin
  result:=true;
  if (Grid<>nil)and(not DataMod.ReportDBF.IsEmpty)and(Grid.Modified) then
    case MessageBox(self.Handle,PChar('Сохранить отчет ?'),
      PChar('Внимание !'),MB_ICONWARNING+MB_YESNOCANCEL) of
      mrYes    : if not self.SaveReport(false) then result:=false;
      mrNo     : {не сораням} result:=true;
      else {не создаем} result:=false;
    end;
end;

procedure TReportForm.NewReportExecute(Sender: TObject);
var
  id     : integer;
begin
  if self.SaveExistsReports then begin
    CurrentFileName:='';
    self.Caption:=AppCaption+' - Новый отчет';
    DataMod.CreateNewReport(EmptyRepFName);
    CreateGrid;
    id:=RecordEditprUnit.EditRecord(0);
    grid.Modified:=true;
    self.UpdateGrid(id);
    self.UpdateBtns(self);
  end;
end;

//----- открытие отчета, открытие несколькоих отчетов при перетаскивании -------

procedure TReportForm.OpenExecute(Sender: TObject);
var
  stdir : string;
begin
  stdir:=UserDocDir+username;
  if (ServMode)and(DirectoryExists(stdir)) then OpenDlg.InitialDir:=PAnsiChar(stdir);
  if self.SaveExistsReports and OpenDlg.Execute then self.OpenFile(OpenDlg.FileName);
end;

procedure TReportForm.OpenFile(fname : string);
begin
  if FileExists(fname) then begin
    DataMod.DeleteTemporyFiles;
    CurrentFileName:=fname;
    self.Caption:=AppCaption+' - '+ExtractFileName(CurrentFileName);
    if DataMod.CreateNewReport(CurrentFileName,false) then begin
      CreateGrid;
      self.UpdateBtns(self);
      self.UpdateGrid(0);
      self.AddToReopenList(CurrentFileName);
      self.Caption:=AppCaption+' - '+ExtractFileName(fname);
    end;
  end;
end;

procedure TReportForm.OpenFileList(flist : TStringList);
var
  i,err : integer;
begin
  for I := 0 to fList.Count - 1 do
    if i=0 then self.OpenFile(flist[0]) else begin
      err:=ShellExecute(Handle,'open', pchar(application.ExeName),pchar(flist[i]), nil, SW_SHOWNORMAL) ;
      if err<=32 then MessageBox(application.ActiveFormHandle,PChar('Ошибка при открытии файла:'+chr(13)+
        flist[i]),PChar('Редактор отчетов RENOVA'),MB_ICONERROR+MB_OK);
    end;
end;

//----------------------- печать отчета----------------------------------------

procedure TReportForm.PrintReportExecute(Sender: TObject);
begin
  frxUDS.RangeEndCount:=Grid.RowCount-2;
  frxReport.PrepareReport(true);
  frxReport.ShowPreparedReport;
end;

procedure TReportForm.frxReportGetValue(const VarName: string;
  var Value: Variant);
var
  acol : integer;
  capt : string;
  pind : ^Tpoint;
begin
  value:='';
  if pos('COL',VarName)=1 then begin
    acol:=StrToIntDef(copy(VarName,4,MaxInt),0);
    if Acol>0 then value:=Grid.Cells[acol+1,frxUDS.RecNo+2] else
      if Grid.Objects[0,frxUDS.RecNo+2]<>nil then begin
        pind:=pointer(Grid.Objects[0,frxUDS.RecNo+2]);
        case pind^.Y of
          1 : value:='!!';
          2 : value:='!';
          3 : value:='';
          else value:='?';
        end;
      end;
  end else begin
    if comparestr(varname,'REPCAPTION')=0 then begin
      capt:=ExtractFileName(CurrentFileName);
      value:=AnsiUpperCase(copy(capt,1,Length(capt)-4));;
    end;
    if comparestr(varname,'WCNT')=0 then value:=IntToStr(wcnt);
    if comparestr(varname,'WSUM')=0 then value:=FormatFloat('######0.00',wsum);
    if comparestr(varname,'MSUM')=0 then value:=FormatFloat('######0.00',msum);
    if comparestr(varname,'PSUM')=0 then value:=FormatFloat('######0.00',psum);
    if comparestr(varname,'TSUM')=0 then value:=FormatFloat('######0.00',wsum+msum+psum);
  end;
end;

procedure TReportForm.ExportReport(Sender: TObject);
var
  id : integer;
begin
  if (sender is TMenuItem)or(sender is TToolButton) then begin
    frxUDS.RangeEndCount:=Grid.RowCount-2;
    frxReport.PrepareReport(true);
    id:=0;
    if (sender is TMenuItem) then id:=(sender as TMenuItem).Tag;
    if (sender is TToolButton) then id:=(sender as TToolButton).Tag;
    case id of
      1 : self.frxReport.Export(self.frxXLSExport1);
      2 : self.frxReport.Export(self.frxODSExport1);
      3 : self.frxReport.Export(self.frxODTExport1);
      4 : self.frxReport.Export(self.frxPDFExport1);
      5 : self.frxReport.Export(self.frxMailExport1);
    end;
  end;
end;

//------------ механизм "Недавние документы" ------------------------------------

procedure TReportForm.AddToReopenList(fname:string);
var
  reopenfile : string;
begin
  //добавляем имя файла в списко повторного открытия
  if ReopenList.IndexOf(FName)<>0 then begin
    if ReopenList.IndexOf(FName)>0 then ReopenList.Delete(ReopenList.IndexOf(FName));
    ReopenList.Insert(0,FName);
    while ReopenList.Count>10 do ReopenList.Delete(ReopenList.Count-1);
    reopenfile:=extractfilepath(application.ExeName)+BaseDir+ReopenListFilename;
    ReopenList.SaveToFile(reopenfile);
  end;
end;

procedure TReportForm.N1Click(Sender: TObject);
begin
  ReopenMI.Enabled:=(ReopenList.Count>0);
end;

procedure TReportForm.ReopenMIClick(Sender: TObject);
var
  i : integer;
  mi : TMenuItem;
begin
  while (sender as TMenuItem).Count>1 do (sender as TMenuItem).Delete(0);
  for I := 0 to ReopenList.Count - 1 do begin
    if i=0 then mi:=(sender as TMenuItem).Items[0]
      else mi:=TMenuItem.Create(sender as TMenuItem);
    mi.Caption:=ReopenList[i];
    mi.OnClick:=self.ReopenClick;
    if i>0 then(sender as TMenuItem).Add(mi);
  end;
end;

procedure TReportForm.ReopenClick(Sender: TObject);
var
  ind              : integer;
  fname,reopenfile : string;
begin
  if (sender is TMenuItem)then
    if (self.SaveExistsReports) then begin
      fname:=(sender as TMenuItem).Caption;
      if not(FileExists(fname)) then begin
        ind:=ReopenList.IndexOf(fname);
        if ind>=0 then begin
          MessageBox(self.Handle,PChar('Файл был удален или перемещен !'),
            PChar('Внимание !'),MB_ICONWARNING+MB_OK);
          ReopenList.Delete(ind);
          reopenfile:=extractfilepath(application.ExeName)+BaseDir+ReopenListFilename;
          ReopenList.SaveToFile(reopenfile);
        end;
      end else self.OpenFile(fname);
    end;
end;

//------------------------------- вид отчета ----------------------------------

procedure TReportForm.RowSizingBtnClick(Sender: TObject);
begin
  if (sender is TMenuItem) then begin
    self.RowSizingMI.Checked:=not self.RowSizingMI.Checked;
    self.RowSizingBtn.Down:=self.RowSizingMI.Checked;
  end;
  if (sender is TToolButton) then self.RowSizingMI.Checked:=self.RowSizingBtn.Down;
  if Grid<>nil then Grid.Repaint;
end;

procedure TReportForm.PaintErrorsBtnClick(Sender: TObject);
begin
  if (sender is TMenuItem) then begin
    self.PaintErrorsMI.Checked:=not self.PaintErrorsMI.Checked;
    self.PaintErrorsBtn.Down:=self.PaintErrorsMI.Checked;
  end;
  if (sender is TToolButton) then self.PaintErrorsMI.Checked:=self.PaintErrorsBtn.Down;
  if Grid<>nil then Grid.Repaint;
end;

//------------ сохаренние отчета -----------------------------------------------

procedure TReportForm.SaveAsExecute(Sender: TObject);
begin
  if self.SaveReport(true) then
    self.Caption:=AppCaption+' - '+ExtractFileName(CurrentFileName);
end;

procedure TReportForm.SaveExecute(Sender: TObject);
begin
  self.SaveReport(false);
end;

function  TReportForm.SaveReport(SaveAs: boolean):boolean;
var
  stdir, fname : string;
begin
  result:=false;
  fname:='';
  stdir:=UserDocDir+username;
  if (ServMode)and(DirectoryExists(stdir)) then SaveDlg.InitialDir:=PAnsiChar(stdir);
  if (SaveAs)or(length(CurrentFileName)=0) then begin
   if SaveDlg.Execute then fname:=SaveDlg.FileName
  end else fname:=CurrentFileName;
  if length(FName)>0 then
    try
      copyfile(PAnsiChar(TempRepFName),PAnsiChar(fName),false);
      FileSetAttr(FName, 0);
      CurrentFileName:=fname;
      grid.Modified:=false;
      UpdateBtns(self);
      self.AddToReopenList(CurrentFileName);
      result:=true;
    except
      MessageBox(application.ActiveFormHandle,PChar('Сохранение не удалось !'),
        PChar('Редактор отчетов RENOVA'),MB_ICONERROR+MB_OK);
    end;
end;

//------------------------------------------------------------------------------

procedure TReportForm.SaveReadyRepMIClick(Sender: TObject);
var
  save  : boolean;
  fname : string;
  y,m,d : word;
begin
  save:=((FileExists(TempRepFName)and(MessageBox(application.ActiveFormHandle,PChar('Вы уверенны, что ваш отчет готов ?'+chr(13)+
    'После отправки отчет не может быть изменен !'), PChar('Внимание !'),MB_ICONQUESTION+MB_OKCANCEL)=mrOK)));
  if (save) then begin
    DecodeDate(now,y,m,d);
    fname:=MonthWin.GetMonth(m,y);
    save:=(Length(fname)>0);
    if not save then MessageBox(application.ActiveFormHandle,PChar('Операция отменена пользователем !'),
        PChar('Внимание !'),MB_ICONWARNING+MB_OK);
  end;
  if (save)then begin
    if (not(DirectoryExists(TargetDir))) then fname:=ExeDir+username+'_'+fname+'.rrp'
      else fname:=TargetDir+username+'_'+fname+'.rrp';
    try
      copyfile(PAnsiChar(TempRepFName),PAnsiChar(fName),false);
      FileSetAttr(FName, 0);
      MessageBox(application.ActiveFormHandle,PChar('Отчет успешно выгружен !'),
        PChar('Внимание !'),MB_ICONINFORMATION+MB_OK);
    except
      MessageBox(application.ActiveFormHandle,PChar('Ошибка выгрузки отчета !'),
        PChar('Редактор отчетов RENOVA'),MB_ICONERROR+MB_OK);
    end;
  end;
end;

//--------------------- закрытие отчета, закрытие приложения -------------------

procedure TReportForm.CloseAppExecute(Sender: TObject);
begin
  self.Close;
end;

procedure TReportForm.CloseReportExecute(Sender: TObject);
begin
  grid.Free;
  grid:=nil;
  DataMod.ReportDBF.Active:=false;
  self.UpdateBtns(self);
  self.ResultLb.Caption:='';
end;

//-------------------- работа с записями --------------------------------------

procedure TReportForm.NewRecordExecute(Sender: TObject);
var
  id : integer;
begin
  id:=RecordEditprUnit.EditRecord(0);
  grid.Modified:=true;
  self.UpdateGrid(id);
  self.UpdateBtns(self);
end;

procedure TReportForm.DelRecordExecute(Sender: TObject);
var
  pind : ^integer;
begin
  if (Grid<>nil)and(Grid.Selection.Top>=Grid.FixedRows)and(Grid.Objects[0,Grid.Selection.Top]<>nil) then
    if MessageBox(self.Handle,PChar('Удалить запись о ремонте ?'),
      PChar('Внимание !'),MB_ICONWARNING+MB_YESNO)=mrYes then begin
        pind:=pointer(Grid.Objects[0,Grid.Selection.Top]);
        DataMod.ReportDBF.Filter:='PARENT='+IntToStr(pind^);
        DataMod.ReportDBF.Filtered:=true;
        while not DataMod.ReportDBF.Eof do DataMod.ReportDBF.Delete;
        DataMod.ReportDBF.Filter:='';
        DataMod.ReportDBF.Filtered:=false;
        if DataMod.ReportDBF.Locate('ID',pind^,[]) then DataMod.ReportDBF.Delete;
        grid.Modified:=true;
        self.UpdateGrid(0);
        self.UpdateBtns(self);
      end;
end;

procedure TReportForm.EditRecordExecute(Sender: TObject);
var
  pind : ^TPoint;
begin
  if (Grid.Selection.Top>1)and(Grid.Objects[0,Grid.Selection.Top]<>nil) then begin
    pind:=pointer(Grid.Objects[0,Grid.Selection.Top]);
    RecordEditprUnit.EditRecord(pind^.X);
    grid.Modified:=true;
    self.UpdateGrid(pind^.X);
    self.UpdateBtns(self);
  end;
end;

procedure TReportForm.CopyRecordExecute(Sender: TObject);
var
  pind : ^TPoint;
begin
  if (Grid.Selection.Top>1)and(Grid.Objects[0,Grid.Selection.Top]<>nil) then begin
    pind:=pointer(Grid.Objects[0,Grid.Selection.Top]);
    RecordEditprUnit.EditRecord(pind^.X,true);
    grid.Modified:=true;
    self.UpdateGrid(pind^.X);
    self.UpdateBtns(self);
  end;
end;

//----------------- события формы, обновление контролов ------------------------

procedure TReportForm.UpdateBtns(Sender: TObject);
var
  reportexists : boolean;
begin
  reportexists:=((Grid<>nil)and(not DataMod.ReportDBF.IsEmpty));
  self.Save.Enabled:=(reportexists)and(grid.Modified);
  self.SaveAs.Enabled:=reportexists;
  self.NewRecord.Enabled:=(Grid<>nil);
  self.EditRecord.Enabled:=reportexists;
  self.DelRecord.Enabled:=reportexists;
  self.PrintReport.Enabled:=reportexists;
  self.CloseReport.Enabled:=reportexists;
  self.EmailMI.Enabled:=reportexists;
  self.ExportMI.Enabled:=reportexists;
  self.ExportODSBtn.Enabled:=reportexists;
  self.ExportXLSBtn.Enabled:=reportexists;
  self.CopyRecord.Enabled:=reportexists;
  self.ScalePn.Enabled:=(Grid<>nil);
  self.RowSizingBtn.Enabled:=(Grid<>nil);
  self.ViewSetMI.Visible:=(Grid<>nil);
  self.PaintErrorsBtn.Enabled:=(Grid<>nil);
  self.SaveReadyRepMI.Enabled:=(ServMode and reportexists);
end;

procedure TReportForm.WMDropFiles(var Msg: TWMDropFiles);
var
  DropH: HDROP;               // дескриптор операции перетаскивания
  DroppedFileCount: Integer;  // количество переданных файлов
  FileNameLength: Integer;    // длина имени файла
  FileName: string;           // буфер, принимающий имя файла
  I: Integer;                 // итератор для прохода по списку
  flist  : TStringList;
begin
  inherited;
  flist:=TStringList.Create;
  // Сохраняем дескриптор
  DropH := Msg.Drop;
  try
    // Получаем количество переданных файлов
    DroppedFileCount := DragQueryFile(DropH, $FFFFFFFF, nil, 0);
    // Получаем имя каждого файла и обрабатываем его
    for I := 0 to Pred(DroppedFileCount) do
    begin
      // получаем размер буфера
      FileNameLength := DragQueryFile(DropH, I, nil, 0);
      // создаем буфер, который может принять в себя строку с именем файла
      // (Delphi добавляет терминирующий ноль автоматически в конец строки)
      SetLength(FileName, FileNameLength);
      // получаем имя файла
      DragQueryFile(DropH, I, PChar(FileName), FileNameLength + 1);
      // что-то делаем с данным именем (все зависит от вашей фантазии)
      flist.Add(filename);
    end;
    //открываем по ссписку
    self.OpenFileList(flist);
  finally
    // Финализация - разрушаем дескриптор
    // не используйте DropH после выполнения данного кода...
    DragFinish(DropH);
    flist.Free;
  end;
  // Говорим о том, что сообщение обработано
  Msg.Result := 0;
end;

procedure TReportForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if self.SaveExistsReports then begin
    DataMod.DeleteTemporyFiles;
    DragAcceptFiles(self.Handle, false);
  end else Action:=caNone;
end;

procedure TReportForm.FormCreate(Sender: TObject);
var
  fname : string;
begin
  if Length(username)=0 then self.UserNameLB.Caption:='Локальный режим'
    else self.UserNameLB.Caption:='Пользователь: '+username;
  DragAcceptFiles(self.Handle, True);
  ReopenList :=TStringList.Create;
  ReopenList.Duplicates:=dupIgnore;
  fname:=extractfilepath(application.ExeName)+BaseDir+ReopenListFilename;
  if FileExists(fname) then ReopenList.LoadFromFile(fname);
  fname:=ParamStr(1);
  self.ResultLb.Caption:='';
  if length(fname)>0 then self.OpenFile(fname);
  self.PaintErrorsBtn.Down:=true;
  self.PaintErrorsMI.Checked:=true;
  self.ReopenMI.Visible:=not ServMode;
  self.SaveReadyRepMI.Visible:=ServMode;
  self.EmailMI.Visible:=not ServMode;
  self.UpdateBtns(self);
  self.Caption:=AppCaption;
end;

procedure TReportForm.IncScaleLBClick(Sender: TObject);
begin
  if (sender is TMenuItem) then begin
    if pos('%',(sender as TMenuItem).Caption)>0 then Grid.Scale:=(sender as TMenuItem).Tag;
    if((sender as TMenuItem).Name='IncScaleMI')and(Grid.Scale<200) then Grid.Scale:=grid.Scale+25;
    if((sender as TMenuItem).Name='DecScaleMI')and(Grid.Scale>25) then Grid.Scale:=grid.Scale-25;
  end;
  if (sender is TLabel) then begin
    if((sender as TLabel).Name='IncScaleLB')and(Grid.Scale<200) then Grid.Scale:=grid.Scale+25;
    if((sender as TLabel).Name='DecScaleLB')and(Grid.Scale>25) then Grid.Scale:=grid.Scale-25;
  end;
  if (sender is TTrackBar) then Grid.Scale:=ScaleTB.Position else  ScaleTB.Position:=Grid.Scale; 
  ScaleLB.Caption:=FormatFloat('###0%',Grid.Scale);
end;

procedure TReportForm.ApplicationEvents1ShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
var
  pt  : tpoint;
begin
  if hintinfo.HintControl.Name='Grid' then begin
    pt:=tpoint(Grid.MouseCoord(HintInfo.CursorPos.X,HintInfo.CursorPos.y));
    if pt.y>0 then HintStr:=Grid.Cells[pt.x,pt.y];
  end;
end;

//----------------------------- события таблицы --------------------------------

procedure TReportForm.CreateGrid;
begin
  Grid.Free;
  Grid:=nil;
  Grid:=TMyGrid.Create(self);
  self.InsertControl(Grid);
  Grid.Font.Size:=10;
  Grid.OnDblClick:=self.EditRecordExecute;
  Grid.DoubleBuffered:=true;
  Grid.OnDrawCell:=self.StringGrid1DrawCell;
  Grid.Scale:=100;
  ScaleLB.Caption:='100%';
  ScaleTB.Position:=100;
end;

procedure TReportForm.UpdateGrid(selID : integer);
var
  id,c,r,stat : integer;
  str         : string;
  pind        : ^TPoint;
begin
  Grid.Enabled:=false;
  Grid.RowCount:=3;
  Grid.Rows[2].Clear;
  wsum:=0; msum:=0; psum:=0; wcnt:=0;
  DataMod.ReportDBF.First;
  r:=1;
  while not DataMod.ReportDBF.Eof do begin
    id:=DataMod.ReportDBF.FieldByName('ID').AsInteger;
    stat:=DataMod.ReportDBF.FieldByName('STATUS').AsInteger;
    if id>0 then begin
      Grid.Enabled:=true;
      inc(r);
      if (r>(Grid.RowCount-2)) then Grid.RowCount:=Grid.RowCount+1;
      if id=selID then begin
        Grid.Selection:=TGridRect(rect(1,r,Grid.ColCount-1,r));
        if r>(Grid.ClientHeight/Grid.DefaultRowHeight) then Grid.TopRow:=r;
      end;
      Grid.Rows[r].Clear;
      new(pind);
      pind^.X:=id;
      pind^.Y:=stat;
      Grid.Objects[0,r]:=TObject(pind);
      for c := 1 to Grid.ColCount - 1 do begin
        str:='';
        if DataMod.ReportDBF.FieldByName('ID').AsInteger>0 then inc(wcnt);
        case c of
          2 : str:=DataMod.ReportDBF.FieldByName('WORKTYPE').AsString;
          3 : str:=DataMod.ReportDBF.FieldByName('CLIENT').AsString;
          4 : str:=DataMod.ReportDBF.FieldByName('CLIENTTEL').AsString;
          5 : str:=DataMod.ReportDBF.FieldByName('CLIENTADDR').AsString;
          8 : if DataMod.ReportDBF.FieldByName('WORKID').AsInteger>1 then
                 str:=FormatDateTime('dd mmm yy',DataMod.ReportDBF.FieldByName('BUYDATE').AsDateTime)
                  else str:='';
          7 : str:=DataMod.ReportDBF.FieldByName('SN').AsString;
          1 : str:=DataMod.ReportDBF.FieldByName('PRODNAME').AsString;
          6 : str:=DataMod.ReportDBF.FieldByName('MODELNOTE').AsString;
          9 : str:=FormatDateTime('dd mmm yy',DataMod.ReportDBF.FieldByName('STARTDATE').AsDateTime);
          10 : str:=FormatDateTime('dd mmm yy',DataMod.ReportDBF.FieldByName('ENDDATE').AsDateTime);
          19 : str:=DataMod.ReportDBF.FieldByName('WORKCODE').AsString;
          17 : begin
                str:=DataMod.ReportDBF.FieldByName('PROBLEMNOT').AsString;
                if length(str)=0 then
                  str:=DataMod.ReportDBF.FieldByName('ADDPROBNOT').AsString
                    else str:=str+'. '+DataMod.ReportDBF.FieldByName('ADDPROBNOT').AsString;
               end;
          18 : str:=DataMod.ReportDBF.FieldByName('WORKNOTE').AsString;
          16 : if DataMod.ReportDBF.FieldByName('WORKPRICE').AsFloat=0 then str:='' else begin
                str:=FormatFloat('######0.00',DataMod.ReportDBF.FieldByName('WORKPRICE').AsFloat);
                wsum:=wsum+DataMod.ReportDBF.FieldByName('WORKPRICE').AsFloat;
                end;
          14 :  if DataMod.ReportDBF.Fields.FindField('PARTDOC')<>nil then
                  str:=DataMod.ReportDBF.FieldByName('PARTDOC').AsString;
          15 : if DataMod.ReportDBF.FieldByName('MOVPRICE').AsFloat=0 then str:='' else begin
                str:=FormatFloat('######0.00',DataMod.ReportDBF.FieldByName('MOVPRICE').AsFloat);
                msum:=msum+DataMod.ReportDBF.FieldByName('MOVPRICE').AsFloat;
                end;
          11 : str:=DataMod.ReportDBF.FieldByName('PARTS').AsString;
          13 : if DataMod.ReportDBF.FieldByName('PARTQTY').AsFloat=0 then str:='' else
                str:=FormatFloat('######0.00',DataMod.ReportDBF.FieldByName('PARTQTY').AsFloat);
          12 : if DataMod.ReportDBF.FieldByName('PARTCOST').AsFloat=0 then str:='' else begin
                str:=FormatFloat('######0.00',DataMod.ReportDBF.FieldByName('PARTCOST').AsFloat);
                psum:=psum+DataMod.ReportDBF.FieldByName('PARTCOST').AsFloat;
                end;
          20 : str:=DataMod.ReportDBF.FieldByName('NOTE').AsString;
        end;
        Grid.Cells[c,r]:=str;
      end;
      //
      DataMod.ReportDBF.Filter:='PARENT='+IntTOStr(id);
      DataMod.ReportDBF.Filtered:=true;
      while not DataMod.ReportDBF.Eof do begin
        inc(r);
        if (r>(Grid.RowCount-2)) then Grid.RowCount:=Grid.RowCount+1;
        Grid.Rows[r].Clear;
        new(pind);
        pind^.X:=id;
        pind^.Y:=stat;
        Grid.Objects[0,r]:=TObject(pind);
        Grid.Cells[11,r]:=DataMod.ReportDBF.FieldByName('PARTS').AsString;
        if DataMod.ReportDBF.FieldByName('PARTQTY').AsFloat=0 then Grid.Cells[16,r]:='' else
          Grid.Cells[13,r]:=FormatFloat('######0.00',DataMod.ReportDBF.FieldByName('PARTQTY').AsFloat);
        if DataMod.ReportDBF.FieldByName('PARTCOST').AsFloat=0 then Grid.Cells[17,r]:='' else begin
          Grid.Cells[12,r]:=FormatFloat('######0.00',DataMod.ReportDBF.FieldByName('PARTCOST').AsFloat);
          psum:=psum+DataMod.ReportDBF.FieldByName('PARTCOST').AsFloat;
          end;
        if DataMod.ReportDBF.Fields.FindField('PARTDOC')<>nil then
          Grid.Cells[14,r]:=DataMod.ReportDBF.FieldByName('PARTDOC').AsString else Grid.Cells[14,r]:='';
        DataMod.ReportDBF.Next;
      end;
      DataMod.ReportDBF.Filter:='';
      DataMod.ReportDBF.Filtered:=false;
    end;
    if id>0 then DataMod.ReportDBF.Locate('ID',id,[]);
    DataMod.ReportDBF.Next;
  end;
  if Grid.Enabled then Grid.RowCount:=Grid.RowCount-1;
  str:='';
  if wcnt>0 then str:='Всего ремонтов: '+inttostr(wcnt)+'   ';
  if wsum>0 then str:=str+'За ремонты: '+FormatFloat('######0.00',wsum)+'   ';
  if msum>0 then str:=str+'За выезд: '+FormatFloat('######0.00',msum)+'   ';
  if psum>0 then str:=str+'За детали: '+FormatFloat('######0.00',psum)+'   ';
  if wsum+msum+psum>0 then str:=str+'Всего: '+FormatFloat('######0.00',wsum+msum+psum);
  self.ResultLb.Caption:=str;
end;

procedure TReportForm.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  rct  : trect;
  flag : cardinal;
  txt  : string;
  h    : integer;
  pind : ^TPoint;
  img  : TbitMap;
begin
  if (ARow>=Grid.FixedRows)and(ACol=0)and(Grid.Objects[0,ARow]<>nil) then begin
    pind:=pointer(Grid.Objects[0,ARow]);
    img:=TBitMap.Create;
    case pind.y of
      1 : DataMod.SmallImgs.GetBitmap(2,img);
      2 : DataMod.SmallImgs.GetBitmap(1,img);
      3 : DataMod.SmallImgs.GetBitmap(0,img);
    end;
    img.Height:=rect.Bottom-rect.Top-2;
    img.Width:=rect.Right-rect.Left-2;
    Grid.Canvas.Draw(rect.Left+1,rect.Top+1,img);
  end;
  if (ARow>=Grid.FixedRows)and(ACol>0) then begin
    if (RowSizingBtn.Down) then flag:=DT_WORDBREAK else flag:=0;
    case ACol of
      8,9,10,19 : flag:=flag or DT_CENTER;
      12,13,15,16 : flag:=flag or DT_RIGHT;
      else flag:=flag or DT_LEFT;
    end;
    if (Grid.Objects[0,ARow]<>nil)and(self.PaintErrorsBtn.Down) then begin
      pind:=pointer(Grid.Objects[0,ARow]);
      case pind^.Y of
        1 : Grid.Canvas.Brush.Color:=clSTATUS1;
        2 : Grid.Canvas.Brush.Color:=clSTATUS2;
        else Grid.Canvas.Brush.Color:=clWhite;
      end;
    end else Grid.Canvas.Brush.Color:=clWhite;
    if gdSelected in State then Grid.Canvas.Font.Color:=clNavy
      else Grid.Canvas.Font.Color:=clBlack;
    rct:=rect;
    Grid.Canvas.FillRect(rct);
    inc(rct.Top,2);inc(rct.Left,2);
    dec(rct.Bottom,2); dec(rct.Right,2);
    txt:=Grid.Cells[ACol,ARow];
    h:=DrawText(Grid.canvas.Handle,pchar(txt),Length(txt),rct,flag);
    if (RowSizingBtn.Down)then begin
      if(Grid.RowHeights[ARow]<h+8) then Grid.RowHeights[ARow]:=h+8;
    end else
      if(Grid.RowHeights[ARow]>Grid.DefaultRowHeight) then Grid.RowHeights[ARow]:=Grid.DefaultRowHeight;
  end;
end;

//---------------------------- класс таблицы -----------------------------------

constructor TMyGrid.Create(AOwner: TComponent);
begin
  inherited;
  SetLength(self.FRanges,0);
  self.RowCount:=3;
  self.FixedRows:=2;
  self.FixedCols:=1;
  self.ColCount:=21;
  self.Ctl3D:=false;
  self.FixedColor:=clWhite;
  self.FFixedFont:=self.Font;
  self.FFixedPenColor:=clBlack;
  self.Align:=alClient;
  self.modif:=false;
  self.Options:=self.Options+[goColSizing,goRowSelect]-[goRangeSelect];
  self.Hint:='Отчет';
  self.ShowHint:=true;
  self.Name:='Grid';
  //создание заголовка
  self.AddRange(0,0,0,1,'');
  self.AddRange(1,0,1,1,'Тип продукции',1.2,DT_WORDBREAK or DT_CENTER);
  self.AddRange(2,0,2,1,'Вид ремонта',0.8,DT_WORDBREAK or DT_CENTER);
  self.AddRange(3,0,5,0,'Данные о клиенте');
  self.AddRange(3,1,3,1,'ФИО',0.8);
  self.AddRange(4,1,4,1,'телефон',0.8);
  self.AddRange(5,1,5,1,'адрес',0.8);
  self.AddRange(6,0,6,1,'Модель продукции',1.2,DT_WORDBREAK or DT_CENTER);
  self.AddRange(7,0,7,1,'Серийный номер',1,DT_WORDBREAK or DT_CENTER);
  self.AddRange(8,0,10,0,'Даты');
  self.AddRange(8,1,8,1,'продажи',0.6);
  self.AddRange(9,1,9,1,'начало ремонта',0.6,DT_WORDBREAK or DT_CENTER);
  self.AddRange(10,1,10,1,'конец ремонта',0.6,DT_WORDBREAK or DT_CENTER);
  self.AddRange(11,0,14,0,'Использованные деталь');
  self.AddRange(11,1,11,1,'наименование',1.2);
  self.AddRange(12,1,12,1,'стоим',0.6);
  self.AddRange(13,1,13,1,'кол-во',0.5);
  self.AddRange(14,1,14,1,'накладная',0.8);
  self.AddRange(15,0,16,0,'Стоимость работ');
  self.AddRange(15,1,15,1,'выезд',0.6);
  self.AddRange(16,1,16,1,'ремонт',0.6);
  self.AddRange(17,0,17,1,'Описание дефекта',1.2,DT_WORDBREAK or DT_CENTER);
  self.AddRange(18,0,18,1,'Описание работ',1.2,DT_WORDBREAK or DT_CENTER);
  self.AddRange(19,0,19,1,'Код',0.5);
  self.AddRange(20,0,20,1,'Примечание',3);
  self.SetScale(100);
end;

destructor TMyGrid.Destroy;
begin
  SetLength(self.FRanges,0);
  self.FRanges:=nil;
  inherited;
end;

function TMyGrid.AddRange(X1,Y1,X2,Y2:integer;txt:string; const dtype : real = 1;  const alng : cardinal = DT_CENTER):integer;
begin
  SetLength(self.FRanges,high(self.FRanges)+2);
  self.FRanges[high(self.FRanges)].left:=X1;
  self.FRanges[high(self.FRanges)].Right:=X2;
  self.FRanges[high(self.FRanges)].Top:=Y1;
  self.FRanges[high(self.FRanges)].Bottom:=Y2;
  self.FRanges[high(self.FRanges)].Text:=txt;
  self.FRanges[high(self.FRanges)].Align:=alng;
  self.FRanges[high(self.FRanges)].datatype:=dtype;
  self.FRanges[high(self.FRanges)].Font:=self.Font;
  result:=high(self.FRanges)
end;

procedure TMyGrid.ClearRanges;
begin
  setlength(self.FRanges,0);
end;

procedure TMyGrid.ChangeText(X1,Y1:integer; txt : string);
var
  i : integer;
begin
  i:=0;
  while(i<=high(self.FRanges))and(not((self.FRanges[i].left=X1)and(self.FRanges[i].Top=Y1)))do inc(i);
  if(i<=high(self.FRanges))and(self.FRanges[i].left=X1)and(self.FRanges[i].Top=Y1)then self.FRanges[i].Text:=txt;
end;

procedure TMyGrid.SetScale(sc: Integer);
var
  i   : integer;
  Rng : TGridRange;
begin
  self.FScale:=sc;
  self.DefaultRowHeight:=round(20*sc/100);
  self.DefaultColWidth:=round(100*sc/100);
  self.Font.Size:=round(8*sc/100);
  for i := low(self.FRanges) to high(self.FRanges) do begin
    Rng:=self.FRanges[i];
    if Rng.left=rng.Right then
      ColWidths[Rng.left]:=round(self.DefaultColWidth*rng.datatype);
  end;
  if ColWidths[0]>16 then ColWidths[0]:=20;
end;

procedure TMyGrid.Paint;
var
  rct   : TRect;
  i,h   : integer;
  Rng   : TGridRange;
  txt   : string;
  candraw : boolean;
  fnt   : TFont;
  bclr  : TColor;
  pn    : TPen;

procedure VerticalForFixed;
var
  j : integer;
begin
  //расчет вертикальных координат для фиксированных строк
  rct.Top:=0;
  for j:=0 to rng.Top-1 do rct.Top:=rct.Top+self.RowHeights[j]+1;
  rct.Bottom:=rct.Top;
  for j:=rng.Top to rng.Bottom do rct.Bottom:=rct.Bottom+self.RowHeights[j]+1;
end;

procedure HorisontalForFixed;
var
  j : integer;
begin
  //расчет горизонтальных координат для фиксированных строк
  rct.Left:=0;
  for j:=0 to rng.left-1 do rct.Left:=rct.Left+self.ColWidths[j]+1;
  rct.Right:=rct.Left;
  for j:=rng.left to rng.Right do rct.Right:=rct.Right+self.ColWidths[j]+1;
end;

procedure HorisontalForMoved;
var
  j : integer;
begin
  //вычисление левой позиции зависит от того, где находится начало прямоугольника
  //слева от ColLeft справа
  rct.left:=0;
  if rng.left>=leftcol then begin
    for j:=0 to self.FixedCols-1 do rct.left:=rct.left+self.ColWidths[j]+1;
    for j:=leftcol to rng.left-1 do rct.left:=rct.left+self.ColWidths[j]+1;
  end;
  if rng.left<leftcol then begin
    for j:=0 to self.FixedCols-1 do rct.left:=rct.left+self.ColWidths[j]+1;
    for j:=rng.left to leftcol-1 do rct.left:=rct.left-self.ColWidths[j]-1;
  end;
  //вычислем кординаты правого нижнего угла относительно левого
  rct.Right:=rct.Left;
  for j := rng.left to rng.Right do rct.Right:=rct.Right+self.ColWidths[j]+1;
end;

procedure VerticalForMoved;
var
  j : integer;
begin
  //вычисление верхней позиции зависит от того, где находится начало прямоугольника
  //сверху от TopRow или снизу
  rct.Top:=0;
  if rng.Top>=toprow then begin
    for j:=0 to self.FixedRows-1 do rct.top:=rct.top+self.RowHeights[j]+1;
    for j:=toprow to rng.top-1 do rct.top:=rct.top+self.RowHeights[j]+1;
  end;
  if rng.top<toprow then begin
    for j:=0 to self.FixedRows-1 do rct.top:=rct.top+self.RowHeights[j]+1;
    for j:=rng.top to toprow-1 do rct.top:=rct.top-self.RowHeights[j]-1;
  end;
  //вычислем кординаты правого нижнего угла относительно левого
  rct.Bottom:=rct.Top;
  for j := rng.Top to rng.Bottom do rct.Bottom:=rct.Bottom+self.RowHeights[j]+1;
end;

begin
  inherited;
  //запоминаем настройки цвета
  fnt:=self.Canvas.Font;
  bclr:=self.Canvas.Brush.Color;
  pn:=self.Canvas.Pen;
  //рисуем диапазоны в подвшижных ячейках диапазоны
  for i := low(self.FRanges) to high(self.FRanges) do begin
    Rng:=self.FRanges[i];
    if (rng.left>=self.FixedCols)and(rng.Top>=self.FixedRows)and
    (rng.Bottom>=TopRow)and(self.CellRect(rng.left,rng.Top).Top<self.ClientRect.Bottom)and
    (rng.Right>=LeftCol)and(self.CellRect(rng.left,rng.Top).Left<self.ClientRect.Right) then begin
      VerticalForMoved;
      HorisontalForMoved;
      if rng.Font<>nil then self.Canvas.Font:=rng.Font;
      if rng.BrushColor<>0 then self.Canvas.Brush.Color:=rng.BrushColor;
      if rng.pencolor<>0 then self.Canvas.Pen.Color:=rng.pencolor;
      self.Canvas.Rectangle(rct);
      inc(rct.Top,2);inc(rct.Left,2);
      dec(rct.Bottom,2); dec(rct.Right,2);
      txt:=rng.Text;
      h:=DrawText(canvas.Handle,pchar(txt),Length(txt),rct,rng.Align);
      if (rng.Top=rng.Bottom)and(self.RowHeights[rng.Top]<h+8) then self.RowHeights[rng.Top]:=h+8;
    end;
  end;
  //рисуем фиксированные строки и столбцы
  for i := low(self.FRanges) to high(self.FRanges) do begin
    Rng:=self.FRanges[i];
    candraw:=false;
    if (rng.left>=0)and(rng.Right<self.FixedCols)and
    (rng.Bottom>=TopRow)and(self.CellRect(rng.left,rng.Top).Top<self.ClientRect.Bottom)then begin
      VerticalForMoved;
      HorisontalForFixed;
      dec(rct.Left);
      candraw:=true;
    end;
    if (rng.Top>=0)and(rng.Bottom<self.FixedRows)and
    (rng.Right>=LeftCol)and(self.CellRect(rng.left,rng.Top).Left<self.ClientRect.Right) then begin
      VerticalForFixed;
      HorisontalForMoved;
      dec(rct.top);
      candraw:=true;
    end;
    if candraw then begin
      self.Canvas.Pen.Color:=self.FFixedPenColor;
      self.Canvas.Font:=self.FFixedFont;
      self.Canvas.Rectangle(rct);
      //вывод текста
      inc(rct.Top,2);inc(rct.Left,2);
      dec(rct.Bottom,2); dec(rct.Right,2);
      txt:=rng.Text;
      h:=DrawText(canvas.Handle,pchar(txt),Length(txt),rct,rng.Align);
      if (rng.Top=rng.Bottom)and(self.RowHeights[rng.Top]<h+8) then self.RowHeights[rng.Top]:=h+8;
    end;
  end;
  //рисуем неподвижные ячейки правого верхнего угла
  for i := low(self.FRanges) to high(self.FRanges) do begin
    Rng:=self.FRanges[i];
    if (rng.left>=0)and(rng.Right<self.FixedCols)and(rng.Top>=0)and(rng.Bottom<self.FixedRows)then begin
      HorisontalForFixed;
      VerticalForFixed;
      dec(rct.top);
      dec(rct.Left);
      self.Canvas.Pen.Color:=self.FFixedPenColor;
      self.Canvas.Font:=self.FFixedFont;
      self.Canvas.Rectangle(rct);
      //вывод текста
      inc(rct.Top,2);inc(rct.Left,2);
      dec(rct.Bottom,2); dec(rct.Right,2);
      txt:=rng.Text;
      h:=DrawText(canvas.Handle,pchar(txt),Length(txt),rct,rng.Align);
      if (rng.Top=rng.Bottom)and(self.RowHeights[rng.Top]<h+8) then self.RowHeights[rng.Top]:=h+8;
    end;
  end;
  self.Canvas.Font:=fnt;
  self.Canvas.Brush.Color:=bclr;
  self.Canvas.Pen:=pn;
end;


end.
