unit RecordEditprUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, Buttons, ExtCtrls, ComCtrls, Grids, ValEdit,
  DBGrids, DB, dbf, AppEvnts, DataUnit;

type
  TErrorRec = record
    code     : integer;
    erortype : integer;
    text     : string;
  end;

  TRecordEditorForm = class(TForm)
    LeftPn: TPanel;
    ClientPn: TPanel;
    ClientNameED: TEdit;
    SerialPn: TPanel;
    Label16: TLabel;
    SerialED: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    ClientTelED: TEdit;
    Label4: TLabel;
    ProductPn: TPanel;
    Label1: TLabel;
    ProductCB: TComboBox;
    ProductED: TEdit;
    WDatesPn: TPanel;
    Label17: TLabel;
    ProductImg: TImage;
    WTypePn: TPanel;
    Label18: TLabel;
    WTypeCB: TComboBox;
    SalesDateLB: TLabel;
    SalesDateTP: TDateTimePicker;
    ModelPn: TPanel;
    Label15: TLabel;
    ModelCB: TComboBox;
    ModelED: TEdit;
    Label19: TLabel;
    WStartTP: TDateTimePicker;
    WEndTP: TDateTimePicker;
    ClientAddrED: TMemo;
    RightPn: TPanel;
    WorksPn: TPanel;
    Label11: TLabel;
    WorksImg: TImage;
    WorksCB: TComboBox;
    BottomPn: TPanel;
    WorksED: TMemo;
    DeefectPn: TPanel;
    Label5: TLabel;
    DeffectImg: TImage;
    DeffectED: TMemo;
    WorksPriceED: TEdit;
    Label7: TLabel;
    MovCheck: TCheckBox;
    MovPriceED: TEdit;
    PartsPN: TPanel;
    Label8: TLabel;
    PartsImg: TImage;
    AddPartsBtn: TSpeedButton;
    NotePN: TPanel;
    ModelImg: TImage;
    SerialImg: TImage;
    WTypeImg: TImage;
    ClientImg: TImage;
    WDatesImg: TImage;
    SalesDateImg: TImage;
    DefDescrED: TEdit;
    DefCodeED: TEdit;
    SelDefCodeBtn: TSpeedButton;
    Label9: TLabel;
    NoteED: TEdit;
    PartsGrid: TStringGrid;
    ApplicationEvents1: TApplicationEvents;
    DelAllPartsBtn: TSpeedButton;
    DelPartBtn: TSpeedButton;
    OkBtn: TSpeedButton;
    CloseBtn: TSpeedButton;
    VerifyBtn: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SetPanelEnabled(pn : TPanel; enbl : boolean);
    procedure UpdateControls(Sender: TObject);
    procedure SetEcitEnabled(Sender: TObject; enbl : boolean);
    procedure ProductCBChange(Sender: TObject);
    procedure UpdateProductionCB(const id:integer=-1);
    procedure UpdateModelCB(mt : integer; const id:integer=-1);
    function  GetIndex(combo,edit : TObject):integer;
    procedure SelDefCodeBtnClick(Sender: TObject);
    procedure EnterInToEditor(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddPartsBtnClick(Sender: TObject);
    procedure RenumeredPartsGrid;
    function  CalckPartsGridRow(row : integer):real;
    procedure PartsGridKeyPress(Sender: TObject; var Key: Char);
    procedure PartsGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure PartsGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ApplicationEvents1ShowHint(var HintStr: string;
      var CanShow: Boolean; var HintInfo: THintInfo);
    procedure DelAllPartsBtnClick(Sender: TObject);
    procedure DelPartBtnClick(Sender: TObject);
    procedure MovPriceEDKeyPress(Sender: TObject; var Key: Char);
    procedure AddPartToGrid(part:TPartRec);
    procedure UpdateErrorImages(haveerrors : boolean);
    procedure CloseBtnClick(Sender: TObject);
    function  HaveFatalErrors: boolean;
    function  HaveWarningErrors: boolean;
    function  Verify:word;
    procedure OkBtnClick(Sender: TObject);
    procedure VerifyBtnClick(Sender: TObject);
    function  CanVerifySerialNum(mt:integer) : boolean;
    function  DecodeSerialNum(sn : string; var fid, mt,md,shtid : integer; var mdate:TDate):string;
    procedure AddToErrorArray(code,errortype : integer; text : string);
    function  UpAndTranslate(str:string;oneword:boolean;const translate : boolean=true ):string;
    procedure Save(stat : integer);
    procedure MovCheckClick(Sender: TObject);
    procedure ProductCBDropDown(Sender: TObject);
    procedure ModelCBChange(Sender: TObject);
  private
    { Private declarations }
    recID : integer;
  public
    { Public declarations }

  end;


function EditRecord(id : integer; const copymode : boolean=false):integer;

implementation

{$R *.dfm}

uses SelectCodesUnit, SelectPartsUnit, UnknownPartEditUnit, DateUtils;

const
  //коды ошибок
  ertFatal=1;
  ertWarning=2;
  erMainType=1;
  erModel=2;
  erSerial=3;
  erWType=4;
  erClient=5;
  erDeffect=6;
  erWork=7;
  erSalesDate=8;
  erWorksDate=9;
  erPart=10;
  //максимальная продолжительность ремонта
  MaxWorkTime=40;

function EditRecord(id : integer; const copymode : boolean=false):integer;
var
  form : TRecordEditorForm;
  mt,md  : integer;
  val    : real;
  str    : string;
  ppart  : ^TPartRec;
begin
  result:=0;
  form := TRecordEditorForm.Create(application);
  form.SalesDateTP.Date:=now;
  form.WStartTP.Date:=now;
  form.WEndTP.Date:=now;
  if (id>0)and(DataMod.ReportDBF.Locate('ID',id,[])) then with form do begin
    recID:=id;
    //тип продукции
    mt:=DataMod.ReportDBF.FieldByName('MAINTYPEID').AsInteger;
    UpdateProductionCB(mt);
    str:=DataMod.ReportDBF.FieldByName('PRODNAME').AsString;
    SetEcitEnabled(ProductED,((mt=0)and(length(str)>0)));
    if (mt=0)and(length(str)>0)then ProductED.Text:=str;
    //модель продукции
    md:=DataMod.ReportDBF.FieldByName('MODELID').AsInteger;
    UpdateModelCB(mt,md);
    str:=DataMod.ReportDBF.FieldByName('MODELNOTE').AsString;
    SetEcitEnabled(ModelED,((md=0)and(length(str)>0)));
    if (md=0)and(length(str)>0)then ModelED.Text:=str;
    //вид ремонта
    WTypeCB.ItemIndex:=DataMod.ReportDBF.FieldByName('WORKID').AsInteger-1;
    ClientPn.Enabled:=(WTypeCB.ItemIndex>0);
    //данные о кклиенте
    ClientNameED.Text:=DataMod.ReportDBF.FieldByName('CLIENT').AsString;
    ClientAddrED.Text:=DataMod.ReportDBF.FieldByName('CLIENTADDR').AsString;
    ClientTelED.Text:=DataMod.ReportDBF.FieldByName('CLIENTTEL').AsString;
    //серийный номер
    str:=DataMod.ReportDBF.FieldByName('SN').AsString;
    SetEcitEnabled(SerialED,Length(str)>0);
    if (length(str)>0)then SerialED.Text:=str;
    //даты
    if ClientPn.Enabled then SalesDateTP.Date:=DataMod.ReportDBF.FieldByName('BUYDATE').AsDateTime;
    WStartTP.Date:=DataMod.ReportDBF.FieldByName('STARTDATE').AsDateTime;
    WEndTP.Date:=DataMod.ReportDBF.FieldByName('ENDDATE').AsDateTime;
    //код и описание деффекта
    str:=DataMod.ReportDBF.FieldByName('WORKCODE').AsString;
    SetEcitEnabled(DefCodeED,Length(str)>0);
    if (length(str)>0)then DefCodeED.Text:=str;
    str:=DataMod.ReportDBF.FieldByName('PROBLEMNOT').AsString;
    SetEcitEnabled(DefDescrED,Length(str)>0);
    if (length(str)>0)then DefDescrED.Text:=str;
    str:=DataMod.ReportDBF.FieldByName('ADDPROBNOT').AsString;
    SetEcitEnabled(DeffectED,Length(str)>0);
    if (length(str)>0)then DeffectED.Text:=str;
    //описание работ
    str:=DataMod.ReportDBF.FieldByName('WORKNOTE').AsString;
    SetEcitEnabled(WorksED,Length(str)>0);
    if (length(str)>0)then WorksED.Text:=str;
    //стоимость выезда
    val:=DataMod.ReportDBF.FieldByName('MOVPRICE').AsFloat;
    MovCheck.Checked:=(val>0);
    SetEcitEnabled(MovPriceED,val>0);
    if val>0 then MovPriceED.Text:=FormatFloat('#####0.00',val);
    //стоимость ремонта
    val:=DataMod.ReportDBF.FieldByName('WORKPRICE').AsFloat;
    SetEcitEnabled(WorksPriceED,val>0);
    if val>0 then WorksPriceED.Text:=FormatFloat('#####0.00',val);
    //примечание
    str:=DataMod.ReportDBF.FieldByName('NOTE').AsString;
    SetEcitEnabled(NoteED,Length(str)>0);
    if (length(str)>0)then NoteED.Text:=str;
    //первая деталь
    str:=DataMod.ReportDBF.FieldByName('PARTS').AsString;
    if length(str)>0 then begin
      new(ppart);
      ppart^.code:=DataMod.ReportDBF.FieldByName('PARTSCODE').AsString;
      ppart^.descr:=DataMod.ReportDBF.FieldByName('PARTS').AsString;
      ppart^.cnt:=DataMod.ReportDBF.FieldByName('PARTQTY').AsFloat;
      ppart^.price:=DataMod.ReportDBF.FieldByName('PARTCOST').AsFloat;
      if DataMod.ReportDBF.Fields.FindField('PARTDOC')<>nil then 
        ppart^.doc:=DataMod.ReportDBF.FieldByName('PARTDOC').AsString else ppart^.doc:='';
      form.AddPartToGrid(ppart^);
    end;
    //выводим остальные детали
    DataMod.ReportDBF.Filter:='PARENT='+inttostr(recID);
    DataMod.ReportDBF.Filtered:=true;
    while not DataMod.ReportDBF.Eof do begin
      new(ppart);
      ppart^.code:=DataMod.ReportDBF.FieldByName('PARTSCODE').AsString;
      ppart^.descr:=DataMod.ReportDBF.FieldByName('PARTS').AsString;
      ppart^.cnt:=DataMod.ReportDBF.FieldByName('PARTQTY').AsFloat;
      ppart^.price:=DataMod.ReportDBF.FieldByName('PARTCOST').AsFloat;
      if DataMod.ReportDBF.Fields.FindField('PARTDOC')<>nil then 
        ppart^.doc:=DataMod.ReportDBF.FieldByName('PARTDOC').AsString else ppart^.doc:='';
      form.AddPartToGrid(ppart^);
      DataMod.ReportDBF.Next;
    end;
    DataMod.ReportDBF.Filter:='';
    DataMod.ReportDBF.Filtered:=false;
    Verify;
    //если это режим копирования - сбрасываем recID
    if copymode then recID:=0;
  end;
  form.ShowModal;
  result:=form.recID;
  form.Free;
end;

procedure TRecordEditorForm.FormCreate(Sender: TObject);
var
  i    : integer;
begin
  self.UpdateProductionCB;
  for I := 1 to high(WorkTypes) do WTypeCB.Items.Add(WorkTypes[i]);
  self.SetPanelEnabled(self.ClientPn,false);
  self.SetEcitEnabled(ProductED,false);
  self.SetEcitEnabled(ModelED,false);
  self.SetEcitEnabled(DefCodeED,false);
  self.SetEcitEnabled(DefDescrED,false);
  self.SetEcitEnabled(DeffectED,false);
  self.SetEcitEnabled(WorksED,false);
  self.SetEcitEnabled(SerialED,false);
  self.SetEcitEnabled(NoteED,false);
  self.UpdateControls(self);
end;

//---------------- управление интерфесом ---------------------------------------

procedure TRecordEditorForm.FormShow(Sender: TObject);
begin
  PartsGrid.Cells[0,0]:=' №';
  PartsGrid.Cells[1,0]:=' Наименование';
  PartsGrid.Cells[2,0]:=' Кол-во';
  PartsGrid.Cells[3,0]:=' Стоим';
  PartsGrid.Cells[4,0]:=' № накладной';
  PartsGrid.ColWidths[1]:=PartsGrid.ClientWidth-PartsGrid.ColWidths[0]-
    PartsGrid.ColWidths[2]-PartsGrid.ColWidths[3]-PartsGrid.ColWidths[4]-6;
  SetPanelEnabled(ClientPn,true);
  UpdateControls(self);
  ProductPn.Realign;
  ModelPn.Realign;
end;

procedure TRecordEditorForm.UpdateControls(Sender: TObject);
begin
  ProductED.Visible:=(ProductCB.ItemIndex=(ProductCB.Items.Count-1));
  ModelCB.Enabled:=(ProductCB.ItemIndex>=0)and(ModelCB.Items.Count>1);
  ModelED.Visible:=(ModelCB.Items.Count>0)and(ModelCB.ItemIndex=(ModelCB.Items.Count-1));
  //if(WTypeCB.ItemIndex>0)then SetPanelEnabled(ClientPn,true) else SetPanelEnabled(ClientPn,false);
  self.SalesDateTP.Visible:=(WTypeCB.ItemIndex>0);
  self.SalesDateLB.Visible:=self.SalesDateTP.Visible;
  SelDefCodeBtn.Enabled:=(ProductCB.ItemIndex<(ProductCB.Items.Count-1))and(ProductCB.ItemIndex>=0);
  MovPriceED.Visible:=MovCheck.Checked;
  AddPartsBtn.Enabled:=(ModelCB.ItemIndex>=0);
end;

procedure TRecordEditorForm.SetPanelEnabled(pn : TPanel; enbl : boolean);
var
  i : integer;
begin
  for I := 0 to pn.ControlCount - 1 do begin
    pn.Controls[i].Enabled:=enbl;
    if (not enbl)then begin
      if(pn.Controls[i] is TEdit) then (pn.Controls[i] as TEdit).text:='';
      if(pn.Controls[i] is TMemo) then (pn.Controls[i] as TMemo).Lines.Clear;
    end;
  end;
  pn.Enabled:=enbl;
end;

procedure TRecordEditorForm.SetEcitEnabled(Sender: TObject; enbl : boolean);
begin
  if enbl then begin
    if (sender is TEdit)and((Sender as TEdit).Font.Color=clGray) then begin
      (Sender as TEdit).Font.Color:=clBlack;
      (Sender as TEdit).Text:='';
    end;
    if (sender is TMemo)and((Sender as TMemo).Font.Color=clGray) then begin
      (Sender as TMemo).Font.Color:=clBlack;
      (Sender as TMemo).Lines.Clear;
    end;
  end else begin
    if (sender is TEdit)then begin
      (Sender as TEdit).Font.Color:=clGray;
      if(Sender as TEdit).Name='ProductED' then (Sender as TEdit).Text:='введите тип продукции';
      if(Sender as TEdit).Name='ModelED' then (Sender as TEdit).Text:='введите модель продукции';
      if(Sender as TEdit).Name='DefCodeED' then (Sender as TEdit).Text:='';
      if(Sender as TEdit).Name='DefDescrED' then (Sender as TEdit).Text:='выберите код из списка';
      if(Sender as TEdit).Name='NoteED' then (Sender as TEdit).Text:='введите примечание';
      if(Sender as TEdit).Name='SerialED' then (Sender as TEdit).Text:='введите серийный номер';
      if(Sender as TEdit).Name='MovPriceED' then (Sender as TEdit).Text:='0,00';
      if(Sender as TEdit).Name='WorksPriceED' then (Sender as TEdit).Text:='0,00';
    end;
    if (sender is TMemo)then begin
      (Sender as TMemo).Font.Color:=clGray;
      (Sender as TMemo).Lines.Clear;
      (Sender as TMemo).Lines.Add('дополнительная информация');
    end;
  end;
end;

procedure TRecordEditorForm.UpdateProductionCB(const id: Integer=-1);
var
  pint : ^integer;
  sel  : integer;
begin
  sel:=-1;
  DataMod.MAINTYPES.First;
  while not DataMod.MAINTYPES.Eof do begin
    new(pint);
    pint^:=DataMod.MAINTYPES.FieldByName('ID').AsInteger;
    ProductCB.Items.AddObject(DataMod.MAINTYPES.FieldByName('DESCR').AsString,TObject(pint));
    if (id>0)and(pint^=id) then sel:=(ProductCB.Items.Count-1);
    DataMod.MAINTYPES.Next;
  end;
  ProductCB.Items.Add('другое изделеие');
  if(id=0)then ProductCB.ItemIndex :=ProductCB.Items.Count-1 else ProductCB.ItemIndex:=sel;
end;

procedure TRecordEditorForm.UpdateModelCB(mt : integer; const id: Integer=-1);
var
  pint : ^integer;
  sel  : integer;
begin
  sel:=-1;
  ModelCB.Clear;
  if mt>0 then begin
    DataMod.PRODUCTIONMODELS.First;
    while not DataMod.PRODUCTIONMODELS.Eof do begin
      if (DataMod.PRODUCTIONMODELS.FieldByName('MAINTYPE').AsInteger=mt)and
      (DataMod.PRODUCTIONMODELS.FieldByName('DESCR').AsString<>'NULL') then begin
        new(pint);
        pint^:=DataMod.PRODUCTIONMODELS.FieldByName('ID').AsInteger;
        ModelCB.Items.AddObject(DataMod.PRODUCTIONMODELS.FieldByName('DESCR').AsString,TObject(pint));
        if (id>0)and(pint^=id) then sel:=(ModelCB.Items.Count-1);
      end;
      DataMod.PRODUCTIONMODELS.Next;
    end;
  end;
  ModelCB.Items.Add('другая модель');
  if(id=0)or(ModelCB.Items.Count=1)then ModelCB.ItemIndex:=ModelCB.Items.Count-1 else ModelCB.ItemIndex:=sel;
end;

procedure TRecordEditorForm.EnterInToEditor(Sender: TObject);
begin
  SetEcitEnabled(sender,true);
end;

procedure TRecordEditorForm.CloseBtnClick(Sender: TObject);
begin
  self.ModalResult:=mrCancel;
end;

procedure TRecordEditorForm.OkBtnClick(Sender: TObject);
var
  ind,smt,smd,ssft,id : integer;
  mdate : TDate;
  part  : ^TPartRec;
  FLD   : TStringField;
begin
  //Проверка указан вид продукции (хотя бы одно обязательное поле)
  if(self.GetIndex(ProductCB,ProductED)=-1) then begin
    MessageBox(self.Handle,PChar('Введите вид продукции !'),PChar('Внимание !'),MB_ICONWARNING+MB_OK);
    Abort;
  end;
  if recID=0 then begin
    //получаем новый ID для записи о ремонте
    recID:=DataMod.GetNewID(TempRepFName);
    DataMod.ReportDBF.Append;
  end else begin
    //находи запись о ремонт у начинаем редактирование
    DataMod.ReportDBF.Locate('ID',recID,[]);
    DataMod.ReportDBF.Edit;
  end;
  with DataMod.ReportDBF do begin
    FieldByName('ID').AsInteger:=recID;
    FieldByName('STATUS').AsInteger:=self.Verify;
    //тип продукции
    ind:=self.GetIndex(self.ProductCB,self.ProductED);
    if ind>0 then FieldByName('PRODNAME').AsString:=ProductCB.Items[ProductCB.ItemIndex];
    if ind=0 then FieldByName('PRODNAME').AsString:=ProductED.Text;
    if ind<0 then FieldByName('PRODNAME').AsVariant:=NULL;
    if ind>0 then FieldByName('MAINTYPEID').AsInteger:=ind else FieldByName('MAINTYPEID').AsVariant:=NULL;
    //модель продукции
    ind:=self.GetIndex(self.ModelCB,self.ModelED);
    if ind>0 then FieldByName('MODELNOTE').AsString:=self.ModelCB.Items[self.ModelCB.ItemIndex];
    if ind=0 then FieldByName('MODELNOTE').AsString:=self.ModelED.Text;
    if ind<0 then FieldByName('MODELNOTE').AsVariant:=NULL;
    if ind>0 then FieldByName('MODELID').AsInteger:=ind else FieldByName('MODELID').AsVariant:=NULL;
    //тип ремонта
    FieldByName('WORKTYPE').AsString:=self.WTypeCB.Items[self.WTypeCB.ItemIndex];
    FieldByName('WORKID').AsInteger:=self.WTypeCB.ItemIndex+1;
    //данные о клинете
    FieldByName('CLIENT').AsString:=self.ClientNameED.Text;
    FieldByName('CLIENTADDR').AsString:=self.ClientAddrED.Text;
    FieldByName('CLIENTTEL').AsString:=self.ClientTelED.Text;
    //серийный номер и данные расшифровки серийного номера
    FieldByName('SN').AsString:=self.SerialED.Text;
    ind:=0; smt:=0; ssft:=0; mdate:=0;
    self.DecodeSerialNum(self.SerialED.Text,ind,smt,smd,ssft,mdate);
    FieldByName('FACTORYID').AsInteger:=ind;
    FieldByName('GROUPID').AsVariant:=DataMod.PRODUCTIONMODELS.Lookup('ID',smd,'PRODGROUP');
    if mdate>0 then FieldByName('MAINDATE').AsDateTime:=mdate else FieldByName('MAINDATE').AsVariant:=NULL;
    FieldByName('SHIFTID').AsInteger:=ssft;
    //даты
    if self.WTypeCB.ItemIndex>0 then FieldByName('BUYDATE').AsDateTime:=self.SalesDateTP.Date
      else FieldByName('BUYDATE').AsVariant:=NULL;
    FieldByName('STARTDATE').AsDateTime:=WStartTP.Date;
    FieldByName('ENDDATE').AsDateTime:=WEndTP.Date;
    //стоимость выезда и ремонта
    FieldByName('MOVPRICE').AsFloat:=StrToFloatDef(MovPriceED.Text,0);
    FieldByName('WORKPRICE').AsFloat:=StrToFloatDef(WorksPriceED.Text,0);
    //описание неисправности и код неисправности
    if (DefCodeED.Font.Color=clBlack)and(length(DefCodeED.Text)>0) then
      FieldByName('WORKCODE').AsString:=DefCodeED.Text else FieldByName('WORKCODE').AsVariant:=NULL;
    if (DefDescrED.Font.Color=clBlack)and(length(DefDescrED.Text)>0) then
       FieldByName('PROBLEMNOT').AsString:=DefDescrED.Text else FieldByName('PROBLEMNOT').AsVariant:=NULL;
    if (DeffectED.Font.Color=clBlack)and(length(DeffectED.Text)>0) then
       FieldByName('ADDPROBNOT').AsString:=DeffectED.Text else FieldByName('ADDPROBNOT').AsVariant:=NULL;
    //описание вида работ
    if (WorksED.Font.Color=clBlack)and(length(WorksED.Text)>0) then
      FieldByName('WORKNOTE').AsString:=WorksED.Text else FieldByName('WORKNOTE').AsVariant:=NULL;
    //запись первой детали
    if PartsGrid.Enabled then begin
      Part:=pointer(PartsGrid.Objects[0,1]);
      FieldByName('PARTSCODE').AsString:=part^.code;
      FieldByName('PARTS').AsString:=part^.descr;
      FieldByName('PARTQTY').AsFloat:=StrToFloatDef(PartsGrid.Cells[2,1],0);
      FieldByName('PARTCOST').AsFloat:=part^.price;
      if Fields.FindField('PARTDOC')<>nil then FieldByName('PARTDOC').AsString:=PartsGrid.Cells[4,1];
    end else begin
      FieldByName('PARTSCODE').AsVariant:=NULL;
      FieldByName('PARTS').AsVariant:=NULL;
      FieldByName('PARTQTY').AsVariant:=NULL;
      FieldByName('PARTCOST').AsVariant:=NULL;
      if Fields.FindField('PARTDOC')<>nil then FieldByName('PARTDOC').AsVariant:=NULL;
    end;
    //примечание
    if (NoteED.Font.Color=clBlack)and(length(NoteED.Text)>0) then
      FieldByName('NOTE').AsString:=self.NoteED.Text else FieldByName('NOTE').AsVariant:=NULL;
    //родитель ноль. Потомуч то это основная запись о ремонте
    FieldByName('PARENT').AsInteger:=0;
    Post;
    //удаляем старые данные
    DataMod.ReportDBF.Filter:='PARENT='+inttostr(recID);
    DataMod.ReportDBF.Filtered:=true;
    while not DataMod.ReportDBF.Eof do DataMod.ReportDBF.Delete;
    DataMod.ReportDBF.Filter:='';
    DataMod.ReportDBF.Filtered:=false;
    //запись дополнитлеьных деталей
    if (PartsGrid.Enabled)and(PartsGrid.RowCount>2) then begin
      //записываем дополнительные детали
      for ind := 2 to PartsGrid.RowCount - 1 do begin
        Append;
        Part:=pointer(PartsGrid.Objects[0,ind]);
        FieldByName('PARTSCODE').AsString:=part^.code;
        FieldByName('PARTS').AsString:=part^.descr;
        FieldByName('PARTQTY').AsFloat:=StrToFloatDef(PartsGrid.Cells[2,ind],0);
        FieldByName('PARTCOST').AsFloat:=part^.price;
        FieldByName('PARENT').AsInteger:=recID;
        if Fields.FindField('PARTDOC')<>nil then FieldByName('PARTDOC').AsString:=PartsGrid.Cells[4,ind];
        Post;
      end;
    end;
  end;
  self.ModalResult:=mrOk;
  self.Close;
end;

procedure TRecordEditorForm.MovCheckClick(Sender: TObject);
begin
  SetEcitEnabled(MovPriceED,false);
  UpdateControls(self);
end;

//-------------- вывод, обработка и проверка информации ------------------------

procedure TRecordEditorForm.ProductCBChange(Sender: TObject);
var
  mt     : ^integer;
  change : integer;
begin
  change:=mrYes;
  if (ProductCB.Tag>=0)and(ProductCB.ItemIndex<>ProductCB.Tag) then
    change:=MessageBox(self.Handle,PChar('При смене типа продукции некоторые поля будут очищены !'+
      chr(13)+'Продолжить ?'),PChar('Внимание !'),MB_ICONWARNING+MB_YESNO);
  if change=mrNo then ProductCB.ItemIndex:=ProductCB.Tag else begin
    if ProductCB.Items.Objects[ProductCB.ItemIndex]=nil then self.UpdateModelCB(0,0)
      else begin
        mt:=pointer(ProductCB.Items.Objects[ProductCB.ItemIndex]);
        self.UpdateModelCB(mt^);
      end;
    SetEcitEnabled(ProductED,false);
    SetEcitEnabled(ModelED,false);
    SetEcitEnabled(DefCodeED,false);
    SetEcitEnabled(DefDescrED,false);
    self.UpdateControls(self);
  end;
end;

procedure TRecordEditorForm.ModelCBChange(Sender: TObject);
var
  change : integer;
begin
  change:=mrYes;
  if (ModelCB.Tag>=0)and(ModelCB.ItemIndex<>ModelCB.Tag) then
    change:=MessageBox(self.Handle,PChar('При смене модели продукции некоторые поля будут очищены !'+
      chr(13)+'Продолжить ?'),PChar('Внимание !'),MB_ICONWARNING+MB_YESNO);
  if change=mrNo then ModelCB.ItemIndex:=ModelCB.Tag else begin
    self.DelAllPartsBtnClick(self);
    self.UpdateControls(self);
  end;
end;

procedure TRecordEditorForm.ProductCBDropDown(Sender: TObject);
begin
  (sender as TComboBox).Tag:=(sender as TComboBox).ItemIndex;
end;

function  TRecordEditorForm.GetIndex(combo,edit : TObject):integer;
var
  pint : ^integer;
  ind  : integer;
begin
  result:=-1;
  ind:=(combo as TComboBox).ItemIndex;
  if (ind=-1) then result:=-1 else if (ind<((combo as TComboBox).Items.Count-1)) then begin
    pint:=pointer((combo as TComboBox).Items.Objects[ind]);
    result:=pint^;
  end else begin
    if(edit is TEdit)then
      if ((edit as TEdit).Font.Color=clGray)or(length((edit as TEdit).Text)=0) then result:=-1 else result:=0;
    if(not(edit is TEdit))then
      if((edit as TMemo).Font.Color=clGray)or((edit as TMemo).Lines.Count=0) then result:=-1 else result:=0;
  end;
end;

procedure TRecordEditorForm.MovPriceEDKeyPress(Sender: TObject; var Key: Char);
var
  txt : string;
begin
    txt:=(sender as TEdit).Text;
    case Key of
      '0'..'9', #8,#13 : ;
      ','          : if Pos(',',txt)>0 then Key := #0;
      else Key:= #0;
    end;
end;

procedure TRecordEditorForm.SelDefCodeBtnClick(Sender: TObject);
var
  newcode  : string;
  maintype : integer;
  price    : real;
begin
  newcode:='';
  maintype:=self.GetIndex(ProductCB,ProductED);
  if (maintype>0)then begin
    if(DefCodeED.Font.Color=clBlack)and(length(DefCodeED.Text)>0) then
      newcode:=GetCode(ServCodesFName,maintype,DefCodeED.Text)
        else newcode:=GetCode(ServCodesFName,maintype);
    if length(newcode)>0 then begin
      SetEcitEnabled(DefCodeED,true);
      SetEcitEnabled(DefDescrED,true);
      DefCodeED.Text:=copy(newcode,1,pos('=',newcode)-1);
      delete(newcode,1,pos('=',newcode));
      DefDescrED.Text:=copy(newcode,1,pos('=',newcode)-1);
      delete(newcode,1,pos('=',newcode));
      price:=StrToFloatDef(newcode,0);
      if price=0 then WorksPriceED.Text:='0.00' else begin
        SetEcitEnabled(WorksPriceED,true);
        WorksPriceED.Text:=FormatFloat('#####0.00',price);
      end;
    end;
  end;
end;

procedure TRecordEditorForm.UpdateErrorImages(haveerrors : boolean);
var
  i   : integer;
  err : ^TErrorRec;
  img : TImage;
begin
  img:=nil;
  //если список ошибок пуст или не пуст, но не содержит фатальных ошибок
  //все имиджы делайем галочкой ОКей
  i:=0;
  while (i<errorlist.Count)and(TErrorRec(ErrorList.Items[i]^).erortype<>ertFatal) do inc(i);
  if (i=errorlist.Count)then for I := 0 to self.ComponentCount - 1 do begin
    if (self.Components[i] is TImage) then begin
      (self.Components[i] as TImage).Picture:=nil;
      DataMod.SmallImgs.GetBitmap(0,(self.Components[i] as TImage).Picture.Bitmap);
      (self.Components[i] as TImage).Hint:='';
      (self.Components[i] as TImage).ShowHint:=false;
    end;
  end;
  //если есть ошибки выставляем ссотв имиджы в соотв состояние
  if haveerrors then for I := 0 to ErrorList.Count-1  do begin
    err:=ErrorList.Items[i];
    case err.code of
      erMainType  : img:=self.ProductImg;
      erModel     : img:=self.ModelImg;
      erSerial    : img:=self.SerialImg;
      erWType     : img:=self.WTypeImg;
      erClient    : img:=self.ClientImg;
      erDeffect   : img:=self.DeffectImg;
      erWork      : img:=self.WorksImg;
      erSalesDate : img:=self.SalesDateImg;
      erWorksDate : img:=self.WDatesImg;
      erPart      : img:=self.PartsImg;
    end;
    img.Picture:=nil;
    case err.erortype of
      ertFatal   : DataMod.SmallImgs.GetBitmap(2,img.Picture.Bitmap);
      ertWarning : DataMod.SmallImgs.GetBitmap(1,img.Picture.Bitmap);
    end;
    img.ShowHint:=true;
    if length(img.Hint)=0 then img.Hint:=err.text
      else img.Hint:=img.Hint+chr(13)+err.text;
  end;
  ClientImg.Visible:=ClientPN.Enabled;
  PartsImg.Visible:=PartsGrid.Enabled;
  SalesDateImg.Visible:=ClientPN.Enabled;
end;

function  TRecordEditorForm.HaveFatalerrors : boolean;
var
  mt,md     : integer;
  snmt,snmd, snfid, snsft : integer;
  sndate    : TDate;
  str : string;
begin
  sndate:=0;
  //проверка введен ли тип продукции, определение ID типа продукции
  mt:=self.GetIndex(ProductCB,ProductED);
  if mt<0 then AddToErrorArray(erMainType,ertFatal,'тип продукции не задан');
  //проверка введена ли модель, определение ID модели
  md:=self.GetIndex(ModelCB,ModelED);
  if md<0 then AddToErrorArray(erModel,ertFatal,'модель не задана');
  //проверка ввода серийного номера и его соответствие типу и модели
  if length(SerialED.Text)>0 then begin
    if (mt>0)and(md>0)and(CanVerifySerialNum(mt)) then begin
      SerialED.Text:=UpAndTranslate(SerialED.Text,true);
      str:=DecodeSerialNum(SerialED.Text,snfid, snmt,snmd,snsft,sndate);
      if length(str)=length(SerialED.Text) then begin
        if mt<>snmt then AddToErrorArray(erSerial,ertFatal,'серийный номер не совпадает с типом продукции');
        if md<>snmd then AddToErrorArray(erSerial,ertFatal,'серийный номер не совпадает с моделью');
      end else
        if length(str)>0 then AddToErrorArray(erSerial,ertFatal,'в серийном номере понятна только часть "'+str+'"')
          else AddToErrorArray(erSerial,ertFatal,'серийный номер не распознан');
    end;
  end else AddToErrorArray(erSerial,ertFatal,'серийный номер не указан');
  //проверка ввода типа ремонта
  if WTypeCB.ItemIndex=-1 then AddToErrorArray(erWType,ertFatal,'вид ремонта не указан');
  //проверка ввода данных о клиенте
  if (WTypeCB.ItemIndex>0)and((length(ClientNameED.Text)*length(ClientAddrED.Text)*
    length(ClientTelED.Text))=0)then AddToErrorArray(erClient,ertFatal,
      'даные о клиенте указаны не полностью');
  //провека дат
  if sndate<>0 then begin
    if (WTypeCB.ItemIndex>0)and(SalesDateTP.DateTime<snDate) then
      AddToErrorArray(erSalesDate,ertFatal,'дата продажи раньше даты производства');
    if (WStartTP.DateTime<snDate) then
      AddToErrorArray(erSalesDate,ertFatal,'дата начала ремонта раньше даты производства');
    if (WEndTP.DateTime<snDate) then
      AddToErrorArray(erSalesDate,ertFatal,'дата окончания ремонта раньше даты производства');
  end;
  if (WTypeCB.ItemIndex>0) then begin
    if (WStartTP.DateTime<SalesDateTP.DateTime) then
      AddToErrorArray(erWorksDate,ertFatal,'дата начала ремонта раньше даты продажи');
    if (WEndTP.DateTime<SalesDateTP.DateTime) then
      AddToErrorArray(erWorksDate,ertFatal,'дата окончания ремонта раньше даты продажи');
  end;
  if (WEndTP.DateTime<WStartTP.DateTime) then
    AddToErrorArray(erWorksDate,ertFatal,'дата начала ремонта раньше даты окончания');
  //проверка ввода кода деффекта или описания дефекта
  if (mt>0)then begin
    if (DataMod.SERVCODES.Lookup('MAINTYPE',mt,'CODE')<>NULL)and(Length(DefCodeED.Text)=0) then
        AddToErrorArray(erDeffect,ertFatal,'код не выбран');
    if (DataMod.SERVCODES.Lookup('MAINTYPE',mt,'CODE')=NULL)and((DeffectED.Lines.Count=0)or
      (DeffectED.Font.Color=clGray)) then
        AddToErrorArray(erDeffect,ertFatal,'описание работ не указано');
  end else if {(mt=0)and}((DeffectED.Lines.Count=0)or(DeffectED.Font.Color=clGray)) then
    AddToErrorArray(erDeffect,ertFatal,'описание работ не указано');
  //проверка ввода описания и стоимости работ
  //if((Length(DefCodeED.Text)>0)or((DeffectED.Lines.Count>0)and(DeffectED.Font.Color=clBlack)))then begin
    if(WorksED.Lines.Count=0)or(WorksED.Font.Color=clGray) then
      AddToErrorArray(erWork,ertFatal,'не указаны проведенные работы');
    if(StrToFloatDef(WorksPriceED.Text,0)=0) then
      AddToErrorArray(erWork,ertFatal,'стоимость работ не указана');
  //end;
  //проверка ввода стоимости ремонта
  if (MovCheck.Checked)and(StrToFloatDef(MovPriceED.Text,0)=0) then
      AddToErrorArray(erWork,ertFatal,'стоимость выезда не указана');
  result:=(ErrorList.Count>0);
end;

function TRecordEditorForm.HaveWarningerrors:boolean;
var
  mt,cmt,i  : integer;
  price : real;
  DBF : TDBF;
begin
  //гарантийный срок
  mt:=self.GetIndex(ProductCB,ProductED);
  if (mt>0)and(ClientPn.Enabled) then begin
    i:=DataMod.MAINTYPES.Lookup('ID',mt,'GARANTTIME');
    if MonthsBetWeen(SalesDateTP.Date,WStartTP.Date)>i*12 then
      AddToErrorArray(erWorksDate,ertWarning,'гарантийный срок истек');
  end;
  //продолжительность ремонта
  if DaysBetween(WStartTP.Date,WEndTP.Date)>MaxWorkTime then
      AddToErrorArray(erWorksDate,ertWarning,'срок ремонта превышен');
  //стоимость ремонта
  if (mt>0)and(length(DefCodeED.Text)>0) then begin
    DBF:=TDBF.Create(self);
    DBF.TableName:=ServCodesFName;
    DBF.Active:=true;
    DBF.Filter:='(MAINTYPE='+inttostr(mt)+' OR MAINTYPE=0) AND CODE='
      +QuotedStr(self.DefCodeED.Text);
    DBF.Filtered:=true;
    if not DBF.IsEmpty then begin
      if DataMod.SERVPRICE.Locate('MAINTYPEID;PRICETYPE',
        VarArrayOf([DBF.FieldByName('MAINTYPE').AsInteger,
        DBF.FieldByName('PRICEID').AsInteger]),[]) then begin
          price:=DataMod.SERVPRICE.FieldByName('PRICE').AsFloat;
          if (price>0)and(StrToFloatDef(WorksPriceED.Text,0)<>price) then
            AddToErrorArray(erWork,ertWarning,'для этого кода неисправности стоимость должна быть '+
              FormatFloat('#####0.00',price));
        end;
    end;
    DBF.Free;
  end;
  //заполнение номера накладной в таблице деталей
  if (PartsGrid.Enabled)then begin
    i:=0;
    repeat inc(i);
    until (i=PartsGrid.RowCount)or(Length(PartsGrid.Cells[4,i])=0);
    if not(i=PartsGrid.RowCount)then
      AddToErrorArray(erPart,ertWarning,'для одной или нескольких деталей не указан номер накладной');
  end;
  result:=(ErrorList.Count>0);
end;

function TRecordEditorForm.Verify:word;
begin
  result:=3;
  ErrorList.Clear;
  if (self.HaveFatalerrors) then result:=1;
  if (result=3)and(HaveWarningErrors) then result:=2;
  self.UpdateErrorImages(ErrorList.Count>0);
end;

procedure TRecordEditorForm.VerifyBtnClick(Sender: TObject);
begin
  self.Verify;
end;

//---------------- работа со списком ошибок ------------------------------------

procedure TRecordEditorForm.AddToErrorArray(code,errortype : integer; text : string);
var
  rec : ^TErrorRec;
begin
  new(rec);
  rec^.code:=code;
  rec^.erortype:=errortype;
  rec^.text:=text;
  ErrorList.Add(rec);
end;

function TRecordEditorForm.UpAndTranslate(str:string;oneword:boolean;const translate : boolean=true ):string;
var
  i : integer;
begin
  //функция удалаяет начальниые и конечные пробелы и заменяет возможные символы
  //кирилицы на латиницу
  str:=AnsiUpperCase(str);
  i:=1;
  while(i<=Length(str))and((str[i]=chr(32))or(str[i]=chr(160)))do begin
    delete(str,i,1);
    inc(i);
  end;
  i:=Length(str);
  while(i>=1)and((str[i]=chr(32))or(str[i]=chr(160)))do begin
    delete(str,i,1);
    dec(i);
  end;
  if oneword then begin
    str:=StringReplace(str,chr(32), '',[rfReplaceAll, rfIgnoreCase]);
    str:=StringReplace(str,chr(160), '',[rfReplaceAll, rfIgnoreCase]);
    str:=StringReplace(str,'-', '',[rfReplaceAll, rfIgnoreCase]);
  end;
  if translate then begin
    str:=StringReplace(str,'А', 'A',[rfReplaceAll, rfIgnoreCase]);
    str:=StringReplace(str,'В', 'B',[rfReplaceAll, rfIgnoreCase]);
    str:=StringReplace(str,'С', 'C',[rfReplaceAll, rfIgnoreCase]);
    str:=StringReplace(str,'Д', 'D',[rfReplaceAll, rfIgnoreCase]);
    str:=StringReplace(str,'Е', 'E',[rfReplaceAll, rfIgnoreCase]);
    str:=StringReplace(str,'К', 'K',[rfReplaceAll, rfIgnoreCase]);
    str:=StringReplace(str,'О', 'O',[rfReplaceAll, rfIgnoreCase]);
    str:=StringReplace(str,'Р', 'R',[rfReplaceAll, rfIgnoreCase]);
  end;
  result:=str;
end;

//-------------------- обработка серийного номера ------------------------------

function  TRecordEditorForm.CanVerifySerialNum(mt:integer) : boolean;
begin
  //функция определяет стоит ли проверять корректность ввода серийного номера
  //для этого необходимо, что бы тип продукции был описан в таблице моделей
  result:=not(DataMod.PRODUCTIONMODELS.Lookup('MAINTYPE',mt,'IDFORSN')=NULL);
end;

function  TRecordEditorForm.DecodeSerialNum(sn : string;var fid, mt,md,shtid : integer; var mdate:TDate):string;
var
  str : string;
begin
  //функция возвращает проверенную часть серийного номера. Если возвращаемое значение
  //полностью совпадает с переданным в функцию значением SN можно сделать вывод, что
  //номер распознан. В переменных MT и МD возвращаются определенные из серийного
  //номер значения индексов типа и модели, в переменной MDATA - дата производства
  result:='';
  if length(sn)>0 then begin
    //онуление переменных
    fid:=0;
    mt:=0;
    md:=0;
    mdate:=0;
    //проверка признака завода изготовлителя, поиск в таблице моделей,
    //определение типа и модели
    if (sn[1]='K')or(sn[1]='N') then begin
      if (sn[1]='K') then fid:=1;
      if (sn[1]='N') then fid:=2;
      result:=sn[1];
      with DataMod.PRODUCTIONMODELS do begin
        First;
        while (not EoF)and(pos(FieldByName('IDFORSN').AsString,sn)<>2) do begin
         Next;
        end;
        if (pos(FieldByName('IDFORSN').AsString,sn)=2) then begin
          mt:=FieldByName('MAINTYPE').AsInteger;
          md:=FieldByName('ID').AsInteger;
          result:=result+FieldByName('IDFORSN').AsString;
        end;
      end;
    end;
    //определение корректности записи даты производства
    str:=copy(sn,length(result)+1,6);
    if(md>0)and(md>0)and(length(str)=6)then begin
      insert('.',str,3); insert('.20',str,6);
      mdate:=StrToDateTimeDef(str,0);
      if mdate<>0 then result:=result+FormatDateTime('ddmmyy',mdate);
    end;
    //определение кооректности записи номера смены и номера изделия
    if (mdate<>0)and(length(sn)=length(result)+4)and((sn[length(sn)-3]='A')or
      (sn[length(sn)-3]='B')or(sn[length(sn)-3]='C')or(sn[length(sn)-3]='D')or
      (sn[length(sn)-3]='E'))then begin
        shtid:=ord(sn[length(sn)-3])-64;
        result:=result+(sn[length(sn)-3]);
        if (StrToIntDef(copy(sn,length(sn)-2,maxint),0)>0) then
          result:=result+copy(sn,length(result)+1,maxint);
       end;
  end;
end;

//---------------------------- таблица деталей ---------------------------------

procedure TRecordEditorForm.PartsGridKeyPress(Sender: TObject; var Key: Char);
var
  txt : string;
begin
  if (PartsGrid.Selection.Top>0)and(PartsGrid.selection.Left=2) then begin
    txt:=PartsGrid.Cells[0,PartsGrid.Selection.Top];
    case Key of
      '0'..'9', #8,#13 : ;
      ','          : if Pos(',',txt)>0 then Key := #0;
      else Key:= #0;
    end;
  end;
end;

procedure TRecordEditorForm.AddPartToGrid(part:TPartRec);
var
  j,r    : integer;
  exists : boolean;
  ppart  : ^TPartRec;
begin
  //ещим может такая деталь уже в таблице
  exists:=false;
  j:=1;
  if (PartsGrid.Enabled)and(length(part.code)>0) then
    while(j<PartsGrid.RowCount)and(not exists)do
      if PartsGrid.Objects[0,j]<>nil then begin
        ppart:=pointer(PartsGrid.Objects[0,j]);
        exists:=(ppart^.code=part.code);
        if not exists then inc(j);
      end else inc(j);
  if exists then begin
    //деталь есть - увеличиваем количество
    PartsGrid.Cells[2,j]:=FormatFloat('#####0.00',part.cnt+
      StrToFloatDef(PartsGrid.Cells[2,j],0));
    PartsGrid.Cells[3,j]:=FormatFloat('#####0.00',self.CalckPartsGridRow(j));
  end else begin
    //детали нет - добавляем
    if PartsGrid.Enabled then begin
      r:=PartsGrid.RowCount;
      PartsGrid.RowCount:=PartsGrid.RowCount+1;
    end else begin
      r:=1;
      PartsGrid.Enabled:=true;
    end;
    new(ppart);
    ppart^:=part;
    PartsGrid.Objects[0,r]:=TObject(ppart);
    PartsGrid.Cells[0,r]:=IntToStr(r);
    PartsGrid.Cells[1,r]:=part.descr;
    PartsGrid.Cells[2,r]:=FormatFloat('######.##',part.cnt);
    PartsGrid.Cells[3,r]:=FormatFloat('#####0.00',self.CalckPartsGridRow(r));
    PartsGrid.Cells[4,r]:=part.doc;    
  end;
  DelPartBtn.Enabled:=PartsGrid.Enabled;
  DelAllPartsBtn.Enabled:=PartsGrid.Enabled;
  PartsGrid.ColWidths[1]:=PartsGrid.ClientWidth-PartsGrid.ColWidths[0]-
    PartsGrid.ColWidths[2]-PartsGrid.ColWidths[3]-PartsGrid.ColWidths[4]-4;
end;

procedure TRecordEditorForm.AddPartsBtnClick(Sender: TObject);
var
  md,i,groupid   : integer;
  handinput      : boolean;
  parts          : TPartRecArray;
  onepart        : TPartRec;
  showsorry      : boolean;
begin
  handinput:=false;
  showsorry:=not PartsGrid.Enabled;
  md:=self.GetIndex(ModelCB,ModelED);
  if md>0 then begin
    groupid:=DataMod.PRODUCTIONMODELS.Lookup('ID',md,'PRODGROUP');
    groupid:=GetParts(PartsListFName,groupid,parts);
    if groupid>0 then for i := 0 to high(parts) do self.AddPartToGrid(parts[i])
      else if groupid<0 then begin
        handinput:=true;
        showsorry:=(groupid=-2)and(not PartsGrid.Enabled);
      end;
  end else begin
    if md=-1 then MessageBox(application.ActiveFormHandle,PChar('Необходимо указать модель продукции !'),
      PChar('Внимание !'),MB_ICONWARNING+MB_OK);
    if md=0 then handinput:=true;
  end;
  if (handinput)and(GetUnknownPart(onepart,showsorry))then self.AddPartToGrid(onepart);
end;

function  TRecordEditorForm.CalckPartsGridRow(row : integer):real;
var
  cnt   : real;
  ppart : ^TPartRec;
begin
  result:=0;
  if PartsGrid.Objects[0,row]<>nil then begin
    ppart:=pointer(PartsGrid.Objects[0,row]);
    cnt:=StrToFloatDef(PartsGrid.Cells[2,row],0);
    result:=cnt*ppart^.price;
  end;
end;

procedure TRecordEditorForm.DelAllPartsBtnClick(Sender: TObject);
var
  i : integer;
begin
  for i := 1 to PartsGrid.RowCount - 1 do
    if PartsGrid.Objects[0,i]<>nil then FreeMem(Pointer(PartsGrid.Objects[0,i]));
  PartsGrid.RowCount:=2;
  PartsGrid.Rows[1].Clear;
  PartsGrid.Enabled:=false;
  DelPartBtn.Enabled:=PartsGrid.Enabled;
  DelAllPartsBtn.Enabled:=PartsGrid.Enabled;
end;

procedure TRecordEditorForm.DelPartBtnClick(Sender: TObject);
var
  sel,i : integer;
begin
  if (PartsGrid.Enabled)and(PartsGrid.Selection.Top>0) then begin
    sel:=PartsGrid.Selection.Top;
    if PartsGrid.RowCount-1=1 then begin
      PartsGrid.Rows[1].Clear;
      PartsGrid.Enabled:=false;
      DelPartBtn.Enabled:=PartsGrid.Enabled;
      DelAllPartsBtn.Enabled:=PartsGrid.Enabled;
    end else begin
      for I := sel to PartsGrid.RowCount-2 do PartsGrid.Rows[i]:=PartsGrid.Rows[i+1];
      PartsGrid.RowCount:=PartsGrid.RowCount-1;
    end;
    self.RenumeredPartsGrid;
  end;
end;

procedure TRecordEditorForm.PartsGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if (ACol=2)or(ACol=4) then PartsGrid.Options:=PartsGrid.Options+[goEditing]
    else  PartsGrid.Options:=PartsGrid.Options-[goEditing];
end;

procedure TRecordEditorForm.PartsGridSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  PartsGrid.Cells[3,ARow]:=FormatFloat('#####0.00',self.CalckPartsGridRow(Arow));
end;

procedure TRecordEditorForm.RenumeredPartsGrid;
var
  i : integer;
begin
  if PartsGrid.Enabled then
    for I := 1 to PartsGrid.RowCount - 1 do
      PartsGrid.Cells[0,i]:=IntToStr(i);
end;

//------------------------- HINT------------------------------------------------

procedure TRecordEditorForm.ApplicationEvents1ShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
var
  y  : integer;
begin
  if hintinfo.HintControl.Name='PartsGrid' then begin
    y:=PartsGrid.MouseCoord(HintInfo.CursorPos.X,HintInfo.CursorPos.y).Y;
    if Y>0 then HintStr:=PartsGrid.Cells[1,Y];
  end;
end;

procedure TRecordEditorForm.Save(stat: integer);
var
  DBF : TDBF;
begin
  DBF:=TDBF.Create(application);
  DBF.Free;
end;

end.
