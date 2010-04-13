// ���� ������ ���������� ����������� ����������� ���������� ��������, �������
// ��������� ��� ������� ������� ����� ��� ��� ��������� plain-style ����� ���� :)
// ���� �� ������ � �������������� ����������� ��������� �� ������� ����� � "06 - SEngine 2D(OOP)"
program demo06;

uses
  zgl_main,
  zgl_screen,
  zgl_window,
  zgl_timers,
  zgl_keyboard,
  zgl_render_2d,
  zgl_fx,
  zgl_textures,
  zgl_textures_png, // ������ ������, ����������� ���� ��� ���������� ������ � ���������� ������� ������� ������
  zgl_textures_jpg,
  zgl_sprite_2d,
  zgl_sengine_2d,
  zgl_primitives_2d,
  zgl_font,
  zgl_text,
  zgl_math_2d,
  zgl_utils;

var
  fntMain   : zglPFont;
  texLogo   : zglPTexture;
  texMiku   : zglPTexture;
  time      : Integer;
  sengine2d : zglTSEngine2D;

// Miku
procedure MikuInit( const Sprite : zglPSprite2D );
begin
  Sprite.X     := 800 + random( 800 );
  Sprite.Y     := random( 600 - 128 );
  // ������ �������� ��������
  // � ���������������� ��������� Data ������� ������
  // ��� ��������� zglTPoint2D
  zgl_GetMem( Sprite.Data, SizeOf( zglTPoint2D ) );
  with zglTPoint2D( Sprite.Data^ ) do
    begin
      X := -random( 10 ) / 5 - 0.5;
      Y := ( random( 10 ) - 5 ) / 5;
    end;
end;

procedure MikuDraw( const Sprite : zglPSprite2D );
begin
  with Sprite^ do
    asprite2d_Draw( Texture, X, Y, W, H, Angle, Round( Frame ), Alpha, FxFlags );
end;

procedure MikuProc( const Sprite : zglPSprite2D );
begin
  with Sprite^ do
    begin
      X := X + zglTPoint2D( Data^ ).X;
      Y := Y + zglTPoint2D( Data^ ).Y;
      Frame := Frame + ( abs( zglTPoint2D( Data^ ).X ) + abs( zglTPoint2D( Data^ ).Y ) ) / 25;
      if Frame > 8 Then
        Frame := 1;
      // ���� ������ ������� �� ������� �� X, ����� �� ������� ���
      if X < -128 Then sengine2d_DelSprite( ID );
      // ���� ������ ������� �� ������� �� Y, ������ ��� � ������� �� ��������
      if Y < -128 Then Destroy := TRUE;
      if Y > 600  Then Destroy := TRUE;
    end;
end;

procedure MikuFree( const Sprite : zglPSprite2D );
begin
  FreeMemory( Sprite.Data );
end;

// �������� 100 ��������
procedure AddMiku;
  var
    i : Integer;
    s : zglPSprite2D;
begin
  // ��� ���������� � �������� �������, ����������� ��������, Layer(��������� �� Z) �
  // ��������� �� �������� ������� - �������������, ������, ��������� � �����������
  for i := 1 to 100 do
    sengine2d_AddSprite( texMiku, random( 10 ), @MikuInit, @MikuDraw, @MikuProc, @MikuFree );
end;

// ������� 100 ��������
procedure DelMiku;
  var
    i : Integer;
begin
  // ������ 100 �������� �� ��������� ID
  for i := 1 to 100 do
    sengine2d_DelSprite( random( sengine2d.Count ) );
end;

procedure Init;
  var
    i : Integer;
begin
  texLogo := tex_LoadFromFile( '../res/zengl.png', $FF000000, TEX_DEFAULT_2D );

  texMiku := tex_LoadFromFile( '../res/miku.png', $FF000000, TEX_DEFAULT_2D );
  tex_SetFrameSize( texMiku, 128, 128 );

  // ������������� ������� ���������� �������� ����
  sengine2d_Set( @sengine2d );
  // �������� 1000 �������� Miku-chan :)
  for i := 0 to 9 do
    AddMiku;

  fntMain := font_LoadFromFile( '../res/font.zfi' );
  for i := 0 to fntMain.Count.Pages - 1 do
    fntMain.Pages[ i ] := tex_LoadFromFile( '../res/font_' + u_IntToStr( i ) + '.png', $FF000000, TEX_DEFAULT_2D );
end;

procedure Draw;
  var
    i : Integer;
    t : Single;
begin
  batch2d_Begin;

  // ������ ��� ������� ����������� � ������� ���������� ���������
  if time > 255 Then
    sengine2d_Draw;

  if time <= 255 Then
    ssprite2d_Draw( texLogo, 400 - 256, 300 - 128, 512, 256, 0, time )
  else
    if time < 510 Then
      begin
        pr2d_Rect( 0, 0, 800, 600, $000000, 510 - time, PR2D_FILL );
        ssprite2d_Draw( texLogo, 400 - 256, 300 - 128, 512, 256, 0, 510 - time );
      end;

  if time > 255 Then
    begin
      pr2d_Rect( 0, 0, 256, 64, $000000, 200, PR2D_FILL );
      text_Draw( fntMain, 0, 0, 'FPS: ' + u_IntToStr( zgl_Get( SYS_FPS ) ) );
      text_Draw( fntMain, 0, 20, 'Sprites: ' + u_IntToStr( sengine2d.Count ) );
      text_Draw( fntMain, 0, 40, 'Up/Down - Add/Delete Miku :)' );
    end;
  batch2d_End;
end;

procedure Timer;
  var
    i : Integer;
begin
  INC( time, 2 );

  // ��������� ��������� ���� �������� � ������� ���������� ���������
  sengine2d_Proc;
  if key_Press( K_SPACE ) Then sengine2d_ClearAll;
  if key_Press( K_UP ) Then AddMiku;
  if key_Press( K_DOWN ) Then DelMiku;
  if key_Press( K_ESCAPE ) Then zgl_Exit;
  key_ClearState;
end;

Begin
  randomize;

  timer_Add( @Timer, 16 );
  timer_Add( @AddMiku, 1000 );

  zgl_Reg( SYS_LOAD, @Init );
  zgl_Reg( SYS_DRAW, @Draw );

  wnd_SetCaption( '06 - SEngine 2D' );

  wnd_ShowCursor( TRUE );

  scr_SetOptions( 800, 600, REFRESH_MAXIMUM, FALSE, FALSE );

  zgl_Init;
End.
