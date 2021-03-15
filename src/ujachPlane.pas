{
*  binpacking2d library
*  https://github.com/jachguate/binpacking2d
*
*  Released under the Mozilla Public License Version 2.0
*  original author and maintainer: jachguate at gmail.com
}
unit ujachPlane;

interface
uses System.Classes, Vcl.Graphics, System.Generics.Collections, System.Types,
  System.SysUtils;

type
  EPlaneError = class(Exception)
  end;

  EInsufficientSpaceForAutoArrange = class(EPlaneError)
  end;

  TPlaneOrientation = (poPortrait, poLandscape);

  TPaperSize = (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, USHalfLetter, USLetter, USLegal, USJuniorLegal, USTabloid, Custom);

  TPlaneDimensions = record
    Width, Height: Integer;
  end;

  TPlaneExtraSpace = record
    Horizontal, Vertical: Integer;
  end;

  TEdge = (Top, Bottom, Left, Right);

  TPlaneList = class;

  TjachPlane = class
  private
    FParentPlane: TjachPlane;
    FItems: TPlaneList;
    FOrientation: TPlaneOrientation;
    FLabelText: string;
    FHeight: Integer;
    FWidth: Integer;
    FPaperSize: TPaperSize;
    FTopLeft: TPoint;
    FExtraSpace: TPlaneExtraSpace;

    FFactorMMAPixelHoriz: Double;
    FFactorMMAPixelVert: Double;

    procedure SetWidth(const Value: Integer);
    procedure SetLabelText(const Value: string);
    procedure SetHeight(const Value: Integer);
    procedure SetOrientation(const Value: TPlaneOrientation);

    procedure SetPaperSize(const Value: TPaperSize);

    function GetItems(Index: Integer): TjachPlane;
    procedure SetTopLeft(const Value: TPoint);
    function GetItemCount: Integer;
  protected
    FUnavailableSpaceHoriz: Integer;
    FUnavailableSpaceVert: Integer;
    procedure UpdateUnavailableSpace; virtual;
    procedure SetExtraSpace(const Value: TPlaneExtraSpace); virtual;
    function GetAbsoluteTopLeft: TPoint; virtual;
    function GetPageTopLeft: TPoint; virtual;
    function GetPageAbsoluteTopLeft: TPoint; virtual;
    function GetClientTopLeft: TPoint; virtual;
    function GetClientAbsoluteTopLeft: TPoint; virtual;
    function GetFullRect: TRect; virtual;
    function GetFullAbsoluteRect: TRect; virtual;
    function GetPageRect: TRect; virtual;
    function GetPageAbsoluteRect: TRect; virtual;
    function GetClientRect: TRect; virtual;
    function GetClientAbsoluteRect: TRect; virtual;
    function GetClientWidth: Integer; virtual;
    function GetClientHeight: Integer; virtual;

    function GetFullDimensionHoriz: Integer; virtual;
    function GetFullDimensionVert: Integer; virtual;
    function GetPageDimensionHoriz: Integer; virtual;
    function GetPageDimensionVert: Integer; virtual;
    function GetClientDimensionHoriz: Integer; virtual;
    function GetClientDimensionVert: Integer; virtual;

    procedure InternalRotateAllValues; virtual;
    procedure InternalDraw(Bmp: TBitmap); virtual;
    function mmRectToPixelRect(const AmmRect: TRect): TRect; virtual;
    procedure DrawTextRotatedB(ACanvas: TCanvas; ARect: TRect; Angle: Single; AText: string);
  public
    constructor Create(APaperSize: TPaperSize; AOrientation: TPlaneOrientation = poPortrait); virtual;
    destructor Destroy; override;
    procedure Draw(Bmp: TBitmap);
    procedure AutoArrangeAllSameSize;
    property TopLeft: TPoint read FTopLeft write SetTopLeft;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property PageDimensionHoriz: Integer read GetPageDimensionHoriz;
    property PageDimensionVert: Integer read GetPageDimensionVert;
    property FullDimensionHoriz: Integer read GetFullDimensionHoriz;
    property FullDimensionVert: Integer read GetFullDimensionVert;
    property LabelText: string read FLabelText write SetLabelText;
    property Orientation: TPlaneOrientation read FOrientation write SetOrientation;
    property PaperSize: TPaperSize read FPaperSize write SetPaperSize;
    property ExtraSpace: TPlaneExtraSpace read FExtraSpace write SetExtraSpace;
    procedure AddPlane(APlane: TjachPlane; ATopLeft: TPoint);
    procedure RemovePlane(APlane: TjachPlane);
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TjachPlane read GetItems;
  end;

  TPlaneList = class(TObjectList<TjachPlane>)
  end;

  TjachMainPlane = class(TjachPlane)
  private
    FClampSize: Integer;
    FClampEdge: TEdge;
    procedure SetClampEdge(const Value: TEdge);
    procedure SetClampSize(const Value: Integer);
  protected
    procedure UpdateUnavailableSpace; override;
    procedure SetExtraSpace(const Value: TPlaneExtraSpace); override;
    function GetClientTopLeft: TPoint; override;
    function GetClientAbsoluteTopLeft: TPoint; override;

    function GetClientWidth: Integer; override;
    function GetClientHeight: Integer; override;
    function GetClientDimensionHoriz: Integer; override;
    function GetClientDimensionVert: Integer; override;


    function GetClampTopLeft: TPoint; virtual;
    function GetClampAbsoluteTopLeft: TPoint; virtual;
    function GetClampRect: TRect; virtual;
    function GetClampAbsoluteRect: TRect; virtual;
    procedure InternalDraw(Bmp: TBitmap); override;
  public
    property ClampEdge: TEdge read FClampEdge write SetClampEdge;
    property ClampSize: Integer read FClampSize write SetClampSize;
  end;

//  TPlanePositionMemory = class
//  private
//    FTopLeft: TPoint;
//    FOrientation: TPlaneOrientation;
//    FPlane: TjachPlane;
//    procedure SetOrientation(const Value: TPlaneOrientation);
//    procedure SetTopLeft(const Value: TPoint);
//    procedure SetPlane(const Value: TjachPlane);
//  public
//    constructor Create(APlane: TjachPlane);
//    property TopLeft: TPoint read FTopLeft write SetTopLeft;
//    property Orientation: TPlaneOrientation read FOrientation write SetOrientation;
//    property Plane: TjachPlane read FPlane write SetPlane;
//  end;
//
//  TPlanePositionMemoryList = class(TObjectList<TPlanePositionMemoryList>)
//  end;
//
  function PlaneExtraSpace(AHorizontal, AVertical: Integer): TPlaneExtraSpace;

const
  DimensionesPaperSize: array[TPaperSize] of TPlaneDimensions = (
     {A0}  (Width:  841;     Height: 1189)
     {A1}, (Width:  594;     Height:  841)
     {A2}, (Width:  420;     Height:  594)
     {A3}, (Width:  297;     Height:  420)
     {A4}, (Width:  210;     Height:  297)
     {A5}, (Width:  148;     Height:  210)
     {A6}, (Width:  105;     Height:  148)
     {A7}, (Width:   74;     Height:  105)
     {A8}, (Width:   52;     Height:   74)
     {A9}, (Width:   37;     Height:   52)
    {A10}, (Width:   26;     Height:   37)
     {B0}, (Width: 1000;     Height: 1414)
     {B1}, (Width:  707;     Height: 1000)
     {B2}, (Width:  500;     Height:  707)
     {B3}, (Width:  353;     Height:  500)
     {B4}, (Width:  250;     Height:  353)
     {B5}, (Width:  176;     Height:  250)
     {B6}, (Width:  125;     Height:  176)
     {B7}, (Width:   88;     Height:  125)
     {B8}, (Width:   62;     Height:   88)
     {B9}, (Width:   44;     Height:   62)
    {B10}, (Width:   31;     Height:   44)
    {USHalfLetter}     , (Width:  140;     Height:  216)
    {USLetter}         , (Width:  216;     Height:  279)
    {USLegal}          , (Width:  216;     Height:  356)
    {USJuniorLegal}    , (Width:  127;     Height:  203)
    {USTabloid}        , (Width:  279;     Height:  432)
    {Custom}           , (Width:    0;     Height:    0)
  );

implementation

uses
  System.Math, Winapi.Windows, System.UITypes;



function PlaneExtraSpace(AHorizontal, AVertical: Integer): TPlaneExtraSpace;
begin
  Result.Horizontal := AHorizontal;
  Result.Vertical := AVertical;
end;

{ TjachPlane }

procedure TjachPlane.AutoArrangeAllSameSize;
type
  TAllocationType = (Horiz, Vert);
var
  PendingPlanes: TPlaneList;
  I: Integer;
  MaxPlanesHoriz, MaxPlanesVert: Integer;
  MaxRotatedPlanesHoriz, MaxRotatedPlanesVert: Integer;
  LinealWasteHoriz, LinealWasteVert, WasteHoriz, WasteVert: Integer;
  RotatedLinealWasteHoriz, RotatedLinealWasteVert, RotatedWasteHoriz, RotatedWasteVert: Integer;
  AvailableRect: TRect;
  AllocationRect: TRect;
  AuxPlane: TjachPlane;
  AllocatedPlanes: Integer;
  MinWaste: Integer;
  AllocationType: TAllocationType;
  AllocationOrientation: TPlaneOrientation;
begin
  if FItems.Count = 0 then
    Exit;
  PendingPlanes := TPlaneList.Create(False);
  try
    for I := 0 to FItems.Count - 1 do
      PendingPlanes.Add(FItems[I]);
    AvailableRect := GetPageRect;
    AvailableRect.Width := AvailableRect.Width - FUnavailableSpaceHoriz;
    AvailableRect.Height := AvailableRect.Height - FUnavailableSpaceVert;
    repeat
      AuxPlane := PendingPlanes[0];
      AllocatedPlanes := 0;
      if AvailableRect.Height >= AuxPlane.FullDimensionVert then
        MaxPlanesHoriz := AvailableRect.Width div AuxPlane.FullDimensionHoriz
      else
        MaxPlanesHoriz := 0;
      if AvailableRect.Width >= AuxPlane.FullDimensionHoriz then
        MaxPlanesVert := AvailableRect.Height div AuxPlane.FullDimensionVert
      else
        MaxPlanesVert := 0;
      LinealWasteHoriz := AvailableRect.Width - (AuxPlane.FullDimensionHoriz * MaxPlanesHoriz);
      LinealWasteVert := AvailableRect.Height - (AuxPlane.FullDimensionVert * MaxPlanesVert);
      WasteHoriz := LinealWasteHoriz * AuxPlane.FullDimensionVert;
      WasteVert := LinealWasteVert * AuxPlane.FullDimensionHoriz;

      if AvailableRect.Height >= AuxPlane.FullDimensionHoriz then
        MaxRotatedPlanesHoriz := AvailableRect.Width div AuxPlane.FullDimensionVert
      else
        MaxRotatedPlanesHoriz := 0;
      if AvailableRect.Width >= AuxPlane.FullDimensionVert then
        MaxRotatedPlanesVert := AvailableRect.Height div AuxPlane.FullDimensionHoriz
      else
        MaxRotatedPlanesVert := 0;
      RotatedLinealWasteHoriz := AvailableRect.Width - (AuxPlane.FullDimensionVert * MaxRotatedPlanesHoriz);
      RotatedLinealWasteVert := AvailableRect.Height - (AuxPlane.FullDimensionHoriz * MaxRotatedPlanesVert);
      RotatedWasteHoriz := RotatedLinealWasteHoriz * AuxPlane.FullDimensionHoriz;
      RotatedWasteVert := RotatedLinealWasteVert * AuxPlane.FullDimensionVert;

      MinWaste := Min(Min(Min(WasteHoriz, WasteVert), RotatedWasteHoriz), RotatedWasteVert);

      if MinWaste = WasteVert then
      begin
        AllocationType := TAllocationType.Vert;
        AllocationOrientation := AuxPlane.Orientation;
      end
      else if MinWaste = RotatedWasteVert then
      begin
        AllocationType := TAllocationType.Vert;
        if AuxPlane.Orientation = poPortrait then
          AllocationOrientation := poLandscape
        else
          AllocationOrientation := poPortrait;
      end
      else if MinWaste = WasteHoriz then
      begin
        AllocationType := TAllocationType.Horiz;
        AllocationOrientation := AuxPlane.Orientation;
      end
      else
      begin
        AllocationType := TAllocationType.Horiz;
        if AuxPlane.Orientation = poPortrait then
          AllocationOrientation := poLandscape
        else
          AllocationOrientation := poPortrait;
      end;

      AuxPlane.Orientation := AllocationOrientation;

      case AllocationType of
        Horiz:
          begin
            AllocationRect := AvailableRect;
            AllocationRect.Height := AuxPlane.FullDimensionVert;
            AvailableRect.Top := AvailableRect.Top + AuxPlane.FullDimensionVert;
            while (AllocationRect.Width >= AuxPlane.FullDimensionHoriz) and (PendingPlanes.Count > 0) do
            begin
              Inc(AllocatedPlanes);
              PendingPlanes[0].Orientation := AllocationOrientation;
              PendingPlanes[0].TopLeft := AllocationRect.TopLeft;
              PendingPlanes.Delete(0);
              AllocationRect.Left := AllocationRect.Left + AuxPlane.FullDimensionHoriz;
            end;
          end;
        Vert:
          begin
            AllocationRect := AvailableRect;
            AllocationRect.Width := AuxPlane.FullDimensionHoriz;
            AvailableRect.Left := AvailableRect.Left + AuxPlane.FullDimensionHoriz;
            while (AllocationRect.Height >= AuxPlane.FullDimensionVert) and (PendingPlanes.Count > 0) do
            begin
              Inc(AllocatedPlanes);
              PendingPlanes[0].Orientation := AuxPlane.Orientation;
              PendingPlanes[0].TopLeft := AllocationRect.TopLeft;
              PendingPlanes.Delete(0);
              AllocationRect.Top := AllocationRect.Top + AuxPlane.FullDimensionVert;
            end;
          end;
      end;
    until (PendingPlanes.Count = 0) or (AllocatedPlanes = 0);

    if PendingPlanes.Count > 0 then
    begin
      raise EInsufficientSpaceForAutoArrange.Create('No se ha podido acomodar todos los planos');
    end;
  finally
    PendingPlanes.Free;
  end;
end;

constructor TjachPlane.Create(APaperSize: TPaperSize; AOrientation: TPlaneOrientation = poPortrait);
begin
  inherited Create;
  FItems := TPlaneList.Create(True);
  FOrientation := AOrientation;
  PaperSize := APaperSize;
end;

destructor TjachPlane.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TjachPlane.Draw(Bmp: Vcl.Graphics.TBitmap);
begin
  FFactorMMAPixelHoriz := Bmp.Width / FullDimensionHoriz;
  FFactorMMAPixelVert := Bmp.Height / FullDimensionVert;
  InternalDraw(Bmp);
end;

procedure TjachPlane.DrawTextRotatedB(ACanvas: TCanvas; ARect: TRect;
  Angle: Single; AText: string);
//thanks to https://stackoverflow.com/a/52923681/255257
var
  Escapement: Integer;
  LogFont: TLogFont;
  NewFontHandle: HFONT;
  OldFontHandle: HFONT;
  TxtColor: TColor;
  PosX, PosY: Integer;
  TxtSize: TSize;
begin
  if not Assigned(ACanvas) then
    Exit;
  TxtColor := ACanvas.Font.Color;

  // Get handle of font and prepare escapement
  GetObject(ACanvas.Font.Handle, SizeOf(LogFont), @LogFont);
  if Angle > 360 then
    Angle := 0;
  Escapement := Round(Angle * 10);

  // We must initialise all fields of the record structure
  LogFont.lfWidth := 0;
  LogFont.lfHeight := ACanvas.Font.Height;
  LogFont.lfEscapement := Escapement;
  LogFont.lfOrientation := 0;
  if fsBold in ACanvas.Font.Style then
    LogFont.lfWeight := FW_BOLD
  else
    LogFont.lfWeight := FW_NORMAL;
  LogFont.lfItalic := Byte(fsItalic in ACanvas.Font.Style);
  LogFont.lfUnderline := Byte(fsUnderline in ACanvas.Font.Style);
  LogFont.lfStrikeOut := Byte(fsStrikeOut in ACanvas.Font.Style);
  LogFont.lfCharSet := ACanvas.Font.Charset;
  LogFont.lfOutPrecision := OUT_DEFAULT_PRECIS;
  LogFont.lfClipPrecision := CLIP_DEFAULT_PRECIS;
  LogFont.lfQuality := DEFAULT_QUALITY;
  LogFont.lfPitchAndFamily := DEFAULT_PITCH;
  StrPCopy(LogFont.lfFaceName, ACanvas.Font.Name);

  // Create new font with rotation
  NewFontHandle := CreateFontIndirect(LogFont);
  try
    // Set color of text
    ACanvas.Font.Color := txtColor;

    // Select the new font into the canvas
    OldFontHandle := SelectObject(ACanvas.Handle, NewFontHandle);
    try
      // Output result
      ACanvas.Brush.Style := VCL.Graphics.bsClear;
      try
        //ACanvas.TextOut(X, Y, AText);
        TxtSize := Acanvas.TextExtent(AText);
        if Escapement = 2700 then
        begin
          PosX := Arect.Right - (ARect.Width - TxtSize.Height) div 2;
          PosY := ARect.Top + (ARect.Height - TxtSize.Width) div 2;
        end
        else if Escapement = 900 then
        begin
          PosX := Arect.Left + (ARect.Width - TxtSize.Height) div 2;
          PosY := ARect.Bottom - (ARect.Height - TxtSize.Width) div 2;
        end;
        ACanvas.TextOut(PosX, PosY, AText);
      finally
        ACanvas.Brush.Style := VCL.Graphics.bsSolid;
      end;
    finally
      // Restore font handle
      NewFontHandle := SelectObject(ACanvas.Handle, OldFontHandle);
    end;
  finally
    // Delete the deselected font object
    DeleteObject(NewFontHandle);
  end;
end;

function TjachPlane.GetPageDimensionHoriz: Integer;
begin
  case FOrientation of
    poLandscape: Result := FHeight;
    poPortrait: Result := FWidth;
    else Result := 0;
  end;
end;

function TjachPlane.GetPageDimensionVert: Integer;
begin
  case FOrientation of
    poLandscape: Result := FWidth;
    poPortrait: Result := FHeight;
    else Result := 0;
  end;
end;

function TjachPlane.GetFullAbsoluteRect: TRect;
begin
  Result.TopLeft := GetAbsoluteTopLeft;
  Result.Width := GetFullDimensionHoriz;
  Result.Height := GetFullDimensionVert;
end;

function TjachPlane.GetFullDimensionHoriz: Integer;
begin
  case FOrientation of
    poLandscape: Result := FHeight + FExtraSpace.Vertical * 2;
    poPortrait: Result := FWidth + FExtraSpace.Horizontal * 2;
    else Result := 0;
  end;
end;

function TjachPlane.GetFullDimensionVert: Integer;
begin
  case FOrientation of
    poLandscape: Result := FWidth + FExtraSpace.Horizontal * 2;
    poPortrait: Result := FHeight + FExtraSpace.Vertical * 2;
    else Result := 0;
  end;
end;

function TjachPlane.GetFullRect: TRect;
begin
  Result.TopLeft := FTopLeft;
  Result.Width := GetFullDimensionHoriz;
  Result.Height := GetFullDimensionVert;
end;

procedure TjachPlane.InternalDraw(Bmp: Vcl.Graphics.TBitmap);
var
  FullRect: TRect;
  PageRect: TRect;
  EtiquetaSize: TSize;
  EtiquetaPos: TPoint;
  Plane: TjachPlane;
  CutMarkSpace: Integer;
begin
  PageRect := mmRectToPixelRect(GetPageAbsoluteRect);
  if (FExtraSpace.Horizontal <> 0) or (FExtraSpace.Vertical <> 0) then
  begin
    FullRect := mmRectToPixelRect(GetFullAbsoluteRect);
    Bmp.Canvas.Brush.Color := RGB(191, 232, 242);
    Bmp.Canvas.Brush.Style := bsFDiagonal;
    Bmp.Canvas.Pen.Style := psSolid;
    Bmp.Canvas.Pen.Color := clSilver;
    Bmp.Canvas.Rectangle(FullRect);

    Bmp.Canvas.Pen.Color := clBlack;

    if (FullRect.Top < PageRect.Top) and (FullRect.Left < PageRect.Left) then
    begin
      CutMarkSpace := Round((PageRect.Top - FullRect.Top) / 4);
      Bmp.Canvas.MoveTo(PageRect.Left, PageRect.Top - CutMarkSpace);
      Bmp.Canvas.LineTo(PageRect.Left, FullRect.Top + CutMarkSpace);
      Bmp.Canvas.MoveTo(PageRect.Right, PageRect.Top - CutMarkSpace);
      Bmp.Canvas.LineTo(PageRect.Right, FullRect.Top + CutMarkSpace);
      Bmp.Canvas.MoveTo(PageRect.Left, PageRect.Bottom + CutMarkSpace);
      Bmp.Canvas.LineTo(PageRect.Left, FullRect.Bottom - CutMarkSpace);
      Bmp.Canvas.MoveTo(PageRect.Right, PageRect.Bottom + CutMarkSpace);
      Bmp.Canvas.LineTo(PageRect.Right, FullRect.Bottom - CutMarkSpace);

      CutMarkSpace := Round((PageRect.Left - FullRect.Left) / 4);
      Bmp.Canvas.MoveTo(PageRect.Left - CutMarkSpace, PageRect.Top);
      Bmp.Canvas.LineTo(FullRect.Left + CutMarkSpace, PageRect.Top);
      Bmp.Canvas.MoveTo(PageRect.Left - CutMarkSpace, PageRect.Bottom);
      Bmp.Canvas.LineTo(FullRect.Left + CutMarkSpace, PageRect.Bottom);

      Bmp.Canvas.MoveTo(PageRect.Right + CutMarkSpace, PageRect.Top);
      Bmp.Canvas.LineTo(FullRect.Right - CutMarkSpace, PageRect.Top);
      Bmp.Canvas.MoveTo(PageRect.Right + CutMarkSpace, PageRect.Bottom);
      Bmp.Canvas.LineTo(FullRect.Right - CutMarkSpace, PageRect.Bottom);
    end;
  end;

  Bmp.Canvas.Brush.Color := clWhite;
  Bmp.Canvas.Brush.Style := bsSolid;
  Bmp.Canvas.Pen.Style := psSolid;
  Bmp.Canvas.Pen.Color := clBlack;
  Bmp.Canvas.Rectangle(PageRect);

  for Plane in FItems do
  begin
    Plane.InternalDraw(Bmp);
  end;

  if LabelText <> '' then
  begin
    Bmp.Canvas.Font.Size := 10;
    Bmp.Canvas.Font.Style := [];
    Bmp.Canvas.Font.Color := clBlack;
    EtiquetaSize := Bmp.Canvas.TextExtent(LabelText);
    EtiquetaPos.X := PageRect.Left + (PageRect.Width - EtiquetaSize.Width) div 2;
    EtiquetaPos.Y := PageRect.Bottom - EtiquetaSize.Height - EtiquetaSize.Height div 4;
    Bmp.Canvas.TextOut(EtiquetaPos.X, EtiquetaPos.Y, LabelText);
  end;
end;

procedure TjachPlane.InternalRotateAllValues;
var
  Plane: TjachPlane;
  Aux: Integer;
begin
  for Plane in FItems do
  begin
    Aux := Plane.FTopLeft.X;
    Plane.FTopLeft.X := Plane.FTopLeft.Y;
    Plane.FTopLeft.Y := Aux;
    Aux := Plane.FExtraSpace.Horizontal;
    Plane.FExtraSpace.Horizontal := Plane.FExtraSpace.Vertical;
    Plane.FExtraSpace.Vertical := Aux;
    if Plane.Orientation = poPortrait then
      Plane.Orientation := poLandscape
    else
      Plane.Orientation := poPortrait;
  end;
end;

function TjachPlane.mmRectToPixelRect(const AmmRect: TRect): TRect;
begin
  if Assigned(FParentPlane) then
    Result := FParentPlane.mmRectToPixelRect(AmmRect)
  else
  begin
    Result.Top := Round(AmmRect.Top * FFactorMMAPixelVert);
    Result.Left := Round(AmmRect.Left * FFactorMMAPixelHoriz);
    Result.Bottom := Round(AmmRect.Bottom * FFactorMMAPixelVert);
    Result.Right := Round(AmmRect.Right * FFactorMMAPixelHoriz);
  end;
end;

procedure TjachPlane.RemovePlane(APlane: TjachPlane);
begin
  FItems.Remove(APlane);
end;

procedure TjachPlane.SetWidth(const Value: Integer);
begin
  if (Value <> FWidth) and (Value > 0) then
    FWidth := Value;
end;

procedure TjachPlane.UpdateUnavailableSpace;
begin
  //
end;

procedure TjachPlane.SetLabelText(const Value: string);
begin
  FLabelText := Value;
end;

procedure TjachPlane.SetExtraSpace(const Value: TPlaneExtraSpace);
begin
  FExtraSpace := Value;
  if FExtraSpace.Horizontal < 0 then
    FExtraSpace.Horizontal := 0;
  if FExtraSpace.Vertical < 0 then
    FExtraSpace.Vertical := 0;
end;

procedure TjachPlane.SetHeight(const Value: Integer);
begin
  if (Value <> FHeight) and (Value > 0) then
    FHeight := Value;
end;

procedure TjachPlane.SetOrientation(const Value: TPlaneOrientation);
begin
  if (Value <> FOrientation) then
  begin
    FOrientation := Value;
    InternalRotateAllValues;
  end;
end;

procedure TjachPlane.SetPaperSize(const Value: TPaperSize);
begin
  if (FPaperSize <> Value) or (FHeight = 0) then
  begin
    FPaperSize := Value;
    if DimensionesPaperSize[FPaperSize].Width <> 0 then
    begin
      Width := DimensionesPaperSize[FPaperSize].Width;
      Height := DimensionesPaperSize[FPaperSize].Height;
    end;
  end;
end;

procedure TjachPlane.SetTopLeft(const Value: TPoint);
begin
  FTopLeft := Value;
  if FTopLeft.X < 0 then
    FTopLeft.X := 0;
  if FTopLeft.Y < 0 then
    FTopLeft.Y := 0;
end;

procedure TjachPlane.AddPlane(APlane: TjachPlane; ATopLeft: TPoint);
begin
  APlane.TopLeft := ATopLeft;
  APlane.FParentPlane := Self;
  FItems.Add(APlane);
end;

function TjachPlane.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TjachPlane.GetItems(Index: Integer): TjachPlane;
begin
  Result := FItems[Index];
end;

function TjachPlane.GetPageAbsoluteRect: TRect;
var
  AbsoluteTopLeft: TPoint;
begin
  AbsoluteTopLeft := GetAbsoluteTopLeft;
  Result.Top := AbsoluteTopLeft.Y + IfThen(FOrientation = poPortrait, FExtraSpace.Vertical, FExtraSpace.Horizontal);
  Result.Left := AbsoluteTopLeft.X + IfThen(FOrientation = poPortrait, FExtraSpace.Horizontal, FExtraSpace.Vertical);
  Result.Width := GetPageDimensionHoriz;
  Result.Height := GetPageDimensionVert;
end;

function TjachPlane.GetPageAbsoluteTopLeft: TPoint;
begin
  Result := GetAbsoluteTopLeft;
  Result.X := Result.X + FExtraSpace.Horizontal;
  Result.Y := Result.Y + FExtraSpace.Vertical;
end;

function TjachPlane.GetPageRect: TRect;
begin
  Result.Top := FTopLeft.Y + IfThen(FOrientation = poPortrait, FExtraSpace.Vertical, FExtraSpace.Horizontal);
  Result.Left := FTopLeft.X + IfThen(FOrientation = poPortrait, FExtraSpace.Horizontal, FExtraSpace.Vertical);
  Result.Width := GetPageDimensionHoriz;
  Result.Height := GetPageDimensionVert;
end;

function TjachPlane.GetPageTopLeft: TPoint;
begin
  Result.Y := FTopLeft.Y + FExtraSpace.Vertical;
  Result.X := FTopLeft.X + FExtraSpace.Horizontal;
end;

function TjachPlane.GetAbsoluteTopLeft: TPoint;
var
  ParentTopLeft: TPoint;
begin
  Result := FTopLeft;
  if Assigned(FParentPlane) then
  begin
    ParentTopLeft := FParentPlane.GetClientAbsoluteTopLeft;
    Result.X := Result.X + ParentTopLeft.X;
    Result.Y := Result.Y + ParentTopLeft.Y;
  end;
end;

function TjachPlane.GetClientAbsoluteRect: TRect;
begin
  Result.TopLeft := GetClientAbsoluteTopLeft;
  Result.Width := GetClientDimensionHoriz;
  Result.Height := GetClientDimensionVert;
end;

function TjachPlane.GetClientAbsoluteTopLeft: TPoint;
begin
  Result := GetPageAbsoluteTopLeft;
end;

function TjachPlane.GetClientDimensionHoriz: Integer;
begin
  Result := GetPageDimensionHoriz;
end;

function TjachPlane.GetClientDimensionVert: Integer;
begin
  Result := GetPageDimensionVert;
end;

function TjachPlane.GetClientHeight: Integer;
begin
  Result := Height;
end;

function TjachPlane.GetClientRect: TRect;

begin
  Result.TopLeft := GetClientTopLeft;
  Result.Width := GetClientDimensionHoriz;
  Result.Height := GetClientDimensionVert;
end;

function TjachPlane.GetClientTopLeft: TPoint;
begin
  Result := GetPageTopLeft;
end;

function TjachPlane.GetClientWidth: Integer;
begin
  Result := Width;
end;

{ TjachMainPlane }

function TjachMainPlane.GetClampAbsoluteRect: TRect;
begin
  Result.TopLeft := GetClampAbsoluteTopLeft;
  case FClampEdge of
    Top,
    Bottom:
      begin
        Result.Width := GetFullDimensionHoriz;
        Result.Height := ClampSize;
      end;
    Left,
    Right:
      begin
        Result.Height := GetFullDimensionVert;
        Result.Width := ClampSize;
      end;
  end;
end;

function TjachMainPlane.GetClampAbsoluteTopLeft: TPoint;
begin
  Result := GetAbsoluteTopLeft;
  case FClampEdge of
    Bottom:
      begin
        Result.Y := Result.Y + GetPageDimensionVert - ClampSize;
      end;
    Right:
      begin
        Result.X := Result.X + GetPageDimensionHoriz - ClampSize;
      end;
  end;
end;

function TjachMainPlane.GetClampRect: TRect;
begin
  Result.TopLeft := GetClampTopLeft;
  case FClampEdge of
    Top,
    Bottom:
      begin
        Result.Width := GetFullDimensionHoriz;
        Result.Height := ClampSize;
      end;
    Left,
    Right:
      begin
        Result.Height := GetFullDimensionVert;
        Result.Width := ClampSize;
      end;
  end;
end;

function TjachMainPlane.GetClampTopLeft: TPoint;
begin
  Result := TopLeft;
  case FClampEdge of
    Bottom:
      begin
        Result.Y := Result.Y + GetPageDimensionVert - ClampSize;
      end;
    Right:
      begin
        Result.X := Result.X + GetPageDimensionHoriz - ClampSize;
      end;
  end;
end;

function TjachMainPlane.GetClientAbsoluteTopLeft: TPoint;
begin
  Result := GetPageAbsoluteTopLeft;
  if ClampSize > 0 then
    case ClampEdge of
      Top: Result.Y := Result.Y + ClampSize;
      Left: Result.X := Result.X + ClampSize;
    end;
end;

function TjachMainPlane.GetClientDimensionHoriz: Integer;
begin
  Result := GetPageDimensionHoriz;
  if FClampEdge in [Left, Right] then
    Result := Result - FClampSize;
end;

function TjachMainPlane.GetClientDimensionVert: Integer;
begin
  Result := GetPageDimensionVert;
  if FClampEdge in [Top, Bottom] then
    Result := Result - FClampSize;
end;

function TjachMainPlane.GetClientHeight: Integer;
begin
  if FClampEdge in [Top, Bottom] then
    Result := Height - ClampSize
  else
    Result := Height;
end;

function TjachMainPlane.GetClientTopLeft: TPoint;
begin
  Result := GetPageTopLeft;
  if ClampSize > 0 then
    case ClampEdge of
      Top: Result.Y := Result.Y + ClampSize;
      Left: Result.X := Result.X + ClampSize;
    end;
end;

function TjachMainPlane.GetClientWidth: Integer;
begin
  if FClampEdge in [Left, Right] then
    Result := Width - ClampSize
  else
    Result := Width;
end;

procedure TjachMainPlane.InternalDraw(Bmp: Vcl.Graphics.TBitmap);
var
  ClampPixelRect: TRect;
  txtClamp: string;
begin
  inherited;
  if ClampSize > 0 then
  begin
    ClampPixelRect := mmRectToPixelRect(GetClampAbsoluteRect);
    Bmp.Canvas.Brush.Color := clSilver;
    Bmp.Canvas.Brush.Style := bsDiagCross;
    Bmp.Canvas.Pen.Style := psDashDotDot;
    Bmp.Canvas.Pen.Color := clBlack;
    Bmp.Canvas.Pen.Width := 1;
    Bmp.Canvas.Rectangle(ClampPixelRect);
    Bmp.Canvas.Font.Color := clRed;
    Bmp.Canvas.Pen.Color := clBlack;
    Bmp.Canvas.Pen.Style := psDashDotDot;
    txtClamp := 'pinza          pinza          pinza';
    InflateRect(ClampPixelRect, -1, -1);
    //todo: escalar fuente
    Bmp.Canvas.Font.Size := 9;
    Bmp.Canvas.Font.Style := [fsBold];
    case FClampEdge of
      Top:
        begin
          Bmp.Canvas.TextRect(ClampPixelRect, txtClamp, [tfCenter, tfVerticalCenter]);
        end;
      Bottom:
        begin
          Bmp.Canvas.TextRect(ClampPixelRect, txtClamp, [tfCenter, tfVerticalCenter]);
        end;
      Left:
        begin
          DrawTextRotatedB(Bmp.Canvas, ClampPixelRect, 270, txtClamp);
        end;
      Right:
        begin
          DrawTextRotatedB(Bmp.Canvas, ClampPixelRect, 90, txtClamp);
        end;
    end;
  end;
end;

procedure TjachMainPlane.SetClampEdge(const Value: TEdge);
begin
  FClampEdge := Value;
  UpdateUnavailableSpace;
end;

procedure TjachMainPlane.SetClampSize(const Value: Integer);
begin
  if (Value <> FClampSize) and (Value >= 0) then
    FClampSize := Value;
  UpdateUnavailableSpace;
end;

procedure TjachMainPlane.SetExtraSpace(const Value: TPlaneExtraSpace);
begin
  FExtraSpace.Horizontal := 0;
  FExtraSpace.Vertical := 0;
end;

procedure TjachMainPlane.UpdateUnavailableSpace;
begin
  if FClampSize > 0 then
  begin
    case FClampEdge of
      Top,
      Bottom: FUnavailableSpaceVert := FClampSize;
      Left,
      Right:  FUnavailableSpaceHoriz := FClampSize;
    end;
  end;
end;

{ TPlanePositionMemory }

//constructor TPlanePositionMemory.Create(APlane: TjachPlane);
//begin
//  inherited Create;
//  FPlane := APlane;
//  FTopLeft := APlane.TopLeft;
//  FOrientation := APlane.Orientation;
//end;
//
//procedure TPlanePositionMemory.SetOrientation(const Value: TPlaneOrientation);
//begin
//  FOrientation := Value;
//end;
//
//procedure TPlanePositionMemory.SetPlane(const Value: TjachPlane);
//begin
//  FPlane := Value;
//end;
//
//procedure TPlanePositionMemory.SetTopLeft(const Value: TPoint);
//begin
//  FTopLeft := Value;
//end;

end.
