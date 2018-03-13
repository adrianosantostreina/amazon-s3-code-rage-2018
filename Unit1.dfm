object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 482
  ClientWidth = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 37
    Height = 16
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 16
    Top = 30
    Width = 37
    Height = 16
    Caption = 'Label2'
  end
  object Button1: TButton
    Left = 8
    Top = 64
    Width = 193
    Height = 25
    Caption = 'Buckets'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 207
    Top = 64
    Width = 194
    Height = 25
    Caption = 'Arquivos'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 407
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Upload'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 407
    Top = 135
    Width = 75
    Height = 25
    Caption = 'Download'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 407
    Top = 175
    Width = 75
    Height = 25
    Caption = 'Exluir'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 407
    Top = 264
    Width = 169
    Height = 25
    Caption = 'Criar Bucket'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 407
    Top = 295
    Width = 169
    Height = 25
    Caption = 'Excluir Bucket'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Edit1: TEdit
    Left = 407
    Top = 234
    Width = 169
    Height = 24
    TabOrder = 7
  end
  object ListBox1: TListBox
    Left = 8
    Top = 95
    Width = 193
    Height = 378
    TabOrder = 8
  end
  object ListBox2: TListBox
    Left = 207
    Top = 95
    Width = 194
    Height = 378
    TabOrder = 9
  end
  object amcAmazon: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Left = 56
    Top = 152
  end
  object OpenDialog1: TOpenDialog
    Left = 56
    Top = 208
  end
end
