{
  Geometrics.
}



{$F+}



unit Geom;



interface



type


{
  A point represents an integer coordinate pair in two dimensions.
  The coordinates are signed 16 bit (Integers).
}

  TPoint16 = record
    X, Y : Integer;
  end;



  TRect16 = record
    SW, NE: TPoint16;
  end;



  PRect16 = ^TRect16;




procedure DestroyRect16(
  var Data : Pointer
);



implementation



procedure DestroyRect16(
  var Data : Pointer
);

var
  Rect : PRect16 absolute Data;

begin
  Dispose(Rect);
end;




end.