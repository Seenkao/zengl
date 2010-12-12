program demo01;

// RU: Приложение можно собрать с ZenGL либо статично, либо используя so/dll/dylib.
// Для этого закомментируйте объявление ниже. Преимущество статичной компиляции
// заключается в меньшем размере, но требует подключение каждого модуля вручную.
// Также статическая компиляция обязывает исполнять условия LGPL-лицензии,
// в частности требуется открытие исходных кодов приложения, которое использует
// исходные коды ZenGL. Использование же только so/dll/dylib этого не требует.
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
  // RU: Перед использованием модулей, не забудьте указать путь к исходным кодам ZenGL :)
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
  // RU: Тут можно выполнять загрузку основных ресурсов.
  // EN: Here can be loading of main resources.
end;

procedure Draw;
begin
  // RU: Тут "рисуем" что угодно :)
  // EN: Here "draw" anything :)
end;

procedure Update( dt : Double );
begin
  // RU: Эта функция наземенима для реализация плавного движения чего-либо, т.к. таймеры зачастую ограничены FPS.
  // EN: This function is the best way to implement smooth moving of something, because timers are restricted by FPS.
end;

procedure Timer;
begin
  // RU: Будем в заголовке показывать количество кадров в секунду.
  // EN: Caption will show the frames per second.
  wnd_SetCaption( '01 - Initialization[ FPS: ' + u_IntToStr( zgl_Get( SYS_FPS ) ) + ' ]' );
end;

procedure Quit;
begin
 //
end;

Begin
  {$IFNDEF STATIC}
    {$IFDEF LINUX}
    // RU: В Linux все библиотеки принято хранить в /usr/lib, поэтому libZenGL.so должна
    // быть предварительно установлена. Если же нужно грузить библиотеку из
    // каталога с исполняемым файлом, то следует вписать './libZenGL.so'
    //
    // EN: Under GNU/Linux all libraries placed in /usr/lib, so libZenGL.so must be
    // installed before it will be used. If you want to load library from directory with
    // executable file you can write below './libZenGL.so' instead of libZenGL
    zglLoad( libZenGL );
    {$ENDIF}
    {$IFDEF WIN32}
    zglLoad( libZenGL );
    {$ENDIF}
    {$IFDEF DARWIN}
    // RU: libZenGL.dylib следует предварительно поместить в каталог
    // MyApp.app/Contents/Frameworks/, где MyApp.app - Bundle вашего приложения.
    // Также следует упомянуть, что лог-файл будет создаваться в корневом каталоге,
    // поэтому либо отключайте его, либо указывайте свой путь и имя, как описано в справке.
    //
    // EN: libZenGL.dylib must be placed into this directory
    // MyApp.app/Contents/Frameworks/, where MyApp.app - Bundle of your application.
    // Also you must know, that log-file will be created in root directory, so you must
    // disable a log, or choose your own path and name for it. How to do this you can find
    // in help.
    zglLoad( libZenGL );
    {$ENDIF}
  {$ENDIF}

  // RU: Для загрузки/создания каких-то своих настроек/профилей/etc. можно получить путь к
  // домашенему каталогу пользователя, или к исполняемому файлу(не работает для GNU/Linux).
  //
  // EN: For loading/creating your own options/profiles/etc. you can get path to user home
  // directory, or to executable file(not works for GNU/Linux).
  DirApp  := PChar( zgl_Get( APP_DIRECTORY ) );
  DirHome := PChar( zgl_Get( USR_HOMEDIR ) );

  // RU: Создаем таймер с интервалом 1000мс.
  // EN: Create a timer with interval 1000ms.
  timer_Add( @Timer, 1000 );

  // RU: Регистрируем процедуру, что выполнится сразу после инициализации ZenGL.
  // EN: Register the procedure, that will be executed after ZenGL initialization.
  zgl_Reg( SYS_LOAD, @Init );
  // RU: Регистрируем процедуру, где будет происходить рендер.
  // EN: Register the render procedure.
  zgl_Reg( SYS_DRAW, @Draw );
  // RU: Регистрируем процедуру, которая будет принимать разницу времени между кадрами.
  // EN: Register the procedure, that will get delta time between the frames.
  zgl_Reg( SYS_UPDATE, @Update );
  // RU: Регистрируем процедуру, которая выполнится после завершения работы ZenGL.
  // EN: Register the procedure, that will be executed after ZenGL shutdown.
  zgl_Reg( SYS_EXIT, @Quit );

  // RU: Т.к. модуль сохранен в кодировке UTF-8 и в нем используются строковые переменные
  // следует указать использование этой кодировки.
  // EN: Enable using of UTF-8, because this unit saved in UTF-8 encoding and here used
  // string variables.
  zgl_Enable( APP_USE_UTF8 );

  // RU: Устанавливаем заголовок окна.
  // EN: Set the caption of the window.
  wnd_SetCaption( '01 - Initialization' );

  // RU: Разрешаем курсор мыши.
  // EN: Allow to show the mouse cursor.
  wnd_ShowCursor( TRUE );

  // RU: Указываем первоначальные настройки.
  // EN: Set screen options.
  scr_SetOptions( 800, 600, REFRESH_MAXIMUM, FALSE, FALSE );

  // RU: Инициализируем ZenGL.
  // EN: Initialize ZenGL.
  zgl_Init();
End.
