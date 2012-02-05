program demo01;

{$R *.res}

// RU: ���������� ����� ������� � ZenGL ���� ��������, ���� ��������� so/dll/dylib.
// ��� ����� ��������������� ���������� ����. ������������ ��������� ����������
// ����������� � ������� �������, �� ������� ����������� ������� ������ �������.
// ����� ����������� ���������� ��������� ��������� ������� LGPL-��������,
// � ��������� ��������� �������� �������� ����� ����������, ������� ����������
// �������� ���� ZenGL. ������������� �� ������ so/dll/dylib ����� �� �������.
//
// EN: Application can be compiled with ZenGL statically or with using so/dll/dylib.
// For this comment the define below. Advantage of static compilation is smaller
// size of application, but it requires including all units.
// Also static compilation requires to follow the terms of LGPL-license,
// particularly you must open source code of application that use
// source code of ZenGL. Using so/dll/dylib doesn't requires this.
{$DEFINE STATIC}

uses
  {$IFNDEF STATIC}
  zglHeader
  {$ELSE}
  // RU: ����� �������������� �������, �� �������� ������� ���� � �������� ����� ZenGL :)
  // EN: Before using the modules don't forget to set path to source code of ZenGL :)
  zgl_main,
  zgl_screen,
  zgl_window,
  zgl_timers,
  zgl_utils
  {$ENDIF}
  ;

var
  DirApp  : String;
  DirHome : String;

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
  // RU: ��� ������� ���������� ��� ���������� �������� �������� ����-����, �.�. ������� �������� ���������� FPS.
  // EN: This function is the best way to implement smooth moving of something, because timers are restricted by FPS.
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
  {$IFNDEF STATIC}
  zglLoad( libZenGL );
  {$ENDIF}

  // RU: ��� ��������/�������� �����-�� ����� ��������/��������/etc. ����� �������� ���� �
  // ���������� �������� ������������, ��� � ������������ �����(�� �������� ��� GNU/Linux).
  //
  // EN: For loading/creating your own options/profiles/etc. you can get path to user home
  // directory, or to executable file(not works for GNU/Linux).
  DirApp  := u_CopyStr( PChar( zgl_Get( DIRECTORY_APPLICATION ) ) );
  DirHome := u_CopyStr( PChar( zgl_Get( DIRECTORY_HOME ) ) );

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
