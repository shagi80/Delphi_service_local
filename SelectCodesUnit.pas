unit SelectCodesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, ComCtrls, ToolWin, ImgList, Buttons, Menus,
  ExtDlgs, DB, dbf, Grids, DBGrids, AppEvnts, ShellAPI, GraphUtil;

type
  TSelectCodesForm = class(TForm)
    ButtomPn: TPanel;
    LeftPn: TPanel;
    Splitter1: TSplitter;
    ClientPn: TPanel;
    FolderLV: TListView;
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    LeftLb: TLabel;
    Panel2: TPanel;
    PaintBox2: TPaintBox;
    Label1: TLabel;
    Table: TDbf;
    DataSource1: TDataSource;
    Grid: TDBGrid;
    TableID: TIntegerField;
    TableDESCR: TStringField;
    TableMAINTYPE: TIntegerField;
    TableFOLDER: TStringField;
    TableISFOLDER: TBooleanField;
    TablePRICEID: TIntegerField;
    OkBtn: TSpeedButton;
    CloseBtn: TSpeedButton;
    TableCODE: TStringField;
    TablePRICE: TFloatField;
    TablePRICEDESCR: TStringField;
    procedure PaintBox1Paint(Sender: TObject);
    procedure UpdateGrid(folder : string);
    procedure FolderLVSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ResizeGrid;
    procedure FormShow(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure TableCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    maintype  : integer;
  public
    { Public declarations }
  end;

function  GetCode(fname : string; mt : integer; const selcode : string=''):  string;

implementation

{$R *.dfm}

uses DataUnit;

function  GetCode(fname : string; mt : integer; const selcode : string=''):  string;
var
  Form : TSelectCodesForm;
  itm  : TListItem;
  pstr : ^string;
  frst : string;
begin
  result:='';
  form:=TSelectCodesForm.Create(application);
  with form do begin
    Width:=round(screen.Width*0.7);
    Height:=round(screen.Height*0.7);
    Table.TableName:=fname;
    Table.IndexFieldNames:='FOLDER, DESCR';
    maintype:=mt;
    if maintype>0 then begin
      Table.Filter:='MAINTYPE='+IntToStr(maintype)+' AND ISFOLDER';
      Table.Filtered:=true;
    end;
    Table.Active:=true;
    {if Table.IsEmpty then begin
      frst:='Для этого типа продукции нет определенных кодов.'+chr(13);
      frst:=frst+'Пожалуйста, самостоятельно введите описание неисправности самостоятельно';
      frst:=frst+' в поле дополнительной информации !';
      MessageBox(handle, PChar(frst),PChar('Внимание!'), MB_ICONWARNING+MB_OK);
      Abort;
    end; }
    //Заполнение категорий
    new(pstr);
    pstr^:='';
    itm:=FolderLV.Items.Add;;
    itm.Caption:='Общие коды';
    itm.Data:=pstr;
    frst:=Table.FieldByName('FOLDER').AsString;
    while not Table.Eof do begin
      new(pstr);
      pstr^:=Table.FieldByName('FOLDER').AsString;
      itm:=FolderLV.Items.Add;;
      itm.Caption:=Table.FieldByName('FOLDER').AsString+' - '+Table.FieldByName('DESCR').AsString;
      itm.Data:=pstr;
      Table.Next;
    end;
    Table.Filtered:=false;
    if (Length(selcode)>0)and(Table.Lookup('CODE',selcode,'FOLDER')<>NULL)
       then frst:=Table.Lookup('CODE',selcode,'FOLDER');
    UpdateGrid(frst);
    if ShowModal=mrOk then result:=table.FieldByName('CODE').AsString+'='+
      table.FieldByName('DESCR').AsString+'='+table.FieldByName('PRICE').AsString;
  end;
  form.Free;
end;

procedure TSelectCodesForm.UpdateGrid(folder : string);
begin
  Table.Filtered:=false;
  if (maintype=0)or(Length(folder)=0) then Table.Filter:='FOLDER='+QuotedStr(folder)+' AND NOT ISFOLDER'
    else Table.Filter:='MAINTYPE='+IntToStr(maintype)+' AND FOLDER='+QuotedStr(folder)+' AND NOT ISFOLDER';
  Table.Filtered:=true;
  Table.First;
end;

procedure TSelectCodesForm.FolderLVSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  pstr : ^string;
begin
  pstr:=Item.Data;
  UpdateGrid(pstr^);
end;

//----------------- события формы и кнопок -------------------------------------

procedure TSelectCodesForm.FormShow(Sender: TObject);
begin
  ResizeGrid;
end;

procedure TSelectCodesForm.OkBtnClick(Sender: TObject);
begin
  self.ModalResult:=mrOk;
end;

procedure TSelectCodesForm.CloseBtnClick(Sender: TObject);
begin
  self.ModalResult:=mrCancel;
end;

procedure TSelectCodesForm.PaintBox1Paint(Sender: TObject);
var
  rct : TRect;
begin
  rct:=rect(0,0,round((sender as TPaintBox).ClientWidth*0.75),(sender as TPaintBox).ClientHeight);
  GradientFillCanvas((sender as TPaintBox).Canvas,clBtnFace,clWhite,rct,gdHorizontal);
end;

procedure TSelectCodesForm.ResizeGrid;
begin
  Grid.Columns.Items[1].Width:=Grid.ClientWidth-Grid.Columns.Items[0].Width-
    Grid.Columns.Items[2].Width-Grid.Columns.Items[3].Width-10;
end;

procedure TSelectCodesForm.TableCalcFields(DataSet: TDataSet);
begin
  if DataMod.SERVPRICE.Locate('MAINTYPEID;PRICETYPE',
      VarArrayOf([DataSet.FieldByName('MAINTYPE').AsInteger,
        DataSet.FieldByName('PRICEID').AsInteger]),[]) then begin
          DataSet.FieldByName('PRICE').AsFloat:=DataMod.SERVPRICE.FieldByName('PRICE').AsFloat;
          DataSet.FieldByName('PRICEDESCR').AsString:=DataMod.SERVPRICE.FieldByName('DESCR').AsString;
        end else begin
          DataSet.FieldByName('PRICE').AsVariant:=null;
          DataSet.FieldByName('PRICEDESCR').AsVariant:=null;
        end;
end;

end.
