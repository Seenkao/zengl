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
unit zgl_memory;

{$I zgl_config.cfg}

interface
uses
  zgl_types;

type
  zglPMemory = ^zglTMemory;
  zglTMemory = record
    Memory   : Pointer;
    Size     : LongWord;
    Position : LongWord;
end;

procedure mem_LoadFromFile( var Memory : zglTMemory; const FileName : String );
procedure mem_SaveToFile( var Memory : zglTMemory; const FileName : String );
function  mem_Seek( var Memory : zglTMemory; const Offset, Mode : LongWord ) : LongWord;
function  mem_Read( var Memory : zglTMemory; var Buffer; const Bytes : LongWord ) : LongWord;
function  mem_ReadSwap( var Memory : zglTMemory; var Buffer; const Bytes : LongWord ) : LongWord;
function  mem_Write( var Memory : zglTMemory; const Buffer; const Bytes : LongWord ) : LongWord;
procedure mem_SetSize( var Memory : zglTMemory; const Size : LongWord );
procedure mem_Free( var Memory : zglTMemory );

{$IFDEF ENDIAN_BIG}
var
  forceNoSwap : Boolean;
{$ENDIF}

implementation
uses
  zgl_main,
  zgl_file;

procedure mem_LoadFromFile;
  var
    f : zglTFile;
begin
  if not file_Exists( FileName ) Then exit;

  file_Open( f, FileName, FOM_OPENR );
  Memory.Size     := file_GetSize( f );
  Memory.Position := 0;
  zgl_GetMem( Memory.Memory, Memory.Size );
  file_Read( f, Memory.Memory^, Memory.Size );
  file_Close( f );
end;

procedure mem_SaveToFile;
  var
    f : zglTFile;
begin
  file_Open( f, FileName, FOM_CREATE );
  file_Write( f, Memory.Memory^, Memory.Size );
  file_Close( f );
end;

function mem_Seek;
begin
  case Mode of
    FSM_SET: Memory.Position := Offset;
    FSM_CUR: Memory.Position := Memory.Position + Offset;
    FSM_END: Memory.Position := Memory.Size + Offset;
  end;
  Result := Memory.Position;
end;

function mem_Read;
begin
  {$IFDEF ENDIAN_BIG}
  if ( Bytes <=4 ) and ( not forceNoSwap ) Then
    begin
      Result := mem_ReadSwap( Memory, Buffer, Bytes );
      exit;
    end;
  {$ENDIF}
  if Bytes > 0 Then
    begin
      Result := Memory.Size - Memory.Position;
      if Result > 0 Then
        begin
          if Result > Bytes Then Result := Bytes;
          Move( Pointer( Ptr( Memory.Memory ) + Memory.Position )^, Buffer, Result );
          INC( Memory.Position, Result );
          exit;
        end;
    end;
  Result := 0;
end;

function mem_ReadSwap;
  var
    i     : LongWord;
    pData : array of Byte;
begin
  {$IFDEF ENDIAN_BIG}
  if forceNoSwap Then
    begin
    Result := mem_Read( Memory, Buffer, Bytes );
    exit;
  end;
  {$ENDIF}
  if Bytes > 0 Then
    begin
      Result := Memory.Size - Memory.Position;
      if Result > 0 Then
        begin
          if Result > Bytes Then Result := Bytes;
          SetLength( pData, Result );
          for i := 0 to Result - 1 do
            begin
              pData[ Result - i - 1 ] := PByte( Ptr( Memory.Memory ) + Memory.Position )^;
              INC( Memory.Position );
            end;
          Move( pData[ 0 ], Buffer, Result );
          SetLength( pData, 0 );
          exit;
        end;
    end;
  Result := 0;
end;

function mem_Write;
begin
  if Bytes = 0 Then
    begin
      Result := 0;
      exit;
    end;
  if Memory.Position + Bytes > Memory.Size Then
    mem_SetSize( Memory, Memory.Position + Bytes );
  Move( Buffer, Pointer( Ptr( Memory.Memory ) + Memory.Position )^, Bytes );
  INC( Memory.Position, Bytes );
  Result := Bytes;
end;

procedure mem_SetSize;
begin
  Memory.Memory := ReAllocMemory( Memory.Memory, Size );
  Memory.Size   := Size;
end;

procedure mem_Free;
begin
  FreeMem( Memory.Memory );
  Memory.Size     := 0;
  Memory.Position := 0;
end;

end.
