program lab6_mb_lu4we;

{$APPTYPE CONSOLE}
uses
  SysUtils, Windows;
const
  y=50;
  x=50;
  MaxY=50;
  MaxX=50;
  MaxRobots=3;
  MaxSpeed1 = 1;
  MaxSpeed2 = 2;
type
  TRobotsCoords = array[1..3, 1..MaxRobots] of integer;
  //TDictanceMatrix = array[1..MaxRobots, 1..MaxRobots] of real;
  TPointMatrix = array [1..x, 1..(y*MaxRobots)] of string;
  TError = string;
  // DELETE BEGIN
  // TTempPointMatrix = array[1..x,1..y] of string;
  // DELETE END
var ix,jy: byte;
  NRob: byte;
  RobotsInfo: TRobotsCoords;
  //DictanceMatrix: TDictanceMatrix;
  i,j,kn, finalTime:Byte;
  err:TError;
  PointMatrix: TPointMatrix;

procedure clrscr;
var
  cursor: COORD;
  r: cardinal;
begin
  r := 300;
  cursor.X := 0;
  cursor.Y := 0;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r, cursor, r);
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
end;

Function IntToStr(I : Longint) : String;
Var S : String;
Begin
 Str(I, S);
 IntToStr:=S;
End;

procedure push(var arr:TPointMatrix; beginel: Integer; elem: string; line: integer);
var i:integer;
var isEnd: Boolean;
begin
  i:=beginel;
  isEnd:=false;
  while ( (i < beginel+MaxX) and (not isEnd) ) do
  begin
    if (arr[line, i] = '') then
    begin
      arr[line, i] := elem;
      isEnd := true;
    end;
    Inc(i);
  end;
end;

procedure searchRelatedPoint(robot,speed, x, y, step: integer);
var rob, time,cf: integer;
currel: string;
//var PointMatrix: TTempPointMatrix;
begin
  cf:= 1 + (robot-1)*MaxX;
  rob:=robot;
  Case speed of
    1 : time:=2;
    2 : time:=1;
  end;
  if (step < 10) then
  begin
    if ((x-1) > 0) then
    begin
      currel := IntToStr(x-1) + IntToStr(y);
      push(PointMatrix,cf,currel,step);
      searchRelatedPoint(rob,speed, x-1,y, step+time);
    end;
    if ((x+1) < ix) then
    begin
      currel := IntToStr(x+1) + IntToStr(y);
      push(PointMatrix,cf,currel,step);
      searchRelatedPoint(rob,speed, x+1,y, step+time);
    end;
    if ((y-1) > 0) then
    begin
      currel := IntToStr(x) + IntToStr(y-1);
      push(PointMatrix,cf,currel,step);
      searchRelatedPoint(rob,speed, x,y-1, step+time);
    end;
    if ((y+1) < jy) then
    begin
      currel := IntToStr(x) + IntToStr(y+1);
      push(PointMatrix,cf,currel,step);
      searchRelatedPoint(rob,speed, x,y+1, step+time);
    end;
  end;
end;

function searchSameElements(var arr:TPointMatrix; el: string; line:Integer):integer;
var j,time, count: Integer;
brk:boolean;
begin
  brk:=false;
  count:=0;
  if (el <> '') then
  begin
    j:=1;
    while((j<MaxY*MaxRobots) and (not brk)) do
    begin
      if (arr[line,j] = el) then
      begin
        Inc(count);
        j:= count*MaxY+1{(j mod MaxY) + MaxY};
      end;
      inc(j);
    end;
  end;

  searchSameElements := count;
end;

function getTime(var arr: TPointMatrix; robots: integer): Integer;
var i,j,rep,time: Integer;
brk:boolean;
begin
  brk:=false;
  i:=1;
  while((i<=MaxX) and (not brk)) do
  //for i :=1 to MaxX do
  begin
    j:=1;
    while((j<MaxY{*MaxRobots}) and (not brk)) do
    begin
      //for j :=1 to MaxY*MaxRobots do
      if(arr[i,j] <> '') then
      begin
        rep:=searchSameElements(PointMatrix, arr[i,j],i);
        if (rep = robots) then
        begin
          brk:=true;
          time:=i;
          {Writeln(j,' ',i);
          Writeln(arr[i,j]);}
        end;
      end;
      inc(j);
    end;
    inc(i);
  end;
  if (rep <> robots) then
    time:= 0;
  getTime:= time;
end;

begin
  //ix:=10;
  //jy:=10;

  {searchRelatedPoint(2,2,3,3,1,1);
  searchRelatedPoint(3,1,5,5,1,1);  }
  // Writeln(PointMatrix[1,44] <> '');
  //PointMatrix[1,51] := '1';
  //writeln(PointMatrix[1,51]);
  {for i :=1 to 22 do
  begin
    for j :=1 to 50 do
        write ( PointMatrix[i,j], ' ');
   writeln ;
  end;
  Writeln;
  for i :=1 to 22 do
  begin
    for j :=51 to 100 do
        write ( PointMatrix[i,j], ' ');
   writeln ;
  end;
  Writeln;
  for i :=1 to 22 do
  begin
    for j :=101 to 150 do
        write ( PointMatrix[i,j], ' ');
   writeln ;
  end;    }
  //Writeln(getTime(PointMatrix,3)*2);

 { ix:= 5;
  jy:=5;
  NRob:= 2;
  RobotsInfo[1,1] := 1;
  RobotsInfo[2,1] := 1;
  RobotsInfo[3,1] := 1;
  RobotsInfo[1,2] := 2;
  RobotsInfo[2,2] := 2;
  RobotsInfo[3,2] := 1;
  }
  repeat
    Writeln('Enter the number of points in width (max: 50)');
    Readln(ix);
    if (ix > 50) then
      Writeln('The maximum value is 50. Please enter again');
  until(ix <= 50);
  repeat
    Writeln('Enter the number of points in height (max: ',50 div ix,')');
    Readln(jy);
    if (ix > 50 div ix) then
      Writeln('The maximum value is ',50 div ix,'. Please enter again');
  until(jy <= (50 div ix));
  repeat
    writeln('Enter the number of robots');
    readln(NRob);
    if (NRob > MaxRobots) then
      Writeln('Max. number of robots: ', MaxRobots);
  until (NRob <= MaxRobots);
  for i:=1 to NRob do
  begin
    repeat
      err := '';
      Write('Enter the initial X coordinate of the robot number ', i, ': ');
      Readln(RobotsInfo[1,i]);
      if(RobotsInfo[1,i] > ix) then
        err:= err + #10 + '- You are outside the X coordinate';
      Write('Enter the initial Y coordinate of the robot number ', i, ': ');
      Readln(RobotsInfo[2,i]);
      if(RobotsInfo[2,i] > jy) then
        err:= err + #10 + '- You are outside the Y coordinate';
      Write('Enter robot speed number ', i, '(speed = ',MaxSpeed1,' or ',MaxSpeed2,')', ': ');
      Readln(RobotsInfo[3,i]);
      if((RobotsInfo[3,i] > 2) or (RobotsInfo[3,i] < 1)) then
        err:= err + #10 + '- The speed can take two values: 1 or 2';
      if (err <> '') then
        writeln(#10,'=======================================',
                #10,'Errors: ', err,#10,
                'Please enter data for this robot again',
                #10,'=======================================');

    until((RobotsInfo[1,i] <= ix)
          and
         (RobotsInfo[2,i] <= jy)
          and
         ((RobotsInfo[3,i] = MaxSpeed1) or (RobotsInfo[3,i] = MaxSpeed2)));
  end;
  clrscr;
  Writeln('The city contains points [',ix,',',jy,']');
  Writeln(NRob, ' robots drive around the city');
  Writeln('+-------+---------+---------+---------+');
  Writeln('| Robot | Initial | Initial |  Robot  |');
  Writeln('| Num.  | coord X | coord Y |  speed  |');
  Writeln('+-------+---------+---------+---------+');
  for i:=1 to NRob do
  begin
    writeln('|', i:7, '|', RobotsInfo[1,i]:9, '|', RobotsInfo[2,i]:9, '|', RobotsInfo[3,i]:9, '|');
    Writeln('+-------+---------+---------+---------+');
  end;

  for kn:=1 to NRob do
  begin
    searchRelatedPoint(kn,RobotsInfo[3,kn],RobotsInfo[1,kn],RobotsInfo[2,kn],1);
  end;
  {
  for i :=1 to 22 do
  begin
    for j :=1 to 50 do
        write ( PointMatrix[i,j], ' ');
   writeln ;
  end;
  Writeln;
  for i :=1 to 22 do
  begin
    for j :=51 to 100 do
        write ( PointMatrix[i,j], ' ');
   writeln ;
  end;
  Writeln;
  for i :=1 to 22 do
  begin
    for j :=101 to 150 do
        write ( PointMatrix[i,j], ' ');
   writeln ;
  end;
  }
  finalTime := getTime(PointMatrix,NRob)*5;
  if  (finalTime = 0) then
    Writeln('Robots will never meet :c')
  else
    Writeln('Robots met through ',(finalTime/10):0:1, 'T');

  Readln;

end.
