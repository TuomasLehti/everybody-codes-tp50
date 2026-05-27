program Test;

uses
  Testing, StrsT, Md5T, StructsT, MetadatT;

begin
  Writeln('Hello, world');
  RunAllTests;
  UnregisterAllTests;
end.