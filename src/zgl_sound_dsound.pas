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
unit zgl_sound_dsound;

{$I zgl_config.cfg}

interface
uses
  Windows;

const
  _FACDS                      = $878; { DirectSound's facility code }
  MAKE_DSHRESULT_R            = (1 shl 31) or (_FACDS shl 16);

  DS_OK                       = $00000000;
  DSSCL_PRIORITY              = $00000002;
  DSSCL_EXCLUSIVE             = $00000003;

  DSBCAPS_PRIMARYBUFFER       = $00000001;
  DSBCAPS_STATIC              = $00000002;
  DSBCAPS_LOCHARDWARE         = $00000004;
  DSBCAPS_LOCSOFTWARE         = $00000008;
  DSBCAPS_CTRLFREQUENCY       = $00000020;
  DSBCAPS_CTRLPAN             = $00000040;
  DSBCAPS_CTRLVOLUME          = $00000080;
  DSBCAPS_CTRLPOSITIONNOTIFY  = $00000100;
  DSBCAPS_GLOBALFOCUS         = $00008000;
  DSBCAPS_GETCURRENTPOSITION2 = $00010000;

  DSBSTATUS_PLAYING           = $00000001;
  DSBSTATUS_BUFFERLOST        = $00000002;

  DSBPLAY_LOOPING             = $00000001;

  DSERR_BUFFERLOST            = MAKE_DSHRESULT_R or 150;

type
  zglTBufferDesc = record
    FormatCode       : Word;
    ChannelNumber    : Word;
    SampleRate       : LongWord;
    BytesPerSecond   : LongWord;
    BytesPerSample   : Word;
    BitsPerSample    : Word;
    cbSize           : Word;
  end;


  IDirectSoundBuffer = interface;
  IDirectSound       = interface;

  TDSBUFFERDESC = packed record
    dwSize          : LongWord;
    dwFlags         : LongWord;
    dwBufferBytes   : LongWord;
    dwReserved      : LongWord;
    lpwfxFormat     : Pointer;
    guid3DAlgorithm : TGUID;
  end;

  PDSBPositionNotify = ^TDSBPositionNotify;
  TDSBPositionNotify = packed record
    dwOffset: DWORD;
    hEventNotify: THandle;
  end;

  IDirectSound = interface (IUnknown)
    ['{279AFA83-4981-11CE-A521-0020AF0BE560}']
    function CreateSoundBuffer(const lpDSBufferDesc: TDSBufferDesc;
        out lpIDirectSoundBuffer: IDirectSoundBuffer;
        pUnkOuter: IUnknown) : HResult; stdcall;
    function GetCaps(lpDSCaps: Pointer) : HResult; stdcall;
    function DuplicateSoundBuffer(lpDsbOriginal: IDirectSoundBuffer;
        out lpDsbDuplicate: IDirectSoundBuffer) : HResult; stdcall;
    function SetCooperativeLevel(hwnd: HWND; dwLevel: LongWord) : HResult; stdcall;
    function Compact: HResult; stdcall;
    function GetSpeakerConfig(var lpdwSpeakerConfig: LongWord) : HResult; stdcall;
    function SetSpeakerConfig(dwSpeakerConfig: LongWord) : HResult; stdcall;
    function Initialize(lpGuid: PGUID) : HResult; stdcall;
  end;

  IDirectSoundBuffer = interface (IUnknown)
    ['{279AFA85-4981-11CE-A521-0020AF0BE560}']
    function GetCaps(lpDSCaps: Pointer) : HResult; stdcall;
    function GetCurrentPosition
        (lpdwPlayPosition, lpdwReadPosition : PLongWord) : HResult; stdcall;
    function GetFormat(lpwfxFormat: Pointer; dwSizeAllocated: LongWord;
        lpdwSizeWritten: PLongWord) : HResult; stdcall;
    function GetVolume(var lplVolume: integer) : HResult; stdcall;
    function GetPan(var lplPan: integer) : HResult; stdcall;
    function GetFrequency(var lpdwFrequency: LongWord) : HResult; stdcall;
    function GetStatus(var lpdwStatus: LongWord) : HResult; stdcall;
    function Initialize(lpDirectSound: IDirectSound;
        const lpcDSBufferDesc: TDSBufferDesc) : HResult; stdcall;
    function Lock(dwWriteCursor, dwWriteBytes: LongWord;
        var lplpvAudioPtr1: Pointer; var lpdwAudioBytes1: LongWord;
        var lplpvAudioPtr2: Pointer; var lpdwAudioBytes2: LongWord;
        dwFlags: LongWord) : HResult; stdcall;
    function Play(dwReserved1,dwReserved2,dwFlags: LongWord) : HResult; stdcall;
    function SetCurrentPosition(dwPosition: LongWord) : HResult; stdcall;
    function SetFormat(lpcfxFormat: Pointer) : HResult; stdcall;
    function SetVolume(lVolume: integer) : HResult; stdcall;
    function SetPan(lPan: integer) : HResult; stdcall;
    function SetFrequency(dwFrequency: LongWord) : HResult; stdcall;
    function Stop: HResult; stdcall;
    function Unlock(lpvAudioPtr1: Pointer; dwAudioBytes1: LongWord;
        lpvAudioPtr2: Pointer; dwAudioBytes2: LongWord) : HResult; stdcall;
    function Restore: HResult; stdcall;
  end;

  IDirectSoundNotify = interface(IUnknown)
    ['{b0210783-89cd-11d0-af08-00a0c925cd16}']
    function SetNotificationPositions(dwPositionNotifies: DWORD; pcPositionNotifies: PDSBPositionNotify): HResult; stdcall;
  end;

function  InitDSound : Boolean;
procedure FreeDSound;

procedure dsu_CreateBuffer( var Buffer : IDirectSoundBuffer; const BufferSize : LongWord; const Format : Pointer );
procedure dsu_FillData( var Buffer : IDirectSoundBuffer; Data : Pointer; const DataSize : LongWord; const Pos : LongWord = 0 );
function  dsu_CalcPos( const X, Y, Z : Single; var Volume : Single ) : Integer;
function  dsu_CalcVolume( const Volume : Single ) : Integer;

var
  dsound_Library    : HMODULE;
  DirectSoundCreate : function (lpGuid: PGUID; out ppDS: IDirectSound; pUnkOuter: IUnknown): HResult; stdcall;

  ds_Device      : IDirectSound;
  ds_Position    : array[ 0..2 ] of Single;
  ds_Plane       : array[ 0..2 ] of Single;
  ds_Orientation : array[ 0..5 ] of Single = ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0 );

implementation
uses
  zgl_types,
  zgl_sound,
  zgl_log,
  zgl_utils;

function CoInitialize(pvReserved: Pointer): HResult; stdcall; external 'ole32.dll' name 'CoInitialize';
procedure CoUninitialize; stdcall; external 'ole32.dll' name 'CoUninitialize';

function InitDSound;
begin
  CoInitialize( nil );
  dsound_Library    := dlopen( 'DSound.dll' );
  DirectSoundCreate := dlsym( dsound_Library, 'DirectSoundCreate' );
  Result            := dsound_Library <> 0;
end;

procedure FreeDSound;
begin
  dlclose( dsound_Library );
  CoUninitialize();
end;

procedure dsu_CreateBuffer;
  var
    bufferDesc : TDSBufferDesc;
begin
  FillChar( bufferDesc, SizeOf( TDSBUFFERDESC ), 0 );
  with bufferDesc do
    begin
      dwSize  := SizeOf( TDSBUFFERDESC );
      dwFlags := DSBCAPS_LOCSOFTWARE or DSBCAPS_CTRLPAN or DSBCAPS_CTRLVOLUME or DSBCAPS_CTRLFREQUENCY or DSBCAPS_CTRLPOSITIONNOTIFY or
                 DSBCAPS_GETCURRENTPOSITION2;
      dwBufferBytes := BufferSize;
      lpwfxFormat   := Format;
    end;

  ds_Device.CreateSoundBuffer( bufferDesc, Buffer, nil );
end;

procedure dsu_FillData;
  var
    block1, block2 : Pointer;
    b1Size, b2Size : LongWord;
begin
  Buffer.Lock( Pos, DataSize, block1, b1Size, block2, b2Size, 0 );
  Move( Data^, block1^, b1Size );
  if b2Size <> 0 Then Move( Pointer( Ptr( Data ) + b1Size )^, block2^, b2Size );
  Buffer.Unlock( block1, b1Size, block2, b2Size );
end;

function dsu_CalcPos;
  var
    dist, angle : Single;
begin
  ds_Plane[ 0 ] := ds_Orientation[ 1 ] * ds_Orientation[ 5 ] - ds_Orientation[ 2 ] * ds_Orientation[ 4 ];
  ds_Plane[ 1 ] := ds_Orientation[ 2 ] * ds_Orientation[ 3 ] - ds_Orientation[ 0 ] * ds_Orientation[ 5 ];
  ds_Plane[ 2 ] := ds_Orientation[ 0 ] * ds_Orientation[ 4 ] - ds_Orientation[ 1 ] * ds_Orientation[ 3 ];

  dist := sqrt( sqr( X - ds_Position[ 0 ] ) + sqr( Y - ds_Position[ 1 ] ) + sqr( Z - ds_Position[ 2 ] ) );
  if dist = 0 then
    angle := 0
  else
    angle := ( ds_Plane[ 0 ] * ( X - ds_Position[ 0 ] ) + ds_Plane[ 1 ] * ( Y - ds_Position[ 1 ] ) + ds_Plane[ 2 ] * ( Z - ds_Position[ 2 ] ) ) * dist;
  Result := Trunc( 10000 * angle );
  if Result < -10000 Then Result := -10000;
  if Result > 10000  Then Result := 10000;

  Volume := 1 - dist / 100;
  if Volume < 0 Then Volume := 0;
end;

function dsu_CalcVolume;
begin
  if Volume = 0 Then
    Result := -10000
  else
    Result := - Round( 1000 * ln( 1 / Volume ) );
end;

end.
