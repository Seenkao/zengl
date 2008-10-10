{
 * Copyright © Kemka Andrey aka Andru
 * mail: dr.andru@gmail.com
 * site: http://andru.2x4.ru
 *
 * This library is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
}
unit zgl_math;

{$I define.inc}

interface
uses
  zgl_const,
  zgl_types;
  
function m_Round( value : Single ) : Integer; extdecl;

procedure InitCosSinTables;
function  m_Cos( Angle : Integer ) : Single; extdecl;
function  m_Sin( Angle : Integer ) : Single; extdecl;
procedure m_SinCos( Angle : Single; var S, C : Single ); {$IFDEF USE_ASM} assembler; {$ENDIF}

function m_Distance( x1, y1, x2, y2 : Single ) : Single; extdecl;
function m_FDistance( x1, y1, x2, y2 : Single ) : Single; extdecl;
function m_Angle( x1, y1, x2, y2 : Single ) : Single; extdecl;

{------------------------------------------------------------------------------}
{--------------------------------- Vectors ------------------------------------}
{------------------------------------------------------------------------------}
function vector_Get( x, y, z : Single ) : zglTPoint3D;

function vector_Add( Vector1, Vector2 : zglTPoint3D ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_Sub( Vector1, Vector2 : zglTPoint3D ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_Mul( Vector1, Vector2 : zglTPoint3D ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_Div( Vector1, Vector2 : zglTPoint3D ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}

function vector_AddV( Vector : zglTPoint3D; Value : Single ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_SubV( Vector : zglTPoint3D; Value : Single ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_MulV( Vector : zglTPoint3D; Value : Single ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_DivV( Vector : zglTPoint3D; Value : Single ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}

function vector_MulM3f( Vector : zglTPoint3D; Matrix : zglTMatrix3f ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_MulM4f( Vector : zglTPoint3D; Matrix : zglTMatrix4f ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_MulInvM4f( Vector : zglTPoint3D; Matrix : zglTMatrix4f ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}

function vector_RotateX( Vector : zglTPoint3D; Value : Single ) : zglTPoint3D;
function vector_RotateY( Vector : zglTPoint3D; Value : Single ) : zglTPoint3D;
function vector_RotateZ( Vector : zglTPoint3D; Value : Single ) : zglTPoint3D;
function vector_RotateQ( Vector : zglTPoint3D; Quaternion : zglTQuaternion ) : zglTPoint3D;

function vector_Negate( Vector : zglTPoint3D ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_Normalize( Vector : zglTPoint3D ) : zglTPoint3D;
function vector_Angle( Vector1, Vector2 : zglTPoint3D ) : Single;
function vector_Cross( Vector1, Vector2 : zglTPoint3D ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_Dot( Vector1, Vector2 : zglTPoint3D ) : Single; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_Distance( Vector1, Vector2 : zglTPoint3D ) : Single; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_FDistance( Vector1, Vector2 : zglTPoint3D ) : Single; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_Length( Vector : zglTPoint3D ) : Single; {$IFDEF USE_ASM} assembler; {$ENDIF}
function vector_Lerp( Vector1, Vector2 : zglTPoint3D; Value : Single ) : zglTPoint3D; {$IFDEF USE_ASM} assembler; {$ENDIF}

{------------------------------------------------------------------------------}
{--------------------------------- Matrix3f -----------------------------------}
{------------------------------------------------------------------------------}
function  matrix3f_Get( v1, v2, v3 : zglTPoint3D ) : zglTMatrix3f;

procedure matrix3f_OrthoNormalize( Matrix : zglPMatrix3f );
procedure matrix3f_Transpose( Matrix : zglPMatrix3f );
procedure matrix3f_Rotate( Matrix : zglPMatrix3f; aX, aY, aZ : Single );
function  matrix3f_Add( Matrix1, Matrix2 : zglTMatrix3f ) : zglTMatrix3f;
function  matrix3f_Mul( Matrix1, Matrix2 : zglTMatrix3f ) : zglTMatrix3f;

procedure matrix4f_Transpose( Matrix : zglPMatrix4f );
function  matrix4f_Determinant( Matrix : zglTMatrix4f ): Single;
function  matrix4f_Inverse( Matrix : zglTMatrix4f ) : zglTMatrix4f;
procedure matrix4f_Translate( Matrix : zglPMatrix4f; tX, tY, tZ : Single );
procedure matrix4f_Rotate( Matrix : zglPMatrix4f; aX, aY, aZ : Single );
procedure matrix4f_Scale( Matrix : zglPMatrix4f; sX, sY, sZ : Single );
function  matrix4f_Mul( Matrix1, Matrix2 : zglTMatrix4f ) : zglTMatrix4f;

{------------------------------------------------------------------------------}
{-------------------------------- Quaternion ----------------------------------}
{------------------------------------------------------------------------------}
function quater_Get( X, Y, Z, W : Single ) : zglTQuaternion;
function quater_Add( q1, q2 : zglTQuaternion ) : zglTQuaternion; {$IFDEF USE_ASM} assembler; {$ENDIF}
function quater_Sub( q1, q2 : zglTQuaternion ) : zglTQuaternion; {$IFDEF USE_ASM} assembler; {$ENDIF}
function quater_Mul( q1, q2 : zglTQuaternion ) : zglTQuaternion;
function quater_Negate( Quaternion : zglTQuaternion ) : zglTQuaternion;
function quater_Normalize( Quaternion : zglTQuaternion ) : zglTQuaternion;
function quater_Dot( q1, q2 : zglTQuaternion ) : Single;
function quater_Lerp( q1, q2 : zglTQuaternion; Value : Single ) : zglTQuaternion;
function quater_FromRotation( Rotation : zglTPoint3D ) : zglTQuaternion;
function quater_GetM4f( Quaternion : zglTQuaternion ) : zglTMatrix4f;

function line3d_ClosestPoint( A, B, Point : zglTPoint3D ) : zglTPoint3D;

function plane_Get( A, B, C : zglTPoint3D ) : zglTPlane;
function plane_Distance( Plane : zglTPlane; Point : zglTPoint3D ) : Single; {$IFDEF USE_ASM} assembler; {$ENDIF}

function tri_GetNormal( A, B, C : zglPPoint3D ) : zglTPoint3D;

function ArcTan2( X, Y : Single ) : Single; assembler;
function ArcCos( Value : Single ) : Single;

const
  matrix3f_Identity: zglTMatrix3f = ( ( X: 1; Y: 0; Z: 0 ), ( X: 0; Y: 1; Z: 0 ), ( X: 0; Y: 0; Z: 1 ) );
  matrix4f_Identity: zglTMatrix4f = ( ( 1, 0, 0, 0 ), ( 0, 1, 0, 0 ), ( 0, 0, 1, 0 ), ( 0, 0, 0, 1 ) );
  quater_Zero      : zglTQuaternion = ( X: 0; Y: 0; Z: 0; W: 0 );

var
  CosTable : array[ 0..360 ] of Single;
  SinTable : array[ 0..360 ] of Single;

implementation

function m_Round;
{$IFNDEF USE_ASM}
begin
  Result := Round( value );
{$ELSE}
asm
  FLD   value
  FISTP DWORD PTR [ value ]
  MOV   EAX,      [ value ]
{$ENDIF}
end;

procedure InitCosSinTables;
  var
    i         : Integer;
    rad_angle : Single;
begin
  for i := 0 to 360 do
    begin
      rad_angle := i * ( cv_pi / 180 );
      CosTable[ i ] := cos( rad_angle );
      SinTable[ i ] := sin( rad_angle );
    end;
end;

function m_Cos;
begin
  while Angle > 360 do Angle := Angle - 360;
  while Angle < 0   do Angle := Angle + 360;
  if Angle > 0 Then
    Result := CosTable[ Angle ]
  else
    Result := CosTable[ 360 - Angle ]
end;

function m_Sin;
begin
  while Angle > 360 do Angle := Angle - 360;
  while Angle < 0   do Angle := Angle + 360;
  if Angle > 0 Then
    Result := SinTable[ Angle ]
  else
    Result := SinTable[ 360 - Angle ]
end;

procedure m_SinCos;
{$IFNDEF USE_ASM}
begin
  s := Sin( Angle );
  c := Cos( Angle );
{$ELSE}
asm
  FLD Angle
  FSINCOS
  FSTP DWORD PTR [ EDX ]
  FSTP DWORD PTR [ EAX ]
{$ENDIF}
end;

function m_Distance;
begin
  Result := Sqrt( ( X1 - X2 ) * ( X1 - X2 ) + ( Y1 - Y2 ) * ( Y1 - Y2 ) );
end;

function m_FDistance;
begin
  Result := ( X1 - X2 ) * ( X1 - X2 ) + ( Y1 - Y2 ) * ( Y1 - Y2 );
end;

function m_Angle;
begin
  Result := ArcTan2( x2 - x1, y2 - y1 );
end;

function ArcTan2;
asm
  FLD    X
  FLD    Y
  FPATAN
  FWAIT
end;

function ArcCos;
begin
  if 1 - sqr( Value ) <= 0 Then
    Result := -1
  else
    Result := ArcTan2( sqrt( 1 - sqr( Value ) ), Value );
end;

{------------------------------------------------------------------------------}
{--------------------------------- Vectors ------------------------------------}
{------------------------------------------------------------------------------}
function vector_Get;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
end;

function vector_Add;
{$IFNDEF USE_ASM}
begin
  Result.X := Vector1.X + Vector2.X;
  Result.Y := Vector1.Y + Vector2.Y;
  Result.Z := Vector1.Z + Vector2.Z;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX     ]
  FADD DWORD PTR [ EDX     ]
  FSTP DWORD PTR [ ECX     ]

  FLD  DWORD PTR [ EAX + 4 ]
  FADD DWORD PTR [ EDX + 4 ]
  FSTP DWORD PTR [ ECX + 4 ]

  FLD  DWORD PTR [ EAX + 8 ]
  FADD DWORD PTR [ EDX + 8 ]
  FSTP DWORD PTR [ ECX + 8 ]
{$ENDIF}
end;


function vector_Sub;
{$IFNDEF USE_ASM}
begin
  Result.X := Vector1.X - Vector2.X;
  Result.Y := Vector1.Y - Vector2.Y;
  Result.Z := Vector1.Z - Vector2.Z;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX     ]
  FSUB DWORD PTR [ EDX     ]
  FSTP DWORD PTR [ ECX     ]

  FLD  DWORD PTR [ EAX + 4 ]
  FSUB DWORD PTR [ EDX + 4 ]
  FSTP DWORD PTR [ ECX + 4 ]

  FLD  DWORD PTR [ EAX + 8 ]
  FSUB DWORD PTR [ EDX + 8 ]
  FSTP DWORD PTR [ ECX + 8 ]
{$ENDIF}
end;

function vector_Mul;
{$IFNDEF USE_ASM}
begin
  Result.X := Vector1.X * Vector2.X;
  Result.Y := Vector1.Y * Vector2.Y;
  Result.Z := Vector1.Z * Vector2.Z;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX     ]
  FMUL DWORD PTR [ EDX     ]
  FSTP DWORD PTR [ ECX     ]

  FLD  DWORD PTR [ EAX + 4 ]
  FMUL DWORD PTR [ EDX + 4 ]
  FSTP DWORD PTR [ ECX + 4 ]

  FLD  DWORD PTR [ EAX + 8 ]
  FMUL DWORD PTR [ EDX + 8 ]
  FSTP DWORD PTR [ ECX + 8 ]
{$ENDIF}
end;

function vector_Div;
{$IFNDEF USE_ASM}
begin
  Result.X := Vector1.X / Vector2.X;
  Result.Y := Vector1.Y / Vector2.Y;
  Result.Z := Vector1.Z / Vector2.Z;
{$ELSE}
asm
  mov [ EAX     ], 0
  mov [ EAX + 4 ], 0
  mov [ EAX + 8 ], 0
  
@@1:
  cmp [ EDX     ], 0
  jz  @@2
  
  FLD  DWORD PTR [ EAX     ]
  FDIV DWORD PTR [ EDX     ]
  FSTP DWORD PTR [ ECX     ]
  
@@2:
  cmp [ EDX + 4 ], 0
  jz  @@3
  
  FLD  DWORD PTR [ EAX + 4 ]
  FDIV DWORD PTR [ EDX + 4 ]
  FSTP DWORD PTR [ ECX + 4 ]
  
@@3:
  cmp [ EDX + 8 ], 0
  jz  @@4
  
  FLD  DWORD PTR [ EAX + 8 ]
  FDIV DWORD PTR [ EDX + 8 ]
  FSTP DWORD PTR [ ECX + 8 ]
  
@@4:
{$ENDIF}
end;

function vector_AddV;
{$IFNDEF USE_ASM}
begin
  Result.X := Vector.X + Value;
  Result.Y := Vector.Y + Value;
  Result.Z := Vector.Z + Value;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX     ]
  FADD DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX     ]

  FLD  DWORD PTR [ EAX + 4 ]
  FADD DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX + 4 ]

  FLD  DWORD PTR [ EAX + 8 ]
  FADD DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX + 8 ]
{$ENDIF}
end;

function vector_SubV;
{$IFNDEF USE_ASM}
begin
  Result.X := Vector.X - Value;
  Result.Y := Vector.Y - Value;
  Result.Z := Vector.Z - Value;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX     ]
  FSUB DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX     ]

  FLD  DWORD PTR [ EAX + 4 ]
  FSUB DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX + 4 ]

  FLD  DWORD PTR [ EAX + 8 ]
  FSUB DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX + 8 ]
{$ENDIF}
end;

function vector_MulV;
{$IFNDEF USE_ASM}
begin
  Result.X := Vector.X * Value;
  Result.Y := Vector.Y * Value;
  Result.Z := Vector.Z * Value;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX     ]
  FMUL DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX     ]

  FLD  DWORD PTR [ EAX + 4 ]
  FMUL DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX + 4 ]

  FLD  DWORD PTR [ EAX + 8 ]
  FMUL DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX + 8 ]
{$ENDIF}
end;

function vector_DivV;
{$IFNDEF USE_ASM}
begin
  Value := 1 / Value;
  Result.X := Vector.X * Value;
  Result.Y := Vector.Y * Value;
  Result.Z := Vector.Z * Value;
{$ELSE}
asm
  mov [ EDX     ], 0
  mov [ EDX + 4 ], 0
  mov [ EDX + 8 ], 0

  cmp [ EBP + 8 ], 0
  jz  @@1

  FLD  DWORD PTR [ EAX     ]
  FDIV DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX     ]

  FLD  DWORD PTR [ EAX + 4 ]
  FDIV DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX + 4 ]

  FLD  DWORD PTR [ EAX + 8 ]
  FDIV DWORD PTR [ EBP + 8 ]
  FSTP DWORD PTR [ EDX + 8 ]

@@1:
{$ENDIF}
end;

function vector_MulM3f;
{$IFNDEF USE_ASM}
begin
  Result.X := Matrix[ 0 ].X * Vector.X + Matrix[ 1 ].X * Vector.Y + Matrix[ 2 ].X * Vector.Z;
  Result.Y := Matrix[ 0 ].Y * Vector.X + Matrix[ 1 ].Y * Vector.Y + Matrix[ 2 ].Y * Vector.Z;
  Result.Z := Matrix[ 0 ].Z * Vector.X + Matrix[ 1 ].Z * Vector.Y + Matrix[ 2 ].Z * Vector.Z;
{$ELSE}
asm
  // Result.X
  FLD  DWORD PTR [ EAX      ]
  FMUL DWORD PTR [ EDX      ]

  FLD  DWORD PTR [ EAX + 4  ]
  FMUL DWORD PTR [ EDX + 12 ]

  FADDP

  FLD  DWORD PTR [ EAX + 8  ]
  FMUL DWORD PTR [ EDX + 24 ]

  FADDP

  FSTP DWORD PTR [ ECX      ]

  // Result.Y
  FLD  DWORD PTR [ EAX      ]
  FMUL DWORD PTR [ EDX + 4  ]

  FLD  DWORD PTR [ EAX + 4  ]
  FMUL DWORD PTR [ EDX + 16 ]

  FADDP

  FLD  DWORD PTR [ EAX + 8 ]
  FMUL DWORD PTR [ EDX + 28 ]

  FADDP

  FSTP DWORD PTR [ ECX + 4  ]

  // Result.Z
  FLD  DWORD PTR [ EAX      ]
  FMUL DWORD PTR [ EDX + 8  ]

  FLD  DWORD PTR [ EAX + 4  ]
  FMUL DWORD PTR [ EDX + 20 ]

  FADDP

  FLD  DWORD PTR [ EAX + 8 ]
  FMUL DWORD PTR [ EDX + 32 ]

  FADDP

  FSTP DWORD PTR [ ECX + 8  ]
{$ENDIF}
end;

function vector_MulM4f;
{$IFNDEF USE_ASM}
begin
  Result.X := Matrix[ 0, 0 ] * Vector.X + Matrix[ 1, 0 ] * Vector.Y + Matrix[ 2, 0 ] * Vector.Z + Matrix[ 3, 0 ];
  Result.Y := Matrix[ 0, 1 ] * Vector.X + Matrix[ 1, 1 ] * Vector.Y + Matrix[ 2, 1 ] * Vector.Z + Matrix[ 3, 1 ];
  Result.Z := Matrix[ 0, 2 ] * Vector.X + Matrix[ 1, 2 ] * Vector.Y + Matrix[ 2, 2 ] * Vector.Z + Matrix[ 3, 2 ];
{$ELSE}
asm
  // Result.X
  FLD  DWORD PTR [ EAX      ]
  FMUL DWORD PTR [ EDX      ]

  FLD  DWORD PTR [ EAX + 4  ]
  FMUL DWORD PTR [ EDX + 16 ]

  FADDP

  FLD  DWORD PTR [ EAX + 8  ]
  FMUL DWORD PTR [ EDX + 32 ]
  FADD DWORD PTR [ EDX + 48 ]

  FADDP

  FSTP DWORD PTR [ ECX      ]

  // Result.Y
  FLD  DWORD PTR [ EAX      ]
  FMUL DWORD PTR [ EDX + 4  ]

  FLD  DWORD PTR [ EAX + 4  ]
  FMUL DWORD PTR [ EDX + 20 ]

  FADDP

  FLD  DWORD PTR [ EAX + 8 ]
  FMUL DWORD PTR [ EDX + 36 ]
  FADD DWORD PTR [ EDX + 52 ]

  FADDP

  FSTP DWORD PTR [ ECX + 4  ]

  // Result.Z
  FLD  DWORD PTR [ EAX      ]
  FMUL DWORD PTR [ EDX + 8  ]

  FLD  DWORD PTR [ EAX + 4  ]
  FMUL DWORD PTR [ EDX + 24 ]

  FADDP

  FLD  DWORD PTR [ EAX + 8 ]
  FMUL DWORD PTR [ EDX + 40 ]
  FADD DWORD PTR [ EDX + 56 ]

  FADDP

  FSTP DWORD PTR [ ECX + 8  ]
{$ENDIF}
end;

function vector_MulInvM4f;
{$IFNDEF USE_ASM}
begin
  Result.x := Matrix[ 0, 0 ] * Vector.X + Matrix[ 0, 1 ] * Vector.Y + Matrix[ 0, 2 ] * Vector.Z + Matrix[ 0, 3 ];
  Result.y := Matrix[ 1, 0 ] * Vector.X + Matrix[ 1, 1 ] * Vector.Y + Matrix[ 1, 2 ] * Vector.Z + Matrix[ 1, 3 ];
  Result.z := Matrix[ 2, 0 ] * Vector.X + Matrix[ 2, 1 ] * Vector.Y + Matrix[ 2, 2 ] * Vector.Z + Matrix[ 2, 3 ];
{$ELSE}
asm
  // Result.X
  FLD  DWORD PTR [ EAX      ]
  FMUL DWORD PTR [ EDX      ]

  FLD  DWORD PTR [ EAX + 4  ]
  FMUL DWORD PTR [ EDX + 4  ]

  FADDP

  FLD  DWORD PTR [ EAX + 8  ]
  FMUL DWORD PTR [ EDX + 8  ]
  FADD DWORD PTR [ EDX + 12 ]

  FADDP

  FSTP DWORD PTR [ ECX      ]

  // Result.Y
  FLD  DWORD PTR [ EAX      ]
  FMUL DWORD PTR [ EDX + 16 ]

  FLD  DWORD PTR [ EAX + 4  ]
  FMUL DWORD PTR [ EDX + 20 ]

  FADDP

  FLD  DWORD PTR [ EAX + 8  ]
  FMUL DWORD PTR [ EDX + 24 ]
  FADD DWORD PTR [ EDX + 28 ]

  FADDP

  FSTP DWORD PTR [ ECX + 4  ]

  // Result.Z
  FLD  DWORD PTR [ EAX      ]
  FMUL DWORD PTR [ EDX + 32 ]

  FLD  DWORD PTR [ EAX + 4  ]
  FMUL DWORD PTR [ EDX + 36 ]

  FADDP

  FLD  DWORD PTR [ EAX + 8  ]
  FMUL DWORD PTR [ EDX + 40 ]
  FADD DWORD PTR [ EDX + 44 ]

  FADDP

  FSTP DWORD PTR [ ECX + 8  ]
{$ENDIF}
end;

function vector_RotateX;
  var
    sina, cosa : Single;
begin
  m_SinCos( Value, sina, cosa );
  Result.X := Vector.X;
  Result.Y := ( Vector.Y * cosa ) + ( Vector.Z * ( -sina ) );
  Result.Z := ( Vector.Y * sina ) + ( Vector.Z * cosa );
end;

function vector_RotateY;
  var
    sina, cosa : Single;
begin
  m_SinCos( Value, sina, cosa );
  Result.X := ( Vector.X * cosa ) + ( Vector.Z * sina );
  Result.Y := Vector.Y;
  Result.Z := ( Vector.X * ( -sina ) ) + ( Vector.Z * cosa );
end;

function vector_RotateZ;
  var
    sina, cosa : Single;
begin
  m_SinCos( Value, sina, cosa );
  Result.X := ( Vector.X * cosa ) + ( Vector.Y * ( -sina ) );
  Result.Y := ( Vector.X * sina ) + ( Vector.Y * cosa );
  Result.Z := Vector.Z;
end;

function vector_RotateQ;
  var
    vn : zglTPoint3D;
    vecQuat, resQuat : zglTQuaternion;
begin
	vecQuat.x := Vector.x;
	vecQuat.y := Vector.y;
	vecQuat.z := Vector.z;
	vecQuat.w := 0;
 
	resQuat := quater_Mul( vecQuat, quater_Negate( Quaternion ) );
	resQuat := quater_Mul( Quaternion, resQuat );
 
	Result.X := resQuat.x;
  Result.Y := resQuat.y;
  Result.Z := resQuat.z;
end;


function vector_Negate;
{$IFNDEF USE_ASM}
begin
  Result.X := -Result.X;
  Result.Y := -Result.Y;
  Result.Z := -Result.Z
{$ELSE}
asm
  FLD  DWORD PTR [ EAX     ]
  FCHS
  FSTP DWORD PTR [ EDX     ]

  FLD  DWORD PTR [ EAX + 4 ]
  FCHS
  FSTP DWORD PTR [ EDX + 4 ]

  FLD  DWORD PTR [ EAX + 8 ]
  FCHS
  FSTP DWORD PTR [ EDX + 8 ]
{$ENDIF}
end;

function vector_Normalize;
  var
    len : Single;
begin
  len := sqrt( sqr( Vector.X ) + sqr( Vector.Y ) + sqr( Vector.Z ) );
  if len <> 0 Then
    len := 1 / len
  else
    begin
      Result := vector_Get( 0, 0, 0 );
      exit;
    end;
  Result.X := Vector.X * len;
  Result.Y := Vector.Y * len;
  Result.Z := Vector.Z * len;
end;

function vector_Angle;
begin
  Result := ArcCos( vector_Dot( vector_Normalize( Vector1 ), vector_Normalize( Vector2 ) ) );
end;

function vector_Cross;
{$IFNDEF USE_ASM}
begin
  Result.X := Vector1.Y * Vector2.Z - Vector1.Z * Vector2.Y;
  Result.Y := Vector1.Z * Vector2.X - Vector1.X * Vector2.Z;
  Result.Z := Vector1.X * Vector2.Y - Vector1.Y * Vector2.X;
{$ELSE}
asm
  // Result.X
  FLD  DWORD PTR [ EAX + 4 ]
  FMUL DWORD PTR [ EDX + 8 ]

  FLD  DWORD PTR [ EAX + 8 ]
  FMUL DWORD PTR [ EDX + 4 ]

  FSUBP

  FSTP DWORD PTR [ ECX     ]

  // Result.Y
  FLD  DWORD PTR [ EAX + 8 ]
  FMUL DWORD PTR [ EDX     ]

  FLD  DWORD PTR [ EAX     ]
  FMUL DWORD PTR [ EDX + 8 ]

  FSUBP

  FSTP DWORD PTR [ ECX + 4 ]

  // Result.Z
  FLD  DWORD PTR [ EAX     ]
  FMUL DWORD PTR [ EDX + 4 ]

  FLD  DWORD PTR [ EAX + 4 ]
  FMUL DWORD PTR [ EDX     ]

  FSUBP

  FSTP DWORD PTR [ ECX + 8 ]
{$ENDIF}
end;

function vector_Dot;
{$IFNDEF USE_ASM}
begin
  Result := Vector1.X * Vector2.X + Vector1.Y * Vector2.Y + Vector1.Z * Vector2.Z;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX     ] // Vector1.X
  FMUL DWORD PTR [ EDX     ] // Vector1.X * Vector2.X
  
  FLD  DWORD PTR [ EAX + 4 ] // Vector1.Y
  FMUL DWORD PTR [ EDX + 4 ] // Vector1.X * Vector2.X
  
  FADDP                      // Result := Vector1.X * Vector2.X + Vector1.X * Vector2.X
  
  FLD  DWORD PTR [ EAX + 8 ] // Vector1.Z
  FMUL DWORD PTR [ EDX + 8 ] // Vector1.Z * Vector2.Z
  
  FADDP                      // Result := Result + Vector1.Z * Vector2.Z
{$ENDIF}
end;

function vector_Distance;
{$IFNDEF USE_ASM}
begin
  Result := sqrt( sqr( Vector2.X - Vector1.X ) +
                  sqr( Vector2.Y - Vector1.Y ) +
                  sqr( Vector2.Z - Vector1.Z ) );
{$ELSE}
asm
  FLD  DWORD PTR [ EDX     ] // Vector1.X
  FSUB DWORD PTR [ EAX     ] // Vector2.X - Vector1.X
  FMUL ST, ST                // sqr( Vector2.X - Vector1.X )
  
  FLD  DWORD PTR [ EDX + 4 ] // Vector2.Y
  FSUB DWORD PTR [ EAX + 4 ] // Vector2.Y - Vector1.Y
  FMUL ST, ST                // sqr( Vector2.Y - Vector1.Y )
  
  FADDP                      // Result := sqr( Vector2.X - Vector1.X ) + sqr( Vector2.Y - Vector1.Y )
  
  FLD  DWORD PTR [ EDX + 8 ] // Vector2.Z
  FSUB DWORD PTR [ EAX + 8 ] // Vector2.Z - Vector1.Z
  FMUL ST, ST                // sqr( Vector2.Z - Vector1.Z )
  
  FADDP                      // Result := Result + sqr( Vector2.Z - Vector1.Z )
  
  FSQRT                      // Result := sqrt( Result )
{$ENDIF}
end;

function vector_FDistance;
{$IFNDEF USE_ASM}
begin
  Result := sqr( Vector2.X - Vector1.X ) +
            sqr( Vector2.Y - Vector1.Y ) +
            sqr( Vector2.Z - Vector1.Z );
{$ELSE}
asm
  FLD  DWORD PTR [ EDX     ] // Vector1.X
  FSUB DWORD PTR [ EAX     ] // Vector2.X - Vector1.X
  FMUL ST, ST                // sqr( Vector2.X - Vector1.X )

  FLD  DWORD PTR [ EDX + 4 ] // Vector2.Y
  FSUB DWORD PTR [ EAX + 4 ] // Vector2.Y - Vector1.Y
  FMUL ST, ST                // sqr( Vector2.Y - Vector1.Y )

  FADDP                      // Result := sqr( Vector2.X - Vector1.X ) + sqr( Vector2.Y - Vector1.Y )

  FLD  DWORD PTR [ EDX + 8 ] // Vector2.Z
  FSUB DWORD PTR [ EAX + 8 ] // Vector2.Z - Vector1.Z
  FMUL ST, ST                // sqr( Vector2.Z - Vector1.Z )

  FADDP                      // Result := Result + sqr( Vector2.Z - Vector1.Z )
{$ENDIF}
end;

function vector_Length;
{$IFNDEF USE_ASM}
begin
  Result := sqrt( sqr( Vector.X ) + sqr( Vector.Y ) + sqr( Vector.Z ) );
{$ELSE}
asm
  FLD  DWORD PTR [ EAX     ] // Vector.X
  FMUL ST, ST                // sqr( Vector.X )

  FLD  DWORD PTR [ EAX + 4 ] // Vector.Y
  FMUL ST, ST                // sqr( Vector.Y )

  FADDP                      // Result := sqr( Vector.X ) + sqr( Vector.Y )

  FLD  DWORD PTR [ EAX + 8 ] // Vector.Z
  FMUL ST, ST                // sqr( Vector.Z )

  FADDP                      // Result := Result + sqr( Vector.Z )

  FSQRT                      // Result := sqrt( Result )
{$ENDIF}
end;

function vector_Lerp;
{$IFNDEF USE_ASM}
begin
  Result.X := Vector1.X + ( Vector2.X - Vector1.X ) * Value;
  Result.Y := Vector1.Y + ( Vector2.Y - Vector1.Y ) * Value;
  Result.Z := Vector1.Z + ( Vector2.Z - Vector1.Z ) * Value;
{$ELSE}
asm
   FLD   Value

   FLD   DWORD PTR [ EAX + 0 ]
   FLD   DWORD PTR [ EDX + 0 ]
   FSUB  ST( 0 ), ST( 1 )
   FMUL  ST( 0 ), ST( 2 )
   FADDP
   FSTP  DWORD PTR [ ECX + 0 ]

   FLD   DWORD PTR [ EAX + 4 ]
   FLD   DWORD PTR [ EDX + 4 ]
   FSUB  ST( 0 ), ST( 1 )
   FMUL  ST( 0 ), ST( 2 )
   FADDP
   FSTP  DWORD PTR [ ECX + 4 ]

   FLD   DWORD PTR [ EAX + 8 ]
   FLD   DWORD PTR [ EDX + 8 ]
   FSUB  ST( 0 ), ST( 1 )
   FMUL  ST( 0 ), ST( 2 )
   FADDP
   FSTP  DWORD PTR [ ECX + 8 ]

   FFREE ST( 0 )
{$ENDIF}
end;

{------------------------------------------------------------------------------}
{--------------------------------- Matrix3f -----------------------------------}
{------------------------------------------------------------------------------}
function matrix3f_Get;
begin
  Result[ 0 ] := v1;
  Result[ 1 ] := v2;
  Result[ 2 ] := v3;
end;

procedure matrix3f_OrthoNormalize;
begin
  Matrix[ 0 ] := vector_Normalize( Matrix[ 0 ] );
  Matrix[ 2 ] := vector_Normalize( vector_Cross( Matrix[ 0 ], Matrix[ 1 ] ) );
  Matrix[ 1 ] := vector_Normalize( vector_Cross( Matrix[ 2 ], Matrix[ 0 ] ) );
end;

procedure matrix3f_Transpose;
begin
  Matrix[ 0 ] := vector_Get( Matrix[ 0 ].X, Matrix[ 1 ].X, Matrix[ 2 ].X );
  Matrix[ 1 ] := vector_Get( Matrix[ 0 ].Y, Matrix[ 1 ].Y, Matrix[ 2 ].Y );
  Matrix[ 2 ] := vector_Get( Matrix[ 0 ].Z, Matrix[ 1 ].Z, Matrix[ 2 ].Z );
end;

procedure matrix3f_Rotate;
  var
    tMatrix : zglTMatrix3f;
begin
  tMatrix[ 0 ] := vector_Get(   0, -aZ,  aY );
  tMatrix[ 1 ] := vector_Get(  aZ,   0, -aX );
  tMatrix[ 2 ] := vector_Get( -aY,  aX,   0 );
  tMatrix := matrix3f_Mul( tMatrix, Matrix^ );
  Matrix^ := matrix3f_Add( Matrix^, tMatrix );
  matrix3f_OrthoNormalize( Matrix );
end;

function matrix3f_Add;
begin
  Result[ 0 ] := vector_Add( Matrix1[ 0 ], Matrix2[ 0 ] );
  Result[ 1 ] := vector_Add( Matrix1[ 1 ], Matrix2[ 1 ] );
  Result[ 2 ] := vector_Add( Matrix1[ 2 ], Matrix2[ 2 ] );
end;

function matrix3f_Mul;
begin
  Result[ 0 ].X := Matrix1[ 0 ].X * Matrix2[ 0 ].X + Matrix1[ 0 ].Y * Matrix2[ 1 ].X + Matrix1[ 0 ].Z * Matrix2[ 2 ].X;
  Result[ 0 ].Y := Matrix1[ 0 ].X * Matrix2[ 0 ].Y + Matrix1[ 0 ].Y * Matrix2[ 1 ].Y + Matrix1[ 0 ].Z * Matrix2[ 2 ].Y;
  Result[ 0 ].Z := Matrix1[ 0 ].X * Matrix2[ 0 ].Z + Matrix1[ 0 ].Y * Matrix2[ 1 ].Z + Matrix1[ 0 ].Z * Matrix2[ 2 ].Z;
  Result[ 1 ].X := Matrix1[ 1 ].X * Matrix2[ 0 ].X + Matrix1[ 1 ].Y * Matrix2[ 1 ].X + Matrix1[ 1 ].Z * Matrix2[ 2 ].X;
  Result[ 1 ].Y := Matrix1[ 1 ].X * Matrix2[ 0 ].Y + Matrix1[ 1 ].Y * Matrix2[ 1 ].Y + Matrix1[ 1 ].Z * Matrix2[ 2 ].Y;
  Result[ 1 ].Z := Matrix1[ 1 ].X * Matrix2[ 0 ].Z + Matrix1[ 1 ].Y * Matrix2[ 1 ].Z + Matrix1[ 1 ].Z * Matrix2[ 2 ].Z;
  Result[ 2 ].X := Matrix1[ 2 ].X * Matrix2[ 0 ].X + Matrix1[ 2 ].Y * Matrix2[ 1 ].X + Matrix1[ 2 ].Z * Matrix2[ 2 ].X;
  Result[ 2 ].Y := Matrix1[ 2 ].X * Matrix2[ 0 ].Y + Matrix1[ 2 ].Y * Matrix2[ 1 ].Y + Matrix1[ 2 ].Z * Matrix2[ 2 ].Y;
  Result[ 2 ].Z := Matrix1[ 2 ].X * Matrix2[ 0 ].Z + Matrix1[ 2 ].Y * Matrix2[ 1 ].Z + Matrix1[ 2 ].Z * Matrix2[ 2 ].Z;
end;

procedure matrix4f_Transpose;
  var
    t : Single;
begin
  t              := Matrix[ 0, 1 ];
  Matrix[ 0, 1 ] := Matrix[ 1, 0 ];
  Matrix[ 1, 0 ] := t;

  t              := Matrix[ 0, 2 ];
  Matrix[ 0, 2 ] := Matrix[ 2, 0 ];
  Matrix[ 2, 0 ] := t;

  t              := Matrix[ 0, 3 ];
  Matrix[ 0, 3 ] := Matrix[ 3, 0 ];
  Matrix[ 3, 0 ] := t;

  t              := Matrix[ 1, 2 ];
  Matrix[ 1, 2 ] := Matrix[ 2, 1 ];
  Matrix[ 2, 1 ] := t;

  t              := Matrix[ 1, 3 ];
  Matrix[ 1, 3 ] := Matrix[ 3, 1 ];
  Matrix[ 3, 1 ] := t;

  t              := Matrix[ 2, 3 ];
  Matrix[ 2, 3 ] := Matrix[ 3, 2 ];
  Matrix[ 3, 2 ] := t;
end;

function matrix4f_Determinant; 
begin
  Result := Matrix[ 0, 0 ] * Matrix[ 1, 1 ] * Matrix[ 2, 2 ] +
            Matrix[ 1, 0 ] * Matrix[ 2, 1 ] * Matrix[ 0, 2 ] +
            Matrix[ 2, 0 ] * Matrix[ 0, 1 ] * Matrix[ 1, 2 ] -
            Matrix[ 2, 0 ] * Matrix[ 1, 1 ] * Matrix[ 0, 2 ] -
            Matrix[ 1, 0 ] * Matrix[ 0, 1 ] * Matrix[ 2, 2 ] -
            Matrix[ 0, 0 ] * Matrix[ 2, 1 ] * Matrix[ 1, 2 ];
end;

function matrix4f_Inverse;
  var
    det : Single;
begin
  det := 1 / matrix4f_Determinant( Matrix );
  Result[ 0, 0 ] :=  ( Matrix[ 1, 1 ] * Matrix[ 2, 2 ] - Matrix[ 2, 1 ] * Matrix[ 1, 2 ] ) * det;
  Result[ 0, 1 ] := -( Matrix[ 0, 1 ] * Matrix[ 2, 2 ] - Matrix[ 2, 1 ] * Matrix[ 0, 2 ] ) * det;
  Result[ 0, 2 ] :=  ( Matrix[ 0, 1 ] * Matrix[ 1, 2 ] - Matrix[ 1, 1 ] * Matrix[ 0, 2 ] ) * det;
  Result[ 0, 3 ] := 0;
  Result[ 1, 0 ] := -( Matrix[ 1, 0 ] * Matrix[ 2, 2 ] - Matrix[ 2, 0 ] * Matrix[ 1, 2 ] ) * det;
  Result[ 1, 1 ] :=  ( Matrix[ 0, 0 ] * Matrix[ 2, 2 ] - Matrix[ 2, 0 ] * Matrix[ 0, 2 ] ) * det;
  Result[ 1, 2 ] := -( Matrix[ 0, 0 ] * Matrix[ 1, 2 ] - Matrix[ 1, 0 ] * Matrix[ 0, 2 ] ) * det;
  Result[ 1, 3 ] := 0;
  Result[ 2, 0 ] :=  ( Matrix[ 1, 0 ] * Matrix[ 2, 1 ] - Matrix[ 2, 0 ] * Matrix[ 1, 1 ] ) * det;
  Result[ 2, 1 ] := -( Matrix[ 0, 0 ] * Matrix[ 2, 1 ] - Matrix[ 2, 0 ] * Matrix[ 0, 1 ] ) * det;
  Result[ 2, 2 ] :=  ( Matrix[ 0, 0 ] * Matrix[ 1, 1 ] - Matrix[ 1, 0 ] * Matrix[ 0, 1 ] ) * det;
  Result[ 2, 3 ] := 0;
  Result[ 3, 0 ] := -( Matrix[ 3, 0 ] * Result[ 0, 0 ] + Matrix[ 3, 1 ] * Result[ 1, 0 ] + Matrix[ 3, 2 ] * Result[ 2, 0 ] );
  Result[ 3, 1 ] := -( Matrix[ 3, 0 ] * Result[ 0, 1 ] + Matrix[ 3, 1 ] * Result[ 1, 1 ] + Matrix[ 3, 2 ] * Result[ 2, 1 ] );
  Result[ 3, 2 ] := -( Matrix[ 3, 0 ] * Result[ 0, 2 ] + Matrix[ 3, 1 ] * Result[ 1, 2 ] + Matrix[ 3, 2 ] * Result[ 2, 2 ] );
  Result[ 3, 3 ] := 1;
end;

procedure matrix4f_Translate;
begin
  Matrix[ 3 ][ 0 ] := tX;
  Matrix[ 3 ][ 1 ] := tY;
  Matrix[ 3 ][ 2 ] := tZ;
  Matrix[ 3 ][ 3 ] := 1;
end;

procedure matrix4f_Rotate;
  var
    A, B, C, D, E, F : Single;
begin
  m_SinCos( aX, A, D );
  m_SinCos( aY, B, E );
  m_SinCos( aZ, C, F );

  Matrix[ 0 ][ 0 ] := E * F;
  Matrix[ 0 ][ 1 ] := E * C;
  Matrix[ 0 ][ 2 ] := - B;
  Matrix[ 0 ][ 3 ] := 0;

  Matrix[ 1 ][ 0 ] := A * B * F - D * C;
  Matrix[ 1 ][ 1 ] := A * B * C + D * F;
  Matrix[ 1 ][ 2 ] := A * E;
  Matrix[ 1 ][ 3 ] := 0;

  Matrix[ 2 ][ 0 ] := D * B * F + A * C;
  Matrix[ 2 ][ 1 ] := D * B * C - A * F;
  Matrix[ 2 ][ 2 ] := D * E;
  Matrix[ 2 ][ 3 ] := 0;
end;

procedure matrix4f_Scale;
  var
    sMatrix : zglTMatrix4f;
begin
  sMatrix := matrix4f_Identity;
  sMatrix[ 0, 0 ] := sX;
  sMatrix[ 1, 1 ] := sY;
  sMatrix[ 2, 2 ] := sZ;
  Matrix^ := matrix4f_Mul( Matrix^, sMatrix );
end;

function matrix4f_Mul;
begin
  Result[0, 0] := Matrix1[0, 0] * Matrix2[0, 0] + Matrix1[0, 1] * Matrix2[1, 0] + Matrix1[0, 2] * Matrix2[2, 0] + Matrix1[0, 3] * Matrix2[3, 0];
  Result[1, 0] := Matrix1[1, 0] * Matrix2[0, 0] + Matrix1[1, 1] * Matrix2[1, 0] + Matrix1[1, 2] * Matrix2[2, 0] + Matrix1[1, 3] * Matrix2[3, 0];
  Result[2, 0] := Matrix1[2, 0] * Matrix2[0, 0] + Matrix1[2, 1] * Matrix2[1, 0] + Matrix1[2, 2] * Matrix2[2, 0] + Matrix1[2, 3] * Matrix2[3, 0];
  Result[3, 0] := Matrix1[3, 0] * Matrix2[0, 0] + Matrix1[3, 1] * Matrix2[1, 0] + Matrix1[3, 2] * Matrix2[2, 0] + Matrix1[3, 3] * Matrix2[3, 0];
  Result[0, 1] := Matrix1[0, 0] * Matrix2[0, 1] + Matrix1[0, 1] * Matrix2[1, 1] + Matrix1[0, 2] * Matrix2[2, 1] + Matrix1[0, 3] * Matrix2[3, 1];
  Result[1, 1] := Matrix1[1, 0] * Matrix2[0, 1] + Matrix1[1, 1] * Matrix2[1, 1] + Matrix1[1, 2] * Matrix2[2, 1] + Matrix1[1, 3] * Matrix2[3, 1];
  Result[2, 1] := Matrix1[2, 0] * Matrix2[0, 1] + Matrix1[2, 1] * Matrix2[1, 1] + Matrix1[2, 2] * Matrix2[2, 1] + Matrix1[2, 3] * Matrix2[3, 1];
  Result[3, 1] := Matrix1[3, 0] * Matrix2[0, 1] + Matrix1[3, 1] * Matrix2[1, 1] + Matrix1[3, 2] * Matrix2[2, 1] + Matrix1[3, 3] * Matrix2[3, 1];
  Result[0, 2] := Matrix1[0, 0] * Matrix2[0, 2] + Matrix1[0, 1] * Matrix2[1, 2] + Matrix1[0, 2] * Matrix2[2, 2] + Matrix1[0, 3] * Matrix2[3, 2];
  Result[1, 2] := Matrix1[1, 0] * Matrix2[0, 2] + Matrix1[1, 1] * Matrix2[1, 2] + Matrix1[1, 2] * Matrix2[2, 2] + Matrix1[1, 3] * Matrix2[3, 2];
  Result[2, 2] := Matrix1[2, 0] * Matrix2[0, 2] + Matrix1[2, 1] * Matrix2[1, 2] + Matrix1[2, 2] * Matrix2[2, 2] + Matrix1[2, 3] * Matrix2[3, 2];
  Result[3, 2] := Matrix1[3, 0] * Matrix2[0, 2] + Matrix1[3, 1] * Matrix2[1, 2] + Matrix1[3, 2] * Matrix2[2, 2] + Matrix1[3, 3] * Matrix2[3, 2];
  Result[0, 3] := Matrix1[0, 0] * Matrix2[0, 3] + Matrix1[0, 1] * Matrix2[1, 3] + Matrix1[0, 2] * Matrix2[2, 3] + Matrix1[0, 3] * Matrix2[3, 3];
  Result[1, 3] := Matrix1[1, 0] * Matrix2[0, 3] + Matrix1[1, 1] * Matrix2[1, 3] + Matrix1[1, 2] * Matrix2[2, 3] + Matrix1[1, 3] * Matrix2[3, 3];
  Result[2, 3] := Matrix1[2, 0] * Matrix2[0, 3] + Matrix1[2, 1] * Matrix2[1, 3] + Matrix1[2, 2] * Matrix2[2, 3] + Matrix1[2, 3] * Matrix2[3, 3];
  Result[3, 3] := Matrix1[3, 0] * Matrix2[0, 3] + Matrix1[3, 1] * Matrix2[1, 3] + Matrix1[3, 2] * Matrix2[2, 3] + Matrix1[3, 3] * Matrix2[3, 3];
end;

{------------------------------------------------------------------------------}
{-------------------------------- Quaternion ----------------------------------}
{------------------------------------------------------------------------------}
function quater_Get;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
  Result.W := W;
end;

function quater_Add;
{$IFNDEF USE_ASM}
begin
  Result.X := q1.X + q2.X;
  Result.Y := q1.Y + q2.Y;
  Result.Z := q1.Z + q2.Z;
  Result.W := q1.W + q2.W;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX      ]
  FADD DWORD PTR [ EDX      ]
  FSTP DWORD PTR [ ECX      ]

  FLD  DWORD PTR [ EAX + 4  ]
  FADD DWORD PTR [ EDX + 4  ]
  FSTP DWORD PTR [ ECX + 4  ]

  FLD  DWORD PTR [ EAX + 8  ]
  FADD DWORD PTR [ EDX + 8  ]
  FSTP DWORD PTR [ ECX + 8  ]

  FLD  DWORD PTR [ EAX + 12 ]
  FADD DWORD PTR [ EDX + 12 ]
  FSTP DWORD PTR [ ECX + 12 ]
{$ENDIF}
end;

function quater_Sub;
{$IFNDEF USE_ASM}
begin
  Result.X := q1.X - q2.X;
  Result.Y := q1.Y - q2.Y;
  Result.Z := q1.Z - q2.Z;
  Result.W := q1.W - q2.W;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX      ]
  FSUB DWORD PTR [ EDX      ]
  FSTP DWORD PTR [ ECX      ]

  FLD  DWORD PTR [ EAX + 4  ]
  FSUB DWORD PTR [ EDX + 4  ]
  FSTP DWORD PTR [ ECX + 4  ]

  FLD  DWORD PTR [ EAX + 8  ]
  FSUB DWORD PTR [ EDX + 8  ]
  FSTP DWORD PTR [ ECX + 8  ]

  FLD  DWORD PTR [ EAX + 12 ]
  FSUB DWORD PTR [ EDX + 12 ]
  FSTP DWORD PTR [ ECX + 12 ]
{$ENDIF}
end;

function quater_Mul;
begin
  Result.X := q1.W * q2.X + q1.X * q2.W + q1.Y * q2.Z - q1.Z * q2.Y;
  Result.Y := q1.W * q2.Y + q1.Y * q2.W + q1.Z * q2.X - q1.X * q2.Z;
  Result.Z := q1.W * q2.Z + q1.Z * q2.W + q1.X * q2.Y - q1.Y * q2.X;
  Result.W := q1.W * q2.W - q1.X * q2.X - q1.Y * q2.Y - q1.Z * q2.Z;
end;

function quater_Negate;
begin
  Result.X := -Quaternion.X;
  Result.Y := -Quaternion.Y;
  Result.Z := -Quaternion.Z;
  Result.W :=  Quaternion.W;
end;

function quater_Normalize;
  var
    t : Single;
begin
  t := ( sqr( Quaternion.X ) + sqr( Quaternion.Y ) + sqr( Quaternion.Z ) + sqr( Quaternion.W ) );
  if t <> 0 Then
    begin
      t        := 1 / t;
      Result.X := Quaternion.X * t;
      Result.Y := Quaternion.Y * t;
      Result.Z := Quaternion.Z * t;
      Result.W := Quaternion.W * t;
    end else
      Result := quater_Zero;
end;

function quater_Dot;
begin
  Result := q1.X * q2.X + q1.Y * q2.Y + q1.Z * q2.Z + q1.W * q2.W;
end;

function quater_Lerp;
  var
    p : zglTQuaternion;
    omega, cosom, scale0, scale1 : Single;
begin
  cosom := q1.X * q2.X + q1.Y * q2.Y + q1.Z * q2.Z + q1.W * q2.W;

  if cosom < 0 then
    begin 
      cosom := -cosom;
      p.X := -q2.X;
      p.Y := -q2.Y;
      p.Z := -q2.Z;
      p.W := -q2.W;
    end else
      begin
        p.X := q2.X;
        p.Y := q2.Y;
        p.Z := q2.Z;
        p.W := q2.W;
      end;

  scale0 := 1 - Value;
  scale1 := Value;

  Result.X := scale0 * q1.X + scale1 * p.X;
  Result.Y := scale0 * q1.Y + scale1 * p.Y;
  Result.Z := scale0 * q1.Z + scale1 * p.Z;
  Result.W := scale0 * q1.W + scale1 * p.W;
end;

function quater_FromRotation;
  var
    sr, sp, sy : Single;
    cr, cp, cy : Single;
    crcp, srsp : Single;
begin
  m_SinCos( Rotation.X * 0.5, sr, cr );
  m_SinCos( Rotation.Y * 0.5, sp, cp );
  m_SinCos( Rotation.Z * 0.5, sy, cy );
  crcp := cr * cp;
  srsp := sr * sp;

  Result.X := sr * cp * cy - cr * sp * sy;
  Result.Y := cr * sp * cy + sr * cp * sy;
  Result.Z := crcp * sy - srsp * cy;
  Result.W := crcp * cy + srsp * sy;
end;

function quater_GetM4f;
  var
    wx, wy, wz, xx, yy, yz, xy, xz, zz, x2, y2, z2 : Single;
begin
  with Quaternion do
    begin
      x2 := X * 2;
      y2 := Y * 2;
      z2 := Z * 2;

      xx := X * x2;
      xy := X * y2;
      xz := X * z2;

      yy := Y * y2;
      yz := Y * z2;
      zz := Z * z2;

      wx := W * x2;
      wy := W * y2;
      wz := W * z2;
    end;

  Result[ 0, 0 ] := 1 - ( yy + zz );
  Result[ 1, 0 ] := xy + wz;
  Result[ 2, 0 ] := xz - wy;
  Result[ 0, 1 ] := xy - wz;
  Result[ 1, 1 ] := 1 - ( xx + zz );
  Result[ 2, 1 ] := yz + wx;
  Result[ 0, 2 ] := xz + wy;
  Result[ 1, 2 ] := yz - wx;
  Result[ 2, 2 ] := 1 - ( xx + yy );
  Result[ 3, 0 ] := 0;
  Result[ 3, 1 ] := 0;
  Result[ 3, 2 ] := 0;
  Result[ 0, 3 ] := 0;
  Result[ 1, 3 ] := 0;
  Result[ 2, 3 ] := 0;
  Result[ 3, 3 ] := 1;
end;

{------------------------------------------------------------------------------}
{------------------------------------ Line ------------------------------------}
{------------------------------------------------------------------------------}

function line3d_ClosestPoint;
  var
    v1, v2 : zglTPoint3D;
    d, t   : Single;
begin
	v1 := vector_Sub( Point, A );
  v2 := vector_Normalize( vector_Sub( B, A ) );
  d  := vector_FDistance( A, B );
  t  := vector_Dot( v2, v1 );

  if  t <= 0 Then
    begin
      Result := A;
		  exit;
  	end;

  if sqr( t ) >= d Then
    begin
	  	Result := B;
		  exit;
  	end;

  Result := vector_Add( A, vector_MulV( v2, t ) );
end;

{------------------------------------------------------------------------------}
{----------------------------------- Plane ------------------------------------}
{------------------------------------------------------------------------------}
function plane_Get;
begin
  Result.Points[ 0 ] := A;
  Result.Points[ 1 ] := B;
  Result.Points[ 2 ] := C;
  Result.Normal      := tri_GetNormal( @A, @B, @C );
  Result.D           := -( Result.Normal.X * Result.Points[ 0 ].X + Result.Normal.Y * Result.Points[ 0 ].Y + Result.Normal.Z * Result.Points[ 0 ].Z );
end;

function plane_Distance;
{$IFNDEF USE_ASM}
begin
	Result := Plane.Normal.X * Point.X + Plane.Normal.Y * Point.Y + Plane.Normal.Z * Point.Z + Plane.D;
{$ELSE}
asm
  FLD  DWORD PTR [ EAX + 40 ]
  FMUL DWORD PTR [ EDX      ]

  FLD  DWORD PTR [ EAX + 44 ]
  FMUL DWORD PTR [ EDX + 4  ]

  FADDP

  FLD  DWORD PTR [ EAX + 48 ]
  FMUL DWORD PTR [ EDX + 8  ]
  FADD DWORD PTR [ EAX + 36 ]

  FADDP
{$ENDIF}
end;

function tri_GetNormal;
  var
    s1, s2, p : zglTPoint3D;
    uvector   : Single;
begin
  s1 := vector_Sub( A^, B^ );
  s2 := vector_Sub( B^, C^ );
  // вектор перпендикулярен центру треугольника
  p := vector_Cross( s1, s2 );
  // получаем унитарный вектор единичной длины
  uvector := sqrt( sqr( p.X ) + sqr( p.Y ) + sqr( p.Z ) );
  if uvector <> 0 Then
    Result := vector_DivV( p, uvector )
  else
    Result := vector_Get( 0, 0, 0 );
end;

initialization
  InitCosSinTables;

end.
