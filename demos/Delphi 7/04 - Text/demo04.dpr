program demo04;

{$R *.res}
{$DEFINE STATIC}

uses
  {$IFNDEF STATIC}
  zglHeader
  {$ELSE}
  zgl_main,
  zgl_screen,
  zgl_window,
  zgl_timers,
  zgl_keyboard,
  zgl_render_2d,
  zgl_fx,
  zgl_primitives_2d,
  zgl_textures,
  zgl_textures_png, // RU: ������ ������, ����������� ���� ��� ���������� ������ � ���������� ������� ������� ������.
                    // EN: Important moment, unit that support needed format must be included one time.
  zgl_font,
  zgl_text,
  zgl_math_2d,
  zgl_utils
  {$ENDIF}
  ;

var
  dirRes : UTF8String = '../data/';
  fnt    : zglPFont;

procedure Init;
  //var
  //  i : Integer;
begin
  // RU: ��������� ������ � ������.
  // EN: Load the font.
  fnt := font_LoadFromFile( dirRes + 'font.zfi' );
  // RU: ���� �� �������� ��������� ��� ������������� ����� ���� "FontName-pageN.ext", �� �������� ����� ���������� ������� ��������� �������:
  // EN: If textures were named without special mask - "FontName-pageN.ext", then it can be loaded this way:
  //for i := 0 to fnt.Count.Pages - 1 do
  //  fnt.Pages[ i ] := tex_LoadFromFile( dirRes + 'font-page' + u_IntToStr( i ) + '.png', $FF000000, TEX_DEFAULT_2D );
end;

procedure Draw;
  var
    r : zglTRect;
    s : UTF8String;
begin
  batch2d_Begin();
  text_Draw( fnt, 400, 25, AnsiToUTF8( '������ � ������������� �� ������' ), TEXT_HALIGN_CENTER );
  text_DrawEx( fnt, 400, 65, 2, 0, AnsiToUTF8( '���������������' ), 255, $FFFFFF, TEXT_HALIGN_CENTER );
  fx2d_SetVCA( $FF0000, $00FF00, $0000FF, $FFFFFF, 255, 255, 255, 255 );
  text_Draw( fnt, 400, 125, AnsiToUTF8( '�������� ����� ��� ������� �������' ), TEXT_FX_VCA or TEXT_HALIGN_CENTER );

  r.X := 0;
  r.Y := 300 - 128;
  r.W := 192;
  r.H := 256;
  text_DrawInRect( fnt, r, AnsiToUTF8( '������� ����� ������ � ��������������' ) );
  pr2d_Rect( r.X, r.Y, r.W, r.H, $FF0000 );

  r.X := 800 - 192;
  r.Y := 300 - 128;
  r.W := 192;
  r.H := 256;
  text_DrawInRect( fnt, r, AnsiToUTF8( '����� ������ ��������� ������������ �� ������� ���� � ���������� �����' ), TEXT_HALIGN_RIGHT or TEXT_VALIGN_BOTTOM );
  pr2d_Rect( r.X, r.Y, r.W, r.H, $FF0000 );

  r.X := 400 - 192;
  r.Y := 300 - 128;
  r.W := 384;
  r.H := 256;
  // RU: ���� ��������� ������ ������ � �������� ����� �� ��� �����, �� ������ - FreePascal ������������, � �� �����
  // ������������ ����������� ������ ������� 255 �������� :)
  // EN: If you want to know why I use two parts of text, I can answer - because FreePascal doesn't like constant
  // string with more than 255 symbols :)
  text_DrawInRect( fnt, r, AnsiToUTF8( '���� ����� ���������� ������������ �� ������ � ������������ �� ���������.' +
                           ' �����, ������� �� ���������� � �������� �������������� ����� �������.' ), TEXT_HALIGN_JUSTIFY or TEXT_VALIGN_CENTER );
  pr2d_Rect( r.X, r.Y, r.W, r.H, $FF0000 );

  r.X := 400 - 320;
  r.Y := 300 + 160;
  r.W := 640;
  r.H := 128;
  text_DrawInRect( fnt, r, AnsiToUTF8( '��� �������� ����� ����� ������������ LF-������' + #10 + '��� �������� ����� 10 � ��������� � ������� Unicode ��� "Line Feed"' ), TEXT_HALIGN_CENTER or TEXT_VALIGN_CENTER );
  pr2d_Rect( r.X, r.Y, r.W, r.H, $FF0000 );

  // RU: ������� ���������� FPS � ������ ����, ��������� text_GetWidth.
  // EN: Render frames per second in the top right corner using text_GetWidth.
  s := AnsiToUTF8( 'FPS: ' + u_IntToStr( zgl_Get( RENDER_FPS ) ) );
  text_Draw( fnt, 800 - text_GetWidth( fnt, s ), 0, s );
  batch2d_End();
end;

procedure Proc;
begin
  if key_Press( K_ESCAPE ) Then zgl_Exit();
  key_ClearState();
end;

Begin
  {$IFNDEF STATIC}
  zglLoad( libZenGL );
  {$ENDIF}

  randomize();

  timer_Add( @Proc, 16 );

  zgl_Reg( SYS_LOAD, @Init );
  zgl_Reg( SYS_DRAW, @Draw );

  wnd_SetCaption( '04 - Text' );

  wnd_ShowCursor( TRUE );

  scr_SetOptions( 800, 600, REFRESH_MAXIMUM, FALSE, FALSE );

  zgl_Init();
End.
