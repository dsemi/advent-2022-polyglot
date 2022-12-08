program sol;

uses generics.collections, fgl, math, sysutils;
Type
   TIntList  = specialize TFPGList<Int64>;
   TIntStack =  specialize TStack<Int64>;

function GetAllSizes(): TIntList;
Var
   line     : AnsiString;
   sizes    : TIntList;
   fstree   : TIntStack;
   size     : Int64;
   filesize : Int64;
begin
   sizes := TIntList.Create;
   fstree := TIntStack.Create;
   fstree.Push(0);
   while not Eof() do
   begin
      ReadLn(line);
      if line.StartsWith('$ cd ') then
         if line.EndsWith('/') then
            while fstree.Count > 1 do
            begin
               size := fstree.Pop;
               sizes.Add(size);
               fstree.Push(fstree.Pop+size);
            end
         else if line.EndsWith('..') then
            begin
               size := fstree.Pop;
               sizes.Add(size);
               fstree.Push(fstree.Pop+size);
            end
         else fstree.Push(0)
      else if line[1] in ['0'..'9'] then
         begin
            size := fstree.Pop;
            filesize := StrToInt(Copy(line, 1, line.IndexOf(' ')));
            fstree.Push(size+filesize);
         end;
   end;
   while fstree.Count > 1 do
   begin
      size := fstree.Pop;
      sizes.Add(size);
      fstree.Push(fstree.Pop+size);
   end;
   sizes.Add(fstree.Pop);
   GetAllSizes := sizes;
end;

Var
   size   : Int64;
   sizes  : TIntList;
   target : Int64;
   p1     : Int64;
   p2     : Int64;
begin
   WriteLn('Day 7: Pascal');
   sizes := GetAllSizes();
   target := sizes.last - 40000000;
   p2 := high(Int64);
   for size in sizes do
   begin
      if size <= 100000 then
         p1 += size;
      if size >= target then
         p2 := min(p2, size);
   end;
   WriteLn('Part 1: ', p1:20);
   WriteLn('Part 1: ', p2:20);
end.
