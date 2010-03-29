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
unit zgl_log;

{$I zgl_config.cfg}

interface
uses
  zgl_file;

procedure log_Init;
procedure log_Close;
procedure log_Add( const Message : AnsiString; const Timings : Boolean = TRUE );
procedure log_Flush;
function  log_Timing : AnsiString;

var
  log      : zglTFile;
  logStart : LongWord;
  logFile  : PChar = 'log.txt';

implementation
uses
  zgl_application,
  zgl_main,
  zgl_timers,
  zgl_utils;

procedure log_Init;
  var
    i  : Integer;
    es : String;
begin
  if ( app_Flags and APP_USE_LOG = 0 ) Then exit;
  if log <> FILE_ERROR Then exit;
  app_Log := TRUE;
  logStart := Round( timer_GetTicks() );

  file_Open( log, logFile, FOM_CREATE );
  // crazy code :)
  for i := 0 to length( cs_ZenGL ) + 7 do
    es := es + '=';
  log_Add( es, FALSE );
  log_Add( '=== ' + cs_ZenGL + ' ===', FALSE );
  log_Add( es, FALSE );
  log_Add( 'Begin' );
end;

procedure log_Close;
begin
  if log <> FILE_ERROR Then
    file_Close( log );
end;

procedure log_Add;
  var
    str : AnsiString;
begin
  if not app_Log Then exit;
  {$IFDEF LINUX}
  writeln( Message );
  {$ENDIF}
  if Timings Then
    str := log_Timing + Message + #13#10
  else
    str := Message + #13#10;

  file_Write( log, str[ 1 ], length( str ) );

  {$IFDEF USE_LOG_FLUSH}
  log_Flush;
  {$ENDIF}
end;

procedure log_Flush;
begin
  if log <> FILE_ERROR Then
    file_Flush( log );
end;

function log_Timing;
  var
    v : LongWord;
begin
  v := Round( timer_GetTicks() ) - logstart;
  case V of
    0..9:               Result := '[0000000' + u_IntToStr( v ) + 'ms] ';
    10..99:             Result := '[000000'  + u_IntToStr( v ) + 'ms] ';
    100..999:           Result := '[00000'   + u_IntToStr( v ) + 'ms] ';
    1000..9999:         Result := '[0000'    + u_IntToStr( v ) + 'ms] ';
    10000..99999:       Result := '[000'     + u_IntToStr( v ) + 'ms] ';
    100000..999999:     Result := '[00'      + u_IntToStr( v ) + 'ms] ';
    1000000..9999999:   Result := '[0'       + u_IntToStr( v ) + 'ms] ';
    10000000..99999999: Result := '['        + u_IntToStr( v ) + 'ms] ';
  else
    Result := '[00000000ms]';
  end;
end;

end.
