program demo01;

// RU: ���� ���� �������� ��������� ���������(�������� ������������ �� ����������� ����������) � ����������� �� ��� ������� ���������� ����������.
// EN: This file contains some options(e.g. whether to use static compilation) and defines of OS for which is compilation going.
{$I zglCustomConfig.cfg}

{$IFDEF WINDOWS}
  {$R *.res}
{$ENDIF}

uses
  {$IFDEF USE_ZENGL_STATIC}
  // RU: ��� ������������� ����������� ���������� ���������� ���������� ������ ZenGL ���������� ����������� ����������.
  // EN: Using static compilation needs to use ZenGL units with needed functionality.
  zgl_main,
  zgl_screen,
  zgl_window,
  zgl_timers,
  zgl_utils
  {$ELSE}
  // RU: ��������� ZenGL � �������� ����������(so, dll ��� dylib) ����� ����� ���� ������������ ����.
  // EN: Using ZenGL as a shared library(so, dll or dylib) needs only one header.
  zglHeader
  {$ENDIF}
  ;

var
  DirApp  : UTF8String;
  DirHome : UTF8String;

procedure Init;
begin
  // RU: ��� ����� ��������� �������� �������� ��������.
  // EN: Here can be loading of main resources.
end;

procedure Draw;
begin
  // RU: ��� "������" ��� ������ :)
  // EN: Here "draw" anything :)
end;

procedure Update( dt : Double );
begin
  // RU: ��� ������� ���������� ��� ���������� �������� �������� ����-����, �.�. �������� �������� ���������� FPS.
  // EN: This function is the best way to implement smooth moving of something, because accuracy of timers are restricted by FPS.
end;

procedure Timer;
begin
  // RU: ����� � ��������� ���������� ���������� ������ � �������.
  // EN: Caption will show the frames per second.
  wnd_SetCaption( '01 - Initialization[ FPS: ' + u_IntToStr( zgl_Get( RENDER_FPS ) ) + ' ]' );
end;

procedure Quit;
begin
 //
end;

Begin
  // RU: ��� ���� ��������� ���������� ���� ����������� ���������� �� ������������.
  // EN: Code below loads a library if static compilation is not used.
  {$IFNDEF USE_ZENGL_STATIC}
    {$IFDEF LINUX}
    // RU: � GNU/Linux ��� ���������� ������� ������� � /usr/lib, ������� libZenGL.so ������ ���� �������������� �����������.
    // �� zglLoad ������� ��������� ���� �� libZenGL.so ����� � ����������� ������.
    //
    // EN: In GNU/Linux all libraries placed in /usr/lib, so libZenGL.so must be installed before it will be used.
    // But zglLoad will check first if there is libZenGL.so near executable file.
    if not zglLoad( libZenGL ) Then exit;
    {$ENDIF}
    {$IFDEF WINDOWS}
    if not zglLoad( libZenGL ) Then exit;
    {$ENDIF}
    {$IFDEF DARWIN}
    // RU: libZenGL.dylib ������� �������������� ��������� � ������� MyApp.app/Contents/Frameworks/, ��� MyApp.app - Bundle ������ ����������.
    // ����� ������� ���������, ��� ���-���� ����� ����������� � �������� �������� ������� ���� ���������� ���, ���� ���������� ���� ���� � ���, ��� ������� � �������.
    //
    // EN: libZenGL.dylib must be placed into this directory MyApp.app/Contents/Frameworks/, where MyApp.app - Bundle of your application.
    // Also you must know, that log-file will be created in root directory, so you must disable a log, or choose your own path and name for it. How to do this you can find in documentation.
    if not zglLoad( libZenGL ) Then exit;
    {$ENDIF}
  {$ENDIF}

  // RU: ��� ��������/�������� �����-�� ����� ��������/��������/etc. ����� �������� ���� � ���������� �������� ������������, ��� � ������������ �����(�� �������� ��� GNU/Linux).
  // EN: For loading/creating your own options/profiles/etc. you can get path to user home directory, or to executable file(not works for GNU/Linux).
  DirApp  := utf8_Copy( PAnsiChar( zgl_Get( DIRECTORY_APPLICATION ) ) );
  DirHome := utf8_Copy( PAnsiChar( zgl_Get( DIRECTORY_HOME ) ) );

  // RU: ������� ������ � ���������� 1000��.
  // EN: Create a timer with interval 1000ms.
  timer_Add( @Timer, 1000 );

  // RU: ������������ ���������, ��� ���������� ����� ����� ������������� ZenGL.
  // EN: Register the procedure, that will be executed after ZenGL initialization.
  zgl_Reg( SYS_LOAD, @Init );
  // RU: ������������ ���������, ��� ����� ����������� ������.
  // EN: Register the render procedure.
  zgl_Reg( SYS_DRAW, @Draw );
  // RU: ������������ ���������, ������� ����� ��������� ������� ������� ����� �������.
  // EN: Register the procedure, that will get delta time between the frames.
  zgl_Reg( SYS_UPDATE, @Update );
  // RU: ������������ ���������, ������� ���������� ����� ���������� ������ ZenGL.
  // EN: Register the procedure, that will be executed after ZenGL shutdown.
  zgl_Reg( SYS_EXIT, @Quit );

  // RU: ������������� ��������� ����.
  // EN: Set the caption of the window.
  wnd_SetCaption( '01 - Initialization' );

  // RU: ��������� ������ ����.
  // EN: Allow to show the mouse cursor.
  wnd_ShowCursor( TRUE );

  // RU: ��������� �������������� ���������.
  // EN: Set screen options.
  scr_SetOptions( 800, 600, REFRESH_MAXIMUM, FALSE, FALSE );

  // RU: �������������� ZenGL.
  // EN: Initialize ZenGL.
  zgl_Init();
End.
