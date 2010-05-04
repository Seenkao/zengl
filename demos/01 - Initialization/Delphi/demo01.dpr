program demo01;

// ���������� ����� ������� � ZenGL ��������, ���� ������������ so/dll/dylib.
// ��� ����� ��������������� ���������� ����. ������������ ��������� ����������
// ����������� � ������� �������, �� ������� ����������� ������� ������ �������
// ����� ����������� ���������� ��������� ��������� ������� LGPL-��������,
// � ��������� ��������� �������� �������� ����� ����������, ������� ����������
// �������� ���� ZenGL. ������������� �� ������ so/dll/dylib ����� �� �������.
{$DEFINE STATIC}

uses
  {$IFDEF STATIC}
  // ����� �������������� �������, �� �������� ������� ���� � �������� ����� ZenGL :)
  zgl_main,
  zgl_screen,
  zgl_window,
  zgl_timers,
  zgl_utils
  {$ELSE}
  zglHeader
  {$ENDIF}
  ;

var
  DirApp  : AnsiString;
  DirHome : AnsiString;

procedure Init;
begin
  // ��� ����� ��������� �������� �������� ��������
end;

procedure Draw;
begin
  // ��� "������" ��� ������ :)
end;

procedure Update( dt : Double );
begin
  //
end;

procedure Timer;
begin
  // ����� � ��������� ���������� ���������� ������ � �������
  wnd_SetCaption( '01 - Initialization[ FPS: ' + u_IntToStr( zgl_Get( SYS_FPS ) ) + ' ]' );
end;

procedure Quit;
begin
 //
end;

Begin
  {$IFNDEF STATIC}
    zglLoad( 'ZenGL.dll' );
  {$ENDIF}

  // ��� ��������/�������� �����-�� ����� ��������/��������/etc. ����� �������� ���� �
  // ��������� ���������� ������������, ��� � ������������ �����
  DirApp  := PAnsiChar( zgl_Get( APP_DIRECTORY ) );
  DirHome := PAnsiChar( zgl_Get( USR_HOMEDIR ) );

  // ������� ������ � ���������� 1000��.
  timer_Add( @Timer, 1000 );

  // ������������ ���������, ��� ���������� ����� ����� ������������� ZenGL
  zgl_Reg( SYS_LOAD, @Init );
  // ������������ ���������, ��� ����� ����������� ������
  zgl_Reg( SYS_DRAW, @Draw );
  // ������������ ���������, ������� ����� ��������� ������� ������� ����� �������
  zgl_Reg( SYS_UPDATE, @Update );
  // ������������ ���������, ������� ���������� ����� ���������� ������ ZenGL
  zgl_Reg( SYS_EXIT, @Quit );

  // ������������� ��������� ����
  wnd_SetCaption( '01 - Initialization' );

  // ��������� ������ ����
  wnd_ShowCursor( TRUE );

  // ��������� �������������� ���������
  scr_SetOptions( 800, 600, REFRESH_MAXIMUM, FALSE, FALSE );

  // �������������� ZenGL
  zgl_Init;
End.
