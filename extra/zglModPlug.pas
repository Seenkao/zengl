{
 * Copyright © Kemka Andrey aka Andru
 * mail: dr.andru@gmail.com
 * site: http://andru-kun.inf.ua
 *
 * This file is part of ZenGL
 *
 * ZenGL is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * ZenGL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
}
unit zglModPlug;

// Если проект не собирается с ZenGL статически, то стоит закоментировать этот define
{$DEFINE STATIC}

interface
uses
  {$IFNDEF STATIC}
  zglHeader,
  {$ELSE}
  zgl_types,
  zgl_application,
  zgl_main,
  zgl_sound,
  zgl_log,
  zgl_file,
  zgl_memory,
  zgl_utils
  {$ENDIF}
  ;

const
{$IFDEF WIN32}
  libmodplug = 'libmodplug.dll';
{$ENDIF}
{$IFDEF LINUX}
  libmodplug = 'libmodplug.so';
{$ENDIF}
{$IFDEF DARWIN}
  libmodplug = 'libmodplug.dylib';
{$ENDIF}
  MAX_FORMATS = 22;

const
  MODPLUG_ENABLE_OVERSAMPLING     = 1 shl 0;
  MODPLUG_ENABLE_NOISE_REDUCTION  = 1 shl 1;
  MODPLUG_ENABLE_REVERB           = 1 shl 2;
  MODPLUG_ENABLE_MEGABASS         = 1 shl 3;
  MODPLUG_ENABLE_SURROUND         = 1 shl 4;

  MODPLUG_RESAMPLE_NEAREST = 0;
  MODPLUG_RESAMPLE_LINEAR  = 1;
  MODPLUG_RESAMPLE_SPLINE  = 2;
  MODPLUG_RESAMPLE_FIR     = 3;

type
  PModPlugFile = ^ModPlugFile;
  ModPlugFile = record
  end;

procedure mp_Init;
function  mp_DecoderOpen( var Stream : zglTSoundStream; const FileName : String ) : Boolean;
function  mp_DecoderRead( var Stream : zglTSoundStream; const Buffer : Pointer; const Count : DWORD; var _End : Boolean ) : DWORD;
procedure mp_DecoderLoop( var Stream : zglTSoundStream );
procedure mp_DecoderClose( var Stream : zglTSoundStream );

var
  Decoders : array[ 0..MAX_FORMATS - 1 ] of zglTSoundDecoder;
  FORMATS  : array[ 0..MAX_FORMATS - 1 ] of String = ( 'MOD', 'IT',  'S3M', 'XM',  'IT',  '669', 'AMF', 'AMS', 'DBM', 'DMF', 'DSM', 'FAR',
                                                       'MDL', 'MED', 'MTM', 'OKT', 'PTM', 'STM', 'ULT', 'UMX', 'MT2', 'PSM' );

  mpLoad    : Boolean;
  mpInit    : Boolean;
  mpLibrary : {$IFDEF WIN32} LongWord {$ELSE} Pointer {$ENDIF};

  ModPlug_Load      : function(data: pointer; size: longint): PModPlugFile; cdecl;
  ModPlug_Unload    : procedure(_file: PModPlugFile); cdecl;
  ModPlug_Read      : function(_file: PModPlugFile; buffer: pointer; size: longint): longint; cdecl;
  ModPlug_Seek      : procedure(_file: PModPlugFile; millisecond: longint); cdecl;
  ModPlug_GetLength : function(_file: PModPlugFile): longint; cdecl;

implementation

procedure mp_Init;
begin
  mpLibrary := dlopen( libmodplug {$IFNDEF WIN32}, $001 {$ENDIF} );
  {$IFDEF LINUX}
  if mpLibrary = LIB_ERROR Then
    mpLibrary := dlopen( PChar( libmodplug + '.0' ), $001 );
  {$ENDIF}
  {$IFDEF DARWIN}
  if mpLibrary = LIB_ERROR Then
    mpLibrary := dlopen( PChar( app_WorkDir + 'Contents/MacOS/' + libmodplug ), $001 );
  {$ENDIF}

  if mpLibrary <> LIB_ERROR Then
    begin
      ModPlug_Load      := dlsym( mpLibrary, 'ModPlug_Load' );
      ModPlug_Unload    := dlsym( mpLibrary, 'ModPlug_Unload' );
      ModPlug_Read      := dlsym( mpLibrary, 'ModPlug_Read' );
      ModPlug_Seek      := dlsym( mpLibrary, 'ModPlug_Seek' );
      ModPlug_GetLength := dlsym( mpLibrary, 'ModPlug_GetLength' );

      log_Add( 'ModPlug: Successful initialized'  );
      mpInit := TRUE;
    end else
      begin
        log_Add( 'ModPlug: Error while loading ' + libmodplug  );
        mpInit := FALSE;
      end;

  mpLoad := TRUE;
end;

function mp_DecoderOpen;
  var
    mem : zglTMemory;
begin
  if not mpLoad Then mp_Init;
  if not mpInit Then exit;

  mem_LoadFromFile( mem, FileName );
  PModPlugFile( Stream._Data ) := ModPlug_Load( mem.Memory, mem.Size );
  mem_Free( mem );

  if Assigned( Stream._Data ) Then
    begin
      Result := TRUE;

      Stream.Frequency  := 44100;
      Stream.Channels   := 2;
      Stream.Length     := ModPlug_GetLength( PModPlugFile( Stream._Data ) );
      Stream.BufferSize := 64 * 1024;
      zgl_GetMem( Pointer( Stream.Buffer ), Stream.BufferSize );
    end else
      Result := FALSE;
end;

function mp_DecoderRead;
begin
  if not mpInit Then exit;

  Result := ModPlug_Read( PModPlugFile( Stream._Data ), Buffer, Count );
  _End := Result = 0;
end;

procedure mp_DecoderLoop;
begin
  if not mpInit Then exit;

  ModPlug_Seek( PModPlugFile( Stream._Data ), 0 );
end;

procedure mp_DecoderClose;
begin
  if not mpInit Then exit;

  ModPlug_Unload( PModPlugFile( Stream._Data ) );
  Stream._Data := nil;
end;

var
  i : Integer;
initialization
  for i := 0 to MAX_FORMATS - 1 do
    begin
      Decoders[ i ].Ext   := FORMATS[ i ];
      Decoders[ i ].Open  := mp_DecoderOpen;
      Decoders[ i ].Read  := mp_DecoderRead;
      Decoders[ i ].Loop  := mp_DecoderLoop;
      Decoders[ i ].Close := mp_DecoderClose;
      zgl_Reg( SND_FORMAT_EXTENSION, PChar( FORMATS[ i ] ) );
      zgl_Reg( SND_FORMAT_FILE_LOADER, nil );
      zgl_Reg( SND_FORMAT_MEM_LOADER,  nil );
      zgl_Reg( SND_FORMAT_DECODER, @Decoders[ i ] );
    end;

finalization
  if mpInit Then
    dlclose( mpLibrary );

end.
