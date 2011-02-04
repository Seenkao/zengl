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
unit zgl_file;

{$I zgl_config.cfg}

interface

uses
  {$IFDEF LINUX_OR_DARWIN}
  BaseUnix,
  {$ENDIF}
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  zgl_types;

{$IFDEF LINUX_OR_DARWIN}
type zglTFile = LongInt;
{$ENDIF}
{$IFDEF WINDOWS}
type zglTFile = THandle;
{$ENDIF}

type zglTFileList = zglTStringList;

const
  FILE_ERROR = {$IFNDEF WINDOWS} 0 {$ELSE} LongWord( -1 ) {$ENDIF};

  // Open Mode
  FOM_CREATE = $01; // Create
  FOM_OPENR  = $02; // Read
  FOM_OPENRW = $03; // Read&Write

  // Seek Mode
  FSM_SET    = $01;
  FSM_CUR    = $02;
  FSM_END    = $03;

function  file_Open( var FileHandle : zglTFile; const FileName : String; Mode : Byte ) : Boolean;
function  file_MakeDir( const Directory : String ) : Boolean;
function  file_Remove( const Name : String ) : Boolean;
function  file_Exists( const Name : String ) : Boolean;
function  file_Seek( FileHandle : zglTFile; Offset, Mode : Integer ) : LongWord;
function  file_GetPos( FileHandle : zglTFile ) : LongWord;
function  file_Read( FileHandle : zglTFile; var Buffer; Bytes : LongWord ) : LongWord;
function  file_Write( FileHandle : zglTFile; const Buffer; Bytes : LongWord ) : LongWord;
function  file_GetSize( FileHandle : zglTFile ) : LongWord;
procedure file_Flush( FileHandle : zglTFile );
procedure file_Close( var FileHandle : zglTFile );
procedure file_Find( const Directory : String; var List : zglTFileList; FindDir : Boolean );
function  file_GetName( const FileName : String ) : String;
function  file_GetExtension( const FileName : String ) : String;
function  file_GetDirectory( const FileName : String ) : String;
procedure file_SetPath( const Path : String );

function _file_GetName( const FileName : String ) : PChar;
function _file_GetExtension( const FileName : String ) : PChar;
function _file_GetDirectory( const FileName : String ) : PChar;

{$IFDEF DARWIN}
function darwin_GetRes( const FileName : String ) : String;
{$ENDIF}

{$IFDEF LINUX_OR_DARWIN}
const
  { read/write search permission for everyone }
  MODE_MKDIR = S_IWUSR or S_IRUSR or
               S_IWGRP or S_IRGRP or
               S_IWOTH or S_IROTH or
               S_IXUSR or S_IXGRP or S_IXOTH;

type
  PPDirEnt      = ^PDirEnt;
  PPPDirEnt     = ^PPDirEnt;
  TSelectorFunc = function(const p1: PDirEnt): Integer; cdecl;
  TCompareFunc  = function(const p1, p2: Pointer): Integer; cdecl;

function scandir(__dir:Pchar; __namelist:PPPdirent; __selector:TSelectorfunc; __cmp:TComparefunc):longint;cdecl;external 'libc' name 'scandir';
function free( ptr : Pointer ):longint;cdecl;external 'libc' name 'free';
{$ENDIF}

implementation
uses
  {$IFDEF DARWIN}
  zgl_application,
  {$ENDIF}
  zgl_utils;

var
  filePath : String = '';

function GetDir( const Path : String ) : String;
  var
    len : Integer;
begin
  len := length( Path );
  if ( len > 0 ) and ( Path[ len ] <> '/' ) {$IFDEF WINDOWS} and ( Path[ len ] <> '\' ) {$ENDIF} Then
    Result := Path + '/'
  else
    Result := u_CopyStr( Path );
end;

function file_Open( var FileHandle : zglTFile; const FileName : String; Mode : Byte ) : Boolean;
begin
{$IFDEF LINUX_OR_DARWIN}
  case Mode of
    FOM_CREATE: FileHandle := FpOpen( filePath + FileName, O_Creat or O_Trunc or O_RdWr );
    FOM_OPENR:  FileHandle := FpOpen( filePath + FileName, O_RdOnly );
    FOM_OPENRW: FileHandle := FpOpen( filePath + FileName, O_RdWr );
  end;
{$ENDIF}
{$IFDEF WINDOWS}
  case Mode of
    FOM_CREATE: FileHandle := CreateFile( PChar( filePath + FileName ), GENERIC_ALL, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0 );
    FOM_OPENR:  FileHandle := CreateFile( PChar( filePath + FileName ), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0 );
    FOM_OPENRW: FileHandle := CreateFile( PChar( filePath + FileName ), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0 );
  end;
{$ENDIF}
  Result := FileHandle <> FILE_ERROR;
end;

function file_MakeDir( const Directory : String ) : Boolean;
begin
{$IFDEF LINUX_OR_DARWIN}
  Result := FpMkdir( Directory, MODE_MKDIR ) = FILE_ERROR;
{$ENDIF}
{$IFDEF WINDOWS}
  Result := CreateDirectory( PChar( Directory ), nil );
{$ENDIF}
end;

function file_Remove( const Name : String ) : Boolean;
  var
  {$IFDEF LINUX_OR_DARWIN}
    status : Stat;
  {$ENDIF}
  {$IFDEF WINDOWS}
    attr   : LongWord;
  {$ENDIF}
    i    : Integer;
    dir  : Boolean;
    path : String;
    list : zglTFileList;
begin
  if not file_Exists( Name ) Then
    begin
      Result := FALSE;
      exit;
    end;

{$IFDEF LINUX_OR_DARWIN}
  FpStat( filePath + Name, status );
  dir := fpS_ISDIR( status.st_mode );
{$ENDIF}
{$IFDEF WINDOWS}
  attr := GetFileAttributes( PChar( filePath + Name ) );
  dir  := attr and FILE_ATTRIBUTE_DIRECTORY > 0;
{$ENDIF}

  if dir Then
    begin
      path := GetDir( Name );

      file_Find( path, list, FALSE );
      for i := 0 to list.Count - 1 do
        file_Remove( path + list.Items[ i ] );

      file_Find( path, list, TRUE );
      for i := 2 to list.Count - 1 do
        file_Remove( path + list.Items[ i ] );

      {$IFDEF LINUX_OR_DARWIN}
      Result := FpRmdir( filePath + Name ) = 0;
      {$ENDIF}
      {$IFDEF WINDOWS}
      Result := RemoveDirectory( PChar( filePath + Name ) );
      {$ENDIF}
    end else
      {$IFDEF LINUX_OR_DARWIN}
      Result := FpUnlink( filePath + Name ) = 0;
      {$ENDIF}
      {$IFDEF WINDOWS}
      Result := DeleteFile( PChar( filePath + Name ) );
      {$ENDIF}
end;

function file_Exists( const Name : String ) : Boolean;
  var
  {$IFDEF LINUX_OR_DARWIN}
    status : Stat;
  {$ENDIF}
  {$IFDEF WINDOWS}
    attr : LongWord;
  {$ENDIF}
begin
{$IFDEF LINUX_OR_DARWIN}
  Result := FpStat( filePath + Name, status ) = 0;
{$ENDIF}
{$IFDEF WINDOWS}
  Result := GetFileAttributes( PChar( filePath + Name ) ) <> $FFFFFFFF;
{$ENDIF}
end;

function file_Seek( FileHandle : zglTFile; Offset, Mode : Integer ) : LongWord;
begin
{$IFDEF LINUX_OR_DARWIN}
  case Mode of
    FSM_SET: Result := FpLseek( FileHandle, Offset, SEEK_SET );
    FSM_CUR: Result := FpLseek( FileHandle, Offset, SEEK_CUR );
    FSM_END: Result := FpLseek( FileHandle, Offset, SEEK_END );
  end;
{$ENDIF}
{$IFDEF WINDOWS}
  case Mode of
    FSM_SET: Result := SetFilePointer( FileHandle, Offset, nil, FILE_BEGIN );
    FSM_CUR: Result := SetFilePointer( FileHandle, Offset, nil, FILE_CURRENT );
    FSM_END: Result := SetFilePointer( FileHandle, Offset, nil, FILE_END );
  end;
{$ENDIF}
end;

function file_GetPos( FileHandle : zglTFile ) : LongWord;
begin
{$IFDEF LINUX_OR_DARWIN}
  Result := FpLseek( FileHandle, 0, SEEK_CUR );
{$ENDIF}
{$IFDEF WINDOWS}
  Result := SetFilePointer( FileHandle, 0, nil, FILE_CURRENT );
{$ENDIF}
end;

function file_Read( FileHandle : zglTFile; var Buffer; Bytes : LongWord ) : LongWord;
begin
{$IFDEF LINUX_OR_DARWIN}
  Result := FpLseek( FileHandle, 0, SEEK_CUR );
  if Result + Bytes > file_GetSize( FileHandle ) Then
    Result := file_GetSize( FileHandle ) - Result
  else
    Result := Bytes;
  FpRead( FileHandle, Buffer, Bytes );
{$ENDIF}
{$IFDEF WINDOWS}
  ReadFile( FileHandle, Buffer, Bytes, Result, nil );
{$ENDIF}
end;

function file_Write( FileHandle : zglTFile; const Buffer; Bytes : LongWord ) : LongWord;
begin
{$IFDEF LINUX_OR_DARWIN}
  Result := FpLseek( FileHandle, 0, SEEK_CUR );
  if Result + Bytes > file_GetSize( FileHandle ) Then
    Result := file_GetSize( FileHandle ) - Result
  else
    Result := Bytes;
  FpWrite( FileHandle, Buffer, Bytes );
{$ENDIF}
{$IFDEF WINDOWS}
  WriteFile( FileHandle, Buffer, Bytes, Result, nil );
{$ENDIF}
end;

function file_GetSize( FileHandle : zglTFile ) : LongWord;
  {$IFDEF LINUX_OR_DARWIN}
  var
    tmp : LongWord;
  {$ENDIF}
begin
{$IFDEF LINUX_OR_DARWIN}
  // Весьма безумная реализация 8)
  tmp    := FpLseek( FileHandle, 0, SEEK_CUR );
  Result := FpLseek( FileHandle, 0, SEEK_END );
  FpLseek( FileHandle, tmp, SEEK_SET );
{$ENDIF}
{$IFDEF WINDOWS}
  Result := GetFileSize( FileHandle, nil );
{$ENDIF}
end;

procedure file_Flush( FileHandle : zglTFile );
begin
{$IFDEF LINUX_OR_DARWIN}
  //fflush( FileHandle );
{$ENDIF}
{$IFDEF WINDOWS}
  FlushFileBuffers( FileHandle );
{$ENDIF}
end;

procedure file_Close( var FileHandle : zglTFile );
begin
{$IFDEF LINUX_OR_DARWIN}
  FpClose( FileHandle );
  FileHandle := 0;
{$ENDIF}
{$IFDEF WINDOWS}
  CloseHandle( FileHandle );
  FileHandle := 0;
{$ENDIF}
end;

{$IFDEF LINUX_OR_DARWIN}
function filter_file( const p1 : Pdirent ) : Integer; cdecl;
begin
  Result := Byte( p1.d_type = 8 );
end;
function filter_dir( const p1 : Pdirent ) : Integer; cdecl;
begin
  Result := Byte( p1.d_type = 4 );
end;
{$ENDIF}

procedure file_Find( const Directory : String; var List : zglTFileList; FindDir : Boolean );
  {$IFDEF LINUX_OR_DARWIN}
  var
    i     : Integer;
    FList : array of Pdirent;
  {$ENDIF}
  {$IFDEF WINDOWS}
  var
    First : THandle;
    FList : {$IFDEF FPC} WIN32FINDDATAA {$ELSE} WIN32_FIND_DATA {$ENDIF};
  {$ENDIF}
begin
  List.Count := 0;
{$IFDEF LINUX_OR_DARWIN}
  if FindDir Then
    List.Count := scandir( PChar( filePath + Directory ), @FList, filter_dir, nil )
  else
    List.Count := scandir( PChar( filePath + Directory ), @FList, filter_file, nil );
  if List.Count <> -1 Then
    begin
      SetLength( List.Items, List.Count );
      for i := 0 to List.Count - 1 do
        begin
          List.Items[ i ] := String( FList[ i ].d_name );
          Free( FList[ i ] );
        end;
      SetLength( FList, 0 );
    end;
{$ENDIF}
{$IFDEF WINDOWS}
  First := FindFirstFile( PChar( GetDir( filePath + Directory ) + '*' ), FList );
  repeat
    if FindDir Then
      begin
        if FList.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0 Then continue;
      end else
        if FList.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY > 0 Then continue;
    SetLength( List.Items, List.Count + 1 );
    List.Items[ List.Count ] := FList.cFileName;
    INC( List.Count );
  until not FindNextFile( First, FList );
  FindClose( First );
{$ENDIF}

  if List.Count > 2 Then
    u_SortList( List, 0, List.Count - 1 );
end;

procedure GetStr( const Str : String; var Result : String; const d : Char; const b : Boolean );
  var
    i, pos, l : Integer;
begin
  pos := 0;
  l := length( Str );
  for i := l downto 1 do
    if Str[ i ] = d Then
      begin
        pos := i;
        break;
      end;
  if b Then
    Result := copy( Str, 1, pos )
  else
    Result := copy( Str, l - ( l - pos ) + 1, ( l - pos ) );
end;

function file_GetName( const FileName : String ) : String;
  var
    tmp : String;
begin
  GetStr( FileName, Result, '/', FALSE );
  {$IFDEF WINDOWS}
  if Result = FileName Then
    GetStr( FileName, Result, '\', FALSE );
  {$ENDIF}
  GetStr( Result, tmp, '.', FALSE );
  Result := copy( Result, 1, length( Result ) - length( tmp ) - 1 );
end;

function file_GetExtension( const FileName : String ) : String;
begin
  GetStr( FileName, Result, '.', FALSE );
end;

function file_GetDirectory( const FileName : String ) : String;
begin
  GetStr( FileName, Result, '/', TRUE );
  {$IFDEF WINDOWS}
  if Result = '' Then
    GetStr( FileName, Result, '\', TRUE );
  {$ENDIF}
end;

procedure file_SetPath( const Path : String );
begin
  filePath := GetDir( Path );
end;

{$IFDEF DARWIN}
function darwin_GetRes( const FileName : String ) : String;
  var
    len : Integer;
begin
  len := length( FileName );
  if ( len > 0 ) and ( FileName[ 1 ] <> '/' ) Then
    Result := appWorkDir + 'Contents/Resources/' + FileName
  else
    Result := FileName;
end;
{$ENDIF}

function _file_GetName( const FileName : String ) : PChar;
begin
  Result := u_GetPChar( file_GetName( FileName ) );
end;

function _file_GetExtension( const FileName : String ) : PChar;
begin
  Result := u_GetPChar( file_GetExtension( FileName ) );
end;

function _file_GetDirectory( const FileName : String ) : PChar;
begin
  Result := u_GetPChar( file_GetDirectory( FileName ) );
end;

end.
