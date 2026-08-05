{
  ---------------------------------------------------------------------------
  Coords - unit
  ---------------------------------------------------------------------------

  Function

    Coordinate related structures and procedures.
}
unit Coords;



interface



uses
  Strs, Structs;



type



{
  ---------------------------------------------------------------------------
  TLongCoords - record
  ---------------------------------------------------------------------------

  Function

    A pair of coordinates.
}
  TLongCoords = record
    X, Y : LongInt;
  end;



{
  ---------------------------------------------------------------------------
  PLongCoords - pointer
  ---------------------------------------------------------------------------

  Function

    A pointer to a pair of coordinates to be used in data structures.
}
  PLongCoords = ^TLongCoords;



{
  ---------------------------------------------------------------------------
  DestroyLongCoords - procedure
  ---------------------------------------------------------------------------

  Function

    Frees the memory allocated for a PLongCoords.

  Parameters

    Data       A pointer to the data about to be de-allocated.

  Remarks

    This is a procedure which is passed to procedures and functions operating
    on a data strcture containing PLongCoords.

  See

    STRUCTS.PAS
}
procedure DestroyLongCoords(
  var Data : Pointer
);



{
  ---------------------------------------------------------------------------
  StrToPLongCoords - function
  ---------------------------------------------------------------------------

  Function

    Converts a string to a PLongCoords.

  Parameters

    Str        The string to convert.

  Remarks

    Str needs to have two numbers separated by a comma. The first number
    will be the X coordinate and the second the Y coordinate.
}
function StrToPLongCoords(
  Str : String
) : PLongCoords;




{
  ---------------------------------------------------------------------------
  ManhDistOrigin
  ---------------------------------------------------------------------------

  Function

    Calculates the manhattan distance between origin and coordinates.

  Parameters

    Coords     The coordinates.

  Returns

    The manhattan distance between origin and the given coordinates.
}
function ManhDistOrigin(
  Coords : PLongCoords
) : LongInt;



{
  ---------------------------------------------------------------------------
  ManhDistBetween
  ---------------------------------------------------------------------------

  Function

    Calculates the manhattan distance between two pairs of coordinates.

  Parameters

    One        The first pair of coordinates.

    Other      The second pair of coordinates.

  Returns

    The manhattan distance between the given pairs of coordinates.
}
function ManhDistBetween(
  One, Other : PLongCoords
) : LongInt;



implementation



procedure DestroyLongCoords(
  var Data : Pointer
);

begin
  Dispose(PLongCoords(Data));
  Data := nil;
end;



function StrToPLongCoords(
  Str : String
) : PLongCoords;

var
  Coords : PLongCoords;

begin
  New(Coords);
  with Coords^ do
  begin
    X := StrToInt(StrCutChr(Str, ','));
    Y := StrToInt(Str);
  end;
  StrToPLongCoords := Coords;
end;



function ManhDistOrigin(
  Coords : PLongCoords
) : LongInt;

begin
  ManhDistOrigin := Abs(Coords^.X) + Abs(Coords^.Y);
end;



function ManhDistBetween(
  One, Other : PLongCoords
) : LongInt;

begin
  ManhDistBetween := Abs(One^.X - Other^.X) + Abs(One^.Y - Other^.Y);
end;


end.

