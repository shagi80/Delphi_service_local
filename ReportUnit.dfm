object ReportForm: TReportForm
  Left = 0
  Top = 0
  Caption = 'ReportForm'
  ClientHeight = 472
  ClientWidth = 795
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 32
    Width = 795
    Height = 120
    Align = alTop
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Visible = False
  end
  object BtmPn: TPanel
    Left = 0
    Top = 442
    Width = 795
    Height = 30
    Align = alBottom
    TabOrder = 1
    object UserNameLB: TLabel
      AlignWithMargins = True
      Left = 11
      Top = 4
      Width = 60
      Height = 13
      Margins.Left = 10
      Margins.Right = 10
      Align = alLeft
      Caption = 'UserNameLB'
      Layout = tlCenter
    end
    object ResultLb: TLabel
      AlignWithMargins = True
      Left = 557
      Top = 4
      Width = 32
      Height = 16
      Margins.Left = 10
      Margins.Right = 10
      Align = alClient
      Alignment = taRightJustify
      Caption = 'result'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object ScalePn: TPanel
      Left = 599
      Top = 1
      Width = 195
      Height = 28
      Align = alRight
      AutoSize = True
      TabOrder = 0
      object ScaleLB: TLabel
        AlignWithMargins = True
        Left = 155
        Top = 4
        Width = 29
        Height = 13
        Margins.Right = 10
        Align = alRight
        Caption = '100%'
        Layout = tlCenter
      end
      object DecScaleLB: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 20
        Height = 20
        Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1084#1072#1089#1096#1090#1072#1073#1072
        Align = alRight
        Alignment = taCenter
        AutoSize = False
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        OnClick = IncScaleLBClick
      end
      object IncScaleLB: TLabel
        AlignWithMargins = True
        Left = 129
        Top = 4
        Width = 20
        Height = 20
        Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1084#1072#1089#1096#1090#1072#1073#1072
        Align = alRight
        Alignment = taCenter
        AutoSize = False
        Caption = '+'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        OnClick = IncScaleLBClick
      end
      object ScaleTB: TTrackBar
        AlignWithMargins = True
        Left = 30
        Top = 4
        Width = 93
        Height = 20
        Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1084#1072#1089#1096#1090#1072#1073#1072
        Align = alRight
        Max = 200
        Min = 25
        Frequency = 25
        Position = 100
        ShowSelRange = False
        TabOrder = 0
        TickStyle = tsNone
        OnChange = IncScaleLBClick
      end
    end
  end
  object TopPn: TPanel
    Left = 0
    Top = 0
    Width = 795
    Height = 32
    Align = alTop
    AutoSize = True
    TabOrder = 2
    object ControlBar1: TControlBar
      Left = 1
      Top = 1
      Width = 793
      Height = 30
      Align = alTop
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object ToolBar1: TToolBar
        Left = 11
        Top = 2
        Width = 326
        Height = 22
        Caption = 'ToolBar1'
        Images = DataMod.SmallImgs
        TabOrder = 0
        object ToolButton4: TToolButton
          Left = 0
          Top = 0
          Action = NewReport
        end
        object ToolButton7: TToolButton
          Left = 23
          Top = 0
          Action = Open
        end
        object ToolButton6: TToolButton
          Left = 46
          Top = 0
          Action = Save
        end
        object ToolButton5: TToolButton
          Left = 69
          Top = 0
          Width = 8
          Caption = 'ToolButton5'
          ImageIndex = 8
          Style = tbsSeparator
        end
        object ToolButton8: TToolButton
          Left = 77
          Top = 0
          Action = PrintReport
        end
        object ToolButton9: TToolButton
          Left = 100
          Top = 0
          Width = 8
          Caption = 'ToolButton9'
          ImageIndex = 14
          Style = tbsSeparator
        end
        object ToolButton1: TToolButton
          Left = 108
          Top = 0
          Action = NewRecord
        end
        object ToolButton3: TToolButton
          Left = 131
          Top = 0
          Action = EditRecord
        end
        object ToolButton12: TToolButton
          Left = 154
          Top = 0
          Action = CopyRecord
        end
        object ToolButton2: TToolButton
          Left = 177
          Top = 0
          Action = DelRecord
        end
        object ToolButton10: TToolButton
          Left = 200
          Top = 0
          Width = 8
          Caption = 'ToolButton10'
          ImageIndex = 14
          Style = tbsSeparator
        end
        object RowSizingBtn: TToolButton
          Left = 208
          Top = 0
          AllowAllUp = True
          Caption = 'RowSizingBtn'
          ImageIndex = 13
          Style = tbsCheck
          OnClick = RowSizingBtnClick
        end
        object PaintErrorsBtn: TToolButton
          Left = 231
          Top = 0
          Hint = #1042#1099#1076#1077#1083#1103#1090#1100' '#1086#1096#1080#1073#1082#1080' '#1094#1074#1077#1090#1086#1084
          Caption = 'PaintErrorsBtn'
          ImageIndex = 15
          Style = tbsCheck
          OnClick = PaintErrorsBtnClick
        end
        object ToolButton11: TToolButton
          Left = 254
          Top = 0
          Width = 8
          Caption = 'ToolButton11'
          ImageIndex = 16
          Style = tbsSeparator
        end
        object ExportODSBtn: TToolButton
          Tag = 2
          Left = 262
          Top = 0
          Hint = #1069#1082#1089#1087#1086#1088#1090' '#1074' '#1090#1072#1073#1083#1080#1094#1091' ODF (*.ods)'
          Caption = 'ExportODSBtn'
          ImageIndex = 16
          OnClick = ExportReport
        end
        object ExportXLSBtn: TToolButton
          Tag = 1
          Left = 285
          Top = 0
          Hint = #1069#1082#1089#1087#1086#1088#1090' '#1074' '#1090#1072#1073#1083#1080#1094#1091' Excel (*.xls)'
          Caption = 'ExportXLSBtn'
          ImageIndex = 18
          OnClick = ExportReport
        end
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = DataMod.ReportDBF
    Left = 40
    Top = 32
  end
  object MainMenu: TMainMenu
    Left = 696
    Top = 16
    object N1: TMenuItem
      Caption = '&'#1054#1090#1095#1077#1090
      Hint = '&'#1056#1072#1073#1086#1090#1072' '#1089' '#1086#1090#1095#1077#1090#1086#1084
      OnClick = N1Click
      object N2: TMenuItem
        Action = NewReport
        Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1086#1090#1095#1077#1090
      end
      object N3: TMenuItem
        Action = Open
        Hint = #1054#1090#1082#1088#1099#1090#1100' '#1086#1090#1095#1077#1090' '#1080#1079' '#1092#1072#1081#1083#1072
      end
      object ReopenMI: TMenuItem
        AutoHotkeys = maManual
        Caption = #1053#1077#1076#1072#1074#1085#1080#1077' '#1086#1090#1095#1077#1090#1099
        Hint = #1054#1090#1082#1088#1099#1090#1100' '#1086#1076#1080#1085#1080' '#1080#1079' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1093' '#1086#1090#1095#1077#1090#1086#1074
        Visible = False
        OnClick = ReopenMIClick
        object none1: TMenuItem
          Caption = '{none}'
        end
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Action = Save
      end
      object N5: TMenuItem
        Action = SaveAs
        Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1086#1090#1095#1077#1090' '#1089' '#1085#1086#1074#1099#1084' '#1080#1084#1077#1085#1077#1084
      end
      object N13: TMenuItem
        Action = CloseReport
        Hint = #1047#1072#1082#1088#1099#1090#1100' '#1086#1090#1095#1077#1090
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object ExportMI: TMenuItem
        Caption = #1069#1082#1089#1087#1086#1088#1090
        Hint = #1069#1082#1089#1087#1086#1088#1090' '#1074' '#1076#1088#1091#1075#1086#1081' '#1092#1086#1088#1084#1072#1090
        object Ecxel1: TMenuItem
          Tag = 1
          Caption = #1090#1072#1073#1083#1080#1094#1072' Excel (*.xls)'
          OnClick = ExportReport
        end
        object DFods1: TMenuItem
          Tag = 2
          Caption = #1090#1072#1073#1083#1080#1094#1072' '#1054'DF (*.ods)'
          OnClick = ExportReport
        end
        object ODFodt1: TMenuItem
          Tag = 3
          Caption = #1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1090#1072' ODF (*.odt)'
          OnClick = ExportReport
        end
        object PDFpdf1: TMenuItem
          Tag = 4
          Caption = #1076#1086#1082#1091#1084#1077#1085#1090' PDF (*.pdf)'
          OnClick = ExportReport
        end
      end
      object EmailMI: TMenuItem
        Tag = 5
        Caption = #1054#1090#1087#1088#1072#1074#1090#1100' '#1087#1086' e-mail'
        Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1086' e-mail '#1082#1072#1082' '#1074#1083#1086#1078#1077#1085#1080#1077
        Visible = False
        OnClick = ExportReport
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object SaveReadyRepMI: TMenuItem
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1085#1072' '#1087#1088#1086#1074#1077#1088#1082#1091
        OnClick = SaveReadyRepMIClick
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object N7: TMenuItem
        Action = CloseApp
      end
    end
    object N9: TMenuItem
      Caption = '&'#1056#1077#1084#1086#1085#1090
      Hint = #1056#1072#1073#1086#1090#1072' '#1089' '#1088#1077#1084#1086#1085#1090#1072#1084
      object N10: TMenuItem
        Action = NewRecord
        Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1088#1077#1084#1086#1085#1090
      end
      object N16: TMenuItem
        Action = CopyRecord
      end
      object N11: TMenuItem
        Action = EditRecord
        Hint = #1048#1079#1084#1077#1085#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1088#1077#1084#1086#1085#1090#1077
      end
      object N12: TMenuItem
        Action = DelRecord
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1088#1077#1084#1086#1085#1090
      end
    end
    object ViewSetMI: TMenuItem
      Caption = #1042#1080#1076
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1074#1085#1077#1096#1085#1077#1075#1086' '#1074#1080#1076#1072' '#1090#1072#1073#1080#1083#1094#1099
      object RowSizingMI: TMenuItem
        Caption = #1055#1086#1076#1073#1086#1088#1072#1090#1100' '#1074#1099#1089#1086#1090#1091' '#1089#1090#1088#1086#1082
        Hint = #1055#1086#1076#1073#1086#1088' '#1074#1099#1089#1086#1090#1099' '#1089#1090#1088#1086#1082' '#1087#1086' '#1076#1083#1080#1085#1077' '#1090#1077#1082#1089#1090#1072
        OnClick = RowSizingBtnClick
      end
      object PaintErrorsMI: TMenuItem
        Caption = #1055#1086#1076#1089#1074#1077#1095#1080#1074#1072#1090#1100' '#1086#1096#1080#1073#1082#1080
        Hint = #1042#1099#1076#1077#1083#1103#1090#1100' '#1086#1096#1080#1073#1082#1080' '#1094#1074#1077#1090#1086#1084
        OnClick = PaintErrorsBtnClick
      end
      object N15: TMenuItem
        Caption = #1052#1072#1089#1096#1090#1072#1073
        Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1084#1072#1089#1096#1090#1072#1073#1072' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103' '
        object IncScaleMI: TMenuItem
          Caption = #1059#1074#1077#1083#1080#1095#1080#1090#1100' '
          Hint = #1059#1074#1083#1077#1080#1095#1080#1090#1100' '#1084#1072#1089#1096#1090#1072#1073
          OnClick = IncScaleLBClick
        end
        object DecScaleMI: TMenuItem
          Caption = #1059#1084#1077#1085#1100#1096#1080#1090#1100
          Hint = #1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1084#1072#1089#1096#1090#1072#1073
          OnClick = IncScaleLBClick
        end
        object N14: TMenuItem
          Caption = '-'
        end
        object N251: TMenuItem
          Tag = 25
          Caption = '25%'
          Hint = #1052#1072#1089#1096#1090#1072#1073' 25%'
          OnClick = IncScaleLBClick
        end
        object N501: TMenuItem
          Tag = 50
          Caption = '50%'
          Hint = #1052#1072#1089#1096#1090#1072#1073' 50%'
          OnClick = IncScaleLBClick
        end
        object N1001: TMenuItem
          Tag = 100
          Caption = '100%'
          Hint = #1052#1072#1089#1096#1090#1072#1073' 100%'
          OnClick = IncScaleLBClick
        end
        object N1251: TMenuItem
          Tag = 125
          Caption = '125%'
          Hint = #1052#1072#1089#1096#1090#1072#1073' 125%'
          OnClick = IncScaleLBClick
        end
        object N1501: TMenuItem
          Tag = 150
          Caption = '150%'
          Hint = #1052#1072#1089#1096#1090#1072#1073' 150%'
          OnClick = IncScaleLBClick
        end
      end
    end
  end
  object ActionList1: TActionList
    Images = DataMod.SmallImgs
    Left = 664
    Top = 16
    object NewRecord: TAction
      Caption = #1053#1086#1074#1099#1081' '#1088#1077#1084#1086#1085#1090
      Hint = #1053#1086#1074#1072#1103' '#1079#1072#1087#1080#1089#1100' '#1086' '#1088#1077#1084#1086#1085#1090#1077
      ImageIndex = 4
      OnExecute = NewRecordExecute
    end
    object EditRecord: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1088#1077#1084#1086#1085#1090
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1086' '#1088#1077#1084#1086#1085#1090#1077
      ImageIndex = 6
      OnExecute = EditRecordExecute
    end
    object DelRecord: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1088#1077#1084#1086#1085#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1086' '#1088#1077#1084#1086#1085#1090#1077
      ImageIndex = 5
      OnExecute = DelRecordExecute
    end
    object SaveAs: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082
      OnExecute = SaveAsExecute
    end
    object NewReport: TAction
      Caption = #1053#1086#1074#1099#1081' '#1086#1090#1095#1077#1090
      Hint = #1053#1086#1074#1099#1081' '#1086#1090#1095#1077#1090
      ImageIndex = 7
      OnExecute = NewReportExecute
    end
    object Save: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1086#1090#1095#1077#1090
      ImageIndex = 11
      OnExecute = SaveExecute
    end
    object Open: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1086#1090#1095#1077#1090
      ImageIndex = 12
      OnExecute = OpenExecute
    end
    object CloseApp: TAction
      Caption = #1042#1099#1093#1086#1076
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
      OnExecute = CloseAppExecute
    end
    object CloseReport: TAction
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnExecute = CloseReportExecute
    end
    object PrintReport: TAction
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 14
      OnExecute = PrintReportExecute
    end
    object CopyRecord: TAction
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1088#1077#1084#1086#1085#1090
      Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1088#1077#1084#1086#1085#1090
      ImageIndex = 19
      OnExecute = CopyRecordExecute
    end
  end
  object SaveDlg: TSaveDialog
    DefaultExt = '*.rrp'
    Filter = #1054#1090#1095#1077#1090#1099' RENOVA|*.rrp'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1086#1090#1095#1077#1090
    Left = 632
    Top = 16
  end
  object OpenDlg: TOpenDialog
    DefaultExt = '*.rrp'
    Filter = #1054#1090#1095#1077#1090#1099' RENOVA|*.rrp'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Title = #1054#1090#1082#1088#1099#1090#1100' '#1086#1090#1095#1077#1090
    Left = 600
    Top = 16
  end
  object ApplicationEvents1: TApplicationEvents
    OnShowHint = ApplicationEvents1ShowHint
    Left = 728
    Top = 16
  end
  object frxXLSExport1: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 568
    Top = 16
  end
  object frxODSExport1: TfrxODSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PictureType = gpPNG
    Background = True
    Creator = 'FastReport'
    Language = 'en'
    SuppressPageHeadersFooters = False
    Left = 536
    Top = 16
  end
  object frxODTExport1: TfrxODTExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PictureType = gpPNG
    Background = True
    Creator = 'FastReport'
    Language = 'en'
    SuppressPageHeadersFooters = False
    Left = 504
    Top = 16
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 472
    Top = 16
  end
  object frxMailExport1: TfrxMailExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ShowExportDialog = True
    SmtpPort = 25
    UseIniFile = True
    TimeOut = 60
    ConfurmReading = False
    UseMAPI = False
    Left = 440
    Top = 16
  end
  object frxReport: TfrxReport
    Version = '4.15'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 43826.431082314800000000
    ReportOptions.LastChange = 44142.621937511580000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'begin'
      ''
      'end.')
    OnGetValue = frxReportGetValue
    Left = 408
    Top = 16
    Datasets = <
      item
        DataSet = frxUDS
        DataSetName = 'frxUserDataSet1'
      end>
    Variables = <
      item
        Name = ' New Category1'
        Value = Null
      end
      item
        Name = 'REPCAPTION'
        Value = Null
      end
      item
        Name = 'WCNT'
        Value = ''
      end
      item
        Name = 'WSUM'
        Value = ''
      end
      item
        Name = 'MSUM'
        Value = ''
      end
      item
        Name = 'PSUM'
        Value = ''
      end
      item
        Name = 'TSUM'
        Value = ''
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      Orientation = poLandscape
      PaperWidth = 297.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 34.015770000000000000
        Top = 18.897650000000000000
        Width = 1046.929810000000000000
        object Memo39: TfrxMemoView
          Left = 241.889920000000000000
          Top = 7.559060000000000000
          Width = 177.637910000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSetName = 'frxData2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[REPCAPTION]')
          ParentFont = False
        end
        object Memo56: TfrxMemoView
          Left = 582.047620000000000000
          Top = 7.559060000000000000
          Width = 464.882190000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftBottom]
          ParentFont = False
        end
        object Memo57: TfrxMemoView
          Left = 434.645950000000000000
          Top = 7.559060000000000000
          Width = 147.401670000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            #1056#1115#1057#1026#1056#1110#1056#176#1056#1029#1056#1105#1056#183#1056#176#1057#8224#1056#1105#1057#1039', '#1056#1110#1056#1109#1057#1026#1056#1109#1056#1169)
          ParentFont = False
        end
        object Memo58: TfrxMemoView
          Left = 3.779530000000000000
          Top = 7.559060000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            #1056#160#1056#181#1056#181#1057#1027#1057#8218#1057#1026' '#1056#1030#1057#8249#1056#1111#1056#1109#1056#187#1056#1029#1056#181#1056#1029#1056#1029#1057#8249#1057#8230' '#1057#1026#1056#181#1056#1112#1056#1109#1056#1029#1057#8218#1056#1109#1056#1030' '#1056#183#1056#176)
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        Height = 18.897650000000000000
        Top = 154.960730000000000000
        Width = 1046.929810000000000000
        DataSet = frxUDS
        DataSetName = 'frxUserDataSet1'
        PrintIfDetailEmpty = True
        RowCount = 0
        Stretched = True
        object Memo5: TfrxMemoView
          Left = 430.866420000000000000
          Width = 49.133850940000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[COL7]')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          Left = 139.842610000000000000
          Width = 64.252010000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL3]')
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          Left = 18.897650000000000000
          Width = 52.913420000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL1]')
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          Left = 71.811070000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL2]')
          ParentFont = False
        end
        object Memo12: TfrxMemoView
          Left = 279.685220000000000000
          Width = 56.692950000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL5]')
          ParentFont = False
        end
        object Memo13: TfrxMemoView
          Left = 827.717070000000000000
          Width = 41.574830000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL15]')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          Left = 578.268090000000000000
          Width = 83.149660000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL10]')
          ParentFont = False
        end
        object Memo15: TfrxMemoView
          Left = 869.291900000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL16]')
          ParentFont = False
        end
        object Memo22: TfrxMemoView
          Left = 204.094620000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL4]')
          ParentFont = False
        end
        object Memo23: TfrxMemoView
          Left = 336.378170000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL6]')
          ParentFont = False
        end
        object ERRORMEMO: TfrxMemoView
          Left = 1020.473100000000000000
          Width = 26.456710000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[COL18]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Left = 480.000310000000000000
          Width = 49.133850940000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[COL8]')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 529.134200000000000000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[COL9]')
          ParentFont = False
        end
        object Memo2: TfrxMemoView
          Left = 695.433520000000000000
          Width = 41.574830000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[COL11]')
          ParentFont = False
        end
        object Memo8: TfrxMemoView
          Left = 661.417750000000000000
          Width = 34.015770000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[COL12]')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Left = 737.008350000000000000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL13]')
          ParentFont = False
        end
        object Memo16: TfrxMemoView
          Left = 786.142240000000000000
          Width = 41.574830000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[COL14]')
          ParentFont = False
        end
        object Memo17: TfrxMemoView
          Left = 941.102970000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[COL17]')
          ParentFont = False
        end
        object Memo38: TfrxMemoView
          Width = 18.897650000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[COL0]')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 18.897650000000000000
        Top = 449.764070000000000000
        Width = 1046.929810000000000000
        object Memo1: TfrxMemoView
          Left = 971.339210000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          HAlign = haRight
          Memo.UTF8 = (
            '[Page#]')
        end
      end
      object PageHeader1: TfrxPageHeader
        Height = 18.897650000000000000
        Top = 75.590600000000000000
        Width = 1046.929810000000000000
        Stretched = True
        object Memo18: TfrxMemoView
          Left = 430.866420000000000000
          Width = 49.133850940000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          DisplayFormat.FormatStr = 'mm.dd.yy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8221#1056#176#1057#8218#1056#176' '#1056#1111#1056#1109#1056#1108#1057#1107#1056#1111#1056#1108#1056#1105)
          ParentFont = False
        end
        object Memo19: TfrxMemoView
          Left = 139.842610000000000000
          Width = 64.252010000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1106#1056#1169#1057#1026#1056#181#1057#1027' '#1056#1108#1056#187#1056#1105#1056#181#1056#1029#1057#8218#1056#176)
          ParentFont = False
        end
        object Memo20: TfrxMemoView
          Left = 18.897650000000000000
          Width = 52.913420000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8217#1056#1105#1056#1169' '#1057#1026#1056#181#1056#1112#1056#1109#1056#1029#1057#8218#1056#176)
          ParentFont = False
        end
        object Memo21: TfrxMemoView
          Left = 71.811070000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1056#187#1056#1105#1056#181#1056#1029#1057#8218)
          ParentFont = False
        end
        object Memo24: TfrxMemoView
          Left = 279.685220000000000000
          Width = 56.692950000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1114#1056#1109#1056#1169#1056#181#1056#187#1057#1034)
          ParentFont = False
        end
        object Memo25: TfrxMemoView
          Left = 869.291900000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8221#1056#181#1057#8222#1057#8222#1056#181#1056#1108#1057#8218)
          ParentFont = False
        end
        object Memo26: TfrxMemoView
          Left = 578.268090000000000000
          Width = 83.149660000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8221#1056#181#1057#8218#1056#176#1056#187#1056#1105)
          ParentFont = False
        end
        object Memo27: TfrxMemoView
          Left = 941.102970000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#160#1056#176#1056#177#1056#1109#1057#8218#1057#8249)
          ParentFont = False
        end
        object Memo28: TfrxMemoView
          Left = 204.094620000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1118#1056#181#1056#187#1056#181#1057#8222#1056#1109#1056#1029' '#1056#1108#1056#187#1056#1105#1056#181#1056#1029#1057#8218#1056#176)
          ParentFont = False
        end
        object Memo29: TfrxMemoView
          Left = 336.378170000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1038#1056#181#1057#1026#1056#1105#1056#8470#1056#1029#1057#8249#1056#8470' '#1056#1029#1056#1109#1056#1112#1056#181#1057#1026)
          ParentFont = False
        end
        object Memo31: TfrxMemoView
          Left = 480.000310000000000000
          Width = 49.133850940000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          DisplayFormat.FormatStr = 'mm.dd.yy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8221#1056#176#1057#8218#1056#176' '#1056#1111#1057#1026#1056#1105#1056#181#1056#1112#1056#176)
          ParentFont = False
        end
        object Memo32: TfrxMemoView
          Left = 529.134200000000000000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          DisplayFormat.FormatStr = 'mm.dd.yy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1115#1056#1108#1056#1109#1056#1029'-'#1056#1029#1056#1105#1056#181' '#1057#1026#1056#181#1056#1112#1056#1109#1056#1029#1057#8218#1056#176)
          ParentFont = False
        end
        object Memo33: TfrxMemoView
          Left = 661.417750000000000000
          Width = 34.015770000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1056#1109#1056#187' '#1056#1169#1056#181#1057#8218)
          ParentFont = False
        end
        object Memo34: TfrxMemoView
          Left = 695.433520000000000000
          Width = 41.574830000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8212#1056#176' '#1056#1169#1056#181#1057#8218#1056#176#1056#187)
          ParentFont = False
        end
        object Memo35: TfrxMemoView
          Left = 786.142240000000000000
          Width = 41.574830000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8212#1056#176' '#1056#1030#1057#8249#1056#181#1056#183#1056#1169)
          ParentFont = False
        end
        object Memo36: TfrxMemoView
          Left = 827.717070000000000000
          Width = 41.574830000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8212#1056#176' '#1057#1026#1056#181#1056#1112'-'#1057#8218)
          ParentFont = False
        end
        object Memo37: TfrxMemoView
          Left = 1020.473100000000000000
          Width = 26.456710000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1056#1109#1056#1169)
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          Width = 18.897650000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
        end
        object Memo30: TfrxMemoView
          Left = 737.008350000000000000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataSetName = 'frxData1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1074#8222#8211' '#1056#1029#1056#176#1056#1108#1056#187)
          ParentFont = False
        end
      end
      object Footer1: TfrxFooter
        Height = 192.756030000000000000
        Top = 196.535560000000000000
        Width = 1046.929810000000000000
        object Memo41: TfrxMemoView
          Left = 374.173470000000000000
          Top = 117.165430000000000000
          Width = 642.520100000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            
              #1056#160#1057#1107#1056#1108#1056#1109#1056#1030#1056#1109#1056#1169#1056#1105#1057#8218#1056#181#1056#187#1057#1034'  ______________________   _____________' +
              '_________    ________________________')
          ParentFont = False
        end
        object Memo42: TfrxMemoView
          Left = 521.575140000000000000
          Top = 139.842610000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1169#1056#1109#1056#187#1056#182#1056#1029#1056#1109#1057#1027#1057#8218#1057#1034)
          ParentFont = False
        end
        object Memo43: TfrxMemoView
          Left = 691.653990000000000000
          Top = 139.842610000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1111#1056#1109#1056#1169#1056#1111#1056#1105#1057#1027#1057#1034)
          ParentFont = False
        end
        object Memo44: TfrxMemoView
          Left = 880.630490000000000000
          Top = 139.842610000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#164#1056#176#1056#1112#1056#1105#1056#187#1056#1105#1057#1039' '#1056#152#1056#1115)
          ParentFont = False
        end
        object Memo45: TfrxMemoView
          Left = 691.653990000000000000
          Top = 170.078850000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1112'.'#1056#1111'.')
          ParentFont = False
        end
        object Memo40: TfrxMemoView
          Left = 941.102970000000000000
          Top = 41.574830000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[TSUM]')
          ParentFont = False
        end
        object Memo46: TfrxMemoView
          Left = 941.102970000000000000
          Top = 7.559060000000000000
          Width = 75.590600000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8217#1057#1027#1056#181#1056#1110#1056#1109)
          ParentFont = False
        end
        object Memo47: TfrxMemoView
          Left = 865.512370000000000000
          Top = 41.574830000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[PSUM]')
          ParentFont = False
        end
        object Memo48: TfrxMemoView
          Left = 865.512370000000000000
          Top = 7.559060000000000000
          Width = 75.590600000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8212#1056#176
            #1056#1169#1056#181#1057#8218#1056#176#1056#187#1056#1105)
          ParentFont = False
        end
        object Memo49: TfrxMemoView
          Left = 789.921770000000000000
          Top = 41.574830000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[MSUM]')
          ParentFont = False
        end
        object Memo50: TfrxMemoView
          Left = 789.921770000000000000
          Top = 7.559060000000000000
          Width = 75.590600000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8212#1056#176
            #1056#1030#1057#8249#1056#181#1056#183#1056#1169)
          ParentFont = False
        end
        object Memo51: TfrxMemoView
          Left = 714.331170000000000000
          Top = 41.574830000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[WSUM]')
          ParentFont = False
        end
        object Memo52: TfrxMemoView
          Left = 714.331170000000000000
          Top = 7.559060000000000000
          Width = 75.590600000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8212#1056#176' '#1057#1026#1056#181#1056#1112#1056#1109#1056#1029#1057#8218#1057#8249)
          ParentFont = False
        end
        object Memo53: TfrxMemoView
          Left = 634.961040000000000000
          Top = 41.574830000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[WCNT]')
          ParentFont = False
        end
        object Memo54: TfrxMemoView
          Left = 634.961040000000000000
          Top = 7.559060000000000000
          Width = 75.590600000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8217#1057#1027#1056#181#1056#1110#1056#1109
            #1057#1026#1056#181#1056#1112#1056#1109#1056#1029#1057#8218#1056#1109#1056#1030)
          ParentFont = False
        end
        object Memo55: TfrxMemoView
          Left = 37.795300000000000000
          Top = 41.574830000000000000
          Width = 264.567100000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8 = (
            '" _____ "  ___________________ 20 ___ '#1056#1110'.')
        end
      end
    end
  end
  object frxUDS: TfrxUserDataSet
    RangeEnd = reCount
    UserName = 'frxUserDataSet1'
    Left = 376
    Top = 16
  end
end
