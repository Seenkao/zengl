{
 *  Copyright © Kemka Andrey aka Andru
 *  mail: dr.andru@gmail.com
 *  site: http://andru-kun.inf.ua
 *
 *  This file is part of ZenGL.
 *
 *  ZenGL is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as
 *  published by the Free Software Foundation, either version 3 of
 *  the License, or (at your option) any later version.
 *
 *  ZenGL is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with ZenGL. If not, see http://www.gnu.org/licenses/
}
unit zgl_textures_tga;

{$I zgl_config.cfg}

interface

uses
  zgl_file,
  zgl_memory;

const
  TGA_EXTENSION : array[ 0..3 ] of Char = ( 'T', 'G', 'A', #0 );

type
  zglPTGAHeader = ^zglTTGAHeader;
  zglTTGAHeader = packed record
    IDLength  : Byte;
    CPalType  : Byte;
    ImageType : Byte;
    CPalSpec  : packed record
      FirstEntry : Word;
      Length     : Word;
      EntrySize  : Byte;
    end;
    ImgSpec: packed record
      X      : Word;
      Y      : Word;
      Width  : Word;
      Height : Word;
      Depth  : Byte;
      Desc   : Byte;
    end;
end;

procedure tga_LoadFromFile( const FileName : String; var Data : Pointer; var W, H : Word );
procedure tga_LoadFromMemory( const Memory : zglTMemory; var Data : Pointer; var W, H : Word );

implementation
uses
  zgl_types,
  zgl_main,
  zgl_log;

procedure tga_FlipVertically( var Data : Pointer; w, h : Integer );
  var
    i        : Integer;
    scanLine : Pointer;
begin
  GetMem( scanLine, w * 4 );

  for i := 0 to h shr 1 - 1 do
    begin
      Move( Pointer( Ptr( Data ) + i * w * 4 )^, scanLine^, w * 4 );
      Move( Pointer( Ptr( Data ) + ( h - i - 1 ) * w * 4 )^, Pointer( Ptr( Data ) + i * w * 4 )^, w * 4 );
      Move( scanLine^, Pointer( Ptr( Data ) + ( h - i - 1 ) * w * 4 )^, w * 4 );
    end;

  FreeMem( scanLine );
end;

procedure tga_FlipHorizontally( var Data : Pointer; w, h : Integer );
  var
    i, x     : Integer;
    scanLine : Pointer;
begin
  GetMem( scanLine, w * 4 );

  for i := 0 to h - 1 do
    begin
      Move( Pointer( Ptr( Data ) + i * w * 4 )^, scanLine^, w * 4 );
      for x := 0 to w - 1 do
        PLongWord( Ptr( Data ) +  i * w * 4 + x * 4 )^ := PLongWord( Ptr( scanLine ) + ( w - 1 - x ) * 4 )^;
    end;

  FreeMem( scanLine );
end;

function tga_RLEDecode( var tgaMem : zglTMemory; var tgaHeader : zglTTGAHeader; var tgaData : PByte ) : LongWord;
  var
    i, j      : Integer;
    pixelSize : Integer;
    packetHdr : Byte;
    packet    : array[ 0..3 ] of Byte;
    packetLen : Byte;
begin
  pixelSize := tgaHeader.ImgSpec.Depth shr 3;
  Result    := tgaHeader.ImgSpec.Width * tgaHeader.ImgSpec.Height * pixelSize;
  GetMem( tgaData, Result );

  i := 0;
  while i < Result do
    begin
      mem_Read( tgaMem, packetHdr, 1 );
      packetLen := ( packetHdr and $7F ) + 1;
      if ( packetHdr and $80 ) <> 0 Then
        begin
          mem_Read( tgaMem, packet[ 0 ], pixelSize );
          for j := 0 to ( packetLen * pixelSize ) - 1 do
            begin
              tgaData^ := packet[ j mod pixelSize ];
              INC( tgaData );
              INC( i );
            end;
        end else
          for j := 0 to ( packetLen * pixelSize ) - 1 do
            begin
              mem_Read( tgaMem, packet[ j mod pixelSize ], 1 );
              tgaData^ := packet[ j mod pixelSize ];
              INC( tgaData );
              INC( i );
            end;
    end;
  DEC( tgaData, i );

  tgaHeader.ImageType := tgaHeader.ImageType - 8;
end;

function tga_PaletteDecode( var tgaMem : zglTMemory; var tgaHeader : zglTTGAHeader; var tgaData : PByte; tgaPalette : PByte ) : Boolean;
  var
    i, base : Integer;
    size    : Integer;
    entry   : Byte;
begin
  if ( tgaHeader.CPalType = 1 ) and ( tgaHeader.CPalSpec.EntrySize <> 24 ) Then
    begin
      log_Add( 'Unsupported color palette type in TGA-file!' );
      Result := FALSE;
      exit;
    end;

  size := tgaHeader.ImgSpec.Width * tgaHeader.ImgSpec.Height;
  base := tgaHeader.CPalSpec.FirstEntry;
  ReallocMem( tgaData, size * 3 );

  if tgaHeader.CPalType = 1 Then
    begin
      for i := size - 1 downto 0 do
        begin
          entry := PByte( Ptr( tgaData ) + i )^;
          PByte( Ptr( tgaData ) + i * 3 + 0 )^ := PByte( Ptr( tgaPalette ) + entry * 3 + 0 - base )^;
          PByte( Ptr( tgaData ) + i * 3 + 1 )^ := PByte( Ptr( tgaPalette ) + entry * 3 + 1 - base )^;
          PByte( Ptr( tgaData ) + i * 3 + 2 )^ := PByte( Ptr( tgaPalette ) + entry * 3 + 2 - base )^;
        end;
    end else
      for i := size - 1 downto 0 do
        begin
          entry := PByte( Ptr( tgaData ) + i )^;
          PByte( Ptr( tgaData ) + i * 3 + 0 )^ := entry;
          PByte( Ptr( tgaData ) + i * 3 + 1 )^ := entry;
          PByte( Ptr( tgaData ) + i * 3 + 2 )^ := entry;
        end;

  tgaHeader.ImageType     := 2;
  tgaHeader.ImgSpec.Depth := 24;
  tgaHeader.CPalType      := 0;
  FillChar( tgaHeader.CPalSpec, SizeOf( tgaHeader.CPalSpec ), 0 );

  Result := TRUE;
end;

procedure tga_LoadFromFile( const FileName : String; var Data : Pointer; var W, H : Word );
  var
    tgaMem : zglTMemory;
begin
  mem_LoadFromFile( tgaMem, FileName );
  tga_LoadFromMemory( tgaMem, Data, W, H );
  mem_Free( tgaMem );
end;

procedure tga_LoadFromMemory( const Memory : zglTMemory; var Data : Pointer; var W, H : Word );
  label _exit;
  var
    i, size    : Integer;
    tgaMem     : zglTMemory;
    tgaHeader  : zglTTGAHeader;
    tgaData    : PByte;
    tgaPalette : array of Byte;
begin
  tgaMem := Memory;
  mem_Read( tgaMem, tgaHeader, SizeOf( zglTTGAHeader ) );

  if tgaHeader.CPalType = 1 then
    begin
      with tgaHeader.CPalSpec do SetLength( tgaPalette, Length * EntrySize shr 3 );
      mem_Read( tgaMem, tgaPalette[ 0 ], Length( tgaPalette ) );
    end;

  if tgaHeader.ImageType >= 9 Then
    size := tga_RLEDecode( tgaMem, tgaHeader, tgaData )
  else
    begin
      size := tgaHeader.ImgSpec.Width * tgaHeader.ImgSpec.Height * ( tgaHeader.ImgSpec.Depth shr 3 );
      GetMem( tgaData, size );
      mem_Read( tgaMem, tgaData^, size );
    end;

  if tgaHeader.ImageType <> 2 Then
    if not tga_PaletteDecode( tgaMem, tgaHeader, tgaData, @tgaPalette[ 0 ] ) Then
      goto _exit;

  if tgaHeader.ImgSpec.Depth shr 3 = 3 Then
    begin
      GetMem( Data, tgaHeader.ImgSpec.Width * tgaHeader.ImgSpec.Height * 4 );
      for i := 0 to tgaHeader.ImgSpec.Width * tgaHeader.ImgSpec.Height - 1 do
        begin
          PByte( Ptr( Data ) + i * 4 + 2 )^ := PByte( Ptr( tgaData ) + 0 )^;
          PByte( Ptr( Data ) + i * 4 + 1 )^ := PByte( Ptr( tgaData ) + 1 )^;
          PByte( Ptr( Data ) + i * 4 + 0 )^ := PByte( Ptr( tgaData ) + 2 )^;
          PByte( Ptr( Data ) + i * 4 + 3 )^ := 255;
          INC( tgaData, 3 );
        end;
      DEC( tgaData, tgaHeader.ImgSpec.Width * tgaHeader.ImgSpec.Height * 3 );
    end else
      if tgaHeader.ImgSpec.Depth shr 3 = 4 Then
        begin
          GetMem( Data, tgaHeader.ImgSpec.Width * tgaHeader.ImgSpec.Height * 4 );
          for i := 0 to tgaHeader.ImgSpec.Width * tgaHeader.ImgSpec.Height - 1 do
            begin
              PByte( Ptr( Data ) + i * 4 + 2 )^ := PByte( Ptr( tgaData ) + 0 )^;
              PByte( Ptr( Data ) + i * 4 + 1 )^ := PByte( Ptr( tgaData ) + 1 )^;
              PByte( Ptr( Data ) + i * 4 + 0 )^ := PByte( Ptr( tgaData ) + 2 )^;
              PByte( Ptr( Data ) + i * 4 + 3 )^ := PByte( Ptr( tgaData ) + 3 )^;
              INC( tgaData, 4 );
            end;
          DEC( tgaData, tgaHeader.ImgSpec.Width * tgaHeader.ImgSpec.Height * 4 );
        end;

  W := tgaHeader.ImgSpec.Width;
  H := tgaHeader.ImgSpec.Height;

  if ( tgaHeader.ImgSpec.Desc and ( 1 shl 4 ) ) <> 0 Then
    tga_FlipHorizontally( Data, W, H );
  if ( tgaHeader.ImgSpec.Desc and ( 1 shl 5 ) ) <> 0 Then
    tga_FlipVertically( Data, W, H );

_exit:
  begin
    FreeMem( tgaData );
    SetLength( tgaPalette, 0 );
  end;
end;

initialization
  zgl_Reg( TEX_FORMAT_EXTENSION,   @TGA_EXTENSION[ 0 ] );
  zgl_Reg( TEX_FORMAT_FILE_LOADER, @tga_LoadFromFile );
  zgl_Reg( TEX_FORMAT_MEM_LOADER,  @tga_LoadFromMemory );

end.
