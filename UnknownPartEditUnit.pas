unit UnknownPartEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DataUnit, ExtCtrls;

type
  TUnknownPartEditForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    CodeED: TEdit;
    Label2: TLabel;
    DescrED: TEdit;
    Label4: TLabel;
    PriceED: TEdit;
    Label3: TLabel;
    CntED: TEdit;
    OkBtn: TSpeedButton;
    CloseBtn: TSpeedButton;
    SorryLB: TLabel;
    Label5: TLabel;
    DocED: TEdit;
    procedure CloseBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure PriceEDKeyPress(Sender: TObject; var Key: Char);
    procedure SetEcitEnabled(Sender: TObject; enbl : boolean);
    procedure CodeEDEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetUnknownPart(var part : TPartRec; const showsorry : boolean=false):boolean;

implementation

{$R *.dfm}

function GetUnknownPart(var part : TPartRec; const showsorry : boolean=false):boolean;
var
  form : TUnknownPartEditForm;
begin
  form:=TUnknownPartEditForm.Create(application);
  result:=false;
  form.SorryLB.Visible:=showsorry;
  if form.ShowModal=mrOK then with form do begin
    part.code:=CodeED.Text;
    part.descr:=DescrED.Text;
    part.cnt:=StrToFloatDef(CntED.Text,0);
    part.price:=StrToFloatDef(PriceED.Text,0);
    part.doc:=DocED.Text;
    result:=true;
  end;
  form.Free;
end;

procedure TUnknownPartEditForm.SetEcitEnabled(Sender: TObject; enbl : boolean);
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
  end;
end;

procedure TUnknownPartEditForm.CloseBtnClick(Sender: TObject);
begin
  self.ModalResult:=mrCancel;
end;

procedure TUnknownPartEditForm.CodeEDEnter(Sender: TObject);
begin
  self.SetEcitEnabled(sender,true);
end;

procedure TUnknownPartEditForm.PriceEDKeyPress(Sender: TObject; var Key: Char);
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

procedure TUnknownPartEditForm.OkBtnClick(Sender: TObject);
begin
  if (length(DescrED.Text)>0)and(StrToFloatDef(CntED.Text,0)>0) then
    self.ModalResult:=mrOk else MessageBox(self.Handle,PChar('Проверьте заполнение формы !'+chr(13)+
      'Поле "Наименование" должно быть заполнено.'+chr(13)+
      'Значение в поле "Количество" должно быть больше нуля.'),PChar('Внимание !'),MB_ICONWARNING+MB_OK);

end;

end.
