program Test;

uses
  Testing, StrsT, Md5T, StructsT;

begin
  Writeln('Hello, world');
  RunAllTests;
  UnregisterAllTests;
end.