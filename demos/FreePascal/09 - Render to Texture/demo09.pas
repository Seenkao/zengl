program demo09;

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
  zgl_textures,
  zgl_textures_png, // Важный момент, обязательно один раз подключить модуль с поддержкой нужного формата данных
  zgl_render_target,
  zgl_sprite_2d,
  zgl_font,
  zgl_text,
  zgl_math_2d,
  zgl_utils
  {$ENDIF}
  ;

var
  dirRes  : String = '../../res/';
  fntMain : zglPFont;
  texTux  : zglPTexture;
  rtarget : zglPRenderTarget;

procedure Init;
begin
  {$IFDEF DARWIN}
  dirRes := PChar( zgl_Get( APP_DIRECTORY ) ) + 'Contents/Resources/';
  {$ENDIF}

  texTux := tex_LoadFromFile( dirRes + 'tux_stand.png', $FF000000, TEX_DEFAULT_2D );
  tex_SetFrameSize( textux, 64, 64 );

  fntMain := font_LoadFromFile( dirRes + 'font.zfi' );

  // Создаем RenderTarget и "цепляем" пустую текстуру. В процессе текстуру можно сменить присвоив
  // rtarget.Surface другую zglPTexture, главное что бы совпадали размеры с теми, что указаны в
  // tex_CreateZero. Таргету также указан флаг RT_FULL_SCREEN, отвечающий за то, что бы в текстуру
  // помещалось все содержимое экрана а не область 512x512(в режиме RT_DEFAULT)
  rtarget := rtarget_Add( tex_CreateZero( 512, 512, $00000000, TEX_DEFAULT_2D ), RT_FULL_SCREEN );
end;

procedure Draw;
  var
    i : Integer;
begin
  // Устанавливаем текущий RenderTarget
  rtarget_Set( rtarget );
  // Рисуем в него
  asprite2d_Draw( texTux, random( 800 - 64 ), random( 600 - 64 ), 64, 64, 0, random( 9 ) + 1 );
  // Возвращаемся к обычному рендеру
  rtarget_Set( nil );

  // Теперь рисуем содержимое RenderTarget'а
  ssprite2d_Draw( rtarget.Surface, ( 800 - 512 ) / 2, ( 600 - 512 ) / 2, 512, 512, 0 );

  text_Draw( fntMain, 0, 0, 'FPS: ' + u_IntToStr( zgl_Get( SYS_FPS ) ) );
end;

procedure Timer;
begin
  if key_Press( K_ESCAPE ) Then zgl_Exit();
  key_ClearState();
end;

Begin
  {$IFNDEF STATIC}
  zglLoad( libZenGL );
  {$ENDIF}

  randomize();

  timer_Add( @Timer, 16 );

  zgl_Reg( SYS_LOAD, @Init );
  zgl_Reg( SYS_DRAW, @Draw );

  // Т.к. модуль сохранен в кодировке UTF-8 и в нем используются строковые переменные
  // следует указать использования этой кодировки
  zgl_Enable( APP_USE_UTF8 );

  wnd_SetCaption( '09 - Render to Texture' );

  wnd_ShowCursor( TRUE );

  scr_SetOptions( 800, 600, REFRESH_MAXIMUM, FALSE, FALSE );

  zgl_Init();
End.
