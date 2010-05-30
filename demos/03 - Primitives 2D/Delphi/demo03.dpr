program demo03;

uses
  zgl_main,
  zgl_screen,
  zgl_window,
  zgl_timers,
  zgl_keyboard,
  zgl_render_2d,
  zgl_fx,
  zgl_primitives_2d,
  zgl_math_2d,
  zgl_utils;

var
  calc   : Integer;
  points : array[ 0..359 ] of zglTPoint2D;

procedure Init;
  var
    i : Integer;
begin
  for i := 0 to 359 do
    begin
      points[ i ].X := 400 + m_Cos( i ) * ( 96 + random( 32 ) );
      points[ i ].Y := 300 + m_Sin( i ) * ( 96 + random( 32 ) );
    end;
end;

procedure Draw;
  var
    i : Integer;
begin
  // ������������� ���� � ����� ��� ������ �������
  fx2d_SetVCA( $FF0000, $00FF00, $0000FF, $FFFFFF, 255, 255, 255, 255 );
  // ������ ������������� � ��������(���� PR2D_FILL) � �������������� ��������� ������ ��� ������ �������(���� FX2D_VCA)
  pr2d_Rect( 0, 0, 800, 600, $000000, 255, FX2D_VCA or PR2D_FILL );

  // ������ � ������ ������ ���� � �������� 128 �������
  pr2d_Circle( 400, 300, 128, $000000, 155, 32, PR2D_FILL );

  // �.�. ����� ���� ����� ���������� ����������(�����) ������� ��������������� ������������ �� ���������� DIP'��.
  // �� ����������� ��������� � batch2d_Begin/batch2d_End ������ �������� ������� �������, ������ ����� ��������� � ��� ��� Draw �������.
  // ��������, ��� ������ ������ �������� ������� � ����� �������� �� ����������, ������ �������� ��� � batch2d ��������� FPS ����� ���� :)
  // ���� � ���, ��� ��� ������� FPS'�� ������������� ���������� ���������, ����� �������� �������� �� �������� � ��.
  batch2d_Begin;
  INC( calc );
  if calc > 359 Then calc := 0;
  points[ calc ].X := 400 + m_Cos( calc ) * ( 96 + random( 32 ) );
  points[ calc ].Y := 300 + m_Sin( calc ) * ( 96 + random( 32 ) );
  // ������ ����� ������ �����
  for i := 0 to 359 do
    pr2d_Line( 400, 300, points[ i ].X, points[ i ].Y, $FFFFFF, 255 );
  batch2d_End;

  // ������ ������� � �������� � ���, �� ����������� ���������
  pr2d_Ellipse( 400 + 300, 300, 64, 256, $FFFFFF, 55, 32, PR2D_FILL or PR2D_SMOOTH );
  pr2d_Ellipse( 400 + 300, 300, 64, 256, $000000, 255, 32, PR2D_SMOOTH );

  pr2d_Ellipse( 400 - 300, 300, 64, 256, $FFFFFF, 55, 32, PR2D_FILL or PR2D_SMOOTH );
  pr2d_Ellipse( 400 - 300, 300, 64, 256, $000000, 255, 32, PR2D_SMOOTH );
end;

procedure Timer;
begin
  wnd_SetCaption( '02 - Primitives 2D[ FPS: ' + u_IntToStr( zgl_Get( SYS_FPS ) ) + ' ]' );
end;

procedure Proc;
begin
  if key_Press( K_ESCAPE ) Then zgl_Exit;
  key_ClearState;
end;

Begin
  randomize;

  timer_Add( @Proc, 16 );
  timer_Add( @Timer, 1000 );

  zgl_Reg( SYS_LOAD, @Init );
  zgl_Reg( SYS_DRAW, @Draw );

  wnd_SetCaption( '03 - Primitives 2D' );

  wnd_ShowCursor( TRUE );

  scr_SetOptions( 800, 600, REFRESH_MAXIMUM, FALSE, FALSE );

  zgl_Init;
End.
