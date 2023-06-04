program Project1;

uses
  Forms,
  RecordEditprUnit in 'RecordEditprUnit.pas' {RecordEditorForm},
  DataUnit in 'DataUnit.pas' {DataMod: TDataModule},
  SelectCodesUnit in 'SelectCodesUnit.pas' {SelectCodesForm},
  SelectPartsUnit in 'SelectPartsUnit.pas' {SelectPartsForm},
  UnknownPartEditUnit in 'UnknownPartEditUnit.pas' {UnknownPartEditForm},
  ReportUnit in 'ReportUnit.pas' {ReportForm},
  MonthWin in 'MonthWin.pas' {MonthDLG};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'RENOVA report';
  Application.CreateForm(TDataMod, DataMod);
  Application.CreateForm(TReportForm, ReportForm);
  Application.Run;
end.
