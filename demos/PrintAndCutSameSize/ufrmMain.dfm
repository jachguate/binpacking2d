object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Imprimir y cortar mismo tama'#241'o'
  ClientHeight = 415
  ClientWidth = 722
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 153
    Width = 722
    Height = 262
    Align = alClient
    TabOrder = 0
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 105
      Height = 105
      AutoSize = True
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 722
    Height = 153
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 192
      Top = 40
      Width = 38
      Height = 13
      Caption = 'Tama'#241'o'
    end
    object Label2: TLabel
      Left = 192
      Top = 13
      Width = 55
      Height = 13
      Caption = 'Orientaci'#243'n'
    end
    object Label3: TLabel
      Left = 192
      Top = 70
      Width = 86
      Height = 13
      Caption = 'Dimensiones (mm)'
    end
    object Label4: TLabel
      Left = 405
      Top = 67
      Width = 6
      Height = 13
      Caption = 'X'
    end
    object Label5: TLabel
      Left = 192
      Top = 96
      Width = 52
      Height = 13
      Caption = 'Pinza (mm)'
    end
    object Label6: TLabel
      Left = 406
      Top = 121
      Width = 6
      Height = 13
      Caption = 'X'
    end
    object Label7: TLabel
      Left = 192
      Top = 121
      Width = 53
      Height = 13
      Caption = 'Extra (mm)'
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 145
      Height = 25
      Caption = 'Crear plano base'
      TabOrder = 0
      OnClick = Button1Click
    end
    object cbPPI: TComboBox
      Left = 577
      Top = 10
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 1
      Text = '30 ppi'
      OnChange = cbPPIChange
      Items.Strings = (
        '40 ppi'
        '30 ppi'
        '20 ppi'
        '10 ppi')
    end
    object Button3: TButton
      Left = 8
      Top = 39
      Width = 145
      Height = 25
      Caption = 'Agregar 1'
      TabOrder = 2
      OnClick = Button3Click
    end
    object cbSize: TComboBox
      Left = 320
      Top = 37
      Width = 177
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'A0'
      OnChange = cbSizeChange
      Items.Strings = (
        'A0'
        'A1'
        'A2'
        'A3'
        'A4'
        'A5'
        'A6'
        'A7'
        'A8'
        'A9'
        'A10'
        'B0'
        'B1'
        'B2'
        'B3'
        'B4'
        'B5'
        'B6'
        'B7'
        'B8'
        'B9'
        'B10'
        'USHalfLetter'
        'USLetter'
        'USLegal'
        'USJuniorLegal'
        'USTabloid'
        'Custom'
        '')
    end
    object cbOrientation: TComboBox
      Left = 320
      Top = 10
      Width = 177
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 4
      Text = 'Horizontal - Landscape'
      Items.Strings = (
        'Vertical - Portrait'
        'Horizontal - Landscape')
    end
    object edtPaperHeight: TEdit
      Left = 319
      Top = 64
      Width = 80
      Height = 21
      TabOrder = 5
      Text = '0'
    end
    object edtPaperWidth: TEdit
      Left = 417
      Top = 64
      Width = 80
      Height = 21
      TabOrder = 6
      Text = '0'
    end
    object edtClampSize: TEdit
      Left = 320
      Top = 91
      Width = 80
      Height = 21
      TabOrder = 7
      Text = '0'
    end
    object cbClampEdge: TComboBox
      Left = 406
      Top = 91
      Width = 91
      Height = 21
      Style = csDropDownList
      ItemIndex = 2
      TabOrder = 8
      Text = 'Izquierda'
      Items.Strings = (
        'Arriba'
        'Abajo'
        'Izquierda'
        'Derecha')
    end
    object Button2: TButton
      Left = 8
      Top = 70
      Width = 145
      Height = 25
      Caption = 'Limpiar'
      TabOrder = 9
      OnClick = Button2Click
    end
    object edtExtraVert: TEdit
      Left = 320
      Top = 118
      Width = 80
      Height = 21
      TabOrder = 10
      Text = '0'
    end
    object edtExtraHoriz: TEdit
      Left = 418
      Top = 118
      Width = 80
      Height = 21
      TabOrder = 11
      Text = '0'
    end
  end
end
