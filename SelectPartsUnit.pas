unit SelectPartsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, ComCtrls, ToolWin, ImgList, Buttons, Menus,
  ExtDlgs, DB, dbf, Grids, DBGrids, AppEvnts, ShellAPI, GraphUtil, DataUnit;

type
  //Тип данных для записи областей на схеме
  TArea=record
    Top, Left, Bottom, Right,Ind : integer;
  end;

  TSelectPartsForm = class(TForm)
    ScrollBox1: TScrollBox;
    TopPn: TPanel;
    InfoPn: TPanel;
    PartNameLB: TLabel;
    PartInfoLB: TLabel;
    PartBtnPN: TPanel;
    IncPrtQty: TSpeedButton;
    DecPrtQty: TSpeedButton;
    prtQtyLb: TLabel;
    AddToBskBtn: TSpeedButton;
    PartPriceLB: TLabel;
    ModListLb: TLabel;
    BsctPn: TPanel;
    Splitter: TSplitter;
    DBF: TDbf;
    ImgPn: TPanel;
    Image2: TImage;
    TopPB: TPaintBox;
    ButtonPn: TPanel;
    ShemeNameLB: TLabel;
    BsckTopPn: TPanel;
    Grid: TStringGrid;
    DelAllBtn: TSpeedButton;
    DelBtn: TSpeedButton;
    BsktTopPn: TPaintBox;
    Label1: TLabel;
    List: TListBox;
    PictureView: TSpeedButton;
    TableView: TSpeedButton;
    MstBtnPn: TPanel;
    DecMstbBTN: TSpeedButton;
    LoopIM: TImage;
    IncMstbBTN: TSpeedButton;
    Bevel1: TBevel;
    Panel1: TPanel;
    CancelBtn: TSpeedButton;
    OkBtn: TSpeedButton;
    Timer1: TTimer;
    CloseInfoPnBtn: TSpeedButton;
    NotItemBtn: TSpeedButton;
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetMstb;
    function  InArea(X,Y:integer):integer;
    procedure DrawSelection(Rct:TRect);
//    function  GetRct(StX,StY,X,Y:integer):TRect;
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IncMstbBTNClick(Sender: TObject);
    procedure DecMstbBTNClick(Sender: TObject);
    procedure DecPrtQtyClick(Sender: TObject);
    procedure IncPrtQtyClick(Sender: TObject);
    procedure AddToBskBtnClick(Sender: TObject);
    function  LoadFromFiles(basepath, modname : string):boolean;
    procedure TopPBPaint(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridResize;
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure GridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure CalculateCost(ARow : integer);
    procedure DelAllBtnClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure PopupInfoPn(X,Y : integer);
    procedure ChangeView (viewmode:integer);
    procedure ViewButtonsClick(Sender: TObject);
    procedure ListDblClick(Sender: TObject);
    procedure AddToGrid(code,name : string; cnt : integer);
    procedure ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CloseInfoPnBtnClick(Sender: TObject);
    procedure NotItemBtnClick(Sender: TObject);
    function  GetModelList:string;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetParts(fname : string; groupid : integer; var parts : TPartRecArray; const multisel : boolean=true):integer;

implementation


{$R *.dfm}

const
  pwPicture=1;
  pwTable=2;
  MaxPrtQty = 100;
  MaxGroupNum = 13;

var
  MInd, MaxW, MaxH : integer;// для вычисления масштаба
  LMD           : boolean;   // флаг нажатия левой кнопки мыши
  StX,StY,X0,Y0 : integer;   // для вычисления координат перемещения мыши
  // перечень переменных масштаба
  MstbArray     : array [0..7] of integer = (25,50,75,100,125,150,175,200);
  AreaList      : TList;     // список прямоугольников на рисунке
  MainPath      : string;    // каталог программы
  Image1        : TImage;    // буфер для хранения исходного изображения
  multiselect   : boolean=true; //флаг режима выбора нескольких элементов или только одного
  GroupNames    : array [1..MaxGroupNum] of string = ('WS30','WS35','WS40','WS50','WS60','WS65',
                  'WS70','WS80','WS85','WS65H','DH500','DVX31','DVX37');

function GetParts(fname : string; groupid : integer; var parts : TPartRecArray; const multisel : boolean=true):integer;
var
  Form : TSelectPartsForm;
  pstr : ^string;
  i    : integer;
begin
  result:=-2;
  if FileExists(fname) then begin
    form:=TSelectPartsForm.Create(application);
    with Form do begin
      //подключаемся к таблице
      DBF.TableName:=fname;
      DBF.Active:=true;
      DBF.IndexFieldNames:='NAME';
      //ищем наличия столбца, соответствующего группе
      i:=0;
      while(i<DBF.FieldCount)and(DBF.Fields[i].FieldName<>('GROUP'+inttostr(groupid)))do inc(i);
      //если стобец соответстуующий группе найден продолжаем подготовку формы
      if (i<DBF.FieldCount)and(DBF.Fields[i].FieldName=('GROUP'+inttostr(groupid))) then begin
        //фильтруем таблицу по столбцу, соответующему номеру группы
        DBF.Filter:='GROUP'+IntToStr(groupid)+'>0';
        DBF.Filtered:=true;
        //настраиваем режим выбора - один или несколько элементов
        multiselect:=multisel;
        BsctPn.Visible:=multiselect;
        Splitter.Visible:=multiselect;
        //устанавливаем заголовок в ооответствии с индексом группы
        case groupid of
          1..10 : ShemeNameLB.Caption:='Стиральная машина типа '+GroupNames[groupid];
          11..13 : ShemeNameLB.Caption:='Электросушилка типа '+GroupNames[groupid];
          else  ShemeNameLB.Caption:='Тип продукции не определен';
        end;
        //заранее заполняем таблицу
        List.Items.Clear;
        while not DBF.Eof do begin
          new(pstr);
          pstr^:=DBF.FieldByName('CODE').AsString;
          List.AddItem(DBF.FieldByName('NAME').AsString,TObject(pstr));
          DBF.Next;
        end;
        //если есть данные о схеме устанавливаем начальный вид pwPicture
        ButtonPn.Visible:=LoadFromFiles(ExtractFilePath(fname),'GROUP'+IntToStr(groupid));
        if ButtonPn.Visible then begin
          PictureView.Down:=true;
          ChangeView(pwPicture);
        end else ChangeView(pwTable);
        //вывод формы
        Width:=round(screen.Width*0.9);
        Height:=round(screen.Height*0.75);
        case ShowModal of
          mrOK : begin
                  SetLength(parts,0);
                  for i :=1 to grid.RowCount-1 do
                    if grid.Objects[0,i]<>nil then begin
                      SetLength(parts,high(parts)+2);
                      pstr:=pointer(grid.Objects[0,i]);
                      parts[high(parts)].code:=pstr^;
                      parts[high(parts)].descr:=grid.Cells[0,i];
                      parts[high(parts)].cnt:=StrToFloatDef(grid.Cells[1,i],0);
                      parts[high(parts)].price:=DBF.Lookup('CODE',pstr^,'PRICE');
                    end;
                  result:=high(parts)+1;
                 end;
          mrCancel : result:=0;
          mrNo     : result:=-1;
        end;
      end;
    end;
    form.Free;
  end;
end;

procedure TSelectPartsForm.FormCreate(Sender: TObject);
begin
  ImgPn.DoubleBuffered:=true;
  MainPath:=ExtractFilePath(application.ExeName);
  Grid.Cells[0,0]:='Наименование';
  Grid.Cells[1,0]:='Кол-во';
  Grid.Cells[2,0]:='Стоим';
  Image1:=TImage.Create(Application);
  AreaList:=TList.Create;
end;

procedure TSelectPartsForm.FormResize(Sender: TObject);
begin
  //Позиционирование рисунка и изменение масштаба скролинга
  if ScrollBox1.Visible then begin
    ScrollBox1.HorzScrollBar.Range:=ImgPn.Width;
    ScrollBox1.VertScrollBar.Range:=ImgPn.Height;
    if ImgPn.Width<ScrollBox1.Width then ImgPn.Left:=round((ScrollBox1.Width-ImgPn.Width)/2)
      else ImgPn.Left:=-ScrollBox1.HorzScrollBar.Position;
    if ImgPn.Height<ScrollBox1.Height then ImgPn.Top:=round((ScrollBox1.Height-ImgPn.Height)/2)
      else ImgPn.Top:=-ScrollBox1.VertScrollBar.Position;
  end;
  ButtonPn.Left:=Splitter.Left-ButtonPn.Width-30;
  self.GridResize;
end;

procedure TSelectPartsForm.CancelBtnClick(Sender: TObject);
begin
  Self.ModalResult:=mrCancel;
end;

procedure TSelectPartsForm.OkBtnClick(Sender: TObject);
begin
  self.ModalResult:=mrOk;
end;

procedure TSelectPartsForm.SplitterMoved(Sender: TObject);
begin
  ButtonPn.Left:=Splitter.Left-ButtonPn.Width-30;
  self.GridResize;
end;

function TSelectPartsForm.LoadFromFiles(basepath, modname: string):boolean;
var
  pitm : ^TArea;
  picfname, datafname : string;
  F : file of TArea;
begin
  picfname:=basepath+modname+'.bmp';
  datafname:=basepath+modname+'.idt';
  result:=false;
  if FileExists(picfname)and FileExists(datafname) then begin
    //Загрузка изображения в буфер
    Image1.AutoSize:=true;
    Image1.Picture.LoadFromFile(picfname);
    MaxH:=Image1.Height;
    MaxW:=Image1.Width;
    Image2.Picture:=Image1.Picture;
    //Загрузка данных
    AreaList.Clear;
    assignfile(f,datafname);
    reset(f);
    while (not Eof(F)) do begin
      new(pitm);
      read(f,pitm^);
      AreaList.Add(pitm);
    end;
    result:=true;
  end;
end;

procedure TSelectPartsForm.NotItemBtnClick(Sender: TObject);
begin
  self.ModalResult:=mrNo;
end;

procedure TSelectPartsForm.Timer1Timer(Sender: TObject);
{var
  pt : TPoint;}
begin
{  if InfoPn.Visible then begin
    GetCursorPos(pt);
    pt:=self.ScreenToClient(pt);
    if not((pt.X>InfoPn.Left)and(pt.X<(InfoPn.Left+InfoPn.Width))and
      (pt.Y>InfoPn.Top)and(pt.Y<(InfoPn.Top+InfoPn.Height)))then begin
        InfoPn.Visible:=false;
        Timer1.Enabled:=false;
      end;
  end;    }
end;

procedure TSelectPartsForm.TopPBPaint(Sender: TObject);
var
  rct : TRect;
begin
  rct:=rect(0,0,round((sender as TPaintBox).ClientWidth*0.5),(sender as TPaintBox).ClientHeight);
  GradientFillCanvas((sender as TPaintBox).Canvas,clBtnFace,clWhite,rct,gdHorizontal);
end;

//---------------------- события списка деталей --------------------------------

procedure TSelectPartsForm.ListDblClick(Sender: TObject);
var
  pstr : ^string;
begin
  if List.ItemIndex>=0 then begin
    pstr:=pointer(List.Items.Objects[List.ItemIndex]);
    if pstr<>nil then self.AddToGrid(pstr^,List.Items[List.ItemIndex],1);
  end;
end;

procedure TSelectPartsForm.ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt : TPoint;
  pstr : ^String;
  ind  : integer;
begin
  pt.X:=X;
  pt.Y:=Y;
  ind:=List.ItemAtPos(pt,true);
  if (button=mbRight)and(ind>=0) then begin
    List.ItemIndex:=ind;
    pstr:=pointer(List.Items.Objects[List.ItemIndex]);
    if pstr<>nil then begin
      DBF.Locate('CODE',pstr^,[]);
      GetCursorPos(pt);
      pt:=self.ScreenToClient(pt);
      self.PopupInfoPn(pt.X,pt.y);
    end;
  end;
end;

procedure TSelectPartsForm.ListMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if InfoPn.Visible then InfoPn.Visible:=false;  
end;

//-------------------------- изменение вида окна -------------------------------

procedure TSelectPartsForm.ChangeView(viewmode: Integer);
begin
  ScrollBox1.Visible:=(viewmode=pwPicture);
  MstBtnPN.Visible:=ScrollBox1.Visible;
  List.Visible:=(viewmode=pwTable);
  if (viewmode=pwPicture) then begin
    ScrollBox1.Align:=alClient;
    MInd:=1;
    self.SetMstb;
  end;
  if (viewmode=pwTable)then List.Align:=alClient;
  self.FormResize(self);
end;

procedure TSelectPartsForm.ViewButtonsClick(Sender: TObject);
begin
  if (sender as TSpeedButton).Name='PictureView' then
    self.ChangeView(pwPicture) else self.ChangeView(pwTable);
end;

//-------------------------- события таблицы выбора ----------------------------

procedure TSelectPartsForm.AddToGrid(code,name : string; cnt : integer);
var
  pstr   : ^string;
  i,ARow : integer;
  Exists : boolean;
begin
  i:=1;
  Exists:=false;
  while(i<Grid.RowCount)and(not Exists) do begin
    pstr:=pointer(Grid.Objects[0,i]);
    if (pstr<>nil)and(pstr^=code) then
      Exists:=true else inc(i);
  end;
  if Exists then begin
    Grid.Selection:=TGridRect(rect(0,i,0,i));
    Grid.Cells[1,i]:=FloatToStr(StrToFloatDef(Grid.Cells[1,i],0)+cnt);
    self.CalculateCost(i);
  end else begin
    if (not Grid.Enabled) then begin
      ARow:=1;
      Grid.Enabled:=true;
    end else begin
      ARow:=Grid.RowCount;
      Grid.RowCount:=Grid.RowCount+1;
    end;
    new(pstr);
    pstr^:= code;
    Grid.Objects[0,ARow]:=TObject(pstr);
    Grid.Cells[0,ARow]:= name;
    Grid.Cells[1,ARow]:= IntToStr(cnt);
    self.CalculateCost(ARow);
    if not multiselect then self.ModalResult:=mrOk;
  end;
  DelBtn.Enabled:=true;
  DelAllBtn.Enabled:=true;
end;

procedure TSelectPartsForm.DelAllBtnClick(Sender: TObject);
var
  i : integer;
begin
  for I := 1 to Grid.RowCount - 1 do
    if Grid.Objects[0,i]<>nil then FreeMem(pointer(Grid.Objects[0,i]));
  Grid.RowCount:=2;
  Grid.Rows[1].Clear;
  Grid.Enabled:=false;
end;

procedure TSelectPartsForm.DelBtnClick(Sender: TObject);
var
  sel,i : integer;
begin
  if (Grid.Enabled)and(Grid.Selection.Top>0) then begin
    sel:=Grid.Selection.Top;
    if Grid.RowCount-1=1 then begin
      Grid.Rows[1].Clear;
      Grid.Enabled:=false;
      DelBtn.Enabled:=false;
      DelAllBtn.Enabled:=false;
    end else begin
      for I := sel to Grid.RowCount-2 do Grid.Rows[i]:=Grid.Rows[i+1];
      Grid.RowCount:=Grid.RowCount-1;
    end;
  end;
end;

procedure TSelectPartsForm.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  rct      : TRect;
  Aligment : cardinal;
  txt      : string;
  hg       : integer;
begin
  rct:=rect;
  Grid.Canvas.FillRect(rct);
  txt:=Grid.Cells[Acol,Arow];
  Aligment:=DT_LEFT;
  if ARow=0 then Aligment:=DT_CENTER else
    case ACol of
      0   : Aligment:=DT_LEFT or DT_WORDBREAK;
      1,2 : Aligment:=DT_RIGHT;
    end;
  inc(rct.Left,2); dec(rct.Right,2);
  inc(rct.Top,2);  dec(rct.Bottom,2);
  hg:=DrawText(Grid.Canvas.Handle,pchar(txt),Length(txt),rct,Aligment);
  if hg+4>Grid.RowHeights[ARow] then Grid.RowHeights[ARow]:=hg+4;
end;

procedure TSelectPartsForm.GridKeyPress(Sender: TObject; var Key: Char);
var
  txt : string;
begin
  if Grid.Selection.Top>0 then begin
    txt:=Grid.Cells[0,Grid.Selection.Top];
    case Key of
      '0'..'9', #8,#13 : ;
      ','          : if Pos(',',txt)>0 then Key := #0;
      else Key:= #0;
    end;
  end;
end;

procedure TSelectPartsForm.GridResize;
begin
  Grid.ColWidths[0]:=Grid.ClientWidth-Grid.ColWidths[1]-Grid.ColWidths[2]-4;
end;

procedure TSelectPartsForm.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ACol=1 then Grid.Options:=Grid.Options+[goEditing] else Grid.Options:=Grid.Options-[goEditing];
end;

procedure TSelectPartsForm.CalculateCost(ARow : integer);
var
  pstr  : ^string;
  res   : real;
  price : variant;
begin
  pstr:=pointer(Grid.Objects[0,ARow]);
  if pstr<>nil then begin
    price:=DBF.Lookup('CODE',pstr^,'PRICE');
    res:=StrToFloatDef(Grid.Cells[1,ARow],0);
    if price<>NULL then res:=res*price else res:=0;
  end else res:=0;
  Grid.Cells[2,ARow]:=FormatFloat('####0.00',res);
end;

procedure TSelectPartsForm.GridSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  self.CalculateCost(ARow);
end;

//-------------------- установка масштаба -------------------------------------

procedure TSelectPartsForm.SetMstb;
begin
  if self.InfoPn.Visible then self.InfoPn.Visible:=false;
  //Изменение масштаба изображения и размеров компонента
  ImgPn.Height:=round(MaxH*MstbArray[Mind]/100);
  ImgPn.Width:=round(MaxW*MstbArray[Mind]/100);
  //Позиционирование рисунка и изменение масштаба скролинга
  ScrollBox1.HorzScrollBar.Range:=ImgPn.Width;
  ScrollBox1.VertScrollBar.Range:=ImgPn.Height;
  if ImgPn.Width<ScrollBox1.Width then ImgPn.Left:=round((ScrollBox1.Width-ImgPn.Width)/2)
    else ImgPn.Left:=-ScrollBox1.HorzScrollBar.Position;
  if ImgPn.Height<ScrollBox1.Height then ImgPn.Top:=round((ScrollBox1.Height-ImgPn.Height)/2)
    else ImgPn.Top:=-ScrollBox1.VertScrollBar.Position;
end;

procedure TSelectPartsForm.DecMstbBTNClick(Sender: TObject);
begin
  if (MInd>0) then begin
    dec(MInd);
    self.SetMstb;
  end;
end;

procedure TSelectPartsForm.IncMstbBTNClick(Sender: TObject);
begin
  if (MInd<high(MstbArray)) then begin
    inc(MInd);
    self.SetMstb;
  end;
end;

//------------------- панель информации о детали -------------------------------

function TSelectPartsForm.GetModelList:string;
var
  i,j : integer;
  str : string;
begin
  result:='';
  for I := 0 to DBF.FieldCount - 1 do
    if pos('GROUP',DBF.Fields[i].FieldName)=1 then
      if DBF.FieldByName(DBF.Fields[i].FieldName).AsFloat>0 then begin
        str:=DBF.Fields[i].FieldName;
        str:=copy(str,6,maxint);
        j:=strtointdef(str,0);
        if (j>0)and(j<=MaxGroupNum) then result:=result+GroupNames[j]+', ';
      end;
  result:=copy(result,1,length(result)-2);
end;

procedure TSelectPartsForm.PopupInfoPn(X,Y: integer);
var
  j : integer;
  price : real;
begin
  InfoPn.Top:=Y-10;
  InfoPn.Left:=X-10;
  if (InfoPn.Left+InfoPn.Width)>self.ClientWidth then
    InfoPn.Left:=self.ClientWidth-InfoPn.Width-10;
  if (InfoPn.Top+InfoPn.Height)>self.ClientHeight then
    InfoPn.Top:=self.ClientHeight-InfoPn.Height-10;
  PrtQtyLb.Caption:='0';
  DecPrtQty.Enabled:=(StrToInt(PrtQtyLb.Caption)>0);
  //установка информации в панели
  PartNameLB.Caption:=DBF.FieldByName('NAME').AsString;
  price:=DBF.FieldByName('PRICE').AsFloat;
  if price=0 then PartPriceLb.Caption:='цена не задана' else
    PartPriceLb.Caption:=FormatFloat('####0.00',price)+' руб';
  ModListLb.Caption:='Использование : '+GetModelList;
  PartInfoLb.Caption:=DBF.FieldByName('NOTE').AsString;
  //настройка кнопок панели ввода количества
  j:=1;
  PrtQtyLb.Caption:=IntToStr(j);
  AddToBskBtn.Enabled:=(j<MaxPrtQty)and(j>0);
  IncPrtQty.Enabled:=(j<MaxPrtQty);
  DecPrtQty.Enabled:=(j>0);
  PartBtnPn.Visible:=true;
  InfoPn.Visible:=true;
  Timer1.Enabled:=true;
end;

procedure TSelectPartsForm.DecPrtQtyClick(Sender: TObject);
var
  i : integer;
begin
  i:=StrToInt(PrtQtyLb.Caption);
  if (i>1) then begin
    dec(i);
    PrtQtyLb.Caption:=IntTostr(i);
    AddToBskBtn.Enabled:=(i>0);
    DecPrtQty.Enabled:=(i>0);
    if IncPrtQty.Enabled=false then IncPrtQty.Enabled:=true;
  end;
end;

procedure TSelectPartsForm.IncPrtQtyClick(Sender: TObject);
var
  i : integer;
begin
  i:=StrToInt(PrtQtyLb.Caption);
  if (i<MaxPrtQty) then begin
    inc(i);
    PrtQtyLb.Caption:=IntTostr(i);
    AddToBskBtn.Enabled:=(i<MaxPrtQty);
    IncPrtQty.Enabled:=(i<MaxPrtQty);
    if DecPrtQty.Enabled=false then DecPrtQty.Enabled:=true;
  end;
end;

procedure TSelectPartsForm.AddToBskBtnClick(Sender: TObject);
begin
  self.AddToGrid(DBF.FieldByName('CODE').AsString,DBF.FieldByName('NAME').AsString,
    StrToIntDef(PrtQtyLb.Caption,0));
end;

procedure TSelectPartsForm.CloseInfoPnBtnClick(Sender: TObject);
begin
  self.InfoPn.Visible:=false;
end;


//------------------ события рисунка -------------------------------------------

procedure TSelectPartsForm.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor:=crSizeall;
  LMD:=true;
  StX:=X;
  StY:=Y;
  X0:=X;
  Y0:=Y;
end;

procedure TSelectPartsForm.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i     : integer;
  Itm   : TArea;
  pt    : Tpoint;
  code  : string;
begin
    //Сдвиг изображения
    if (LMD) then begin
      if (ScrollBox1.HorzScrollBar.Position-(X-StX)>0)and(ScrollBox1.HorzScrollBar.Position-(X-StX)<ScrollBox1.HorzScrollBar.Range) then
      ScrollBox1.HorzScrollBar.Position:=ScrollBox1.HorzScrollBar.Position-(X-StX);
      if (ScrollBox1.VertScrollBar.Position-(Y-StY)>0)and(ScrollBox1.VertScrollBar.Position-(Y-StY)<ScrollBox1.VertScrollBar.Range) then
      ScrollBox1.VertScrollBar.Position:=ScrollBox1.VertScrollBar.Position-(Y-StY);
      Image2.Update;
    end else begin
      //Проверка нахождения над записанной областью
      i:=InArea(X*100 div MstbArray[Mind],Y*100 div MstbArray[Mind]);
      if i>=0 then begin
        Image2.Cursor:=crHandPoint;
        if i<>InArea(X0*100 div MstbArray[Mind],Y0*100 div MstbArray[Mind]) then begin
              Itm:=TArea(AreaList[i]^);
              code:=FormatFloat('Ц0000000',itm.Ind);
              if DBF.Locate('CODE',code,[]) then begin
                if Image2.Picture<>Image1.Picture then Image2.Picture:=Image1.Picture;
                self.DrawSelection(Rect(Itm.Left,Itm.Top,Itm.Right,Itm.Bottom));
                //показ информационной панели
                if (not InfoPn.Visible)or((InfoPn.Visible)and(InfoPn.Tag<>Itm.Ind)) then begin
                  GetCursorPos(pt);
                  pt:=self.ScreenToClient(pt);
                  self.PopupInfoPn(pt.X,pt.Y);
                  InfoPn.Tag:=Itm.Ind;
                end;
              end;
            end;
        end else begin
          Image2.Cursor:=crDefault;
          if Image2.Picture<>Image1.Picture then Image2.Picture:=Image1.Picture;
          if InfoPn.Visible then InfoPn.Visible:=false;
        end;
      X0:=X;
      Y0:=Y;
    end;
end;

procedure TSelectPartsForm.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor:=crDefault;
  if LMD then LMD:=false;
end;

function TSelectPartsForm.InArea(X: Integer; Y: Integer):integer;
var
  i,res : integer;
  Itm   : TArea;
begin
  res:=-1;
  for I := 0 to AreaList.Count - 1 do begin
    Itm:=TArea(AreaList[i]^);
    if((X<Itm.Right)and(X>Itm.Left)and(Y<Itm.Bottom)and(Y>Itm.Top))then res:=i;
  end;
  result:=res;
end;

procedure TSelectPartsForm.DrawSelection(Rct: TRect);
var
  Rct1:TRect;
begin
  //Рисуем тень
  Image2.Canvas.Pen.Width:=3;
  Image2.Canvas.Pen.Color:=clMedGray;
  Image2.Canvas.Rectangle(Rct);
  //Сдвигаем изображение исходной области
  Rct1.Left:=Rct.Left-2;
  Rct1.Top:=Rct.Top-2;
  Rct1.Bottom:=Rct.Bottom-2;
  Rct1.Right:=Rct.Right-2;
  Image2.Canvas.Pen.Width:=2;
  Image2.Canvas.Pen.Color:=clRed;
  Image2.Canvas.CopyRect(Rct1,Image1.Canvas,Rct);
  //Рисуем рамку
  Image2.Canvas.MoveTo(Rct1.Left,Rct1.Top);
  Image2.Canvas.LineTo(Rct1.Left,Rct1.Bottom);
  Image2.Canvas.LineTo(Rct1.Right,Rct1.Bottom);
  Image2.Canvas.LineTo(Rct1.Right,Rct1.Top);
  Image2.Canvas.LineTo(Rct1.Left,Rct1.Top);
end;

end.
