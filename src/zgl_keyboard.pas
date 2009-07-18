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
unit zgl_keyboard;

{$I zgl_config.cfg}

interface
uses
  {$IFDEF LINUX}
  X, Xlib, keysym
  {$ENDIF}
  {$IFDEF WIN32}
  Windows
  {$ENDIF}
  {$IFDEF DARWIN}
  MacOSAll
  {$ENDIF}
  ;

const
  K_SYSRQ      = $B7;
  K_PAUSE      = $C5;
  K_ESCAPE     = $01;
  K_ENTER      = $1C;
  K_KP_ENTER   = $9C;

  K_UP         = $C8;
  K_DOWN       = $D0;
  K_LEFT       = $CB;
  K_RIGHT      = $CD;

  K_BACKSPACE  = $0E;
  K_SPACE      = $39;
  K_TAB        = $0F;
  K_TILDE      = $29;

  K_INSERT     = $D2;
  K_DELETE     = $D3;
  K_HOME       = $C7;
  K_END        = $CF;
  K_PAGEUP     = $C9;
  K_PAGEDOWN   = $D1;

  K_CTRL       = $FF - $01;
  K_CTRL_L     = $1D;
  K_CTRL_R     = $9D;
  K_ALT        = $FF - $02;
  K_ALT_L      = $38;
  K_ALT_R      = $B8;
  K_SHIFT      = $FF - $03;
  K_SHIFT_L    = $2A;
  K_SHIFT_R    = $36;
  K_SUPER_L    = $DB;
  K_SUPER_R    = $DC;
  K_APP_MENU   = $DD;

  K_CAPSLOCK   = $3A;
  K_NUMLOCK    = $45;
  K_SCROLL     = $46;

  K_BRACKET_L  = $1A; // [ {
  K_BRACKET_R  = $1B; // ] }
  K_BACKSLASH  = $2B; // \
  K_SLASH      = $35; // /
  K_COMMA      = $33; // ,
  K_DECIMAL    = $34; // .
  K_SEMICOLON  = $27; // : ;
  K_APOSTROPHE = $28; // ' "

  K_0          = $0B;
  K_1          = $02;
  K_2          = $03;
  K_3          = $04;
  K_4          = $05;
  K_5          = $06;
  K_6          = $07;
  K_7          = $08;
  K_8          = $09;
  K_9          = $0A;

  K_MINUS      = $0C;
  K_EQUALS     = $0D;

  K_A          = $1E;
  K_B          = $30;
  K_C          = $2E;
  K_D          = $20;
  K_E          = $12;
  K_F          = $21;
  K_G          = $22;
  K_H          = $23;
  K_I          = $17;
  K_J          = $24;
  K_K          = $25;
  K_L          = $26;
  K_M          = $32;
  K_N          = $31;
  K_O          = $18;
  K_P          = $19;
  K_Q          = $10;
  K_R          = $13;
  K_S          = $1F;
  K_T          = $14;
  K_U          = $16;
  K_V          = $2F;
  K_W          = $11;
  K_X          = $2D;
  K_Y          = $15;
  K_Z          = $2C;

  K_KP_0       = $52;
  K_KP_1       = $4F;
  K_KP_2       = $50;
  K_KP_3       = $51;
  K_KP_4       = $4B;
  K_KP_5       = $4C;
  K_KP_6       = $4D;
  K_KP_7       = $47;
  K_KP_8       = $48;
  K_KP_9       = $49;

  K_KP_SUB     = $4A;
  K_KP_ADD     = $4E;
  K_KP_MUL     = $37;
  K_KP_DIV     = $B5;
  K_KP_DECIMAL = $53;

  K_F1         = $3B;
  K_F2         = $3C;
  K_F3         = $3D;
  K_F4         = $3E;
  K_F5         = $3F;
  K_F6         = $40;
  K_F7         = $41;
  K_F8         = $42;
  K_F9         = $43;
  K_F10        = $44;
  K_F11        = $57;
  K_F12        = $58;

  KA_DOWN      = 0;
  KA_UP        = 1;

function  key_Down( const KeyCode : Byte ) : Boolean;
function  key_Up( const KeyCode : Byte ) : Boolean;
function  key_Press( const KeyCode : Byte ) : Boolean;
function  key_Last( const KeyAction : Byte ) : Byte;
procedure key_BeginReadText( const Text : String; const MaxSymbols : Integer = -1 );
procedure key_EndReadText( var Result : String );
procedure key_ClearState;

procedure key_InputText( const Text : String );
function scancode_to_utf8( const ScanCode : Byte ) : Byte;
{$IFDEF LINUX}
function xkey_to_scancode( XKey, KeyCode : Integer ) : Byte;
function Xutf8LookupString( ic : PXIC; event : PXKeyPressedEvent; buffer_return : PChar; bytes_buffer : Integer; keysym_return : PKeySym; status_return : PStatus ) : integer; cdecl; external;
{$ENDIF}
{$IFDEF WIN32}
function winkey_to_scancode( WinKey : Integer ) : Byte;
{$ENDIF}
{$IFDEF DARWIN}
function mackey_to_scancode( MacKey : Integer ) : Byte;
{$ENDIF}
function  SCA( KeyCode : DWORD ) : DWORD;
procedure DoKeyPress( KeyCode : DWORD );

{$IFDEF DARWIN}
type
  zglTModifier = record
    bit : Integer;
    key : Integer;
  end;
const
  Modifier : array[ 0..2 ] of zglTModifier = ( ( bit: 4096; key: K_CTRL ),
                                               ( bit: 512;  key: K_SHIFT ),
                                               ( bit: 256;  key: K_ALT ) );
{$ENDIF}

var
  keysDown     : array[ 0..255 ] of Boolean;
  keysUp       : array[ 0..255 ] of Boolean;
  keysPress    : array[ 0..255 ] of Boolean;
  keysCanPress : array[ 0..255 ] of Boolean;
  keysText     : String = '';
  keysMax      : Integer;
  keysLast     : array[ 0..1 ] of Byte;
  {$IFDEF LINUX}
  keysRepeat : Integer; // Костыль, да :)
  {$ENDIF}

implementation
uses
  zgl_const,
  zgl_application,
  zgl_utils;

function key_Down;
begin
  Result := keysDown[ KeyCode ];
end;

function key_Up;
begin
  Result := keysUp[ KeyCode ];
end;

function key_Press;
begin
  Result := keysPress[ KeyCode ];
end;

function key_Last;
begin
  Result := keysLast[ KeyAction ];
end;

procedure key_BeginReadText;
begin
  keysText := Text;
  keysMax  := MaxSymbols;
end;

procedure key_EndReadText;
begin
  Result := keysText;
end;

procedure key_ClearState;
  var
    i : Integer;
begin
  {$IFDEF LINUX}
  if keysRepeat < 2 Then
  {$ENDIF}
  for i := 0 to 255 do
    begin
      keysUp      [ i ] := FALSE;
      keysPress   [ i ] := FALSE;
      keysCanPress[ i ] := TRUE;
    end;
  keysLast[ KA_DOWN ] := 0;
  keysLast[ KA_UP   ] := 0;
end;

procedure key_InputText;
  var
    c : Char;
begin
  if ( u_Length( keysText ) < keysMax ) or ( keysMax = -1 ) Then
    begin
      if ( app_Flags and APP_USE_ENGLISH_INPUT > 0 ) and
         ( Text[ 1 ] <> ' ' )  Then
        begin
          c := Char( scancode_to_utf8( keysLast[ 0 ] ) );
          if c <> #0 Then
            keysText := keysText + c;
        end else
          keysText := keysText + Text;
    end;
end;

// Костыли мои костыли :)
function scancode_to_utf8;
begin
  Result := 0;

  case ScanCode of
    K_TILDE:  Result := 96;
    K_MINUS,
    K_KP_SUB: Result := 45;
    K_EQUALS: Result := 61;

    K_0, K_KP_0: Result := 48;
    K_1, K_KP_1: Result := 49;
    K_2, K_KP_2: Result := 50;
    K_3, K_KP_3: Result := 51;
    K_4, K_KP_4: Result := 52;
    K_5, K_KP_5: Result := 53;
    K_6, K_KP_6: Result := 54;
    K_7, K_KP_7: Result := 55;
    K_8, K_KP_8: Result := 56;
    K_9, K_KP_9: Result := 57;

    K_KP_MUL: Result := 42;
    K_KP_ADD: Result := 43;

    K_A: Result := 97;
    K_B: Result := 98;
    K_C: Result := 99;
    K_D: Result := 100;
    K_E: Result := 101;
    K_F: Result := 102;
    K_G: Result := 103;
    K_H: Result := 104;
    K_I: Result := 105;
    K_J: Result := 106;
    K_K: Result := 107;
    K_L: Result := 108;
    K_M: Result := 109;
    K_N: Result := 110;
    K_O: Result := 111;
    K_P: Result := 112;
    K_Q: Result := 113;
    K_R: Result := 114;
    K_S: Result := 115;
    K_T: Result := 116;
    K_U: Result := 117;
    K_V: Result := 118;
    K_W: Result := 119;
    K_X: Result := 120;
    K_Y: Result := 121;
    K_Z: Result := 122;

    K_BRACKET_L:  Result := 91;
    K_BRACKET_R:  Result := 93;
    K_BACKSLASH:  Result := 92;
    K_SLASH,
    K_KP_DIV:     Result := 47;
    K_COMMA:      Result := 44;
    K_DECIMAL,
    K_KP_DECIMAL: Result := 46;
    K_SEMICOLON:  Result := 59;
    K_APOSTROPHE: Result := 39;
  end;

  if keysDown[ K_SHIFT ] and
     ( ScanCode <> K_KP_0 ) and ( ScanCode <> K_KP_1 ) and
     ( ScanCode <> K_KP_2 ) and ( ScanCode <> K_KP_3 ) and
     ( ScanCode <> K_KP_4 ) and ( ScanCode <> K_KP_5 ) and
     ( ScanCode <> K_KP_6 ) and ( ScanCode <> K_KP_7 ) and
     ( ScanCode <> K_KP_8 ) and ( ScanCode <> K_KP_9 ) and
     ( ScanCode <> K_KP_DIV ) and ( ScanCode <> K_KP_MUL) and
     ( ScanCode <> K_KP_SUB ) and ( ScanCode <> K_KP_ADD ) Then
    case Result of
      96: Result := 126; // ~
      45: Result := 95;  // _
      61: Result := 43;  // +

      48: Result := 41; // (
      49: Result := 33; // !
      50: Result := 64; // @
      51: Result := 35; // #
      52: Result := 36; // $
      53: Result := 37; // %
      54: Result := 94; // ^
      55: Result := 38; // &
      56: Result := 42; // *
      57: Result := 40; // (

      97..122: Result := Result - 32;

      91: Result := 123; // {
      93: Result := 125; // }
      92: Result := 124; // |
      47: Result := 63;  // ?
      44: Result := 60;  // <
      46: Result := 62;  // >
      59: Result := 58;  // :
      39: Result := 34;  // "
    end;
end;

{$IFDEF LINUX}
// Большинство сканкодов можно получить простым преобразованием, закомментированные
// оставил себе на память :)
function xkey_to_scancode;
begin
  case XKey of
    //XK_Sys_Req:      Result := K_SYSRQ;
    XK_Pause:        Result := K_PAUSE;
    //XK_Escape:       Result := K_ESCAPE;
    //XK_Return:       Result := K_ENTER;*)
    //XK_KP_Enter:     Result := K_KP_ENTER;

    XK_Up:           Result := K_UP;
    XK_Down:         Result := K_DOWN;
    XK_Left:         Result := K_LEFT;
    XK_Right:        Result := K_RIGHT;

    //XK_BackSpace:    Result := K_BACKSPACE;
    //XK_Space:        Result := K_SPACE;
    //XK_Tab:          Result := K_TAB;
    //XK_Grave:        Result := K_TILDE;

    XK_Insert:       Result := K_INSERT;
    XK_Delete:       Result := K_DELETE;
    XK_Home:         Result := K_HOME;
    XK_End:          Result := K_END;
    XK_Page_Up:      Result := K_PAGEUP;
    XK_Page_Down:    Result := K_PAGEDOWN;

    //XK_Control_L:    Result := K_CTRL_L;
    XK_Control_R:    Result := K_CTRL_R;
    //XK_Alt_L:        Result := K_ALT_L;
    XK_Alt_R:        Result := K_ALT_R;
    //XK_Shift_L:      Result := K_SHIFT_L;
    //XK_Shift_R:      Result := K_SHIFT_R;
    XK_Super_L:      Result := K_SUPER_L;
    XK_Super_R:      Result := K_SUPER_R;
    XK_Menu:         Result := K_APP_MENU;

    //XK_Caps_Lock:    Result := K_CAPSLOCK;
    //XK_Num_Lock:     Result := K_NUMLOCK;
    //XK_Scroll_Lock:  Result := K_SCROLL;

    //XK_BracketLeft:  Result := K_BRACKET_L;
    //XK_BracketRight: Result := K_BRACKET_R;
    //XK_BackSlash:    Result := K_BACKSLASH;
    //XK_Slash:        Result := K_SLASH;
    //XK_Comma:        Result := K_COMMA;
    //XK_Period:       Result := K_DECIMAL;
    //XK_Semicolon:    Result := K_SEMICOLON;
    //XK_Apostrophe:   Result := K_APOSTROPHE;

    //XK_Minus:        Result := K_MINUS;
    //XK_Equal:        Result := K_EQUALS;

    //XK_KP_Insert,
    //XK_KP_0:         Result := K_KP_0;
    //XK_KP_End,
    //XK_KP_1:         Result := K_KP_1;
    //XK_KP_Down,
    //XK_KP_2:         Result := K_KP_2;
    //XK_KP_Page_Down,
    //XK_KP_3:         Result := K_KP_3;
    //XK_KP_Left,
    //XK_KP_4:         Result := K_KP_4;
    //XK_KP_5:         Result := K_KP_5;
    //XK_KP_Right,
    //XK_KP_6:         Result := K_KP_6;
    //XK_KP_Home,
    //XK_KP_7:         Result := K_KP_7;
    //XK_KP_Up,
    //XK_KP_8:         Result := K_KP_8;
    //XK_KP_Page_Up,
    //XK_KP_9:         Result := K_KP_9;

    //XK_KP_Subtract:  Result := K_KP_SUB;
    //XK_KP_Add:       Result := K_KP_ADD;
    //XK_KP_Multiply:  Result := K_KP_MUL;
    XK_KP_Divide:    Result := K_KP_DIV;
    //XK_KP_Delete,
    //XK_KP_Decimal:   Result := K_KP_DECIMAL;
  else
    Result := ( KeyCode - 8 ) and $FF;
  end;
end;
{$ENDIF}

{$IFDEF WIN32}
function winkey_to_scancode;
begin
  case WinKey of
    $26: Result := K_UP;
    $28: Result := K_DOWN;
    $25: Result := K_LEFT;
    $27: Result := K_RIGHT;

    $2D: Result := K_INSERT;
    $2E: Result := K_DELETE;
    $24: Result := K_HOME;
    $23: Result := K_END;
    $21: Result := K_PAGEUP;
    $22: Result := K_PAGEDOWN;
  else
    Result := MapVirtualKey( WinKey, 0 );
  end;
end;
{$ENDIF}

{$IFDEF DARWIN}
function mackey_to_scancode;
begin
  case MacKey of
    //: Result := K_SYSRQ;
    $71: Result := K_PAUSE;
    $35: Result := K_ESCAPE;
    $24: Result := K_ENTER;
    $4C: Result := K_KP_ENTER;

    $7E: Result := K_UP;
    $7D: Result := K_DOWN;
    $7B: Result := K_LEFT;
    $7C: Result := K_RIGHT;

    $33: Result := K_BACKSPACE;
    $31: Result := K_SPACE;
    $30: Result := K_TAB;

    $72 : Result := K_INSERT;
    $75 : Result := K_DELETE;
    $73 : Result := K_HOME;
    $77 : Result := K_END;
    $74 : Result := K_PAGEUP;
    $79 : Result := K_PAGEDOWN;

    $3B: Result := K_CTRL_L;
    //$3B: Result := K_CTRL_R;
    $3A: Result := K_ALT_L;
    //$3A: Result := K_ALT_R;
    $38: Result := K_SHIFT_L;
    //$38: Result := K_SHIFT_R;
    //: Result := K_SUPER_L;
    //: Result := K_SUPER_R;
    //: Result := K_APP_MENU;

    $39: Result := K_CAPSLOCK;
    $47: Result := K_NUMLOCK;
    $6B: Result := K_SCROLL;

    $21: Result := K_BRACKET_L;
    $1E: Result := K_BRACKET_R;
    $2A: Result := K_BACKSLASH;
    $2C: Result := K_SLASH;
    $2B: Result := K_COMMA;
    $2F: Result := K_DECIMAL;
    $29: Result := K_SEMICOLON;
    $27: Result := K_APOSTROPHE; // FIXME: Check!

    $1D: Result := K_0;
    $12: Result := K_1;
    $13: Result := K_2;
    $14: Result := K_3;
    $15: Result := K_4;
    $17: Result := K_5;
    $16: Result := K_6;
    $1A: Result := K_7;
    $1C: Result := K_8;
    $19: Result := K_9;

    $1B: Result := K_MINUS;
    $18: Result := K_EQUALS;

    $00: Result := K_A;
    $0B: Result := K_B;
    $08: Result := K_C;
    $02: Result := K_D;
    $0E: Result := K_E;
    $03: Result := K_F;
    $05: Result := K_G;
    $04: Result := K_H;
    $22: Result := K_I;
    $26: Result := K_J;
    $28: Result := K_K;
    $25: Result := K_L;
    $2E: Result := K_M;
    $2D: Result := K_N;
    $1F: Result := K_O;
    $23: Result := K_P;
    $0C: Result := K_Q;
    $0F: Result := K_R;
    $01: Result := K_S;
    $11: Result := K_T;
    $20: Result := K_U;
    $09: Result := K_V;
    $0D: Result := K_W;
    $07: Result := K_X;
    $10: Result := K_Y;
    $06: Result := K_Z;

    $52: Result := K_KP_0;
    $53: Result := K_KP_1;
    $54: Result := K_KP_2;
    $55: Result := K_KP_3;
    $56: Result := K_KP_4;
    $57: Result := K_KP_5;
    $58: Result := K_KP_6;
    $59: Result := K_KP_7;
    $5B: Result := K_KP_8;
    $5C: Result := K_KP_9;

    $4E: Result := K_KP_SUB;
    $45: Result := K_KP_ADD;
    $43: Result := K_KP_MUL;
    $4B: Result := K_KP_DIV;
    $41: Result := K_KP_DECIMAL;

    $7A: Result := K_F1;
    $78: Result := K_F2;
    $63: Result := K_F3;
    $76: Result := K_F4;
    $60: Result := K_F5;
    $61: Result := K_F6;
    $62: Result := K_F7;
    $64: Result := K_F8;
    $65: Result := K_F9;
    $6D: Result := K_F10;
    $67: Result := K_F11;
    $6F: Result := K_F12;
  end;
end;
{$ENDIF}

function SCA;
begin
  Result := KeyCode;
  if ( KeyCode = K_SHIFT_L ) or ( KeyCode = K_SHIFT_R ) Then Result := K_SHIFT;
  if ( KeyCode = K_CTRL_L ) or ( KeyCode = K_CTRL_R ) Then Result := K_CTRL;
  if ( KeyCode = K_ALT_L ) or ( KeyCode = K_ALT_R ) Then Result := K_ALT;
end;

procedure DoKeyPress;
begin
  {$IFDEF LINUX}
  if keysRepeat < 2 Then
  {$ENDIF}
  if keysCanPress[ KeyCode ] Then
    begin
      keysPress   [ KeyCode ] := TRUE;
      keysCanPress[ KeyCode ] := FALSE;
    end;
end;

end.
