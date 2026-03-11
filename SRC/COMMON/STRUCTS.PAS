{doc



  Data structures.



  Data structures are there to store data. In this implementation the data
  is inserted and retrieved as pointers and the user is responsible for
  casting the actual data to a a pointer and the retrieved pointer to
  usable data. Moreover, the user is the owner of the data, ie. they
  are responsible for allocating and freeing the memory needed for the data.

  This implementation uses a singly linked list as the base. A choice
  has to be made if one prefers lower memory usage or speed of execution,
  and in this case the the memory usage was considered the more important
  point.

  The overhead is as much as 8 bytes per stored item of data. Careful
  consideration should take place if there's a need to store items of
  small data such as integers, because a simple array might be more
  memory-efficient and faster at the same time! There are use cases for
  storing small items, too, the main one probably being data sets, whose
  size is not known beforehand.

  If the memory usage or speed of this implementation proves to be
  unsatisfactory, the user might be out of luck and they might have to
  roll their own implementation. These better solutions might be taken
  in as a part of this unit, if they are needed often enough.



  Procedures and functions to manipulate a linked list:



  AppendToLnkLst      Adds a node to the end of the linked list.
  CreateLnkLst        Creates (initializes) a linked list.
  DestroyLnkLst       Removes all nodes from the linked list.
  LnkLstIsEmpty       Checks if the linked list has any nodes.
  PopFromLnkLst       Retrieves and removes the first node of the list.
  PushToLnkLst        Adds a node to the start of the linked list.

  Queue-like behaviour can be achieved by using AppendToLnkLst and
  PopFromLnkLst.

  Stack-like behaviour can be achieved by using PushToLnkLst and
  PopFromLnkLst.



  Procedures and functions to iterate over a linked list:



  IterEndOfLst        Detects the end of the linked list.
  IterNext            Returns the next item of data from the list.
  IterReset           Moves the iterator to the start of the list.

  When the list is empty, ie. right after the list has been created or
  all the nodes have been removed in one way or another, the iterator
  points to the end of the list.

  When an item of data is added to an empty list, the iterator points
  to the one and only item of data.

  When an item is pushed to a list which contains data, and the iterator
  points to the first node, the iterator is not moved. Therefore it
  is not recommended to push data to a list while iterating over it.



  Procedure and function prototypes:



  The purpose of these is to give the routines in this unit a way
  to examine the actual data in order to do its tasks.

  There is also a destroyer prototype, which is only used when a
  data structure is destroyed. This kind of delegates the ownership
  of the data pointer to the data structure destroyer routine.

  DataPtrDestroyer    Frees up the memory allocated by the data.

}


unit Structs;

{$F+}


interface



uses
  Logging;



type


  TNodePtr = ^TNode;

  TNode = record
    Data : Pointer;
    Next : TNodePtr;
  end;

  TLnkLst = record
    Head,
    Tail,
    Iter : TNodePtr;
  end;

  DataPtrDestroyer = procedure(var Data : Pointer);




{doc
  ---------------------------------------------------------------------------
  CreateLnkLst - function                                             Structs
  ---------------------------------------------------------------------------

  Function

    Creates (initializes) a linked list.

  Parameters

    Lst        The linked list to be created.

  Remarks

    If the linked list is already in use, all the data it contains will be
    lost.
}
procedure CreateLnkLst(
  var Lst : TLnkLst
);


{doc
  ---------------------------------------------------------------------------
  DestroyLnkLst
  ---------------------------------------------------------------------------

  Function

    Removes all nodes from the linked list.

  Parameters

    Lst        The list to be emptied.

    Destroyer  A procedure to free the memory allocated by the data.

}
procedure DestroyLnkLst(
  var Lst : TLnkLst;
  Destroyer : DataPtrDestroyer
);



{doc
  ---------------------------------------------------------------------------
  LnkLstIsEmpty - function                                            Structs
  ---------------------------------------------------------------------------

  Function

    Checks if the linked list has any nodes.

  Parameters

    Lst        The linked list to check for.

}
function LnkLstIsEmpty(
  Lst : TLnkLst
) : Boolean;



{doc
  ---------------------------------------------------------------------------
  AppendToLnkLst - procedure                                          Structs
  ---------------------------------------------------------------------------

  Function

    Adds a node to the end of the linked list.

  Parameters

    Lst        The linked list to add to.

    Data       The data to be added.

}
procedure AppendToLnkLst(
  var Lst : TLnkLst;
  Data : Pointer
);



{doc
  ---------------------------------------------------------------------------
  PushToLnkLst - procedure                                            Structs
  ---------------------------------------------------------------------------

  Function

    Adds a node to the start of the linked list.

  Parameters

    Lst        The linked list to add to.

    Suffix     The data to be added

}
procedure PushToLnkLst(
  var Lst : TLnkLst;
  Data : Pointer
);


{doc
  ---------------------------------------------------------------------------
  PopFromLnkLst - function                                            Structs
  ---------------------------------------------------------------------------

  Function

    Retrieves the data from and removes the first node of the list.

  Parameters

    Lst        The linked list to pop from.

    Returns    The data that was inside the first node.

}
function PopFromLnkLst(
  var Lst : TLnkLst
) : Pointer;


{doc
  ---------------------------------------------------------------------------
  IterEndOfLst - function                                             Structs
  ---------------------------------------------------------------------------

  Function

    Detects if the iterator is at the end of the linked list.

  Parameters

    Lst        The linked list.

    Returns    True if the iterator is at the end of the list.

}
function IterEndOfLst(
  Lst : TLnkLst
) : Boolean;



{doc
  ---------------------------------------------------------------------------
  IterReset - procedure                                               Structs
  ---------------------------------------------------------------------------

  Function

    Moves the iterator to the start of the list.

  Parameters

    Lst        The linked list.

}
procedure IterReset(
  var Lst : TLnkLst
);


{
  ---------------------------------------------------------------------------
  IterNext - function                                                 Structs
  ---------------------------------------------------------------------------

  Function

    Returns the next item of data from the list.

  Parameters

    Lst        The linked list.

    Returns    The pointer to the next item of data on the list.

  Remarks

    Additional remarks.

}
function IterNext(
  var Lst : TLnkLst
) : Pointer;



implementation



procedure CreateLnkLst(
  var Lst : TLnkLst
);

begin
  Lst.Head := nil;
  Lst.Tail := nil;
  Lst.Iter := nil;
end;



procedure DestroyLnkLst(
  var Lst : TLnkLst;
  Destroyer : DataPtrDestroyer
);

var
  Ptr : Pointer;

begin
  while not LnkLstIsEmpty(Lst) do
  begin
    Ptr := PopFromLnkLst(Lst);
    Destroyer(Ptr);
  end;
end;


function LnkLstIsEmpty(
  Lst : TLnkLst
) : Boolean;

begin
  LnkLstIsEmpty := (Lst.Head = nil) and (Lst.Tail = nil);
end;



procedure AppendToLnkLst(
  var Lst : TLnkLst;
  Data : Pointer
);

var
  Node : TNodePtr;

begin
  New(Node);
  Node^.Data := Data;
  Node^.Next := nil;
  if LnkLstIsEmpty(Lst) then
  begin
    Lst.Head := Node;
    Lst.Tail := Node;
    Lst.Iter := Node;
  end
  else
  begin
    Lst.Tail^.Next := Node;
    Lst.Tail := Node;
  end;
end;



procedure PushToLnkLst(
  var Lst : TLnkLst;
  Data : Pointer
);

var
  Node : TNodePtr;

begin
  New(Node);
  Node^.Data := Data;
  if LnkLstIsEmpty(Lst) then
  begin
    Lst.Head := Node;
    Lst.Tail := Node;
    Lst.Iter := Node;
    Node^.Next := nil;
  end
  else
  begin
    Node^.Next := Lst.Head;
    Lst.Head := Node;
  end;
end;



function PopFromLnkLst(
  var Lst : TLnkLst
) : Pointer;

var
  Node : TNodePtr;

begin
  if not LnkLstIsEmpty(Lst) then
  begin
    Node := Lst.Head;
    Lst.Head := Lst.Head^.Next;
    if Lst.Head = nil then
      Lst.Tail := nil;
    PopFromLnkLst := Node^.Data;
    Dispose(Node);
  end
  else
  begin
    PopFromLnkLst := nil;
    Log(logWarn, 'Tried to pop from an empty linked list.');
  end;
end;



function IterEndOfLst(
  Lst : TLnkLst
) : Boolean;

begin
  IterEndOfLst := Lst.Iter = nil;
end;



procedure IterReset(
  var Lst : TLnkLst
);

begin
  Lst.Iter := Lst.Head;
end;



function IterNext(
  var Lst : TLnkLst
) : Pointer;

begin
  if not IterEndOfLst(Lst) then
  begin
    IterNext := Lst.Iter^.Data;
    Lst.Iter := Lst.Iter^.Next;
  end
  else
  begin
    IterNext := nil;
    Log(logWarn, 'Tried to iterate forward while at the end of the list.');
  end;
end;


end.