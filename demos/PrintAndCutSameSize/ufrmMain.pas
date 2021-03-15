unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ujachPlane;

type
  TfrmMain = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Panel1: TPanel;
    Button1: TButton;
    cbPPI: TComboBox;
    Button3: TButton;
    cbSize: TComboBox;
    cbOrientation: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtPaperHeight: TEdit;
    edtPaperWidth: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtClampSize: TEdit;
    cbClampEdge: TComboBox;
    Button2: TButton;
    edtExtraVert: TEdit;
    edtExtraHoriz: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cbSizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbPPIChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FPlano: TjachMainPlane;
    FNumeradorPag: Integer;
    FNumeradorPlano: Integer;
    procedure CrearPlano;
    procedure DibujarPlano;
    procedure AgregarPlanoInterno;
    procedure AjustarControlesTamaño;
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.Math, System.Types;

{$R *.dfm}

function ExtractIntValue(Edit: TEdit): Integer;
begin
  if (not TryStrToInt(Trim(Edit.Text), Result)) or (Result < 0) then
  begin
    Edit.SelectAll;
    Edit.SetFocus;
    raise EConvertError.Create('El valor ' + Edit.Text + ' no es válido, debe ingresar un número positivo entero de milimetros');
  end;
end;

procedure TfrmMain.AgregarPlanoInterno;
var
  PlanoAux1, PlanoAux2: TjachPlane;
  Size: TPaperSize;
  PaperWidth, PaperHeight: Integer;
  ExtraSpaceHoriz, ExtraSpaceVert: Integer;
begin
  Size := TPaperSize(cbSize.ItemIndex);
  if Size = Custom then
  begin
    PaperWidth := ExtractIntValue(edtPaperWidth);
    PaperHeight := ExtractIntValue(edtPaperHeight);
  end
  else
  begin
    PaperWidth := 0;
    PaperHeight := 0;
  end;

  ExtraSpaceHoriz := ExtractIntValue(edtExtraHoriz);
  ExtraSpaceVert := ExtractIntValue(edtExtraVert);


  PlanoAux1 := TjachPlane.Create(Size, poLandscape);
  Inc(FNumeradorPlano);
  PlanoAux1.LabelText := 'corte' + IntToStr(FNumeradorPlano);
  PlanoAux1.ExtraSpace := PlaneExtraSpace(ExtraSpaceHoriz, ExtraSpaceVert);

//  PlanoAux2 := TjachPlane.Create(A5, poPortrait);
//  Inc(FNumeradorPag);
//  PlanoAux2.LabelText := 'pg' + IntToStr(FNumeradorPag);
//  PlanoAux1.AddPlane(PlanoAux2, Point(0, 0));
//
//  PlanoAux2 := TjachPlane.Create(A5, poPortrait);
//  Inc(FNumeradorPag);
//  PlanoAux2.LabelText := 'pg' + IntToStr(FNumeradorPag);
//  PlanoAux1.AddPlane(PlanoAux2, Point(PlanoAux2.FullDimensionHoriz, 0));

  FPlano.AddPlane(PlanoAux1, Point(0, 0));
  try
    FPlano.AutoArrangeAllSameSize;
  except
    on E:EInsufficientSpaceForAutoArrange do
    begin
      FPlano.RemovePlane(PlanoAux1);
      raise;
    end;
  end;
end;

procedure TfrmMain.AjustarControlesTamaño;
var
  Tamaño: TPaperSize;
begin
  Tamaño := TPaperSize(cbSize.ItemIndex);
  if Tamaño <> TPaperSize.Custom then
  begin
    edtPaperHeight.Text := IntToStr(DimensionesPaperSize[Tamaño].Height);
    edtPaperWidth.Text := IntToStr(DimensionesPaperSize[Tamaño].Width);
    edtPaperHeight.Enabled := False;
    edtPaperWidth.Enabled := False;
  end
  else
  begin
    edtPaperHeight.Enabled := True;
    edtPaperWidth.Enabled := True;
  end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  CrearPlano;
  DibujarPlano;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  while FPlano.ItemCount > 0 do
  begin
    FPlano.RemovePlane(FPlano.Items[FPlano.ItemCount - 1]);
  end;
  DibujarPlano;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  AgregarPlanoInterno;
  DibujarPlano;
end;

procedure TfrmMain.cbPPIChange(Sender: TObject);
begin
  DibujarPlano;
end;

procedure TfrmMain.cbSizeChange(Sender: TObject);
begin
  AjustarControlesTamaño;
end;

procedure TfrmMain.CrearPlano;
var
  Size: TPaperSize;
  PaperWidth, PaperHeight: Integer;
  Orientation: TPlaneOrientation;
  ClampSize: Integer;
  ClampEdge: TEdge;
begin
  if Assigned(FPlano) then
    FPlano.Free;

  Size := TPaperSize(cbSize.ItemIndex);
  if Size = Custom then
  begin
    PaperWidth := ExtractIntValue(edtPaperWidth);
    PaperHeight := ExtractIntValue(edtPaperHeight);
  end
  else
  begin
    PaperWidth := 0;
    PaperHeight := 0;
  end;

  Orientation := TPlaneOrientation(cbOrientation.ItemIndex);
  ClampSize := ExtractIntValue(edtClampSize);
  ClampEdge := TEdge(cbClampEdge.ItemIndex);


  FPlano := TjachMainPlane.Create(Size, Orientation);
  if Size = Custom then
  begin
    FPlano.Width := PaperWidth;
    FPlano.Height := PaperHeight;
  end;

  FPlano.ClampEdge := ClampEdge;
  FPlano.ClampSize := ClampSize;
end;

procedure TfrmMain.DibujarPlano;
var
  Bmp: TBitmap;
  ppi: Integer;
begin
  if not Assigned(FPlano) then
  begin
    Image1.Picture.Bitmap := nil;
    exit;
  end;
  case cbPPI.ItemIndex of
    0: ppi := 40;
    1: ppi := 30;
    2: ppi := 20;
    else ppi := 10;
  end;

  Bmp := TBitmap.Create;
  try
    Bmp.Width := Trunc(RoundTo((FPlano.FullDimensionHoriz * ppi) / 25.4, 0));
    Bmp.Height := Trunc(RoundTo((FPlano.FullDimensionVert * ppi) / 25.4, 0));

    FPlano.Draw(Bmp);

    Image1.Picture.Bitmap := Bmp;
  finally
    Bmp.Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  AjustarControlesTamaño;
end;

end.
